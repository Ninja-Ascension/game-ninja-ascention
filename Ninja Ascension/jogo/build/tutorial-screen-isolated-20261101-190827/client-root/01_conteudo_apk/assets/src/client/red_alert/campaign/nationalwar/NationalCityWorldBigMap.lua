-----------------------------
--单个城池信息
-----------------------------
NationalCityWorldBigMap = class("NationalCityWorldBigMapClass", Window)

local national_city_world_big_map_window_open_terminal = {
    _name = "national_city_world_big_map_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalCityWorldBigMapClass") == nil then
            fwin:open(NationalCityWorldBigMap:new():init(params))
        else
            state_machine.excute("national_city_world_big_map_window_close",0,"")
            fwin:open(NationalCityWorldBigMap:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_city_world_big_map_window_close_terminal = {
    _name = "national_city_world_big_map_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalCityWorldBigMapClass"))     
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 军情
local national_city_world_big_map_button_report_terminal = {
    _name = "national_city_world_big_map_button_report",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if _ED.union_fight_city_user_info ~= nil and 
            _ED.union_fight_city_user_info.is_death == "1" then
            TipDlg.drawTextDailog(tipStringInfo_union_str[92])
            return
        end
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local cityId = state_machine.find("national_city_world_big_map_button_report")._city_id
                if _ED.city_resource_invite_goto_info ~= nil 
                    and tonumber(_ED.city_resource_invite_goto_info.city_id) == tonumber(cityId) then
                    local function response1Callback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("map_rattling_window_open", 0, {_ED.city_resource_invite_goto_info.city_id, 
                                _ED.city_resource_invite_goto_info.resource_id, _ED.city_resource_invite_goto_info.resource_index})
                            state_machine.excute("map_build_infor_window_close", 0, nil)
                        end
                        _ED.city_resource_invite_goto_info = nil
                    end
                    protocol_command.city_resource_hold_get_resource_users.param_list = _ED.city_resource_invite_goto_info.city_id.."\r\n".._ED.city_resource_invite_goto_info.id
                    NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, nil, response1Callback, false, nil)
                else
                    local info = _ED.city_resource_hold_resource_infos[1]
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("map_rattling_window_open", 0, {info.city_id, info.mould_id, 1})
                        end
                    end
                    protocol_command.city_resource_hold_get_resource_users.param_list = info.city_id.."\r\n"..info.id
                    NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, nil, responseCallback, false, nil)
                    -- state_machine.excute("map_build_infor_window_open",0,{zstring.tonumber(cityId)})
                end
                state_machine.excute("national_city_world_big_map_window_close",0,"")
            end
        end
        local cityId = params._datas.city_id
        local resourceCityInfo = _ED.city_map_info["" .. cityId]
        if resourceCityInfo ~= nil then
            terminal._city_id = cityId
            protocol_command.city_resource_hold_get_city_resource.param_list = cityId
            NetworkManager:register(protocol_command.city_resource_hold_get_city_resource.code, nil, nil, nil, nil, responseCallback, false, nil)
        elseif _ED.union_stronghold_info_list ~= nil then
            -- if tonumber(_ED.union_fight_city_state) == 0 then
                -- TipDlg.drawTextDailog(tipStringInfo_union_str[102])
                -- return
            -- end
            if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                or tonumber(_ED.union.union_info.union_grade) < dms.int(dms["union_config"], 30, union_config.param) 
                then
                TipDlg.drawTextDailog(tipStringInfo_union_str[81])
                return
            end
            local mainCityInfo = _ED.union_stronghold_info_list[""..cityId]
            if mainCityInfo ~= nil then
                local function responseCallback1( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_fighting_main_open", 0, mainCityInfo)
                        state_machine.excute("national_city_world_big_map_window_close",0,"")
                    end
                end
                if tonumber(_ED.union_fight_city_state) == 3 then
                    protocol_command.union_stronghold_init.param_list = _ED.union.union_info.union_id.."\r\n"..cityId
                    NetworkManager:register(protocol_command.union_stronghold_init.code, nil, nil, nil, nil, responseCallback1, false, nil)
                end
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
} 

