-- TRP3 Currently Frame by Tammya-Moonguard (2018)

local _, Me = ...

local Locales = {
   enUS = {
      CURFRAME_ADDON_NOTES = "Adds a window for editing your Currently.";
      CURFRAME_ADDON_TITLE = "TRP3 Currently Frame";
      CURFRAME_CO_HEADER = "Currently frame";
      CURFRAME_CO_SHOW_FRAME = "Show frame";
      CURFRAME_CO_SHOW_FRAME_HELP = "Show or hide the currently frame. You can also hide the frame by setting your OOC flag, but this is useful if you're only interested in the /cur command.";
      CURFRAME_CO_SHOW_OOC = "Show OOC";
      CURFRAME_CO_SHOW_OOC_HELP = "Show editor for OOC information in the frame.";
      CURFRAME_SLASH_CMD = "/cur";
      CURFRAME_SLASH_CMD2 = "/cooc";
   };
}

---------------------------------------------------------------------------
-- Other languages imported from Curse during packaging.
---------------------------------------------------------------------------

--@insert-localizations Locales.{lang}@

-------------------------------------------------------------------------------
function Me.AddLocales()
   TRP3_API.loc:GetDefaultLocale():AddTexts( Locales.enUS )
   for code, strings in pairs( Locales ) do
      TRP3_API.loc:GetLocale( code ):AddTexts( strings )
   end
   
   -- garbage collect
   Locales = nil
end
