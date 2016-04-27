       class-id batsweb.atbatdetail is partial 
                inherits type System.Web.UI.Page public.
                 
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat360rununit         type RunUnit.
       01 BAT360WEBF                type BAT360WEBF.
       01 mydata type batsweb.bat360Data.
       01 teststring type String protected.


       method-id Page_Load protected.
       local-storage section.
       01 dataLine         type String.

       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat360_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           if self::IsPostBack
               exit method.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set gameDateAt::Text to BAT360-GAME-DATE-DSP::ToString("00/00/00")
           set visTeam::Text to BAT360-I-VIS::Trim
           set homeTeam::Text to BAT360-I-HOME::Trim
           set visScore::Text to BAT360-I-VIS-SCORE::ToString
           set homeScore::Text to BAT360-I-HOME-SCORE::ToString
           set inning::Text to BAT360-I-INNING::ToString
           set currentlyBatting::Text to BAT360-I-CURR-BATTING::ToString
           set pitcher::Text to BAT360-PITCHER::Trim
           set batter::Text to BAT360-BATTER::Trim
           
      *     set gameDateB::Text to BAT360-GAME-DATE-DSP::ToString("00/00/00")
      *     set visTeamB::Text to BAT360-I-VIS::Trim
      *     set homeTeamB::Text to BAT360-I-HOME::Trim
      *     set visScoreB::Text to BAT360-I-VIS-SCORE::ToString
      *     set homeScoreB::Text to BAT360-I-HOME-SCORE::ToString
      *     set inningB::Text to BAT360-I-INNING::ToString
      *     set currentlyBattingB::Text to BAT360-I-CURR-BATTING::ToString       
       
      *     set pitcherTextBox::Text to BAT360-PITCHER::Trim
      *     set batterTextBox::Text to BAT360-BATTER::Trim           
           set outsValue::Text to BAT360-I-OUTS::ToString
           set hitValue::Text to BAT360-I-HIT-DESC::Trim
           set resultValue::Text to BAT360-I-RES-DESC::Trim
           set posValue1::Text to BAT360-I-FIELDER-POS::Trim
           set posValue2::Text to BAT360-I-FIELDER2-POS::Trim
           set fieldedValue1::Text to BAT360-I-FIELDER-NAME::Trim
           set fieldedValue2::Text to BAT360-I-FIELDER2-NAME::Trim
           set flagValue1::Text to BAT360-I-FIELDER-FLAG::Trim
           set flagValue2::Text to BAT360-I-FIELDER2-FLAG::Trim
           set countValue::Text to BAT360-I-FINAL-COUNT::Trim
           set rbiValue::Text to BAT360-I-RBI::ToString
           set catcherValue::Text to BAT360-CATCHER
           move 1 to aa.
       pitch-loop.
           if aa > BAT360-NUM-PITCHES
               go to pitch-done.
           set dataline to (" " & BAT360-P-NUM(aa) & "  " & BAT360-P-TYPE(aa) & "  " & BAT360-P-DESC(aa) &
           " " & BAT360-P-RESULT(aa) & " " & BAT360-P-VEL(aa) & " " & BAT360-P-FLAG(aa) & BAT360-P-FLAG2(AA) & "  " & BAT360-P-VIDEO(aa))
           INSPECT dataline REPLACING ALL " " BY X'A0'
           invoke self::addTableRow(pitchTable, " " & dataLine)
           add 1 to aa
           go to pitch-loop.
       pitch-done.
           goback.
       end method.
 
       method-id printPitchList final private.
       local-storage section.
       01 dataLine         type String. 
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat360_dg.CPB".
       procedure division returning pitchList as String.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer
           set pitchList to ""
           
      *    invoke plListBox::Items::Clear

           move 1 to aa.
       5-loop.
           if aa > BAT360-NUM-PITCHES
               go to 10-done.
           set dataline to (" " & BAT360-P-NUM(aa) & "  " & BAT360-P-TYPE(aa) & "  " & BAT360-P-DESC(aa) &
           " " & BAT360-P-RESULT(aa) & " " & BAT360-P-VEL(aa) & " " & BAT360-P-FLAG(aa) & BAT360-P-FLAG2(AA) & "  " & BAT360-P-VIDEO(aa))
           INSPECT dataline REPLACING ALL " " BY X'A0'
           invoke self::addTableRow(pitchTable, " " & dataLine)
      *     set pitchList to pitchlist & dataLine & ';'
           add 1 to aa.
           go to 5-loop.
       10-done.
       end method.
       
       method-id szoneImageButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.Web.UI.ImageClickEventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit      
           set MOUSEX to e::X
           set MOUSEY to e::Y
           move "MO" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD
           else               
               invoke self::batstube.
           invoke self::printPitchList
       end method.
       
       method-id playButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat360_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer       
           set bat360rununit to self::Session::Item("360rununit")
               as type RunUnit           
           move "PA" to BAT360-ACTION
           invoke bat360rununit::Call("BAT360WEBF")
           if ERROR-FIELD NOT = SPACES
               invoke self::ClientScript::RegisterStartupScript(self::GetType(), "AlertBox", "alert('" & ERROR-FIELD & "');", true)
               move spaces to ERROR-FIELD
           else               
               invoke self::batstube.               
           invoke self::printPitchList
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
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "callcallBatstube", "callBatstube();", true).
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
           
           
       end class.
