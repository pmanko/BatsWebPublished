
       class-id batsweb.gameSummary is partial
                implements type System.Web.UI.ICallbackEventHandler
                inherits type System.Web.UI.Page public.

       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat360rununit         type RunUnit.
       01 BAT360WEBF                type BAT360WEBF.
       01 mydata type batsweb.bat360Data.
       01 callbackReturn type String.
       01 dir      type DirectoryInfo.
       01 files    type FileInfo occurs any.
       01 searchPattern    type String.
       01 searchOption    type SearchOption.
       method-id Page_Load protected.
       local-storage section.
       01 cm type ClientScriptManager.
       01 cbReference type String.
       01 callbackScript type String.       
       LINKAGE SECTION.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
      *     set searchOption to new SearchOption::AllDirectories
      *     set dir to new DirectoryInfo(Server::MapPath("/majorsbats"))           
      *     set files to dir::GetFiles()
      *     set BAT360-TEST-PATH to dir       
      * #### ICallback Implementation ####
           set cm to self::ClientScript
           set cbReference to cm::GetCallbackEventReference(self, "arg", "GetServerData", "context")
           set callbackScript to "function CallServer(arg, context)" & "{" & cbReference & "};"
           invoke cm::RegisterClientScriptBlock(self::GetType(), "CallServer", callbackScript, true)
      * #### End ICallback Implement  ####               
           
           if self::IsPostBack
               invoke self::loadGames
               invoke self::loadLines
               exit method.
               
      *    Setup - from main menu                
           SET self::Session::Item("database") to self::Request::QueryString["league"]
           if   self::Session["bat360data"] = null
              set mydata to new batsweb.bat360Data
              invoke mydata::populateData
              set self::Session["bat360data"] to mydata
           else
               set mydata to self::Session["bat360data"] as type batsweb.bat360Data.

           if  self::Session::Item("360rununit") not = null
               set bat360rununit to self::Session::Item("360rununit")
                   as type RunUnit
                ELSE
                set bat360rununit to type RunUnit::New()
                set BAT360WEBF to new BAT360WEBF
                invoke bat360rununit::Add(BAT360WEBF)
                set self::Session::Item("360rununit") to  bat360rununit.
           
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer
           move "I" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
          
      *     set label1::Text to files[0]::Length
           if ERROR-FIELD NOT = SPACES
              invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
      *        invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & BAT360-TEST-PATH::Trim & "');", true)
               move spaces to ERROR-FIELD.   
           if BAT360-GAMES-CHOICE = " "
               set allRadioButton::Checked to true
           else if BAT360-GAMES-CHOICE = "N"
               set nlRadioButton::Checked to true
           else if BAT360-GAMES-CHOICE = "M"
               set alRadioButton::Checked to true
           else if BAT360-GAMES-CHOICE = "T"
               set teamRadioButton::Checked to true.
           invoke self::loadGames.
           move 1 to aa.
       team-loop.
           if aa > BAT360-NUM-TEAMS
               go to team-done.
           invoke teamDropDownList::Items::Add(BAT360-TEAM-NAME(aa))
           add 1 to aa
           go to team-loop.
       team-done.
           if BAT360-GAME-SEL-YR not = zeroes
               set yearDropDownList::Text to BAT360-GAME-SEL-YR::ToString
           else
               set yearDropDownList::Text to type DateTime::Today::Year::ToString.
           if BAT360-STARTING-PITCHERS = "Y"
               set pitchersCheckBox::Checked to true.
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
           
           if actionFlag = 'play-home'
               set callbackReturn to actionFlag & "|" & self::playVids("VH")
           else if actionFlag = 'play-vis'
               set callbackReturn to actionFlag & "|" & self::playVids("VV")
           else if actionFlag = 'play-full'
               set callbackReturn to actionFlag & "|" & self::playVids("VX")
           else if actionFlag = 'from-selected'
               set callbackReturn to actionFlag & "|" & self::fromSelectd()
           else if actionFlag = 'play-sel'
               set callbackReturn to actionFlag & "|" & self::playSelected()              
           else if actionFlag = 'inning-selected'
               set callbackReturn to actionFlag & "|" & self::inningSelected(methodArg)
           else if actionFlag = 'show-detail'
               set callbackReturn to actionFlag & "|" & self::showDetail()
           else if actionFlag = 'select-home-player'
               set callbackReturn to actionFlag & "|" & self::selectHomePlayer()
           else if actionFlag = 'home-player-button-click'
               set callbackReturn to actionFlag & "|" & self::homePlayerButtonClick(methodArg)
           else if actionFlag = 'select-visiting-player'
               set callbackReturn to actionFlag & "|" & self::selectVisitingPlayer()
           else if actionFlag = 'visiting-player-button-click'
               set callbackReturn to actionFlag & "|" & self::visitingPlayerButtonClick(methodArg).
       end method.
       
       method-id GetCallbackResult public.
       procedure division returning returnToClient as String.
       
           set returnToClient to callbackReturn.
           
       end method.
       
      *####################################################################
    
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
             
       method-id loadGames protected.
       local-storage section.
           01 dataLine             type String.
           01 gameNum              pic x.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer 
           invoke gamesTable::Rows::Clear()
           invoke self::addTableRow(gamesTable, "Date        Vis                         Home                     Time Video"::Replace(" ", "&nbsp;"), 'h')
           
           move 1 to aa.
       games-loop.
           if aa > BAT360-NUM-GAMES
               go to games-done
           else
               if BAT360-G-NUM(AA) = 0
                   move space to gameNum
               else
                   move BAT360-G-NUM(AA) to gameNum
               end-if
               Set dataLine to BAT360-G-DSP-DATE(aa)::ToString("0#/##/##") & " "
                  & gameNum & " " & BAT360-G-VIS(aa) & " "
                  & BAT360-G-HOME(aa) & " " & BAT360-G-TIME(aa) & " " & BAT360-G-VIDEO(AA)
               INSPECT dataline REPLACING ALL " " BY X'A0'
               invoke self::addTableRow(gamesTable, " " & dataLine, 'b').
           add 1 to aa
           go to games-loop.
       games-done.
       end method.

       method-id inningsButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           if GamesValueField::Value = null or spaces
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('You must select a game');", true)
               exit method.
           move BAT360-G-GAME-DATE(BAT360-SEL-GAME) to BAT360-I-GAME-DATE
           move BAT360-G-GAME-ID(BAT360-SEL-GAME) to BAT360-I-GAME-ID


           MOVE "RA" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                      
           invoke self::loadLines.
       end method.

       method-id allRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE " " to BAT360-GAMES-CHOICE
           MOVE "RG" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                      
           invoke self::loadGames.
       end method.

       method-id teamRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "T" to BAT360-GAMES-CHOICE
           set BAT360-GAMES-TEAM to teamDropDownList::SelectedItem
           if BAT360-GAMES-TEAM = spaces
               exit method.
           MOVE "RG" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                      
           invoke self::loadGames.
       end method.

       method-id nlRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "N" to BAT360-GAMES-CHOICE
           MOVE "RG" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                      
           invoke self::loadGames.
       end method.

       method-id alRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "M" to BAT360-GAMES-CHOICE
           MOVE "RG" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                      
           invoke self::loadGames.
       end method.

       method-id teamDropDownList_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           set BAT360-GAMES-TEAM TO teamDropDownList::SelectedItem    
           if BAT360-GAMES-CHOICE = "T"
               MOVE "RG" to BAT360-ACTION
               invoke bat360rununit::Call("BAT360WEBF")
               if ERROR-FIELD NOT = SPACES
                   invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
                   move spaces to ERROR-FIELD
               end-if    
               invoke self::loadGames.
       end method.

       method-id pitchersCheckBox_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           if pitchersCheckBox::Checked
               MOVE "Y" to BAT360-STARTING-PITCHERS
               MOVE "RG" to BAT360-ACTION
           else
               MOVE "N" to BAT360-STARTING-PITCHERS
               MOVE "RG" to BAT360-ACTION.
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                      
           invoke self::loadGames
       end method.

       method-id yearDropDownList_SelectedIndexChanged protected.
       local-storage section.
       01 seasonYear       type Single.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           invoke type System.Single::TryParse(yearDropDownList::Text::ToString, by reference seasonYear)
           set BAT360-GAME-SEL-YR to seasonYear
           MOVE "RG" to BAT360-ACTION.
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                      
           invoke self::loadGames
       end method.

       method-id selectVisitingPlayer protected.
       local-storage section.
       01 i type Int32.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division returning playerList as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "SV" to BAT360-ACTION.
           invoke bat360rununit::Call("BAT360WEBF")
       
           if ERROR-FIELD NOT = SPACES
               set playerList to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.  
               
           perform varying i from 1 by 1 until BAT360-V-ROSTER-NAME(i) = spaces
               set playerList to playerList & BAT360-V-ROSTER-NAME(i)::Trim & ";" 
           end-perform.
       end method.

       method-id selectHomePlayer protected.
       local-storage section.
       01 i type Int32.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division returning playerList as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "SH" to BAT360-ACTION.
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               set playerList to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.                      
           
           perform varying i from 1 by 1 until BAT360-H-ROSTER-NAME(i) = spaces
               set playerList to playerList & BAT360-H-ROSTER-NAME(i)::Trim & ";" 
           end-perform.
           
       end method.

       method-id inningSelected protected.
       local-storage section.
       01 ctrl             type Control.
       01 atbatflag        pic x.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value inningIndex as String returning returnVal as  String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
               
           set BAT360-SEL-AB to type Int32::Parse(inningIndex)
           
           add 1 to BAT360-SEL-AB
           MOVE BAT360-SEL-AB to BAT360-AB-IP
           MOVE BAT360-AB-KEY(BAT360-SEL-AB) to BAT360-I-KEY
           
           MOVE "VD" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               set returnVal to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.                      
           invoke self::batstube.
               
       end method.

       method-id fromSelectd protected.
       local-storage section.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division returning returnVal as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
               
           if BAT360-AB-IP = 0
               set returnVal to "er|" & "No starting point is highlighted!"
               exit method.   
           IF BAT360-REC-TYPE(BAT360-SEL-AB) NOT = "B"
               set returnVal to "er|" & "You cannot select a header field!"
               exit method.      
               
           MOVE "VS" to BAT360-ACTION
           
           invoke bat360rununit::Call("BAT360WEBF")
           
           if ERROR-FIELD NOT = SPACES
               set returnVal to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method. 
                       
           invoke self::batstube.
       end method.

       method-id playSelected protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division returning returnVal as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer   
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit      
           if BAT360-AB-IP = 0
               set returnVal to "er|" & "No at bat is highlighted!"
               exit method.   
           MOVE "VD" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               set returnVal to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.                      
           invoke self::batstube.
       end method.
       
       method-id gameSelected protected.
       local-storage section.
       01 temp type String.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           set BAT360-AB-IP to 0
           set BAT360-SEL-GAME TO (type Int32::Parse(gamesIndexField::Value) + 1)
           
           
      *    if self::Request::Params::Get("__EVENTTARGET") not = null or spaces
      *        if self::Request::Params::Get("__EVENTTARGET") not = "ctl00$MainContent$gamesValueField"
      *            exit method.
                   
           MOVE BAT360-G-GAME-DATE(BAT360-SEL-GAME) to BAT360-I-GAME-DATE
           MOVE BAT360-G-GAME-ID(BAT360-SEL-GAME) to BAT360-I-GAME-ID
           MOVE "RA" to BAT360-ACTION
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit

           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.               
           invoke self::loadLines
       end method.
       
       method-id loadLines protected.
       local-storage section.
       01 WS-DATA-LINE.
           05  WS-DATA-L PIC X(39).
           05  WS-ASTERISK PIC X.
           05  WS-DATA-R PIC X(39).
       
       01 WS-DATA-LINE2.
           05  WS2-DATA-L PIC X(39).
           05  WS2-ASTERISK PIC X.
           05  WS2-DATA-R PIC X(39).
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".      
       procedure division.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       

           invoke inningSummaryTable::Rows::Clear()
           invoke self::addTableRow(inningSummaryTable, " Inn Batter         Out Rnrs  Res  RBI   Inn Batter         Out Rnrs  Res  RBI"::Replace(" ", "&nbsp;"), 'h')

           move 1 to aa.
       ab-loop.
           if aa > BAT360-NUM-AB
               go to ab-done
           else
               MOVE BAT360-AB-LINE(AA) TO WS-DATA-LINE, WS-DATA-LINE2
               MOVE SPACES TO WS-ASTERISK
      *        IF WS-DATA-L = SPACES
                   INSPECT WS-DATA-LINE REPLACING ALL " " BY X'A0'
      *        END-IF
               invoke self::addTableRow(inningSummaryTable, " " & WS-DATA-LINE, 'b').
      *        IF AA > 1
      *             IF WS2-DATA-L = SPACES
      *                 invoke listbox2::Items[aa - 1]::Attributes::Add("style", "color:blue")
      *             ELSE
      *                 Invoke listbox2::Items[aa - 1]::Attributes::Add("style", "color:blue")
      *             END-IF
      *        END-IF   
           add 1 to aa
           go to ab-loop.
       ab-done.
      *    invoke listbox3::Items::Clear
           invoke statsTable::Rows::Clear()
           
           move 1 to aa.
       5-loop.
           if aa > BAT360-NUM-T-LINES
               go to 10-done
           else
               INSPECT BAT360-T-LINE(aa) REPLACING ALL " " BY X'A0'
      *        invoke listbox3::Items::Add(BAT360-T-LINE(aa)).
               invoke self::addTableRow(statsTable, BAT360-T-LINE(aa), 'b')
           add 1 to aa
           go to 5-loop.
       10-done.
       end method.

       method-id playVis_Click protected.
       local-storage section.
