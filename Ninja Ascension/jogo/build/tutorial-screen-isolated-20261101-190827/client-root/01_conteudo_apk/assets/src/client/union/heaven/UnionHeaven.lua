--------------------------------------------------------------------------------------------------------------
--  说明：封坛祭天主界面
--------------------------------------------------------------------------------------------------------------
UnionHeaven = class("UnionHeavenClass", Window)

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
        state_machine.lock("union_heaven_open", 0, "")
        fwin:open(UnionHeaven:createCell(), fwin._view)
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
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.cells.union.union_heaver_integral_chest")
    else
        app.load("client.cells.union.union_heaver_integral_chest")
    end
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
		state_machine.add(union_heaven_hide_event_terminal)
		state_machine.add(union_heaven_show_event_terminal)
		state_machine.add(union_heaven_refresh_terminal)
		state_machine.add(union_heaven_look_help_info_terminal)
		state_machine.add(union_heaven_ensure_button_terminal)
		state_machine.add(union_heaven_select_oracle_terminal)
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
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        return
    end
    if tonumber(_ED.union.user_union_info.build_count) == 0 then
        return
    end
    self.tickTime = self.tickTime - dt
    if self.tickTime <= 0 then
        self.tickTime = 6
        local ntype = self:updateChatPopAction()
        if ntype ~= 0 then
            if self.action1Type ~= (ntype + 1) then
                self:autoUpdateChooseAction(ntype + 1)
            end
        end
    end
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
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
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
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        return
    end
    self.action1Type = nType
    local action = self.actions[1]
    if lastType ~= nil and lastType == 0 then
        action:play("advanced_build_cut", false)
    else
        if tonumber(nType) == 1 then
            action:play("primary_build_cut", false)
        elseif tonumber(nType) == 2 then
            action:play("intermediate_build_cut", false)
        elseif tonumber(nType) == 3 then
            action:play("advanced_build_cut", false)
        end
    end
end

function UnionHeaven:updateChooseAction( nType )
    -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    --     return
    -- end
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
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        return
    end
    local action = self.actions[2]
    -- action:play("qipao_donghua", false)
    local root = self.roots[2]
    local text = ccui.Helper:seekWidgetByName(root, "Text_legion_chat")
  
    if self.isFirstIn == true and tonumber(_ED.union.user_union_info.build_count) == 0 then
        self.isFirstIn = false
        text:removeAllChildren(true)
        text:setString(tipStringInfo_union_str[44])
        action:play("qipao_donghua", false)
        return 0
    else
        if self.lastChooseType == 1 then
            text:removeAllChildren(true)
            text:setString(tipStringInfo_union_str[42])
            action:play("qipao_donghua", false)
            return self.lastChooseType
        elseif self.lastChooseType == 2 then
            text:removeAllChildren(true)
            text:setString(tipStringInfo_union_str[43])
            action:play("qipao_donghua", false)
            return self.lastChooseType
        elseif self.lastChooseType == 3 then
            text:removeAllChildren(true)
            text:setString(tipStringInfo_union_str[44])
            action:play("qipao_donghua", false)
            return self.lastChooseType
        else
            if _ED.union.union_cache_message_info_list == nil or #_ED.union.union_cache_message_info_list == 0 then
                text:removeAllChildren(true)
                text:setString(tipStringInfo_union_str[48])
                action:play("qipao_donghua", false)
                return 0
            end
        end
    end
    
    local random = math.ceil(math.random(1, 5))
    if random > #_ED.union.union_cache_message_info_list then
        random = #_ED.union.union_cache_message_info_list
    end
    local info = _ED.union.union_cache_message_info_list[random]
	if info == nil then
		return 0
	end
    local info1 = ""
    local info2 = ""
    local info3 = ""
    local info4 = ""
    if info ~= nil and tonumber(info.ntype) == 0 or tonumber(info.ntype) == 1 or
        tonumber(info.ntype) == 2 then
        local typeName = tipStringInfo_union_str[tonumber(info.ntype) + 13]
        local configs = zstring.split(dms.string(dms["pirates_config"], 202, pirates_config.param), ",")
        local typeInfo = zstring.split(configs[tonumber(info.ntype) + 1], "|")
        info1 = "%|2|"..info.name.."%"
        if tonumber(info.ntype) == 0 then
            info2 = "%|4|"..typeName.."%"
        elseif tonumber(info.ntype) == 1 then
            info2 = "%|5|"..typeName.."%"
        elseif tonumber(info.ntype) == 2 then
            info2 = "%|6|"..typeName.."%"
        end
        -- info2 = "%|6|"..typeName.."%"
        info3 = "%|3|"..typeInfo[2].."%"
        info4 = "%|3|"..info.quality2.."%"
        local stringInfo = string.format(tipStringInfo_union_str[29], info1, info2, info3,info4)
        local fontSize = 24
        if verifySupportLanguage(_lua_release_language_en) == true then
            if __lua_project_id == __lua_project_warship_girl_b then
                fontSize = 18
            end
        end
        local _richText,l = self:cutStringMain(stringInfo,tonumber(text:getContentSize().height),24, tonumber(text:getContentSize().width))
        _richText:setAnchorPoint(cc.p(0, 1))
        _richText:setPosition(cc.p(text:getPositionX()-text:getContentSize().width - 40 , text:getPositionY()+text:getContentSize().height/2-10 ))
        text:removeAllChildren(true)
        text:setString("")
        text:addChild(_richText)
        -- local stringInfo = string.format(tipStringInfo_union_str[29], info.name, typeName, typeInfo[2], info.quality2)
        -- text:setString(stringInfo)
        action:play("qipao_donghua", false)
        return info.ntype
    end
    return 0
