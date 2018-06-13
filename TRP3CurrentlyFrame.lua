-------------------------------------------------------------------------------
-- TRP3 Currently Frame by Tammya-Moonguard (2018)
--
-- Adds a standalone frame to edit your currently status.
-------------------------------------------------------------------------------

local _, Me = ...

local L = TRP3_API.loc

local CONFIG_POS_X = "CONFIG_TRP3CURRENTLYFRAME_POS_X";
local CONFIG_POS_Y = "CONFIG_TRP3CURRENTLYFRAME_POS_Y";
local CONFIG_POS_A = "CONFIG_TRP3CURRENTLYFRAME_POS_A";
local CONFIG_SHOW  = "CONFIG_TRP3CURRENTLYFRAME_SHOW";

-------------------------------------------------------------------------------
-- Called when the module is initialized.
--
local function onInit()
	Me.AddLocales()
	L = TRP3_API.loc
	
	Me.frame = CreateFrame( "Frame", "TRP3CurrentlyFrame", UIParent, "TRP3CurrentlyTemplate" )
	Me.frame.host = Me
	
	-- Set the currently frame's caption.
	Me.frame.caption.label:SetText( L.REG_PLAYER_CURRENT )
end

-------------------------------------------------------------------------------
-- Update frame display.
--
local function updateFrame()

	-- Update visibility.
	if TRP3_API.profile.getData( "player/character/RP" ) == 1
	   and TRP3_API.configuration.getValue(CONFIG_SHOW) then
		Me.frame:Show()
	else
		Me.frame:Hide()
	end
	
	-- Update text from profile currently.
	Me.frame.text:SetText( TRP3_API.profile.getData("player/character").CU or "" )
	
end

-------------------------------------------------------------------------------
-- The /cur slash command.
--
local function SlashCommandCur( msg )
	Me:SetCurrently( msg )
end

-------------------------------------------------------------------------------
-- Secondary initialization.
--
local function onStart()

	local self = Me
	TRP3_API.currently_frame = Me;
	
	SlashCmdList.CUR = SlashCommandCur
	SLASH_CUR1 = "/cur"
	
	-- Add another slash command if it's in the translations for this locale.
	if L.CURFRAME_SLASH_CMD ~= "/cur" then
		SLASH_CUR2 = L.CURFRAME_SLASH_CMD
	end

	TRP3_API.configuration.registerConfigKey( CONFIG_POS_A, "TOP" );
	TRP3_API.configuration.registerConfigKey( CONFIG_POS_X, 0 );
	TRP3_API.configuration.registerConfigKey( CONFIG_POS_Y, -60 );
	TRP3_API.configuration.registerConfigKey( CONFIG_SHOW, true );
	
	-- Build configuration page (todo: localization)
	tinsert( TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigH1";
		title   = L.CURFRAME_CO_HEADER;
	});
	
	tinsert( TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit   = "TRP3_ConfigCheck";
		title     = L.CURFRAME_CO_SHOW_FRAME;
		help      = L.CURFRAME_CO_SHOW_FRAME_HELP;
		configKey = CONFIG_SHOW;
	});
	
	-- handler for when the show toggle is changed.
	TRP3_API.configuration.registerHandler( CONFIG_SHOW, function()
		updateFrame()
	end);
	
	function Me:ResetConfig()
		TRP3_API.configuration.setValue( CONFIG_POS_A, "TOP" );
		TRP3_API.configuration.setValue( CONFIG_POS_X, 0 );
		TRP3_API.configuration.setValue( CONFIG_POS_Y, -60 );
		TRP3_API.configuration.setValue( CONFIG_SHOW, true );
	end	

	Me.frame:ClearAllPoints()
	Me.frame:SetPoint(
		TRP3_API.configuration.getValue(CONFIG_POS_A), 
		UIParent, 
		TRP3_API.configuration.getValue(CONFIG_POS_A),
		TRP3_API.configuration.getValue(CONFIG_POS_X), 
		TRP3_API.configuration.getValue(CONFIG_POS_Y));
	
	Me.frame:SetMovable(true) 
	Me.frame.caption:SetScript("OnMouseDown", function(self, button )
		
        if button == "LeftButton" then
			Me.frame:StartMoving();
		
        end
	end);
	Me.frame.caption:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
			Me.frame:StopMovingOrSizing();
			local anchor, _, _, x, y = Me.frame:GetPoint(1);
		
			TRP3_API.configuration.setValue( CONFIG_POS_A, anchor );
			TRP3_API.configuration.setValue( CONFIG_POS_X, x );
			TRP3_API.configuration.setValue( CONFIG_POS_Y, y );
        end
	end);
	
	
	function Me:SetCurrently( text )
		Me.frame.text:SetText( text or "" )
		Me:SaveCurrently()
	end
	
	function Me:SaveCurrently()
		local character = TRP3_API.profile.getData("player/character");
		local old = character.CU;
		character.CU = self.frame.text:GetText();
		if old == character.CU then return end
		
		character.v = TRP3_API.utils.math.incrementNumber(character.v or 1, 2);
		TRP3_API.events.fireEvent( 
			TRP3_API.events.REGISTER_DATA_UPDATED,
			TRP3_API.globals.player_id, 
			TRP3_API.profile.getPlayerCurrentProfileID(), 
			"character"
		);
		
		local context = TRP3_API.navigation.page.getCurrentContext()
		if context and context.isPlayer then
			TRP3_RegisterMiscViewCurrentlyICScrollText:SetText( character.CU or "" )
		end
	end
	
	TRP3_API.events.listenToEvent( TRP3_API.events.REGISTER_DATA_UPDATED, function( player_id, profileID )
		if player_id == TRP3_API.globals.player_id then
			updateFrame()
		end
	end)
	
	-- clear focus when clicking world frame
	WorldFrame:HookScript( "OnMouseDown", function()
		if Me.frame.text:HasFocus() then
			Me.frame.text:ClearFocus()
		end
	end)
	
	updateFrame()
end
 
------------------------------------------------------------------------------
-- Module information.
--
local MODULE_STRUCTURE = {
	["name"]        = "Currently Frame",
	["description"] = "Adds a global window to view and edit Currently easily.",
	["version"]     = 1.3,
	["id"]          = "trp3_currently_frame",
	["onStart"]     = onStart,
	["onInit"]      = onInit,
	["minVersion"]  = 3,
};

TRP3_API.module.registerModule( MODULE_STRUCTURE );
