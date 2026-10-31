--[[ ----------------------------------------------------------------------------
-- 大富翁神秘大奖弹窗界面
--]] ----------------------------------------------------------------------------
RichmanGrandSlamPopup = class("RichmanGrandSlamPopupClass", Window)

-- 打开窗口
local richman_grand_slam_popup_window_open_terminal = {
    _name = "richman_grand_slam_popup_window_open",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanGrandSlamPopupClass") then
            fwin:open(RichmanGrandSlamPopup:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local richman_grand_slam_popup_window_close_terminal = {
    _name = "richman_grand_slam_popup_window_close",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RichmanGrandSlamPopupClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(richman_grand_slam_popup_window_open_terminal)
state_machine.add(richman_grand_slam_popup_window_close_terminal)
state_machine.init()

-- 构造器
function RichmanGrandSlamPopup:ctor()
    self.super:ctor()

    self.roots = {}
    self.actions = {}


	local function init_richman_grand_slam_popup_terminal()
        -- 打开角色创建窗口
        local richman_grand_slam_popup_open_terminal = {
            _name = "richman_grand_slam_popup_open",
            _init = function(terminal)
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

        -- 关闭角色创建窗口
        local richman_grand_slam_popup_close_terminal = {
            _name = "richman_grand_slam_popup_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 进行神秘大奖行为
                state_machine.excute("richman_main_play_big_reward_animation", 0, nil)
                state_machine.excute("richman_grand_slam_popup_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local richman_grand_slam_popup_show_terminal = {
            _name = "richman_grand_slam_popup_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local richman_grand_slam_popup_hide_terminal = {
            _name = "richman_grand_slam_popup_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(richman_grand_slam_popup_open_terminal)
        state_machine.add(richman_grand_slam_popup_close_terminal)
        state_machine.add(richman_grand_slam_popup_show_terminal)
        state_machine.add(richman_grand_slam_popup_hide_terminal)
		
        state_machine.init()
    end
    -- call func init state machine.
    init_richman_grand_slam_popup_terminal()

end

function RichmanGrandSlamPopup:onUpdate(dt)
    
end

-- 对象初始化
function RichmanGrandSlamPopup:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RichmanGrandSlamPopup:onInit(params)

end

function RichmanGrandSlamPopup:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/dafuweng/dafuweng_GrandSlam.csb")
    local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
    table.insert(self.roots, root)
	local action = csb.createTimeline("activity/dafuweng/dafuweng_GrandSlam.csb")
	table.insert(self.actions, action)
    csbNode:runAction(action)

    -- 开始神秘大奖
    self.dafuweng_Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "richman_grand_slam_popup_close",
        terminal_state = 0, 
        isPressedActionEnabled = true,
    },
    nil,0)
    
    self:onUpdateDraw()
end

function RichmanGrandSlamPopup:onUpdateDraw()
    local root = self.roots[1]
    local action = self.actions[1]
    -- 动画容器
    self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    self.Panel_effect:removeAllChildren(true)

    local function animationFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
        if evt then
            if evt == "show" then
                if action ~= nil then
                    action:play("animation0", false)
                end
            end
        end
    end

    local function changeActionCallbackOne(armatureBack)
        if armatureBack then
            armatureBack._invoke = nil
            
            armatureBack:setAnimation(0, "animation1", true)
        end
    end

    local jsonFile = "images/ui/effice/effect_dafuweng_shenmijiang/effect_dafuweng_shenmijiang.json"
    local atlasFile = "images/ui/effice/effect_dafuweng_shenmijiang/effect_dafuweng_shenmijiang.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
    sp.initArmature(animation, false)
    animation.animationNameList = {"animation", "animation1"}

    animation._invoke = changeActionCallbackOne
    animation:getAnimation():setFrameEventCallFunc(animationFrameEvent)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

    animation:setAnimation(0, "animation", false)
    animation:setPosition(cc.p(self.Panel_effect:getContentSize().width / 2, self.Panel_effect:getContentSize().height / 2))
    self.Panel_effect:addChild(animation)
end

function RichmanGrandSlamPopup:onExit()
    state_machine.remove("richman_grand_slam_popup_open")
    state_machine.remove("richman_grand_slam_popup_close")
    state_machine.remove("richman_grand_slam_popup_show")
    state_machine.remove("richman_grand_slam_popup_hide")
    
end


function RichmanGrandSlamPopup:close()
	-- window event : close.
	
end

function RichmanGrandSlamPopup:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
