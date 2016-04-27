       class-id batsweb.EZvideo is partial
                implements type System.Web.UI.ICallbackEventHandler
                inherits type System.Web.UI.Page public.

       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 batsw060rununit         type RunUnit.
       01 BATSW060WEBF                type BATSW060WEBF.
       01 mydata type batsweb.batsw060Data.
       01 gmDate        type Single.
       01 callbackReturn type String.
       method-id Page_Load protected.
       local-storage section.
       01 cm type ClientScriptManager.
       01 cbReference type String.
       01 callbackScript type String.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".

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
               
      *    Setup - from main menu                          
           if   self::Session["batsw060data"] = null
              set mydata to new batsweb.batsw060Data
              invoke mydata::populateData
              set self::Session["batsw060data"] to mydata
           else
               set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data.
           
              

           if  self::Session::Item("w060rununit") not = null
               set batsw060rununit to self::Session::Item("w060rununit")
               as type RunUnit
                ELSE
                set batsw060rununit to type RunUnit::New()
                set BATSW060WEBF to new BATSW060WEBF
                invoke batsw060rununit::Add(BATSW060WEBF)
                set self::Session::Item("w060rununit") to  batsw060rununit.

           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer

           move "I" to BATSW060-ACTION
           invoke batsw060rununit::Call("BATSW060WEBF")
           set textBox1::Text to BATSW060-START-DATE::ToString("00/00/00")
           set textBox2::Text to BATSW060-END-DATE::ToString("00/00/00")
           invoke self::populate_listbox().
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
           
           if actionFlag = "update-video"
               set callbackReturn to actionFlag & "|" & self::video_Selected(methodArg).
           
       end method.
       
       method-id GetCallbackResult public.
       procedure division returning returnToClient as String.
       
           set returnToClient to callbackReturn.
           
       end method.
      *####################################################################
       method-id populate_listbox protected.
       local-storage section.
           01 dataLine             type String.
       linkage section.
            COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division.
            set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
            set address of BATSW060-DIALOG-FIELDS to myData::tablePointer

            move 1 to aa.
       vid-loop.
           if aa > BATSW060-NUM-VID
               go to vid-done.
           SET dataLine to (BATSW060-V-TEAM(aa) & " " & BATSW060-V-NAME(aa) & " " & BATSW060-V-DSP-DATE(aa)::ToString("0#/##/##") & " " & BATSW060-V-DESC(aa))
           INSPECT dataLine REPLACING ALL " " BY X'A0'
           invoke self::addTableRow(videoTable, " " & dataLine)
           add 1 to aa
           go to vid-loop.
       vid-done.

       end method.

       method-id RadioButtonTeam_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           move "RG" to BATSW060-ACTION
           move 1 to BATSW060-SORT-TYPE.
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke batsw060rununit::Call("BATSW060WEBF")
           invoke self::populate_listbox().
       end method.

       method-id RadioButtonName_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           move "RG" to BATSW060-ACTION
           move 2 to BATSW060-SORT-TYPE.
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke batsw060rununit::Call("BATSW060WEBF")
           invoke self::populate_listbox().
       end method.

       method-id RadioButtonDate_CheckedChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           move "RG" to BATSW060-ACTION
           move 3 to BATSW060-SORT-TYPE.
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke batsw060rununit::Call("BATSW060WEBF")
           invoke self::populate_listbox().
       end method.

       method-id Button2_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           invoke type System.Single::TryParse(TextBox1::Text::ToString::Replace("/", ""), by reference gmDate)
           set BATSW060-START-DATE to gmDate
           invoke type System.Single::TryParse(TextBox2::Text::ToString::Replace("/", ""), by reference gmDate)
           set BATSW060-END-DATE to gmDate
           move "RG" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke batsw060rununit::Call("BATSW060WEBF")
           invoke self::populate_listbox().

       end method.

       method-id video_Selected protected.
       local-storage section.
       01 vidPaths type String. 
       01 vidTitles type String.
       01 selected  type Int32[].
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value indexString as type String 
                          returning atBatReturn as type String.
       
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           initialize BATSW060-SEL-VID-TBL
           
           move 0 to aa.

           set selected to self::getSelectedIndeces(indexString).
                      
       videos-loop.
           if aa = selected::Count
               go to videos-done.
           MOVE "Y" TO BATSW060-SEL-VID-FLAG(selected[aa] + 1).
           add 1 to aa.
           go to videos-loop.
       videos-done.
       
           MOVE "PV" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke batsw060rununit::Call("BATSW060WEBF")
           
           if ERROR-FIELD NOT = SPACES
               set atBatReturn to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.           
               
           set vidPaths to ""
           set vidTitles to ""
           move 1 to aa.

       lines-loop.
           if aa > BATSW060-WF-VID-COUNT
               go to lines-done.
           
