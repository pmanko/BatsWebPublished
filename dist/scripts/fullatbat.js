(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
$(document).on("click", "#show_videos", function (event) {
	if($("#MainContent_ListBox1").val() == null)
	{
		alert("Please select an at-bat");
	}
	else
	{
		batstubeWindow = window.open("batstube.aspx", '_blank');
		batstubeWindow.focus();
	}

    event.preventDefault();
});

// $(document).on("click", "#click_test", function(event) {
// 	alert("HI");
// 	console.log("Sup");
// 	$(this).closest(".panel").parent().hide();
// });
},{}]},{},[1])