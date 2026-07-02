// clear_stems.js — deletes all WAV files in data/stems/
outlets = 1;

// Path computed relative to patch — works on any machine.
function getDataDir() {
    var p = patcher.filepath;
    var slash = p.indexOf('/');
    if (slash > 0) p = p.slice(slash);
    p = p.replace(/[^\/]+$/, '');    // strip filename  → .../src/max/
    p = p.replace(/[^\/]+\/$/, ''); // strip max/      → .../src/
    p = p.replace(/[^\/]+\/$/, ''); // strip src/      → .../EBYS/
    return p + 'data/';
}
var folderPath = getDataDir() + "stems";

function clear() {
    var f = new Folder(folderPath);

    if (!f) {
        post("Cannot open folder: " + folderPath + "\n");
        return;
    }

    f.reset();
    var fname = f.filename;

    while (fname !== null) {
        try {
            // Only delete .wav files (stems)
            if (!fname.startsWith(".") && fname.endsWith(".wav")) {
                var filePath = folderPath + "/" + fname;
                var fileObj = new File(filePath, "write", "TEXT");
                if (fileObj.isopen) {
                    fileObj.close();
                }
                // Delete file
                var deleted = File.remove(filePath);
                if (deleted)
                    post("Deleted: " + fname + "\n");
                else
                    post("Failed to delete: " + fname + "\n");
            }
        } catch (e) {
            post("Error handling file: " + fname + "\n");
        }

        if (!f.next()) break;
        fname = f.filename;
    }

    f.close();
    post("Stem folder cleared.\n");
}