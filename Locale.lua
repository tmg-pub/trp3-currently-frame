-- TRP3 Currently Frame by Tammya-Moonguard (2018)

local _, Me = ...

local Locales = {
	enUS = {
		CURFRAME_CO_HEADER = "Currently frame"; -- test
		CURFRAME_CO_SHOW_FRAME = "Show frame";
		CURFRAME_CO_SHOW_FRAME_HELP = "Show or hide the currently frame. You can also hide the frame by setting your OOC flag, but this is useful if you're only interested in the /cur command.";
		CURFRAME_SLASH_CMD = "/cur";
	};
}

-------------------------------------------------------------------------------
function Me.AddLocales()
	TRP3_API.loc:GetDefaultLocale():AddTexts( Locales.enUS )
	for code, strings in pairs( Locales ) do
		TRP3_API.loc:GetLocale( code ):AddTexts( strings )
	end
	
	-- garbage collect
	Locales = {}
end
