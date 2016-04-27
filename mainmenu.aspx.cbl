       class-id batsweb.mainmenu is partial
                inherits type System.Web.UI.Page public.

       working-storage section.
       01 mybat666Data type batsweb.bat666Data.
       01 mybat360Data type batsweb.bat360Data.
       01 mybat766Data type batsweb.bat766Data. 
       01 mybat310Data type batsweb.bat310Data. 
       01 mybatsw060Data type batsweb.batsw060Data.
       01 batsw150rununit         type RunUnit.
       01 BATSW150WEBF                type BATSW150WEBF.

       method-id Page_Load protected.
       local-storage section.
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.


       goback.
       end method.

      * Not needed - moved to fullatbat 
      *method-id atbatButton_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      * SET self::Session::Item("database") to "MA"
      *if   self::Session["bat666data"] = null
      *   set mybat666Data to new batsweb.bat666Data
      *   invoke mybat666Data::populateData
      *   set self::Session["bat666data"] to mybat666Data.
      *
      *invoke self::Response::Redirect("~/fullatbat.aspx")
      *
      *end method.

      *method-id fullatbatButtonmi_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      *SET self::Session::Item("database") to "MI"
      * if   self::Session["bat666data"] = null
      *    set mybat666Data to new batsweb.bat666Data
      *    invoke mybat666Data::populateData
      *    set self::Session["bat666data"] to mybat666Data.
      *
      *invoke self::Response::Redirect("~/fullatbat.aspx")
      *
      *end method.

      *method-id gamesButton_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      *SET self::Session::Item("database") to "MA"
      *if   self::Session["bat360data"] = null
      *   set mybat360Data to new batsweb.bat360Data
      *   invoke mybat360Data::populateData
      *   set self::Session["bat360data"] to mybat360Data.
      *
      *invoke self::Response::Redirect("~/gameSummary.aspx")
      *
      *end method.
      *
      *method-id Button7_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      *SET self::Session::Item("database") to "MI"
      *
      *if   self::Session["bat360data"] = null
      *   set mybat360Data to new batsweb.bat360Data
      *   invoke mybat360Data::populateData
      *   set self::Session["bat360data"] to mybat360Data.
      *invoke self::Response::Redirect("~/gameSummary.aspx")
      *
      *end method.
      *
      *method-id Button11_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      *SET self::Session::Item("database") to "MA"
      *if   self::Session["bat360data"] = null
      *   set mybat360Data to new batsweb.bat360Data
      *   invoke mybat360Data::populateData
      *   set self::Session["bat360data"] to mybat360Data.
      *
      *invoke self::Response::Redirect("~/gameSummary.aspx")
      *
      *end method.
      *
      *method-id EZvideobutton_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      *if   self::Session["batsw060data"] = null
      *   set mybatsw060Data to new batsweb.batsw060Data
      *   invoke mybatsw060Data::populateData
      *   set self::Session["batsw060data"] to mybatsw060Data.
      *
      *invoke self::Response::Redirect("~/EZvideo.aspx")
      *
      *end method.

       method-id Button12_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           try 
             set batsw150rununit to type RunUnit::New
             set BATSW150WEBF to new BATSW150WEBF
             invoke batsw150rununit::Add(BATSW150WEBF)
             invoke batsw150rununit::Call("BATSW150WEBF")
           catch 
             invoke type System.Diagnostics.Debug::WriteLine(exception-object::Message)
             raise
           finally
             invoke batsw150rununit::StopRun(0)                           
           end-try
       
       end method.

      *method-id pitcherBatterButton_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      *SET self::Session::Item("database") to "MA"
      *if   self::Session["bat766data"] = null
      *   set mybat766Data to new batsweb.bat766Data
      *   invoke mybat766Data::populateData
      *   set self::Session["bat766data"] to mybat766Data.
      *
      *    invoke self::Response::Redirect("~/pitchervsbatter.aspx")
      *end method.
      *
      *method-id breakdownButton_Click protected.
      *procedure division using by value sender as object e as type System.EventArgs.
      *    SET self::Session::Item("database") to "MA"
      *    if self::Session["bat310data"] = null
      *   set mybat310Data to new batsweb.bat310Data
      *   invoke mybat310Data::populateData
      *   set self::Session["bat310data"] to mybat310Data.
      *
      *    invoke self::Response::Redirect("~/breakdown.aspx")
      *end method.

       end class.
