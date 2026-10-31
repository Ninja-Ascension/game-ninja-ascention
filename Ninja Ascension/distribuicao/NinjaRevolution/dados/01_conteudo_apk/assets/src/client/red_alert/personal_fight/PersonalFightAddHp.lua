-----------------------------
-- 侠客疗伤
-----------------------------
PersonalFightAddHp = class("PersonalFightAddHpClass", Window)

local personal_fight_add_hp_open_terminal = {
	_name = "personal_fight_add_hp_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:open(PersonalFightAddHp:new():init(params),fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local personal_fight_add_hp_close_terminal = {
	_name = "personal_fight_add_hp_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PersonalFightAddHpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(personal_fight_add_hp_open_terminal)
state_machine.add(personal_fight_add_hp_close_terminal)
state_machine.init()

function PersonalFightAddHp:ctor()
	self.super:ctor()
	self.roots = {}

    self.listview = nil
    self.listview_poy = 0
    self.Text_11_0 = nil

    self._isSelect = false

    app.load("client.red_alert.cells.personal_fight.personal_fight_add_hp_cell")
    app.load("client.utils.ConfirmTip")

    local function init_personal_fight_add_hp_terminal()
        local personal_fight_add_hp_begin_add_terminal = {
            _name = "personal_fight_add_hp_begin_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("personal_fight_main_clear_hp_cd", 0, nil)
                -- local add_hp = 0
                -- local need_time = 0
                -- local result = ""
                -- local index = 0
                -- for k,v in pairs(instance.listview:getItems()) do
                --     if v ~= nil then
                --         add_hp = add_hp + v:getTotalAddHp()
                --         index = index + 1
                --         if index == 1 then
                --             result = result..v._info.ship_base_template_id..","..math.ceil(v:getTotalAddHp())..","..v._info.ship_id..","..math.ceil(v._info.ship_health)
                --         else
                --             result = result.."|"..v._info.ship_base_template_id..","..math.ceil(v:getTotalAddHp())..","..v._info.ship_id..","..math.ceil(v._info.ship_health)
                --         end
                --     end
                -- end
                -- add_hp = math.ceil(add_hp)

                -- -- local cost = dms.float(dms["user_stronghold_config"], 10, user_stronghold_config.info)
                -- -- local time = dms.float(dms["user_stronghold_config"], 11, user_stronghold_config.info)

                -- -- if cost * add_hp <= zstring.tonumber(_ED.user_info.user_silver) then
                -- --     TipDlg.drawTextDailog(red_alert_all_str[80])
                -- --     return
                -- -- end
                -- local function responseCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("personal_fight_add_hp_close", 0, nil)
                --         state_machine.excute("personal_fight_main_update_add_time_hp", 0, nil)
                --     end
                -- end

                -- if result ~= nil and #result > 0 then
                --     protocol_command.user_stronghold_revived.param_list = "0\r\n"..result
                --     NetworkManager:register(protocol_command.user_stronghold_revived.code, nil, nil, nil, nil, responseCallback, false, nil)
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local personal_fight_add_hp_update_info_terminal = {
            _name = "personal_fight_add_hp_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_add_hp_begin_add_terminal)
        state_machine.add(personal_fight_add_hp_update_info_terminal)
        state_machine.init()
    end

    init_personal_fight_add_hp_terminal()
end

function PersonalFightAddHp:onUpdate( dt )
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
    local time = 0
    if _ED.personal_add_hp_cd_time_end ~= nil then
        time = _ED.personal_add_hp_cd_time_end - (os.time() + _ED.time_add_or_sub)
    end
    if time < 0 then
        time = 0
    end
    self.Text_11_0:setString(self:formatTimeString(time))
end

function PersonalFightAddHp:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function PersonalFightAddHp:updateInfo( ... )
    -- local add_hp = 0
    -- local max_hp = 0
    -- local roleCount = 0
    -- local total_time = 0
    -- local total_cost = 0

    -- for i=2,6 do
    --     local ship_id = _ED.formetion[i]
    --     if tonumber(ship_id) > 0 then
    --         local ship = _ED.user_ship[""..ship_id]
    --         if ship ~= nil 
    --             and tonumber(ship.current_hp) < tonumber(ship.ship_health) 
    --             then
    --             add_hp = add_hp + tonumber(ship.ship_health) - tonumber(ship.current_hp)
    --             max_hp = max_hp + tonumber(ship.ship_health)
    --             -- total_cost = total_cost + math.ceil(hp * (900 * tonumber(_ED.user_info.user_grade) + 10000) / tonumber(v._info.ship_health))
    --             roleCount = roleCount + 1
    --         end
    --     end
    -- end
    -- add_hp = math.ceil(add_hp)

    -- if max_hp > 0 then
    --     total_time = add_hp * (roleCount * 720) / max_hp
    -- else
    --     total_time = 0
    -- end
end

function PersonalFightAddHp:updateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllItems()
    self.Text_11_0 = ccui.Helper:seekWidgetByName(root,"Text_11_0")
    local time = 0
    if _ED.personal_add_hp_cd_time_end ~= nil then
        time = _ED.personal_add_hp_cd_time_end - (os.time() + _ED.time_add_or_sub)
    end
    if time < 0 then
        time = 0
    end
    self.Text_11_0:setString(self:formatTimeString(time))
    local index = 0
    for i=2,6 do
        local ship_id = _ED.formetion[i]
        if tonumber(ship_id) > 0 then
            local ship = _ED.user_ship[""..ship_id]
            if ship ~= nil 
                and tonumber(ship.current_hp) < tonumber(ship.ship_health) 
                then
                index = index + 1
                local cell = state_machine.excute("personal_fight_add_hp_cell_create",0,{index, ship})
                ListView_1:addChild(cell)
            end
        end
    end
    ListView_1:requestRefreshView()
    self.listview = ListView_1
    self.listview_poy = ListView_1:getInnerContainer():getPositionY()
end

function PersonalFightAddHp:onInit()
    local csbItem = csb.createNode(config_csb.palyer_build.palyer_build_add_blood)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add_bolld"), nil, 
    {
        terminal_name = "personal_fight_add_hp_begin_add",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_player"), nil, 
    {
        terminal_name = "personal_fight_add_hp_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)

    self:updateDraw()
end

function PersonalFightAddHp:onEnterTransitionFinish()
    
end

function PersonalFightAddHp:init(params)
	self:onInit()
    return self
end

function PersonalFightAddHp:onExit()
    state_machine.remove("personal_fight_add_hp_begin_add")
    state_machine.remove("personal_fight_add_hp_update_info")
end