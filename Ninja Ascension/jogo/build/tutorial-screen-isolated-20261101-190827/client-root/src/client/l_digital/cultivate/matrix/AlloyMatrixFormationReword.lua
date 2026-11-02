-----------------------------
-- 合金矩阵列表
-----------------------------
AlloyMatrixFormationReword = class("AlloyMatrixFormationRewordClass", Window)

local alloy_matrix_formation_reword_open_terminal = {
	_name = "alloy_matrix_formation_reword_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixFormationRewordClass") == nil then
            fwin:open(AlloyMatrixFormationReword:new():init(params), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_formation_reword_close_terminal = {
	_name = "alloy_matrix_formation_reword_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AlloyMatrixFormationRewordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_formation_reword_open_terminal)
state_machine.add(alloy_matrix_formation_reword_close_terminal)
state_machine.init()

function AlloyMatrixFormationReword:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixInformation")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationChange")
    
    local function init_alloy_matrix_terminal()
        --  领奖
        local alloy_serial_list_all_get_terminal = {
            _name = "alloy_serial_list_all_get",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship_id = instance.ship.ship_id
                local _type = params._datas._type
                local id = params._datas.id
                if not instance.all_get_params or instance.all_get_params == "" then
                    TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[14])
                    return
                end

                local matrix_ids = _type == 1 and id or instance.all_get_params
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd,fwin._ui)
                            response.node:onUpdateDraw()
                            state_machine.excute("alloy_matrix_formation_reword_redot",0,"")
                            state_machine.excute("alloy_matrix_change_formation_reword_redot",0,"")
                        end 
                    end
                end
                protocol_command.draw_matrix_reward.param_list = ship_id.."\r\n"..matrix_ids
                NetworkManager:register(protocol_command.draw_matrix_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(alloy_serial_list_all_get_terminal)
        state_machine.init()
    end
    init_alloy_matrix_terminal()
end

function AlloyMatrixFormationReword:onUpdateDraw()
    local root = self.roots[1]
    self.alloyMatrix = _ED.user_ship[self.ship.ship_id].alloyMatrix
    local all_ids = self:sortMatrixId()
    local ListView_serial_list = ccui.Helper:seekWidgetByName(root,"ListView_serial_list")
    ListView_serial_list:removeAllItems()

    local csbItemCell = csb.createNode("cultivate/alloy_serial_list_unit_cell.csb")
    local temp_cell = csbItemCell:getChildByName("root") 

    for i ,v in ipairs(all_ids) do
        local need_metals = zstring.splits(dms.string(dms["ship_matrix_mould"], v, ship_matrix_mould.metal_need), "|", ",")
        local nameindex = dms.int(dms["ship_matrix_mould"], v, ship_matrix_mould.name)
        local word_info = dms.element(dms["word_mould"], nameindex)
        local name = word_info[3]
        local reword = zstring.splits(dms.string(dms["ship_config"], 40, ship_config.param), "|", ",") 
        local new_need_metals = self:getNewMatrixInfo(need_metals)
        local cell = temp_cell:clone()
        local cell_name = ccui.Helper:seekWidgetByName(cell,"Text_alloy_serial_list_name")
        local Text_alloy_serial_list_stuff_n = ccui.Helper:seekWidgetByName(cell,"Text_alloy_serial_list_stuff_n")
        local Text_alloy_serial_list_jb_n = ccui.Helper:seekWidgetByName(cell,"Text_alloy_serial_list_jb_n")
        local Panel_alloy_serial_list_in_1 = ccui.Helper:seekWidgetByName(cell,"Panel_alloy_serial_list_in_1")
        local Image_alloy_serial_list_in_2 = ccui.Helper:seekWidgetByName(cell,"Image_alloy_serial_list_in_2")
        local Button_alloy_serial_list_single_get = ccui.Helper:seekWidgetByName(cell,"Button_alloy_serial_list_single_get")
        cell_name:setString(name)

        Text_alloy_serial_list_stuff_n:setString(reword[1][3])
        Text_alloy_serial_list_jb_n:setString(reword[2][3])

        Panel_alloy_serial_list_in_1:setVisible(not(self.alloyMatrix.mr[v] and tonumber(self.alloyMatrix.mr[v]) == 1))
        Image_alloy_serial_list_in_2:setVisible(self.alloyMatrix.mr[v] and tonumber(self.alloyMatrix.mr[v]) == 1)

        if not self.alloyMatrix.mr[v] then
            Button_alloy_serial_list_single_get:setBright(false)
            Button_alloy_serial_list_single_get:setTouchEnabled(false)
        elseif self.alloyMatrix.mr[v] and self.alloyMatrix.mr[v] == 0 then
            Button_alloy_serial_list_single_get:setBright(true)
            Button_alloy_serial_list_single_get:setTouchEnabled(true)
        end

         --领取
        fwin:addTouchEventListener(Button_alloy_serial_list_single_get, nil, 
        {
            terminal_name = "alloy_serial_list_all_get", 
            terminal_state = 0,
            _type = 1, 
            id = v,
            touch_black = true,
        }, nil, 3)

        for k,v in ipairs(new_need_metals) do
            local Panel_alloy_serial_list_icon = ccui.Helper:seekWidgetByName(cell,"Panel_alloy_serial_list_icon_" .. k)
            Panel_alloy_serial_list_icon:setBackGroundImage(string.format("images/ui/text/smhj/hj_%s.png", v))
        end

        ListView_serial_list:addChild(cell)
    end
end

function AlloyMatrixFormationReword:getNewMatrixInfo( metals )
    local new_metals = {}
    for i, metal in ipairs(metals) do
        local num = tonumber(metal[2])
        if num > 1 then
            for k = 1, num do
                table.insert(new_metals, metal[1])
            end
        else
            table.insert(new_metals, metal[1])
        end
    end
    return new_metals
end

function AlloyMatrixFormationReword:sortMatrixId()
    local can_not_get = {} -- 不可领取
    local can_get = {} -- 可领取
    self.all_get_params = ""
    local is_got = {} -- 已领取
    local all_ids = {}
    local matrix = zstring.split(dms.string(dms["ship_mould"], self.ship.ship_template_id, 68), ",")
    for i, v in ipairs(matrix) do
        if self.alloyMatrix.mr[v] and tonumber(self.alloyMatrix.mr[v]) == 0 then
            table.insert(can_get, v)
            self.all_get_params = self.all_get_params .. v .. ","
        elseif self.alloyMatrix.mr[v] and tonumber(self.alloyMatrix.mr[v]) == 1 then
            table.insert(is_got, v)
        else
            table.insert(can_not_get, v)
        end
    end
    table.add(all_ids, can_get)
    table.add(all_ids, can_not_get)
    table.add(all_ids, is_got)

    return all_ids
end

function AlloyMatrixFormationReword:onUpdate( dt )
    
end

function AlloyMatrixFormationReword:init(params)
    self.ship = params._datas._ship
	self:onInit()
    return self
end

function AlloyMatrixFormationReword:onInit()
    local csbItem = csb.createNode("cultivate/alloy_serial_list.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_serial_list_close"), nil, 
    {
        terminal_name = "alloy_matrix_formation_reword_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --一键领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_serial_list_all_get"), nil, 
    {
        terminal_name = "alloy_serial_list_all_get", 
        terminal_state = 0,
        _type = 2, 
        touch_black = true,
    }, nil, 3)
    self:onUpdateDraw()
end

function AlloyMatrixFormationReword:onEnterTransitionFinish()
end

function AlloyMatrixFormationReword:onExit()
    state_machine.remove("tab_btn_change")
end
