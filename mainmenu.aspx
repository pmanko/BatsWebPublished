<%@ Page AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="mainmenu.aspx.cbl" Inherits="batsweb.mainmenu" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent" >
        <br />
        <br />
        <div class="container">
            <div class="row">
                <div id="MAJORS" class="col-md-4">
                    <h2>MAJORS</h2> 
                    <a href="/gameSummary.aspx?league=MA" class="btn btn-default btn-block">Games</a>    
                    <a href="/fullatbat.aspx?league=MA" class="btn btn-default btn-block">Full At Bat</a> 
                    <a href="/pitchervsbatter.aspx?league=MA" class="btn btn-default btn-block">Pitcher vs Batter At Bats</a>    
                    <a href="/breakdown.aspx?league=MA" class="btn btn-default btn-block">Batter/Pitcher Breakdown</a> 
<%--                       
                    <asp:Button ID="pitcherBatterButton" runat="server" Text="Pitcher vs Batter At Bats" OnClick="pitcherBatterButton_Click" CssClass="btn btn-default btn-block" />
                    <asp:Button ID="breakdownButton" runat="server" Text="Batter/Pitcher Breakdown" OnClick="breakdownButton_Click" Width="200px" CssClass="btn btn-default btn-block" />

                    --%>
<%--                    <asp:Button ID="gamesButton" runat="server" Text="Games" OnClick="gamesButton_Click" Width="200px" CssClass="btn btn-default" />
                    <asp:Button ID="atbatButton" runat="server" Text="Full at Bat" OnClick="atbatButton_Click" Width="200px" CssClass="btn btn-default" />

                    </div>
                    <div class="row">
                            <asp:Button ID="Button3" runat="server" Text="Button" Width="200px" CssClass="btn btn-default" />
                    </div>
                    <div class="row">
                            <asp:Button ID="Button6" runat="server" Text="Button" Width="200px" CssClass="btn btn-default" />
                    </div>--%>
                </div>
                <div id="MINORS" class="col-md-4">
                    <h2>MINORS</h2>     
                    <a href="/gameSummary.aspx?league=MI" class="btn btn-default btn-block">Games</a>    
                    <a href="/fullatbat.aspx?league=MI" class="btn btn-default btn-block">Full At Bat</a>
                    <a href="/pitchervsbatter.aspx?league=MI" class="btn btn-default btn-block">Pitcher vs Batter At Bats</a>
                    <a href="/breakdown.aspx?league=MI" class="btn btn-default btn-block">Batter/Pitcher Breakdown</a>
                        
                        
        <%--                        <asp:Button ID="Button7" runat="server" Text="Games" OnClick="Button7_Click" Width="200px" CssClass="btn btn-default"  />--%>
                            <%--<asp:Button ID="Button11" runat="server" Text="Button" OnClick="Button11_Click" Width="200px" CssClass="btn btn-default"  />--%>

                            <%--<asp:Button ID="fullatbatButtonmi" runat="server" OnClick="fullatbatButtonmi_Click" Text="Full At Bat" Width="200px" CssClass="btn btn-default" />--%>
                </div>
                <div id="MISC" class="col-md-4">
                    <h2>MISC</h2>     
                    <a href="/EZvideo.aspx" class="btn btn-default btn-block">EZ Video</a>
                    <a href="/customClips.aspx" class="btn btn-default btn-block">Custom Clips</a>
                    <asp:Button ID="Button12" runat="server" Text="Reload Games" OnClick="Button12_Click" CssClass="btn btn-default btn-block" />
<%--                    <div class="row">
                        <asp:Button ID="EZvideobutton" runat="server" OnClick="EZvideobutton_Click" Text="EZ Video" Width="200px" CssClass="btn btn-default"/>
                        <asp:Button ID="Button12" runat="server" Text="Reload Games" OnClick="Button12_Click" Width="200px" CssClass="btn btn-default" />
                    </div>--%>
            </div>

            </div>
            <br />

            <br />

        </div>    
</asp:Content>