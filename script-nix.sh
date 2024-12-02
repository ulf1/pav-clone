#!/bin/bash


# set the available psychojs Version from 'psychojs/...' folder
AVAILVERSION=2023.1.0

if [ ! -d "psychojs/lib-${AVAILVERSION}" ]; then
    echo "the folder 'psychojs/lib-${AVAILVERSION}' does not exist"
    exit 1;
fi



# checke inputs
if [ $1 ]; then
    FOLDER=$1
else
    echo "not psychopy project folder specified"
    exit 1;
fi

if [ $2 ]; then
    EXPNAME=$2
else
    echo "no experiment name supplied"
    exit 1;
fi



# check if directory and files exist
if [ ! -d "${FOLDER}" ]; then
    echo "the folder '${FOLDER}' does not exist"
    exit 1;
fi
if [ ! -f "${FOLDER}/index.html" ]; then
    echo "the file '${FOLDER}/index.html does not exist"
    exit 1;
fi
if [ ! -f "${FOLDER}/$EXPNAME.js" ]; then
    echo "the file '${FOLDER}/${EXPNAME}.js' does not exist"
    exit 1;
fi


# (4) Add a psychojs library folder if missing
if [ ! -d "${FOLDER}/lib" ]; then
    echo "the folder '${FOLDER}/lib' does not exist"
    
    # copy psychojs lib
    echo "copy psychojs ${AVAILVERSION} to your project as 'lib' folder"
    cp -r "psychojs/lib-${AVAILVERSION}" "${FOLDER}/lib"
fi

# find psychopy version
PJSVERSION=$(cat "${FOLDER}/${EXPNAME}.js" | grep -o -P '(?<=lib/psychojs-).*(?=.js)')
AVAILVERSION=$(ls -l "${FOLDER}/lib" | grep psychojs | grep ".css" | grep -o -P '(?<=psychojs-).*(?=.css)')

if [ "${PJSVERSION}" != "${AVAILVERSION}" ]; then
    # replace versions
    echo "replace your psychojs ${PJSVERSION} with ${AVAILVERSION}"
    sed -i.bak "s/${PJSVERSION}/${AVAILVERSION}/g" "${FOLDER}/${EXPNAME}.js"
    sed -i.bak "s/${PJSVERSION}/${AVAILVERSION}/g" "${FOLDER}/index.html"
fi


# (5) Copy the PHP server script 
# the purpose of the PHP server script is to receive and store trial data 
# that have been sent from the client webbrowser by the participant.
cp save_trial.php "${FOLDER}/save_trial.php"



if [ $(cat "${FOLDER}/${EXPNAME}.js" | grep "sendToServer" | wc -l) -gt 0 ]; then
    echo "function sendToServer is already added to ${FOLDER}/${EXPNAME}.js"
else
    # (6a) Append Code
    # the file `sendtoserver.js` contains JS code that need to be appended to `${EXPNAME}.js`
    cat sendtoserver.js >> "${FOLDER}/${EXPNAME}.js"

    # (6b) Call sendToServer in quitPsychoJS
    # At the bottom of the `${EXPNAME}.js` file there is a function `quitPsychoJS`.
    # Call the `sendToServer();` function in the first line of `quitPsychoJS`
    LINE="async function quitPsychoJS(message, isCompleted) {"
    sed -i.bak2 "s/${LINE}/${LINE}\\n  sendToServer();/g" "${FOLDER}/${EXPNAME}.js"
fi 
