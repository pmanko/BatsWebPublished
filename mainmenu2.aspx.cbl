       class-id batsweb.mainmenu is partial 
                inherits type System.Web.UI.Page public.
                 
       working-storage section.

       method-id Page_Load protected.
       local-storage section.
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.

           
      

       
       goback.
       end method.
 
       method-id atbatButton_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
       SET self::Session::Item("database") to "MA"
       invoke self::Response::Redirect("~/fullatbat.aspx")
      
       end method.
   


       end class.
