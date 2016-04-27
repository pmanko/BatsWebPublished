       class-id batsweb.SiteMaster is partial
               inherits type System.Web.UI.MasterPage public.
               
       working-storage section.
           
       method-id Page_Load protected.
       local-storage section.
       procedure division using by value sender as object by value e as type EventArgs.
           if type HttpContext::Current::User::Identity::IsAuthenticated
               set Logout::CssClass to ""
           else 
               set Logout::CssClass to "hidden".
           goback.           
       end method.
              
       method-id Logout_Click protected.
       procedure division using by value sender as object e as type System.EventArgs.
           invoke type FormsAuthentication::SignOut()
           invoke type FormsAuthentication::RedirectToLoginPage()
       end method.

       end class.
    