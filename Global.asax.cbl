       class-id batsweb.Global
               inherits type System.Web.HttpApplication public.
       working-storage section.
      *copy "Y:\sydexsource\bats\batsglobal.cpb".

       method-id Application_Start internal.
       local-storage section.
       procedure division using by value sender as object by value e as type EventArgs.
           *> Code that runs on application startup
           goback.
       end method.

       method-id Application_End internal.
       local-storage section.

       procedure division using by value sender as object by value e as type EventArgs.
            *>  Code that runs on application shutdown


       goback.
       end method.

       method-id Application_Error internal.
       local-storage section.
       procedure division using by value sender as object by value e as type EventArgs.
            *> Code that runs when an unhandled error occurs
           goback.
       end method.

       method-id Session_Start internal.
       local-storage section.

       procedure division using by value sender as object by value e as type EventArgs.
           *> Code that runs when a new session is started

           goback.
       end method.

       method-id Session_OnEnd internal.
       local-storage section.
       01 bat666rununit         type RunUnit.
       01 BAT666WEBF                type BAT666WEBF.
       01 bat766rununit         type RunUnit.
       01 BAT766WEBF                type BAT766WEBF.

       01 bat360rununit         type RunUnit.
       01 BAT360WEBF                type BAT360WEBF.
       01 bat310rununit         type RunUnit.
       01 BAT310WEBF                type BAT310WEBF.

       01 batsw060rununit         type RunUnit.
       01 BATSW060WEBF                type BATSW060WEBF.
       01 ws-file-ip   type String.

       procedure division using by value sender as object by value e as type EventArgs.



           *> Code that runs when a session ends.
           *> Note: The Session_End event is raised only when the sessionstate mode
           *> is set to InProc in the Web.config file. If session mode is set to StateServer
           *> or SQLServer, the event is not raised.
      *    THE FINAL CALL KILLS THE TEMP FILES.
      *    IT WORKS BECAUSE THE HTTPCONTEXT HAS GONE NULL FOR THE SUBMODULE
           if  self::Session::Item("666rununit") not = null
               set bat666rununit to self::Session::Item("666rununit")
                       as type RunUnit
               invoke bat666rununit::Call("BAT666WEBF")
               invoke bat666rununit::StopRun.

           if  self::Session::Item("766rununit") not = null
               set bat766rununit to self::Session::Item("766rununit")
                       as type RunUnit
               invoke bat766rununit::Call("BAT766WEBF")
               invoke bat766rununit::StopRun.

           if  self::Session::Item("360rununit") not = null
               set bat360rununit to self::Session::Item("360rununit")
                       as type RunUnit
               invoke bat360rununit::Call("BAT360WEBF")
               invoke bat360rununit::StopRun.
           if  self::Session::Item("310rununit") not = null
               set bat310rununit to self::Session::Item("310rununit")
                       as type RunUnit
               invoke bat310rununit::Call("BAT310WEBF")
               invoke bat310rununit::StopRun.

           if  self::Session::Item("w060rununit") not = null
               set batsw060rununit to self::Session::Item("w060rununit")
                       as type RunUnit
      *         set batsw060data to self::Session["batsw060data"] as type batsweb.batsw060Data
      *         MOVE "X" TO batsw060data::BATSW060-ACTION
      *         invoke batsw060rununit::Call("BATSW060WEBF")
               invoke batsw060rununit::StopRun.

           goback.
       end method.

       end class.
