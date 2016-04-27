      $set sourceformat(variable)

      *> Namespace: batsweb.Properties

       class-id batsweb.Properties.Settings is partial is final inherits type System.Configuration.ApplicationSettingsBase
           attribute System.Runtime.CompilerServices.CompilerGenerated()
           attribute System.CodeDom.Compiler.GeneratedCode("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "14.0.0.0")
       .

       working-storage section.
       01 defaultInstance type batsweb.Properties.Settings value type System.Configuration.ApplicationSettingsBase::Synchronized(new batsweb.Properties.Settings) as type batsweb.Properties.Settings static.

       method-id get property Default static final.
       procedure division returning return-item as type batsweb.Properties.Settings.
       set return-item to defaultInstance
       goback
       end method.

       end class.
