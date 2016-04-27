       class-id batsweb.breakdownparkdetail is partial 
                inherits type System.Web.UI.Page public.
                 
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat310rununit         type RunUnit.
       01 BAT310WEBF                type BAT310WEBF.
       01 mydata type batsweb.bat310Data.
       01 teststring type String protected.
       
       method-id Page_Load protected.
       local-storage section.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           if self::IsPostBack
               exit method.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer       
           if BAT310-INFIELD-IP = "Y"
               set infieldButton::Text to "Show Outfield"
           else    
               set infieldButton::Text to "Show Infield".
           move 1 to aa.
       parks-loop.
           if aa > BAT310-BPARK-NUM-ENTRIES
               go to parks-done.
           invoke parkDropDownList::Items::Add(BAT310-BPARK(AA)::Trim)
           if BAT310-BPARK(AA) = BAT310-SEL-BPARK
               set parkDropDownList::SelectedIndex to (AA - 1).
           add 1 to aa
           go to parks-loop.
       parks-done.
           invoke self::Recalc.

           goback.
       end method.
       
       method-id Recalc protected.
       local-storage section.
       01  avg         type Double.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           
           set avg to BAT310-LOC-PCT(1)
           set lfLabel::Text to avg::ToString & "%" 
           set avg to BAT310-LOC-PCT(2)
           set cfLabel::Text to avg::ToString & "%"
           set avg to BAT310-LOC-PCT(3)
           set rfLabel::Text to avg::ToString & "%"
           set avg to BAT310-LOC-PCT(4)
           set b3Label::Text to avg::ToString & "%"   
           set avg to BAT310-LOC-PCT(5)
           set ssLabel::Text to avg::ToString & "%"
           set avg to BAT310-LOC-PCT(6)
           set b2Label::Text to avg::ToString & "%"
           set avg to BAT310-LOC-PCT(7)
           set b1Label::Text to avg::ToString & "%"                
       end method.
       
       method-id parkDropDownList_SelectedIndexChanged protected.
       linkage section.
           COPY "Y:\sydexsource\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit
           set BAT310-SEL-BPARK to parkDropDownList::SelectedItem
           MOVE "FB" TO BAT310-ACTION
           invoke bat310rununit::Call("BAT300WEBF")
           invoke self::Recalc
       end method.      
       
       method-id parkImageButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.Web.UI.ImageClickEventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit")
               as type RunUnit

           set MOUSEX-BF, MOUSEX2-BF to e::X
           set MOUSEY-BF, MOUSEY2-BF to e::Y.

           COMPUTE BAT292V-DOWN-X ROUNDED = MOUSEX-BF * 597 / 597
           COMPUTE BAT292V-DOWN-Y ROUNDED = MOUSEY-BF * 480 / 480
           COMPUTE BAT292V-UP-X ROUNDED = MOUSEX2-BF * 597 / 597
           COMPUTE BAT292V-UP-Y ROUNDED = MOUSEY2-BF * 480 / 480
           SUBTRACT 3 FROM BAT292V-DOWN-X
           SUBTRACT 3 FROM BAT292V-DOWN-Y
           ADD 3 TO BAT292V-UP-X
           ADD 3 TO BAT292V-UP-Y
           move "M2" to BAT310-ACTION
           invoke bat310rununit::Call("BAT310WEBF")
           invoke self::batstube
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
           invoke self::ClientScript::RegisterStartupScript(self::GetType(), "callcallBatstube", "callBatstube();", true).
       end method.
             
       method-id infieldButton_Click protected.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value sender as object e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer
           set bat310rununit to self::Session::Item("310rununit") as
               type RunUnit   

           if BAT310-INFIELD-IP = "Y"
               move " " to BAT310-INFIELD-IP
               set infieldButton::Text to "Show Infield"
               MOVE "FB" TO BAT310-ACTION
               invoke bat310rununit::Call("BAT310WEBF")
               else
               move "Y" to BAT310-INFIELD-IP
               set infieldButton::Text to "Show Outfield".


           invoke self::Recalc.

       end method.


       end class.
