      $set ilusing "System.Collections.Generic";
      $set ilusing "System.Linq";
      $set ilusing "System.Web";
      $set ilusing "System.Web.UI";
      $set ilusing "System.Web.UI.WebControls";
       class-id batsweb.pitchervsbatter is partial 
                implements type System.Web.UI.ICallbackEventHandler
                inherits type System.Web.UI.Page public.
     
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
          SELECT PLAY-FILE ASSIGN LK-PLAYER-FILE
              ORGANIZATION IS INDEXED
              ACCESS IS DYNAMIC
              RECORD KEY IS PLAY-KEY
              ALTERNATE KEY IS PLAY-ALT-KEY WITH DUPLICATES
              LOCK MANUAL
              FILE STATUS IS STATUS-COMN.
       DATA DIVISION.
       FILE SECTION.
       COPY "Y:\SYDEXSOURCE\FDS\FDPLAY.CBL".
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       copy "y:\sydexsource\bats\WSBATF.CBL".
       01 bat766rununit         type RunUnit.
       01 BAT766WEBF                type BAT766WEBF.
       01 mydata type batsweb.bat766Data.
       01 abnum        type Single.
       01 fn           type String.
       01  WS-NETWORK-FLAG             PIC X       VALUE SPACES.
       01 playerName      type String.
       01 nameArray      type String.       
       01 callbackReturn type String.
       method-id Page_Load protected.
       local-storage section.
       01 cm type ClientScriptManager.
       01 cbReference type String.
       01 callbackScript type String.       
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
      * #### ICallback Implementation ####
           set cm to self::ClientScript
           set cbReference to cm::GetCallbackEventReference(self, "arg", "GetServerData", "context")
           set callbackScript to "function CallServer(arg, context)" & "{" & cbReference & "};"
           invoke cm::RegisterClientScriptBlock(self::GetType(), "CallServer", callbackScript, true)
           
           if self::IsPostBack       
               exit method.

      * #### End ICallback Implement  ####               
        
      *    Setup - from main menu
           set self::Session::Item("database") to self::Request::QueryString["league"]
           if   self::Session["bat766data"] = null
              set mydata to new batsweb.bat766Data
              invoke mydata::populateData
              set self::Session["bat766data"] to mydata
           else
               set mydata to self::Session["bat766data"] as type batsweb.bat766Data.
               
           
           if  self::Session::Item("766rununit") not = null
               set bat766rununit to self::Session::Item("766rununit")
                   as type RunUnit
               else
               set bat766rununit to type RunUnit::New()
               set BAT766WEBF to new BAT766WEBF
               invoke bat766rununit::Add(BAT766WEBF)
               set self::Session::Item("766rununit") to  bat766rununit.
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           move "I" to BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert(ERROR-FIELD);", true)
               move spaces to ERROR-FIELD.
           set BAT766-GAME-FLAG to "D"
           SET LK-PLAYER-FILE TO BAT766-WF-LK-PLAYER-FILE
           open input play-file.
           initialize play-alt-key
           start play-file key > play-alt-key.
           move 1 to aa.     
       5-loop.
           read play-file next
               at end go to 10-done.
           move spaces to playerName
           string play-last-name, ", " play-first-name
               delimited "  " into playerName
           set nameArray to nameArray & playerName & ";"
           add 1 to aa
           go to 5-loop.
       10-done.
           close play-file.
