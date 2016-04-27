<%@ Page Title="Home Page" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cbl" Inherits="batsweb._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <h2>Welcome to Batsweb!</h2>


    <div class="container">
        <div id="sign-in">
            <h2>Please sign in</h2>
            <asp:label ID="Msg" CssClass="text-danger" runat="server"></asp:label>
            <div class='form-group'>
                <label for="TextBox4" class="sr-only">Team:</label>
                <asp:DropDownList ID="teamDropDownList" runat="server" AutoPostBack="false" class="form-control" >
                    <asp:ListItem>DEMO</asp:ListItem>
                    <asp:ListItem>BLUE JAYS</asp:ListItem>
                    <asp:ListItem>BRAVES</asp:ListItem>
                    <asp:ListItem>BREWERS</asp:ListItem>
                    <asp:ListItem>DODGERS</asp:ListItem>
                    <asp:ListItem>GIANTS</asp:ListItem>
                    <asp:ListItem>MARLINS</asp:ListItem>
                    <asp:ListItem>METS</asp:ListItem>
                    <asp:ListItem>NATIONALS</asp:ListItem>
                    <asp:ListItem>ORIOLES</asp:ListItem>
                    <asp:ListItem>PADRES</asp:ListItem>
                    <asp:ListItem>PIRATES</asp:ListItem>
                    <asp:ListItem>RANGERS</asp:ListItem>
                    <asp:ListItem>RED SOX</asp:ListItem>
                    <asp:ListItem>REDS</asp:ListItem>
                    <asp:ListItem>ROCKIES</asp:ListItem>
                    <asp:ListItem>ROYALS</asp:ListItem>
                    <asp:ListItem>TIGERS</asp:ListItem>
                    <asp:ListItem>TWINS</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class='form-group'>
                <label for="TextBox4" class="sr-only">First Name:</label>
                <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" placeholder="First Name"></asp:TextBox>
            </div>
            <div class='form-group'>
                <label for="TextBox4" class="sr-only">Last Name:</label>
                <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" placeholder="Last Name"></asp:TextBox>
            </div>
            <div class='form-group'>
                <label for="TextBox4" class="sr-only">Password:</label>
                <asp:TextBox ID="TextBox2" runat="server" type="password" CssClass="form-control" placeholder="Password"></asp:TextBox>
            </div>
            <div class='checkbox checkbox-primary'><asp:CheckBox ID="rememberCheckBox" runat="server" AutoPostBack="False" Text="Remember Me" /></div>
            <asp:Button ID="loginButton" runat="server" OnClick="loginButton_Click" Text="Sign In" class="btn btn-lg btn-primary btn-block"/>



        </div>
    </div> <!-- /container -->
</asp:Content>
