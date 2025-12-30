Notes:
    [3D Vision]
        Set desktop and Stereoscopic 3D refresh rate to 120hz in NVIDIA control panel if using a 144Hz 3D-capable monitor for smooth 60FPS/eye at 120Hz
    Download and open/import this driver profile in NVIDIA Profile Inspector if using an NVIDIA GPU (not sure if other GPUs will work).

Instructions:
    Use geo-11 0.6.90 since all known older and newer builds crash at startup.
    Disable Temporal AA to fix motion blur
    Set Anti-Aliasing to MSAA 4x or 8x, otherwise shadows will be broken
    Disable Ambient Occlusion during sunset/sunrise if the terrain is too dark, or increase brightness.

Credits:
    DHR: 3DMigoto fix
    MikeNX95: Finding the one geo-11 version that works
    3DJ: Auto-convergence and other tweaks