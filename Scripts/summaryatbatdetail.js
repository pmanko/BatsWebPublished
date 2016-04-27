$(function() {
    makeServerRequest('reload-pitch-list')
});

// -----------------------------
// Returns Data from Server after GetCallbackResult code behind function
function GetServerData(arg, context) {
    var splitArgs = arg.split("|");
    var actionFlag = splitArgs[0];

    if(splitArgs.length > 2) {
        alert(splitArgs[2]);
        return;
    }

    if (actionFlag == 'reload-pitch-list') {
        populateListboxTable("#pitchListTable", splitArgs[1])
    }
};
// -----------------------------
