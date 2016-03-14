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

; Set supported file types
fileTypes := Object()
fileTypes.insert("mp4")
fileTypes.insert("webm")
fileTypes.insert("3gp")
fileTypes.insert("mkv")
fileTypes.insert("m4v")

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

; For each file extension supported
Loop % fileTypes.MaxIndex() {

	; Get the extension text for the current filetype
	fileType := fileTypes[A_Index]

	; Create a video file search string
	searchString := videoFolder . "\*." . fileType

	; Find all files recursively
	OutputDebug %searchString%`r`n
	Loop, Files, %searchString%, R
	{
		; Parse the video file name for key components
		expression := "(.*)." . fileType . "$"
		file_minus_ext := RegExReplace(A_LoopFileName, expression, "$1")
		video_type := RegExReplace(file_minus_ext, ".*\.(.*)", "$1")
		name := RegExReplace(file_minus_ext, "(.*)\..*", "$1")	

		; Create mvrl file name
		filename := file_minus_ext . ".mvrl"

		; Create http based file path
		filePath := StrReplace(A_LoopFileFullPath, videoFolder . "\", urlBase)
		filePath := StrReplace(filePath, "\", "/")

		; Create the mvrl file, respecting the keepExisting setting
		if ((keepExisting = "false") || ((keepExisting = "true") && (!FileExist(filename)))) {
			file := FileOpen(filename, "w")
			file.Write(filePath . "`r`n")
			file.Write(video_type)
			file.Close()
		}
	}
}
