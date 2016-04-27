// -----------------------------
// List Box Replacement
// -----------------------------
$(document).on('click', 'table.listbox-replacement-clickable tbody tr', function (event) {
    $(this).toggleClass("selected");
    console.log("SINGLE!")
    
    var attrs = getTableAttributes(this);

    console.log(attrs);
    

    setTableValues(this, attrs);


    if (attrs.selectFn){
        window[attrs.selectFn]();
    }

    if (attrs.selected && attrs.postback == "single" && !attrs.multiple) {
        __doPostBack();
    }
   

});

$(document).on("dblclick", "table.listbox-replacement-clickable tbody tr", function (event) {
    $(this).toggleClass("selected");
    console.log("DOUBLE!!");
    
    var attrs = getTableAttributes(this);
    
    setTableValues(this, attrs, "double");

    if (attrs.selected && attrs.selectFn){
        window[attrs.selectFn]();
    }
    
    if (attrs.dblclickFn && attrs.selected) {
        window[attrs.dblclickFn]();    
    }
    
    if (attrs.selected && attrs.postback == "double") {
        __doPostBack();
    }
   
});

function setTableValues(target, attrs, clicktype) {
    if (clicktype === undefined) {
        clicktype = "single";
    }
    
    console.log(attrs.multiple);
    console.log(clicktype);
    console.log(attrs.selected);
    
    if ((!attrs.multiple || clicktype == "double") && attrs.selected) {

        $(target).siblings().removeClass("selected");
    }
    
    if (attrs.multiple && clicktype == 'single') {
        attrs.valField.val(attrs.values.join(';'));
        attrs.iField.val(attrs.indeces.join(';'));
    } else {    
        attrs.valField.val(unescape(attrs.value));
        attrs.iField.val(attrs.index);
    }
}

function getTableAttributes(targetRow) {
    var myRow = $(targetRow);
    var myTable = myRow.closest("table");

    var returnObj = {
        table: myTable,
        value: myRow.find("td:first").html(),
        index: myRow.index(),
        values: myRow.parent().children(".selected").map(function () { return unescape($(this).text()) }).get(),
        indeces: myRow.parent().children(".selected").map(function() { return $(this).index() }).get(),
        valField: $(myTable.data('valueField')),
        iField: $(myTable.data('indexField')),
        postback: myTable.data("postback"),
        multiple: myTable.data("multiple"),
        selected: myRow.hasClass("selected"),
        dblclickFn: myTable.data("onDblclick"),
        selectFn: myTable.data("onSelect") 
    };
    
    return returnObj;    
};

function populateListboxTable(tableId, rowData) {
    $.each(rowData.split(";"), function (i, row) {
        if (row != "") {
            // console.log($(tableId + ' tbody'));
            $(tableId + ' tbody').append('<tr><td></td></tr>');
            $(tableId + ' tbody tr:last td:first').html(unescape(row));
        }

    });

}

