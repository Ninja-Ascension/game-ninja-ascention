----------------------------------------------------------------------------------------------------
-- 说明：背包道具cell
-------------------------------------------------------------------------------------------------------
PropsShopPacksPacksCell = class("PropsShopPacksPacksCellClass", Window)
PropsShopPacksPacksCell.__size = nil

local props_shop_packs_packs_cell_create_terminal = {
    _name = "props_shop_packs_packs_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PropsShopPacksPacksCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_shop_packs_packs_cell_create_terminal)
state_machine.init()

function PropsShopPacksPacksCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._prop_id = 0
    self._trace_address = 0

    self._prop_name = ""

    app.load("client.red_alert_time.props.PropsInforPrompt")
    app.load("client.red_alert_time.props.PropsHornUse")
    app.load("client.red_alert_time.utils.ShortCut")
    app.load("client.red_alert_time.worldMap.redAlertTimeMinePropsReconnaissance")
    app.load("client.red_alert_time.props.propsUseRedEnvelopes")
    app.load("client.red_alert_time.props.PropsUseChangeName")

    local function init_props_shop_packs_packs_cell_terminal()
        -- 使用
        local props_shop_packs_packs_cell_props_use_terminal = {
            _name = "props_shop_packs_packs_cell_props_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local prop = fundPropWidthId(cell._prop_id)
                if prop == nil then
                    state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, "")
                    return true
                end

                local is_camouflage_prop = false       -- 是否是基地伪装道具
                local is_replace = false               -- 是否已有其他伪装
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

                    -- 基地伪装
                    if tonumber(build_buff_id[1]) >= 11 and tonumber(build_buff_id[1]) <= 20 then
                        is_camouflage_prop = true
                        for k, v in pairs(_ED.factor_info) do
                            if tonumber(v.build_buff_id) ~= tonumber(build_buff_id[1]) 
                                and tonumber(v.build_buff_id) >= 11 and tonumber(v.build_buff_id) <= 20
                                then
                                is_replace = true
                                break
                            end
                        end
                    end
                end

				if tonumber(cell._prop_id) == dms.int(dms["prop_config"], 23, prop_config.param) or tonumber(cell._prop_id) == dms.int(dms["prop_config"], 24, prop_config.param) then
					if funOpenDrawTip(210) == true then
                        return
                    end
                    state_machine.excute("red_alert_time_mine_props_reconnaissance_open", 0, cell._prop_id)
				else
					if tonumber(cell._trace_address[1]) == 4 then
						if tonumber(prop.prop_number) > 1 
							and tonumber(cell._prop_id)~= dms.int(dms["prop_config"], 21, prop_config.param) 
							and tonumber(cell._prop_id)~= dms.int(dms["prop_config"], 25, prop_config.param) 
                            and tonumber(cell._prop_id)~= dms.int(dms["prop_config"], 26, prop_config.param) 
                            and tonumber(cell._prop_id)~= dms.int(dms["prop_config"], 40, prop_config.param) 
                            and tonumber(cell._prop_id)~= 693 
							and tonumber(cell._prop_id)~= 694
                            and is_camouflage_prop == false
							then
							state_machine.excute("props_batch_use_window_open", 0, {cell._prop_data.prop_id, prop.user_prop_id, tonumber(prop.prop_number),cell._pack_type})
						else
							local prop_name = cell._prop_name
							local p_type = -1

                            local function sureUseProp(_instance, sure_number)
                                if sure_number ~= 0 then
                                    return
                                end

    							local function responseCallback( response )
    								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    									if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
    										if response.node._pack_type == 2 
    											or (response.node._prop_id >= 1 and response.node._prop_id <= 11) 
    											or (response.node._prop_id >= 121 and response.node._prop_id <= 132) 
    											or (response.node._prop_id >= 163 and response.node._prop_id <= 242) 
    											then 
    											TipDlg.drawTextDailog(string.format(red_alert_time_str[21], prop_name))
    										else
    											checkRewardObtainDraw()
    										end
    										if tonumber(cell._prop_id) == dms.int(dms["prop_config"], 21, prop_config.param)
                                                or tonumber(cell._prop_id) == dms.int(dms["prop_config"], 40, prop_config.param)
                                                then
    											state_machine.excute("red_alert_time_mine_locate_yourself", 0, "")
                                                state_machine.excute("adventure_mine_reset_boss_update_draw", 0, nil)
                                                state_machine.excute("short_cut_go_to_other_window", 0, {14})
                                            end
    									end
                                        state_machine.excute("player_info_skill_update_skill_point", 0, nil)
    									state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, "")
    									state_machine.excute("main_window_update_userinfo", 0, nil)
    									state_machine.excute("home_map_update_tanke_info", 0, "")
                                        state_machine.excute("build_up_tank_production_proc_update_draw", 0, nil)
                                        state_machine.excute("build_up_tank_production_proc_ex_update_draw", 0, nil)
                                        state_machine.excute("build_up_make_props_update_draw", 0, nil)
    								end
    							end
    							protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1".."\r\n"..p_type.."\r\n".."-1"
    							NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, cell, responseCallback, false, nil)
                            end

                            if tonumber(cell._prop_id) == dms.int(dms["prop_config"], 21, prop_config.param)
                                or tonumber(cell._prop_id) == dms.int(dms["prop_config"], 40, prop_config.param)
                                then
                                p_type = 4
                            end

                            if is_camouflage_prop == true and is_replace == true then
                                local tip = ConfirmTip:new()
                                tip:init(cell, sureUseProp, red_alert_time_str[281])
                                fwin:open(tip,fwin._windows) 
                            else
                                sureUseProp(cell, 0)
                            end
						end
					elseif tonumber(cell._trace_address[1]) == 5 then
                        local tdata = cell._trace_address[2]
                        state_machine.excute("player_info_window_close",0,nil)
                        state_machine.excute("short_cut_go_to_other_window",0,{tdata})
						-- state_machine.excute("props_shop_packs_window_close",0,nil)
					elseif tonumber(cell._trace_address[1]) == 7 then  --（1红包 2喇叭 3搜索 4改名）
                        if tonumber(cell._trace_address[2]) == 1 then
                            state_machine.excute("props_use_red_envelopes_window_open",0,{prop})
                        elseif tonumber(cell._trace_address[2]) == 2 then
                            state_machine.excute("props_horn_use_window_open",0,{prop})
                        elseif tonumber(cell._trace_address[2]) == 3 then
                        elseif tonumber(cell._trace_address[2]) == 4 then
                            state_machine.excute("props_use_change_name_window_open", 0, {prop})
                        else
                        end
					end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 道具详情
        local props_shop_packs_packs_cell_props_info_terminal = {
            _name = "props_shop_packs_packs_cell_props_info",
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

        local props_shop_packs_packs_cell_update_info_terminal = {
            _name = "props_shop_packs_packs_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._prop_data = params.info
                cell._pack_type = params.pack_type
                cell._index = params.index
                if cell._prop_data ~= nil then
                    cell._prop_id = cell._prop_data.prop_id
                    if cell._index <= 7 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_shop_packs_packs_cell_props_use_terminal)
        state_machine.add(props_shop_packs_packs_cell_props_info_terminal)
        state_machine.add(props_shop_packs_packs_cell_update_info_terminal)
        state_machine.init()
    end
    init_props_shop_packs_packs_cell_terminal()          
end

function PropsShopPacksPacksCell:onUpdateDraw()
    local root = self.roots[1]
    -- 道具icon
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,1,self._prop_id,1})
    Panel_props_icon:addChild(cell) 
    -- 道具名字
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    Text_props_name:setString(prop_name)
    if __lua_project_id == __lua_project_pacific_rim then
        local prop_quality = dms.int(dms["prop_mould"], self._prop_id, prop_mould.prop_quality)
        Text_props_name:setColor(cc.c3b(color_Type[prop_quality + 1][1], color_Type[prop_quality + 1][2], color_Type[prop_quality + 1][3]))
    end
    self._prop_name = prop_name
    -- 道具描述
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local remarks = dms.string(dms["prop_mould"], self._prop_id, prop_mould.remarks)
    Text_props_infor:setString(remarks)
    
    -- 拥有数量
    local Text_props_have_n = ccui.Helper:seekWidgetByName(root,"Text_props_have_n")      
    Text_props_have_n:setString(tipStringInfo_build_up_info[25]..self._prop_data.count)

    -- 是否可使用
    local Button_props_use = ccui.Helper:seekWidgetByName(root,"Button_props_use")
    self._trace_address = dms.string(dms["prop_mould"], self._prop_id, prop_mould.trace_address)
    self._trace_address = zstring.split(self._trace_address, "|")
    if tonumber(self._trace_address[1]) == 6 then
        Button_props_use:setVisible(false)
    else
        Button_props_use:setVisible(true)
    end
