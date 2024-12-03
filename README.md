# Get PsychoJS Code running on-premise

## Win Howto
The easist way to get the bash script running on Windows is the "Windows Subsystem for Linux" (WSL).

(1) Install WSL
- (a) Login with your Administrator account in Windows
- (b) Open the Program "Powershell"
- (c) Type the command `wsl --install` and follow the instruction.

After restarting, proceed.

(2) What was installed
- Search for Program "WSL". It has a cute pinguin icon. It starts an Ubuntu Terminal window (we need that later)
- Open your File Explorer (Win+E). On the bottom left there is net drive `Linux/Ubuntu/...`. Go to `home/<yourname>`.

(3) Download the template repo:
- Go back to the Terminal Window and type: `git clone https://github.com/ulf1/pav-clone.git`
- Type the command `cd pav-clone`. This how navigate into another folder on the terminal.
- Type the command `ls -l`. This will give a list of files and folders in this directory.
- In your File Explorer you should see a folder `Linux/Ubuntu/home/<yourname>/pav-clone`

Proceed with step (2) in the next chapter.


## *nix HowTo (bash)


### (1) Clone this Git-Rep
```sh
git clone https://github.com/ulf1/pav-clone.git
cd pav-clone
```

### (2) Save your HTML-/JS-Code
- In PsychoPy, click on "Export HTML" in the Menu.
- Save the code as **folder** in this Git-Rep (In our example, the "mini-beispiel" folder)
- What is your **experiment name**? (In our example, "Test123")

You can recognize the experiment name by the file names. The experiment name is used as prefix, e.g.

- `[experiment name]_lastrun.py`
- `[experiment name]-legacy-browsers.js`
- `[experiment name].js`
- `[experiment name].psyexp`


### (3) Call the script to alter the code

```sh
# bash script.sh  <folder>  <experiment name>
bash script-nix.sh  "mini-beispiel"  "Test123"
```

The script does the following:

- add a PsychoJS library as `myfolder/lib/`, and replace the versions numbers. 
    Currently PsychoJS 2023.1.0 is availble. If you want to upgrade, then 
    add a new library as `psychojs/lib-YYYY.x.z`, and set `AVAILVERSION=YYYY.x.z` in `script-nix.sh` 
- add the PHP server script `save_trial.php` to your folder. 
    The server script runs on your web server and receives the result file from your test subjects client/webbrowser.
- append the code of `sendtoserver.js` in your `[experiment name].js` file, 
    and add the `sendToServer()` call in the first line of the JS function  `quitPsychoJS`
 

### (4) Check if works 
You need to have PHP-CLI installed for this (e.g. `sudo apt install php8.1-cli`)

```sh
cd mini-beispiel
php -S localhost:8000
```

Open http://localhost:8000/ in your Browser.

In Chrome or Firefox, open the "Developer Tools" and check the Console tab to see if there is an Javascript error on client side.
On your Ubuntu-PC, you will see the error logs of the PHP web server.


### (5) Upload to study server
First, you need to create a folder on the study server

```sh
ssh webfb11@allgpsych-studien.uni-bremen.de 
cd /home/webfb11/public_html.allgpsych-studien.uni-bremen.de
mkdir test123
exit # logout or use another terminal window
```

Second, upload your code to the new study folder
```sh
cd mini-beispiel
scp -r $(pwd)/* webfb11@allgpsych-studien.uni-bremen.de:/home/webfb11/public_html.allgpsych-studien.uni-bremen.de/test123/
```

Run a trial
https://allgpsych-studien.uni-bremen.de/test123/

Check if the trial data was saved
```sh
ssh webfb11@allgpsych-studien.uni-bremen.de 
ls /home/webfb11/public_html.allgpsych-studien.uni-bremen.de/test123/data
```


## Acknowledgement
https://codewithsusan.com/notes/psychopy-self-hosted-experiments
