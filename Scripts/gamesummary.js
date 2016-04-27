var batstubeWindow;
// Game Selection
// * For now, uses traditional post-backs
//function gamesUpdate() {
//    console.log($("#MainContent_gamesIndexField").val())
//    makeServerRequest("update-game", $("#MainContent_gamesIndexField").val());
//}

// -----------------------------
// Table-Bound Functions
// -----------------------------

// Open Batstube
function openBatsTube() {
    batstubeWindow = window.open("batstube.aspx", '_blank');
	batstubeWindow.focus();
}

function openAtBatDetail() {
    batstubeWindow = window.open("summaryatbatdetail.aspx", '_blank');
    batstubeWindow.focus();
}

// Inning Row Selected
//      On a single click, data is set --> code behind, so that all the vars and video paths are set
//      On a double click, batstube is opened
function inningRowSelected() {
    makeServerRequest("inning-selected", $("#MainContent_inningSummaryIndexField").val());
};

// -----------------------------
// Event Bindings
// -----------------------------


// -----------------------------
// Server Asynchronious Callback
//  * Calls to makeServerRequest 
//  * are handled in GetServerData 
//  * after server callback is 
//  * finished, using same action
//  * flag
// -----------------------------

// Play Home


// Play Vis
// Play Full
// From Selected
$(document).on('click', '.btn-async-request', function (events) {
    makeServerRequest($(this).data("actionFlag"));
    openBatsTube();
});

// Show Detail
$(document).on('click', '#atBatDetail', function (events) {
    makeServerRequest($(this).data("actionFlag"));
    if ($("#MainContent_inningSummaryIndexField").val()) {
        openAtBatDetail();
    }
    
});

// Select Home/Visting Player
$(document).on('click', '#selectHomePlayer', function (events) {
    makeServerRequest('select-home-player');

});

$(document).on('click', '#selectVisitingPlayer', function (events) {
    makeServerRequest('select-visiting-player');

});

$(document).on('click', '#playerButtons .btn', function(event){
    console.log($(this).data("playerId")); 
    if($(this).data("playerType") == "Home") {
        makeServerRequest('home-player-button-click', $(this).data("playerId"));    
    } else {
        makeServerRequest('visiting-player-button-click', $(this).data("playerId"));
    }
    
    openBatsTube();
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

    switch(actionFlag) {
      case 'select-home-player':
        console.log(splitArgs[1]);
        openPlayerModal(splitArgs[1], "Home");
        break;
      case 'select-visiting-player':
        console.log(splitArgs[1]);
        openPlayerModal(splitArgs[1], "Visiting");
        break;        
      default:
        console.log("Default!");
    };
};
// -----------------------------

// -----------------------------
// Callback Functions

function openPlayerModal(playerList, modalType) {
    $("#playerButtons").html("");
    $.each(playerList.split(';') ,function(i, player){
        if(player) {
            $('<a class="btn btn-default">')
            .text(player).data("playerId", i + 1).data("playerType", modalType).appendTo($("#playerButtons"))            
        }
    });
    $("#playerType").text(modalType);
    $("#selectPlayerModal").modal();
}
// -----------------------------