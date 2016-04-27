       class-id batsweb.breakdown is partial 
                inherits type System.Web.UI.Page
                implements type System.Web.UI.ICallbackEventHandler
                public.
  
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
       01 bat310rununit         type RunUnit.
       01 BAT310WEBF                type BAT310WEBF.
       01 mydata type batsweb.bat310Data.
       01 mydata300 type batsweb.bat300Data.
       01 callbackReturn type String.
       01 playerName      type String.
       01 nameArray      type String.
       method-id Page_Load protected.
       local-storage section.
       01 cm type ClientScriptManager.
       01 cbReference type String.
       01 callbackScript type String.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
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
           
           set self::Session::Item("database") to self::Request::QueryString["league"]
           if self::Session["bat310data"] = null
               set mydata to new batsweb.bat310Data
               invoke mydata::populateData
               set self::Session["bat310data"] to mydata              
           else
               set mydata to self::Session["bat310data"] as type batsweb.bat310Data.

           if  self::Session::Item("310rununit") not = null
               set bat310rununit to self::Session::Item("310rununit")
                   as type RunUnit
               else
               set bat310rununit to type RunUnit::New()
               set BAT310WEBF to new BAT310WEBF
               invoke bat310rununit::Add(BAT310WEBF)
               set self::Session::Item("310rununit") to  bat310rununit.              
               
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           INITIALIZE BAT310-DIALOG-FIELDS
           MOVE "I" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.         
      *show and hide batter based on L or R handedness

           invoke runnersdd::Items::Clear.
           invoke outsdd::Items::Clear.
           invoke inndd::Items::Clear.
           invoke countdd::Items::Clear.
           invoke pitchlocdd::Items::Clear
           invoke catcherdd::Items::Clear.
           invoke result1dd::Items::Clear.
           invoke result2dd::Items::Clear.
           invoke pitchtypedd::Items::Clear.

           move 1 to aa.
       runners-loop.
           if aa > DIALOG-RUN-NUM-ENTRIES
               go to runners-done.
           invoke runnersdd::Items::Add(DIALOG-RUN(AA)::Trim)
           add 1 to aa
           go to runners-loop.
       runners-done.
           move 1 to aa.
       outs-loop.
           if aa > DIALOG-OUT-NUM-ENTRIES
               go to outs-done.
           invoke outsdd::Items::Add(DIALOG-OUT(AA)::Trim)
           add 1 to aa
           go to outs-loop.
       outs-done.
           move 1 to aa.
       inning-loop.
           if aa > DIALOG-INN-NUM-ENTRIES
               go to inning-done.
           invoke inndd::Items::Add(DIALOG-INNING-DESC(AA)::Trim)
           add 1 to aa
           go to inning-loop.
       inning-done.
       move 1 to aa.
       count-loop.
           if aa > DIALOG-COUNT-NUM-ENTRIES
               go to count-done.
           invoke countdd::Items::Add(DIALOG-COUNT-DESC(AA)::Trim)
           add 1 to aa
           go to count-loop.
       count-done.
       move 1 to aa.
       location-loop.
           if aa > DIALOG-PLO-NUM-ENTRIES
               go to location-done.
           invoke pitchlocdd::Items::Add(DIALOG-PLO(AA)::Trim)
           add 1 to aa
           go to location-loop.
       location-done.
       move 1 to aa.
       catcher-loop.
           if aa > DIALOG-CAT-NUM-ENTRIES
               go to catcher-done.
           invoke catcherdd::Items::Add(DIALOG-CAT(AA)::Trim)
           add 1 to aa
           go to catcher-loop.
       catcher-done.
       move 1 to aa.
       result1-loop.
           if aa > DIALOG-RES-NUM-ENTRIES
               go to result1-done.
           invoke result1dd::Items::Add(DIALOG-RES(AA)::Trim)
           add 1 to aa
           go to result1-loop.
       result1-done.
       move 1 to aa.
       result2-loop.
           if aa > DIALOG-RES-NUM-ENTRIES
               go to result2-done.
           invoke result2dd::Items::Add(DIALOG-RES(AA)::Trim)
           add 1 to aa
           go to result2-loop.
       result2-done.
       move 1 to aa.
       pitchtype-loop.
           if aa > DIALOG-PTY-NUM-ENTRIES
               go to pitchtype-done.
           invoke pitchtypedd::Items::Add(DIALOG-PTY(AA)::Trim)
           add 1 to aa
           go to pitchtype-loop.
       pitchtype-done.
           set result1dd::SelectedIndex to 0
           set result2dd::SelectedIndex to 0
           set inndd::SelectedIndex to 0
           set outsdd::SelectedIndex to 0
           set runnersdd::SelectedIndex to 0
           if catcherdd::Items::Count not = 0
               set catcherdd::SelectedIndex to 0.
           if self::Session::Item("DIALOG-CNT-IDX") = null
               set countdd::SelectedIndex to 0
           else
               set countdd::SelectedIndex to self::Session::Item("DIALOG-CNT-IDX") as binary-long
               set DIALOG-CNT-IDX TO countdd::SelectedIndex + 1
               set DIALOG-COUNT-MASTER TO countdd::SelectedItem.
           set pitchlocdd::SelectedIndex to 0
           set pitchtypedd::SelectedIndex to 0
           set scoredd::SelectedIndex to 0
           set fieldingdd::SelectedIndex to 0
       
      *     attach method self::MouseDownploc to szonebox::MouseDown
      *     attach method self::MouseUpploc to szonebox::MouseUp
      *     attach method self::MouseMoveloc to szonebox::MouseMove

      *     move 1 to SH-BAT300-FLAG
      *    CHECK IF WE HAVE A TEMP FILE TO PROCESS
           move "FC" to BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.              
           move "IN" to BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                    
           IF BAT310-BYPASS-FLAG = "Y"
      *        invoke selectionButton_ModalPopupExtender::Show
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "openModal" ,"var showModal = 1;", true)
           else
               invoke self::Recalc.
           invoke self::bat300
           goback.
       end method.
       
      *#####               Client Callback Implementation             #####
      *##### (https://msdn.microsoft.com/en-us/library/ms178208.aspx) #####
       
       method-id RaiseCallbackEvent public.
       local-storage section.
       01 actionFlag type String.
       01 methodArg type String.       

       procedure division using by value eventArgument as String.
           unstring eventArgument
               delimited by "|"
               into actionFlag, methodArg
           end-unstring.
           
           if actionFlag = "od"
               set callbackReturn to actionFlag & "|" & self::SetGameDates(methodArg)
           else if actionFlag = "pt"
               set callbackReturn to actionFlag & "|" & self::pTeamOKButton_Click(methodArg)
           else if actionFlag = "bt"
               set callbackReturn to actionFlag & "|" & self::bTeamOKButton_Click(methodArg)
           else if actionFlag = "pa"
               set callbackReturn to actionFlag & "|" & self::pitcherallButton_Click()
           else if actionFlag = "ba"
               set callbackReturn to actionFlag & "|" & self::batterallButton_Click()
           else if actionFlag = "sp"
               invoke self::selectpitcherButton_Click()
               set callbackReturn to actionFlag & "|"
           else if actionFlag = "sb"
               invoke self::selectbatterButton_Click()
               set callbackReturn to actionFlag & "|"
           else if actionFlag = 'lr'
               set callbackReturn to actionFlag & "|" & self::populateTeamAsync(methodArg)
           else if actionFlag = 'po'
               set callbackReturn to actionFlag & "|" & self::playerOKButton_Click(methodArg)
           
      *    Pitch Buttons
           else if actionFlag = "pb"
               set callbackReturn to actionFlag & "|" & self::prevButton_Click()
           else if actionFlag = "nb"
               set callbackReturn to actionFlag & "|" & self::nextButton_Click()
           else if actionFlag = "tr"
               invoke self::previousResultsButton_Click()
               set callbackReturn to actionFlag & "|"
           else if actionFlag = "nr"
               invoke self::nextResultsButton_Click()
               set callbackReturn to actionFlag & "|"               
           else if actionFlag = "tt"
               invoke self::previousTypesButton_Click()
               set callbackReturn to actionFlag & "|"
           else if actionFlag = "nt"
               invoke self::nextTypesButton_Click()
               set callbackReturn to actionFlag & "|"    
           else if actionFlag = "mx"
               if methodArg not = ""
                   invoke self::setMaxAB(methodArg)
               end-if
               set callbackReturn to actionFlag & "|" & self::getMaxAB()         
           else if actionFlag = "sm"
               set callbackReturn to actionFlag & "|" & self::getMaxAB()                     
      *    List Box Re-Engineering
           else if actionFlag = 'reload-pitch-list'
               set callbackReturn to actionFlag & "|" & self::printPitchList()
           else if actionFlag = 'reload-previous-list'
               set callbackReturn to actionFlag & "|" & self::printPreviousPitchList()
           else if actionFlag = 'reload-next-list'
               set callbackReturn to actionFlag & "|" & self::printNextPitchList().
       end method.
       
       method-id GetCallbackResult public.
       procedure division returning returnToClient as String.
       
           set returnToClient to callbackReturn.
           
       end method.

      *##### Event Callbacks #####
       
       
       method-id bat300 protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division.
           if self::Session["bat300data"] = null
               set mydata300 to new batsweb.bat300Data
               invoke mydata300::populateData
               set self::Session["bat300data"] to mydata300              
           else
               set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data.
          
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           INITIALIZE BAT300-DIALOG-FIELDS
           MOVE "IN" TO BAT300-ACTION
           invoke bat310rununit::Call("BAT300WEBF").
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                    
           MOVE "I" TO BAT300-ACTION
           invoke bat310rununit::Call("BAT300WEBF").
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                    
           SET LK-PLAYER-FILE TO BAT300-WF-LK-PLAYER-FILE
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
           
           set batterSelectionTextBox::Text to BAT300-BATTER::Trim
           set pitcherSelectionTextBox::Text to BAT300-PITCHER::Trim
       
      *pitcher location radio buttons in "Other Selections"
          if BAT300-PITCHER-LOC-FLAG = " "
            set allLocRadioButton::Checked to true
          else if BAT300-PITCHER-LOC-FLAG = "H"
            set pitchHomeRadioButton::Checked to true
          else if BAT300-PITCHER-LOC-FLAG = "A"
            set pitchAwayRadioButton::Checked to true.
           
      *hides NL and AL buttons for college  
      *     if SH-BATS-PRODUCT-FLAG is not = " "
      *         set btnALBatter::Visible to false
      *         set btnALPitcher::Visible to false
      *         set btnNLBatter::Visible to false
      *         set btnNLPitcher::Visible to false.
               
      *"Additional Pitcher Options" radio buttons & display field        
           if BAT300-PITCHER-TYPE-FLAG = "P"
               set pitcherpowerRadioButton::Checked to true
           else if BAT300-PITCHER-TYPE-FLAG = "A" or BAT300-PITCHER-TYPE-FLAG = " "
               set pitcheranyRadioButton::Checked to true
           else if BAT300-PITCHER-TYPE-FLAG = "C"  
               set pitchercontrolRadioButton::Checked to true
           else if BAT300-PITCHER-TYPE-FLAG = "B"   
               set pitcherbreakingRadioButton::Checked to true
           else 
               set pitchercustomRadioButton::Checked to true.
           SET pitcheroptionsTextBox::Text to BAT300-PITCHER-TYPE-FLAG::Trim.
           
      *"Additional Batter Options" radio buttons & display field
           if BAT300-BATTER-TYPE-FLAG = "P"
               set batterpowerRadioButton::Checked to true
           else if BAT300-BATTER-TYPE-FLAG = "A" or BAT300-BATTER-TYPE-FLAG = " "
               set batteranyRadioButton::Checked to true
           else if BAT300-BATTER-TYPE-FLAG = "S"  
               set battersingleRadioButton::Checked to true
           else
               set battercustomRadioButton::Checked to true.
           SET batteroptionsTextBox::Text to BAT300-BATTER-TYPE-FLAG::Trim.
               
      *options for "Individual Pitchers Only" radio buttons
           if BAT300-START-R-FLAG = "A"
               set allinningsRadioButton::Checked to true
           else if BAT300-START-R-FLAG = "S"  
               set startinningsRadioButton::Checked to true
           else if BAT300-START-R-FLAG = "R"  
               set reliefRadioButton::Checked to true.
      
      *checkboxes for MaxAbs and My Team's Games Only
           if BAT300-MAX-FLAG = "Y"
               SET maxAtBatsCheckBox::Checked to true
           else
               SET maxAtBatsCheckBox::Checked to false.
               
           if BAT300-TEAM-ONLY-FLAG = "Y"   
               set myCheckBox::Checked to true
           else
               set myCheckBox::Checked to false.

      *Batter handedness radio buttons
           if BAT300-BATTER-BATS-FLAG = "L"
               set batsleftRadioButton::Checked to true
           else if BAT300-BATTER-BATS-FLAG = "R"   
               set batsrightRadioButton::Checked to true
           else
               set batseitherRadioButton::Checked to true.
      
      *Pitcher handedness radio buttons
           if BAT300-PITCHER-THROWS-FLAG = "R"
               set throwsrightRadioButton::Checked to true
           else if BAT300-PITCHER-THROWS-FLAG = "L"    
               set throwsleftRadioButton::Checked to true
           else
               set throwseitherRadioButton::Checked to true.
       
      *Day/Night game time radio buttons
           if BAT300-TIME-FLAG = "D"
               set dayRadioButton::Checked to true
           else if BAT300-TIME-FLAG = "N" 
               set nightRadioButton::Checked to true
           else
               set allTimeRadioButton::Checked to true.
      
      *Show Dodgers custom buttons 
      *     if BAT300-CONTROL-TEAM-NAME = "LOS ANGELES DODGERS"
      *         set btnLABatter::Visible to true
      *         set btnLAPitcher::Visible to true.
               
      *radio buttons for Start/End dates or 'All' dates
           if BAT300-GAME-FLAG = "A"
               SET allstartRadioButton::Checked to true    
           else
               set startDateRadioButton::Checked to true.
           
           if BAT300-END-GAME-FLAG = "A"
               SET allendRadioButton::Checked to true
           else
               set endDateRadioButton::Checked to true.
 
           
           set startDateTextBox::Text to BAT300-GAME-DATE::ToString("00/00/00")
           set endDateTextBox::Text to BAT300-END-GAME-DATE::ToString("00/00/00")
           move 1 to aa. 
       15-loop.
          if aa > BAT300-NUM-TEAMS
               go to 20-done
          else
               invoke thisTeamdd::Items::Add(BAT300-TEAM-NAME(aa))
               invoke teamDropDownList::Items::Add(BAT300-TEAM-NAME(aa))
               invoke pTeamDropDownList::Items::Add(BAT300-TEAM-NAME(aa)).
          add 1 to aa
          go to 15-loop.
       20-done.    
           
       end method.
      
      
      * #######################################
      * Select Boxes for Pitch Modifiers
      * ####################################### 
       method-id result1dd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-RES-IDX to result1dd::SelectedIndex
           set DIALOG-RES-MASTER TO result1dd::SelectedItem
           set self::Session::Item("DIALOG-RES-IDX") to result1dd::SelectedIndex as binary-long
           
           add 1 to DIALOG-RES-IDX
           
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.
       
       method-id result2dd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-RES-IDX2 to result2dd::SelectedIndex
           set DIALOG-RES-MASTER2 TO result2dd::SelectedItem
           set self::Session::Item("DIALOG-RES-IDX2") to result2dd::SelectedIndex as binary-long

           add 1 to DIALOG-RES-IDX2
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.
              
       method-id inndd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-INN-IDX to inndd::SelectedIndex
           set DIALOG-INN-MASTER TO inndd::SelectedItem
           set self::Session::Item("DIALOG-INN-IDX") to inndd::SelectedIndex as binary-long

           add 1 to DIALOG-INN-IDX
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.
       
       method-id outsdd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-OUT-IDX to outsdd::SelectedIndex
           set DIALOG-OUT-MASTER TO outsdd::SelectedItem
           set self::Session::Item("DIALOG-OUT-IDX") to outsdd::SelectedIndex as binary-long

           add 1 to DIALOG-OUT-IDX
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.
       
       method-id catcherdd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-CAT-IDX to catcherdd::SelectedIndex
           set DIALOG-CAT-MASTER TO catcherdd::SelectedItem
           set self::Session::Item("DIALOG-CAT-IDX") to catcherdd::SelectedIndex as binary-long

           add 1 to DIALOG-CAT-IDX
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.       
       
       method-id runnersdd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-RUN-IDX to runnersdd::SelectedIndex
           set DIALOG-RUN-MASTER TO runnersdd::SelectedItem
           set self::Session::Item("DIALOG-RUN-IDX") to runnersdd::SelectedIndex as binary-long

           add 1 to DIALOG-RUN-IDX
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.  
       
       method-id pitchtypedd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-PTY-IDX to pitchtypedd::SelectedIndex
           set DIALOG-PTY-MASTER TO pitchtypedd::SelectedItem
           set self::Session::Item("DIALOG-PTY-IDX") to pitchtypedd::SelectedIndex as binary-long

           add 1 to DIALOG-PTY-IDX
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.  
       
       method-id pitchlocdd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set DIALOG-PLO-IDX to pitchlocdd::SelectedIndex
           set DIALOG-PLO-MASTER TO pitchlocdd::SelectedItem
           set self::Session::Item("DIALOG-PLO-IDX") to pitchlocdd::SelectedIndex as binary-long

           add 1 to DIALOG-PLO-IDX
           invoke self::Recalc.
      *    invoke self::Response::Redirect(self::Request::RawUrl)
       end method.  
       
       method-id countdd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
               
           set DIALOG-CNT-IDX to countdd::SelectedIndex
           set DIALOG-COUNT-MASTER TO countdd::SelectedItem
           set self::Session::Item("DIALOG-CNT-IDX") to countdd::SelectedIndex as binary-long
           add 1 to DIALOG-CNT-IDX

           invoke self::Recalc.
           
           invoke self::Response::Redirect(self::Request::RawUrl)

       end method.  
      * #######################################
        
        
       method-id resetButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           move 0 to countdd::SelectedIndex
           set DIALOG-CNT-IDX to (countdd::SelectedIndex + 1)
           set DIALOG-COUNT-MASTER to countdd::SelectedItem
           move 0 to pitchlocdd::SelectedIndex
           set DIALOG-PLO-IDX to (pitchlocdd::SelectedIndex + 1)
           set DIALOG-PLO-MASTER to pitchlocdd::SelectedItem   
           move 0 to pitchtypedd::SelectedIndex
           set DIALOG-PTY-IDX to (pitchtypedd::SelectedIndex + 1)
           set DIALOG-PTY-MASTER to pitchtypedd::SelectedItem       
           move 0 to catcherdd::SelectedIndex
           set DIALOG-CAT-IDX to (countdd::SelectedIndex + 1)
           set DIALOG-CAT-MASTER to countdd::SelectedItem                
           move 0 to result1dd::SelectedIndex
           set DIALOG-RES-IDX to (result1dd::SelectedIndex + 1)
           set DIALOG-RES-MASTER TO result1dd::SelectedItem
           move 0 to result2dd::SelectedIndex
           set DIALOG-RES-IDX2 to (result2dd::SelectedIndex + 1)
           set DIALOG-RES-MASTER2 TO result2dd::SelectedItem
           move 0 to runnersdd::SelectedIndex
           set DIALOG-RUN-MASTER to outsdd::SelectedItem
           set DIALOG-RUN-IDX to (outsdd::SelectedIndex + 1)           
           move 0 to outsdd::SelectedIndex
           set DIALOG-OUT-MASTER to outsdd::SelectedItem
           set DIALOG-OUT-IDX to (outsdd::SelectedIndex + 1)
           move 0 to inndd::SelectedIndex
           set DIALOG-INN-MASTER to outsdd::SelectedItem
           set DIALOG-INN-IDX to (outsdd::SelectedIndex + 1)
           MOVE "RA" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                    
           invoke self::Recalc.
      *     invoke self::Response::Redirect(self::Request::RawUrl)
       end method.
       
       method-id Recalc protected.
       local-storage section.
       01  avg         type Double.
       01  mypen       type Pen.

       01  ws-x        pic 9(4).
       01  ws-y        pic 9(4).
       01  ws-new-x1        pic 9(4).
       01  ws-new-y1        pic 9(4).
       01  ws-x2        pic 9(4).
       01  ws-y2        pic 9(4).
       01  drawArea          type Bitmap.
       01  g           type Graphics.
       01  WORKF                       PIC S999   VALUE ZERO.

       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           move "RE" to BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.         
               
           set batterTextBox::Text to DIALOG-BATTER::Trim
           set pitcherTextBox::Text to DIALOG-PITCHER::Trim
           set gamesTextBox::Text to DIALOG-GAME-RANGE::Trim
           set locationTextBox::Text to DIALOG-GAME-LOC::Trim
           set gValue::Text to BAT310-G::ToString
           set abValue::Text to BAT310-AB::ToString
           set hValue::Text to BAT310-H::ToString
           set doubleValue::Text to BAT310-2B::ToString
           set tripleValue::Text to BAT310-3B::ToString
           set hrValue::Text to BAT310-HR::ToString
           set rbiValue::Text to BAT310-RBI::ToString
           set bbValue::Text to BAT310-BB::ToString
           set kValue::Text to BAT310-K::ToString
           set sacValue::Text to BAT310-SAC::ToString
           set dpValue::Text to BAT310-DP::ToString
           set hbpValue::Text to BAT310-HBP::ToString
           set tpaValue::Text to BAT310-TPA::ToString
           set avg to BAT310-BA
           set avgValue::Text to avg::ToString("#.000")
           set avg to BAT310-SP
           set slgValue::Text to avg::ToString("#.000")
           set avg to BAT310-OBP
           set obpValue::Text to avg::ToString("#.000")
           set avg to BAT310-OPS
           set opsValue::Text to avg::ToString("#.000")
           set fbValue::Text to BAT310-FB::ToString
           set gbValue::Text to BAT310-GB::ToString
           set ldValue::Text to BAT310-LD::ToString
           set puValue::Text to BAT310-PU::ToString
           set buValue::Text to BAT310-BU::ToString
           set hardValue::Text to BAT310-HARD::Trim
           set medValue::Text to BAT310-MEDIUM::Trim
           set softValue::Text to BAT310-SOFT::Trim
      
           invoke printPitchList()
           
           IF BAT310-INFIELD-IP = "Y"
                  MOVE "if1.png" TO BAT310-BPARK-BITMAP.

      *      if HitLocationsform = null or HitLocationsform::IsDisposed
      *          next sentence
      *      else
      *          invoke HitLocationsform::Recalc.


       end method.
       
       method-id printPitchList final private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division returning pitchList as String.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set pitchList to ""
           
      *    invoke plListBox::Items::Clear

           move 1 to aa.
       5-loop.
           if aa > BAT310-NUM-PITCH-LIST
               go to 10-done.
           INSPECT BAT310-PITCH-DESC(AA) REPLACING ALL " " BY X'A0'
      *    invoke plListBox::Items::Add(BAT310-PITCH-DESC(AA))
           set pitchList to pitchlist & BAT310-PITCH-DESC(AA) & ';'
           add 1 to aa.
           go to 5-loop.
       10-done.
       
       end method.

       method-id printNextPitchList final private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division returning pitchList as String.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set pitchList to ""
           
      *    invoke plListBox::Items::Clear

           move 1 to aa.
       5-loop.
           if aa > BAT310-NP-NUM-PITCH-LIST
               go to 10-done.
           INSPECT BAT310-NP-PITCH-DESC(AA) REPLACING ALL " " BY X'A0'
      *    invoke plListBox::Items::Add(BAT310-PITCH-DESC(AA))
           set pitchList to pitchlist & BAT310-NP-PITCH-DESC(AA) & ';'
           add 1 to aa.
           go to 5-loop.
       10-done.
       
       end method.

       method-id printPreviousPitchList final private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division returning pitchList as String.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set pitchList to ""
           
      *    invoke plListBox::Items::Clear

           move 1 to aa.
       5-loop.
           if aa > BAT310-PV-NUM-PITCH-LIST
               go to 10-done.
           INSPECT BAT310-PV-PITCH-DESC(AA) REPLACING ALL " " BY X'A0'
      *    invoke plListBox::Items::Add(BAT310-PITCH-DESC(AA))
           set pitchList to pitchlist & BAT310-PV-PITCH-DESC(AA) & ';'
           add 1 to aa.
           go to 5-loop.
       10-done.
       
       end method.
       
       method-id testCallback final protected.
       local-storage section.
       01 i type Int32.
       01 s type String.
       01 temp type String[].
       01 array type Int32[].
       procedure division using by value sender as object e as type System.EventArgs.

           set s to pitchListValueField::Value
           set temp to s::Split(';')
           set s to pitchListIndexField::Value
           set temp to s::Split(';')
       
           set size of array to temp::Length
           
           perform varying i from 0 by 1 until i >= temp::Length
               set array[i] to type Int32::Parse(temp[i])
           end-perform
           

           set s to ""
       end method.
       
       method-id reloadCatchers final private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           move 1 to aa.
           invoke catcherdd::Items::Clear.
       catcher-loop.
           if aa > DIALOG-CAT-NUM-ENTRIES
               go to catcher-done.
           invoke catcherdd::Items::Add(DIALOG-CAT(AA)::Trim)
           add 1 to aa
           go to catcher-loop.
       catcher-done.
           set catcherdd::SelectedIndex to 0
       end method.      
    
       method-id btnPitchTypes_Click final private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           move "T" to BAT310-DISPLAY-TYPE
           INVOKE self::Recalc
       end method.

       method-id btnPitchResults_Click final private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           move "R" to BAT310-DISPLAY-TYPE
           INVOKE self::Recalc
       end method.
  
       method-id selectpitcherButton_Click private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           MOVE "P" to BAT300-IND-PB-FLAG
           MOVE "I" to BAT300-PITCHER-SEL-FLAG
           MOVE "RP" to BAT300-ACTION
           
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.              
           move " " to BAT300-SEL-TEAM
           
      * Called Client-Side    
      *    set teamList to self::populateTeamAsync(selectedTeam)     
      *    invoke ipHiddenField_ModalPopupExtender::Show
       end method.    
    
       method-id selectbatterButton_Click private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           MOVE "B" to BAT300-IND-PB-FLAG
      *    MOVE "I" to BAT300-PITCHER-SEL-FLAG
           MOVE "I" to BAT300-BATTER-SEL-FLAG
           MOVE "RB" to BAT300-ACTION
           
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.              
           move " " to BAT300-SEL-TEAM
      
      * Called Client-Side:
      *    invoke self::populateTeam.     
      *    invoke ipHiddenField_ModalPopupExtender::Show
       end method.    
       
       method-id populateTeamAsync private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value selectedTeam as String
                          returning teamList as String.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set BAT300-SEL-TEAM to selectedTeam
           
           if BAT300-IND-PB-FLAG = "P"
               MOVE BAT300-SEL-TEAM TO BAT300-PITCHER-ROSTER-TEAM
               MOVE "RP" TO BAT300-ACTION  
           else
               MOVE BAT300-SEL-TEAM TO BAT300-BATTER-ROSTER-TEAM
               MOVE "RB" TO BAT300-ACTION  
           end-if.
         
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.              
           set teamList to ""
           move 1 to aa.
       5-loop.
           if aa > BAT300-ROSTER-NUM-ENTRIES
               go to 10-done
           else
               set teamList to teamList & aa & "," & BAT300-ROSTER-NAME(aa) & " " & BAT300-ROSTER-POS(aa) & ";"
           add 1 to aa.
           go to 5-loop.
       10-done.

       end method.
      
       method-id playerOKButton_Click protected.
       local-storage section.
       01 selectedPlayer type String.
       01 selectionType type String.
       01 playerName type String.
       01 playerIdStr type String.
       01 playerId type Single.
       
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value selectedPlayerInfo as String 
                          returning playerNames as String.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
         
           unstring selectedPlayerInfo delimited ";" into selectionType, selectedPlayer
           
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
               
               
           if selectionType = "located"
      *        Player is selected using autofill textbox
               SET LK-PLAYER-FILE TO BAT300-WF-LK-PLAYER-FILE
               MOVE SPACES TO PLAY-ALT-KEY
               unstring selectedPlayer delimited ", " into play-last-name, play-first-name
               open input play-file
               READ PLAY-FILE KEY PLAY-ALT-KEY
               set BAT300-SEL-PLAYER to play-first-name::Trim & " " & play-last-name 
               MOVE play-player-id to BAT300-LOCATE-SEL-ID
               move "LP" to BAT300-ACTION
               invoke bat310rununit::Call("BAT300WEBF")
               if ERROR-FIELD NOT = SPACES
                   set playerNames to "er|" & ERROR-FIELD
      *            invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
                   move spaces to ERROR-FIELD
                   exit method
               END-IF    
               IF BAT300-IND-PB-FLAG = "P"  
                   MOVE play-player-id to BAT300-SAVE-PITCHER-ID 
               ELSE
                   MOVE play-player-id to BAT300-SAVE-BATTER-ID 
               end-if
               CLOSE PLAY-FILE
           else 
      *        Player is selected using list box    
               unstring selectedPlayer delimited by "," into playerIdStr, playerName
           
               set playerId to type Single::Parse(playerIdStr)
           
               MOVE playerName to BAT300-SEL-PLAYER
           
               if BAT300-IND-PB-FLAG = "P" THEN
                   MOVE BAT300-ROSTER-ID(playerId) TO BAT300-SAVE-PITCHER-ID
               ELSE
                   MOVE BAT300-ROSTER-ID(playerId) TO BAT300-SAVE-BATTER-ID
               END-IF.        .
           
           if BAT300-IND-PB-FLAG = "P"
               move BAT300-SEL-TEAM to BAT300-PITCHER-ROSTER-TEAM  
               move BAT300-SEL-PLAYER to BAT300-PITCHER-DSP-NAME  
               move " " to BAT300-PITCHER-THROWS-FLAG
           else
               MOVE BAT300-SEL-TEAM TO BAT300-BATTER-ROSTER-TEAM
               MOVE BAT300-SEL-PLAYER TO BAT300-BATTER-DSP-NAME  
               move " " to BAT300-BATTER-BATS-FLAG
           end-if.
           MOVE "TI" TO BAT300-ACTION
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                         
           MOVE " " to BAT300-IND-PB-FLAG  
           
      *    
      *    set pitcherTextBox::Text to BAT300-PITCHER
      *    set batterTextBox::Text to BAT300-BATTER
           
           set playerNames to BAT300-PITCHER & ';' & BAT300-BATTER
       end method.  
   
       method-id pitcherallButton_Click private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".   
       procedure division returning pitcherSelection as String.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           
           MOVE "A" to BAT300-PITCHER-SEL-FLAG
           MOVE "TI" to BAT300-ACTION
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                         
      *    Called on client side:     
      *    set pitcherSelectionTextBox::Text to BAT300-PITCHER::Trim
           
           set pitcherSelection to BAT300-PITCHER::Trim
       end method.

       method-id batterallButton_Click private.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".   
       procedure division returning batterSelection as String.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           MOVE "A" to BAT300-BATTER-SEL-FLAG
           MOVE "TI" to BAT300-ACTION
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                         
      *    Called on client side:     
      *    set batterSelectionTextBox::Text to BAT300-BATTER::Trim
           
           set batterSelection to BAT300-BATTER::Trim
       end method.
       
       method-id resetselectionButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set allStartRadioButton::Checked to True
           set allendRadioButton::Checked to True 
           set allLocRadioButton::Checked to true
           set allTimeRadioButton::Checked to true
           set maxAtBatsCheckBox::Checked to false
           set myCheckBox::Checked to false
           set batseitherRadioButton::Checked to true
           set throwseitherRadioButton::Checked to true
           set allinningsRadioButton::Checked to true
           set batteranyRadioButton::Checked to true
           set pitcheranyRadioButton::Checked to true
       end method.

       method-id goButton_Click protected.
       local-storage section.
       01 gmDate        type Single.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
               
           
           invoke type System.Single::TryParse(startDateTextBox::Text::ToString::Replace("/", ""), by reference gmDate)
           set BAT300-GAME-DATE to gmDate.
               
           invoke type System.Single::TryParse(endDateTextBox::Text::ToString::Replace("/", ""), by reference gmDate)
           set BAT300-END-GAME-DATE to gmDate.
               
           MOVE "GO" to BAT300-ACTION
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.              
           invoke self::reloadCatchers
           invoke self::Recalc
           
           invoke self::Response::Redirect(self::Request::RawUrl)

       end method.
       
       method-id szoneImageButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.Web.UI.ImageClickEventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           set MOUSEX, MOUSEX2 to e::X
           set MOUSEY, MOUSEY2 to e::Y
           move "MO" to BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD
           else    
               invoke self::batstube.
       end method.
       
       method-id allButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           MOVE "VA" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
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
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer   
           set vidPaths to ""