end

function PropsShopPacksPacksCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.props.props_shop_packs_packs_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if PropsShopPacksPacksCell.__size == nil then
        PropsShopPacksPacksCell.__size = root:getContentSize()
    end

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_use"), nil, 
    {
        terminal_name = "props_shop_packs_packs_cell_props_use",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    -- 道具详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_icon"), nil, 
    {
        terminal_name = "props_shop_packs_packs_cell_props_info",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    self:onUpdateDraw()
end

function PropsShopPacksPacksCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.props_shop_packs_packs_cell, self.roots[1])
end

function PropsShopPacksPacksCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PropsShopPacksPacksCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.props_shop_packs_packs_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function PropsShopPacksPacksCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local Text_props_have_n = ccui.Helper:seekWidgetByName(root,"Text_props_have_n")  
    local Button_props_use = ccui.Helper:seekWidgetByName(root,"Button_props_use") 

    if Panel_props_icon ~= nil then   
        Panel_props_icon:removeAllChildren(true)
        Text_props_name:setString("")
        Text_props_infor:setString("")
        Text_props_have_n:setString("")
        Button_props_use:setVisible(true)
    end

    self._trace_address = 0
end

function PropsShopPacksPacksCell:init(params)
    self._index = params[1]
    self._prop_data = params[2]
    self._pack_type = params[3]
    self._prop_id = self._prop_data.prop_id
    if self._index <= 7 then
        self:onInit()
    end
    self:setContentSize(PropsShopPacksPacksCell.__size)
end

