// atBat Selection
function gamesUpdate () {
    console.log($("#MainContent_gamesIndexField").val())
    makeServerRequest("update-game", $("#MainContent_gamesIndexField").val());
}

// Batstube and atBat List Box
function openBatsTube() {
    if($("#MainContent_atBatTable tbody tr.selected").length == 0)
	{
		alert("Please select an at-bat!");
	}
	else
	{
		batstubeWindow = window.open("batstube.aspx", '_blank');
		batstubeWindow.focus();
	}
}

function showInnings() {
        makeServerRequest("show-innings", $("#MainContent_gamesIndexField").val());
	}
}

$(document).on("click", "#showVideosButton", function(){
   openBatsTube();
});

// Open Player Selection Modal
function openModal() {
    $("#showPlayerModal").modal();
}
function openPTeamModal() {
    $("#showPTeamModal").modal();
}
function openBTeamModal() {
    $("#showBTeamModal").modal();
}
function openDatesModal() {
    $("#showDatesModal").modal();
}

// -----------------------------
// Server Asynchronious Callback
// -----------------------------

// -----------------------------
// Returns Data from Server after GetCallbackResult code behind function
function GetServerData(arg, context) {
    var splitArgs = arg.split("|");
    var actionFlag = splitArgs[0];

    if(splitArgs.length > 2) {
        alert(splitArgs[2]);
        return;
    }

    switch(actionFlag) {
      case "update-at-bat":
        console.log("UPDATED!");
        break;
      default:
        console.log("Default!");
    };
};
// -----------------------------
