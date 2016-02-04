# milkvr-mvrl-maker
Windows executable to generate MilkVR ".mvrl" files for a collection of videos on your local PC, allowing easy access to those videos from within the MilkVR application.

NOTE: This tool was inspired by, and copies heavily from, the tool located at  https://github.com/abnormalend/milkvr-url-maker

##The Basics
If you already have a web server running and configured, just put the mvrl-maker.exe tool in the folder with your VR video files and execute it. The tool will create a folder named "mvrl" with a mvrl file for each video file found.  Copy the generated mvrl files to the MilkVR folder in the root directory of your mobile device, The videos will then be accessible in the "Sideloaded" category from within MilkVR. See https://milkvr.com/#/content/faq for directions on how to create a MilkVR folder on your device. 

###Don't Already Have a Web Server?  (assumes you're on windows)
 - Download nginx. (http://nginx.org/en/download.html)
 - Unzip somewhere on your system.
 - Enter the nginx folder, then the html folder.
 - For the default settings, create a folder within html called VR.
 - Copy some VR videos (named correctly) to this folder, along with mvrl-maker.exe tool.
 - Run mvrl-maker.exe.
 - Copy the generated mvrl files from the generated mvrl folder to the MilkVR folder on your mobile device. 
 - Go back to the main nginx folder and run nginx.exe.  If you have windows firewall turned on, you should get prompted about allowing it.
 - Test it out! Run MilkVR and directly stream your PC videos from the "Sideloaded" category.

##File Names
The video files do need to be named in the same way that MilkVR would expect them if you were copying to your phone's storage. The optimal naming convention for your videos is `<video_name>.<video_type>.mp4` where `<video_type>` is a MilkVR recognized video type string. See https://milkvr.com/#/content/faq for the available options for `<video_type>`.

For example, if you have a video named `my_video.3dh.mp4`, the tool will create an mvrl file named `my_video.3dh.mvrl` containing:

    http://<your_computer_name>/VR/my_video.3dh.mp4
    3dh

In a mvrl file, the first line is the path to the file to be played, and the second line identifies the video type. 
    
The `<video_name>.<video_type>.mp4` format is optimal but not required. If you have a valid `<video_type>` string anywhere in the file name, the generated mvrl file should still work. For example, if you have a video named `another_video_3dph.mp4` (the video type string is `_3dph`), the tool will create an mvrl file named `another_video_3dph.mvrl` containing:

    http://<your_computer_name>/VR/another_video_3dph.mp4
    another_video_3dph

Note that the video type line of the generated file will contain more than just the required video type string `_3dph`, but, at present, the MilkVR still finds the video type information in this case and plays the video correctly. 

##Runtime Arguments
The mvrl-maker.exe tool has several options built into it. You have to run the tool using the command line if you want to use any of the options below.

 -  `--urlBase` will override the main URL being assigned to the file links put into the mvrl files.  The default if not specified is `http://<your_computer_name>/VR/` where `<your_computer_name>` is the name of your PC. For eample, if for some reason your mobile device cannot locate your machine via `http://<your_computer_name>`, you can use this option to use the ip address of your machine instead with:

    `--urlBase=http://<ip_address>/VR/`

 -  --videoFolder is the folder to scan for videos. The default is the folder that the tool is being run from. Example usage is:
 
   `--videoFolder=C:\Users\userA\MyVRVideos`

 -  --mvrlFolder is the folder the tool should place the generated mvrl files.  The default mvrl file destination is a folder named "mvrl" created in the folder that the tool is being run from. For example, to override the default name and location of the mvrl folder you can use:

   `--mvrlFolder=C:\Users\userA\MyMvrlFiles`
   
 -  --keepExisting is an option to prevent the tool from deleting existing mvrl files before generating new ones. By default, the tool deletes all existing mvrl files from the targeted mvrl folder, and generates new mvrl files for each video found. If this option is used, the tool will not delete or overwrite any existing mvrl files located in the mvrl folder. For example, you can use this option if you are running the tool in order to add new mvrl files to an existing mvrl folder. 

##What is mvrl-maker.ahk?
The mvrl-maker.exe tool was generated from the AutoHotKey script mvrl-maker.ahk using AutoHotkey (https://autohotkey.com/). AutoHotKey must be installed on your PC to execute mvrl-maker.ahk directly. The AutoHotKey version of the tool accepts the same parameters as the exectuable version. The AutoHotKey script is provided to allow users to modify the tool behavior if desired and generate a new executable.  
