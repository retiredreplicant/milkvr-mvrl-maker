# milkvr-mvrl-maker

A Windows executable to generate MilkVR ".mvrl" files for a collection of videos on your local PC, allowing easy access to those videos from within the MilkVR application.

This tool was inspired by, and copies heavily from, the tool located at https://github.com/abnormalend/milkvr-url-maker

## The Basics

If you already have a web server running and configured, just put the mvrl-maker.exe tool in the folder with your VR video files and execute it. The tool will create a folder named "mvrl" with a mvrl file for each video file found.  Supported video file type extensions are .mp4, .m4v, .mkv, .3gp, and .webm. Copy the generated mvrl files to the MilkVR folder in the root directory of your mobile device. The videos will then be accessible in the "Sideloaded" category from within MilkVR. See https://milkvr.com/portal/content/faq for directions on how to create a MilkVR folder on your device.

The tool will recursively search subfolders for video files and generate the proper mvrl files for those as well. However, the generated mvrl folder will be a flat structure, as the MilkVR folder on a device does not support subfolders. *Web Servers do not like spaces in folder names.*

### Don't Already Have a Web Server?  (assumes you're on windows)

-   Download nginx. (http://nginx.org/en/download.html)
-   Unzip somewhere on your system.
-   Enter the nginx folder, then the html folder.
-   For the default settings, create a folder within html called VR.
-   Copy some VR videos (named correctly) to this folder, along with mvrl-maker.exe tool.
-   Run mvrl-maker.exe.
-   **Copy the generated mvrl files from the generated mvrl folder to the MilkVR folder\* on your mobile device.**
-   Go back to the main nginx folder and run nginx.exe.  If you have windows firewall turned on, you should get prompted about allowing it.
-   Test it out! Run MilkVR and directly stream your PC videos from the "Sideloaded" category.

\* See https://milkvr.com/portal/content/faq for directions on how to create a MilkVR folder on your device.

## Thumbnails

If you would like to see thumbnails for your vides in MilkVR, instead of a black square, create a folder named `thumbnails` in the same folder as your videos. Use a thumbnail generator tool to create thumbnails for your videos with a `.jpeg` extension. For example, if your video is named `my_video.mp4` put an image named `my_video.jpeg` in the `thumbnails` directory, and that image will be automatically associated with that video within MilkVR.

I use a tool called Thumbnail me 3.0 (http://www.thumbnailme.com/) to create my thumbnails rather easily. "Load" all your videos as the input, specify the `thumbnails` directory as the output destination, and then select "Start". I recommend setting the "Rows" and "Columns" values under "Configuration" to 1 for the best looking thumbnails.

## File Names

The video files do need to be named in the same way that MilkVR would expect them if you were copying to your phone's storage. Any required Video Type code or Audio Type code needs to be embedded in the video file name. See https://milkvr.com/portal/content/faq for all the available Video and Audio Type codes.

For example, if you have a video named `my_video_binaural_3dh.mp4`, the tool will create an mvrl file named `my_video_binaural_3dh.mvrl` containing:

    http://<your_computer_name>/VR/my_video_binaural_3dh.mp4
    my_video_binaural_3dh
    my_video_binaural_3dh
    http://<your_computer_name>/VR/thumbnails/my_video_binaural_3dh.jpeg

In a mvrl file, the first line is the path to the file to be played, the second line identifies the Video Type, the third line identifies the Audio Type, and the fouth line identifies a thumbnail image. There is a good description now of mvrl files on the MilkVR FAQ page (https://milkvr.com/portal/content/faq).

I have verified the MilkVR searches the entire second line for a video type code, and searches the entire third line for an audio type code. For the above example, MilkVR will play the video using video type code `3dh` and audio type code `_binaural`. If your video does not require a video or audio type code, it will be ok that MilkVR does not them in the text on the respective lines. It is also ok if the generated thumbnail path put on the fourth line does not exist. Your video will just not have a thumbnail associated with it.

*Avoid using spaces in filenames, at least when using nginx.*

## Runtime Arguments

The mvrl-maker.exe tool has several options built into it. You have to run the tool using the command line if you want to use any of the options below. Multiple options can be used at the same time.

-   `--urlBase` will override the main URL being assigned to the file links put into the mvrl files.  The default if not specified is `http://<your_computer_name>/VR/` where `<your_computer_name>` is the name of your PC. For eample, if for some reason your mobile device cannot locate your machine via `http://<your_computer_name>`, you can use this option to identify your machine using its ip address instead with:

        >mvrl-maker.exe --urlBase=http://<ip_address>/VR/

-   `--mvrlFolder` identifies the folder the tool should place the generated mvrl files.  The default mvrl file destination is a folder named "mvrl" created in the folder that the tool is being run from. For example, to override the default name and location of the mvrl folder you can use:

        >mvrl-maker.exe --mvrlFolder=C:\Users\userA\MyMvrlFiles

-   `--keepExisting` is an option to prevent the tool from deleting existing mvrl files before generating new ones. By default, the tool deletes all existing mvrl files from the targeted mvrl folder, and generates new mvrl files for each video found. If this option is used, the tool will not delete or overwrite any existing mvrl files located in the mvrl folder. For example, you can use this option if you are running the tool in order to add new mvrl files to an existing mvrl folder. For example:

        >mvrl-maker.exe --keepExisting

## Accessing Files on External Drives

If you follow the standard instructions above, and are using nginx as your web server, you may have all your videos in the folder `\nginx-x.x.x\html\VR`, and the urls for accessing those videos would would start with `http://<machine_name>/VR/` or `http://<machine_ip_address>/VR/`

Let's say you wanted to move all your VR videos to an external drive mapped to `g:`, The directions below are one way to do this.

-   Move the "VR" folder from `\nginx-x.x.x\html` to the root of the `g:` so that the path to the videos is `g:\VR`

-   Copy mvrl-maker.exe to `g:\VR`

-   Run mvrl-maker and use the --urlBase option such that the generated urls still point the the old VR folder

        g:\VR>mvrl-maker.exe --urlBase=http://<machine_name>/VR/

    or

        g:\VR>mvrl-maker.exe --urlBase=http://<machine_ip_address>/VR/

-   **Copy the generated mvrl files from the generated mvrl folder to the MilkVR folder on your mobile device.**

-   Open the nginx.conf file located at `\nginx-x.x.x\conf\nginx.conf`

-   Add a new "location" entry to the "server" section of the nginx.conf that indicates where nginx should look for the VR folder. in this example, the VR folder is located on the g: drive.

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

                ###### ADDED LINES BELOW ######
                location /VR/ {
                    root g:;
                }
                ####### END ADDED LINES #######

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

    Note that in this example, the location of the VR folder is in the root of `g:` . If the VR folder was located at `g:\MyVideos\VR\`, then the location statement added to nginx.conf would contain `root g:/MyVideos;`

-   Restart the nginx server

-   With the above configuration change, nginx will respond to a request for `http://<machine_name>/VR/file.mp4` with the file `g:\VR\file.mp4`
-   Note that the nginx.conf file uses only forward slashes "/"
-   See nginx documentation for the details about the configuration file syntax

## What is mvrl-maker.ahk?

The mvrl-maker.exe tool was generated from mvrl-maker.ahk using AutoHotkey (https://autohotkey.com/). AutoHotKey must be installed on your PC to execute mvrl-maker.ahk directly. The AutoHotKey version of the tool accepts the same parameters as the exectuable version. The AutoHotKey script is provided to allow users to modify the tool behavior if desired and generate a new executable. Installing AutoHotKey and extracting mvrl-make.ahk is not required otherwise.

## Trouble Shooting

If you are using a nginx server, you can start the server by double-clicking `nginx.exe` in the `nginx-1.x.x` folder. A small window should appear and dissapear quickly. You may get asked if you want the program to run. Use the Task Manager to verify that nginx.exe is listed in the running processes. It seems to always be listed twice for me.

If the nginx server, or the server of your choosing, is running, open up one of the generated mvrl files using Notepad or Wordpad. Copy the URL to the video from the first line of the mvrl file. Past this URL into a tab in your browser and press enter. If you are using nginx and you followed the directions above, the video will start to play in a 2D mode (tested with Chrome.) If you are using another server, you may need to use the `--urlBase` option to identify the proper path to your videos for that server.

If the URL above works in a browser on your computer, the next step would be to try that same URL on your mobile device. **Make sure your mobile device and your computer are connected to the same WiFi network.** One trick to get the URL on your device is to email it to yourself. Open the email and simply click on the link you pasted into the email. Your default browser should open and the video should again play.

If the video does not play, it could be possible that your computer is not accessible via its name. Your computer's name is used by mvrl-maker by default to construct the URL to a video. If you are familiar with using a command line, use `ipconfig` to get the wireless IP Address of your computer, and execute `mvrl-maker` from the command line using the `--urlBase` option to use the wireless IP Address instead of the computer name. The Runtime Arguments section above has an example. If you are not familiar with using a command line, continue reading.

Using the Windows Start icon, type in `cmd` in the search text box and hit enter to start the command line program. A black window with a blinking cursor will appear. This is a command line window. Note that to the left of the blinking cursor a "path" is shown. This is showing you what is called the Current Directory for the command line.  If you type in `dir` and hit enter, you will get a list of all the files and directories in the current directory. Directories are identified with `<DIR>` in the results.

Now, the task is to move to the `VR` where your videos and the `mvrl-maker.exe` tool are located. You can type and enter `cd <dir>`, where `<dir>` is actually the name of a directory listed when you execute the `dir` command, to move "down" into that directory. You can type and enter `cd .` to move "up" to the parent directory of the current directory. Using the commands above, migrate to the folder where the nginx server was installed. Once there, enter `cd html` followed by `cd VR` to get to the directory containing your videos.

Now you can use the command line to execute `mvrl-maker.exe`. If you type `mvrl-maker.exe` and hit enter it will do exactly the same work as if you double-clinked the file from a regular window. The options list under Runtime Arguments above can be appended to the command line to modify the program's behavior. In this case we want to create URLs that use your computer's wireless IP Address.

Type and enter `ipconfig`. In the results the appear, find the IPv4 Address listed under the Wireless LAN Adapter section. An IP Address is four numbers separated by periods. Now, enter the command `mvrl-maker.exe --urlBase=http://<ip_address>/VR/` where `<ip_address>` is replaced with the IP Address found using the `ipconfig` command. Open one of the generated mvrl files. The URL to the video file should now start with the wireless IP Address of your machine. Verify the URL works when pasted into a tab in a browser on your computer, and also when entered into a browser on your mobile device. Make sure both devices are on the same WiFi network.
