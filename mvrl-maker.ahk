;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
;
; Script Function:
;	Creates a folder of SamsungVR mvrl files for a directory of videos
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Set default values
videoFolder := A_ScriptDir
urlBase := "http://" . A_ComputerName . "/VR/"
mvrlFolder := "mvrl"
keepExisting := "false"

; Look for and parse input parameters
Loop, %0%  ; For each parameter:
{
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
	if InStr(param, "--urlbase")
	{
		StringSplit, paramArray, param, "="
		urlBase := paramArray2
	}
	if InStr(param, "--videoFolder")
	{
		StringSplit, paramArray, param, "="
		videoFolder := paramArray2
	}	
	if InStr(param, "--mvrlFolder")
	{
		StringSplit, paramArray, param, "="
		mvrlFolder := paramArray2
	}	
	if InStr(param, "--keepExisting")
	{
		keepExisting := "true"
	}	
}

; Create the mvrl folder if it does not exist
IfNotExist, %mvrlFolder% 
	FileCreateDir, %mvrlFolder%

; Move to the mvrl folder
SetWorkingDir, %mvrlFolder%

; Remove existing mvrls if flag to keep them is not set
if (keepExisting = "false"){
	FileDelete, *.mvrl
}

; Create a video file search string
searchString := videoFolder . "\*.mp4"

OutputDebug %searchString%`r`n
Loop, %searchString%
{
	; Parse the video file name for key components
	file_minus_ext := RegExReplace(A_LoopFileName, "(.*).mp4$", "$1")
	video_type := RegExReplace(file_minus_ext, ".*\.(.*)", "$1")
	name := RegExReplace(file_minus_ext, "(.*)\..*", "$1")	

	; Create mvrl file name
	filename := file_minus_ext . ".mvrl"

	; Create the mvrl file, respecting the keepExisting setting
	if ((keepExisting = "false") || ((keepExisting = "true") && (!FileExist(filename)))) {
		file := FileOpen(filename, "w")
		file.Write(urlBase . A_LoopFileName . "`r`n")
		file.Write(video_type)
		file.Close()
	}
}
