Notes:
    ℹ️ geo-11 leverages the game's native Stereo 3D option which takes care of correcting shaders by faking 3D Vision support
    ❌ Water and mirror reflections are flat
    ❌ TXAA makes game 2D
    ❌ Map player indicator is slightly offset to the right
    ✅ Fantastic performance
    ✅ Dynamic crosshair adjusts depth to match the distance to the object at the center of the screen, though to shoot while driving we have to break/shoot the windshield.

Instructions:
    Disable BattlEye using the method that applies to your case:
    in Rockstar Games Launcher > Settings > Disable BattlEye
    in Steam, right-click on the game title in the library > Properties > paste launch parameters: -nobattleye
    in the desktop shortcut, right-click it > Properties and add the following (including space) after the end of the path to the .exe in Target:  -nobattleye
    If the game doesn't load geo-11's d3d11.dll (common in newer GTA5 builds and on Windows 11), try: 
    Run 3DMigoto Loader.exe
    Set the executables to run with Windows 7 compatibility.
    Downgrade to a mod-friendly build like 1.0.2699.16.
    Settings
    Graphics
    Screen type: Fullscreen
    Only required if using NVIDIA 3D Vision
    Disable NVIDIA TXAA
    Enable Stereo 3D
    This requires restarting the game
    If shadows, lighting or reflections look wrong, try switching Shadows to Normal and back, and increase/decrease both separation and convergence with Ctrl+F3-F6 (if overlay doesn't auto-hide, press Ctrl+F1) or via Settings > Graphics
    For 3D Vision, disable fullscreen optimizations for all executables to start in fullscreen.

Credits:
    davegl1234: geo-11 with native 3D Vision spoofing
    bo3b: Native 3D texture hash
    masterotaku: Help with auto-convergence
    Midlife Crisis: Destination marker fix
    TonyMontana: Windows 7 compatibility suggestion
    3DJ: auto-convergence presets and packaging