PM     01 vidPaths type String. 
 PM    01 vidTitles type String.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "VV" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.               
           invoke self::batstube.
       end method.

       method-id playHome_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "VH" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")   
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.               
           invoke self::batstube.
       end method.

       method-id playFull_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
           MOVE "VX" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.               
           invoke self::batstube.
       end method.

       method-id batstube protected.
       local-storage section.
PM     01 vidPaths type String. 
 PM    01 vidTitles type String.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set vidPaths to ""
PM         set vidTitles to ""
           move 1 to aa.
           
       lines-loop.
           if aa > BAT360-WF-VID-COUNT
               go to lines-done.
           
PM         set vidPaths to vidPaths & BAT360-WF-VIDEO-PATH(aa) & BAT360-WF-VIDEO-A(aa) & ";"
PM         set vidTitles to vidTitles & BAT360-WF-VIDEO-TITL(aa) & ";"
           
           if BAT360-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT360-WF-VIDEO-PATH(aa) & BAT360-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BAT360-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BAT360-WF-VIDEO-PATH(aa) & BAT360-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BAT360-WF-VIDEO-D(aa) not = spaces
               set vidPaths to vidPaths & BAT360-WF-VIDEO-PATH(aa) & BAT360-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
           
           add 1 to aa.
           go to lines-loop.
       lines-done.
       
