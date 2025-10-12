
DHR's 3DMigoto fix upgraded to geo-11 by 3DJ with help from masterotaku.

Instructions:
    Download and extract the fix into the game folder
    Set direct_mode in d3dxdm.ini to what your 3D hardware expects.
    Optionally, run JustCause3.cmd included in the fix to run the game with the parameters needed to skip the intro video to save time, especially when testing. You can also add them to Steam to skip the warning.
    Max out all graphics settings, but Motion Blur (Off) and Anti-Aliasing (SMAA, FXAA or Off)

When upgrading the 3DMigoto fix to geo-11 manually (not needed if you download the fix):
    Set allow_create_device=1 under [System] in d3dx.ini to fix game not starting with 3DV
    Set stereo_compute_enable=3 under [Stereo] in d3dxdm.ini to fix missing terrain
    Delete 7a1ee521893b9809-ds.txt and 7a1ee521893b9809-ds.bin from ShaderFixes and ShaderFixesDM folders to fix some far geometry not rendering correctly.

Notes:
    Driver 452.06 may freeze at the end of the loading screen (might be shader cache-related?), but 425.31 works fine.
    There may be some stones and vegetation rendering in one eye, some minor distant lights rendering incorrectly, and the city title and some menu text being distorted