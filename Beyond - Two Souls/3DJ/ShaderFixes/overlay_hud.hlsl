// Edit this line to change the font colour:
static const float3 colour = float3(0.25, 1, 0.25);

//Edit this line to scale the font:
static const float font_scale = 1.4;

static float2 cur_pos;
static float4 resolution;
static float2 char_size;
static int2 meta_pos_start;

Texture2D<float> font : register(t100);
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


//Define [Constants]
#define depth1 IniParams[0].x
#define enable_depth1 IniParams[5].x

#define onoff1 IniParams[0].z
#define enable_onoff1 IniParams[5].z

#define current_time IniParams[3].x
#define activation_time IniParams[3].y

#define overlay_hud_timeout IniParams[4].x


struct vs2gs {
	uint idx : TEXCOORD0;
};

struct gs2ps {
	float4 pos : SV_Position0;
	float2 tex : TEXCOORD1;
	uint character : TEXCOORD2;
};

#ifdef VERTEX_SHADER
void main(uint id : SV_VertexID, out vs2gs output)
{
	output.idx = id;
}
#endif


#ifdef GEOMETRY_SHADER
void get_meta()
{
	float font_width, font_height;

	resolution = StereoParams.Load(int3(2, 0, 0));

	font.GetDimensions(font_width, font_height);
	char_size = float2(font_width, font_height) / float2(16, 6);

	meta_pos_start = float2(15 * char_size.x, 5 * char_size.y);
}

float2 get_char_dimensions(uint c)
{
	float2 meta_pos;
	float2 dim;

	meta_pos.x = meta_pos_start.x + (c % 16);
	meta_pos.y = meta_pos_start.y + (c / 16 - 2) * 2;

	dim.x = font.Load(int3(meta_pos, 0)) * 255;
	meta_pos.y++;
	dim.y = font.Load(int3(meta_pos, 0)) * 255;

	return dim;
}

void emit_char(uint c, inout TriangleStream<gs2ps> ostream)
{
	float2 cdim = get_char_dimensions(c);

	if (c >= ' ' && c < 0x7f) {
		gs2ps output;
		float2 dim = float2(cdim.x, char_size.y) / resolution.xy * 2 * font_scale;
		float texture_x_percent = cdim.x / char_size.x;

		output.character = c;

		output.pos = float4(cur_pos.x        , cur_pos.y - dim.y, 0, 1);
		output.tex = float2(0, 1);
		ostream.Append(output);
		output.pos = float4(cur_pos.x + dim.x, cur_pos.y - dim.y, 0, 1);
		output.tex = float2(texture_x_percent, 1);
		ostream.Append(output);
		output.pos = float4(cur_pos.x        , cur_pos.y        , 0, 1);
		output.tex = float2(0, 0);
		ostream.Append(output);
		output.pos = float4(cur_pos.x + dim.x, cur_pos.y        , 0, 1);
		output.tex = float2(texture_x_percent, 0);
		ostream.Append(output);

		ostream.RestartStrip();
	}

	// Increment current position taking specific character width into account:
	cur_pos.x += cdim.x / resolution.x * 2 * font_scale;
}

void emit_int(int val, inout TriangleStream<gs2ps> ostream)
{
	int digit;

	if (val < 0.0) {
		emit_char('-', ostream);
		val *= -1;
	}

	int e = 0;
	if (val == 0) {
		emit_char('0', ostream);
		return;
	}
	e = log10(val);
	while (e >= 0) {
		digit = uint(val / pow(10, e)) % 10;
		emit_char(digit + 0x30, ostream);
		e--;
	}
}

// isnan() is optimised out by the compiler, which produces a warning that we
// need the /Gis (IEEE Strictness) option to enable it... but that doesn't work
// either... neither does disabling optimisations... Uhh, good job Microsoft?
// Whatever, just implement it ourselves by testing for an exponent of all 1s
// and a non-zero mantissa:
bool workaround_broken_isnan(float x)
{
	return (((asuint(x) & 0x7f800000) == 0x7f800000) && ((asuint(x) & 0x007fffff) != 0));
}

