<%@ Page MasterPageFile="~/Site.Master" AutoEventWireup="true" Language="C#" CodeBehind="breakdown.aspx.cbl" Inherits="batsweb.breakdown" EnableEventValidation="false" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %> 

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link type="text/css" href="/Styles/breakdown.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/callBatstube.js"></script> 
    <script type="text/javascript" src="Scripts/breakdowncallpark.js"></script> 
    <script type="text/javascript" src="Scripts/breakdown.js"></script> 
    <script type="text/javascript">
        $(document).ready(function () {
            var names = "<%= Session["nameArray"] %>".split(";");
                $("#MainContent_locatePlayerTextBox").autocomplete({
                    autoFocus: true,
                    source: function (request, response) {
                        var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(request.term), "i");
                        response($.grep(names, function (item) {
                            return matcher.test(item);
                        }));
                    }
                });
            });
  </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container main-container">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>


        <!----------------------->
        <!-- Modals and Popups -->
        <!----------------------->
        <div class="modal-container"></div>


        <!-- Change Report Selection Modal -->  
        <div class="modal fade" id="changeSelectionModal" tabindex="-1" role="dialog" aria-labelledby="changeSelectionModal">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">Report Data Selection</h4>
                    </div>                                                      
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        Date Range
                                    </div>
                                    <div class="list-group">
                                        <div class="list-group-item">
                                            <h5>Start Date</h5>
                                            <div class='radio radio-primary'><asp:RadioButton ID="allStartRadioButton" runat="server" GroupName="startDate" text="All Games"  OnCheckedChanged="allStartRadioButton_CheckedChanged"/></div>
                                            <div class='radio radio-primary'><asp:RadioButton ID="startDateRadioButton" runat="server" GroupName="startDate" Text="Start Date:"  OnCheckedChanged="startDateRadioButton_CheckedChanged"/></div>
                                            <asp:TextBox ID="startDateTextBox" runat="server" TextMode="DateTime" class="form-control"></asp:TextBox>
                                            <cc1:MaskedEditExtender ID="startDateTextBox_MaskedEditExtender" runat="server" BehaviorID="startDateTextBox_MaskedEditExtender" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder="" Mask="99/99/99" MaskType="Date" TargetControlID="startDateTextBox" />
                                            <cc1:CalendarExtender ID="startDateTextBox_CalendarExtender" runat="server" Format="MM/dd/yy" BehaviorID="startDateTextBox_CalendarExtender" TargetControlID="startDateTextBox" />
                                        </div>
                                        <div class="list-group-item">
                                            <h5>End Date</h5>
                                            <div class='radio radio-primary'><asp:RadioButton ID="allEndRadioButton" runat="server" GroupName="endDate" Text="All Games" OnCheckedChanged="allEndRadioButton_CheckedChanged"/></div>
                                            <div class='radio radio-primary'><asp:RadioButton ID="endDateRadioButton" runat="server" GroupName="endDate" Text="End Date:" OnCheckedChanged="endDateRadioButton_CheckedChanged"/></div>
                                            <asp:TextBox ID="endDateTextBox" runat="server" TextMode="DateTime"  class="form-control"></asp:TextBox>
                                            <cc1:MaskedEditExtender ID="endDateTextBox_MaskedEditExtender" runat="server" BehaviorID="endDateTextBox_MaskedEditExtender" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder="" Mask="99/99/99" MaskType="Date" TargetControlID="endDateTextBox" />
                                            <cc1:CalendarExtender ID="endDateTextBox_CalendarExtender" runat="server" Format="MM/dd/yy" BehaviorID="endDateTextBox_CalendarExtender" DefaultView="Days" PopupPosition="BottomLeft" TargetControlID="endDateTextBox" />

                                        </div>
                                        <a class="list-group-item list-group-item-info" href="#" data-toggle="modal" data-target="#oneClickDateModal">Date One-Clicks</a>

                                    </div>
                                </div>

                                <div class="panel panel-default">
                                    <div class="panel-heading" role="tab" id="OtherSelPanel">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" href="#otherSelections" aria-expanded="false" aria-controls="otherSelections">
                                                <i class="fa fa-caret-right pull-left"></i>
                                                Other Selections                                                
                                            </a>
                                        </h4>
                                    </div>
                                    <div class="panel-collapse collapse" id="otherSelections">

                                        <div class="list-group">
                                            <div class="list-group-item">
                                                <h5>Location</h5>
                                                <div class='radio radio-primary'><asp:RadioButton ID="allLocRadioButton" runat="server" GroupName="location" text="All Locations" OnCheckedChanged="allLocRadioButton_CheckedChanged" /></div>
                                                <div class='radio radio-primary'><asp:RadioButton ID="pitchHomeRadioButton" runat="server" GroupName="location" text="Pitcher Home/Batter Away" OnCheckedChanged="pitchHomeRadioButton_CheckedChanged" /></div>
                                                <div class='radio radio-primary'><asp:RadioButton ID="pitchAwayRadioButton" runat="server" GroupName="location" text="Pitcher Away/Batter Home" OnCheckedChanged="pitchAwayRadioButton_CheckedChanged" /></div>
                                            </div>
                                            <div class="list-group-item">
                                                <h5>Game Time</h5>
                                                <div class='radio radio-primary radio-inline'><asp:RadioButton ID="allTimeRadioButton" runat="server" GroupName="time" text="All" OnCheckedChanged="allTimeRadioButton_CheckedChanged"/></div>
                                                <div class='radio radio-primary radio-inline'><asp:RadioButton ID="dayRadioButton" runat="server" GroupName="time" text="Day" OnCheckedChanged="dayRadioButton_CheckedChanged"/></div>
                                                <div class='radio radio-primary radio-inline'><asp:RadioButton ID="nightRadioButton" runat="server" GroupName="time" text="Night" OnCheckedChanged="nightRadioButton_CheckedChanged"/></div>
                                            </div>
                                            <div class="list-group-item">
                                                <div class='form-group'>
                                                    <div class='checkbox checkbox-primary'><asp:CheckBox ID="maxAtBatsCheckBox" runat="server" Text="Maximum At Bats:" OnCheckedChanged="maxAtBatsCheckBox_CheckedChanged"/></div>
                                                    <input type="number" name="maxid" id="maxid" onkeypress="return isNumberKey(event)" onkeydown="limit(this);" onkeyup="limit(this);" class="form-control"/>
                                                <!--    <asp:TextBox ID="maxABTextBox" runat="server" class="form-control"></asp:TextBox>      -->                                          
                                                </div>
                                                <div class='checkbox checkbox-primary'><asp:CheckBox ID="myCheckBox" runat="server" Text="My Team's Games Only" OnCheckedChanged="myCheckBox_CheckedChanged"/></div>
                                            </div>
                                        </div>
                                    </div>
                                        
                                </div>
                            </div>                            
                            <div class="col-lg-4">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        Pitcher Choices
                                    </div> 
                                    <div class="panel-body">
                                        <h5>Current Pitcher Selection</h5>
                                        <asp:TextBox ID="pitcherSelectionTextBox" runat="server" style="text-align: left" class="form-control" ReadOnly="True"></asp:TextBox>
                                        <br />
                                        <div class="btn-toolbar" role="toolbar">
                                            <a href="#" class="btn btn-default" id="pitcherAllButton" data-player-type="p">All</a>
                                            <a href="#" class="btn btn-default" data-toggle="modal" data-target="#teamSelectionModal" data-modal-type="pitcher">Team</a>
                                            <a href="#" class="btn btn-default" data-toggle="modal" data-target="#playerSelectionModal" data-modal-type="pitcher">Select Player</a>                                                                                                
                                        </div>

                                    </div>
                                    <div class="list-group">
                                        <div class="list-group-item">
                                            <h5>Throw Selection</h5>
                                            <div class='radio radio-primary'><asp:RadioButton ID="throwsrightRadioButton" runat="server" GroupName="throws" text="Right" OnCheckedChanged="throwsrightRadioButton_CheckedChanged" /></div>
                                            <div class='radio radio-primary'><asp:RadioButton ID="throwsleftRadioButton" runat="server" GroupName="throws" text="Left" OnCheckedChanged="throwsleftRadioButton_CheckedChanged" /></div>
                                            <div class='radio radio-primary'><asp:RadioButton ID="throwseitherRadioButton" runat="server" GroupName="throws" text="Either" OnCheckedChanged="throwseitherRadioButton_CheckedChanged" /></div>

                                        </div>
                                    </div>
                                </div>

                                <div class="panel panel-default">
                                    <div class="panel-heading" role="tab" id="additionalOptionsPanel">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" href="#additionalPitcherOptions" aria-expanded="false" aria-controls="additionalPitcherOptions">
                                                <i class="fa fa-caret-right pull-left"></i>
                                                Additional Pitcher Options                                                
                                            </a>
                                        </h4>
                                    </div>
                                    <div class="panel-collapse collapse" id="additionalPitcherOptions">
                                        <div class="panel-body">
                                                
                                            <div class="row">
                                                <div class="col-lg-2">
                                                    <asp:TextBox ID="pitcheroptionsTextBox" runat="server" style="text-align: left" class="form-control"></asp:TextBox>
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="pitcheranyRadioButton" runat="server" GroupName="pitchertype" text="Any Type" OnCheckedChanged="pitcheranyRadioButton_CheckedChanged" /></div>
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="pitcherbreakingRadioButton" runat="server" GroupName="pitchertype" text="Breaking Ball" OnCheckedChanged="pitcherbreakingRadioButton_CheckedChanged" /></div>
                                                </div> 
                                            </div> 
                                            <div class="row">
                                                <div class="col-lg-2">
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="pitcherpowerRadioButton" runat="server" GroupName="pitchertype" text="Power" OnCheckedChanged="pitcherpowerRadioButton_CheckedChanged" /></div>
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="pitchercustomRadioButton" runat="server" GroupName="pitchertype" text="Custom" OnCheckedChanged="pitchercustomRadioButton_CheckedChanged" /></div>
                                                </div> 
                                            </div> 
                                            <div class="row">
                                                <div class="col-lg-2">
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="pitchercontrolRadioButton" runat="server" GroupName="pitchertype" text="Control" OnCheckedChanged="pitchercontrolRadioButton_CheckedChanged" /></div>
                                                </div> 
                                                <div class="col-lg-5">
                                                </div> 
                                            </div> 
                                        </div>

                                    </div>
                                </div>
                                    
                                <div class="panel panel-default">
                                    <div class="panel-heading" role="tab" id="indivPitchers">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" href="#indivPitcherOptions" aria-expanded="false" aria-controls="indivPitcherOptions">
                                                <i class="fa fa-caret-right pull-left"></i>
                                                For Individual Pitchers Only                                             
                                            </a>
                                        </h4>                                        
                                    </div>
                                    <div class="panel-collapse collapse" id="indivPitcherOptions">
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-lg-2">
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="allinningsRadioButton" runat="server" GroupName="innings" text="All Innings" OnCheckedChanged="allinningsRadioButton_CheckedChanged" /></div>
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="reliefRadioButton" runat="server" GroupName="innings" text="Relief Only" OnCheckedChanged="reliefRadioButton_CheckedChanged" /></div>
                                                </div> 
                                            </div> 
                                            <div class="row">
                                                <div class="col-lg-2">
                                                </div> 
                                                <div class="col-lg-5">
                                                    <div class='radio radio-primary'><asp:RadioButton ID="startinningsRadioButton" runat="server" GroupName="innings" text="Start Only" OnCheckedChanged="startinningsRadioButton_CheckedChanged" /></div>
                                                </div> 
                                            </div>
                                        </div>
                                    </div>


                                </div>
                                        
                                                  
                            </div>

                            <div class="col-lg-4">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                Batter Choices
                                            </div> 
                                            <div class="panel-body">
                                                <h5>Current Batter Selection</h5>
                                                <asp:TextBox ID="batterSelectionTextBox" runat="server" style="text-align: left" class="form-control" ReadOnly="True"></asp:TextBox>
                                                <br />

                                                <div class="btn-toolbar">
                                                    <a href="#" class="btn btn-default" id="batterAllButton" data-player-type="b">All</a>
                                                    <a href="#" class="btn btn-default" data-toggle="modal" data-target="#teamSelectionModal" data-modal-type="batter">Team</a>
                                                    <a href="#" class="btn btn-default" data-toggle="modal" data-target="#playerSelectionModal" data-modal-type="batter">Select Player</a> 
                                                </div> 
                                                        
                                            </div> 

                                            <div class="list-group">

                                                <div class="list-group-item">                                                        
                                                    <h5>Bats</h5>                                                        
                                                    <div class='radio radio-primary'><asp:RadioButton ID="batsrightRadioButton" runat="server" GroupName="bats" text="Right" OnCheckedChanged="batsrightRadioButton_CheckedChanged" /></div>
                                                    <div class='radio radio-primary'><asp:RadioButton ID="batsleftRadioButton" runat="server" GroupName="bats" text="Left" OnCheckedChanged="batsleftRadioButton_CheckedChanged" /></div>
                                                    <div class='radio radio-primary'><asp:RadioButton ID="batseitherRadioButton" runat="server" GroupName="bats" text="Either" OnCheckedChanged="batseitherRadioButton_CheckedChanged" /></div>
                                                </div> 
                                            </div> 
                                        </div>
                                        <div class="panel panel-default">
                                            <div class="panel-heading" role="tab" id="batterOptionsPanel">
                                                <h4 class="panel-title">
                                                    <a class="collapsed" role="button" data-toggle="collapse" href="#additionalBatterOptions" aria-expanded="false" aria-controls="additionalBatterOptions">
                                                        <i class="fa fa-caret-right pull-left"></i>
                                                        Additional Batter Options                                                
                                                    </a>
                                                </h4>
                                            </div>
                                            <div class="panel-collapse collapse" id="additionalBatterOptions">
                                                <div class="panel-body">
                                                    <div class="row">
                                                        <div class="col-lg-2">
                                                            <asp:TextBox ID="batteroptionsTextBox" runat="server" style="text-align: left" class="form-control"></asp:TextBox>
                                                        </div> 
                                                        <div class="col-lg-5">
                                                            <div class='radio radio-primary'><asp:RadioButton ID="batteranyRadioButton" runat="server" GroupName="battertype" text="Any Type" OnCheckedChanged="batteranyRadioButton_CheckedChanged" /></div>
                                                        </div> 
                                                        <div class="col-lg-5">
                                                            <div class='radio radio-primary'><asp:RadioButton ID="battercustomRadioButton" runat="server" GroupName="battertype" text="Custom" OnCheckedChanged="battercustomRadioButton_CheckedChanged" /></div>
                                                        </div> 
                                                    </div> 
                                                    <div class="row">
                                                        <div class="col-lg-2">
                                                        </div> 
                                                        <div class="col-lg-5">
                                                            <div class='radio radio-primary'><asp:RadioButton ID="batterpowerRadioButton" runat="server" GroupName="battertype" text="Power" OnCheckedChanged="batterpowerRadioButton_CheckedChanged" /></div>
                                                        </div> 
                                                        <div class="col-lg-5">
                                                        </div> 
                                                    </div> 
                                                    <div class="row">
                                                        <div class="col-lg-2">
                                                        </div> 
                                                        <div class="col-lg-5">
                                                            <div class='radio radio-primary'><asp:RadioButton ID="battersingleRadioButton" runat="server" GroupName="battertype" text="Single" OnCheckedChanged="battersingleRadioButton_CheckedChanged" /></div>
                                                        </div> 
                                                        <div class="col-lg-5">
                                                        </div> 
                                                    </div> 
                                                </div> 
                                            </div> 
                                        </div> 
                                    </div>
                                </div>
                            </div>
                        </div>
                                                     
                        <div class="row">
                            <div class="col-md-3 col-md-offset-1">
                                <asp:Button ID="resetselectionButton" runat="server" OnClick="resetselectionButton_Click" Text="Reset All Selections" CssClass="btn btn-danger btn-lg btn-block" />
                            </div>
                            <div class="col-md-5 col-md-offset-1">
                                <asp:Button ID="goButton" runat="server" OnClick="goButton_Click" Text="Go-Read These Games!" class="btn btn-lg btn-block btn-primary"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!----------------------->

        <!-- Date One Click Modal -->
        <div class="modal fade" id="oneClickDateModal" tabindex="-1" role="dialog" aria-labelledby="oneClickDateModal">
            <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Dates</h4>
                </div>
                <div class="modal-body">
                <div class="list-group" id="oneClickDate">
                    <button type="button" class="list-group-item" data-date-flag="A">All Games</button>
                    <button type="button" class="list-group-item" data-date-flag="C">Current Season</button>
                    <button type="button" class="list-group-item" data-date-flag="P">Previous Season</button>
                    <button type="button" class="list-group-item" data-date-flag="W">Last 2 Weeks</button>
                    <button type="button" class="list-group-item" data-date-flag="M">Current Month</button>
                    <button type="button" class="list-group-item" data-date-flag="2">Last 2 Months</button>
                    <button type="button" class="list-group-item" data-date-flag="3">Last 3 Months</button>
                </div>
                </div>
            </div>
            </div>
        </div>
        <!----------------------->
            
        <!-- Team Selection Modal -->
        <div class="modal fade" id="teamSelectionModal" tabindex="-1" role="dialog" aria-labelledby="teamSelectionModal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Which <span id="modalType"></span> team?</h4>
                    </div>
                    <div class="modal-body">
                        <asp:DropDownList ID="pTeamDropDownList" runat="server" class="form-control"></asp:DropDownList>
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-default" data-dismiss="modal">Close</a>
                        <a href="#" class="btn btn-primary" id="teamSelectionOkButton">OK</a>
                        <%--<asp:Button ID="pTeamOKButton" runat="server" OnClick="pTeamOKButton_Click" Text="OK" style="margin-left: 60px" class="btn btn-default" />--%>
                    </div>
                        
                </div>
            </div>
        </div>
        <!----------------------->

        <!-- More Click Modal -->
        <div class="modal fade" id="moreModal" tabindex="-1" role="dialog" aria-labelledby="moreModal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Additional Options</h4>
                    </div>
                    <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-default">
                                <div class="panel-heading">    
                                    Velocity          
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class='checkbox checkbox-primary'><asp:CheckBox ID="rangeCheckBox" runat="server" AutoPostBack="True" OnCheckedChanged="rangeCheckBox_CheckedChanged" Text="Check this range only" /></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-2">
                                            <label>From(Low):</label>
                                        </div>
                                        <div class="col-lg-4">
                                            <asp:TextBox ID="lowTextBox" runat="server" class="form-control" MaxLength="3"></asp:TextBox>
                                            <cc1:MaskedEditExtender ID="lowTextBox_MaskedEditExtender" runat="server" AutoComplete="False" BehaviorID="lowTextBox_MaskedEditExtender" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder="" Mask="999" MaskType="Number" PromptCharacter=" " TargetControlID="maxABTextBox" />
                                        </div>
                                        <div class="col-lg-2">
                                            <label>To(Low):</label>
                                        </div>
                                        <div class="col-lg-4">
                                            <asp:TextBox ID="highTextBox" runat="server" class="form-control" MaxLength="3"></asp:TextBox>
                                            <cc1:MaskedEditExtender ID="highTextBox_MaskedEditExtender" runat="server" AutoComplete="False" BehaviorID="highTextBox_MaskedEditExtender" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder="" Mask="999" MaskType="Number" PromptCharacter=" " TargetControlID="maxABTextBox" />
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <asp:Button ID="rangeGoButton" runat="server" OnClick="rangeGoButton_Click" Text="Go" class="btn btn-lg btn-block btn-primary"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label>Score:</label>
                        </div>
                        <div class="col-lg-8">
                            <asp:DropDownList ID="scoredd" runat="server" OnSelectedIndexChanged="scoredd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem>Even</asp:ListItem>
                                <asp:ListItem>+/- 1</asp:ListItem>
                                <asp:ListItem>+/- 2</asp:ListItem>
                                <asp:ListItem>+/- 3</asp:ListItem>
                                <asp:ListItem>Over 3</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label>Fielding:</label>
                        </div>
                        <div class="col-lg-8">
                            <asp:DropDownList ID="fieldingdd" runat="server" OnSelectedIndexChanged="fieldingdd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem>Highlight</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-default">
                                <div class="panel-heading">    
                                    Team Selection          
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class='checkbox checkbox-primary'><asp:CheckBox ID="thisTeamCheckBox" runat="server" AutoPostBack="True" OnCheckedChanged="thisTeamCheckBox_CheckedChanged" Text="Check this range only" /></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-12">
                                        <div class='radio radio-primary radio-inline'><asp:RadioButton ID="pitcherRadioButton" runat="server" GroupName="this" text="Pitcher" OnCheckedChanged="pitcherRadioButton_CheckedChanged"/></div>
                                        <div class='radio radio-primary radio-inline'><asp:RadioButton ID="batterRadioButton" runat="server" GroupName="this" text="Batter" OnCheckedChanged="batterRadioButton_CheckedChanged"/></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-4">
                                            <label>Team:</label>
                                        </div>
                                        <div class="col-lg-8">
                                            <asp:DropDownList ID="thisTeamdd" runat="server" OnSelectedIndexChanged="thisTeamdd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <asp:Button ID="teamGoButton" runat="server" OnClick="teamGoButton_Click" Text="Go" class="btn btn-lg btn-block btn-primary"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </div>
        <!----------------------->

        <!-- Player Selection Modal -->
        <div class="modal fade" id="playerSelectionModal" tabindex="-1" role="dialog" aria-labelledby="playerSelectionModal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Select Player</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class='col-md-12'>
                                <label>Locate Player:</label>
                                <asp:TextBox ID="locatePlayerTextBox" runat="server" class="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class='col-md-12'>
                                <asp:DropDownList ID="teamDropDownList" runat="server" class="form-control" ></asp:DropDownList> 
                                <br />
