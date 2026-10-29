-- The table stops at a lower level than the account cap: use the highest
-- level it has (NinjaAscension accounts go up to level 200).
function nrArtifactLevel()
    local grade = tonumber(_ED.user_info.user_grade) or 1
    if not nrArtifactMaxLevel then
        nrArtifactMaxLevel = 1
        for i = 1, #dms["artifact_param"] do
            local lv = dms.int(dms["artifact_param"], i, artifact_param.user_level)
            if lv and lv > nrArtifactMaxLevel then nrArtifactMaxLevel = lv end
        end
    end
    return math.min(grade, nrArtifactMaxLevel)
end

-----------------------------

SmCultivateArtifactInfo = class("SmCultivateArtifactInfoClass", Window)

local sm_cultivate_artifact_info_open_terminal = {
	_name = "sm_cultivate_artifact_info_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateArtifactInfoClass") == nil then
			fwin:open(SmCultivateArtifactInfo:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_artifact_info_open_terminal)
state_machine.init()

function SmCultivateArtifactInfo:ctor()
	self.super:ctor()
	self.roots = {}

    self._chooseCellIndex = 0
    self._chooseIndex = 0

    local function init_sm_cultivate_artifact_info_terminal()
		local sm_cultivate_artifact_info_update_choose_cell_index_terminal = {
            _name = "sm_cultivate_artifact_info_update_choose_cell_index",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._chooseCellIndex = params[1]
                    instance._chooseIndex = 1
                    instance:updateChooseState()
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_choose_terminal = {
            _name = "sm_cultivate_artifact_info_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._chooseIndex == params._datas.index then
                    return
                end
                instance._chooseIndex = params._datas.index
                instance:updateChooseState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_yijianpeiyang_terminal = {
            _name = "sm_cultivate_artifact_info_yijianpeiyang",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 一键培养，如果次数不足，弹出提示
                local maxNum = instance:countMaxNum()
                if maxNum < 1 then
                    TipDlg.drawTextDailog(_string_piece_info[85])
                    return
                end

                -- 弹出界面
                state_machine.excute("sm_cultivate_artifact_confirm_train_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_reqeust_terminal = {
            _name = "sm_cultivate_artifact_info_reqeust",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local times = params._datas.times
                if times == 10 then
                    local count = zstring.tonumber(getPropAllCountByMouldId(242))
                    if math.floor(count / 5) >= 1 and math.floor(count / 5) < 10 then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[295], math.floor(count / 5)))
                    end
                end
                state_machine.lock("sm_cultivate_artifact_info_reqeust")
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_cultivate_artifact_open_result", 0, true)
                            response.node:updateButtonState(true)
                            response.node:showAddAttr()
                        end
                        state_machine.excute("notification_center_update",0,"push_notification_cultivate_artifact")
                        state_machine.excute("notification_center_update",0,"push_notification_home_cultivate")
                    end
                    state_machine.unlock("sm_cultivate_artifact_info_reqeust")
                end
                local id = dms.string(dms["artifact_mould"], instance._chooseCellIndex, artifact_mould.id)
                protocol_command.artifact_culture.param_list = id.."\r\n"..(instance._chooseIndex - 1).."\r\n"..times
                NetworkManager:register(protocol_command.artifact_culture.code, nil, nil, nil, instance, responseCallBack, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_save_terminal = {
            _name = "sm_cultivate_artifact_info_save",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateButtonState(false)
                            state_machine.excute("sm_cultivate_artifact_open_result", 0, false)
                            response.node:onUpdateDraw()
                        end
                        smFightingChange()
                    end
                end
                local chooseState = "1"
                if table.nums(_ED.user_artifact_culture_info) > 1 then
                    chooseState = state_machine.excute("sm_cultivate_artifact_choose_get_choose_info", 0, nil)
                end
                if chooseState ~= nil then
                    if chooseState == "" then
                        state_machine.excute("sm_cultivate_artifact_info_cancel", 0, nil)
                    else
                        local id = dms.string(dms["artifact_mould"], instance._chooseCellIndex, artifact_mould.id)
                        protocol_command.artifact_confirm.param_list = id.."\r\n0\r\n"..chooseState
                        NetworkManager:register(protocol_command.artifact_confirm.code, nil, nil, nil, instance, responseCallBack, false, nil)  
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_cancel_terminal = {
            _name = "sm_cultivate_artifact_info_cancel",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateButtonState(false)
                            response.node:showAddAttr(false)
                            response.node:onUpdateDraw()
                            state_machine.excute("sm_cultivate_artifact_open_result", 0, false)
                        end
                    end
                end
                local id = dms.string(dms["artifact_mould"], instance._chooseCellIndex, artifact_mould.id)
                protocol_command.artifact_confirm.param_list = id.."\r\n-1\r\n1"
                NetworkManager:register(protocol_command.artifact_confirm.code, nil, nil, nil, instance, responseCallBack, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_reqeust_open_state_terminal = {
            _name = "sm_cultivate_artifact_info_reqeust_open_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            TipDlg.drawTextDailog(_new_interface_text[286])
                            state_machine.excute("sm_cultivate_artifact_update_info", 0, nil)
                        end
                    end
                end
                local id = dms.string(dms["artifact_mould"], instance._chooseCellIndex, artifact_mould.id)
                protocol_command.artifact_unlock.param_list = id
                NetworkManager:register(protocol_command.artifact_unlock.code, nil, nil, nil, instance, responseCallBack, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_update_add_attr_info_terminal = {
            _name = "sm_cultivate_artifact_info_update_add_attr_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:showAddAttr()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_info_count_max_num_terminal = {
            _name = "sm_cultivate_artifact_info_count_max_num",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    return instance:countMaxNum()
                end
                return nil
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_artifact_info_update_choose_cell_index_terminal)
        state_machine.add(sm_cultivate_artifact_info_choose_terminal)
        state_machine.add(sm_cultivate_artifact_info_yijianpeiyang_terminal)
        state_machine.add(sm_cultivate_artifact_info_reqeust_terminal)
        state_machine.add(sm_cultivate_artifact_info_save_terminal)
        state_machine.add(sm_cultivate_artifact_info_cancel_terminal)
        state_machine.add(sm_cultivate_artifact_info_reqeust_open_state_terminal)
        state_machine.add(sm_cultivate_artifact_info_update_add_attr_info_terminal)
        state_machine.add(sm_cultivate_artifact_info_count_max_num_terminal)
        state_machine.init()
    end
    init_sm_cultivate_artifact_info_terminal()
end

function SmCultivateArtifactInfo:updateChooseState( ... )
    local root = self.roots[1]
    for i=1,3 do
        local Image_hook = ccui.Helper:seekWidgetByName(root, "Image_hook_"..i)
        if i == self._chooseIndex then
            Image_hook:setVisible(true)
        else
            Image_hook:setVisible(false)
        end
    end
    local Text_sh_xh = ccui.Helper:seekWidgetByName(root, "Text_sh_xh")
    local Image_jb_icon = ccui.Helper:seekWidgetByName(root, "Image_jb_icon")
    local Text_jb_xh = ccui.Helper:seekWidgetByName(root, "Text_jb_xh")
    local Image_zs_icon = ccui.Helper:seekWidgetByName(root, "Image_zs_icon")
    local Text_zs_xh = ccui.Helper:seekWidgetByName(root, "Text_zs_xh")
    Text_sh_xh:setString("")
    Text_jb_xh:setString("")
    Text_zs_xh:setString("")
    Image_jb_icon:setVisible(false)
    Image_zs_icon:setVisible(false)
    local costInfo = zstring.split(dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.primary_consume + self._chooseIndex - 1), "|")
    for k,v in pairs(costInfo) do
        v = zstring.split(v, ",")
        if tonumber(v[1]) == 6 then
            Text_sh_xh:setString(v[3])
            if tonumber(v[3]) > zstring.tonumber(getPropAllCountByMouldId(242)) then
                Text_sh_xh:setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
            else
                Text_sh_xh:setColor(cc.c3b(tipStringInfo_quality_color_Type[1][1],tipStringInfo_quality_color_Type[1][2],tipStringInfo_quality_color_Type[1][3]))
            end
        elseif tonumber(v[1]) == 1 then
            Text_jb_xh:setString(v[3])
            Image_jb_icon:setVisible(true)
            if tonumber(v[3]) > zstring.tonumber(_ED.user_info.user_silver) then
                Text_jb_xh:setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
            else
                Text_jb_xh:setColor(cc.c3b(tipStringInfo_quality_color_Type[1][1],tipStringInfo_quality_color_Type[1][2],tipStringInfo_quality_color_Type[1][3]))
            end
        elseif tonumber(v[1]) == 2 then
            Text_zs_xh:setString(v[3])
            Image_zs_icon:setVisible(true)
            if tonumber(v[3]) > zstring.tonumber(_ED.user_info.user_gold) then
                Text_zs_xh:setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
            else
                Text_zs_xh:setColor(cc.c3b(tipStringInfo_quality_color_Type[1][1],tipStringInfo_quality_color_Type[1][2],tipStringInfo_quality_color_Type[1][3]))
            end
        end
    end
end

function SmCultivateArtifactInfo:countMaxNum()
    local costInfo = zstring.split(dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.primary_consume + self._chooseIndex - 1), "|")

    local maxCount = -1
    for i,v in ipairs(costInfo) do
        local lstDataCost = zstring.split(v, ",", zstring.tonumber)
        local type = lstDataCost[1]
        local typeID = lstDataCost[2]
        local value = lstDataCost[3]
        if type == 6 then
            local valueUser = zstring.tonumber(getPropAllCountByMouldId(typeID))
            local count = math.floor(valueUser/value)
            if maxCount == -1 or maxCount > count then
                maxCount = count
            end
        elseif type == 1 then
            local valueUser = zstring.tonumber(_ED.user_info.user_silver)
            local count = math.floor(valueUser/value)
            if maxCount == -1 or maxCount > count then
                maxCount = count
            end
        elseif type == 2 then
            local valueUser = zstring.tonumber(_ED.user_info.user_gold)
            local count = math.floor(valueUser/value)
            if maxCount == -1 or maxCount > count then
                maxCount = count
            end
        end
    end

    return maxCount, costInfo
end

function SmCultivateArtifactInfo:showAddAttr(  )
    local root = self.roots[1]
    local chooseState = nil
    if table.nums(_ED.user_artifact_culture_info) > 1 then
        chooseState = state_machine.excute("sm_cultivate_artifact_choose_get_choose_info", 0, nil)
        chooseState = zstring.split(chooseState, ",")
    end
    local id = dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.id)
    local addAttr = {}
    for k,v in pairs(_ED.user_artifact_culture_info) do
        local isNeedSave = false
        if chooseState ~= nil then
            for k1,v1 in pairs(chooseState) do
                if tonumber(v1) == tonumber(k) then
                    isNeedSave = true
                    break
                end
            end
        else
            isNeedSave = true
        end
        if isNeedSave == true then
            for k1,v1 in pairs(v) do
                addAttr[""..v1.key] = zstring.tonumber(addAttr[""..v1.key]) + tonumber(v1.value)
            end
        end
    end
    local function sortFun( a, b )
        return tonumber(a.key) < tonumber(b.key)
    end
    local result = _ED.user_artifact_attributes[""..id]
    table.sort(result, sortFun)

    local upper_limit_library = zstring.split(dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.upper_limit_library), "|")
    for k,v in pairs(result) do
        -- local LoadingBar_sx = ccui.Helper:seekWidgetByName(root, "LoadingBar_sx_"..k)
        -- local Text_sx = ccui.Helper:seekWidgetByName(root, "Text_sx_"..k)
        -- local Text_sx_n = ccui.Helper:seekWidgetByName(root, "Text_sx_n_"..k)
        local Text_sx_change = ccui.Helper:seekWidgetByName(root, "Text_sx_change_"..k)
        local group_id = 0
        for k1,v1 in pairs(upper_limit_library) do
            v1 = zstring.split(v1, ",")
            if tonumber(v1[1]) == tonumber(v.key) then
                group_id = tonumber(v1[2])
                break
            end
        end
        local info = dms.searchs(dms["artifact_param"], artifact_param.group_id, group_id, artifact_param.user_level, nrArtifactLevel())
        local max = tonumber(info[1][4])
        -- LoadingBar_sx:setPercent(tonumber(v.value) * 100 / tonumber(max))
        -- Text_sx_n:setString(v.value.."/"..max)
        Text_sx_change:setString("")
        -- Text_sx:setString(skill_attributes_text_tips[tonumber(v.key) + 1])
        if zstring.tonumber(addAttr[""..v.key]) ~= 0 then
            if zstring.tonumber(addAttr[""..v.key]) >= 0 then
                if tonumber(v.value) >= max then
                    Text_sx_change:setString("MAX")
                else
                    if tonumber(v.key) + 1 >= 5 then
                        Text_sx_change:setString("+"..addAttr[""..v.key].."%")
                    else
                        Text_sx_change:setString("+"..addAttr[""..v.key])
                    end
                end
                Text_sx_change:setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1],tipStringInfo_quality_color_Type[2][2],tipStringInfo_quality_color_Type[2][3]))
            else
                if tonumber(v.key) + 1 >= 5 then
                    Text_sx_change:setString(""..addAttr[""..v.key].."%")
                else
                    Text_sx_change:setString(""..addAttr[""..v.key])
                end
                Text_sx_change:setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
            end
        end
    end
end

function SmCultivateArtifactInfo:onUpdateDraw()
    local root = self.roots[1]
    local id = dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.id)
    local upper_limit_library = zstring.split(dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.upper_limit_library), "|")
    local function sortFun( a, b )
        return tonumber(a.key) < tonumber(b.key)
    end
    local result = _ED.user_artifact_attributes[""..id]
    table.sort(result, sortFun)
    for k,v in pairs(result) do
        local LoadingBar_sx = ccui.Helper:seekWidgetByName(root, "LoadingBar_sx_"..k)
        local Text_sx = ccui.Helper:seekWidgetByName(root, "Text_sx_"..k)
        local Text_sx_n = ccui.Helper:seekWidgetByName(root, "Text_sx_n_"..k)
        local Text_sx_change = ccui.Helper:seekWidgetByName(root, "Text_sx_change_"..k)
        local group_id = 0
        for k1,v1 in pairs(upper_limit_library) do
            v1 = zstring.split(v1, ",")
            if tonumber(v1[1]) == tonumber(v.key) then
                group_id = tonumber(v1[2])
                break
            end
        end
        local info = dms.searchs(dms["artifact_param"], artifact_param.group_id, group_id, artifact_param.user_level, nrArtifactLevel())
        local max = tonumber(info[1][4])
        LoadingBar_sx:setPercent(tonumber(v.value) * 100 / tonumber(max))
        if tonumber(v.key) + 1 >= 5 then
            Text_sx_n:setString(v.value.."%/"..max.."%")
        else
            Text_sx_n:setString(v.value.."/"..max)
        end
        Text_sx_change:setString("")
        Text_sx:setString(skill_attributes_text_tips[tonumber(v.key) + 1])
    end
