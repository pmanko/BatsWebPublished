$(function () {
    if (typeof showModal != 'undefined') {
        $("#changeSelectionModal").modal('show');
    };

    makeServerRequest('reload-pitch-list');
 //   makeServerRequest('mx', "");
});


function callparkdetail() {
    var url = 'breakdownparkdetail.aspx';
    var win = window.open(url, '_blank');
    win.focus();
    //   event.preventDefault();
}

// -----------------------------
// Server Asynchronious Callback 
// -----------------------------

// request flags:
// od - one click dates

// pt - set pitcher team
// bt - set batter team

// lr - player list refresh
// lc - player list changed
// po - player button ok
// sp - select pitcher
// sb - select batter


// pa - pitcher - select all
// ba - batter - select all

// tt - change to pitch types
// tr - change to pitch results

// -----------------------------
// Returns Data from Server after GetCallbackResult code behind function
function GetServerData(arg, context) {
    var splitArgs = arg.split("|");
    var actionFlag = splitArgs[0];

    if (splitArgs.length > 2) {
        alert(splitArgs[2]);
        return;
    }

    if (actionFlag == 'od') {
        oneClickDateSelectionSuccess(splitArgs[1]);
    }
    else if (actionFlag == 'pt' || actionFlag == 'bt') {
        teamSelectionSuccess(splitArgs[1], actionFlag);
    }
    else if (actionFlag == 'pa') {
        pitcherAllSelectionSuccess(splitArgs[1]);
    }
    else if (actionFlag == 'ba') {
        batterAllSelectionSuccess(splitArgs[1]);
    }
    else if (actionFlag == 'lr') {
        playerListRefreshSuccess(splitArgs[1]);
    }
    else if (actionFlag == 'tt' || actionFlag == 'tr') {
        $("#MainContent_previousSzoneImage").attr("src", "/breakdownpreviousszone.aspx?timestamp=" + new Date().getTime());
    }
    else if (actionFlag == 'nt' || actionFlag == 'nr') {
        $("#MainContent_nextSzoneImage").attr("src", "/breakdownnextszone.aspx?timestamp=" + new Date().getTime());
    }
    else if (actionFlag == 'pb') {
        openPreviousModalSuccess(splitArgs[1]);
    }
    else if (actionFlag == 'nb') {
        openNextModalSuccess(splitArgs[1]);
    }
    else if (actionFlag == 'po') {
        playerSelectedSuccess(splitArgs[1]);
    }
    else if (actionFlag == 'reload-pitch-list') {
        populateListboxTable("#pitchListTable", splitArgs[1]);
    }
    else if (actionFlag == 'reload-previous-list') {
        $('#previousPitchTable tbody').empty();
        populateListboxTable("#previousPitchTable", splitArgs[1]);
    }
    else if (actionFlag == 'reload-next-list') {
        // console.log("RELOADING!");
        $('#nextPitchTable tbody').empty();
        populateListboxTable("#nextPitchTable", splitArgs[1]);
    }
    else if (actionFlag == 'mx' || actionFlag == 'sm') {
        console.log("MX RETURN:" + splitArgs[1]);
        $("#maxid").val(splitArgs[1]);
    }
};
// -----------------------------

// -----------------------------
// Max AB

$(document).on("change", "#maxid", function (event) {
    console.log("MAXAB: " + $("#maxid").val());
    makeServerRequest('mx', $("#maxid").val());

});

// Selection Modal

// Pitcher - select all
$(document).on("click", "#pitcherAllButton,#batterAllButton", function (event) {
    // Selects all pitchers
    var requestFlag = $(this).data("playerType") + "a";
    makeServerRequest(requestFlag, "");
});

// Batter - select all


// One-Click Dates
$(document).on("click", "#oneClickDate button", function (event) {
    // Calls server with one-click date parameter and request type flag
    // console.log($(this).data('dateFlag'));
    var requestFlag = "od";
    makeServerRequest(requestFlag, $(this).data('dateFlag'));

});

function oneClickDateSelectionSuccess(dateRange) {
    if (dateRange == "ALL") {
        $("#MainContent_allEndRadioButton").prop("checked", true);
        $("#MainContent_allStartRadioButton").prop("checked", true);
    }
    else {

        var dates = dateRange.split(";");
        console.log(dates);

        $("#MainContent_startDateTextBox").val(dates[0]);
        $("#MainContent_startDateRadioButton").prop("checked", true);

        $("#MainContent_endDateTextBox").val(dates[1]);
        $("#MainContent_endDateRadioButton").prop("checked", true);

    }
    $("#oneClickDateModal").modal('hide');
}

