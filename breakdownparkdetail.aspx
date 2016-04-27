<%@ Page MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="breakdownparkdetail.aspx.cbl" Inherits="batsweb.breakdownparkdetail" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="Scripts/callBatstube.js"></script> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container main-container">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:Panel ID="Panel1" runat="server" >
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-2">
                                <asp:Label ID="parkLabel" runat="server" Font-Size="Medium" Text="Choose Ballpark:"></asp:Label>
                            </div>
                            <div class="col-lg-6">
                                <asp:DropDownList ID="parkDropDownList" OnSelectedIndexChanged="parkDropDownList_SelectedIndexChanged" runat="server" AutoPostBack="True" class="form-control">
                                </asp:DropDownList> 
                            </div>
                            <div class="col-lg-4">
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-lg-8">
                                <asp:ImageButton ID="parkImageButton" runat="server" OnClick="parkImageButton_Click" src="parkdetailpark.aspx" alt="image could not be displayed refresh"/>
                            </div>
                            <div class="col-lg-4">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <asp:Image ID="Image1" runat="server" src="Images/HLKey2.png" alt="image could not be displayed refresh"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4 text-right">
                                        <label>LF:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <asp:Label ID="lfLabel" runat="server" ReadOnly="true" class="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4 text-right">
                                        <label>CF:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <asp:Label ID="cfLabel" runat="server" ReadOnly="true" class="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4 text-right">
                                        <label>RF:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <asp:Label ID="rfLabel" runat="server" ReadOnly="true" class="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4 text-right">
                                        <label>3B:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <asp:Label ID="b3Label" runat="server" ReadOnly="true" class="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4 text-right">
                                        <label>SS:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <asp:Label ID="ssLabel" runat="server" ReadOnly="true" class="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4 text-right">
                                        <label>2B:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <asp:Label ID="b2Label" runat="server" ReadOnly="true" class="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4 text-right">
                                        <label>1B:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <asp:Label ID="b1Label" runat="server" ReadOnly="true" class="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <asp:Button ID="infieldButton" runat="server" Text="Show Infield" OnClick="infieldButton_Click" class="btn btn-primary"/>
                                    </div>
                                </div>
                        <!--    <div class="row">
                                    <div class="col-lg-12">
                                        <asp:Button ID="selectedButton" runat="server" Text="Selected" class="btn btn-primary"/>
                                    </div>
                                </div> -->
                            </div>
                        </div>
                    </div>
                </div>
        </asp:Panel>
    </div>
</asp:Content>