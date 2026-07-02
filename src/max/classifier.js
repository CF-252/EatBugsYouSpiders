autowatch = 1;

function classify(path) {

    var lower = path.toLowerCase();

    if (lower.indexOf("drums.wav") !== -1) {
        outlet(0, "drums " + path);
    }
    else if (
        lower.indexOf("bass.wav") !== -1 ||
        lower.indexOf("other.wav") !== -1 ||
        lower.indexOf("vocals.wav") !== -1
    ) {
        outlet(0, "instruments " + path);
    }
}