end

function SmCultivateArtifactInfo:updateButtonState( isShowSave )
    local root = self.roots[1]
    local Button_save = ccui.Helper:seekWidgetByName(root,"Button_save")
    local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")
    local Button_py_1 = ccui.Helper:seekWidgetByName(root,"Button_py_1")
    local Button_py_10 = ccui.Helper:seekWidgetByName(root,"Button_py_10")
    local Button_py_1_0 = ccui.Helper:seekWidgetByName(root,"Button_py_1_0")
    local Button_py_10_0 = ccui.Helper:seekWidgetByName(root,"Button_py_10_0")
    local Button_py_100 = ccui.Helper:seekWidgetByName(root,"Button_py_100")


    Button_save:setVisible(false)
    Button_cancel:setVisible(false)
    Button_py_1:setVisible(false)
    Button_py_10:setVisible(false)
    if Button_py_1_0 then
        Button_py_1_0:setVisible(false)
        Button_py_10_0:setVisible(false)
        Button_py_100:setVisible(false)
    end
    if isShowSave == true then
        Button_save:setVisible(true)
        local isMustSave = true
        if table.nums(_ED.user_artifact_culture_info) == 1 then
            for k,v in pairs(_ED.user_artifact_culture_info) do
                for k1,v1 in pairs(v) do
                    if tonumber(v1.value) < 0 then
                        isMustSave = false
                    end
                end
            end
        else
            isMustSave = false
        end
        if isMustSave == true then
            Button_cancel:setTouchEnabled(false)
            Button_cancel:setBright(false)
        else
            Button_cancel:setTouchEnabled(true)
            Button_cancel:setBright(true)
            Button_cancel:setVisible(true)
        end
        Button_cancel:setVisible(true)
    else
        local level_limit = dms.int(dms["fun_open_condition"], 205, fun_open_condition.level)
        if level_limit == nil then
            level_limit = self.DEFAULT_LEVEL_LIMIT
        end

        if tonumber(_ED.user_info.user_grade) >= level_limit then
            if Button_py_1_0 then
                Button_py_1_0:setVisible(true)
                Button_py_10_0:setVisible(true)
                Button_py_100:setVisible(true)
            end
        else
            Button_py_1:setVisible(true)
            Button_py_10:setVisible(true)
        end
    end
