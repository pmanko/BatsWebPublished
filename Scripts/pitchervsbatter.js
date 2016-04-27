// Open Player Selection Modal
function openPitcherModal() {
    $("#showPitcherModal").modal();
}
function openBatterModal() {
    $("#showBatterModal").modal();
}

// atBat Selection
function atBatUpdate() {
    console.log($("#MainContent_atBatIndexField").val())
    makeServerRequest("update-at-bat", $("#MainContent_atBatIndexField").val());
}

// Batstube and atBat List Box
function openBatsTube() {
    if ($("#MainContent_atBatTable tbody tr.selected").length == 0) {
        alert("Please select an at-bat!");
    }
    else {
        batstubeWindow = window.open("batstube.aspx", '_blank');
        batstubeWindow.focus();
    }
}

$(document).on("click", "#showVideosButton", function () {
    openBatsTube();
});

$(document).on("click", "#playAllButton", function () {
    makeServerRequest("play-all");
    batstubeWindow = window.open("batstube.aspx", '_blank');
    batstubeWindow.focus();
});
// -----------------------------
// Server Asynchronious Callback 
// -----------------------------

// -----------------------------
// Returns Data from Server after GetCallbackResult code behind function
function GetServerData(arg, context) {
    var splitArgs = arg.split("|");
    var actionFlag = splitArgs[0];

    if (splitArgs.length > 2) {
        alert(splitArgs[2]);
        return;
    }

    switch (actionFlag) {
        case "update-at-bat":
            console.log("UPDATED!");
            break;
        default:
            console.log("Default!");
    };
};
// -----------------------------