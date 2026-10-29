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

		--确认祭天
		local union_heaven_ensure_button_terminal = {
            _name = "union_heaven_ensure_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local chooseType = params._datas.chooseType
                if chooseType == 1 then
                    local cost = dms.int(dms["union_config"], 2, union_config.param)
                    if zstring.tonumber(cost) > zstring.tonumber(_ED.user_info.user_silver) then
                        TipDlg.drawTextDailog(tipStringInfo_union_str[71])
                        return
                    end
                else
                    local cost = dms.int(dms["union_config"], 3, union_config.param)
                    if zstring.tonumber(cost) > zstring.tonumber(_ED.user_info.user_gold) then
                        state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                        {
                            terminal_name = "shortcut_open_recharge_window", 
                            terminal_state = 0, 
                            _msg = red_alert_all_str[185], 
                            _datas= 
                            {
                            }
                        })
                        return
                    end
                end
                local function responseDrawLivenessRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots~=nil then
                            response.node:updateDraw()
                            -- response.node:updateNotice()
                            state_machine.excute("reward_obtain_window_open",0,{25})
                        end
                    end
                end
                protocol_command.union_build.param_list = _ED.union.user_union_info.union_id .."\r\n"..chooseType
                NetworkManager:register(protocol_command.union_build.code, nil, nil, nil, instance, responseDrawLivenessRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_heaven_hide_event_terminal)
		state_machine.add(union_heaven_show_event_terminal)
		state_machine.add(union_heaven_ensure_button_terminal)
        state_machine.init()
    end
    
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
    local armature = panel:getChildByName("ArmatureNode_end")
    local function changeActionCallback(armatureBack)
    end
    armature._invoke = changeActionCallback
    armature:setVisible(true)
    csb.animationChangeToAction(armature, 0, 0, false)
end

function UnionHeaven:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    --公会等级
    local Text_legion_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_lv")
    Text_legion_lv:setString("".._ED.union.union_info.union_grade)
    --公会经验
    local Text_experience = ccui.Helper:seekWidgetByName(root, "Text_experience")
    local Text_remind_experience = ccui.Helper:seekWidgetByName(root, "Text_remind_experience")

    local maxProgress = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)
    --如果公会满级了
    if tonumber(maxProgress) == -1 then
        Text_experience:setString(tipStringInfo_union_str[70])
        ccui.Helper:seekWidgetByName(root, "LoadingBar_fitment_award"):setPercent(100)
        Text_remind_experience:setString(tipStringInfo_union_str[70])
    else    --如果公会没满级
        Text_experience:setString(_ED.union.union_info.union_worship.."/"..maxProgress)
        ccui.Helper:seekWidgetByName(root, "LoadingBar_fitment_award"):setPercent(tonumber(_ED.union.union_info.union_worship) * 100/tonumber(maxProgress))
        Text_remind_experience:setString(string.format(tipStringInfo_union_str[69], 
            maxProgress - tonumber(_ED.union.union_info.union_worship), 
            tonumber(_ED.union.union_info.union_grade + 1)))
    end

    local Image_had_fitment_1 = ccui.Helper:seekWidgetByName(root, "Image_had_fitment_1")       --已建设
    local Image_had_fitment_2 = ccui.Helper:seekWidgetByName(root, "Image_had_fitment_2")       --已建设
    local Button_normal_fitment = ccui.Helper:seekWidgetByName(root, "Button_normal_fitment")   --普通建设
    local Button_senior_fitment = ccui.Helper:seekWidgetByName(root, "Button_senior_fitment")   --高级建设
    Image_had_fitment_1:setVisible(false)
    Image_had_fitment_2:setVisible(false)
    Button_normal_fitment:setVisible(false)
    Button_senior_fitment:setVisible(false)
    --如果没有建设显示建设按钮
    if tonumber(_ED.union.user_union_info.build_count) == 0 then 
        Button_normal_fitment:setVisible(true)
        Button_senior_fitment:setVisible(true)
    else    --如果建设了显示已建设
        -- if tonumber(_ED.union.user_union_info.build_type) == 1 then
            Image_had_fitment_1:setVisible(true)
        -- else
            Image_had_fitment_2:setVisible(true)
        -- end
    end
end

function UnionHeaven:onInit()
	self:updateDraw()
end

function UnionHeaven:onEnterTransitionFinish()
    local csbItem = csb.createNode(config_csb.legion.legion_fitment)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rollback"),  nil, 
    {
        terminal_name = "union_heaven_close",
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --普通建设
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_normal_fitment"),  nil, 
    {
        terminal_name = "union_heaven_ensure_button",
        cell = self,
        chooseType = 1,
        terminal_state = 0
    }, 
    nil, 0)
    --高级建设
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_fitment"),  nil, 
    {
        terminal_name = "union_heaven_ensure_button",
        cell = self,
        chooseType = 2,
        terminal_state = 0
    }, 
    nil, 0)

    self:init()
    state_machine.unlock("union_heaven_open", 0, "")
end

function UnionHeaven:init()
	self:onInit()
	return self
end

function UnionHeaven:onExit()
	state_machine.remove("union_heaven_hide_event")
	state_machine.remove("union_heaven_show_event")
	state_machine.remove("union_heaven_ensure_button")
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