end

function SmCultivateArtifactInfo:updateLockInfo( ... )
    local root = self.roots[1]
    local achieve_ids = zstring.split(dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.achieve_id), ",")
    for i=1,5 do
        local Panel_jstj = ccui.Helper:seekWidgetByName(root, "Panel_jstj_"..i)
        local Text_tj = ccui.Helper:seekWidgetByName(root, "Text_tj_"..i)
        local Text_jd = ccui.Helper:seekWidgetByName(root, "Text_jd_"..i)
        local Image_zs = ccui.Helper:seekWidgetByName(root, "Image_zs_"..i)
        local Image_dc = ccui.Helper:seekWidgetByName(root, "Image_dc_"..i)
        local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock_"..i)
        local achieve_id = achieve_ids[i]
        local descript = dms.string(dms["achieve"], achieve_id, achieve.descript)
        Text_tj:setString(descript)
        Text_jd:setString("")
        Image_zs:setVisible(false)
        Image_dc:setVisible(false)
        Image_lock:setVisible(false)
        local complete = tonumber(_ED.all_achieve and _ED.all_achieve[tonumber(achieve_id)]) or 0
        local max = dms.int(dms["achieve"], achieve_id, achieve.param2)
        local param1 = dms.int(dms["achieve"], achieve_id, achieve.param1)
        if param1 == 25 or param1 == 27 then
            max = dms.int(dms["achieve"], achieve_id, achieve.param3)
        elseif param1 == 35 then
            max = 1
        end
        if tonumber(complete) >= max then
            Image_zs:setVisible(true)
            Image_dc:setVisible(true)
            Text_jd:setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1],tipStringInfo_quality_color_Type[2][2],tipStringInfo_quality_color_Type[2][3]))
        else
            Text_jd:setString(complete.."/"..max)
            Image_lock:setVisible(true)
            Text_jd:setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
        end
    end
