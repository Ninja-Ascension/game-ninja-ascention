----------------------------------------------------------------------------------------------------
-- 说明：使用道具cell
-------------------------------------------------------------------------------------------------------
PropsUseCell = class("PropsUseCellClass", Window)
PropsUseCell.__size = nil

local props_use_create_cell_terminal = {
    _name = "props_use_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PropsUseCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_use_create_cell_terminal)
state_machine.init()

function PropsUseCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._index = 0
    self._id = 0
	self._prop_id = 0
    self._buy_type = 0
    self._use_id = -1
    self._build_id = 0

    app.load("client.red_alert_time.props.PropsInforPrompt")
    app.load("client.red_alert_time.props.PropsHornUse")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
 	local function init_props_use_cell_terminal()
        -- 使用
        local props_use_cell_props_use_terminal = {
            _name = "props_use_cell_props_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell == nil or cell.roots == nil or cell.roots[1] == nil then
                    return
                end
                local prop = fundPropWidthId(cell._prop_id)
                if prop == nil then
                    cell:onUpdateDraw()
                    return true
                end

                local talent_id = dms.int(dms["prop_mould"], cell._prop_id, prop_mould.use_of_power)
                if talent_id > 0 then
                    local build_buff_id = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.build_buff_id), ",")
                    if tonumber(build_buff_id[1]) > 0 then
                        local can_use = true
                        local add_time = dms.int(dms["talent_mould"], talent_id, talent_mould.add_buff_time)
                        add_time = add_time * 1000
                        for k1,v1 in pairs(_ED.factor_info) do
                            for k, v in pairs(build_buff_id) do
                                local current_time = 0
                                if tonumber(v1.build_buff_id) == tonumber(v) then
                                    current_time = v1.factor_cd_time * 1000
                                end
                                local total_time = current_time + add_time
                                if total_time > max_int_tip_info then
                                    can_use = false
                                    break
                                end
                            end
                        end
                        if can_use == false then
                            TipDlg.drawTextDailog(red_alert_time_str[230])  
                            return
                        end
                    end
                end
                local last_level = 0
                if _ED.home_build[""..cell._use_id] ~= nil then
                    last_level = tonumber(_ED.home_build[""..cell._use_id].level) 
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if response.node._buy_type == 3 then        -- 科技
                                state_machine.excute("home_map_update_prodcution_state", 0, {3})
                            elseif response.node._buy_type == 4 then        -- 生产
                                state_machine.excute("home_map_update_prodcution_state", 0, {response.node._build_id})
                            end
                            if response.node._buy_type >= 5 then
                                local prop_name = dms.string(dms["prop_mould"], response.node._prop_id, prop_mould.prop_name)
                                TipDlg.drawTextDailog(string.format(red_alert_time_str[21], prop_name))
                            else
                                checkRewardObtainDraw()
                            end
                            if _ED.home_build[""..response.node._use_id] ~= nil then
                                if last_level < tonumber(_ED.home_build[""..response.node._use_id].level) then
                                    checkPlayEffect(36)
                                end
                            end
                        end
                        state_machine.excute("build_up_build_quickly_update_draw", 0, nil)
                        state_machine.excute("build_up_build_production_quickly_update_draw", 0, nil)
                        state_machine.excute("build_up_build_scientific_quickly_update_draw", 0, nil)
                        state_machine.excute("props_use_window_update", 0, nil)
                        state_machine.excute("props_use_window_need_update", 0, nil)
                    end
                end
                local buy_type = cell._buy_type
                if buy_type == 2 or buy_type == 3 or buy_type == 4 then
                    buy_type = buy_type - 2
                else
                    buy_type = -1
                end
                if prop ~= nil then
                    protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1".."\r\n"..buy_type.."\r\n"..cell._use_id
                    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, cell, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买使用
        local props_use_cell_props_buy_use_terminal = {
            _name = "props_use_cell_props_buy_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell == nil or cell.roots == nil then
                    return
                end
                if cell._buy_type == 1 or cell._buy_type == 9 then
                    local shop_of_gold = dms.int(dms["prop_mould"], cell._prop_id, prop_mould.shop_of_gold)
                    local name = dms.string(dms["prop_mould"], cell._prop_id, prop_mould.prop_name)
                    local sell_tag = dms.int(dms["prop_mould"], self._prop_id, prop_mould.sell_tag)
                    if sell_tag > 0 then
                        if _ED.world_map ~= nil then
                            local store_addition = dms.string(dms["world_level_addition_param"], zstring.tonumber(_ED.world_level), world_level_addition_param.store_addition)
                            shop_of_gold =  math.ceil(tonumber(shop_of_gold)*(1-tonumber(store_addition)))
                        end
                    end
                    local tip = ConfirmTip:new()
                    tip:init(cell, cell.buyPropAndUse, string.format(red_alert_all_str[307], shop_of_gold, name))
                    fwin:open(tip, fwin._windows)
                else
                    cell:buyPropAndUse(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 道具详情
        local props_use_cell_props_info_terminal = {
            _name = "props_use_cell_props_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("props_infor_prompt_window_open", 0, {cell._prop_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_use_cell_props_use_terminal)
        state_machine.add(props_use_cell_props_buy_use_terminal)
        state_machine.add(props_use_cell_props_info_terminal)
        state_machine.init()
    end
	init_props_use_cell_terminal()        	
end

function PropsUseCell:buyPropAndUse( sure_number )
    if self == nil or self.roots == nil then
        return
    end
    local last_level = 0
    if _ED.home_build[""..self._use_id] ~= nil then
        last_level = tonumber(_ED.home_build[""..self._use_id].level) 
    end
    local function responseBuyCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                local function responseCallback( response )
                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        TipDlg.drawTextDailog(red_alert_all_str[307+response.node._buy_type])
                        checkRewardObtainDraw()
						if response.node._buy_type == 3 then        -- 科技
                            state_machine.excute("home_map_update_prodcution_state", 0, {3})
                        elseif response.node._buy_type == 4 then        -- 生产
                            state_machine.excute("home_map_update_prodcution_state", 0, {response.node._build_id})
                        elseif response.node._buy_type == 9 then --使用保护罩
							if fwin:find("redAlertTimeMineBaseOperationInterfaceClass") ~= nil then
								state_machine.excute("red_alert_time_mine_back_to_base_update", 0, 0)
							end
                        end
                        if _ED.home_build[""..response.node._use_id] ~= nil then
                            if last_level < tonumber(_ED.home_build[""..response.node._use_id].level) then
                                checkPlayEffect(36)
                            end
                        end
                    end
                    state_machine.excute("build_up_build_quickly_update_draw", 0, nil)
                    state_machine.excute("build_up_build_production_quickly_update_draw", 0, nil)
                    state_machine.excute("build_up_build_scientific_quickly_update_draw", 0, nil)
                    state_machine.excute("props_use_window_update", 0, nil)
                    state_machine.excute("props_use_window_need_update", 0, nil)
                end
                local prop = fundPropWidthId(response.node._prop_id)
                if prop == nil then
                    response.node:onUpdateDraw()
                    return true
                end

                local talent_id = dms.int(dms["prop_mould"], self._prop_id, prop_mould.use_of_power)
                if talent_id > 0 then
                    local build_buff_id = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.build_buff_id), ",")
                    if tonumber(build_buff_id[1]) > 0 then
                        local can_use = true
                        local add_time = dms.int(dms["talent_mould"], talent_id, talent_mould.add_buff_time)
                        add_time = add_time * 1000
                        for k1,v1 in pairs(_ED.factor_info) do
                            for k, v in pairs(build_buff_id) do
                                local current_time = 0
                                if tonumber(v1.build_buff_id) == tonumber(v) then
                                    current_time = v1.factor_cd_time * 1000
                                end
                                local total_time = current_time + add_time
                                if total_time > max_int_tip_info then
                                    can_use = false
                                    break
                                end
                            end
                        end
                        if can_use == false then
                            TipDlg.drawTextDailog(red_alert_time_str[230])  
                            return
                        end
                    end
                end

                local buy_type = response.node._buy_type
                if buy_type == 2 or buy_type == 3 or buy_type == 4 then
                    buy_type = buy_type - 2
                else
                    buy_type = -1
                end
                if prop ~= nil then
                    _ED.show_reward_list_group_ex = {}
                    protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1".."\r\n"..buy_type.."\r\n"..response.node._use_id
                    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, response.node, responseCallback, false, nil)   
                end 
            end
        end
    end
    if sure_number == 0 then
        protocol_command.build_shop_buy.param_list = self._id.."\r\n"..(self._index - 1).."\r\n1"
        NetworkManager:register(protocol_command.build_shop_buy.code, nil, nil, nil, self, responseBuyCallback, false, nil)
    end
