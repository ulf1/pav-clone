

/**
 * (1) Append this function to your [experiment name].js file
 * (2) Call this function `sendToServer();` in the 1st line of `quitPsychoJS` 
 */
async function sendToServer(){
    // Deaktiviere dass PsychoJS einen Download triggert (deactivate triggering CSV downloads)
    psychoJS._saveResults = 0; 
    console.log("check:", psychoJS._saveResults)
  
    // Siehe `updateInfo` aber ohne Unterordner (generate a file name for the server)
    let filename = psychoJS._experiment._experimentName + '_' + psychoJS._experiment._datetime + '.csv';
    console.log("check:", filename)
  
    // Lese die Versuchdaten ins CSV-Format aus (get the temporary trial data and copy it into CSV strings)
    let dataObj = psychoJS._experiment._trialsData;
    let dataset = [Object.keys(dataObj[0])].concat(dataObj).map(it => {
        return Object.values(it).toString()
    }).join('\n')
  
    // Zum Server senden
    fetch('save_trial.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            Accept: '*/*',
        },
        body: JSON.stringify({
            filename: filename,
            dataset: dataset,
        }),
    }).then(response => response.json()).then(msg => {
        console.log(msg);  // Zeige Fehlernachricht fürs Debugging
    })
  }

  