end
function UnionHeaven:cutStringMain(str, height, fontSize, width)
    local mRoot = ccui.RichText:create()
    fontSize = fontSize or 10
    -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    --  fontSize=18
    -- end
    local l = string.len(str)
    mRoot:ignoreContentAdaptWithSize(false)
    local count = 0
    while (l > 0) do
        local f,e = string.find(str, "%%%C-%%")
        if f == nil or e == nil then
            local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_zhuangxiu_color[1][1], tipStringInfo_union_zhuangxiu_color[1][2], tipStringInfo_union_zhuangxiu_color[1][3]), 255, str, "fonts/FZYiHei-M20S.ttf", fontSize)
            mRoot:pushBackElement(re)
            count = count + zstring.utfstrlen(str)
            break
        end
        if f > 1 then
            local strsub = string.sub(str, 1, f-1)
            count = count + zstring.utfstrlen(strsub)
            local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_zhuangxiu_color[1][1], tipStringInfo_union_zhuangxiu_color[1][2], tipStringInfo_union_zhuangxiu_color[1][3]), 255, strsub, "fonts/FZYiHei-M20S.ttf", fontSize)
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
        local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_zhuangxiu_color[color][1],tipStringInfo_union_zhuangxiu_color[color][2],tipStringInfo_union_zhuangxiu_color[color][3]), 255, name, "fonts/FZYiHei-M20S.ttf", fontSize)
        mRoot:pushBackElement(re1)
        str = string.sub(str, e+1, l)
        l = string.len(str)
    end
    if width ~= nil and width > 0 then
        mRoot:setContentSize(cc.size(width-15, height+20))
    else
        mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
    end
    
    -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    --  mRoot:setContentSize(cc.size(width-20, height+20))
    -- end
    return mRoot, count
end

