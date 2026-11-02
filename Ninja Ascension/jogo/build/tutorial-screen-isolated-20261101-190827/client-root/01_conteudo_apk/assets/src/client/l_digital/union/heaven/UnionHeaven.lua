--------------------------------------------------------------------------------------------------------------
--  说明：封坛祭天主界面
--------------------------------------------------------------------------------------------------------------
UnionHeaven = class("UnionHeavenClass", Window)
UnionHeaven._mtype = 0
--打开界面
local union_heaven_open_terminal = {
    _name = "union_heaven_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionHeavenWindow = fwin:find("UnionHeavenClass")
        if unionHeavenWindow ~= nil and unionHeavenWindow:isVisible() == true then
            return true
        end
        UnionHeaven._mtype = params
        state_machine.lock("union_heaven_open", 0, "")
        fwin:open(UnionHeaven:createCell(), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_heaven_close_terminal = {
    _name = "union_heaven_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionHeaven:closeCell()
        state_machine.excute("union_refresh_info", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_heaven_open_terminal)
state_machine.add(union_heaven_close_terminal)
state_machine.init()

function UnionHeaven:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.lastChooseType = 0
    self.isFirstIn = false
    app.load("client.l_digital.cells.union.union_heaver_integral_chest")
    app.load("client.l_digital.cells.union.union_logo_icon_cell")
    self.tickTime = 6
    self.action1Type = 0
	
	 -- Initialize union heaven machine.
    local function init_union_heaven_terminal()
		
		-- 隐藏界面
        local union_heaven_hide_event_terminal = {
            _name = "union_heaven_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_heaven_show_event_terminal = {
            _name = "union_heaven_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_heaven_refresh_terminal = {
            _name = "union_heaven_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--查看帮助
		local union_heaven_look_help_info_terminal = {
            _name = "union_heaven_look_help_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.refinery.TreasureInfo")
                local cell = TreasureInfo:new()
                cell:init(6)
                fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--确认祭天
		local union_heaven_ensure_button_terminal = {
            _name = "union_heaven_ensure_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawLivenessRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots~=nil then
                            response.node:updateDraw()
                            response.node:updateNotice()
                            response.node:registerOnNoteUpdate(instance)
                        end
                    end
                end
                if tonumber(_ED.union.user_union_info.build_count) ~= 0 then
                    -- TipDlg.drawTextDailog(tipStringInfo_union_str[3])
                    return
                end
                protocol_command.union_build.param_list = ""..instance.lastChooseType
                NetworkManager:register(protocol_command.union_build.code, nil, nil, nil, instance, responseDrawLivenessRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--选择祭天神官
		local union_heaven_select_oracle_terminal = {
            _name = "union_heaven_select_oracle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.build_count) == 0 then
                    instance:updateChooseAction(params._datas.nType)
                else
                    TipDlg.drawTextDailog(tipStringInfo_union_str[41])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --公会等级经验捐献
        local union_heaven_union_level_exp_donation_terminal = {
            _name = "union_heaven_union_level_exp_donation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._page
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:updateDraw()
                            state_machine.excute("sm_union_research_institute_update_draw", 0, "")
                            state_machine.excute("sm_union_institute_donate_update_draw", 0, "")
                        end
                    end
                end
                local union_id = _ED.union.union_info.union_id
                local donate_type = page - 1
                protocol_command.union_donate.param_list = union_id.."\r\n"..UnionHeaven._mtype.."\r\n"..donate_type.."\r\n-1"
                NetworkManager:register(protocol_command.union_donate.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_heaven_hide_event_terminal)
		state_machine.add(union_heaven_show_event_terminal)
		state_machine.add(union_heaven_refresh_terminal)
		state_machine.add(union_heaven_look_help_info_terminal)
		state_machine.add(union_heaven_ensure_button_terminal)
        state_machine.add(union_heaven_select_oracle_terminal)
		state_machine.add(union_heaven_union_level_exp_donation_terminal)
        state_machine.init()
    end
    
    -- call func init union heaven machine.
    init_union_heaven_terminal()
end

function UnionHeaven:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionHeaven:onUpdate( dt )

end

function UnionHeaven:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionHeaven:updateNotice( ... )
    local root = self.roots[1]
    local panel = ccui.Helper:seekWidgetByName(root, "Panel_legion_animation")
    panel:setVisible(true)
    local armature = nil
    if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        armature = panel:getChildByName("ArmatureNode_end")
    else
        armature = panel:getChildByName("ArmatureNode_1")
    end
    local function changeActionCallback(armatureBack)
    end
    ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"):setVisible(false)
    armature._invoke = changeActionCallback
    armature:setVisible(true)
    csb.animationChangeToAction(armature, 0, 0, false)
end

function UnionHeaven:autoUpdateChooseAction( nType , lastType)
end

function UnionHeaven:updateChooseAction( nType )

    local action = self.actions[1]
    local root = self.roots[1]
    if tonumber(nType) == 3 and tonumber(_ED.vip_grade) < 2 then
        TipDlg.drawTextDailog(tipStringInfo_union_str[45])
        return
    end
    ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_primaryfitment_affirm"):setSelected(false)
    ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_intermediate_affirm"):setSelected(false)
    ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_advanced_affirm"):setSelected(false)
    if self.lastChooseType == 0 and self.lastChooseType ~= nType then
        
    else
        ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"):setVisible(true)
        if tonumber(nType) == 1 then
            ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_primaryfitment_affirm"):setSelected(true)
        elseif tonumber(nType) == 2 then
            ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_intermediate_affirm"):setSelected(true)
        elseif tonumber(nType) == 3 then
            ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_advanced_affirm"):setSelected(true)
        end
    end
    local lastType = self.lastChooseType
    self.lastChooseType = nType
    self:autoUpdateChooseAction(nType,lastType)
end

function UnionHeaven:updateChatPopAction( ... )
end
function UnionHeaven:cutStringMain(str, height, fontSize, width, fontName)
    local mRoot = ccui.RichText:create()
    fontSize = fontSize or 10

    local l = string.len(str)
    mRoot:ignoreContentAdaptWithSize(false)
    local count = 0
    while (l > 0) do
        local f,e = string.find(str, "%%%C-%%")
        if f == nil or e == nil then
            local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_zhuangxiu_color[1][1], tipStringInfo_union_zhuangxiu_color[1][2], tipStringInfo_union_zhuangxiu_color[1][3]), 255, str, fontName, fontSize)
            mRoot:pushBackElement(re)
            count = count + zstring.utfstrlen(str)
            break
        end
        if f > 1 then
            local strsub = string.sub(str, 1, f-1)
            count = count + zstring.utfstrlen(strsub)
            local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_zhuangxiu_color[1][1], tipStringInfo_union_zhuangxiu_color[1][2], tipStringInfo_union_zhuangxiu_color[1][3]), 255, strsub, fontName, fontSize)
            mRoot:pushBackElement(re)
        end
        local name = string.sub(str, f+1, e-1)
        local f1, e1 = string.find(name, "%d+")
        if name == nil or f1 == nil or e1 == nil then
            mRoot:removeAllChildrenWithCleanup(true)
            break
        end
        local quality = string.sub(name, f1, e1)
        local color = tonumber(quality)
        name = string.sub(name, e1+2, string.len(name))
        count = count + zstring.utfstrlen(name)
        if color == nil or color <= 0 or color > 11 then
            mRoot:removeAllChildrenWithCleanup(true)
            break
        end
        local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_zhuangxiu_color[color][1],tipStringInfo_union_zhuangxiu_color[color][2],tipStringInfo_union_zhuangxiu_color[color][3]), 255, name, fontName, fontSize)
        mRoot:pushBackElement(re1)
        str = string.sub(str, e+1, l)
        l = string.len(str)
    end
    if width ~= nil and width > 0 then
        mRoot:setContentSize(cc.size(width-15, height+20))
    else
        mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
    end
    
    return mRoot, count
end

function UnionHeaven:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end

    local science_info = zstring.split(_ED.union_science_info,"|")
    local hall_technology = zstring.split(science_info[tonumber(UnionHeaven._mtype)],",")
    local science_name = dms.string(dms["union_science_mould"], UnionHeaven._mtype, union_science_mould.name)
    --名称
    local Text_27 = ccui.Helper:seekWidgetByName(root, "Text_27")
    Text_27:setString(science_name)

    --等级
    local Text_legion_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_lv")
    Text_legion_lv:setString("Lv."..hall_technology[1])
    --经验
    local Text_loading_numeral = ccui.Helper:seekWidgetByName(root, "Text_loading_numeral")
    local LoadingBar_legion_lv = ccui.Helper:seekWidgetByName(root, "LoadingBar_legion_lv")

    local maxMember = 0
    if tonumber(UnionHeaven._mtype) == 1 then
        maxMember = dms.int(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)
    else
        --通过科技类型找到科技模板的库组
        local parameter_group = dms.int(dms["union_science_mould"], UnionHeaven._mtype, union_science_mould.parameter_group)
        --通过参数库组找到对应de经验参数表数据
        local expMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
        local expData = nil
        for i, v in pairs(expMould) do
            if tonumber(hall_technology[1]) == tonumber(v[3]) then
                expData = v
                break
            end
        end
        maxMember = tonumber(expData[4])
    end
    Text_loading_numeral:setString(hall_technology[2].."/"..maxMember)
    local persent = math.floor(tonumber(hall_technology[2])/maxMember*100)
    LoadingBar_legion_lv:setPercent(persent)
    if maxMember == -1 then
        Text_loading_numeral:setString("")
        LoadingBar_legion_lv:setPercent(100)
   end

    --图标
    local Panel_23 = ccui.Helper:seekWidgetByName(root, "Panel_23")
    local cell = CnionLogoIconCell:createCell():init(_ED.union.union_info.union_kuang, _ED.union.union_info.union_icon,_ED.union.union_info.union_grade)
    Panel_23:removeAllChildren(true)
    Panel_23:addChild(cell)

    local vipLook = dms.int(dms["union_config"], 35, union_config.param)
    if vipLook ~= nil then
        if tonumber(_ED.vip_grade) < vipLook then
            ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary"):setPositionX(ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary")._x+110)
            ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate"):setPositionX(ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate")._x+110)
            ccui.Helper:seekWidgetByName(root, "Panel_fitment_advanced"):setVisible(false)
        else
            ccui.Helper:seekWidgetByName(root, "Panel_fitment_advanced"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary"):setPositionX(ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary")._x)
            ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate"):setPositionX(ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate")._x)
        end
    end
    --今日捐献次数
    local Text_legion_jxcs = ccui.Helper:seekWidgetByName(root, "Text_legion_jxcs")
    local all = zstring.split(science_info[1],",")
    local maxNumber = dms.int(dms["union_config"], 18, union_config.param)
    Text_legion_jxcs:setString((maxNumber - tonumber(all[4])).."/"..maxNumber)

    if maxNumber - tonumber(all[4]) <= 0 then
        ccui.Helper:seekWidgetByName(root,"Button_jx_1"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_jx_2"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_jx_3"):setBright(false)
        Text_legion_jxcs:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        ccui.Helper:seekWidgetByName(root,"Button_jx_1"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_jx_2"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_jx_3"):setBright(true)

        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then

        else
            Text_legion_jxcs:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end
    end