// Team Selection
$(document).on("click", "#teamSelectionOkButton", function (event) {
    // Calls server with one-click date parameter and request type flag
    // console.log($(this).data('dateFlag'));
    var requestFlag = "";
    var modalType = $("#teamSelectionModal #modalType").text();



    console.log(modalType);
    console.log($('#MainContent_pTeamDropDownList :selected').text());

    if (modalType == "pitcher")
        requestFlag = 'pt';
    else if (modalType == "batter")
        requestFlag = 'bt';

    makeServerRequest(requestFlag, $('#MainContent_pTeamDropDownList :selected').text());

});

$(document).on('show.bs.modal', '#teamSelectionModal', function (event) {
    // Set Modal Type - either pitcher or batter
    var button = $(event.relatedTarget); // Button that triggered the modal
    var type = button.data('modalType'); // Extract info from data-* attributes


    var modal = $(this);
    modal.find('#modalType').text(type);

})

// Player Selection
$(document).on('change', "#MainContent_teamDropDownList", function (event) {
    makeServerRequest('lr', $(this).val())
});

$(document).on('show.bs.modal', '#playerSelectionModal', function (event) {
    // Set Modal Type - either pitcher or batter
    var button = $(event.relatedTarget); // Button that triggered the modal
    var type = button.data('modalType');// Extract info from data-* attributes


    var modal = $(this);
    modal.data("type", type);

    $("#MainContent_locatePlayerTextBox").val("");

    if (type == 'pitcher')
        makeServerRequest('sp');
    else
        makeServerRequest('sb');

    makeServerRequest('lr', $("#MainContent_teamDropDownList").val())

});

$(document).on('click', "#selectPlayerButton", function (event) {
    var selectedPlayerInfo;
    // Decide which player value to select
    if (!$("#playerValueField").val()) {
        selectedPlayerInfo = "located;" + $("#MainContent_locatePlayerTextBox").val()
    } else {
        var pIndex = parseInt($("#playerIndexField").val()) + 1
        selectedPlayerInfo = "selected;" + pIndex + ',' + $("#playerValueField").val()
    }
    makeServerRequest("po", selectedPlayerInfo);
});

// Pitch Buttons
$(document).on("click", "#previousResultsButton", function (event) {

    makeServerRequest("tr");
});

$(document).on("click", "#previousButton", function (event) {
    $("#previousModal").modal();
    makeServerRequest('reload-previous-list');
});

$(document).on("click", "#changeSelectionButton", function (event) {
    console.log("MAXAB: " + $("#maxid").val());
    makeServerRequest("sm");
 //   console.log("MX RETURN:" + splitArgs[1]);
  //  $("#maxid").val(splitArgs[1]);
});

$(document).on("click", "#nextResultsButton", function (event) {

    makeServerRequest("nr");
});

$(document).on("click", "#nextButton", function (event) {
    $("#nextModal").modal();
    makeServerRequest('reload-next-list');
});

$(document).on("click", "#nextTypesButton", function (event) {
    makeServerRequest("nt");
});
// Success Callbacks
function teamSelectionSuccess(selectedTeam, typeFlag) {
    console.log("CLOSE: " + selectedTeam);
    if (typeFlag == 'pt')
        $("#MainContent_pitcherSelectionTextBox").val(selectedTeam);
    else
        $("#MainContent_batterSelectionTextBox").val(selectedTeam);
    $("#teamSelectionModal").modal("hide");
}

function pitcherAllSelectionSuccess(pitcherVal) {
    $("#MainContent_pitcherSelectionTextBox").val(pitcherVal);
}

function batterAllSelectionSuccess(batterVal) {
    $("#MainContent_batterSelectionTextBox").val(batterVal);
}

function playerListRefreshSuccess(players) {
    console.log(players.split(';'))
    $("#playerTable tbody").empty();
    $.each(players.split(';'), function (i, playerString) {
        var splitPlayer = playerString.split(',');
        if (splitPlayer.length > 1) {
            $("#playerTable tbody").append('<tr><td></td></tr>');
            $("#playerTable tbody tr:last td:first").html(unescape(splitPlayer[1]));
            $("#playerTable tbody tr:last td:first").data("val", splitPlayer[0]);
        }

    });


}

function openPreviousModalSuccess(listData) {



    $("#previousModal").modal();
    makeServerRequest('reload-previous-list')

}

function openNextModalSuccess(listData) {
    $.each(listData.split(';'), function (i, listItem) {
        $('#MainContent_nextListBox').append($('<option></option>').val(listItem).html(listItem));
    });


    $("#nextModal").modal();
    makeServerRequest('reload-next-list')

}

function playerSelectedSuccess(players) {
    console.log(players.split(';'))
    var playersSplit = players.split(';')
    $("#MainContent_pitcherSelectionTextBox").val(playersSplit[0]);
    $("#MainContent_batterSelectionTextBox").val(playersSplit[1]);

    $("#playerSelectionModal").modal('hide');
}

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function limit(element) {
    var max_chars = 3;

    if (element.value.length > max_chars) {
        element.value = element.value.substr(0, max_chars);
    }
}