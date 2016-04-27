// atBat Selection
function videoUpdate () {
    console.log($("#MainContent_videoIndexField").val())
    makeServerRequest("update-video", $("#MainContent_videoIndexField").val());
}

// Batstube and atBat List Box
function openBatsTube() {
    if($("#MainContent_videoTable tbody tr.selected").length == 0)
	{
		alert("Please select a video!");
	}
	else
	{
		batstubeWindow = window.open("batstube.aspx", '_blank');
		batstubeWindow.focus();
	}
}

$(document).on("click", "#showVideosButton", function(){
   openBatsTube();
});

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
      case "update-video":
        console.log("UPDATED!");
        break;
      default:
        console.log("Default!");
    };
};
// -----------------------------