end

function SmCultivateArtifactInfo:onInit()
    local csbName = ""
    local id = dms.string(dms["artifact_mould"], self._chooseCellIndex, artifact_mould.id)
    local info = _ED.user_artifact_info[""..id]
    if tonumber(info.state) == 1 then
        csbName = "cultivate/cultivate_artifact_tab_2.csb"
    else
        csbName = "cultivate/cultivate_artifact_tab_2_lock.csb"
    end
    local csbItem = csb.createNode(csbName)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pyfs_"..i), nil, 
        {
            terminal_name = "sm_cultivate_artifact_info_choose", 
            terminal_state = 0, 
            touch_black = true,
            index = i,
        }, nil, 3)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_save"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_info_save", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_info_cancel", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_py_1"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_info_reqeust", 
        terminal_state = 0, 
        touch_black = true,
        times = 1,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_py_10"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_info_reqeust", 
        terminal_state = 0, 
        touch_black = true,
        times = 10,
    }, nil, 3)

    self.Button_py_1_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_py_1_0"), nil,
    {
        terminal_name = "sm_cultivate_artifact_info_reqeust",
        terminal_state = 0,
        isPressedActionEnabled = true,
        times = 1,
    }, nil, 0)

    self.Button_py_10_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_py_10_0"), nil,
    {
        terminal_name = "sm_cultivate_artifact_info_reqeust",
        terminal_state = 0,
        isPressedActionEnabled = true,
        times = 10,
    }, nil, 0)

    self.Button_py_100 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_py_100"), nil,
    {
        terminal_name = "sm_cultivate_artifact_info_yijianpeiyang",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    if tonumber(info.state) == 1 then
        self._chooseIndex = 1
        self:onUpdateDraw()
        self:updateChooseState()
        self:updateButtonState(false)
    else
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_save"), nil, 
        {
            terminal_name = "sm_cultivate_artifact_info_reqeust_open_state", 
            terminal_state = 0, 
            touch_black = true,
        }, nil, 3)
        self:updateLockInfo()
    end
end

function SmCultivateArtifactInfo:onEnterTransitionFinish()
end

function SmCultivateArtifactInfo:init(params)
    self.DEFAULT_LEVEL_LIMIT = 0

    self._rootWindows = params[1]
    self._chooseCellIndex = params[2]
    self:onInit()
    return self
end

function SmCultivateArtifactInfo:onExit()
    state_machine.remove("sm_cultivate_artifact_info_update_choose_cell_index")
    state_machine.remove("sm_cultivate_artifact_info_choose")
    state_machine.remove("sm_cultivate_artifact_info_yijianpeiyang")
    state_machine.remove("sm_cultivate_artifact_info_reqeust")
    state_machine.remove("sm_cultivate_artifact_info_save")
    state_machine.remove("sm_cultivate_artifact_info_cancel")
    state_machine.remove("sm_cultivate_artifact_info_reqeust_open_state")
    state_machine.remove("sm_cultivate_artifact_info_update_add_attr_info")
    state_machine.remove("sm_cultivate_artifact_info_count_max_num")
end
