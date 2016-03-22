# milkvr-mvrl-maker
A Windows executable to generate MilkVR ".mvrl" files for a collection of videos on your local PC, allowing easy access to those videos from within the MilkVR application.

This tool was inspired by, and copies heavily from, the tool located at https://github.com/abnormalend/milkvr-url-maker

##The Basics
If you already have a web server running and configured, just put the mvrl-maker.exe tool in the folder with your VR video files and execute it. The tool will create a folder named "mvrl" with a mvrl file for each video file found.  Supported video file type extensions are .mp4, .m4v, .mkv, .3gp, and .webm. Copy the generated mvrl files to the MilkVR folder in the root directory of your mobile device. The videos will then be accessible in the "Sideloaded" category from within MilkVR. See https://milkvr.com/#/content/faq for directions on how to create a MilkVR folder on your device. 

The tool will recursively search subfolders for video files and generate the proper mvrl files for those as well. However, the generated mvrl folder will be a flat structure, as the MilkVR folder on a device does not support subfolders. *Web Servers do not like spaces in folder names.*

###Don't Already Have a Web Server?  (assumes you're on windows)
 - Download nginx. (http://nginx.org/en/download.html)
 - Unzip somewhere on your system.
 - Enter the nginx folder, then the html folder.
 - For the default settings, create a folder within html called VR.
 - Copy some VR videos (named correctly) to this folder, along with mvrl-maker.exe tool.
 - Run mvrl-maker.exe.
 - **Copy the generated mvrl files from the generated mvrl folder to the MilkVR folder\* on your mobile device.** 
 - Go back to the main nginx folder and run nginx.exe.  If you have windows firewall turned on, you should get prompted about allowing it.
 - Test it out! Run MilkVR and directly stream your PC videos from the "Sideloaded" category.

\* See https://milkvr.com/#/content/faq for directions on how to create a MilkVR folder on your device.

##File Names
The video files do need to be named in the same way that MilkVR would expect them if you were copying to your phone's storage. The optimal naming convention for your videos is `<video_name>.<video_type>.mp4` where `<video_type>` is a MilkVR recognized video type string. See https://milkvr.com/#/content/faq for the available options for `<video_type>`.

For example, if you have a video named `my_video.3dh.mp4`, the tool will create an mvrl file named `my_video.3dh.mvrl` containing:

    http://<your_computer_name>/VR/my_video.3dh.mp4
    3dh

In a mvrl file, the first line is the path to the file to be played, and the second line identifies the video type. 
    
The `<video_name>.<video_type>.mp4` format is optimal but not required. If you have a valid `<video_type>` string anywhere in the file name, the generated mvrl file should still work. For example, if you have a video named `another_video_3dph.mp4` (the video type string is `_3dph`), the tool will create an mvrl file named `another_video_3dph.mvrl` containing:

    http://<your_computer_name>/VR/another_video_3dph.mp4
    another_video_3dph

Note that the video type line of the generated file will contain more than just the required video type string `_3dph`, but, at present, MilkVR still finds the video type information in this case and plays the video correctly. 

*Avoid using spaces in filenames, at least when using nginx.*

##Runtime Arguments
The mvrl-maker.exe tool has several options built into it. You have to run the tool using the command line if you want to use any of the options below.

 -  `--urlBase` will override the main URL being assigned to the file links put into the mvrl files.  The default if not specified is `http://<your_computer_name>/VR/` where `<your_computer_name>` is the name of your PC. For eample, if for some reason your mobile device cannot locate your machine via `http://<your_computer_name>`, you can use this option to identify your machine using its ip address instead with:

    `--urlBase=http://<ip_address>/VR/`

 -  `--videoFolder` identifies the folder to scan for videos. The default is the folder that the tool is being run from. Example usage is:
 
   `--videoFolder=C:\Users\userA\MyVRVideos`

 -  `--mvrlFolder` identifies the folder the tool should place the generated mvrl files.  The default mvrl file destination is a folder named "mvrl" created in the folder that the tool is being run from. For example, to override the default name and location of the mvrl folder you can use:

   `--mvrlFolder=C:\Users\userA\MyMvrlFiles`
   
 -  `--keepExisting` is an option to prevent the tool from deleting existing mvrl files before generating new ones. By default, the tool deletes all existing mvrl files from the targeted mvrl folder, and generates new mvrl files for each video found. If this option is used, the tool will not delete or overwrite any existing mvrl files located in the mvrl folder. For example, you can use this option if you are running the tool in order to add new mvrl files to an existing mvrl folder. 

##Accessing Files on External Drives
If you follow the standard instructions above, and are using nginx as your web server, you may have all your videos in the folder `\nginx-x.x.x\html\VR`, and the urls for accessing those videos would would start with `http://<machine_name>/VR/` or `http://<machine_ip_address>/VR/` 

Let's say you wanted to move all your VR videos to an external drive mapped to `g:`, The directions below are one way to do this.

- Move the "VR" folder from `\nginx-x.x.x\html` to the root of the `g:` so that the path to the videos is `g:\VR`
- Copy mvrl-maker.exe to `g:\VR`
- Run mvrl-maker and use the --urlBase option such that the generated urls still point the the old VR folder

  `g:\VR>mvrl-maker.exe --urlBase=http://<machine_name>/VR/`  
  
  or 
  
  `g:\VR>mvrl-maker.exe --urlBase=http://<machine_ip_address>/VR/`  
  
- **Copy the generated mvrl files from the generated mvrl folder to the MilkVR folder on your mobile device.** 
- - Open the nginx.conf file located at `\nginx-x.x.x\conf\nginx.conf`
- Add a new "location" entry to the "server" section of the nginx.conf that maps the location of the old VR folder to the new VR folder on the g: drive. 

```
http  {
    ...
    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }
        
        ### ADDED LINES BELOW ###
        location /VR/ {
            root g:/VR;
        }
        ### END ADDED LINES ###

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
        ...
    }
}
```        
- Restart the nginx server
- With the above configuration change, nginx will respond to a request for `http://<machine_name>/VR/file.mp4` with the file `g:\VR\file.mp4`
- Note that the nginx.conf file uses only forward slashes "/"


##What is mvrl-maker.ahk?
The mvrl-maker.exe tool was generated from mvrl-maker.ahk using AutoHotkey (https://autohotkey.com/). AutoHotKey must be installed on your PC to execute mvrl-maker.ahk directly. The AutoHotKey version of the tool accepts the same parameters as the exectuable version. The AutoHotKey script is provided to allow users to modify the tool behavior if desired and generate a new executable. Installing AutoHotKey and extracting mvrl-make.ahk is not required otherwise. 
