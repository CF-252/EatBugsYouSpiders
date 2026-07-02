autowatch = 1;

function scan(folderPath) {

    var results = [];
    walk(folderPath, results);

    for (var i = 0; i < results.length; i++) {
        outlet(0, results[i]);
    }
}

function walk(path, results) {

    var f = new Folder(path);

    while (!f.end) {

        var name = f.filename;

        if (name && name !== "." && name !== "..") {

            var fullPath = f.pathname + "/" + name;

            if (f.filetype === "fold") {
                walk(fullPath, results);
            }
            else {
                var lower = name.toLowerCase();

                if (lower.indexOf(".wav") === name.length - 4) {
                    results.push(fullPath);
                }
            }
        }

        f.next();
    }
}