end

function PropsUseCell:onUpdateDraw()
	local root = self.roots[1]
    -- 道具icon
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{7,1,self._prop_id,1})
    Panel_props_icon:addChild(cell) 

    -- 道具名字
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    Text_props_name:setString(prop_name)
    -- 道具描述
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local remarks = dms.string(dms["prop_mould"], self._prop_id, prop_mould.remarks)
    Text_props_infor:setString(remarks)
    
    local Button_props_buy_use = ccui.Helper:seekWidgetByName(root,"Button_props_buy_use")  -- 购买使用按钮
    local Button_props_use = ccui.Helper:seekWidgetByName(root,"Button_props_use")  -- 使用按钮
    local Image_glod_icon = ccui.Helper:seekWidgetByName(root,"Image_glod_icon")    -- 金币图标
    Button_props_buy_use:setVisible(false)
    Button_props_use:setVisible(false)
    Image_glod_icon:setVisible(false)
    -- 需要金币数
    local Text_glod_n = ccui.Helper:seekWidgetByName(root,"Text_glod_n")            
    local shop_of_gold = dms.int(dms["prop_mould"], self._prop_id, prop_mould.shop_of_gold)
    local sell_tag = dms.int(dms["prop_mould"], self._prop_id, prop_mould.sell_tag)
    if sell_tag > 0 then
        if _ED.world_map ~= nil then
            local store_addition = dms.string(dms["world_level_addition_param"], zstring.tonumber(_ED.world_level), world_level_addition_param.store_addition)
            shop_of_gold =  math.ceil(tonumber(shop_of_gold)*(1-tonumber(store_addition)))
        end
    end
    Text_glod_n:setString("")
    -- 拥有数量
    local Text_have_props_n = ccui.Helper:seekWidgetByName(root,"Text_have_props_n")      
    local prop_count = 0 
    if fundPropWidthId(self._prop_id) ~= nil then 
        local token = fundPropWidthId(self._prop_id)
        prop_count = token.prop_number
    end
    Text_have_props_n:setString("")
    if zstring.tonumber(prop_count) > 0 then
        Text_have_props_n:setString(string.format(red_alert_time_str[64], prop_count))
        Button_props_use:setVisible(true)
    else
        Button_props_buy_use:setVisible(true)
        Image_glod_icon:setVisible(true)
        Text_glod_n:setString(shop_of_gold)
    end
