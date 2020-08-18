set "nowPath=nsProcess_1_6"





D:

cd D:\qx\robot-client\dependent

"C:\Program Files\7-Zip\7z.exe" x %nowPath%.7z -o*

cd ./%nowPath%

copy .\Include\nsProcess.nsh "C:\Program Files (x86)\NSIS\Include"

copy .\Plugin\nsProcess.dll "C:\Program Files (x86)\NSIS\Plugins\x86-ansi"

copy .\Plugin\nsProcessW.dll "C:\Program Files (x86)\NSIS\Plugins\x86-unicode"

ren "C:\Program Files (x86)\NSIS\Plugins\x86-unicode\nsProcessW.dll" "nsProcess.dll"

cd ../

rd /s /Q %nowPath%

pause