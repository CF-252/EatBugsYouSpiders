// asset_family_filename.js
outlets = 1;

var familyID = "";    // current family ID
var stemCounter = 0;  // counts stems within the family

// set the family ID from the raw file name
function setfile(filename) {
    // remove extension if present
    var dotIndex = filename.lastIndexOf(".");
    if (dotIndex != -1) {
        familyID = filename.substring(0, dotIndex);
    } else {
        familyID = filename;
    }
    stemCounter = 1;
    outlet(0, familyID); // optionally output family ID
}

// generate the next stem
function nextstem() {
    if (familyID === "") {
        post("No family set! Use setfile(filename) first.\n");
        return;
    }

    var id = familyID;
    if (stemCounter > 0) { // first stem is family name + counter
        id += "_" + stemCounter; // add underscore before counter
    }
    stemCounter++;
    outlet(0, id);
}

// optional: reset family
function reset() {
    familyID = "";
    stemCounter = 0;
}