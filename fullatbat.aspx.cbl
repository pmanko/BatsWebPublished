       class-id batsweb.fullatbat is partial
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
       01 bat666rununit         type RunUnit.
       01 BAT666WEBF                type BAT666WEBF.
       01 mydata type batsweb.bat666Data.
       01 abnum        type Single.
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
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.

      * #### ICallback Implementation ####
           set cm to self::ClientScript
           set cbReference to cm::GetCallbackEventReference(self, "arg", "GetServerData", "context")
           set callbackScript to "function CallServer(arg, context)" & "{" & cbReference & "};"
           invoke cm::RegisterClientScriptBlock(self::GetType(), "CallServer", callbackScript, true)
      * #### End ICallback Implement  ####                 

           if self::IsPostBack
               exit method.
                                               
      * Setup using GET variables
      *    Moved from mainmenu.aspx - Pages should be self-sufficient          
           SET self::Session::Item("database") to self::Request::QueryString["league"]
           if   self::Session["bat666data"] = null
               set mydata to new batsweb.bat666Data
               invoke mydata::populateData
               set self::Session["bat666data"] to mydata
           else
               set mydata to self::Session["bat666data"] as type batsweb.bat666Data.
       
           if  self::Session::Item("666rununit") not = null
               set bat666rununit to self::Session::Item("666rununit")
                   as type RunUnit
               else
               set bat666rununit to type RunUnit::New()
               set BAT666WEBF to new BAT666WEBF
               invoke bat666rununit::Add(BAT666WEBF)
               set self::Session::Item("666rununit") to  bat666rununit.
          
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           move "I" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           if BAT666-GAME-FLAG = "D"
               set startDateRadioButton::Checked to true
           else
               MOVE "A" to BAT666-GAME-FLAG
               set allStartRadioButton::Checked to true.
           if BAT666-END-GAME-FLAG = "D"
               set endDateRadioButton::Checked to true
           else
               MOVE "A" to BAT666-END-GAME-FLAG
               set allEndRadioButton::Checked to true.
           set textBox1::Text to BAT666-GAME-DATE::ToString("00/00/00")
           set textBox4::Text to BAT666-END-GAME-DATE::ToString("00/00/00")
           set pitcherTextBox::Text to BAT666-PITCHER
           set batterTextBox::Text to BAT666-BATTER
           set BAT666-PITCHER-TYPE-FLAG TO " "    
           set BAT666-BATTER-TYPE-FLAG TO " "    
           if BAT666-SORT-FLAG = "Y"
               set sortByInningCheckBox::Checked to true
           else if BAT666-SORT-FLAG = "B"
               set sortByBatterCheckBox::Checked to true
           else if BAT666-SORT-FLAG = "O"
               set sortByOldCheckBox::Checked to true.
           if BAT666-MAX-FLAG = "Y"
               set maxAtBatsCheckBox::Checked to true.             
           move 1 to aa.
       team-loop.
           if aa > BAT666-NUM-TEAMS
               go to team-done.
           invoke teamDropDownList::Items::Add(BAT666-TEAM-NAME(aa))
           invoke pTeamDropDownList::Items::Add(BAT666-TEAM-NAME(aa))
           invoke bTeamDropDownList::Items::Add(BAT666-TEAM-NAME(aa))
           add 1 to aa
           go to team-loop.
       team-done.
          move 1 to aa.
       runners-loop.
           if aa > DIALOG-RUN-NUM-ENTRIES
               go to runners-done.
           invoke Runners::Items::Add(DIALOG-RUN(AA)::Trim)
           add 1 to aa
           go to runners-loop.
       runners-done.
           move 1 to aa.
       outs-loop.
           if aa > DIALOG-OUT-NUM-ENTRIES
               go to outs-done.
           invoke Outs::Items::Add(DIALOG-OUT(AA)::Trim)
           add 1 to aa
           go to outs-loop.
       outs-done.
           move 1 to aa.
       inning-loop.
           if aa > DIALOG-INN-NUM-ENTRIES
               go to inning-done.
           invoke Innings::Items::Add(DIALOG-INNING-DESC(AA)::Trim)
           add 1 to aa
           go to inning-loop.
       inning-done.
           SET LK-PLAYER-FILE TO BAT666-WF-LK-PLAYER-FILE
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
               set callbackReturn to actionFlag & "|" & self::playAll(methodArg).
      *    else if actionFlag = "update-player"
      *        set callbackReturn to actionFlag & "|" & self::player_Selected(methodArg).
       end method.
       
       method-id GetCallbackResult public.
       procedure division returning returnToClient as String.
       
           set returnToClient to callbackReturn.
           
       end method.
      *####################################################################

       method-id Button5_Click protected.
       local-storage section.
       01 javaScript type System.Text.StringBuilder.
       01 confirmMessage type String.
       01 gmDate        type Single.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           invoke type System.Single::TryParse(TextBox1::Text::ToString::Replace("/", ""), by reference gmDate)
           set BAT666-GAME-DATE to gmDate
           invoke type System.Single::TryParse(TextBox4::Text::ToString::Replace("/", ""), by reference gmDate)
           set BAT666-END-GAME-DATE to gmDate
           if maxAtBatsCheckBox::Checked
               invoke type System.Single::TryParse(MaxABTextBox::Text::ToString, by reference abnum)
               set BAT666-MAX-NUM to abnum.
           MOVE "GO" to BAT668-ACTION
           MOVE "T" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.
           MOVE "RA" TO BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.
          invoke self::loadList.
       end method.
                  
       method-id loadList protected.
       local-storage section.
      * 01 getVidPaths type String.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division.
      *      set getVidPaths to ""

           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           
           move 1 to aa.
       lines-loop.
           if aa > BAT666-NUM-AB
               go to lines-done.
           INSPECT BAT666-T-LINE(AA) REPLACING ALL " " BY X'A0'
           
           invoke self::addTableRow(atBatTable, " " & BAT666-T-LINE(aa))
      *     set getVidPaths to getVidPaths & BAT666-T-LINE(aa) & ","
           
           add 1 to aa.
           go to lines-loop.
       lines-done.     
      *     set self::Session::Item("testing") to getVidPaths
     
       end method.
       
       method-id atBat_Selected protected.
       local-storage section.
       01 vidPaths type String. 
       01 vidTitles type String.
       01 selected  type Int32[].
       linkage section.
       COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value indexString as type String 
                          returning atBatReturn as type String.
       
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           initialize BAT666-T-AB-SEL-TBL
           move 0 to aa.

           set selected to self::getSelectedIndeces(indexString).
                      
       videos-loop.
           if aa = selected::Count
               go to videos-done.
           MOVE "Y" TO BAT666-T-SEL(selected[aa] + 1).
           add 1 to aa.
           go to videos-loop.
       videos-done.
       
           MOVE "               00000000000" TO BAT666-I-KEY.
           MOVE "VS" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit") as type RunUnit

           invoke bat666rununit::Call("BAT666WEBF")
           
           if ERROR-FIELD NOT = SPACES
               set atBatReturn to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.           
               
           set vidPaths to ""
           set vidTitles to ""
           move 1 to aa.

       lines-loop.
           if aa > BAT666-WF-VID-COUNT
               go to lines-done.
           
           set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-A(aa) & ";"
           set vidTitles to vidTitles & BAT666-WF-VIDEO-TITL(aa) & ";"
           
           if BAT666-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BAT666-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BAT666-WF-VIDEO-D(aa) not = spaces
               set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
           
           add 1 to aa.
           go to lines-loop.
       lines-done.
       
           set self::Session::Item("video-paths") to vidPaths
           set self::Session::Item("video-titles") to vidTitles

       end method.

       method-id playAll protected.
       local-storage section.
       01 vidPaths type String. 
       01 vidTitles type String.
       linkage section.
       COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value itemsCount as type String 
                               returning atBatReturn as type String.
       
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           initialize BAT666-T-AB-SEL-TBL
           move spaces to BAT666-VIDEO-FOUND
           move 0 to aa.
           invoke type System.Single::TryParse(itemsCount, by reference abNum).
       videos-loop.
      * Replace with itemsCount
           if aa = abNum
               go to videos-done.
           MOVE "Y" TO BAT666-T-SEL(aa + 1).
           add 1 to aa.
           go to videos-loop.
       videos-done.
       
           MOVE "               00000000000" TO BAT666-I-KEY.
           MOVE "VS" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit") as type RunUnit

           invoke bat666rununit::Call("BAT666WEBF")
           
           if ERROR-FIELD NOT = SPACES
               set atBatReturn to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.           
               
           set vidPaths to ""
           set vidTitles to ""
           move 1 to aa.

       lines-loop.
           if aa > BAT666-WF-VID-COUNT
               go to lines-done.
           
           set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-A(aa) & ";"
           set vidTitles to vidTitles & BAT666-WF-VIDEO-TITL(aa) & ";"
           
           if BAT666-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BAT666-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BAT666-WF-VIDEO-D(aa) not = spaces
               set vidPaths to vidPaths & BAT666-WF-VIDEO-PATH(aa) & BAT666-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
           
           add 1 to aa.
           go to lines-loop.
       lines-done.
       
           set self::Session::Item("video-paths") to vidPaths
           set self::Session::Item("video-titles") to vidTitles

       end method.

       method-id CleanupPage public static
       attribute System.Web.Services.WebMethod.
       local-storage section.
       01 confirmMessage type String.
       linkage section.
       procedure division.
           continue
      *      set bat666rununit to self::Session::Item("666rununit") as type rununit


     **          call "CBL_GET_SHMEM_PTR" using  SH-BAT666-MEM-POINTER node-name
      *         returning mem-flag
      *     set address of BAT666-DIALOG-FIELDS  to SH-BAT666-MEM-POINTER
           set confirmMessage to "Haltest"

      *     MOVE "X" TO BAT666-ACTION.
      *     invoke bat666rununit::Call("BAT666WEBF")

      *     invoke bat666rununit::StopRun.
      *     call "CBL_FREE_SHMEM" using  SH-BAT666-MEM-POINTER
           goback.
       end method.

       method-id allStartRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "A" to BAT666-GAME-FLAG
       end method.

       method-id startDateRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "D" to BAT666-GAME-FLAG
       end method.

       method-id allEndRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
          set mydata to self::Session["bat666data"] as type batsweb.bat666Data
          set address of BAT666-DIALOG-FIELDS to myData::tablePointer
          MOVE "A" to BAT666-END-GAME-FLAG
       end method.

       method-id endDateRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
        set mydata to self::Session["bat666data"] as type batsweb.bat666Data
        set address of BAT666-DIALOG-FIELDS to myData::tablePointer
        MOVE "A" to BAT666-END-GAME-FLAG
       end method.

       method-id maxAtBatsCheckBox_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit           
           if maxAtBatsCheckBox::Checked
               invoke type System.Single::TryParse(MaxABTextBox::Text::ToString, by reference abnum)
               set BAT666-MAX-NUM to abnum
               move "Y" to BAT666-MAX-FLAG
               invoke maxABTextBox::Focus
           else
               move "N" to BAT666-MAX-FLAG.
           MOVE "GO" to BAT668-ACTION
           MOVE "T" to BAT666-ACTION               
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                     
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           invoke self::loadList
               
       end method.

       method-id sortByInningCheckBox_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           if sortByInningCheckBox::Checked
               move "Y" to BAT666-SORT-FLAG
               set sortByBatterCheckBox::Checked to false
               set sortByOldCheckBox::Checked to false
           else
               move "N" to BAT666-SORT-FLAG.
           MOVE "GO" to BAT668-ACTION
           MOVE "T" to BAT666-ACTION               
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                          
           invoke self::loadList
       end method.

       method-id sortByBatterCheckBox_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           if sortByBatterCheckBox::Checked
               move "B" to BAT666-SORT-FLAG
               set sortByInningCheckBox::Checked to false
               set sortByOldCheckBox::Checked to false
           else
               move "N" to BAT666-SORT-FLAG.
           MOVE "GO" to BAT668-ACTION
           MOVE "T" to BAT666-ACTION               
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                     
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                          
           invoke self::loadList

       end method.

       method-id sortByOldCheckBox_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           if sortByOldCheckBox::Checked
               move "O" to BAT666-SORT-FLAG
               set sortByBatterCheckBox::Checked to false
               set sortByInningCheckBox::Checked to false
           else
               move "N" to BAT666-SORT-FLAG.
           MOVE "GO" to BAT668-ACTION
           MOVE "T" to BAT666-ACTION               
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                     
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                          
           invoke self::loadList
       end method.

       method-id allGamesButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "A" to BAT666-DATE-CHOICE-FLAG
           MOVE "A" to BAT666-GAME-FLAG
           MOVE "A" to BAT666-END-GAME-FLAG
           set startDateRadioButton::Checked to false
           set endDateRadioButton::Checked to false
           set allStartRadioButton::Checked to true
           set allEndRadioButton::Checked to true
       end method.

       method-id currentYearButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "C" to BAT666-DATE-CHOICE-FLAG
           MOVE "DC" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.
           MOVE "D" to BAT666-GAME-FLAG
           MOVE "D" to BAT666-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set TextBox1::Text to BAT666-GAME-DATE::ToString("##/##/##").
           set TextBox4::Text to BAT666-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id pastYearButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "P" to BAT666-DATE-CHOICE-FLAG
           MOVE "DC" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           MOVE "D" to BAT666-GAME-FLAG
           MOVE "D" to BAT666-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set TextBox1::Text to BAT666-GAME-DATE::ToString("##/##/##").
           set TextBox4::Text to BAT666-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id twoWeeksButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "W" to BAT666-DATE-CHOICE-FLAG
           MOVE "DC" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.
           MOVE "D" to BAT666-GAME-FLAG
           MOVE "D" to BAT666-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set TextBox1::Text to BAT666-GAME-DATE::ToString("##/##/##").
           set TextBox4::Text to BAT666-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id currentMonthButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "M" to BAT666-DATE-CHOICE-FLAG
           MOVE "DC" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           MOVE "D" to BAT666-GAME-FLAG
           MOVE "D" to BAT666-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set TextBox1::Text to BAT666-GAME-DATE::ToString("##/##/##").
           set TextBox4::Text to BAT666-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id twoMonthsButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "2" to BAT666-DATE-CHOICE-FLAG
           MOVE "DC" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           MOVE "D" to BAT666-GAME-FLAG
           MOVE "D" to BAT666-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set TextBox1::Text to BAT666-GAME-DATE::ToString("##/##/##").
           set TextBox4::Text to BAT666-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id threeMonthsButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "3" to BAT666-DATE-CHOICE-FLAG
           MOVE "DC" to BAT666-ACTION
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           MOVE "D" to BAT666-GAME-FLAG
           MOVE "D" to BAT666-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set TextBox1::Text to BAT666-GAME-DATE::ToString("##/##/##").
           set TextBox4::Text to BAT666-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id teamDropDownList_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           invoke self::populateTeam.     
       end method.
       
       method-id populateTeam protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set BAT666-SEL-TEAM to teamDropDownList::SelectedItem
           
         if BAT666-IND-PB-FLAG = "P"
            MOVE BAT666-SEL-TEAM TO BAT666-PITCHER-ROSTER-TEAM
            MOVE "RP" TO BAT668-ACTION  
            MOVE "T" TO BAT666-ACTION
         else
            MOVE BAT666-SEL-TEAM TO BAT666-BATTER-ROSTER-TEAM
            MOVE "RB" TO BAT668-ACTION  
            MOVE "T" TO BAT666-ACTION
         end-if.
         
           set bat666rununit to self::Session::Item("666rununit") as
               type RunUnit
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
               invoke playerTable::Rows::Clear()

           move 1 to aa.
       5-loop.
           if aa > BAT666-ROSTER-NUM-ENTRIES
               go to 10-done
           else
      *         invoke playerListBox::Items::Add(" " & BAT666-ROSTER-NAME(aa) & " " & BAT666-ROSTER-POS(aa))
               invoke self::addTableRow(playerTable, " " & BAT666-ROSTER-NAME(aa) & " " & BAT666-ROSTER-POS(aa)).
           add 1 to aa.
           go to 5-loop.
       10-done.

       end method.

       method-id playerOKButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           if playerValueField::Value = spaces
               SET LK-PLAYER-FILE TO BAT666-WF-LK-PLAYER-FILE
               MOVE SPACES TO PLAY-ALT-KEY
               unstring locatePlayerTextBox::Text delimited ", " into play-last-name, play-first-name
               open input play-file
               READ PLAY-FILE KEY PLAY-ALT-KEY
               set BAT666-SEL-PLAYER to play-first-name::Trim & " " & play-last-name 
               MOVE play-player-id to BAT666-LOCATE-SEL-ID
               move "LP" to BAT668-ACTION
               move "T" to BAT666-ACTION
               invoke bat666rununit::Call("BAT666WEBF")
               if ERROR-FIELD NOT = SPACES
                   invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
                   move spaces to ERROR-FIELD
               END-IF    
               IF BAT666-IND-PB-FLAG = "P"  
                   MOVE play-player-id to BAT666-SAVE-PITCHER-ID 
               ELSE
                   MOVE play-player-id to BAT666-SAVE-BATTER-ID 
               end-if
               CLOSE PLAY-FILE.
           if BAT666-IND-PB-FLAG = "P"
               move BAT666-SEL-TEAM to BAT666-PITCHER-ROSTER-TEAM  
               move BAT666-SEL-PLAYER to BAT666-PITCHER-DSP-NAME  
           else
               MOVE BAT666-SEL-TEAM TO BAT666-BATTER-ROSTER-TEAM
               MOVE BAT666-SEL-PLAYER TO BAT666-BATTER-DSP-NAME  
           end-if.
           move "TI" to BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           MOVE " " to BAT666-IND-PB-FLAG   
           set pitcherTextBox::Text to BAT666-PITCHER
           set batterTextBox::Text to BAT666-BATTER
       end method.

       method-id player_Selected protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           
      *    if team is changed instead of ok button
           if playerIndexField::Value = spaces
               exit method.
           
           move playerValueField::Value to BAT666-SEL-PLAYER.
       
      *    MOVE BAT666-ROSTER-NAME(self::getSelectedIndex(indexString)) to BAT666-SEL-PLAYER.
      *     SET selectedplayerlabel::Text to BAT666-SEL-PLAYER
           
           if BAT666-IND-PB-FLAG = "P" THEN
               MOVE BAT666-ROSTER-ID(type Int32::Parse(playerIndexField::Value) + 1) TO BAT666-SAVE-PITCHER-ID
           ELSE
               MOVE BAT666-ROSTER-ID(type Int32::Parse(playerIndexField::Value) + 1) TO BAT666-SAVE-BATTER-ID
           END-IF.
       end method.

       method-id pPlayerButton_Click protected
       procedure division using by value sender as object e as type System.EventArgs.
           invoke self::ShowPlayerPanel("P").
       end method.

       method-id bPlayerButton_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           invoke self::ShowPlayerPanel("B").     
       end method.

       method-id Result1_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           set BAT666-RES-IDX to Result1::SelectedIndex
           set BAT666-RESULT1 TO Result1::SelectedItem
           add 1 to BAT666-RES-IDX
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
          invoke self::loadList.       
       end method.

       method-id Result2_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           set BAT666-RES-IDX2 to Result2::SelectedIndex
           set BAT666-RESULT2 TO Result2::SelectedItem
           add 1 to BAT666-RES-IDX2
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
          invoke self::loadList.     
       end method.

       method-id Runners_SelectedIndexChanged protected.
       linkage section.       
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           set DIALOG-RUN-MASTER to Runners::SelectedItem
           set DIALOG-RUN-IDX to Runners::SelectedIndex
           add 1 to DIALOG-RUN-IDX
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
          invoke self::loadList.  
       end method.

       method-id Innings_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           set DIALOG-INN-MASTER to Innings::SelectedItem
           set DIALOG-INN-IDX to Innings::SelectedIndex
           add 1 to DIALOG-INN-IDX
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
          invoke self::loadList.  
       end method.

       method-id Outs_SelectedIndexChanged protected.
       linkage section.       
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           set DIALOG-OUT-MASTER to Outs::SelectedItem
           set DIALOG-OUT-IDX to Outs::SelectedIndex
           add 1 to DIALOG-OUT-IDX
           MOVE "RA" to BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
          invoke self::loadList.
       end method.

       method-id resetButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           move 0 to result1::SelectedIndex
           set BAT666-RES-IDX to (Result1::SelectedIndex + 1)
           set BAT666-RESULT1 TO Result1::SelectedItem
           move 0 to result2::SelectedIndex
           set BAT666-RES-IDX2 to (Result2::SelectedIndex + 1)
           set BAT666-RESULT2 TO Result2::SelectedItem
           move 0 to runners::SelectedIndex
           set DIALOG-RUN-MASTER to runners::SelectedItem
           set DIALOG-RUN-IDX to (runners::SelectedIndex + 1)           
           move 0 to outs::SelectedIndex
           set DIALOG-OUT-MASTER to Outs::SelectedItem
           set DIALOG-OUT-IDX to (Outs::SelectedIndex + 1)
           move 0 to innings::SelectedIndex
           set DIALOG-INN-MASTER to innings::SelectedItem
           set DIALOG-INN-IDX to (innings::SelectedIndex + 1)
           MOVE "RA" TO BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
          INVOKE self::loadList.   
       end method.

       method-id pAllLeftButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           MOVE "AL" TO BAT666-PITCHER-FLAG
           MOVE "TI" TO BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION  
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set pitcherTextBox::Text to BAT666-PITCHER
       end method.

       method-id pAllButton_Click protected.
        linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           MOVE "A" TO BAT666-PITCHER-FLAG
           MOVE "TI" TO BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION  
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set pitcherTextBox::Text to BAT666-PITCHER
       end method.

       method-id pAllRightButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           MOVE "AR" TO BAT666-PITCHER-FLAG
           MOVE "TI" TO BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION  
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set pitcherTextBox::Text to BAT666-PITCHER
       end method.

       method-id bAllLeftButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           MOVE "AL" TO BAT666-BATTER-FLAG
           MOVE "TI" TO BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION  
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set batterTextBox::Text to BAT666-BATTER
       end method.

       method-id bAllButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           MOVE "A" TO BAT666-BATTER-FLAG
           MOVE "TI" TO BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION  
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set batterTextBox::Text to BAT666-BATTER
       end method.

       method-id bAllRightButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           MOVE "AR" TO BAT666-BATTER-FLAG
           MOVE "TI" TO BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION  
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set batterTextBox::Text to BAT666-BATTER
       end method.

       method-id pTeamButton_Click protected.
       local-storage section.
       01 loc          type Single.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "T " to BAT666-PITCHER-FLAG
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openPTeamModal" ,"openPTeamModal();", true);
       end method.

       method-id pTeamDropDownList_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set BAT666-PITCHER-TEAM to pTeamDropDownList::SelectedItem.
       end method.

       method-id pTeamOKButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           if BAT666-PITCHER-TEAM = spaces
               set BAT666-PITCHER-TEAM to pTeamDropDownList::SelectedItem.
           MOVE "T" to BAT666-ACTION
           MOVE "TI" to BAT668-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set pitcherTextBox::Text to BAT666-PITCHER
       end method.

       method-id pTeamLeftButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "TL" to BAT666-PITCHER-FLAG
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openPTeamModal" ,"openPTeamModal();", true);
       end method.

       method-id pTeamRightButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "TR" to BAT666-PITCHER-FLAG
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openPTeamModal" ,"openPTeamModal();", true);
       end method.

       method-id bTeamDropDownList_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set BAT666-BATTER-TEAM to bTeamDropDownList::SelectedItem.
       end method.

       method-id bTeamOKButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
           if BAT666-BATTER-TEAM = spaces
               set BAT666-BATTER-TEAM to bTeamDropDownList::SelectedItem.
           MOVE "T" to BAT666-ACTION
           MOVE "TI" to BAT668-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           set batterTextBox::Text to BAT666-BATTER
       end method.

       method-id bTeamButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "T " to BAT666-BATTER-FLAG
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openBTeamModal" ,"openBTeamModal();", true);
       end method.
       
       method-id bTeamLeftButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "TL" to BAT666-BATTER-FLAG
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openBTeamModal" ,"openBTeamModal();", true);
       end method.

       method-id bTeamRightButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".  
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           MOVE "TR" to BAT666-BATTER-FLAG
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openBTeamModal" ,"openBTeamModal();", true);
       end method.

       
      * ######################################################
      * Helper Methods
      * ######################################################
       method-id ShowPlayerPanel private.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat666_dg.CPB".
       procedure division using by value playerFlag as String.
           set mydata to self::Session["bat666data"] as type batsweb.bat666Data
           set address of BAT666-DIALOG-FIELDS to myData::tablePointer
           set bat666rununit to self::Session::Item("666rununit")
               as type RunUnit
               
           if playerFlag = "B"
               move "I" to BAT666-BATTER-FLAG
           else
               move "I" to BAT666-PITCHER-FLAG
               
           MOVE playerFlag TO BAT666-IND-PB-FLAG  
           MOVE "RP" TO BAT668-ACTION  
           MOVE "T" TO BAT666-ACTION
           invoke bat666rununit::Call("BAT666WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
           MOVE " " TO BAT666-SEL-TEAM
           invoke self::populateTeam.     
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openModal" ,"openModal();", true);
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
                          by value rowContent as type String.
           
           set td to type System.Web.UI.WebControls.TableCell::New()
           set tRow to type System.Web.UI.WebControls.TableRow::New()

           set td::Text to rowContent
           set tRow::TableSection to type System.Web.UI.WebControls.TableRowSection::TableBody
           
    
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
         
       end class.