PM         set self::Session::Item("nameArray") to nameArray
           set pitcherTextBox::Text to BAT766-PITCHER-DSP-NAME::Trim
           set batterTextBox::Text to BAT766-BATTER-DSP-NAME::Trim
      *     set bTeamDropDownList::Text to BAT766-BATTER-TEAM::Trim
      *     set pTeamDropDownList::Text to BAT766-PITCHER-TEAM::Trim
           set textBox1::Text to BAT766-GAME-DATE::ToString("00/00/00")
           move 1 to aa.     
       15-loop.
          if aa > BAT766-NUM-TEAMS
               go to 20-done
          else
               invoke pTeamDropDownList::Items::Add(BAT766-TEAM-NAME(aa)).
               invoke bTeamDropDownList::Items::Add(BAT766-TEAM-NAME(aa)).
          add 1 to aa
          go to 15-loop.
       20-done.    
           invoke self::populatePitcher
           invoke self::populateBatter
           goback.
       end method.
       
      *#####               Client Callback Implementation             #####
      *##### (https://msdn.microsoft.com/en-us/library/ms178208.aspx) #####
      *####################################################################
 
       method-id RaiseCallbackEvent public.
       local-storage section.
       01 actionFlag type String.
       01 methodArg type String.       

       procedure division using by value eventArgument as String.
           unstring eventArgument
               delimited by "|"
               into actionFlag, methodArg
           end-unstring.
           
           if actionFlag = "update-at-bat"
               set callbackReturn to actionFlag & "|" & self::atBat_Selected(methodArg)
           else if actionFlag = "play-all"
               set callbackReturn to actionFlag & "|" & self::playAll.
           
       end method.
       
       method-id GetCallbackResult public.
       procedure division returning returnToClient as String.
       
           set returnToClient to callbackReturn.
           
       end method.
      *####################################################################
       
       method-id pTeamDropDownList_SelectedIndexChanged protected.
       local-storage section.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           invoke self::populatePitcher
       end method.
       
       method-id populatePitcher protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".       
       procedure division.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set bat766rununit to self::Session::Item("766rununit")
               as type RunUnit
           SET BAT766-PITCHER-TEAM TO pTeamDropDownList::SelectedItem
           MOVE "RP" to BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")  
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.
           if BAT766-P-ROSTER-NAME(1) not = spaces
               set Button1::Visible to true
               set Button1::Text to BAT766-P-ROSTER-NAME(1)::Trim
           else
               set Button1::Visible to false. 
           if BAT766-P-ROSTER-NAME(2) not = spaces
               set Button2::Visible to true
               set Button2::Text to BAT766-P-ROSTER-NAME(2)::Trim
           else
               set Button2::Visible to false. 
           if BAT766-P-ROSTER-NAME(3) not = spaces
               set Button3::Visible to true
               set Button3::Text to BAT766-P-ROSTER-NAME(3)::Trim 
           else
               set Button3::Visible to false. 
           if BAT766-P-ROSTER-NAME(4) not = spaces
               set Button4::Visible to true
               set Button4::Text to BAT766-P-ROSTER-NAME(4)::Trim 
           else
               set Button4::Visible to false.            
           if BAT766-P-ROSTER-NAME(5) not = spaces
               set Button5::Visible to true
               set Button5::Text to BAT766-P-ROSTER-NAME(5)::Trim 
           else
               set Button5::Visible to false.            
           if BAT766-P-ROSTER-NAME(6) not = spaces
               set Button6::Visible to true
               set Button6::Text to BAT766-P-ROSTER-NAME(6)::Trim 
           else
               set Button6::Visible to false.            
           if BAT766-P-ROSTER-NAME(7) not = spaces
               set Button7::Visible to true
               set Button7::Text to BAT766-P-ROSTER-NAME(7)::Trim 
           else
               set Button7::Visible to false.            
           if BAT766-P-ROSTER-NAME(8) not = spaces
               set Button8::Visible to true
               set Button8::Text to BAT766-P-ROSTER-NAME(8)::Trim 
           else
               set Button8::Visible to false.            
           if BAT766-P-ROSTER-NAME(9) not = spaces
               set Button9::Visible to true
               set Button9::Text to BAT766-P-ROSTER-NAME(9)::Trim 
           else
               set Button9::Visible to false.            
           if BAT766-P-ROSTER-NAME(10) not = spaces
               set Button10::Visible to true
               set Button10::Text to BAT766-P-ROSTER-NAME(10)::Trim 
           else
               set Button10::Visible to false.            
           if BAT766-P-ROSTER-NAME(11) not = spaces
               set Button11::Visible to true
               set Button11::Text to BAT766-P-ROSTER-NAME(11)::Trim 
           else
               set Button11::Visible to false.            
           if BAT766-P-ROSTER-NAME(12) not = spaces
               set Button12::Visible to true
               set Button12::Text to BAT766-P-ROSTER-NAME(12)::Trim 
           else
               set Button12::Visible to false.            
           if BAT766-P-ROSTER-NAME(13) not = spaces
               set Button13::Visible to true
               set Button13::Text to BAT766-P-ROSTER-NAME(13)::Trim 
           else
               set Button13::Visible to false.            
           if BAT766-P-ROSTER-NAME(14) not = spaces
               set Button14::Visible to true
               set Button14::Text to BAT766-P-ROSTER-NAME(14)::Trim 
           else
               set Button14::Visible to false.            
           if BAT766-P-ROSTER-NAME(15) not = spaces
               set Button15::Visible to true
               set Button15::Text to BAT766-P-ROSTER-NAME(15)::Trim 
           else
               set Button15::Visible to false.            
           if BAT766-P-ROSTER-NAME(16) not = spaces
               set Button16::Visible to true
               set Button16::Text to BAT766-P-ROSTER-NAME(16)::Trim 
           else
               set Button16::Visible to false.            
           if BAT766-P-ROSTER-NAME(17) not = spaces
               set Button17::Visible to true
               set Button17::Text to BAT766-P-ROSTER-NAME(17)::Trim 
           else
               set Button17::Visible to false.            
           if BAT766-P-ROSTER-NAME(18) not = spaces
               set Button18::Visible to true
               set Button18::Text to BAT766-P-ROSTER-NAME(18)::Trim 
           else
               set Button18::Visible to false.            
           if BAT766-P-ROSTER-NAME(19) not = spaces
               set Button19::Visible to true
               set Button19::Text to BAT766-P-ROSTER-NAME(19)::Trim 
           else
               set Button19::Visible to false.            
           if BAT766-P-ROSTER-NAME(20) not = spaces
               set Button20::Visible to true
               set Button20::Text to BAT766-P-ROSTER-NAME(20)::Trim 
           else
               set Button20::Visible to false.            
           if BAT766-P-ROSTER-NAME(21) not = spaces
               set Button21::Visible to true
               set Button21::Text to BAT766-P-ROSTER-NAME(21)::Trim 
           else
               set Button21::Visible to false.            
           if BAT766-P-ROSTER-NAME(22) not = spaces
               set Button22::Visible to true
               set Button22::Text to BAT766-P-ROSTER-NAME(22)::Trim 
           else
               set Button22::Visible to false.            
           if BAT766-P-ROSTER-NAME(23) not = spaces
               set Button23::Visible to true
               set Button23::Text to BAT766-P-ROSTER-NAME(23)::Trim 
           else
               set Button23::Visible to false.            
           if BAT766-P-ROSTER-NAME(24) not = spaces
               set Button24::Visible to true
               set Button24::Text to BAT766-P-ROSTER-NAME(24)::Trim 
           else
               set Button24::Visible to false.            
           if BAT766-P-ROSTER-NAME(25) not = spaces
               set Button25::Visible to true
               set Button25::Text to BAT766-P-ROSTER-NAME(25)::Trim 
           else
               set Button25::Visible to false.            
           if BAT766-P-ROSTER-NAME(26) not = spaces
               set Button26::Visible to true
               set Button26::Text to BAT766-P-ROSTER-NAME(26)::Trim 
           else
               set Button26::Visible to false.            
           if BAT766-P-ROSTER-NAME(27) not = spaces
               set Button27::Visible to true
               set Button27::Text to BAT766-P-ROSTER-NAME(27)::Trim 
           else
               set Button27::Visible to false.            
           if BAT766-P-ROSTER-NAME(28) not = spaces
               set Button28::Visible to true
               set Button28::Text to BAT766-P-ROSTER-NAME(28)::Trim 
           else
               set Button28::Visible to false.            
           if BAT766-P-ROSTER-NAME(29) not = spaces
               set Button29::Visible to true
               set Button29::Text to BAT766-P-ROSTER-NAME(29)::Trim 
           else
               set Button29::Visible to false.            
           if BAT766-P-ROSTER-NAME(30) not = spaces
               set Button30::Visible to true
               set Button30::Text to BAT766-P-ROSTER-NAME(30)::Trim 
           else
               set Button30::Visible to false. 
       end method.
       
       method-id Button1_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 1 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button2_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 2 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button3_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 3 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button4_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 4 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button5_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 5 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button6_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 6 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button7_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 7 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button8_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 8 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button9_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 9 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button10_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 10 to aa.
           invoke self::pitcherClick.
       end method. 
       method-id Button11_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 11 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button12_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 12 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button13_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 13 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button14_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 14 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button15_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 15 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button16_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 16 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button17_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 17 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button18_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 18 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button19_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 19 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button20_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 20 to aa.
           invoke self::pitcherClick.
       end method. 
       method-id Button21_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 21 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button22_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 22 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button23_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 23 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button24_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 24 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button25_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 25 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button26_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 26 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button27_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 27 to aa.
           invoke self::pitcherClick.
       end method.     
       method-id Button28_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 28 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button29_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 29 to aa.
           invoke self::pitcherClick.
       end method.
       method-id Button30_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 30 to aa.
           invoke self::pitcherClick.
       end method. 
       
       method-id pitcherClick protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".    
       procedure division.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set bat766rununit to self::Session::Item("766rununit")
               as type RunUnit
           MOVE aa to BAT766-SEL-P-BUTTON
           MOVE "GP" to BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.
           set pitcherTextBox::Text to BAT766-PITCHER-DSP-NAME::Trim.
      *     set pTeamDropDownList::SelectedItem to BAT766-PITCHER-TEAM::Trim
       end method.
 
       method-id bTeamDropDownList_SelectedIndexChanged protected.
       local-storage section.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           invoke self::populateBatter
       end method.
       
       method-id populateBatter protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set bat766rununit to self::Session::Item("766rununit")
               as type RunUnit
           SET BAT766-BATTER-TEAM TO bTeamDropDownList::SelectedItem
           MOVE "RB" to BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")     
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert(ERROR-FIELD);", true)
               move spaces to ERROR-FIELD.           
           if BAT766-B-ROSTER-NAME(1) not = spaces
               set Button31::Visible to true
               set Button31::Text to BAT766-B-ROSTER-NAME(1)::Trim
           else
               set Button31::Visible to false. 
           if BAT766-B-ROSTER-NAME(2) not = spaces
               set Button32::Visible to true
               set Button32::Text to BAT766-B-ROSTER-NAME(2)::Trim
           else
               set Button32::Visible to false. 
           if BAT766-B-ROSTER-NAME(3) not = spaces
               set Button33::Visible to true
               set Button33::Text to BAT766-B-ROSTER-NAME(3)::Trim 
           else
               set Button33::Visible to false. 
           if BAT766-B-ROSTER-NAME(4) not = spaces
               set Button34::Visible to true
               set Button34::Text to BAT766-B-ROSTER-NAME(4)::Trim 
           else
               set Button34::Visible to false.            
           if BAT766-B-ROSTER-NAME(5) not = spaces
               set Button35::Visible to true
               set Button35::Text to BAT766-B-ROSTER-NAME(5)::Trim 
           else
               set Button35::Visible to false.            
           if BAT766-B-ROSTER-NAME(6) not = spaces
               set Button36::Visible to true
               set Button36::Text to BAT766-B-ROSTER-NAME(6)::Trim 
           else
               set Button36::Visible to false.            
           if BAT766-B-ROSTER-NAME(7) not = spaces
               set Button37::Visible to true
               set Button37::Text to BAT766-B-ROSTER-NAME(7)::Trim 
           else
               set Button37::Visible to false.            
           if BAT766-B-ROSTER-NAME(8) not = spaces
               set Button38::Visible to true
               set Button38::Text to BAT766-B-ROSTER-NAME(8)::Trim 
           else
               set Button38::Visible to false.            
           if BAT766-B-ROSTER-NAME(9) not = spaces
               set Button39::Visible to true
               set Button39::Text to BAT766-B-ROSTER-NAME(9)::Trim 
           else
               set Button39::Visible to false.            
           if BAT766-B-ROSTER-NAME(10) not = spaces
               set Button40::Visible to true
               set Button40::Text to BAT766-B-ROSTER-NAME(10)::Trim 
           else
               set Button40::Visible to false.            
           if BAT766-B-ROSTER-NAME(11) not = spaces
               set Button41::Visible to true
               set Button41::Text to BAT766-B-ROSTER-NAME(11)::Trim 
           else
               set Button41::Visible to false.            
           if BAT766-B-ROSTER-NAME(12) not = spaces
               set Button42::Visible to true
               set Button42::Text to BAT766-B-ROSTER-NAME(12)::Trim 
           else
               set Button42::Visible to false.            
           if BAT766-B-ROSTER-NAME(13) not = spaces
               set Button43::Visible to true
               set Button43::Text to BAT766-B-ROSTER-NAME(13)::Trim 
           else
               set Button43::Visible to false.            
           if BAT766-B-ROSTER-NAME(14) not = spaces
               set Button44::Visible to true
               set Button44::Text to BAT766-B-ROSTER-NAME(14)::Trim 
           else
               set Button44::Visible to false.            
           if BAT766-B-ROSTER-NAME(15) not = spaces
               set Button45::Visible to true
               set Button45::Text to BAT766-B-ROSTER-NAME(15)::Trim 
           else
               set Button45::Visible to false.            
           if BAT766-B-ROSTER-NAME(16) not = spaces
               set Button46::Visible to true
               set Button46::Text to BAT766-B-ROSTER-NAME(16)::Trim 
           else
               set Button46::Visible to false.            
           if BAT766-B-ROSTER-NAME(17) not = spaces
               set Button47::Visible to true
               set Button47::Text to BAT766-B-ROSTER-NAME(17)::Trim 
           else
               set Button47::Visible to false.            
           if BAT766-B-ROSTER-NAME(18) not = spaces
               set Button48::Visible to true
               set Button48::Text to BAT766-B-ROSTER-NAME(18)::Trim 
           else
               set Button48::Visible to false.            
           if BAT766-B-ROSTER-NAME(19) not = spaces
               set Button49::Visible to true
               set Button49::Text to BAT766-B-ROSTER-NAME(19)::Trim 
           else
               set Button49::Visible to false.            
           if BAT766-B-ROSTER-NAME(20) not = spaces
               set Button50::Visible to true
               set Button50::Text to BAT766-B-ROSTER-NAME(20)::Trim 
           else
               set Button50::Visible to false.            
           if BAT766-B-ROSTER-NAME(21) not = spaces
               set Button51::Visible to true
               set Button51::Text to BAT766-B-ROSTER-NAME(21)::Trim 
           else
               set Button51::Visible to false.            
           if BAT766-B-ROSTER-NAME(22) not = spaces
               set Button52::Visible to true
               set Button52::Text to BAT766-B-ROSTER-NAME(22)::Trim 
           else
               set Button52::Visible to false.            
           if BAT766-B-ROSTER-NAME(23) not = spaces
               set Button53::Visible to true
               set Button53::Text to BAT766-B-ROSTER-NAME(23)::Trim 
           else
               set Button53::Visible to false.            
           if BAT766-B-ROSTER-NAME(24) not = spaces
               set Button54::Visible to true
               set Button54::Text to BAT766-B-ROSTER-NAME(24)::Trim 
           else
               set Button54::Visible to false.            
           if BAT766-B-ROSTER-NAME(25) not = spaces
               set Button55::Visible to true
               set Button55::Text to BAT766-B-ROSTER-NAME(25)::Trim 
           else
               set Button55::Visible to false.            
           if BAT766-B-ROSTER-NAME(26) not = spaces
               set Button56::Visible to true
               set Button56::Text to BAT766-B-ROSTER-NAME(26)::Trim 
           else
               set Button56::Visible to false.            
           if BAT766-B-ROSTER-NAME(27) not = spaces
               set Button57::Visible to true
               set Button57::Text to BAT766-B-ROSTER-NAME(27)::Trim 
           else
               set Button57::Visible to false.            
           if BAT766-B-ROSTER-NAME(28) not = spaces
               set Button58::Visible to true
               set Button58::Text to BAT766-B-ROSTER-NAME(28)::Trim 
           else
               set Button58::Visible to false.            
           if BAT766-B-ROSTER-NAME(29) not = spaces
               set Button59::Visible to true
               set Button59::Text to BAT766-B-ROSTER-NAME(29)::Trim 
           else
               set Button59::Visible to false.            
           if BAT766-B-ROSTER-NAME(30) not = spaces
               set Button60::Visible to true
               set Button60::Text to BAT766-B-ROSTER-NAME(30)::Trim 
           else
               set Button60::Visible to false. 
       end method.
       
       method-id Button31_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 1 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button32_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 2 to aa.
           invoke self::batterClick.
       end method.
       method-id Button33_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 3 to aa.
           invoke self::batterClick.
       end method.
       method-id Button34_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 4 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button35_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 5 to aa.
           invoke self::batterClick.
       end method.
       method-id Button36_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 6 to aa.
           invoke self::batterClick.
       end method.
       method-id Button37_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 7 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button38_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 8 to aa.
           invoke self::batterClick.
       end method.
       method-id Button39_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 9 to aa.
           invoke self::batterClick.
       end method.
       method-id Button40_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 10 to aa.
           invoke self::batterClick.
       end method. 
       method-id Button41_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 11 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button42_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 12 to aa.
           invoke self::batterClick.
       end method.
       method-id Button43_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 13 to aa.
           invoke self::batterClick.
       end method.
       method-id Button44_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 14 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button45_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 15 to aa.
           invoke self::batterClick.
       end method.
       method-id Button46_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 16 to aa.
           invoke self::batterClick.
       end method.
       method-id Button47_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 17 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button48_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 18 to aa.
           invoke self::batterClick.
       end method.
       method-id Button49_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 19 to aa.
           invoke self::batterClick.
       end method.
       method-id Button50_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 20 to aa.
           invoke self::batterClick.
       end method. 
       method-id Button51_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 21 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button52_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 22 to aa.
           invoke self::batterClick.
       end method.
       method-id Button53_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 23 to aa.
           invoke self::batterClick.
       end method.
       method-id Button54_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 24 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button55_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 25 to aa.
           invoke self::batterClick.
       end method.
       method-id Button56_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 26 to aa.
           invoke self::batterClick.
       end method.
       method-id Button57_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 27 to aa.
           invoke self::batterClick.
       end method.     
       method-id Button58_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 28 to aa.
           invoke self::batterClick.
       end method.
       method-id Button59_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 29 to aa.
           invoke self::batterClick.
       end method.
       method-id Button60_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           move 30 to aa.
           invoke self::batterClick.
       end method. 
       
       method-id batterClick protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".    
       procedure division.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set bat766rununit to self::Session::Item("766rununit")
               as type RunUnit
           MOVE aa to BAT766-SEL-B-BUTTON
           MOVE "GB" to BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set batterTextBox::Text to BAT766-BATTER-DSP-NAME::Trim.
      *     set bTeamDropDownList::Text to BAT766-BATTER-TEAM::Trim
       end method.
 
      * ######################################################
        
      * ###################################################### 
      * ######### List Box Replacement Table Methods #########
      * ######################################################
       method-id addTableRow private.
       local-storage section.
       01 tRow type System.Web.UI.WebControls.TableRow.
       01 td type System.Web.UI.WebControls.TableCell.
       procedure division using by value targetTable as type System.Web.UI.WebControls.Table,
                          by value rowContent as type String,
                          by value rowType as type String.
           
           set td to type System.Web.UI.WebControls.TableCell::New()
           set tRow to type System.Web.UI.WebControls.TableRow::New()

           set td::Text to rowContent
           if rowType = 'b'
               set tRow::TableSection to type System.Web.UI.WebControls.TableRowSection::TableBody
           else
               set tRow::TableSection to type System.Web.UI.WebControls.TableRowSection::TableHeader.
           
    
           invoke tRow::Cells::Add(td)
           invoke targetTable::Rows::Add(tRow)
       end method.
       
       method-id getSelectedIndeces private.
       local-storage section.
       01 i type Int32.
       01 strArray type String[].
       procedure division using by value fieldValue as type String
                          returning indexArray as type Int32[].
       
           set strArray to fieldValue::Split(';')
           
           set size of indexArray to strArray::Length
           
           perform varying i from 0 by 1 until i >= strArray::Length
               set indexArray[i] to type Int32::Parse(strArray[i])
           end-perform
           
       end method.
       
       method-id getSelectedValues private.
       local-storage section.
       01 i type Int32.
       procedure division using by value fieldValue as type String
                          returning strArray as type String[].
      
           set strArray to fieldValue::Split(';')           
       end method.
       
       method-id getSelectedValue private.
       local-storage section.
       01 i type Int32.
       procedure division using by value fieldValue as type String
                          returning val as type String.
       
           set val to self::getSelectedValues(fieldValue)[0]           
       end method.       
       
       method-id getSelectedIndex private.
       local-storage section.
       01 i type Int32.
       procedure division using by value fieldValue as type String
                          returning idx as type Int32.
       
           set idx to self::getSelectedIndeces(fieldValue)[0]           
       end method.       
      * ######################################################       
       
       method-id Load_List protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".    
       procedure division.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set pitcherTextBox::Text to BAT766-PITCHER-DSP-NAME::Trim.
           set batterTextBox::Text to BAT766-BATTER-DSP-NAME::Trim.
      *     set bTeamDropDownList::Text to BAT766-BATTER-TEAM::Trim
      *     set pTeamDropDownList::Text to BAT766-PITCHER-TEAM::Trim
           invoke atBatTable::Rows::Clear()
         
           invoke self::addTableRow(atBatTable, "Inn Batter       Out Rnrs Res   RBI Inn Batter      Out Rnrs Res   RBI"::Replace(" ", "&nbsp;"), 'h')
 
           move 1 to aa.
       5-loop.
           if aa > BAT766-NUM-AB
               go to 10-done
           else
               INSPECT BAT766-T-LINE(AA) REPLACING ALL " " BY X'A0'
               invoke self::addTableRow(atBatTable, " " & BAT766-T-LINE(aa), 'b').
           add 1 to aa.
           go to 5-loop.
       10-done.
       end method.
     
       method-id goButton_Click protected.
       local-storage section.
       01 gmDate        type Single.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set bat766rununit to self::Session::Item("766rununit")
               as type RunUnit
           invoke type System.Single::TryParse(TextBox1::Text::ToString::Replace("/", ""), by reference gmDate)
           set BAT766-GAME-DATE to gmDate
           MOVE "DT" to BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           invoke self::Load_List.
       end method.
    
       method-id batstube protected.
       local-storage section.
