-----------------------------
--国战城市战争技能卡牌
-----------------------------
NationalWarCityWarUITactics = class("NationalWarCityWarUITacticsClass", Window)

local national_war_city_war_tactics_window_open_terminal = {
    _name = "national_war_city_war_tactics_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        if fwin:find("NationalWarCityWarUITacticsClass") == nil then
            fwin:open(NationalWarCityWarUITactics:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_city_war_tactics_window_close_terminal = {
    _name = "national_war_city_war_tactics_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarCityWarUITacticsClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_city_war_tactics_window_open_terminal)
state_machine.add(national_war_city_war_tactics_window_close_terminal)
state_machine.init()

function NationalWarCityWarUITactics:ctor()
    self.super:ctor()
    self.roots = {}
	self.city_id = nil
	self.actions = {}
	self.tactics_indes = 0
	self.animationPanel = nil
	self.card_use_time = 0
	
	self.card_use_count = {5,4,9,7,1}--卡牌使用上限
	
    -- Initialize NationalWarMap state machine.
    local function init_national_war_war_city_war_tactics_terminal()

		--卡牌选择动画
        local nationalwar_tactical_card_choose_terminal = {
            _name = "nationalwar_tactical_card_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:playActionCard(params._datas._pageIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--卡牌使用
        local nationalwar_tactical_card_use_terminal = {
            _name = "nationalwar_tactical_card_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local consumeNumber = 0
				local warfareCardData = dms.element(dms["warfare_card"],self.tactics_indes)
				local number = dms.atoi(warfareCardData,warfare_card.use_count) - zstring.tonumber(_ED.warfare_card_info[self.tactics_indes].card_use_surplus_number)
				local consume = dms.atos(warfareCardData,warfare_card.consume)
				local m_params = zstring.split(consume, ",")
				
				if zstring.tonumber(_ED.user_info.user_force) ~= zstring.tonumber(_ED.war_in_city_info.now_city_camp) and self.tactics_indes == 1 then
					TipDlg.drawTextDailog(red_alert_war_city_map_tip[6])
					return
				elseif zstring.tonumber(_ED.user_info.user_force) == zstring.tonumber(_ED.war_in_city_info.now_city_camp) and self.tactics_indes == 2 then 
					TipDlg.drawTextDailog(red_alert_war_city_map_tip[7])
					return
				end
				local m_buffLaye = 0
				for i,v in pairs(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].buffs) do
					m_buffLaye = m_buffLaye + zstring.tonumber(v.buff_laye)
				end
				if m_buffLaye==0 and self.tactics_indes == 1 then
					TipDlg.drawTextDailog(red_alert_all_str[68])
					return
				end
				if zstring.tonumber(_ED.warfare_card_info[self.tactics_indes].card_use_time) > 0 then
					TipDlg.drawTextDailog(red_alert_war_city_map_tip[2])
				else
					if zstring.tonumber(_ED.selfWarProvisions) < zstring.tonumber(m_params[number]) then
						state_machine.excute("natinal_war_buy_resource_window_open",0,"")
					else
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								state_machine.excute("national_war_city_war_play_tactics_animation",0,{self.tactics_indes})
								state_machine.excute("nationalwar_tactical_card_update_free_times",0,0)
								state_machine.excute("national_war_city_war_tactics_window_close",0,"")
							end
						end
						protocol_command.use_card.param_list = self.tactics_indes
						NetworkManager:register(protocol_command.use_card.code, nil, nil, nil,nil, responseCallback, false, nil)
					end
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
        local nationalwar_tactical_card_update_free_times_terminal = {
            _name = "nationalwar_tactical_card_update_free_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(nationalwar_tactical_card_choose_terminal)  
        state_machine.add(nationalwar_tactical_card_use_terminal)  
        state_machine.add(nationalwar_tactical_card_update_free_times_terminal)
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_war_city_war_tactics_terminal()
end

function NationalWarCityWarUITactics:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_tactical)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	
	local action = csb.createTimeline(config_csb.campaign.nationalwar.nationalwar_tactical)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    action:play("window_open",false)
	--关闭 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tactical_back"), nil, 
    {
        terminal_name = "national_war_city_war_tactics_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	--使用
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tactical_use"), nil, 
    {
        terminal_name = "nationalwar_tactical_card_use", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	for i=1, 5 do
	--卡牌
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_nationalwar_tactical_card_"..i), nil, 
		{
			terminal_name = "nationalwar_tactical_card_choose", 
			terminal_state = 0, 
			_pageIndex = i,
			touch_scale = false,
			touch_scale_xy = 0.95,
		}, nil, 0)
	end
	self:onUpdateDraw()
end

function NationalWarCityWarUITactics:onUpdateDraw()
	local root = self.roots[1]
	for i=1,5 do
		local warfareCardData = dms.element(dms["warfare_card"],i)
		local consume = dms.atos(warfareCardData,warfare_card.consume)
		local params = zstring.split(consume, ",")
		local ferrNumber = 0
		for j=1, #params do
			if zstring.tonumber(params[j]) == 0 then
				ferrNumber = ferrNumber+1
			end
		end
		local number = dms.atoi(warfareCardData,warfare_card.use_count) - zstring.tonumber(_ED.warfare_card_info[i].card_use_surplus_number)
		local remain = ferrNumber - number
		if remain <= 0 then 
			remain = 0
		end
		ccui.Helper:seekWidgetByName(root,"Text_tactical_loading_"..i):setString("" ..remain)
	end
end

function NationalWarCityWarUITactics:playActionCard(index)
	local root = self.roots[1]
	local action = self.actions[1]
	self.tactics_indes = index
	local Panel_nationalwar_tactical_card = ccui.Helper:seekWidgetByName(root, "Panel_nationalwar_tactical_card")
	local warfareCardData = dms.element(dms["warfare_card"],index)
    local m_index = dms.atoi(warfareCardData,warfare_card.pic)
    Panel_nationalwar_tactical_card:setBackGroundImage("images/ui/play/nationalwar/nationalwar_card_"..m_index..".png")
	local Text_nationalwar_tactical_card_description = ccui.Helper:seekWidgetByName(root, "Text_nationalwar_tactical_card_description")
	Text_nationalwar_tactical_card_description:setString(dms.atos(warfareCardData,warfare_card.remark))
	local Text_nationalwar_tactical_use = ccui.Helper:seekWidgetByName(root, "Text_nationalwar_tactical_use")
	
	local number = dms.atoi(warfareCardData,warfare_card.use_count) - zstring.tonumber(_ED.warfare_card_info[index].card_use_surplus_number)
	Text_nationalwar_tactical_use:setString(number.."/"..dms.atos(warfareCardData,warfare_card.use_count))
	
	local Text_tactical_card_loading = ccui.Helper:seekWidgetByName(root, "Text_tactical_card_loading")
	local ferrNumber = 0
	local consume = dms.atos(warfareCardData,warfare_card.consume)
	local params = zstring.split(consume, ",")
	local remain = 0
	for j=1, #params do
		if zstring.tonumber(params[j]) == 0 then
			ferrNumber = ferrNumber+1
		end
	end
	local remain = ferrNumber - number
	if remain <= 0 then 
		remain = 0
	end
	Text_tactical_card_loading:setString(""..remain)
	self.card_use_time = zstring.tonumber(_ED.warfare_card_info[self.tactics_indes].card_use_time)/1000
	if zstring.tonumber(_ED.warfare_card_info[index].card_use_time) <= 0 then--如果没有cd
		ccui.Helper:seekWidgetByName(root, "Button_tactical_use"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_nationalwar_tactical_card_time"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Button_tactical_use"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_nationalwar_tactical_card_time"):setVisible(true)
	end
	
	for i=1, 5 do
		if i == zstring.tonumber(index) then
			ccui.Helper:seekWidgetByName(root, "Image_nationalwar_tactical_card_"..i):setScale(0.65)
		else
			ccui.Helper:seekWidgetByName(root, "Image_nationalwar_tactical_card_"..i):setScale(0.6)
		end
	end
	action:play("window_open_choose", false)
end

function NationalWarCityWarUITactics:onUpdateTime(params)
	local root = self.roots[1]
    local time = math.modf(params)
    local hour = math.floor(time/ (60 * 60))
    time = time - (hour * 60 * 60)
    local minute = math.floor(time / 60)
    time = time - minute * 60
    local second = time % 60
    ccui.Helper:seekWidgetByName(root, "Text_nationalwar_tactical_card_time"):setString(string.format("%s (%02d:%02d:%02d)", "", hour, minute, second))
end

function NationalWarCityWarUITactics:onUpdate(dt)
	local root = self.roots[1]
	if self.tactics_indes ~= 0 then
		self.card_use_time = self.card_use_time- dt
		if tonumber(self.card_use_time) <= 0 then
			ccui.Helper:seekWidgetByName(root, "Button_tactical_use"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Panel_nationalwar_tactical_card_time"):setVisible(false)
		else
			ccui.Helper:seekWidgetByName(root, "Button_tactical_use"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_nationalwar_tactical_card_time"):setVisible(true)
			self:onUpdateTime(self.card_use_time)
		end
    end
end

function NationalWarCityWarUITactics:init(params)
	self.city_id = params[1]  
	self.animationPanel = params[2]
    self:onInit()
    return self
end

function NationalWarCityWarUITactics:onExit()
    state_machine.remove("nationalwar_tactical_card_choose")
    state_machine.remove("nationalwar_tactical_card_use")
    state_machine.remove("nationalwar_tactical_card_update_free_times")
end
