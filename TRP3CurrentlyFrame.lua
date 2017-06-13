
local Me = {}

local function onInit()
	local self = Me
	
	self.frame = CreateFrame( "Frame", "TRP3CurrentlyFrame", UIParent, "TRP3CurrentlyTemplate" )
	self.frame.host = self
end

local function updateShow()
	if TRP3_API.profile.getData( "player/character/RP" ) == 1 then
		Me.frame:Show()
	else
		Me.frame:Hide()
	end
end

local function onStart()

	local self = Me
	TRP3_API.currently_frame = Me;
	
	SLASH_CUR1 = "/cur"
	
	function SlashCmdList.CUR( msg )
		Me:SetCurrently( msg )
		
	end

	local CONFIG_POS_X = "CONFIG_TRP3CURRENTLYFRAME_POS_X";
	local CONFIG_POS_Y = "CONFIG_TRP3CURRENTLYFRAME_POS_Y";
	local CONFIG_POS_A = "CONFIG_TRP3CURRENTLYFRAME_POS_A";

	TRP3_API.configuration.registerConfigKey( CONFIG_POS_A, "TOP" );
	TRP3_API.configuration.registerConfigKey( CONFIG_POS_X, 0 );
	TRP3_API.configuration.registerConfigKey( CONFIG_POS_Y, -60 );
	
	function Me:ResetConfig()
		TRP3_API.configuration.setValue( CONFIG_POS_A, "TOP" );
		TRP3_API.configuration.setValue( CONFIG_POS_X, 0 );
		TRP3_API.configuration.setValue( CONFIG_POS_Y, -60 );
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
		if old ~= character.CU then
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
	end
	
	TRP3_API.events.listenToEvent( TRP3_API.events.REGISTER_DATA_UPDATED, function( player_id, profileID )
		if player_id == TRP3_API.globals.player_id then
			updateShow()
			Me.frame.text:SetText( TRP3_API.profile.getData("player/character").CU or "" )
		end
	end)
	
	local character = TRP3_API.profile.getData("player/character");
	Me.frame.text:SetText( character.CU or "" )
	
	updateShow()
	
	-- clear focus when clicking world frame
	WorldFrame:HookScript( "OnMouseDown", function()
		if Me.frame.text:HasFocus() then
			Me.frame.text:ClearFocus()
		end
	end)
	
	
end
 
-------------------------------------------------------------------------------
local MODULE_STRUCTURE = {
	["name"] = "Currently Frame",
	["description"] = "Adds a global window to view and edit Currently easily.",
	["version"] = 1.000,
	["id"] = "trp3_currently_frame",
	["onStart"] = onStart,
	["onInit"] = onInit,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule( MODULE_STRUCTURE );