end

function PropsUseCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.props.props_use_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PropsUseCell.__size == nil then
		PropsUseCell.__size = root:getContentSize()
	end

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_use"), nil, 
    {
        terminal_name = "props_use_cell_props_use",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 购买使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_buy_use"), nil, 
    {
        terminal_name = "props_use_cell_props_buy_use",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 道具详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_icon"), nil, 
    {
        terminal_name = "props_use_cell_props_info",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

	self:onUpdateDraw()
end

function PropsUseCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.props.props_use_cell, self.roots[1])
end

function PropsUseCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PropsUseCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.props.props_use_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function PropsUseCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local Button_props_buy_use = ccui.Helper:seekWidgetByName(root,"Button_props_buy_use")
    local Button_props_use = ccui.Helper:seekWidgetByName(root,"Button_props_use")
    local Image_glod_icon = ccui.Helper:seekWidgetByName(root,"Image_glod_icon")
    local Text_glod_n = ccui.Helper:seekWidgetByName(root,"Text_glod_n")    
    local Text_have_props_n = ccui.Helper:seekWidgetByName(root,"Text_have_props_n")     

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Text_props_name:setString("")
        Text_props_infor:setString("")
        Button_props_buy_use:setVisible(true)
        Button_props_use:setVisible(false)
        Image_glod_icon:setVisible(true)
        Text_glod_n:setString("")
        Text_have_props_n:setString("")
    end
end

function PropsUseCell:init(params)
    self._index = params[1]
    self._id = params[2]
    self._prop_id = params[3]
    self._buy_type = params[4]
    if params[5] ~= nil then
        self._use_id = params[5]
    end
    if params[6] ~= nil then
        self._build_id = params[6]
    end
    -- if self._index <= 6 then
	   self:onInit()
    -- end
	self:setContentSize(PropsUseCell.__size)
end

