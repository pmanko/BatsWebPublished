<%@ Page AutoEventWireup="true" CodeBehind="mainmenu.aspx.cbl" Inherits="batsweb.mainmenu" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
            height: 80px;
        }
        .auto-style2 {
            width: 133px;
        }
        .auto-style3 {
            width: 133px;
            height: 30px;
        }
        .auto-style4 {
            height: 30px;
            width: 1117px;
        }
        .auto-style5 {
            width: 1117px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:Panel ID="Panel1" runat="server" GroupingText="MAJORS">
            <asp:Panel ID="Panel2" runat="server">
                <table class="auto-style1">
                    <tr>
                        <td class="auto-style2">
                            <asp:Button ID="gamesButton" runat="server" Text="Games" />
                        </td>
                        <td class="auto-style5">
                            <asp:Button ID="Button2" runat="server" Text="Button" />
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style3">
                            <asp:Button ID="Button3" runat="server" Text="Button" />
                        </td>
                        <td class="auto-style4">
                            <asp:Button ID="Button4" runat="server" Text="Button" />
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style2">
                            <asp:Button ID="atbatButton" runat="server" Text="Full at Bat" OnClick="atbatButton_Click" />
                        </td>
                        <td class="auto-style5">
                            <asp:Button ID="Button6" runat="server" Text="Button" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </asp:Panel>
    

    
    </div>
    </form>
</body>
</html>
