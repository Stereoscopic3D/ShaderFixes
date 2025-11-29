
geo-11 without shader fixes, only configured with auto-convergence by 3DJ

Instructions:
    Download and extract the fix into the game folder
    Set direct_mode in d3dxdm.ini to what your 3D hardware expects.
    Steam version apparently requires removing Steam DRM:
    steam_api64.dll https://cs.rin.ru/forum/download/file.php?id=173979
        source https://cs.rin.ru/forum/viewtopic.php?p=3402371#p3402371
        scan https://hybrid-analysis.com/sample/28842312753062ed1fe8a05e5509c3f46abd9766cd708c476d983b97db65bd2f
    steam_emu.ini https://pastebin.com/dl/rEqP3mph
        (configure if needed)
    Steamless https://github.com/atom0s/Steamless/releases/latest
        unpack original SnowRunner.exe, delete/move it, and rename SnowRunner.exe.unpacked.exe to replace the original)
    Run game via above executable instead of running Steam
    Settings
        Video
            Display Mode: Fullscreen
                If 3DV fails to trigger, especially after Alt+Tabbing, switch to Borderless then back to Fullscreen
            Resolution: Set max/preferred