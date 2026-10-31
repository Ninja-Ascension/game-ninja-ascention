--------------------------------------------------------------------------------------------------------------
--  说明：副本扫荡界面
--------------------------------------------------------------------------------------------------------------
PveRaid = class("PveRaidClass", Window)

--打开界面
local pve_raid_open_terminal = {
	_name = "pve_raid_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PveRaidClass") == nil then
    		fwin:open(PveRaid:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_raid_close_terminal = {
	_name = "pve_raid_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveRaidClass"))
        state_machine.excute("pve_armor_tab_update_attack_times", 0, "")
        state_machine.excute("formation_defend_update_formation", 0, "")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_raid_open_terminal)
state_machine.add(pve_raid_close_terminal)
state_machine.init()

function PveRaid:ctor()
	self.super:ctor()
	self.roots = {}
    self._npc_id = 0
    self._scene_id = 0
    self.old_formation = ""
    self.fight_type = 0

    self.is_time_out = false
	self.is_number = 0
	self.m_listView = nil
	self.reward = nil
	self.old_formation = nil
	self.is_carry_on = true
    self.is_stop = true

    self.max_number = 0
    self.armor_attack_times = 0

    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

	app.load("client.red_alert_time.cells.pve.pve_sweep_settlement_cell")
    app.load("client.red_alert_time.pve.PveArmorBuyTimes")
    local function init_pve_raid_terminal()
        local pve_raid_show_terminal = {
            _name = "pve_raid_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_raid_hide_terminal = {
            _name = "pve_raid_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local pve_raid_update_draw_terminal = {
            _name = "pve_raid_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
				instance.m_listView:scrollToPercentVertical(100,0.5,true)
				state_machine.excute("main_window_update_userinfo", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 置底
        local pve_raid_update_zidi_terminal = {
            _name = "pve_raid_update_zidi",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.m_listView:scrollToPercentVertical(100,0.5,true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 扫荡操作
        local pve_raid_sweep_is_operating_terminal = {
            _name = "pve_raid_sweep_is_operating",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- instance:updateDrawList()
                -- if self.is_number + 1 >= 10 then
                --     TipDlg.drawTextDailog(sweep_tip_text[9])
                --     return
                -- end
                if zstring.tonumber(instance.fight_type) == battle_enum._fight_type._fight_type_15 then
                    instance.armor_attack_times = getArmorPveAttackTimes()
                    if instance.armor_attack_times <= 0 then
                        state_machine.excute("pve_armor_buy_times_open", 0, "")
                        return
                    end
                else
                    if tonumber(_ED.user_info.user_food) <= 0 then
                        state_machine.excute("player_energy_add_open", 0, "")
                        return
                    end
                end

				if instance.is_carry_on == false then
					local items = instance.m_listView:getItems()
					instance.m_listView:removeItem(#items - 1)
					instance.m_listView:requestRefreshView()
					instance.is_number = instance.is_number - 1
					instance.is_carry_on = true
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pve_sweep_stop"):setTitleText(formation_type_string[26])
				else
                    if instance.is_stop == true then
                        instance.max_number = instance.max_number + 10
                        instance.is_stop = false
                    end
					state_machine.excute("pve_raid_sweep_is_once_again",0,0)
					instance.is_carry_on = false
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pve_sweep_stop"):setTitleText(formation_type_string[25])
				end
				
				-- state_machine.excute("pve_sweep_settlement_cell_stop",0,{_datas = {cell = items[#items]}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pve_raid_sweep_is_once_again_terminal = {
            _name = "pve_raid_sweep_is_once_again",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.is_number <= instance.max_number then
                    instance:updateDrawList()
                    instance:updateDraw()
                else
                    state_machine.excute("pve_raid_sweep_stop", 0, 1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_raid_sweep_request_refresh_list_terminal = {
            _name = "pve_raid_sweep_request_refresh_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.m_listView:requestRefreshView()
                instance._list_view_poy = instance.m_listView:getInnerContainer():getPositionY()
                instance._list_view_height = instance.m_listView:getInnerContainer():getPositionY()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 停止扫荡
        local pve_raid_sweep_stop_terminal = {
            _name = "pve_raid_sweep_stop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local stop_type = params
                if stop_type == 1 then      -- 扫荡完成
                    instance.is_stop = true
                elseif stop_type == 2 then        -- 能量不足
                    instance.is_stop = false
                    instance.is_number = instance.is_number - 1
                elseif stop_type == 3 then   
                    instance.is_stop = false
                    instance.is_number = instance.is_number - 1
                end
                instance.is_time_out = true
                instance.is_carry_on = true
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_raid_show_terminal)
        state_machine.add(pve_raid_hide_terminal)
        state_machine.add(pve_raid_update_draw_terminal)
        state_machine.add(pve_raid_sweep_is_operating_terminal)
        state_machine.add(pve_raid_sweep_is_once_again_terminal)
        state_machine.add(pve_raid_update_zidi_terminal)
        state_machine.add(pve_raid_sweep_request_refresh_list_terminal)
        state_machine.add(pve_raid_sweep_stop_terminal)
        state_machine.init()
    end
    
    init_pve_raid_terminal()
end

function PveRaid:updateDrawList()
    local root = self.roots[1]
	-- self.reward = getSceneReward(2)
	-- if self.reward ~= nil then
	self.is_number = self.is_number + 1
    if self.is_number <= self.max_number then
        local cell = state_machine.excute("pve_sweep_settlement_create_cell", 0, {self.is_number,nil,self.old_formation,self.max_number, self.fight_type})
        self.m_listView:addChild(cell)
        self.m_listView:requestRefreshView()
    elseif self.is_number == self.max_number + 1 then
        local cell = state_machine.excute("pve_sweep_settlement_create_cell", 0, {self.is_number,nil,self.old_formation,self.max_number, self.fight_type})
        self.m_listView:addChild(cell)
        self.m_listView:requestRefreshView()
        self.is_number = self.max_number
    end

    self._list_view_poy = self.m_listView:getInnerContainer():getPositionY()
    self._list_view_height = self.m_listView:getInnerContainer():getPositionY()
	-- end
end

-- 副本扫荡
function PveRaid:updatePveSweepInfo()
    local root = self.roots[1]
    
    --当前宝石
    local Text_gemstone_n = ccui.Helper:seekWidgetByName(root, "Text_gemstone_n")
    Text_gemstone_n:setString(exChangeNumToString(_ED.user_info.user_silver))
    
    --当前能量
    local Text_pve_attack_times = ccui.Helper:seekWidgetByName(root, "Text_pve_attack_times")
    Text_pve_attack_times:setVisible(false)

    local Text__energy = ccui.Helper:seekWidgetByName(root, "Text__energy")
    local Text__energy_n = ccui.Helper:seekWidgetByName(root, "Text__energy_n")
    local Image_icon_energy = ccui.Helper:seekWidgetByName(root, "Image_icon_energy")
    Image_icon_energy:setVisible(true)
    Text__energy:setVisible(true)
    Text__energy_n:setVisible(true)

    Text__energy_n:setString(_ED.user_info.user_food)
    Image_icon_energy:setVisible(true)
end

-- 装甲扫荡
function PveRaid:updateArmorSweepInfo()
    local root = self.roots[1]
    --当前宝石
    local Text_gemstone_n = ccui.Helper:seekWidgetByName(root, "Text_gemstone_n")
    Text_gemstone_n:setString(exChangeNumToString(_ED.user_info.user_silver))

    -- 当前挑战次数
    local Text__energy = ccui.Helper:seekWidgetByName(root, "Text__energy")
    local Text__energy_n = ccui.Helper:seekWidgetByName(root, "Text__energy_n")
    local Image_icon_energy = ccui.Helper:seekWidgetByName(root, "Image_icon_energy")
    Text__energy:setVisible(false)
    Text__energy_n:setVisible(false)
    Image_icon_energy:setVisible(false)

    local Text_pve_attack_times = ccui.Helper:seekWidgetByName(root, "Text_pve_attack_times")
    Text_pve_attack_times:setVisible(true)
    self.armor_attack_times = getArmorPveAttackTimes()
    Text_pve_attack_times:setString(sweep_tip_text[16]..self.armor_attack_times)
end

function PveRaid:updateDraw()
    local root = self.roots[1]
    if self.fight_type == battle_enum._fight_type._fight_type_15 then
        self:updateArmorSweepInfo()
    else
        self:updatePveSweepInfo()
    end

    --扫荡按钮
    local Button_pve_sweep_stop = ccui.Helper:seekWidgetByName(root, "Button_pve_sweep_stop")
    if self.is_stop == true then
        Button_pve_sweep_stop:setTitleText(sweep_tip_text[10])
    elseif self.is_carry_on == false then
        Button_pve_sweep_stop:setTitleText(formation_type_string[25])
    else
        Button_pve_sweep_stop:setTitleText(formation_type_string[26])
    end
end

function PveRaid:onUpdate(dt)
    if self.m_listView ~= nil then
        local size = self.m_listView:getContentSize()
        local posY = self.m_listView:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
    end
end

--初始化
function PveRaid:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_sweep)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_sweep_close"), nil, 
    {
        terminal_name = "pve_raid_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	--扫荡或者停止
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_sweep_stop"), nil, 
    {
        terminal_name = "pve_raid_sweep_is_operating",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    },
    nil,1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)

	self.m_listView = ccui.Helper:seekWidgetByName(root, "ListView_sweep_result")
    self.m_listView:jumpToTop()
	self.m_listView:removeAllItems()
	self.m_listView:requestRefreshView()
    self._list_view_poy = self.m_listView:getInnerContainer():getPositionY()
    self._list_view_height = self.m_listView:getInnerContainer():getPositionY()

    state_machine.excute("pve_raid_sweep_is_operating", 0, "")
end

function PveRaid:onEnterTransitionFinish()

end

function PveRaid:init(params)
    self._npc_id = params._datas.scene_id
    self._scene_id = params._datas.npc_id
	self.old_formation = params._datas.old_formation
    self.fight_type = params._datas.fight_type
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function PveRaid:onExit()
    state_machine.remove("pve_raid_show")
    state_machine.remove("pve_raid_hide")
    state_machine.remove("pve_raid_update_draw")
    state_machine.remove("pve_raid_update_zidi")
    state_machine.remove("pve_raid_sweep_is_operating")
    state_machine.remove("pve_raid_sweep_is_once_again")
    state_machine.remove("pve_raid_sweep_request_refresh_list")
    state_machine.remove("pve_raid_sweep_stop")
end
