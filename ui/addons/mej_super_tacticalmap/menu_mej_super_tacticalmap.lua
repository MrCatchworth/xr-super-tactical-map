local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t UniverseID;
	typedef struct {
		const char* factionName;
		const char* factionIcon;
	} FactionDetails;
	typedef struct {
		UniverseID softtargetID;
		const char* softtargetName;
		const char* softtargetConnectionName;
	} SofttargetDetails;
	typedef struct {
		float x;
		float y;
		float z;
		float yaw;
		float pitch;
		float roll;
	} UIPosRot;
	void AbortPlayerPrimaryShipJump(void);
	UniverseID AddHoloMap(const char* texturename, float x0, float x1, float y0, float y1);
	void ClearHighlightMapComponent(UniverseID holomapid);
	const char* GetBuildSourceSequence(UniverseID componentid);
	const char* GetComponentClass(UniverseID componentid);
	const char* GetComponentName(UniverseID componentid);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	FactionDetails GetFactionDetails(const char* factionid);
	UniverseID GetMapComponentBelowCamera(UniverseID holomapid);
	bool GetMapPositionOnEcliptic(UniverseID holomapid, UIPosRot* position, bool showposition);
	const char* GetMapShortName(UniverseID componentid);
	FactionDetails GetOwnerDetails(UniverseID componentid);
	UniverseID GetParentComponent(UniverseID componentid);
	UniverseID GetPickedMapComponent(UniverseID holomapid);
	SofttargetDetails GetSofttarget(void);
	UniverseID GetZoneAt(UniverseID sectorid, UIPosRot* uioffset);
	bool HasPlayerJumpKickstarter(void);
	bool InitPlayerPrimaryShipJump(UniverseID objectid);
	bool IsComponentOperational(UniverseID componentid);
	bool IsInfoUnlockedForPlayer(UniverseID componentid, const char* infostring);
	bool IsSellOffer(UniverseID tradeofferdockid);
	void RemoveHoloMap2(void);
	void SetHighlightMapComponent(UniverseID holomapid, UniverseID componentid, bool resetplayerpan);
	bool SetSofttarget(UniverseID componentid);
	void ShowUniverseMap(UniverseID holomapid, UniverseID componentid, bool resetplayerzoom, int overridezoom);
	void StartPanMap(UniverseID holomapid);
	void StartRotateMap(UniverseID holomapid);
	void StopPanMap(UniverseID holomapid);
	void StopRotateMap(UniverseID holomapid);
	void ZoomMap(UniverseID holomapid, float zoomstep);
    bool IsShip(const UniverseID componentid);
    void SetFill(const UniverseID componentid, const uint8_t red, const uint8_t green, const uint8_t blue, const float alpha, const bool animated, const float minalpha, const float maxalpha, const float transitiontime);
    void RemoveFill(const UniverseID componentid);
    void SetOutline(const UniverseID componentid, const uint8_t red, const uint8_t green, const uint8_t blue, const bool animated);
]]

local menu = {
    name = "MeJ_SuperTacticalMapMenu",
    white = { r = 255, g = 255, b = 255, a = 100 },
    red = { r = 255, g = 0, b = 0, a = 100 },
    transparent = { r = 0, g = 0, b = 0, a = 0 },
    grey = { r = 128, g = 128, b = 128, a = 100 },
    lightGrey = { r = 170, g = 170, b = 170, a = 100 },
}

function menu.onShowMenu()
    C.DeactivatePlayerControls()
    RegisterAddonBindings("ego_mainmenu")
    
    --TODO
end

function menu.cleanup()
    C.ActivatePlayerControls()
    UnregisterAddonBindings("ego_mainmenu")
end

local function init()
    Menus = Menus or { }
    table.insert(Menus, menu)
    if Helper then
        Helper.registerMenu(menu)
    end
    menu.holomap = 0
    
    loadOrdersFromExtensions()
    
    --fill gridOrders a bit
    while #menu.gridOrders < 12 do
        local num = #menu.gridOrders
        table.insert(menu.gridOrders,
            {
                buttonText = "--",
                
                requiresTarget = false,
                
                buttonFilter = function(order) return false end,
                
                issue = function(order) end
            }
        )
    end
end

init()