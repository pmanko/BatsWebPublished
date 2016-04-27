<%@ Page MasterPageFile="~/Site.Master" AutoEventWireup="true" Language="C#" CodeBehind="pitchervsbatter.aspx.cbl" Inherits="batsweb.pitchervsbatter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link type="text/css" href="/Styles/pitchervsbatter.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/callBatstube.js"></script> 
    <script type="text/javascript" src="Scripts/pitchervsbatter.js"></script> 
    <script type="text/javascript">
          $(document).ready(function () {
              var names = "<%= Session["nameArray"] %>".split(";");
            $("#MainContent_locateBatterTextBox, #MainContent_locatePitcherTextBox").autocomplete({
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
            <asp:Panel ID="Panel1" runat="server" GroupingText="Report Settings">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Pitcher
                            </div>
                            <div class="panel-body">
                                <label>Team:</label>
                                <asp:DropDownList ID="pTeamDropDownList" OnSelectedIndexChanged="pTeamDropDownList_SelectedIndexChanged" runat="server" AutoPostBack="True" class="form-control" >
                                </asp:DropDownList> 
                                <label>Player:</label>
                                <asp:TextBox ID="pitcherTextBox" runat="server" style="text-align: left" class="form-control" ReadOnly="True"></asp:TextBox>
                          <!--      <asp:Button ID="pitcherButton" runat="server" Text="Select Pitcher" CssClass="btn btn-default" OnClientClick="openPitcherModal();" />-->
                                <a data-toggle="modal" data-target="#showPitcherModal" class="btn btn-default">Select Pitcher</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Batter
                            </div>
                            <div class="panel-body">            
                                <label>Team:</label>
                                <asp:DropDownList ID="bTeamDropDownList" OnSelectedIndexChanged="bTeamDropDownList_SelectedIndexChanged" runat="server" AutoPostBack="True" class="form-control">
                                </asp:DropDownList> 
                                <label>Player:</label>
                                <asp:TextBox ID="batterTextBox" runat="server" class="form-control" ReadOnly="True"></asp:TextBox>
                                <a data-toggle="modal" data-target="#showBatterModal" class="btn btn-default">Select Batter</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-3">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Starting Date
                            </div>
                            <div class="list-group">
                                <div class="list-group-item">
                                    <asp:TextBox ID="TextBox1" runat="server" TextMode="DateTime" class="form-control"></asp:TextBox>
                                    <cc1:MaskedEditExtender ID="TextBox1_MaskedEditExtender" runat="server" BehaviorID="TextBox1_MaskedEditExtender" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder="" Mask="99/99/99" MaskType="Date" TargetControlID="TextBox1" />
                                    <cc1:CalendarExtender ID="TextBox1_CalendarExtender" runat="server" Format="MM/dd/yy" BehaviorID="TextBox1_CalendarExtender" TargetControlID="TextBox1" />
                                    <asp:Button ID="goButton" runat="server" Text="Go" OnClick="goButton_Click" class="btn btn-primary"/>
                                </div>
                           </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                At Bats (Double Click to View)
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="listbox-replacement-wrapper">
                                            <asp:Table id="atBatTable" runat="server" class="table table-condensed table-bordered table-hover table-no-grid listbox-replacement listbox-replacement-clickable" 
                                            data-index-field="#MainContent_atBatIndexField" 
                                            data-value-field="#MainContent_atBatValueField" 
                                            data-postback="false" 
                                            data-multiple="true"
                                            data-on-select="atBatUpdate"
                                            data-on-dblclick="openBatsTube"
                                            >

                                
                                            </asp:Table>
                                        </div>
                                    <asp:HiddenField ID="atBatTableValue" runat="server"  />
                                    <asp:HiddenField ID="atBatIndexField" runat="server"  />  
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <a href="#" id="playAllButton" class="btn btn-lg btn-primary btn-block">Play All</a>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="#" id="showVideosButton" class="btn btn-lg btn-primary btn-block">Play Selected</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <div class="modal" id="showPitcherModal" tabindex="-1" role="dialog" aria-labelledby="ShowPitcherModalLabel">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="row">
                                <div class="col-lg-2">
                                    <asp:Label ID="locatePitcherLabel" runat="server" Font-Size="Medium" Text="Locate Player:"></asp:Label>
                                </div>
                                <div class="col-lg-6">
                                    <div class="ui-widget">
                                        <asp:TextBox ID="locatePitcherTextBox" runat="server" class="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-lg-2">
                                    <asp:Button ID="locatePitcherButton" Text="OK" OnClick="locatePitcherButton_Click" runat="server" class="btn btn-primary"/>
                                </div>
                                <div class="col-lg-2">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                </div>
                            </div>
                        </div>
                        <div class="modal-body"> 
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button1" runat="server" Text="Button1" Visible="False" OnClick="Button1_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button2" runat="server" Text="Button2" Visible="False" OnClick="Button2_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button3" runat="server" Text="Button3" Visible="False" OnClick="Button3_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button4" runat="server" Text="Button4" Visible="False" OnClick="Button4_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button5" runat="server" Text="Button5" Visible="False" OnClick="Button5_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button6" runat="server" Text="Button6" Visible="False" OnClick="Button6_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button7" runat="server" Text="Button7" Visible="False" OnClick="Button7_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button8" runat="server" Text="Button8" Visible="False" OnClick="Button8_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button9" runat="server" Text="Button9" Visible="False" OnClick="Button9_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button10" runat="server" Text="Button10" Visible="False" OnClick="Button10_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button11" runat="server" Text="Button11" Visible="False" OnClick="Button11_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button12" runat="server" Text="Button12" Visible="False" OnClick="Button12_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button13" runat="server" Text="Button13" Visible="False" OnClick="Button13_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button14" runat="server" Text="Button14" Visible="False" OnClick="Button14_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button15" runat="server" Text="Button15" Visible="False" OnClick="Button15_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button16" runat="server" Text="Button16" Visible="False" OnClick="Button16_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button17" runat="server" Text="Button17" Visible="False" OnClick="Button17_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button18" runat="server" Text="Button18" Visible="False" OnClick="Button18_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button19" runat="server" Text="Button19" Visible="False" OnClick="Button19_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button20" runat="server" Text="Button20" Visible="False" OnClick="Button20_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button21" runat="server" Text="Button21" Visible="False" OnClick="Button21_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button22" runat="server" Text="Button22" Visible="False" OnClick="Button22_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button23" runat="server" Text="Button23" Visible="False" OnClick="Button23_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button24" runat="server" Text="Button24" Visible="False" OnClick="Button24_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button25" runat="server" Text="Button25" Visible="False" OnClick="Button25_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button26" runat="server" Text="Button26" Visible="False" OnClick="Button26_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button27" runat="server" Text="Button27" Visible="False" OnClick="Button27_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button28" runat="server" Text="Button28" Visible="False" OnClick="Button28_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button29" runat="server" Text="Button29" Visible="False" OnClick="Button29_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button30" runat="server" Text="Button30" Visible="False" OnClick="Button30_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal" id="showBatterModal" tabindex="-1" role="dialog" aria-labelledby="ShowBatterModalLabel">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="row">
                                <div class="col-lg-2">
                                    <asp:Label ID="locateBatterLabel" runat="server" Font-Size="Medium" Text="Locate Player:"></asp:Label> 
                                </div>
                                <div class="col-lg-6">
                                    <div class="ui-widget">
                                        <asp:TextBox ID="locateBatterTextBox" runat="server" class="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-lg-2">
                                    <asp:Button ID="locateBatterButton" Text="OK" OnClick="locateBatterButton_Click" runat="server" class="btn btn-primary"/>
                                </div>
                                <div class="col-lg-2">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                </div>
                            </div>
                        </div>
                        <div class="modal-body"> 
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button31" runat="server" Text="Button31" Visible="False" OnClick="Button31_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button32" runat="server" Text="Button32" Visible="False" OnClick="Button32_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button33" runat="server" Text="Button33" Visible="False" OnClick="Button33_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button34" runat="server" Text="Button34" Visible="False" OnClick="Button34_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button35" runat="server" Text="Button35" Visible="False" OnClick="Button35_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                               <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button36" runat="server" Text="Button36" Visible="False" OnClick="Button36_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button37" runat="server" Text="Button37" Visible="False" OnClick="Button37_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button38" runat="server" Text="Button38" Visible="False" OnClick="Button38_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button39" runat="server" Text="Button39" Visible="False" OnClick="Button39_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button40" runat="server" Text="Button40" Visible="False" OnClick="Button40_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button41" runat="server" Text="Button41" Visible="False" OnClick="Button41_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button42" runat="server" Text="Button42" Visible="False" OnClick="Button42_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button43" runat="server" Text="Button43" Visible="False" OnClick="Button43_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button44" runat="server" Text="Button44" Visible="False" OnClick="Button44_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button45" runat="server" Text="Button45" Visible="False" OnClick="Button45_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button46" runat="server" Text="Button46" Visible="False" OnClick="Button46_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button47" runat="server" Text="Button47" Visible="False" OnClick="Button47_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button48" runat="server" Text="Button48" Visible="False" OnClick="Button48_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button49" runat="server" Text="Button49" Visible="False" OnClick="Button49_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button50" runat="server" Text="Button50" Visible="False" OnClick="Button50_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                           </div>
                           <div class="row">
                               <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button51" runat="server" Text="Button51" Visible="False" OnClick="Button51_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button52" runat="server" Text="Button52" Visible="False" OnClick="Button52_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button53" runat="server" Text="Button53" Visible="False" OnClick="Button53_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button54" runat="server" Text="Button54" Visible="False" OnClick="Button54_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button55" runat="server" Text="Button55" Visible="False" OnClick="Button55_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button56" runat="server" Text="Button56" Visible="False" OnClick="Button56_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button57" runat="server" Text="Button57" Visible="False" OnClick="Button57_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button58" runat="server" Text="Button58" Visible="False" OnClick="Button58_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button59" runat="server" Text="Button59" Visible="False" OnClick="Button59_Click" class="btn btn-default"/>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <asp:Button ID="Button60" runat="server" Text="Button60" Visible="False" OnClick="Button60_Click" class="btn btn-default"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    </div>
</asp:Content>