PM         set self::Session::Item("video-paths") to vidPaths
PM         set self::Session::Item("video-titles") to vidTitles
       end method.

       method-id visitingPlayerButtonClick protected.
       procedure division using by value aaValue as String
                          returning returnVal as String.
           invoke self::visitingPlayer(type Int32::Parse(aaValue))
       end method.       
       
       method-id visitingPlayer protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value aaVal as type Int32 
                          returning returnVal as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit      
               
           MOVE aaVal to BAT360-V-SEL-BUTTON
           MOVE "PV" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               set returnVal to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.                 
           invoke self::batstube.
       end method.
       
       
       method-id homePlayerButtonClick protected.
       procedure division using by value aaValue as String
                          returning returnVal as String.
           invoke self::homePlayer(type Int32::Parse(aaValue))
       end method.    
       
       
       method-id homePlayer protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value aaVal as type Int32 
                          returning returnVal as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit      
           MOVE aaVal to BAT360-H-SEL-BUTTON
           MOVE "PH" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               set returnVal to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.               
           invoke self::batstube.
       end method.
       
       method-id printButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
      *     MOVE "PG" to BAT360-ACTION
      *     invoke bat360rununit::Call("BAT360WEBF")
      *     MOVE " " to SYD145WD-FILENAME
      *     MOVE "S" to SYD145WD-PAGE-ORIENT
      *     MOVE 1 to SYD145WD-COPIES
      *     MOVE " " to SYD145WD-NOTEPAD
       end method.

       method-id showDetail protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division returning returnVal as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer   
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit      
           if BAT360-AB-IP = 0
               set returnVal to "er|" & "No at bat is highlighted!"
               exit method.   
           move "VA" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               set returnVal to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD.               
               exit method.   
       end method.
      *
      *method-id game_Selected protected.
      *local-storage section.
      *01 selected  type Int32.
      *linkage section.
      *COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
      *procedure division using by value indexString as type String 
      *                   returning gamesReturn as type String.
      *
      *    set mydata to self::Session["bat360data"] as type batsweb.bat360Data
      *    set address of BAT360-DIALOG-FIELDS to myData::tablePointer
      *
      *    set selected to self::getSelectedIndex(indexString).
      *    set BAT360-AB-IP to 0
      *    set BAT360-SEL-GAME TO (selected)
      *    MOVE BAT360-G-GAME-DATE(BAT360-SEL-GAME) to BAT360-I-GAME-DATE
      *    MOVE BAT360-G-GAME-ID(BAT360-SEL-GAME) to BAT360-I-GAME-ID
      *end method.
      *              
      *    
      *method-id show_Innings protected.
      *local-storage section.
      *linkage section.
      *COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
      *procedure division.
      *
      *    set mydata to self::Session["bat360data"] as type batsweb.bat360Data
      *    set address of BAT360-DIALOG-FIELDS to myData::tablePointer          
      *    MOVE "RA" to BAT360-ACTION
      *    set bat360rununit to self::Session::Item("360rununit")
      *        as type RunUnit
      *
      *    invoke bat360rununit::Call("BAT360WEBF")
      *    if ERROR-FIELD NOT = SPACES
      *        invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
      *        move spaces to ERROR-FIELD.    
      *    invoke self::loadLines.
      *end method.
       
       
       
      * #### Helpers ####
       method-id playVids protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value actionFlag as type String
                          returning returnVal as type String.
                          
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer    
           
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit
               
           MOVE actionFlag to BAT360-ACTION
           
           invoke bat360rununit::Call("BAT360WEBF")   
           
           if ERROR-FIELD NOT = SPACES
               set returnVal to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.         
               
           invoke self::batstube.
       end method.

       end class.
