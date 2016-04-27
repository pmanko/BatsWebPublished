<%@ Page MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="summaryatbatdetail.aspx.cbl" Inherits="batsweb.atbatdetail" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="Scripts/callBatstube.js"></script> 
    <script type="text/javascript" src="Scripts/summaryatbatdetail.js"></script> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container main-container">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:Panel ID="Panel6" runat="server" >
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row"><div class="col-md-12"><h4><asp:Literal ID="gameDateAt" runat="server"></asp:Literal></h4></div></div>
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-bordered table-hover">
                                      <thead>
                                          <tr>
                                              <th>Inning: <asp:Literal ID="inning" runat="server"></asp:Literal></th>
                                              <th>R</th>
                                          </tr>
                                      </thead>  
                                      <tbody>
                                          <tr>
                                            <th scope="row"><asp:Literal ID="homeTeam" runat="server"></asp:Literal></th>
                                            <td><asp:Literal ID="homeScore" runat="server"></asp:Literal></td>
                                          </tr>
                                          <tr>
                                            <th scope="row"><asp:Literal ID="visTeam" runat="server"></asp:Literal></th>
                                            <td><asp:Literal ID="visScore" runat="server"></asp:Literal></td>
                                          </tr>
                                      </tbody>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <dl class="dl-horizontal">
                                        <dt>Currently Batting:</dt>
                                        <dd><asp:Literal id="currentlyBatting" runat="server"></asp:Literal></dd>

                                        <dt>Pitcher:</dt>
                                        <dd><asp:Literal ID="pitcher" runat="server"></asp:Literal></dd>

                                        <dt>Batter:</dt>
                                        <dd><asp:Literal ID="batter" runat="server"></asp:Literal></dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-4">
                                    <asp:ImageButton ID="szoneImageButton" runat="server" OnClick="szoneImageButton_Click" src="gamesummaryszone.aspx" alt="image could not be displayed refresh"/>
                                </div>
                                <div class="col-lg-4">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="listbox-replacement-wrapper">
                                                <asp:Table 
                                                id="pitchTable" runat="server" class="table table-condensed table-bordered listbox-replacement" 
                                                >
                                                <asp:TableHeaderRow TableSection="TableHeader">
                                                <asp:TableHeaderCell>## Type Location K Vel * Vid</asp:TableHeaderCell>
                                                </asp:TableHeaderRow>
                                    
                                                </asp:Table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-lg-offset-1">
                                    <asp:Image ID="runnersImage" runat="server" src="summaryrunners.aspx" alt="image could not be displayed refresh"/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-sm-6">
                                    <dl class="dl-horizontal">
                                        <dt>Outs:</dt>
                                        <dd><asp:Literal ID="outsValue" runat="server" ></asp:Literal></dd>
                                        <dt>Hit Type:</dt>
                                        <dd><asp:Literal ID="hitValue" runat="server" ></asp:Literal></dd>
                                        <dt>Result:</dt>
                                        <dd><asp:Literal ID="resultValue" runat="server" ></asp:Literal></dd>
                                        <dt>Final Count:</dt>
                                        <dd><asp:Literal ID="countValue" runat="server" ></asp:Literal></dd>
                                        <dt>RBI:</dt>
                                        <dd><asp:Literal ID="rbiValue" runat="server" ></asp:Literal></dd>
                                        <dt>Fielded By(1):</dt>
                                        <dd><span><asp:Literal ID="posValue1" runat="server" ></asp:Literal>&vert;<asp:Literal ID="fieldedValue1" runat="server" ></asp:Literal>&vert;<asp:Literal ID="flagValue1" runat="server" ></asp:Literal></span></dd>
                                        <dt>Fielded By(2):</dt>
                                        <dd><span><asp:Literal ID="posValue2" runat="server" ></asp:Literal>&vert;<asp:Literal ID="fieldedValue2" runat="server" ></asp:Literal>&vert;<asp:Literal ID="flagValue2" runat="server" ></asp:Literal></span></dd>
                                        <dt>Catcher:</dt>
                                        <dd><asp:Literal ID="catcherValue" runat="server" ></asp:Literal></dd>
                                    </dl>
                                </div>
                                <div class="col-sm-6">
                                    <asp:Image ID="parkImage" runat="server" src="summarypark.aspx" alt="image could not be displayed refresh"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <asp:Button ID="playButton" runat="server" Text="Play At-Bat" OnClick="playButton_Click" class="btn btn-primary btn-block" /> 
                                </div>
                                <div class="col-md-4">
                                </div>
                                <div class="col-md-4">
                                </div>
                            </div>
                        </div>
                    </div>
            </asp:Panel>
    </div>
</asp:Content>