PM         set vidTitles to ""
           move 1 to aa.
       lines-loop.
           if aa > BAT310-WF-VID-COUNT
               go to lines-done.
           
           
      *    REFACTOR BATSTUBE SETUP --> SINGLE CLASS     
PM         set vidPaths to vidPaths & BAT310-WF-VIDEO-PATH(aa) & BAT310-WF-VIDEO-A(aa) & ";"          
PM         set vidTitles to vidTitles & BAT310-WF-VIDEO-TITL(aa) & ";"
           
           if BAT310-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BAT310-WF-VIDEO-PATH(aa) & BAT310-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BAT310-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BAT310-WF-VIDEO-PATH(aa) & BAT310-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BAT310-WF-VIDEO-D(aa) not = spaces
               set vidPaths to vidPaths & BAT310-WF-VIDEO-PATH(aa) & BAT310-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
               
           add 1 to aa.
           go to lines-loop.
       lines-done.
PM         set self::Session::Item("video-paths") to vidPaths
PM         set self::Session::Item("video-titles") to vidTitles
      *    END REFACTOR
           
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "callcallBatstube", "callBatstube();", true).
       end method.
       
       method-id allStartRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "A" to BAT300-GAME-FLAG
       end method.

       method-id startDateRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "D" to BAT300-GAME-FLAG
       end method.

       method-id allEndRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
          MOVE "A" to BAT300-END-GAME-FLAG
       end method.

       method-id endDateRadioButton_CheckedChanged protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "D" to BAT300-END-GAME-FLAG
       end method.
       
       method-id allLocRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           move " " to BAT300-BATTER-LOC-FLAG
           move " " to BAT300-PITCHER-LOC-FLAG.
       end method.

       method-id pitchHomeRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           move "A" to BAT300-BATTER-LOC-FLAG
           move "H" to BAT300-PITCHER-LOC-FLAG.
       end method.

       method-id pitchAwayRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           move "H" to BAT300-BATTER-LOC-FLAG
           move "A" to BAT300-PITCHER-LOC-FLAG.
       end method.

       method-id allTimeRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "A" to BAT300-TIME-FLAG.
       end method.

       method-id dayRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "D" to BAT300-TIME-FLAG.
       end method.

       method-id nightRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "N" to BAT300-TIME-FLAG.
       end method.

       method-id maxAtBatsCheckBox_CheckedChanged protected.
       01 abnum    type Single.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           if maxAtBatsCheckBox::Checked
               move "Y" to BAT300-MAX-FLAG
      *         set BAT300-MAX-NUM TO abnum
            else
               move "N" to BAT300-MAX-FLAG.
       end method.
       
       method-id setMaxAB protected.
       01 abnum    type Single.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".       
       procedure division using by value maxabs as String.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           invoke type System.Single::TryParse(maxabs, by reference abnum)
           set BAT300-MAX-NUM TO abnum.
       end method.
       
       method-id getMaxAB protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".       
       procedure division returning maxabs as String.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer           
           set maxabs to BAT300-MAX-NUM.
       end method.
       
       

       method-id myCheckBox_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           if myCheckBox::Checked
               move "Y" to BAT300-TEAM-ONLY-FLAG
            else
               move "N" to BAT300-TEAM-ONLY-FLAG.
       end method.
 

       method-id throwsrightRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if throwsrightRadioButton::Checked 
               MOVE "R" to BAT300-PITCHER-THROWS-FLAG
               MOVE "TI" to BAT300-ACTION  
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER::Trim.
       end method.

       method-id throwsleftRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if throwsleftRadioButton::Checked
               MOVE "L" to BAT300-PITCHER-THROWS-FLAG
               MOVE "TI" to BAT300-ACTION  
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER::Trim.
       end method.

       method-id throwseitherRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if throwseitherRadioButton::Checked
               MOVE " " to BAT300-PITCHER-THROWS-FLAG
               MOVE "TI" to BAT300-ACTION  
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER::Trim.
       end method.
       
       method-id pitcheranyRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if pitcheranyRadioButton::Checked
               MOVE "A" TO BAT300-PITCHER-TYPE-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER::Trim
               SET pitcheroptionsTextBox::Text to BAT300-PITCHER-TYPE-FLAG::Trim.
       end method.

       method-id pitcherpowerRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if pitcherpowerRadioButton::Checked
               MOVE "P" TO BAT300-PITCHER-TYPE-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER
               SET pitcheroptionsTextBox::Text to BAT300-PITCHER-TYPE-FLAG::Trim.
       end method.

       method-id pitchercontrolRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if pitchercontrolRadioButton::Checked
               MOVE "C" TO BAT300-PITCHER-TYPE-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER
               SET pitcheroptionsTextBox::Text to BAT300-PITCHER-TYPE-FLAG::Trim.
       end method.

       method-id pitcherbreakingRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if pitcherbreakingRadioButton::Checked
               MOVE "B" TO BAT300-PITCHER-TYPE-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER
               SET pitcheroptionsTextBox::Text to BAT300-PITCHER-TYPE-FLAG::Trim.
       end method.

       method-id pitchercustomRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
           if pitchercustomRadioButton::Checked
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               SET pitcherSelectionTextBox::Text to BAT300-PITCHER
               SET pitcheroptionsTextBox::Text to BAT300-PITCHER-TYPE-FLAG::Trim.
       end method.

       method-id allinningsRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           if allinningsRadioButton::Checked
               MOVE "A" TO BAT300-START-R-FLAG.
       end method.

       method-id reliefRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           if reliefRadioButton::Checked
               MOVE "S" TO BAT300-START-R-FLAG.
       end method.

       method-id startinningsRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           if startinningsRadioButton::Checked
               MOVE "R" TO BAT300-START-R-FLAG.
       end method.
 
       method-id batsrightRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
           if batsrightRadioButton::Checked
               MOVE "R" TO BAT300-BATTER-BATS-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               set batterSelectionTextBox::Text to BAT300-BATTER::Trim.
       end method.

       method-id batsleftRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
            if batsleftRadioButton::Checked
               MOVE "L" TO BAT300-BATTER-BATS-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               set batterSelectionTextBox::Text to BAT300-BATTER::Trim.
       end method.

       method-id batseitherRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
            if batseitherRadioButton::Checked
               MOVE " " TO BAT300-BATTER-BATS-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               set batterSelectionTextBox::Text to BAT300-BATTER::Trim.
       end method.

       method-id batteranyRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
           if batteranyRadioButton::Checked
               MOVE "A" TO BAT300-BATTER-TYPE-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               set batteroptionsTextBox::Text to BAT300-BATTER-TYPE-FLAG::Trim
               set batterSelectionTextBox::Text to BAT300-BATTER::Trim.
       end method.

       method-id batterpowerRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
           if batterpowerRadioButton::Checked
               MOVE "P" TO BAT300-BATTER-TYPE-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               set batteroptionsTextBox::Text to BAT300-BATTER-TYPE-FLAG::Trim
               set batterSelectionTextBox::Text to BAT300-BATTER::Trim.
       end method.

       method-id battersingleRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
           if battersingleRadioButton::Checked
               MOVE "S" TO BAT300-BATTER-TYPE-FLAG
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               set batteroptionsTextBox::Text to BAT300-BATTER-TYPE-FLAG::Trim
               set batterSelectionTextBox::Text to BAT300-BATTER::Trim.
       end method.

       method-id battercustomRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
           if battercustomRadioButton::Checked
               MOVE "TI" TO BAT300-ACTION
               invoke bat310rununit::Call("BAT310WEBF")            
               set batteroptionsTextBox::Text to BAT300-BATTER-TYPE-FLAG::Trim
               set batterSelectionTextBox::Text to BAT300-BATTER::Trim.
       end method.
  
       method-id typesButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           move "T" to BAT310-DISPLAY-TYPE
           INVOKE self::Recalc
       end method.

       method-id resultsButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           move "R" to BAT310-DISPLAY-TYPE
           INVOKE self::Recalc
       end method.

       method-id videosButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           MOVE "SC" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                 
      *     set ComparePlaysForm to new type BatterPitcherBreakdown.ComparePlaysForm
      *     invoke ComparePlaysForm::Show
       end method.
  
       method-id prevButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division returning prevListBoxItems as String.
       
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           
           IF DIALOG-CNT-IDX < 3 or DIALOG-CNT-IDX > 13
               set prevListBoxItems to "error|You must select a pitch count!"
               exit method
           Else
               set prevListBoxItems to self::previousLb_Load().
       end method.

       method-id nextButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division returning nextListBoxItems as String.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           IF DIALOG-CNT-IDX < 2 or DIALOG-CNT-IDX > 13
               set nextListBoxItems to "error|You must select a pitch count!"
               exit method
           Else
               set nextListBoxItems to self::nextLb_Load().
       end method.
      * ########################
      * One Click Dates
      * ########################
       method-id allGamesButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "A" to BAT300-DATE-CHOICE-FLAG
           MOVE "A" to BAT300-GAME-FLAG
           MOVE "A" to BAT300-END-GAME-FLAG
           set startDateRadioButton::Checked to false
           set endDateRadioButton::Checked to false
           set allStartRadioButton::Checked to true
           set allEndRadioButton::Checked to true
       end method.

       method-id currentYearButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat310data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "C" to BAT300-DATE-CHOICE-FLAG
           MOVE "DC" to BAT300-ACTION
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           invoke bat310rununit::Call("BAT300WEBF")

           MOVE "D" to BAT300-GAME-FLAG
           MOVE "D" to BAT300-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set startDateTextBox::Text to BAT300-GAME-DATE::ToString("##/##/##").
           set endDateTextBox::Text to BAT300-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id pastYearButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "P" to BAT300-DATE-CHOICE-FLAG
           MOVE "DC" to BAT300-ACTION
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           invoke bat310rununit::Call("BAT300WEBF")
           MOVE "D" to BAT300-GAME-FLAG
           MOVE "D" to BAT300-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set startDateTextBox::Text to BAT300-GAME-DATE::ToString("##/##/##").
           set endDateTextBox::Text to BAT300-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id twoWeeksButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "W" to BAT300-DATE-CHOICE-FLAG
           MOVE "DC" to BAT300-ACTION
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           invoke bat310rununit::Call("BAT300WEBF")

           MOVE "D" to BAT300-GAME-FLAG
           MOVE "D" to BAT300-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set startDateTextBox::Text to BAT300-GAME-DATE::ToString("##/##/##").
           set endDateTextBox::Text to BAT300-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id currentMonthButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "M" to BAT300-DATE-CHOICE-FLAG
           MOVE "DC" to BAT300-ACTION
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           invoke bat310rununit::Call("BAT300WEBF")
           MOVE "D" to BAT300-GAME-FLAG
           MOVE "D" to BAT300-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set startDateTextBox::Text to BAT300-GAME-DATE::ToString("##/##/##").
           set endDateTextBox::Text to BAT300-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id twoMonthsButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "2" to BAT300-DATE-CHOICE-FLAG
           MOVE "DC" to BAT300-ACTION
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           invoke bat310rununit::Call("BAT300WEBF")
           MOVE "D" to BAT300-GAME-FLAG
           MOVE "D" to BAT300-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set startDateTextBox::Text to BAT300-GAME-DATE::ToString("##/##/##").
           set endDateTextBox::Text to BAT300-END-GAME-DATE::ToString("##/##/##").
       end method.

       method-id threeMonthsButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           MOVE "3" to BAT300-DATE-CHOICE-FLAG
           MOVE "DC" to BAT300-ACTION
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           invoke bat310rununit::Call("BAT300WEBF")
           MOVE "D" to BAT300-GAME-FLAG
           MOVE "D" to BAT300-END-GAME-FLAG
           set startDateRadioButton::Checked to true
           set endDateRadioButton::Checked to true.
           set startDateTextBox::Text to BAT300-GAME-DATE::ToString("##/##/##").
           set endDateTextBox::Text to BAT300-END-GAME-DATE::ToString("##/##/##").
       end method. 
      * ########################
      * #### Helper Methods ####
      * ########################
        
        
      * #### One Click Dates ####
       method-id SetGameDates private.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".
       procedure division using by value dateChoiceFlag as String
                          returning startEndDates as String.
                          
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
               set bat310rununit to self::Session::Item("310rununit")
                   as type RunUnit           
           if dateChoiceFlag = "A"
               MOVE "A" to BAT300-DATE-CHOICE-FLAG
               MOVE "A" to BAT300-GAME-FLAG
               MOVE "A" to BAT300-END-GAME-FLAG
               set startEndDates to "ALL"
           else
               MOVE dateChoiceFlag to BAT300-DATE-CHOICE-FLAG
               MOVE "D" to BAT300-GAME-FLAG
               MOVE "D" to BAT300-END-GAME-FLAG
               MOVE "DC" to BAT300-ACTION
               invoke bat310rununit::Call("BAT300WEBF")
               if ERROR-FIELD NOT = SPACES
                   invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
                   move spaces to ERROR-FIELD
               end-if    
               set startEndDates to BAT300-GAME-DATE::ToString("##/##/##") & ";" & BAT300-END-GAME-DATE::ToString("##/##/##").
       end method.
       
      * ######################## 
      * #### Player Selection ####
      * ######################## 
        
      * ########################
      * #### Team Selection ####
      * ########################   
       method-id pTeamOKButton_Click private.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".  
       procedure division using by value teamName as String
                          returning pitcherTeam as String.
                          
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           
           set BAT300-PITCHER-TEAM to teamName.
           
           MOVE "T " to BAT300-PITCHER-SEL-FLAG
           MOVE "T" to BAT300-ACTION
           MOVE "TI" to BAT300-ACTION
           
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.           
      *    Called on client side: 
      *    set pitcherSelectionTextBox::Text to BAT300-PITCHER::Trim
      *    set pitcherTextBox::Text to BAT300-PITCHER
           
           set pitcherTeam to BAT300-PITCHER::Trim
           
       end method.
       
       method-id bTeamOKButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat300_dg.CPB".  
       procedure division using by value teamName as String
                          returning batterTeam as String.
                          
           set mydata300 to self::Session["bat300data"] as type batsweb.bat300Data
           set address of BAT300-DIALOG-FIELDS to myData300::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           
           set BAT300-BATTER-TEAM to teamName.
               
           MOVE "T " to BAT300-BATTER-SEL-FLAG
           MOVE "T" to BAT300-ACTION
           MOVE "TI" to BAT300-ACTION
           
           invoke bat310rununit::Call("BAT300WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                
      * Called Client-Side    
      *    SET batterSelectionTextBox::Text to BAT300-BATTER::Trim
      *    set batterTextBox::Text to BAT300-BATTER
      *    invoke bHiddenFieldTeam_ModalPopupExtender::Hide
            
           set batterTeam to BAT300-BATTER::Trim
       end method.
       
      * ########################   
        
       method-id rangeCheckBox_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           if maxAtBatsCheckBox::Checked
               set BAT310-VEL-FLAG to "Y"
           else
               set BAT310-VEL-FLAG to "N".
       end method.
       
       method-id rangeGoButton_Click protected.
       local-storage section.
       01  vel         type Single.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           invoke type System.Single::TryParse(lowTextBox::Text::ToString, by reference vel)
           set BAT310-VEL-LO to vel
           invoke type System.Single::TryParse(highTextBox::Text::ToString, by reference vel)
           set BAT310-VEL-HI to vel
           invoke self::Recalc
       end method.
        
       method-id scoredd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set BAT310-SCR-IDX to scoredd::SelectedIndex
           set BAT310-SCR-HDR TO scoredd::SelectedItem
           add 1 to BAT310-SCR-IDX
           invoke self::Recalc
       end method.         
       
       method-id fieldingdd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set BAT310-FIELDING-IDX to pitchtypedd::SelectedIndex
           set BAT310-FIELDING-MASTER TO scoredd::SelectedItem
           add 1 to BAT310-FIELDING-IDX
           invoke self::Recalc
       end method.
       
       method-id thisTeamCheckBox_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           if thisTeamCheckBox::Checked
               set BAT310-CHECK-TEAM-FLAG to "Y"
           else
               set BAT310-CHECK-TEAM-FLAG to "N".
       end method. 
       
       method-id pitcherRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           if pitcherRadioButton::Checked
               set BAT310-CHOOSE-TEAM-FLAG to "P".
       end method. 

       method-id batterRadioButton_CheckedChanged protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           if batterRadioButton::Checked
               set BAT310-CHOOSE-TEAM-FLAG to "B".
       end method. 

       method-id thisTeamdd_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set BAT310-CHOOSE-TEAM TO thisTeamdd::SelectedItem
       end method.
    
       method-id teamGoButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           invoke self::Recalc
       end method. 
       
       method-id ifButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.  
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit       
           if BAT310-INFIELD-IP = "Y"
               set ifButton::Text to "Infield"
               move " " to BAT310-INFIELD-IP
               MOVE "FB" TO BAT310-ACTION
               invoke bat310rununit::Call("BAT310WEBF")
               if ERROR-FIELD NOT = SPACES
                   invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
                   move spaces to ERROR-FIELD
               end-if    
           else
               set ifButton::Text to "Outfield"
               move "Y" to BAT310-INFIELD-IP.
           invoke self::Recalc
       end method.    
              
       method-id hlButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.     
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "callparkdetail", "callparkdetail();", true).
       end method.  
       
       method-id previousPitchesButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit                
           MOVE "PX" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                
           invoke self::batstube
       end method.  

       method-id withNextButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit                
           MOVE "PP" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                
           invoke self::batstube
       end method.  
   
       method-id previousResultsButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
               
               
           MOVE "R" TO BAT310-PV-DISPLAY-TYPE
           
      *    invoke self::Recalc
       end method.  

       method-id previousTypesButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
               
           MOVE "T" TO BAT310-PV-DISPLAY-TYPE
           
      *    invoke self::Recalc
       end method.  
       
       method-id previousLb_Load private.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".       
       procedure division returning lbItems as String.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer       

           move 1 to aa.
       5-loop.
           if aa > BAT310-PV-NUM-PITCH-LIST
               go to 10-done.
           INSPECT BAT310-PV-PITCH-DESC(AA) REPLACING ALL " " BY X'A0'
           
           set lbItems to lbItems & BAT310-PV-PITCH-DESC(AA) & ';'
           
           add 1 to aa.
           go to 5-loop.
       10-done.       
       end method.  
       
       method-id nextPitchesButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit                
           MOVE "NX" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                
           invoke self::batstube
       end method.  

       method-id withPreviousButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit                
           MOVE "NN" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD.                
           invoke self::batstube
       end method.  
   
       method-id nextResultsButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit           
               
               
           MOVE "R" TO BAT310-NP-DISPLAY-TYPE
           
      *    invoke self::Recalc
       end method.  

       method-id nextTypesButton_Click protected.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.     
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit
               
           MOVE "T" TO BAT310-NP-DISPLAY-TYPE
           
      *    invoke self::Recalc
       end method.  
       
       method-id nextLb_Load private.
       linkage section.
            COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".       
       procedure division returning lbItems as String.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer       

           move 1 to aa.
       5-loop.
           if aa > BAT310-NP-NUM-PITCH-LIST
               go to 10-done.
           INSPECT BAT310-NP-PITCH-DESC(AA) REPLACING ALL " " BY X'A0'
           
           set lbItems to lbItems & BAT310-NP-PITCH-DESC(AA) & ';'
           
           add 1 to aa.
           go to 5-loop.
       10-done.       
       end method.  
       

       