PM     01 vidPaths type String. 
 PM    01 vidTitles type String.   
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".      
       procedure division.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
PM         set vidPaths to ""
PM         set vidTitles to ""
           move 1 to aa.
       lines-loop.
           if aa > BAT766-WF-VID-COUNT
               go to lines-done.
           
PM         set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-A(aa) & ";"
PM         set vidTitles to vidTitles & BAT766-WF-VIDEO-TITL(aa) & ";"
           
           if BAT766-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BAT766-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BAT766-WF-VIDEO-D(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
           
           add 1 to aa.
           go to lines-loop.
       lines-done.
PM         set self::Session::Item("video-paths") to vidPaths
PM         set self::Session::Item("video-titles") to vidTitles
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "callcallBatstube", "callBatstube();", true).
      *     invoke self::ClientScript::RegisterStartupScript(self::GetType(), "alert", "callBatstube();", true).
       end method.

       method-id playAll protected.
       local-storage section.
       01 vidPaths type String. 
       01 vidTitles type String.       
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division returning atBatReturn as type String.
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set bat766rununit to self::Session::Item("766rununit")
               as type RunUnit
           MOVE "0000000000000" to BAT766-I-KEY
           MOVE "VA" TO BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")
           if ERROR-FIELD NOT = SPACES
               set atBatReturn to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.
           set vidPaths to ""
           set vidTitles to ""
           move 1 to aa.

       lines-loop.
           if aa > BAT766-WF-VID-COUNT
               go to lines-done.
           
           set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-A(aa) & ";"
           set vidTitles to vidTitles & BAT766-WF-VIDEO-TITL(aa) & ";"
           
           if BAT766-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BAT766-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BAT766-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
           
           add 1 to aa.
           go to lines-loop.
       lines-done.
       
           set self::Session::Item("video-paths") to vidPaths
           set self::Session::Item("video-titles") to vidTitles
               
       end method.
       
       method-id locatePitcherButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           invoke self::locatePlayer("P").
       end method.     
       
       method-id locateBatterButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           invoke self::locatePlayer("B").
       end method.     
       
       method-id locatePlayer private.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value playerFlag as String.    
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           set bat766rununit to self::Session::Item("766rununit")
               as type RunUnit
           SET LK-PLAYER-FILE TO BAT766-WF-LK-PLAYER-FILE
           MOVE SPACES TO PLAY-ALT-KEY
           if playerFlag = "B"
               unstring locateBatterTextBox::Text delimited ", " into play-last-name, play-first-name
           else
               unstring locatePitcherTextBox::Text delimited ", " into play-last-name, play-first-name.
           open input play-file
           if status-byte-1 not = zeroes
               set play-player-id to 4
           end-if
           READ PLAY-FILE KEY PLAY-ALT-KEY
           set BAT766-SEL-PLAYER to play-first-name::Trim & " " & play-last-name 
           MOVE play-player-id to BAT766-LOCATE-SEL-ID
           move "LP" to BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           CLOSE PLAY-FILE.
           if playerFlag = "B"
               MOVE BAT766-LOCATE-SEL-ID TO BAT766-SAVE-BATTER-ID
               MOVE BAT766-SEL-TEAM TO BAT766-BATTER-TEAM
               MOVE BAT766-SEL-PLAYER TO BAT766-BATTER-DSP-NAME
           else
               MOVE BAT766-LOCATE-SEL-ID TO BAT766-SAVE-PITCHER-ID
               MOVE BAT766-SEL-TEAM TO BAT766-PITCHER-TEAM
               MOVE BAT766-SEL-PLAYER TO BAT766-PITCHER-DSP-NAME.
           MOVE "DT" TO BAT766-ACTION
           invoke bat766rununit::Call("BAT766WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           if playerFlag = "B"
               set batterTextBox::Text to BAT766-BATTER-DSP-NAME::Trim
           else
               set pitcherTextBox::Text to BAT766-PITCHER-DSP-NAME::Trim.       
       end method.
       
       method-id atBat_Selected protected.
       local-storage section.
       01 vidPaths type String. 
       01 vidTitles type String.
       01 selected  type Int32[].
       linkage section.
       COPY "Y:\sydexsource\BATS\bat766_dg.CPB".
       procedure division using by value indexString as type String 
                          returning atBatReturn as type String.
       
           set mydata to self::Session["bat766data"] as type batsweb.bat766Data
           set address of BAT766-DIALOG-FIELDS to myData::tablePointer
           initialize BAT766-T-AB-SEL-TBL
           move 0 to aa.

           set selected to self::getSelectedIndeces(indexString).
                      
       videos-loop.
           if aa = selected::Count
               go to videos-done.
           MOVE "Y" TO BAT766-T-SEL(selected[aa] + 1).
           add 1 to aa.
           go to videos-loop.
       videos-done.
       
           MOVE "               00000000000" TO BAT766-I-KEY.
           MOVE "VS" to BAT766-ACTION
           set bat766rununit to self::Session::Item("766rununit") as type RunUnit

           invoke bat766rununit::Call("BAT766WEBF")
           
           if ERROR-FIELD NOT = SPACES
               set atBatReturn to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.           
               
           set vidPaths to ""
           set vidTitles to ""
           move 1 to aa.

       lines-loop.
           if aa > BAT766-WF-VID-COUNT
               go to lines-done.
           
           set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-A(aa) & ";"
           set vidTitles to vidTitles & BAT766-WF-VIDEO-TITL(aa) & ";"
           
           if BAT766-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BAT766-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BAT766-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT766-WF-VIDEO-PATH(aa) & BAT766-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;". 
               
           add 1 to aa.
           go to lines-loop.
       lines-done.
       
           set self::Session::Item("video-paths") to vidPaths
           set self::Session::Item("video-titles") to vidTitles

       end method.

       
       end class.