function UnionHeaven:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end

    if tonumber(_ED.union.user_union_info.build_count) ~= 0 then
        self.lastChooseType = 0
        ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_primaryfitment_affirm"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_intermediate_affirm"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_advanced_affirm"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_primaryfitment_affirm"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_intermediate_affirm"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_fitment_advanced_affirm"):setVisible(true)
    end

    local gongx = ccui.Helper:seekWidgetByName(root, "Text_legion_lv")
    local unionname = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    local unionlv = ccui.Helper:seekWidgetByName(root, "Text_legion_contribution_numeral")
    local totalCon = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)
    ccui.Helper:seekWidgetByName(root, "LoadingBar_legion_lv"):setPercent(tonumber(_ED.union.union_info.union_contribution) * 100 /tonumber(totalCon))
    ccui.Helper:seekWidgetByName(root, "Text_loading_numeral"):setString(_ED.union.union_info.union_contribution.."/"..totalCon)
    gongx:setString(zstring.tonumber(_ED.union.union_info.union_grade))
    unionname:setString(_ED.union.union_info.union_name)
    unionlv:setString(_ED.union.user_union_info.rest_contribution)

    ccui.Helper:seekWidgetByName(root, "Text_the_same_day_numeral"):setString("".._ED.union.union_info.union_worship)
    local maxMember = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxMember)
    ccui.Helper:seekWidgetByName(root, "Text_the_same_day_people_numeral"):setString(_ED.union.union_info.union_member_num.."/"..maxMember)
    local maxProgress = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxProgress)
    ccui.Helper:seekWidgetByName(root, "LoadingBar_fitment_award"):setPercent(tonumber(_ED.union.union_info.union_worship) * 100/tonumber(maxProgress))

    local rewardStates = zstring.split(_ED.union.user_union_info.build_reward, ",")
    local rewards = zstring.split(dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.rewards), "|")
    local getRewardProgress = zstring.split(dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.getRewardProgress), "|")
    for k,v in pairs(rewards) do
        local isCanGet = false
        if tonumber(_ED.union.union_info.union_worship) >= tonumber(getRewardProgress[k]) then
            isCanGet = true
        end
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_award_box_"..k)
        panel:removeAllChildren(true)
        local cell = UnionHeaverIntegralChest:createCell()
        local state = 0
        if isCanGet == true then
            if tonumber(rewardStates[k]) == 0 then
                state = 1
            else
                state = 2
            end
        else
            state = 0
        end
        cell:init(k, v, state)
        panel:addChild(cell)
    end

    local Panel_fitment_money_1 = ccui.Helper:seekWidgetByName(root, "Panel_fitment_money_1"):setVisible(false)
    local Panel_fitment_end_1 = ccui.Helper:seekWidgetByName(root, "Panel_fitment_end_1"):setVisible(false)
    local Panel_fitment_money_2 = ccui.Helper:seekWidgetByName(root, "Panel_fitment_money_2"):setVisible(false)
    local Panel_fitment_end_2 = ccui.Helper:seekWidgetByName(root, "Panel_fitment_end_2"):setVisible(false)
    local Panel_fitment_money_3 = ccui.Helper:seekWidgetByName(root, "Panel_fitment_money_3"):setVisible(false)
    local Panel_fitment_end_3 = ccui.Helper:seekWidgetByName(root, "Panel_fitment_end_3"):setVisible(false)
    local Panel_vip = ccui.Helper:seekWidgetByName(root, "Panel_vip"):setVisible(false)
    local function updatePanelFitment( index )
        if index == 1 then
            Panel_fitment_money_2:setVisible(true)
            if tonumber(_ED.vip_grade) >= 2 then
                Panel_fitment_money_3:setVisible(true)
            else
                Panel_vip:setVisible(true)
            end
        elseif index == 2 then
            Panel_fitment_money_1:setVisible(true)
            if tonumber(_ED.vip_grade) >= 2 then
                Panel_fitment_money_3:setVisible(true)
            else
                Panel_vip:setVisible(true)
            end
        elseif index == 3 then
            Panel_fitment_money_1:setVisible(true)
            Panel_fitment_money_2:setVisible(true)
        end
    end
    
    if tonumber(_ED.union.user_union_info.build_count) == 0 then
        Panel_fitment_money_1:setVisible(true)
        Panel_fitment_money_2:setVisible(true)
        if tonumber(_ED.vip_grade) >= 2 then
            Panel_fitment_money_3:setVisible(true)
        else
            Panel_vip:setVisible(true)
        end
    else
        if tonumber(_ED.union.user_union_info.build_count) == 1 then
            Panel_fitment_end_1:setVisible(true)
        elseif tonumber(_ED.union.user_union_info.build_count) == 2 then
            Panel_fitment_end_2:setVisible(true)
        elseif tonumber(_ED.union.user_union_info.build_count) == 3 then
            Panel_fitment_end_3:setVisible(true)
        end
        updatePanelFitment(tonumber(_ED.union.user_union_info.build_count))
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

    if __lua_project_id ~= __lua_project_gragon_tiger_gate and __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_naruto  then
        local action = csb.createTimeline("legion/legion_fitment.csb")
        table.insert(self.actions, action)
        csbUnionHeavenCell:runAction(action)

        local Panel_legion_chat = ccui.Helper:seekWidgetByName(root, "Panel_legion_chat")
        local csbUnionHeavenQipaoCell = csb.createNode("legion/legion_fitment_chat.csb")
        table.insert(self.roots, csbUnionHeavenQipaoCell:getChildByName("root"))
        local action1 = csb.createTimeline("legion/legion_fitment_chat.csb")
        table.insert(self.actions, action1)
        csbUnionHeavenQipaoCell:runAction(action1)
        Panel_legion_chat:addChild(csbUnionHeavenQipaoCell)

        ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"):setVisible(false)
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "primary_build_cut_over" then
                if tonumber(_ED.union.user_union_info.build_count) == 0 then
                    self:updateChatPopAction()
                end
            elseif str == "primary_build_out_over" then
                
            elseif str == "intermediate_build_cut_over" then
                if tonumber(_ED.union.user_union_info.build_count) == 0 then
                    self:updateChatPopAction()
                end
            elseif str == "intermediate_build_out_over" then

            elseif str == "advanced_build_cut_over" then
                if tonumber(_ED.union.user_union_info.build_count) == 0 then
                    self:updateChatPopAction()
                end
            elseif str == "advanced_build_out_over" then
                
            end
        end)

        action1:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "legion_chat_cut_over" then
                
            elseif str == "legion_chat_out_over" then
                
            end
        end)
    end
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
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_fitment_primary"),  nil, 
    {
        terminal_name = "union_heaven_select_oracle",
        cell = self,
        nType = 1,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_fitment_intermediate"),  nil, 
    {
        terminal_name = "union_heaven_select_oracle",
        cell = self,
        nType = 2,
        terminal_state = 0
    }, 
    nil, 0)
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

    self:init()
    if tonumber(_ED.union.user_union_info.build_count) == 0 then
        ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"):setVisible(false)
        self:updateChooseAction(1)
    else
        self.tickTime = 0
        ccui.Helper:seekWidgetByName(root, "Button_zhuangxiu"):setVisible(false)
        self:registerOnNoteUpdate(self)
    end
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