<%@ Page MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EZvideo.aspx.cbl" Inherits="batsweb.EZvideo" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/Styles/ezvideo.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="Scripts/callBatstube.js"></script> 
    <script type="text/javascript" src="Scripts/ezvideo.js"></script> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container main-container">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <!----------------------->
        <!-- Modals and Popups -->
        <!----------------------->
        <div class="modal-container"></div>
        <div class="modal" id="showDatesModal" tabindex="-1" role="dialog" aria-labelledby="ShowDatesModalLabel">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        Dates
                    </div>
                    <div class="modal-body"> 
                        <div class="row">
                            <div class="col-lg-12">
                                <asp:Button ID="allGamesButton" runat="server" OnClick="allGamesButton_Click" Text="All Games" Width="100%" class="btn btn-default"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <asp:Button ID="currentYearButton" runat="server" OnClick="currentYearButton_Click" Text="Current Season" Width="100%" class="btn btn-default"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <asp:Button ID="pastYearButton" runat="server" OnClick="pastYearButton_Click" Text="Previous Season" Width="100%" class="btn btn-default"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <asp:Button ID="twoWeeksButton" runat="server" OnClick="twoWeeksButton_Click" Text="Last 2 Weeks" Width="100%" class="btn btn-default"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <asp:Button ID="currentMonthButton" runat="server" OnClick="currentMonthButton_Click" Text="Current Month" Width="100%" class="btn btn-default"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <asp:Button ID="twoMonthsButton" runat="server" OnClick="twoMonthsButton_Click" Text="Last 2 Months" Width="100%" class="btn btn-default"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <asp:Button ID="threeMonthsButton" runat="server" OnClick="threeMonthsButton_Click" Text="Last 3 Months" Width="100%" class="btn btn-default"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


            <asp:Panel ID="Panel1" runat="server" GroupingText="Master Video List">
                <div class="row">
                    <div class="col-lg-3">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Start Date
                            </div>
                            <div class="panel-body">   
                                <asp:TextBox ID="TextBox1" runat="server" class="form-control"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="TextBox1_MaskedEditExtender" runat="server" BehaviorID="TextBox1_MaskedEditExtender" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder="" Mask="99/99/99" MaskType="Date" TargetControlID="TextBox1" />
                                <cc1:CalendarExtender ID="TextBox1_CalendarExtender" runat="server" Format="MM/dd/yy" BehaviorID="TextBox1_CalendarExtender" TargetControlID="TextBox1" />
                            </div>
                         </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                End Date
                            </div>
                            <div class="panel-body">   
                                <asp:TextBox ID="TextBox2" runat="server" class="form-control"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="TextBox2_MaskedEditExtender" runat="server" BehaviorID="TextBox2_MaskedEditExtender" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder="" Mask="99/99/99" MaskType="Date" TargetControlID="TextBox2" />
                                <cc1:CalendarExtender ID="TextBox2_CalendarExtender" runat="server" Format="MM/dd/yy" BehaviorID="TextBox2_CalendarExtender" TargetControlID="TextBox2" />
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <a data-toggle="modal" data-target="#showDatesModal" class="btn btn-block btn-info">Date One-Clicks</a>
                    </div>
                    <div class="col-lg-3">
                        <asp:Button ID="Button2" runat="server" Text="Go" OnClick="Button2_Click" CssClass="btn btn-primary btn-block" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="listbox-replacement-wrapper">
                            <asp:Table id="videoTable" runat="server" class="table table-condensed table-bordered table-hover table-no-grid listbox-replacement listbox-replacement-clickable" 
                            data-index-field="#MainContent_videoIndexField" 
                            data-value-field="#MainContent_videoValueField" 
                            data-postback="false" 
                            data-multiple="true"
                            data-on-select="videoUpdate"
                            data-on-dblclick="openBatsTube"
                             >
                            <asp:TableHeaderRow TableSection="TableHeader">
                                <asp:TableHeaderCell> Date          Clip               Description</asp:TableHeaderCell>
                            </asp:TableHeaderRow>
                                    
                            </asp:Table>
                        </div>
                        <asp:HiddenField ID="videoValueField" runat="server"  />
                        <asp:HiddenField ID="videoIndexField" runat="server"  />               
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Sort By:
                            </div>
                            <div class="panel-body">   
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class='radio radio-primary'><asp:RadioButton ID="RadioButtonTeam" runat="server" Text="Team" AutoPostBack="True" OnCheckedChanged="RadioButtonTeam_CheckedChanged" GroupName="sort" /></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class='radio radio-primary'><asp:RadioButton ID="RadioButtonName" runat="server" Text="Name" AutoPostBack="True" OnCheckedChanged="RadioButtonName_CheckedChanged" GroupName="sort" /></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class='radio radio-primary'><asp:RadioButton ID="RadioButtonDate" runat="server" Text="Newest Date" AutoPostBack="True" OnCheckedChanged="RadioButtonDate_CheckedChanged" GroupName="sort" /></div>
                                    </div>
                                </div>
                            </div>
                         </div>
                     </div>
                    <div class="col-lg-6">
                        <a href="#" id="showVideosButton" class="btn btn-lg btn-primary btn-block">Play Selected</a>
                    </div>
                </div>
            </asp:Panel>
    </div>
</asp:Content>
