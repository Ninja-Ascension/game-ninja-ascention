-----------------------------
-- 诸神赐福激活
-----------------------------
ConstellationShipActivation = class("ConstellationShipActivationClass", Window)

local constellation_ship_activation_open_terminal = {
	_name = "constellation_ship_activation_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("ConstellationShipActivationClass") == nil then
            fwin:open(ConstellationShipActivation:new():init(params), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local constellation_ship_activation_close_terminal = {
	_name = "sconstellation_ship_activation_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ConstellationShipActivationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(constellation_ship_activation_open_terminal)
state_machine.add(constellation_ship_activation_close_terminal)
state_machine.init()

function ConstellationShipActivation:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentIndex = 0

    self.currentScrollView = nil
    self.leftButton = nil
    self.rightButton = nil

    self.lastIndex = -1

    app.load("client.l_digital.cells.cultivate.constellation.constellation_star_activation_cell")
    app.load("client.l_digital.cultivate.constellation.ConstellationPageCell")

    app.load("client.l_digital.cultivate.SmCultivateWindow")
    app.load("client.l_digital.cells.cultivate.constellation.constellation_cell")
    
    local function init_sm_cultivate_constellat_terminal()
        local ship_start_btn_change_terminal = {
            _name = "ship_start_btn_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local chooseIndex = params._datas.ship_type
                instance:changePageViewShow(chooseIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local constellat_ship_activation_update_terminal = {
            _name = "constellat_ship_activation_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = instance.last_index
                instance:initData()
                instance:changePageViewShow(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --红点
        local constellat_ship_activation_redot_update_terminal = {
            _name = "constellat_ship_activation_redot_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local groups =  _ED.constellation_redot_data[tonumber(instance.constellation_mould_id)][tonumber(instance.index) - 1]
                for i=1,6 do
                    if groups[i] then
                        local img_redot = ccui.Helper:seekWidgetByName(instance.roots[1],"Image_red_" .. i)
                        img_redot:setVisible(tonumber(groups[i]) == 0)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(ship_start_btn_change_terminal)
        state_machine.add(constellat_ship_activation_update_terminal)
        state_machine.add(constellat_ship_activation_redot_update_terminal)
        state_machine.init()
    end
    init_sm_cultivate_constellat_terminal()
end

function ConstellationShipActivation:onUpdateDraw()
    local root = self.roots[1]
    local ship_name = ccui.Helper:seekWidgetByName(root,"Text_maoxian_name")
    local name_mould_id = dms.int(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_name_id)
    local type_id = dms.int(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_ship_type)
    local name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    ship_name:setString(name)

    for i, v in ipairs(self.classify_group_id) do
        local quality_grader_config = zstring.splits(dms.string(dms["play_config"], 80, play_config.param), "|", ",")
        local need_user_grade = 0
        if tonumber(i) == tonumber(quality_grader_config[i][1]) then
            need_user_grade = quality_grader_config[i][2]
        end
        local ship_start_btn = ccui.Helper:seekWidgetByName(root,"Button_xz_lv_" .. i)
        local Button_xz_lv_lock = ccui.Helper:seekWidgetByName(root, string.format("Button_xz_lv_%d_lock", tonumber(i)))
        if zstring.tonumber(need_user_grade) > zstring.tonumber(_ED.user_info.user_grade) then
            Button_xz_lv_lock:setVisible(true)
            ship_start_btn:setVisible(false)
            Button_xz_lv_lock:getChildByName("Text_lv_lock_" .. i):setString(string.format(tipStringInfo_constellation_tips[5], tonumber(need_user_grade)))
        else
            Button_xz_lv_lock:setVisible(false)
            ship_start_btn:setVisible(true)
        end
        fwin:addTouchEventListener(ship_start_btn, nil, 
        {
            terminal_name = "ship_start_btn_change", 
            terminal_state = 0, 
            ship_type = i, 
            touch_black = true,
        }, nil, 3)
    end
    self.last_index = 1
    self:changePageViewShow(1)
end

function ConstellationShipActivation:initData()
    local ship_group_ids = dms.string(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_group_id)
    local ship_group_id = zstring.split(ship_group_ids, ",")[tonumber(self.index)]
    local all_groups = dms.searchs(dms["constellation_group"], constellation_group.group_id, ship_group_id)
    local classify_group_id = {}
    local temp_group_ids = {}
    local level_id = 0
    for i,v in ipairs(all_groups) do
        local current_level_id = zstring.tonumber(v[constellation_group.level_id])
        if current_level_id ~= level_id then
            if #temp_group_ids > 0 then
                table.insert(classify_group_id, temp_group_ids)
            end
            temp_group_ids = {}
            level_id = current_level_id
            table.insert(temp_group_ids, v)
        else
            table.insert(temp_group_ids, v)
            if i == #all_groups then
                table.insert(classify_group_id, temp_group_ids)
            end
        end
    end
    self.classify_group_id = classify_group_id
end

function ConstellationShipActivation:changePageViewShow( index )
    local root = self.roots[1]
    for i=1,6 do
        local tab_btn = ccui.Helper:seekWidgetByName(root,"Button_xz_lv_" .. i)
        if index == i then
            tab_btn:setHighlighted(true)
            tab_btn:setTouchEnabled(false)
        else
            tab_btn:setHighlighted(false)
            tab_btn:setTouchEnabled(true)
        end
    end

    for i,v in ipairs(self.classify_group_id[index]) do
        if v then
            local ship_panel = ccui.Helper:seekWidgetByName(root,"Panel_xz_lv_" .. v[constellation_group.level_type])
            local cell = ConstellationShipActivationCell:createCell()
            ship_panel:removeAllChildren(true)
            cell:init({v[constellation_group.id], self.index, self.constellation_mould_id, self.cell})
            ship_panel:addChild(cell)
        end
    end
    self.last_index = index

    local groups =  _ED.constellation_redot_data[tonumber(self.constellation_mould_id)][tonumber(self.index) - 1]
    if groups[index] and tonumber(groups[index]) == 0 then
        _ED.constellation_redot_data[tonumber(self.constellation_mould_id)][tonumber(self.index) - 1][index] = 1
        state_machine.excute("constellat_ship_activation_redot_update", 0, "")

        state_machine.excute("constellation_ship_redot_update", 0, self.cell)

        local cultivateWindow = fwin:find("SmCultivateWindowClass")
        if cultivateWindow and cultivateWindow:isVisible() then
            state_machine.excute("sm_cultivate_constellation_redot_update", 0, "")
        end     
    end
end


function ConstellationShipActivation:onUpdate( dt )
    
end

function ConstellationShipActivation:init(params)
    self.constellation_mould_id = params[1] .. ""
    self.index = params[2] .. ""
    self.cell = params[3]
    local ship_ids = dms.string(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_ship_id)
    self.ship_template_id = zstring.split(ship_ids, ",")[self.index]
    if zstring.tonumber(self.ship_template_id) == -1 then
        return
    end
	self:onInit()
    return self
end

function ConstellationShipActivation:onInit()
    local csbItem = csb.createNode("cultivate/constellation_star_activation.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    self.roots = {}
    table.insert(self.roots, root)

    self:initData()
    self:onUpdateDraw()
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_star_activation_close"), nil, 
    {
        terminal_name = "sconstellation_ship_activation_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    state_machine.excute("constellat_ship_activation_redot_update", 0, "")
    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

end

function ConstellationShipActivation:onEnterTransitionFinish()
end

function ConstellationShipActivation:onExit()
    state_machine.remove("constellat_ship_activation_update")
    state_machine.remove("constellat_ship_activation_update")
end
