       class-id batsweb.customClips is partial 
                implements type System.Web.UI.ICallbackEventHandler
                inherits type System.Web.UI.Page public.
                 
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 BATSW100rununit         type RunUnit.
       01 BATSW100WEBF                type BATSW100WEBF.
       01 mydata type batsweb.batsw100Data.
       01 gmDate        type Single.
       01 callbackReturn type String.
       method-id Page_Load protected.
       local-storage section.
       01 cm type ClientScriptManager.
       01 cbReference type String.
       01 callbackScript type String.       
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw100webf_dg.CPB".       
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
           if   self::Session["batsw100data"] = null
              set mydata to new batsweb.batsw100Data
              invoke mydata::populateData
              set self::Session["batsw100data"] to mydata
           else
               set mydata to self::Session["batsw100data"] as type batsweb.batsw100Data.
           
              

           if  self::Session::Item("w100rununit") not = null
               set BATSW100rununit to self::Session::Item("w100rununit")
               as type RunUnit
                ELSE
                set batsw100rununit to type RunUnit::New()
                set BATSW100WEBF to new BATSW100WEBF
                invoke batsw100rununit::Add(BATSW100WEBF)
                set self::Session::Item("w100rununit") to  batsw100rununit.

           set address of BATSW100-DIALOG-FIELDS to myData::tablePointer

           move "I" to BATSW100-ACTION
           invoke BATSW100rununit::Call("BATSW100WEBF")
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
            COPY "Y:\sydexsource\BATS\batsw100webf_dg.CPB".
       procedure division.
            set mydata to self::Session["batsw100data"] as type batsweb.batsw100Data
            set address of BATSW100-DIALOG-FIELDS to myData::tablePointer

            move 1 to aa.
       vid-loop.
           if aa > BATSW100-NUM-VID
               go to vid-done.
           SET dataLine to (BATSW100-V-DESC(aa))
           INSPECT dataLine REPLACING ALL " " BY X'A0'
           invoke self::addTableRow(videoTable, " " & dataLine)
           add 1 to aa
           go to vid-loop.
       vid-done.

       end method.
       
       method-id video_Selected protected.
       local-storage section.
       01 vidPaths type String. 
       01 vidTitles type String.
       01 selected  type Int32[].
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw100webf_dg.CPB".
       procedure division using by value indexString as type String 
                          returning atBatReturn as type String.
       
           set mydata to self::Session["BATSW100data"] as type batsweb.batsw100Data
           set address of BATSW100-DIALOG-FIELDS to myData::tablePointer
           initialize BATSW100-SEL-VID-TBL
           
           move 0 to aa.

           set selected to self::getSelectedIndeces(indexString).
                      
       videos-loop.
           if aa = selected::Count
               go to videos-done.
           MOVE "Y" TO BATSW100-SEL-VID-FLAG(selected[aa] + 1).
           add 1 to aa.
           go to videos-loop.
       videos-done.
       
           MOVE "PV" to BATSW100-ACTION
           set BATSW100rununit to self::Session::Item("w100rununit") as
               type RunUnit
           invoke BATSW100rununit::Call("BATSW100WEBF")
           
           if ERROR-FIELD NOT = SPACES
               set atBatReturn to "er|" & ERROR-FIELD
               move spaces to ERROR-FIELD
               exit method.           
               
           set vidPaths to ""
           set vidTitles to ""
           move 1 to aa.

       lines-loop.
           if aa > BATSW100-WF-VID-COUNT
               go to lines-done.
           
PM         set vidPaths to vidPaths & BATSW100-WF-VIDEO-PATH(aa) & BATSW100-WF-VIDEO-A(aa) & ";"
PM         set vidTitles to vidTitles & BATSW100-WF-VIDEO-TITL(aa) & ";"
           
           if BATSW100-WF-VIDEO-B(aa) not = spaces
               set vidPaths to vidPaths & BATSW100-WF-VIDEO-PATH(aa) & BATSW100-WF-VIDEO-B(aa) & ";"
               set vidTitles to vidTitles & "B;".
           if BATSW100-WF-VIDEO-C(aa) not = spaces
               set vidPaths to vidPaths & BATSW100-WF-VIDEO-PATH(aa) & BATSW100-WF-VIDEO-C(aa) & ";"
               set vidTitles to vidTitles & "C;".
           if BATSW100-WF-VIDEO-D(aa) not = spaces
               set vidPaths to vidPaths & BATSW100-WF-VIDEO-PATH(aa) & BATSW100-WF-VIDEO-D(aa) & ";"
               set vidTitles to vidTitles & "D;".
               
           
           add 1 to aa.
           go to lines-loop.
       lines-done.
       
           set self::Session::Item("video-paths") to vidPaths
           set self::Session::Item("video-titles") to vidTitles

       end method.

       method-id goButton_Click protected.
       local-storage section.
       01 javaScript type System.Text.StringBuilder.
       01 confirmMessage type String.
       01 gmDate        type Single.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw100webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["BATSW100data"] as type batsweb.batsw100Data
           set address of BATSW100-DIALOG-FIELDS to myData::tablePointer
           set BATSW100-ADVANCED-1 to findTextBox::Text
           MOVE "RG" to BATSW100-ACTION
           set BATSW100rununit to self::Session::Item("w100rununit") as
               type RunUnit
           invoke BATSW100rununit::Call("BATSW100WEBF")           
           invoke self::populate_listbox().
       end method.
       
       method-id clearButton_Click protected.
       local-storage section.
       01 javaScript type System.Text.StringBuilder.
       01 confirmMessage type String.
       01 gmDate        type Single.
       linkage section.
           COPY "Y:\sydexsource\BATS\batsw100webf_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["BATSW100data"] as type batsweb.batsw100Data
           set address of BATSW100-DIALOG-FIELDS to myData::tablePointer
           set BATSW100-ADVANCED-1, findTextBox::Text to ""
           MOVE "RG" to BATSW100-ACTION
           set BATSW100rununit to self::Session::Item("w100rununit") as
               type RunUnit
           invoke BATSW100rununit::Call("BATSW100WEBF")           
           invoke self::populate_listbox().
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