void emit_float(float val, inout TriangleStream<gs2ps> ostream)
{
	int digit;
	int significant = 0;
	int scientific = 0;

	if (workaround_broken_isnan(val)) {
		emit_char('N', ostream);
		emit_char('a', ostream);
		emit_char('N', ostream);
		return;
	}

	if (val < 0.0) {
		emit_char('-', ostream);
		val *= -1;
	}

	if (isinf(val)) {
		emit_char('i', ostream);
		emit_char('n', ostream);
		emit_char('f', ostream);
		return;
	}

	if (val == 0) {
		emit_char('0', ostream);
		return;
	}

	int e = log10(val);
	if (e < 0) {
		if (e < -4) {
			scientific = --e;
			digit = uint(val / pow(10, e)) % 10;
			emit_char(digit + 0x30, ostream);
			significant++;
			e--;
		} else {
			emit_char('0', ostream);
			e = -1;
		}
	} else {
		if (e > 6)
			scientific = e;
		while (e - scientific >= 0) {
			digit = uint(val / pow(10, e)) % 10;
			emit_char(digit + 0x30, ostream);
			if (digit || significant) // Don't count leading 0 as significant, but do count following 0s
				significant++;
			e--;
		}
	}
	if (!scientific && frac(val / pow(10, e + 1)) == 0)
		return;
	emit_char('.', ostream);
	bool emitted = false;
	while (!emitted || (significant < 3 && frac(val / pow(10, e + 1)))) {
		digit = uint(val / pow(10, e)) % 10;
		emit_char(digit + 0x30, ostream);
		significant++;
		e--;
		emitted = true;
	}

	if (scientific) {
		emit_char('e', ostream);
		emit_int(scientific, ostream);
	}
}

// The max here is dictated by 1024 / sizeof(gs2ps)
[maxvertexcount(144)]
void main(point vs2gs input[1], inout TriangleStream<gs2ps> ostream)
{

	if ((current_time - activation_time > overlay_hud_timeout))
	return;

//***************************************************************
	get_meta();
	uint idx = input[0].idx;
	uint i = 0;
	uint start_pos = idx;
	//float cval = 1.#INF;
	float char_height = char_size.y / resolution.y * 2 * font_scale;
	int max_y = resolution.y / char_size.y * font_scale;

	// Edit this line to change the position on screen:
	//cur_pos = float2(-0.98, 0.0 + char_height);
	cur_pos = float2(-0.98, -0.9 - (start_pos % max_y) * char_height);
		
//***************************************************************

	if (idx == i++) {
			

						
			if (onoff1) {
					emit_char('C', ostream);
					emit_char('i', ostream);
					emit_char('n', ostream);
					emit_char('e', ostream);
					emit_char('m', ostream);
					emit_char('a', ostream);
					emit_char('t', ostream);
					emit_char('i', ostream);
					emit_char('c', ostream);
					emit_char('s', ostream);
			}
			
			else {
					emit_char('G', ostream);
					emit_char('a', ostream);
					emit_char('m', ostream);
					emit_char('e', ostream);
					emit_char('p', ostream);
					emit_char('l', ostream);
					emit_char('a', ostream);
					emit_char('y', ostream);
				}
			
			
			
		}
		
}
#endif

#ifdef PIXEL_SHADER
void main(gs2ps input, out float4 o0 : SV_Target0)
{
	float font_width, font_height;
	float2 char_size;
	float2 pos;
			
	font.GetDimensions(font_width, font_height);
	char_size = float2(font_width, font_height) / float2(16, 6);

	pos.x = (input.character % 16) * char_size.x;
	pos.y = (input.character / 16 - 2) * char_size.y;

	pos.xy += input.tex * char_size;

	o0.xyzw = font.Load(int3(pos, 0)) * float4(colour, 1);

	// Cap alpha to make background dark for contrast:
	o0.w = max(o0.w, 0.75);
}
#endif
