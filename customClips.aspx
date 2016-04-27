<%@ Page MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="customClips.aspx.cbl" Inherits="batsweb.customClips" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/Styles/customclips.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="Scripts/callBatstube.js"></script> 
    <script type="text/javascript" src="Scripts/customclips.js"></script> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container main-container">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:Panel ID="Panel1" runat="server" GroupingText="Master Video List">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-default">
                            <div class="panel-body">   
                                <div class="listbox-replacement-wrapper">
                                    <asp:Table id="videoTable" runat="server" class="table table-condensed table-bordered table-hover table-no-grid listbox-replacement listbox-replacement-clickable" 
                                    data-index-field="#MainContent_videoIndexField" 
                                    data-value-field="#MainContent_videoValueField" 
                                    data-postback="false" 
                                    data-multiple="true"
                                    data-on-select="videoUpdate"
                                    data-on-dblclick="openBatsTube"
                                    >
                                    </asp:Table>
                                </div>
                                <asp:HiddenField ID="videoValueField" runat="server"  />
                                <asp:HiddenField ID="videoIndexField" runat="server"  />               
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Find:
                            </div>
                            <div class="panel-body">   
                                <div class="row">
                                    <div class="col-lg-12">
                                        <asp:TextBox ID="findTextBox" runat="server" class="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <asp:Button ID="goButton" runat="server" Text="Go" OnClick="goButton_Click" CssClass="btn btn-primary btn-block" />
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:Button ID="clearButton" runat="server" Text="Clear" OnClick="clearButton_Click" CssClass="btn btn-primary btn-block" />
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