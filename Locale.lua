-- TRP3 Currently Frame by Tammya-Moonguard (2018)

local _, Me = ...

local Locales = {
	enUS = {
		CURFRAME_CONFIG_HEADER = "Currently frame";
		CURFRAME_SHOW_FRAME = "Show frame";
		CURFRAME_SHOW_FRAME_HELP = "Show or hide the currently frame. You can also hide the frame by setting your OOC flag, but this is useful if you're only interested in the /cur command.";
		CURFRAME_SLASH_CMD = "/cur";
	};
}

-------------------------------------------------------------------------------
function Me.AddLocales()
	TRP3_API:GetDefaultLocale():AddTexts( Locales.enUS )
	for code, strings in pairs( Locales ) do
		TRP3_API:GetLocale( code ):AddTexts( strings )
	end
end

-------------------------------------------------------------------------------
Me.currentLocale = localeStrings.enUS

-------------------------------------------------------------------------------
-- Switch the current locale.
--
function Me.SetLocale( locale )
	Me.currentLocale = localeStrings[locale] or localeStrings.enUS
end

-------------------------------------------------------------------------------
-- Get a localized string.
--
Me.Locale.Get = setmetatable( {}, {
	__index = function( table, key )
		return Me.currentLocale[key] or localStrings.enUS[key] or key
	end
}
