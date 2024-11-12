

## Adjust PsychoJS Code [on Linux with bash]

### (1) Clone this Git-Rep
```sh
git clone pav-clone
cd pav-clone
```

### (1) Export the HTML-/JS-Code from Psychopy
In PsychoPy, click on "Export HTML" in the Menu.


### (2) Copy the code into this Git-Clone
In following, it's assumed that the HTML-/JS-Code is in the folder "mini-beispiel".

```sh
export FOLDER=mini-beispiel
```
(Change the environment variable `FOLDER` to your folder name.)


### (3) Set your experiment name
In the `FOLDER` there are several files with the same name, e.g.

- `[name]_lastrun.py`
- `[name]-legacy-browsers.js`
- `[name].js`
- `[name].psyexp`

We need to set this experiment name as variable:

```sh
export EXPNAME=Test123
```
(Change the environment variable `EXPNAME` your experiment name.)


### (4a) Get the PsychoJS Version
!Step 4 a-c are only necessary, if you don't have `./lib` folder or it contains a PsychoJS version that does not match your exported HTML/JS-Code.


In the file `${FOLDER}/${EXPNAME}.js` (e.g. `mini-beispiel/Test123.js`) there is a line of code that looks like:

```js
...
import { core, data, sound, util, visual, hardware } from './lib/psychojs-2024.2.4.js';
...
```

Copy the version number `... ./lib/psychojs-[version].js ...` and set as environment variable

```sh
export PJSVERSION=2024.2.4
```
(Change the environment variable `PJSVERSION` your version.)


### (4b) Copy the PsychoJS lib
```sh
export AVAILVERSION=2023.1.0
cp -r "psychojs/lib-${AVAILVERSION}" "${FOLDER}/lib"
```

### (4c) Replace versions in HTML/JS Code
```sh
cd "${FOLDER}"

sed -i.bak "s/${PJSVERSION}/${AVAILVERSION}/g" "${EXPNAME}.js"
sed -i.bak "s/${PJSVERSION}/${AVAILVERSION}/g" "index.html"

# rm "index.html"
# rm "${EXPNAME}.js.bak"

cd ..
```
(!Don' forget `cd ..` here)

### (5) Copy the PHP server script 
The purpose of the PHP server script is to receive and store trial data 
that have been sent from the client webbrowser by the participant.

```sh
cp save_trial.php "${FOLDER}/save_trial.php"
```

### (6a) Append Code
The file `sendtoserver.js` contains JS code that need to be appended to `${EXPNAME}.js` (e.g. Test123.js).

```sh
cat sendtoserver.js >> "${FOLDER}/${EXPNAME}.js"
``` 

### (6b) Call sendToServer in quitPsychoJS
At the bottom of the `${EXPNAME}.js` (e.g. Test123.js) file there is a function `quitPsychoJS`.
Call the `sendToServer();` in the first line of `quitPsychoJS`

For example,
```js
async function quitPsychoJS(message, isCompleted) {
  sendToServer();
  ...
}
``` 

### (7) Check if works 
```sh
cd "${FOLDER}"
php -S localhost:8000
```

In Chrome or Firefox, open the "Developer Tools" and check the Console tab to see if there is an Javascript error on client side.
On your Ubuntu-PC, you will see the error logs of the PHP web server.


### (8) Upload to study server

```sh
scp -r $(pwd) webfb11@allgpsych-studien.uni-bremen.de:/home/webfb11/public_html.allgpsych-studien.uni-bremen.de/test456/
```


## Development

Installiere PHP Testserver auf Ubuntu-PC
```sh
sudo apt install php8.1-cli
```

Gehe in den Ordner mit dem Experiment
```sh
cd mini-beispiel/
```

Starte den PHP-Entwicklungsserver
```sh
php -S localhost:8000
```

Nun der Ubuntu-PC genau in diesem Ordner ein Webserver (Server).
Beim HTML-/JS-Code ist immer zu beachten, dass diese im Browser des Studienteilnehmer laufen (Client).
Also der Benutzer lädt sich immer beim Aufruf den HTML-/JS-Code runter.
Dagegen bleibt das PHP-Skript `save_trial.php` immer auf dem Webserver liegen.


## Acknowledgement
This solution was mainly copied and adoped from 
https://codewithsusan.com/notes/psychopy-self-hosted-experiments
