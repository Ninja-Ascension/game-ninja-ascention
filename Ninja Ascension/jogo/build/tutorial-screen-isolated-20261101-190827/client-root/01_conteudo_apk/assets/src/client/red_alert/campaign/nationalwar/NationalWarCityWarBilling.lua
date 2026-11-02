-----------------------------
--国战城市战争个人战结算
-----------------------------
NationalWarCityWarBilling = class("NationalWarCityWarBillingClass", Window)
NationalWarCityWarBilling.__fontName_r = ""
NationalWarCityWarBilling.__fontName_l = ""

local national_war_city_war_billing_window_open_terminal = {
    _name = "national_war_city_war_billing_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        if fwin:find("NationalWarCityWarBillingClass") == nil then
            fwin:open(NationalWarCityWarBilling:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_city_war_billing_window_close_terminal = {
    _name = "national_war_city_war_billing_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarCityWarBillingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_city_war_billing_window_open_terminal)
state_machine.add(national_war_city_war_billing_window_close_terminal)
state_machine.init()

function NationalWarCityWarBilling:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self.matchingDataInfo = nil
	self.city_id = nil
	self.attackOrDefense = 0
	
	app.load("client.red_alert.campaign.nationalwar.NationalWarHeroBillingIcon")
	-- app.load("client.red_alert.campaign.nationalwar.NationalRank")
    -- Initialize NationalWarMap state machine.
    local function init_national_war_war_city_war_billing_terminal()
		--确定按钮
        local national_war_city_war_city_war_confirm_terminal = {
            _name = "national_war_city_war_city_war_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--如果胜利
				if zstring.tonumber(_ED.war_city_war_result) == 1 then
					state_machine.excute("national_war_city_war_billing_window_close",0,"")
					state_machine.excute("national_war_city_war_billing_ui_refresh",0,"")
				else --否则结束
					-- state_machine.excute("national_war_record_window_open",0,{self.city_id})
					state_machine.excute("national_war_city_war_map_ui_close",0,"")
					state_machine.excute("national_war_map_return_home_city",0,"")	
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		state_machine.add(national_war_city_war_city_war_confirm_terminal)  
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_war_city_war_billing_terminal()
end

function NationalWarCityWarBilling:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_settlement_battle)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	--关闭 
    local action = csb.createTimeline(config_csb.campaign.nationalwar.nationalwar_settlement_battle)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)
    csbItem:runAction(action)   
    action:play("window_open",false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then
			if zstring.tonumber(_ED.war_city_war_result) == 1 then
				ccui.Helper:seekWidgetByName(root,"Image_win"):setVisible(true)
				ccui.Helper:seekWidgetByName(root,"Image_fail"):setVisible(false)
			else
				ccui.Helper:seekWidgetByName(root,"Image_win"):setVisible(false)
				ccui.Helper:seekWidgetByName(root,"Image_fail"):setVisible(true)
			end
        end
        
    end)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_settlement_sure"), nil, 
    {
        terminal_name = "national_war_city_war_city_war_confirm", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	
	self:updateDraw()
end


function NationalWarCityWarBilling:updateDraw()
	local root = self.roots[1]
	local Panel_role_camp_l = ccui.Helper:seekWidgetByName(root,"Panel_role_camp_l")
	local Text_role_name_l = ccui.Helper:seekWidgetByName(root,"Text_role_name_l")
	local Text_role_lv_l = ccui.Helper:seekWidgetByName(root,"Text_role_lv_l")
	local Text_role_fight_l = ccui.Helper:seekWidgetByName(root,"Text_role_fight_l")
	local matchingOne = self.matchingDataInfo[1]
	local matchingTwo = self.matchingDataInfo[2]
	local warCityWarServerReviewOne = nil
	local warCityWarServerReviewTwo = nil
	if self.attackOrDefense == 0 then
		warCityWarServerReviewOne = _ED.war_city_war_server_review[1]
		warCityWarServerReviewTwo = _ED.war_city_war_server_review[2]
	else
		warCityWarServerReviewOne = _ED.war_city_war_server_review[2]
		warCityWarServerReviewTwo = _ED.war_city_war_server_review[1]
	end
	Panel_role_camp_l:removeBackGroundImage()
	if NationalWarCityWarBilling.__fontName_l == "" then 
		NationalWarCityWarBilling.__fontName_l = Text_role_name_l:getFontName()
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		local index = zstring.tonumber(warCityWarServerReviewOne.selfCamp)
		if index ~= 4 and index ~= 0 then 
			if ___is_open_leadname == true then 
				Text_role_name_l:setFontName("")
				Text_role_name_l:setFontSize(Text_role_name_l:getFontSize())
			end 
		else
			Text_role_name_l:setFontName(NationalWarCityWarBilling.__fontName_l)
			Text_role_name_l:setFontSize(Text_role_name_l:getFontSize())
		end
		Text_role_name_l:setString(warCityWarServerReviewOne.name)
		Panel_role_camp_l:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", index))
	else
		Text_role_name_l:setString(matchingOne.userName)
		Panel_role_camp_l:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", zstring.tonumber(matchingOne.country)))
	end
	Text_role_lv_l:setString(warCityWarServerReviewOne.level)
	Text_role_fight_l:setString(warCityWarServerReviewOne.combatForce)
	
	
	local Panel_role_camp_r = ccui.Helper:seekWidgetByName(root,"Panel_role_camp_r")
	local Text_role_name_r = ccui.Helper:seekWidgetByName(root,"Text_role_name_r")
	local Text_role_lv_r = ccui.Helper:seekWidgetByName(root,"Text_role_lv_r")
	local Text_role_fight_r = ccui.Helper:seekWidgetByName(root,"Text_role_fight_r")
	if NationalWarCityWarBilling.__fontName_r == "" then 
		NationalWarCityWarBilling.__fontName_r = Text_role_name_r:getFontName()
	end
	Panel_role_camp_r:removeBackGroundImage()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		local index = zstring.tonumber(warCityWarServerReviewTwo.selfCamp)
		if index ~= 4 and index ~= 0 then 
			--玩家名称
			if ___is_open_leadname == true then 
				Text_role_name_r:setFontName("")
				Text_role_name_r:setFontSize(Text_role_name_r:getFontSize())
			end
		else
			Text_role_name_r:setFontName(NationalWarCityWarBilling.__fontName_r)
			Text_role_name_r:setFontSize(Text_role_name_r:getFontSize())
		end
		Text_role_name_r:setString(warCityWarServerReviewTwo.name)
		Panel_role_camp_r:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", index))
	else
		Text_role_name_r:setString(matchingTwo.userName)
		Panel_role_camp_r:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", zstring.tonumber(matchingTwo.country)))
	end
	Text_role_lv_r:setString(warCityWarServerReviewTwo.level)
	Text_role_fight_r:setString(warCityWarServerReviewTwo.combatForce)
	
	if zstring.tonumber(_ED.war_city_war_result) == 1 then
		ccui.Helper:seekWidgetByName(root,"Image_win"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Image_fail"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root,"Image_win"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Image_fail"):setVisible(true)
	end
	
	--形象
	local Panel_settlement_role_l = ccui.Helper:seekWidgetByName(root,"Panel_settlement_role_l")
	local Panel_settlement_role_r = ccui.Helper:seekWidgetByName(root,"Panel_settlement_role_r")
	Panel_settlement_role_l:removeBackGroundImage()
	Panel_settlement_role_r:removeBackGroundImage()
	if tonumber(warCityWarServerReviewOne.selfGener) == 2 then
		Panel_settlement_role_l:setBackGroundImage(string.format("images/ui/decorative/head_l.png"))
	else
		Panel_settlement_role_l:setBackGroundImage(string.format("images/ui/decorative/head_j.png"))
	end
	if tonumber(warCityWarServerReviewTwo.selfGener) == 2 then
		Panel_settlement_role_r:setBackGroundImage(string.format("images/ui/decorative/head_l.png"))
	else
		Panel_settlement_role_r:setBackGroundImage(string.format("images/ui/decorative/head_j.png"))
	end
	
	--战船
	local ListView_role_head_l = ccui.Helper:seekWidgetByName(root,"ListView_role_head_l")
	for i , v in pairs(warCityWarServerReviewOne.warfare_formation) do
		local cell = state_machine.excute("national_war_hero_billing_icon_create_cell",0,{v})
        ListView_role_head_l:addChild(cell)
		ListView_role_head_l:requestRefreshView()
	end
	local ListView_role_head_r = ccui.Helper:seekWidgetByName(root,"ListView_role_head_r")
	for j , w in pairs(warCityWarServerReviewTwo.warfare_formation) do
		local cell = state_machine.excute("national_war_hero_billing_icon_create_cell",0,{w})
        ListView_role_head_r:addChild(cell)
		ListView_role_head_r:requestRefreshView()
	end
	
	state_machine.excute("national_war_hero_listview_update_hp",0,"")
end

function NationalWarCityWarBilling:onUpdate(dt)
	
end

function NationalWarCityWarBilling:init(params)
	self._rootWindows = params[1]  
	self.matchingDataInfo = params[2] 
	self.city_id = params[3] 
	self.attackOrDefense = params[4] 
    self:onInit()
    return self
end

function NationalWarCityWarBilling:onExit()
    state_machine.remove("national_war_city_war_city_war_confirm")
end