<%--                                    <select ID="MainContent_playerListBox" size="14" class="form-control" ></select>                       --%>
                                <div class="listbox-replacement-wrapper" id="playerTableWrapper">
                                    <table id="playerTable" class="table table-condensed table-bordered table-hover table-no-grid listbox-replacement listbox-replacement-clickable" 
                                    data-index-field="#playerIndexField" 
                                    data-value-field="#playerValueField" >
                                    <tbody></tbody>
                                    </table>                                
                                    <input type="hidden" name="playerIndexField" id="playerIndexField" />
                                    <input type="hidden" name="playerValueField" id="playerValueField" />
                                </div>

                            </div>
                        </div>
                            
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-default" data-dismiss="modal">Close</a>
                        <a href="#" class="btn btn-primary" id="selectPlayerButton">OK</a>
                    </div>
                        
                </div>
            </div>
        </div>            
        <!----------------------->

        <!-- Previous Pitch Modal -->
        <div class="modal fade" id="previousModal" tabindex="-1" role="dialog" aria-labelledby="PreviousModal">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Previous Pitch</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-lg-4">
                                <asp:Image ID="previousSzoneImage" runat="server" src="breakdownpreviousszone.aspx" alt="image could not be displayed refresh"/>
                            </div>
                            <div class="col-lg-8">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="listbox-replacement-wrapper">
                                            <table id="previousPitchTable" class="table table-condensed table-hover listbox-replacement" >
                                            <tbody id="previousPitchTableBody" runat="server"></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <asp:Button ID="previousPitchesButton" runat="server" OnClick="previousPitchesButton_Click" Text="These Pitches"  class="btn btn-primary" />
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:Button ID="withNextButton" runat="server" OnClick="withNextButton_Click" Text="With Next Pitch"  class="btn btn-primary" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <a href="#" class="btn btn-primary" id="previousResultsButton">Pitch Results</a>
                            </div>
                            <div class="col-lg-4">
                                <a href="#" class="btn btn-primary" id="previousTypesButton">Pitch Types</a>
                            </div>
                            <div class="col-lg-4">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!----------------------->

        <!-- Next Pitch Modal -->
        <div class="modal fade" id="nextModal" tabindex="-1" role="dialog" aria-labelledby="NextModal">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Next Pitch</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-lg-4">
                                <asp:Image ID="nextSzoneImage" runat="server" src="breakdownnextszone.aspx" alt="image could not be displayed refresh"/>
                            </div>
                            <div class="col-lg-8">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="listbox-replacement-wrapper">
                                            <table id="nextPitchTable" class="table table-condensed table-hover listbox-replacement" >
                                            <tbody id="nextPitchTableBody" runat="server"></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <asp:Button ID="nextPitchesButton" runat="server" OnClick="nextPitchesButton_Click" Text="These Pitches"  class="btn btn-primary" />
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:Button ID="withPreviousButton" runat="server" OnClick="withPreviousButton_Click" Text="With Previous Pitch"  class="btn btn-primary" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <a href="#" class="btn btn-primary" id="nextResultsButton">Pitch Results</a>
                            </div>
                            <div class="col-lg-4">
                                <a href="#" class="btn btn-primary" id="nextTypesButton">Pitch Types</a>
                            </div>
                            <div class="col-lg-4">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!----------------------->


        <asp:Panel ID="selectionPanel" runat="server" GroupingText="Report Settings">
            <div class="row">
                <div class="col-lg-9">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Pitcher:</label>
                                    <asp:TextBox ID="pitcherTextBox" runat="server" ReadOnly="true" class="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-6">
                                    <label>Batter:</label>
                                    <asp:TextBox ID="batterTextBox" runat="server" ReadOnly="true" class="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Games:</label>
                                    <asp:TextBox ID="gamesTextBox" runat="server" ReadOnly="true" class="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-6">
                                    <label>Location:</label>
                                    <asp:TextBox ID="locationTextBox" runat="server" ReadOnly="true" class="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <a class="btn btn-lg btn-block btn-primary" id="changeSelectionButton" data-toggle="modal" data-target="#changeSelectionModal">Change Selection</a>
                </div>
                    
            </div>
            <div class="row">
                <div class="col-lg-6">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-4">
                                    <label>Count:</label>
                                    <asp:DropDownList ID="countdd" runat="server" OnSelectedIndexChanged="countdd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <label>Catcher:</label>
                                    <asp:DropDownList ID="catcherdd" runat="server" OnSelectedIndexChanged="catcherdd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <label>Outs:</label>
                                    <asp:DropDownList ID="outsdd" runat="server" OnSelectedIndexChanged="outsdd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-4">
                                    <label>Pitch Loc:</label>
                                    <asp:DropDownList ID="pitchlocdd" runat="server" OnSelectedIndexChanged="pitchlocdd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <label>Runners:</label>
                                    <asp:DropDownList ID="runnersdd" runat="server" OnSelectedIndexChanged="runnersdd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <label>Inn:</label>
                                    <asp:DropDownList ID="inndd" runat="server" OnSelectedIndexChanged="inndd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-4">
                                    <label>Pitch Type:</label>
                                    <asp:DropDownList ID="pitchtypedd" runat="server" OnSelectedIndexChanged="pitchtypedd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <label>Result1:</label>
                                    <asp:DropDownList ID="result1dd" runat="server" OnSelectedIndexChanged="result1dd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-4">
                                </div>
                                <div class="col-lg-4">
                                    <label>Result2:</label>
                                    <asp:DropDownList ID="result2dd" runat="server" OnSelectedIndexChanged="result2dd_SelectedIndexChanged" AutoPostBack="True" class="form-control">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer">
                            <div class="pull-right">
                            <a class="btn btn-info btn-md" data-toggle="modal" data-target="#moreModal">More</a>
                            <asp:Button ID="resetButton" runat="server" Text="Reset" OnClick="resetButton_Click" class="btn btn-danger btn-md"/>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">Pitch List</div>
                        </div>
                            
                        <div class="listbox-replacement-wrapper">
                            <table id="pitchListTable" class="table table-condensed table-hover listbox-replacement" 
                            data-index-field="#MainContent_pitchListIndexField" 
                            data-value-field="#MainContent_pitchListValueField"
                            >           
                                
                            <tbody id="pitchListTableBody" runat="server"></tbody>

                            </table>
                        </div>
                        <asp:HiddenField ID="pitchListValueField" runat="server" />
                        <asp:HiddenField ID="pitchListIndexField" runat="server" />
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-6">
                    <asp:ImageButton ID="szoneImageButton" runat="server" src="breakdownszone.aspx" OnClick="szoneImageButton_Click" alt="image could not be displayed refresh"/>
                </div>
                <div class="col-lg-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">Statistics</div> 
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-4">
                                    <dl class="dl-horizontal dl-horizontal-compact">
                                        <dt>G:</dt>
                                        <dd><asp:Literal ID="gValue" runat="server"></asp:Literal></dd>
                                        <dt>AB:</dt>
                                        <dd><asp:Literal ID="abValue" runat="server"></asp:Literal></dd>
                                        <dt>H:</dt>
                                        <dd><asp:Literal ID="hValue" runat="server"></asp:Literal></dd>
                                        <dt>2B:</dt>
                                        <dd><asp:Literal ID="doubleValue" runat="server"></asp:Literal></dd>
                                        <dt>3B:</dt>
                                        <dd><asp:Literal ID="tripleValue" runat="server"></asp:Literal></dd>
                                        <dt>HR:</dt>
                                        <dd><asp:Literal ID="hrValue" runat="server"></asp:Literal></dd>
                                        <dt>RBI:</dt>
                                        <dd><asp:Literal ID="rbiValue" runat="server"></asp:Literal></dd>
                                        <dt>BB:</dt>
                                        <dd><asp:Literal ID="bbValue" runat="server"></asp:Literal></dd>
                                        <dt>K:</dt>
                                        <dd><asp:Literal ID="kValue" runat="server"></asp:Literal></dd>
                                    </dl>                                        
                                </div>
                                <div class="col-sm-4">
                                    <dl class="dl-horizontal dl-horizontal-compact">
                                        <dt>SAC:</dt>
                                        <dd><asp:Literal ID="sacValue" runat="server"></asp:Literal></dd>
                                        <dt>DP:</dt>
                                        <dd><asp:Literal ID="dpValue" runat="server"></asp:Literal></dd>
                                        <dt>HBP:</dt>
                                        <dd><asp:Literal ID="hbpValue" runat="server"></asp:Literal></dd>
                                        <dt>TPA:</dt>
                                        <dd><asp:Literal ID="tpaValue" runat="server"></asp:Literal></dd>
                                        <dt>&nbsp;</dt>
                                        <dd>&nbsp;</dd>
                                        <dt>AVG:</dt>
                                        <dd><asp:Literal ID="avgValue" runat="server"></asp:Literal></dd>
                                        <dt>OBP:</dt>
                                        <dd><asp:Literal ID="obpValue" runat="server"></asp:Literal></dd>
                                        <dt>SLG:</dt>
                                        <dd><asp:Literal ID="slgValue" runat="server"></asp:Literal></dd>
                                        <dt>OPS:</dt>
                                        <dd><asp:Literal ID="opsValue" runat="server"></asp:Literal></dd>
                                    </dl>                                        
                                </div>
                                <div class="col-sm-4">
                                    <dl class="dl-horizontal dl-horizontal-compact">
                                        <dt>FB:</dt>
                                        <dd><asp:Literal ID="fbValue" runat="server"></asp:Literal></dd>
                                        <dt>GB:</dt>
                                        <dd><asp:Literal ID="gbValue" runat="server"></asp:Literal></dd>
                                        <dt>LD:</dt>
                                        <dd><asp:Literal ID="ldValue" runat="server"></asp:Literal></dd>
                                        <dt>PU:</dt>
                                        <dd><asp:Literal ID="puValue" runat="server"></asp:Literal></dd>
                                        <dt>BU:</dt>
                                        <dd><asp:Literal ID="buValue" runat="server"></asp:Literal></dd>
                                        <dt>&nbsp;</dt>
                                        <dd>&nbsp;</dd>
                                        <dt>Hard:</dt>
                                        <dd><asp:Literal ID="hardValue" runat="server"></asp:Literal></dd>
                                        <dt>Med:</dt>
                                        <dd><asp:Literal ID="medValue" runat="server"></asp:Literal></dd>
                                        <dt>Soft:</dt>
                                        <dd><asp:Literal ID="softValue" runat="server"></asp:Literal></dd>
                                    </dl>                                        
                                </div>
                            </div>


                                
                        </div>
                    </div>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-lg-6">
                    <div class="row">
                        <div class="col-lg-4">
            <!--                <asp:Button ID="clearButton" runat="server" Text="Clear Selected" class="btn btn-primary btn-block"/> -->
                            <asp:Button ID="allButton" runat="server" Text="Play All" OnClick="allButton_Click" class="btn btn-primary btn-block"/>
                        </div>
                        <div class="col-lg-4">
            <!--                <asp:Button ID="selectedButton" runat="server" Text="Selected" class="btn btn-primary btn-block"/> -->
                        </div>
                        <div class="col-lg-4">
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <asp:Image ID="parkImage" runat="server" src="breakdownpark.aspx" alt="image could not be displayed refresh"/>
                </div>
                <div class="col-lg-2">
                    <asp:Button ID="ifButton" runat="server" Text="Infield" OnClick="ifButton_Click" class="btn btn-primary btn-block"/>
                    <asp:Button ID="hlButton" runat="server" Text="Expand Ballpark View" OnClick="hlButton_Click" class="btn btn-primary btn-block"/>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-lg-2">
                    <asp:Button ID="resultsButton" runat="server" Text="Pitch Results" OnClick="resultsButton_Click" class="btn btn-primary btn-block"/>
                </div>
                <div class="col-lg-2">
                    <asp:Button ID="typesButton" runat="server" Text="Pitch Types" OnClick="typesButton_Click" class="btn btn-primary btn-block"/>
                </div>
                <div class="col-lg-2">
                    <asp:Button ID="videosButton" runat="server" Text="Compare Videos" OnClick="videosButton_Click" class="btn btn-primary btn-block"/>
                </div>
                <div class="col-lg-2">
                    <a href="#" class="btn btn-primary btn-block" id="previousButton">Prev. Pitch</a>
                </div>
                <div class="col-lg-2">
                    <a href="#" class="btn btn-primary btn-block" id="nextButton">Next Pitch</a>
                </div>
                <div class="col-lg-2">
                 <!--   <asp:Button ID="printButton" runat="server" Text="Print..." class="btn btn-primary btn-block"/> -->
                </div>
            </div>
        </asp:Panel>                       
    </div>
</asp:Content>