# milkvr-mvrl-maker
Script to generate NilkVR ".mvrl" files for a collection of videos on your local PC, allowing easy access to those videos from within the milkVR application.

##The Basics
If you already have a web server running and configured, just drop this tool in the folder with your VR video files and run it. The tool will create a folder named "mvrl" with a mvrl file for each video file found.  Copy the generated <video_name>.mvrl files to the MilkVR folder in the root directory of your mobile device, The videos will be accessible in the "Sideloaded" category from within MilkVR. The files do need to be named in the same way that MilkVR would expect them if you were copying to your phone's storage. The optimal naming convention for your videos is <video_name>.<video_type>.mp4 (See https://milkvr.com/#/content/faq for directions to create a MilkVR folder and for the available options for <video_type>.) For example, if you have a video named my_video.3dh.mp4, the tool will create an mvrl file named my_video.3dh.mvrl containing:

    http://<

###Don't already have a webserver?  (assumes you're on windows)
 - Download nginx. (http://nginx.org/en/download.html)
 - Unzip somewhere on your system
 - Enter the nginx folder, then the html folder.
 - For the default settings, create a folder within html called VR.
 - Copy some VR videos (named correctly) to this folder, and the mvrl maker.
 - Run the mvrl maker.
 - Copy the generated mvrl files to the MilkVR folder on your mobile device. 
 - Go back to the main nginx folder and run nginx.exe.  If you have windows firewall turned on, you should get prompted about allowing it.
 - Test it out, run MilkVR and stream your videos from the "Sideloaded" category
 
##Runtime arguments
Both the autohotkey and .exe version have several options built into them.
 -  --urlBase will override the main URL being assigned to the file links.  The default if not specified is http://<computer_name>/VR/ where <computer_name> is the name of your PC. For eample, if your mobile device cannot locate your machine via your <computer_name>, you can use this option to use the ip address of your machine instead with "--urlBase=http://<ip_address>/VR/".
 -  --videoFolder is the folder to scan for videos.  The default is the folder that the tool is being run from. Example usage is "--videoFolder=C:\Users\userA\MyVRVideos".
 -  --mvrlFolder is the folder to place the generated mvrl files for the videos.  The default is a folder named "mvrl" created in the folder that the tool is being run from. For example, to override the default name and location of the mvrl folder you can use "--mvrlFolder=C:\Users\userA\MyMvrlFiles".
 -  --keepExisting is an option to prevent the tool from deleting existing mvrl files before generating new ones. If this option is used, the tool will not delete existing mvrl files, or overwrite existing mvrl files. Use this option if you are running the tool in order to add new mvrl files to an existing mvrl folder. 