PM         set vidPaths to vidPaths & BATSW060-WF-VIDEO-PATH(aa) & BATSW060-WF-VIDEO-A(aa) & ";"
PM         set vidTitles to vidTitles & BATSW060-WF-VIDEO-TITL(aa) & ";"
           
           if BATSW060-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BATSW060-WF-VIDEO-PATH(aa) & BATSW060-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BATSW060-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BATSW060-WF-VIDEO-PATH(aa) & BATSW060-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BATSW060-WF-VIDEO-D(aa) not = spaces
               set vidPaths to vidPaths & BATSW060-WF-VIDEO-PATH(aa) & BATSW060-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
               
           
           add 1 to aa.
           go to lines-loop.
       lines-done.
       
           set self::Session::Item("video-paths") to vidPaths
           set self::Session::Item("video-titles") to vidTitles

       end method.

       method-id allGamesButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           MOVE "A" to BATSW060-DATE-CHOICE-FLAG
           MOVE "DC" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke BATSW060rununit::Call("BATSW060WEBF")
           set TextBox1::Text to "01/01/00".
           set TextBox2::Text to BATSW060-END-DATE::ToString("##/##/##").
       end method.

       method-id currentYearButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           MOVE "C" to BATSW060-DATE-CHOICE-FLAG
           MOVE "DC" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke BATSW060rununit::Call("BATSW060WEBF")
           set TextBox1::Text to BATSW060-START-DATE::ToString("##/##/##").
           set TextBox2::Text to BATSW060-END-DATE::ToString("##/##/##").
       end method.

       method-id pastYearButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           MOVE "P" to BATSW060-DATE-CHOICE-FLAG
           MOVE "DC" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke BATSW060rununit::Call("BATSW060WEBF")
           set TextBox1::Text to BATSW060-START-DATE::ToString("##/##/##").
           set TextBox2::Text to BATSW060-END-DATE::ToString("##/##/##").
       end method.

       method-id twoWeeksButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           MOVE "W" to BATSW060-DATE-CHOICE-FLAG
           MOVE "DC" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke BATSW060rununit::Call("BATSW060WEBF")
           set TextBox1::Text to BATSW060-START-DATE::ToString("##/##/##").
           set TextBox2::Text to BATSW060-END-DATE::ToString("##/##/##").
       end method.

       method-id currentMonthButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           MOVE "M" to BATSW060-DATE-CHOICE-FLAG
           MOVE "DC" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke BATSW060rununit::Call("BATSW060WEBF")
           set TextBox1::Text to BATSW060-START-DATE::ToString("##/##/##").
           set TextBox2::Text to BATSW060-END-DATE::ToString("##/##/##").
       end method.

       method-id twoMonthsButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           MOVE "2" to BATSW060-DATE-CHOICE-FLAG
           MOVE "DC" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke BATSW060rununit::Call("BATSW060WEBF")
           set TextBox1::Text to BATSW060-START-DATE::ToString("##/##/##").
           set TextBox2::Text to BATSW060-END-DATE::ToString("##/##/##").
       end method.

       method-id threeMonthsButton_Click protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw060webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["batsw060data"] as type batsweb.batsw060Data
           set address of BATSW060-DIALOG-FIELDS to myData::tablePointer
           MOVE "3" to BATSW060-DATE-CHOICE-FLAG
           MOVE "DC" to BATSW060-ACTION
           set batsw060rununit to self::Session::Item("w060rununit") as
               type RunUnit
           invoke BATSW060rununit::Call("BATSW060WEBF")
           set TextBox1::Text to BATSW060-START-DATE::ToString("##/##/##").
           set TextBox2::Text to BATSW060-END-DATE::ToString("##/##/##").
       end method.
       
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
