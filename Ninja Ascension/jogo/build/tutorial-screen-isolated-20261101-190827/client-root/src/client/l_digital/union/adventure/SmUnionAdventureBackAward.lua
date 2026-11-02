SmUnionAdventureBackAward = class("SmUnionAdventureBackAward", Window)

-- 打开窗口
local sm_union_adventure_back_award_window_open_terminal = {
    _name = "sm_union_adventure_back_award_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SmUnionAdventureBackAward") then
            fwin:open(SmUnionAdventureBackAward:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local sm_union_adventure_back_award_window_close_terminal = {
    _name = "sm_union_adventure_back_award_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmUnionAdventureBackAward"))

        -- 打开小游戏开始界面
        local gameView = fwin:find("SmUnionAdventureClass")
        if gameView then
            local Panel_21 = ccui.Helper:seekWidgetByName(gameView.roots[1],"Panel_21")
            state_machine.excute("sm_union_adventure_ui_open", 0, {Panel_21})
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_adventure_back_award_window_open_terminal)
state_machine.add(sm_union_adventure_back_award_window_close_terminal)
state_machine.init()

function SmUnionAdventureBackAward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.lstSM = {}

    local function init_sm_union_adventure_back_award_terminal()
        
        local sm_union_adventure_back_award_close_terminal = 
        {
            _name = "sm_union_adventure_back_award_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("SmUnionAdventureBackAward"))

                -- 打开小游戏开始界面
                local gameView = fwin:find("SmUnionAdventureClass")
                if gameView then
                    local Panel_21 = ccui.Helper:seekWidgetByName(gameView.roots[1],"Panel_21")
                    state_machine.excute("sm_union_adventure_ui_open", 0, {Panel_21})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_union_adventure_back_award_confirm_terminal = 
        {
            _name = "sm_union_adventure_back_award_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local silver_number = instance.silver
                        local gem_number = instance.gem
                        local prop_number = instance.numProp

                        fwin:close(fwin:find("SmUnionAdventureBackAward"))

                        local datas = zstring.split(_ED.union_adventure_state_info,"!")
                        local infos = zstring.split(datas[1],",")

                        local current_layer = tonumber(infos[2])
                        state_machine.excute("sm_union_adventure_back_tip_open", 0, {silver_number, gem_number, prop_number, current_layer})
                    end
                end

                NetworkManager:register(protocol_command.stick_crazy_one_key_get.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_adventure_back_award_close_terminal)
        state_machine.add(sm_union_adventure_back_award_confirm_terminal)	
        state_machine.init()
    end

    init_sm_union_adventure_back_award_terminal()
end

function SmUnionAdventureBackAward:init(params)
    self.params = params

    local rootWindow = params[1] 
    self._rootWindows = rootWindow   

    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function SmUnionAdventureBackAward:onEnterTransitionFinish()
    local csbNode = csb.createNode("legion/sm_legion_adventure_back_award.csb")
    self:addChild(csbNode)

    local action = csb.createTimeline("legion/sm_legion_adventure_back_award.csb")
    csbNode:runAction(action)
    action:play("window_open", false)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.btnClose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
    {
        terminal_name = "sm_union_adventure_back_award_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self.btnCancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil,
    {
        terminal_name = "sm_union_adventure_back_award_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)
    
    self.btnConfirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok_0"), nil,
    {
        terminal_name = "sm_union_adventure_back_award_confirm",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self:onUpdateDraw()
    self:showData()
end

function SmUnionAdventureBackAward:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    self.Text_zs_n = ccui.Helper:seekWidgetByName(root, "Text_zs_n")
    self.Text_jb_n = ccui.Helper:seekWidgetByName(root, "Text_jb_n")
    self.Text_sp_n = ccui.Helper:seekWidgetByName(root, "Text_sp_n")
    self.Panel_sp_icon = ccui.Helper:seekWidgetByName(root, "Panel_sp_icon")
end

function SmUnionAdventureBackAward:initData()
    -- 更新数据
    self.silver = 0
    self.gem = 0
    self.numProp = 0

    local datas = zstring.split(_ED.union_adventure_state_info,"!")
    local topHistoryData = datas[3]
    if topHistoryData == "-1" 
    or topHistoryData == ""
    or topHistoryData == nil
    then
    else
        local rewardData = zstring.split(topHistoryData,"|")
        for i, v in pairs(rewardData) do
            local datasReworld = zstring.split(v,",")
            if tonumber(datasReworld[1]) == 1 then
                self.silver = tonumber(datasReworld[3])
            elseif tonumber(datasReworld[1]) == 2 then
                self.gem = tonumber(datasReworld[3])
            elseif tonumber(datasReworld[1]) == 6 then
                self.numProp = tonumber(datasReworld[3])
            end
        end
    end
end

function SmUnionAdventureBackAward:showData()
    -- 更新显示
    self.Panel_sp_icon:removeAllChildren(true)
    local propData = dms.string(dms["union_config"], 73, union_config.param)
    local cell = DrawHandle.drawIcon(propData)
    self.Panel_sp_icon:addChild(cell)

    self.Text_zs_n:setString(""..self.gem)
    self.Text_jb_n:setString(""..self.silver)
    self.Text_sp_n:setString(""..self.numProp)
end

function SmUnionAdventureBackAward:onExit()    
    state_machine.remove("sm_union_adventure_back_award_close")
    state_machine.add("sm_union_adventure_back_award_confirm")	
end

function SmUnionAdventureBackAward:close()

end

function SmUnionAdventureBackAward:destroy(window)
 
end