state_machine.add(national_city_world_big_map_window_open_terminal)
state_machine.add(national_city_world_big_map_window_close_terminal)
state_machine.add(national_city_world_big_map_button_report_terminal)
state_machine.init()

function NationalCityWorldBigMap:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.city_id = nil
	
	app.load("client.red_alert.big_map.MapBuildInfor")
    app.load("client.red_alert.big_map.MapRattling")
    app.load("client.red_alert.union.unionFighting.UnionFightingBuildInfo")
	
    -- Initialize national_war_build_button state machine.
    local function init_national_war_build_button_terminal()

        -- 前往
        local national_city_world_big_map_move_pos_terminal = {
            _name = "national_city_world_big_map_move_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("====前往===点击的城池",instance.city_id)
				if zstring.tonumber(_ED.city_world_map_id) == zstring.tonumber(self.city_id) then
		            if _ED.union_stronghold_info_list ~= nil then
                        local mainCityInfo = _ED.union_stronghold_info_list[""..self.city_id]
                        if mainCityInfo ~= nil then
                            local function responseCallback( response )
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    state_machine.excute("union_fighting_main_open", 0, mainCityInfo)
                                    state_machine.excute("national_city_world_big_map_window_close",0,"")
                                end
                            end
                            if tonumber(_ED.union_fight_city_state) == 3 then
                                protocol_command.union_stronghold_init.param_list = _ED.union.union_info.union_id.."\r\n"..self.city_id
                                NetworkManager:register(protocol_command.union_stronghold_init.code, nil, nil, nil, nil, responseCallback, false, nil)
                            end
                        end
                    end
				else
                    if _ED.union_fight_city_user_info ~= nil and 
                        _ED.union_fight_city_user_info.is_death == "1" then
                        TipDlg.drawTextDailog(tipStringInfo_union_str[92])
                        return
                    end
                    -- if _ED._inUnionFightScene == true then
                    --     TipDlg.drawTextDailog(tipStringInfo_union_str[93])
                    --     return 
                    -- end
					local function responsemapmoveto(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("national_war_map_move_my_pos",0,{zstring.tonumber(instance.city_id)})
							state_machine.excute("national_city_world_big_map_window_close",0,"")
						end
					end
					protocol_command.city_resource_hold_move_to_city.param_list = zstring.tonumber(instance.city_id)
					NetworkManager:register(protocol_command.city_resource_hold_move_to_city.code, nil, nil, nil, nil, responsemapmoveto, false, nil)  
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        local national_city_world_big_map_capture_terminal = {
            _name = "national_city_world_big_map_capture",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    or tonumber(_ED.union.union_info.union_grade) < dms.int(dms["union_config"], 30, union_config.param) 
                    then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[81])
                    return true
                end

                local function responseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("national_city_world_big_map_window_close",0,"")
                        state_machine.excute("union_fighting_build_info_open", 0, {response.node})
                    end
                end
                protocol_command.union_stronghold_battle_details.param_list = _ED.union.union_info.union_id.."\r\n"..zstring.tonumber(instance.city_id)
                NetworkManager:register(protocol_command.union_stronghold_battle_details.code, nil, nil, nil, instance.city_id, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(national_city_world_big_map_move_pos_terminal)  
        state_machine.add(national_city_world_big_map_capture_terminal)
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_build_button_terminal()
end


function NationalCityWorldBigMap:onUpdateDraw()
    local root = self.roots[1] 
	local Panel_grade = ccui.Helper:seekWidgetByName(root,"Panel_grade")
	local mould_show = nil
	mould_show = {}
	
	for i, v in pairs(_ED.city_map_info) do
		if self.city_id == zstring.tonumber(v.city_world_map_id) then
            Panel_grade:setBackGroundImage(string.format(config_res.images.ui.play.big_map.build_grade, zstring.tonumber(v.city_world_map_quality)+1))
			local mouldData = zstring.split(v.city_Resource_points_mould,",")
			if v.city_Resource_points_mould ~= "" then
				local index_s = 0
				for j,r in pairs(mouldData) do
					index_s = index_s +1
					local mouldinfo = dms.int(dms["city_resource_mould"],zstring.tonumber(r),city_resource_mould.quality)
					if index_s<=3 then
						mould_show[index_s] = r
					else
						for z, w in pairs(mould_show) do
							if mouldinfo > dms.int(dms["city_resource_mould"],zstring.tonumber(w),city_resource_mould.quality) then
								w = r
								break
							end
						end
					end
				end	
			end
			if #mould_show > 0 then
				for t = 1, #mould_show do
					local resourceType = dms.int(dms["city_resource_mould"],zstring.tonumber(mould_show[t]),city_resource_mould.resourceType)
					if resourceType == 33 then
						ccui.Helper:seekWidgetByName(root,"Panel_resources_"..t):setBackGroundImage(config_res.images.ui.props.props_4019)
					elseif resourceType == 1 then
                        ccui.Helper:seekWidgetByName(root,"Panel_resources_"..t):setBackGroundImage(config_res.images.ui.props.props_4002)
                    elseif resourceType == 2 then
						ccui.Helper:seekWidgetByName(root,"Panel_resources_"..t):setBackGroundImage(config_res.images.ui.props.props_4001)
					else
						ccui.Helper:seekWidgetByName(root,"Panel_resources_"..t):setBackGroundImage(config_res.images.ui.props.props_4008)
					end
				end
			end
			return
		end
	end
end

function NationalCityWorldBigMap:onInit( )
    local csbItem = csb.createNode(config_csb.cells.big_map.big_map_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())

    --关闭 Panel_national_truce_bilud_button
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "national_city_world_big_map_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 前往
    local Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "national_city_world_big_map_move_pos",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    -- 详情
    local Button_infor = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor"), nil, 
    {
        terminal_name = "national_city_world_big_map_button_report",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        city_id = self.city_id
    }, nil, 0)

    local Button_occupy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_occupy"), nil, 
    {
        terminal_name = "national_city_world_big_map_capture",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        city_id = self.city_id
    }, nil, 0)

    -- 进入
    local Button_in = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_in"), nil, 
    {
        terminal_name = "national_city_world_big_map_button_report",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        city_id = self.city_id
    }, nil, 0)
    if nil ~= Button_infor then
        local cityInfo = _ED.city_map_info["" .. self.city_id]
        Button_occupy:setVisible(false)
        if nil ~= cityInfo then
            Button_infor:setVisible(true)
            if zstring.tonumber(self.city_id) == zstring.tonumber(_ED.city_world_map_id_backup) then
                Button_go:setVisible(false)
                Button_infor:setVisible(false)
                Button_in:setVisible(true)
            end
            if cityInfo.city_Resource_points ~= "-1" and #cityInfo.city_Resource_points > 0 then
            else
                Button_infor:setVisible(false)
            end
        else
            local mainCityInfo = nil
            if _ED.union_stronghold_info_list ~= nil then
                mainCityInfo = _ED.union_stronghold_info_list[""..self.city_id]
            end
            if mainCityInfo ~= nil then
                Button_occupy:setVisible(true)
                if zstring.tonumber(_ED.city_world_map_id_backup) == zstring.tonumber(self.city_id) then
                    Button_go:setVisible(false)
                    Button_in:setVisible(true)
                end
            end
        end
    end
    -- self:onUpdateDraw() 
end

function NationalCityWorldBigMap:init(params)
    self._rootWindows = params[1]
    self.city_id = tonumber(params[2])
    self.pos = params[3]
    self:onInit()
    self:setPosition(self.pos)
    self:setAnchorPoint(cc.p(0.5, 0.5)) 
    return self
end

function NationalCityWorldBigMap:onExit()
    state_machine.remove("national_city_world_big_map_move_pos")    
end
