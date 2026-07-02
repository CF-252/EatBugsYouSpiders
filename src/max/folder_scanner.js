// folder_scanner.js
outlets = 1;

function scan(path) {
    var folder = new Folder(path);
    if (!folder || folder.end) {
        post("Could not open folder: " + path + "\n");
        return;
    }

    while (!folder.end) {
        var fname = folder.filename;

        // filter only audio files (wav, aif, aiff, mp3)
        if (fname.match(/\.(wav|aif|aiff|mp3)$/i)) {
            outlet(0, fname); // send to ingestion JS
        }

        folder.next();
    }

    folder.close();
    post("Folder scan complete.\n");
}