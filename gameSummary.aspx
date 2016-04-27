<%@ Page MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="gameSummary.aspx.cbl" Inherits="batsweb.gameSummary" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link type="text/css" href="/Styles/gamesummary.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/gamesummary.js"></script> 
    <script type="text/javascript" src="Scripts/callBatstube.js"></script> 
    <script type="text/javascript" src="Scripts/summarycallatbat.js"></script> 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container main-container">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <div class="panel panel-default" id="gamesPanel">
                <div class="panel-heading">
                    <div class="panel-title">List of Games</div>
                </div>
                <div class="listbox-replacement-wrapper">

                    <asp:Table id="gamesTable" runat="server" class="table table-condensed table-bordered table-hover table-no-grid listbox-replacement listbox-replacement-clickable" 
                                data-index-field="#MainContent_gamesIndexField" 
                                data-value-field="#MainContent_gamesValueField" 
                                data-postback="double" 
                                data-multiple="false"
                    >
                    <asp:TableHeaderRow TableSection="TableHeader">
                        <asp:TableHeaderCell>Date      Vis                      Home                   Time Video</asp:TableHeaderCell>
                    </asp:TableHeaderRow>
                                
                    </asp:Table>
                </div>
                <asp:HiddenField ID="gamesValueField" runat="server" onvaluechanged="gameSelected" />
                <asp:HiddenField ID="gamesIndexField" runat="server"   />
                <br />
                <div class="panel-footer">

                    <div class="row">
                    <div class="col-md-3">
                        <div class='radio radio-primary'>
                            <asp:RadioButton ID="allRadioButton" runat="server" GroupName="Games" Text="All Games" AutoPostBack="True" OnCheckedChanged="allRadioButton_CheckedChanged" />
                        </div>
                                                    
                        <div class='form-group'>
                        <label>Year:</label>
                        <asp:DropDownList ID="yearDropDownList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="yearDropDownList_SelectedIndexChanged" class="form-control">
                            <asp:ListItem>2020</asp:ListItem>
                            <asp:ListItem>2019</asp:ListItem>
                            <asp:ListItem>2018</asp:ListItem>
                            <asp:ListItem>2017</asp:ListItem>
                            <asp:ListItem>2016</asp:ListItem>
                            <asp:ListItem>2015</asp:ListItem>
                            <asp:ListItem>2014</asp:ListItem>
                            <asp:ListItem>2013</asp:ListItem>
                            <asp:ListItem>2012</asp:ListItem>
                            <asp:ListItem>2011</asp:ListItem>
                            <asp:ListItem>2010</asp:ListItem>
                            <asp:ListItem>2009</asp:ListItem>
                            <asp:ListItem>2008</asp:ListItem>
                            <asp:ListItem>2007</asp:ListItem>
                            <asp:ListItem>2006</asp:ListItem>
                            <asp:ListItem>2005</asp:ListItem>
                            <asp:ListItem>2004</asp:ListItem>
                            <asp:ListItem>2003</asp:ListItem>
                            <asp:ListItem>2002</asp:ListItem>
                            <asp:ListItem>2001</asp:ListItem>
                            <asp:ListItem>2000</asp:ListItem>
                            <asp:ListItem>1999</asp:ListItem>
                            <asp:ListItem>1998</asp:ListItem>
                            <asp:ListItem>1997</asp:ListItem>
                            <asp:ListItem>1996</asp:ListItem>
                            <asp:ListItem>1995</asp:ListItem>
                            <asp:ListItem>1994</asp:ListItem>
                            <asp:ListItem>1993</asp:ListItem>
                            <asp:ListItem>1992</asp:ListItem>
                            <asp:ListItem>1991</asp:ListItem>
                        </asp:DropDownList></div>

                    </div>
                    <div class="col-md-3 col-md-offset-1">

                        <div class='radio radio-primary'><asp:RadioButton ID="teamRadioButton" runat="server" GroupName="Games" Text="Team:" AutoPostBack="True" OnCheckedChanged="teamRadioButton_CheckedChanged" /></div>
                        <asp:DropDownList ID="teamDropDownList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="teamDropDownList_SelectedIndexChanged" class="form-control">
                        </asp:DropDownList>
                        
                        <div class='radio radio-primary'>
                            <asp:RadioButton ID="nlRadioButton" runat="server" GroupName="Games" Text="National League" AutoPostBack="True" OnCheckedChanged="nlRadioButton_CheckedChanged"
                            />
                        </div>
                        <div class='radio radio-primary'>
                            <asp:RadioButton ID="alRadioButton" runat="server" GroupName="Games" Text="American League" AutoPostBack="True" OnCheckedChanged="alRadioButton_CheckedChanged"
                            />
                        </div>
                        
                    </div>
                    <div class="col-md-3 col-md-offset-1">
                        <div class='checkbox checkbox-primary'>
                            <asp:CheckBox ID="pitchersCheckBox" runat="server" Text="Show Starting Pitchers" AutoPostBack="True" OnCheckedChanged="pitchersCheckBox_CheckedChanged"
                            />
                        </div>
                        
                        <asp:Button ID="Button1" runat="server" Text="Show Innings" OnClick="inningsButton_Click" class="btn btn-primary btn-block" />
                <%--        <asp:Label ID="label1" runat="server" Text="test"></asp:Label>--%>
                       </div>
                </div>
                </div>

            </div>

            <br />

            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="panel-title">Inning Summary</div>
                </div>
                <div class="listbox-replacement-wrapper">
                    <asp:Table id="inningSummaryTable" runat="server" class="table table-condensed table-bordered table-hover table-no-grid listbox-replacement listbox-replacement-clickable" 
                    data-value-field="#MainContent_inningSummaryValueField" 
                    data-index-field="#MainContent_inningSummaryIndexField" 
                    data-postback="false" 
                    data-multiple="false"
                    data-on-select="inningRowSelected"
                    data-on-dblclick="openBatsTube"
                    >
                                                                     
                    </asp:Table>
                </div>
                <asp:HiddenField ID="inningSummaryValueField" runat="server" />
                <asp:HiddenField ID="inningSummaryIndexField" runat="server"  />
                                    
                <div class="panel-footer">
                    <div class='row'>
                        <div class="col-md-6">
                            <a href="#" class="btn btn-block btn-default" id="atBatDetail" data-action-flag="show-detail">At Bat Detail</a>
                        </div>
                        <div class="col-md-6">
                            <a href="#" class="btn btn-block btn-primary btn-async-request" data-action-flag="play-sel">Play Selected</a>
                        </div>
                    <div class="clearfix"></div>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class='panel-body'>
                    <div class='row'>
                        <div class="col-md-3">
                            <a href="#" class="btn btn-block btn-primary btn-async-request" data-action-flag="play-vis">Play Visitors</a>
                        </div>
                        <div class="col-md-3">
                            <a href="#" class="btn btn-block btn-primary btn-async-request" data-action-flag="play-home">Play Home</a>
                        </div>
                        <div class="col-md-3">
                            <a href="#" class="btn btn-block btn-primary btn-async-request" data-action-flag="from-selected">From Selected</a>
                        </div>
                        <div class="col-md-3">
                            <a href="#" class="btn btn-block btn-primary btn-async-request" data-action-flag="play-full">Play Full</a>
                        </div>
                    </div>
                    <br />
                    <div class='row'>
                        <div class="col-md-3">
                            <a href="#" id="selectVisitingPlayer" class="btn btn-default btn-block">Select Visiting Player</a>
                        </div>
                        <div class="col-md-3">
                            <a href="#" class="btn btn-default btn-block" data-toggle="modal" data-target="#statsModal">View Game Stats</a>
                        </div>
                        <div class="col-md-3">
                     <!--       <asp:Button ID="replaysButton" runat="server" Text="Replays" class="btn btn-default btn-block" /> -->
                        </div>
                        <div class="col-md-3">
                            <a href="#" id="selectHomePlayer" class="btn btn-default btn-block">Select Home Player</a>
                        </div>
                    </div>
                </div>
                    
            </div>



        <!-- Stats Modal -->

        <div class="modal fade" id="statsModal" tabindex="-1" role="dialog" aria-labelledby="statsModalLabel">
          <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="statsModalLabel">Current Game Stats</h4>
              </div>
              <div class="modal-body">
                <div class="listbox-replacement-wrapper">
                  <asp:Table id="statsTable" runat="server" class="table table-condensed table-bordered table-hover listbox-replacement"></asp:Table>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>

        <!-- Select Player Modal -->

        <div class="modal fade" id="selectPlayerModal" tabindex="-1" role="dialog" aria-labelledby="selectPlayerModalLabel">
          <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">View all clips for <span id="playerType"></span> Player</h4>
              </div>
              <div class="modal-body">
                <div id="playerButtons" class="">

                </div>

              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>

    </div>
</asp:Content>