end

function UnionHeaven:onInit()
	self:updateDraw()
end

function UnionHeaven:onEnterTransitionFinish()
    local csbUnionHeavenCell = csb.createNode("legion/legion_fitment.csb")
    local root = csbUnionHeavenCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionHeavenCell)

    if ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary")._x == nil then
        ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary")._x = ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary"):getPositionX()
    end
    ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary"):setPositionX(ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary")._x)

    if ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate")._x == nil then
        ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate")._x = ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate"):getPositionX()
    end
    ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate"):setPositionX(ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate")._x)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"),  nil, 
    {
        terminal_name = "union_heaven_look_help_info",
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rollback"),  nil, 
    {
        terminal_name = "union_heaven_close",
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary"):setTouchEnabled(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary"),  nil, 
    {
        terminal_name = "union_heaven_select_oracle",
        cell = self,
        nType = 1,
        terminal_state = 0
    }, 
    nil, 0)
    ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate"):setTouchEnabled(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate"),  nil, 
    {
        terminal_name = "union_heaven_select_oracle",
        cell = self,
        nType = 2,
        terminal_state = 0
    }, 
    nil, 0)
    ccui.Helper:seekWidgetByName(root, "Panel_fitment_advanced"):setTouchEnabled(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_fitment_advanced"),  nil, 
    {
        terminal_name = "union_heaven_select_oracle",
        cell = self,
        nType = 3,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"),  nil, 
    {
        terminal_name = "union_heaven_ensure_button",
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
      fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"),  nil, 
    {
        terminal_name = "union_heaven_look_help_info",
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    for i=1,3 do
        --捐献
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jx_"..i),  nil, 
        {
            terminal_name = "union_heaven_union_level_exp_donation",
            cell = self,
            terminal_state = 0,
            _page = i,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    self:init()
    -- if tonumber(_ED.union.user_union_info.build_count) == 0 then
    --     ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"):setVisible(false)
    --     self:updateChooseAction(1)
    -- else
    --     self.tickTime = 0
    --     ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"):setVisible(false)
    --     self:registerOnNoteUpdate(self)
    -- end
    state_machine.unlock("union_heaven_open", 0, "")
    self.isFirstIn = true
end

function UnionHeaven:init()
	self:onInit()
	return self
end

function UnionHeaven:onExit()
    self:unregisterOnNoteUpdate(self)
	state_machine.remove("union_heaven_hide_event")
	state_machine.remove("union_heaven_show_event")
	state_machine.remove("union_heaven_refresh")
	state_machine.remove("union_heaven_look_help_info")
	state_machine.remove("union_heaven_ensure_button")
	state_machine.remove("union_heaven_select_oracle")
end

function UnionHeaven:createCell( ... )
    local cell = UnionHeaven:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionHeaven:closeCell( ... )
    local unionHeavenWindow = fwin:find("UnionHeavenClass")
    if unionHeavenWindow == nil then
        return
    end
    fwin:close(unionHeavenWindow)
end