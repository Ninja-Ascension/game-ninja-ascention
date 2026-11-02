--[[ ----------------------------------------------------------------------------
-- 圣诞奇缘主界面
--]] ----------------------------------------------------------------------------
ChristmasRomance = class("ChristmasRomanceClass", Window)

-- 打开窗口
local christmas_romance_window_open_terminal = {
    _name = "christmas_romance_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ChristmasRomanceClass") then
            fwin:open(ChristmasRomance:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local christmas_romance_window_close_terminal = {
    _name = "christmas_romance_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ChristmasRomanceTurntableClass") then
            fwin:close(fwin:find("ChristmasRomanceTurntableClass"))
        end
        if fwin:find("ChristmasRomanceShopClass") then
            fwin:close(fwin:find("ChristmasRomanceShopClass"))
        end
        fwin:close(fwin:find("ChristmasRomanceClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(christmas_romance_window_open_terminal)
state_machine.add(christmas_romance_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomance:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var

    -- load lua files.
    app.load("client.activity.christmas_romance.ChristmasRomanceTurntable")
    app.load("client.activity.christmas_romance.ChristmasRomanceShop")
    app.load("client.activity.christmas_romance.ChristmasRomanceRule")
    app.load("client.activity.christmas_romance.ChristmasRomanceTopInfo")
    app.load("client.cells.utils.resources_icon_cell")
    -- Initialize christmas romance page state machine.
    local function init_christmas_romance_terminal()
        -- 打开角色创建窗口
        local christmas_romance_open_terminal = {
            _name = "christmas_romance_open",
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
        local christmas_romance_close_terminal = {
            _name = "christmas_romance_close",
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

        -- 显示窗口
        local christmas_romance_show_terminal = {
            _name = "christmas_romance_show",
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
        local christmas_romance_hide_terminal = {
            _name = "christmas_romance_hide",
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

        -- 跳转页面 	1.钻石转盘 2.幸运转盘 3.兑换商店
        local christmas_romance_jump_to_page_terminal = {
            _name = "christmas_romance_jump_to_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= params then
                    local mType = params._datas.m_type
                    if mType == 1 or mType == 2 then
                        state_machine.excute("christmas_romance_turntable_window_open", 0, mType)
                    else
                        state_machine.excute("christmas_romance_shop_window_open", 0, "")
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local christmas_romance_get_resources_id_terminal = {
            _name = "christmas_romance_get_resources_id",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.idResources == nil then
                    local activity_params = json.decode(_ED.active_activity[181].activity_params)
                    local idResources = zstring.tonumber(activity_params.festivalThemeId)
            
                    instance.idResources = idResources
                end
            
                return instance.idResources
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(christmas_romance_open_terminal)
        state_machine.add(christmas_romance_close_terminal)
        state_machine.add(christmas_romance_show_terminal)
        state_machine.add(christmas_romance_hide_terminal)
        state_machine.add(christmas_romance_jump_to_page_terminal)
        state_machine.add(christmas_romance_get_resources_id_terminal)
        state_machine.init()
    end
    -- call func init christmas romance state machine.
    init_christmas_romance_terminal()
end

-- 对象初始化
function ChristmasRomance:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ChristmasRomance:onUpdateDraw()
    local root = self.roots[1]
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

    local pathEffect = "images/ui/effice/christmas_romance_shengdan/christmas_romance_shengdan"
    local idResources = state_machine.excute("christmas_romance_get_resources_id")
    if idResources > 0 then
        local newJsonFile = string.format("images/ui/effice/christmas_romance_shengdan/christmas_romance_shengdan_%d/christmas_romance_shengdan.json", idResources)
        local newPathEffect = string.format("images/ui/effice/christmas_romance_shengdan/christmas_romance_shengdan_%d/christmas_romance_shengdan", idResources)
        if cc.FileUtils:getInstance():isFileExist(newJsonFile) == true then
            pathEffect = newPathEffect
        end
    end

    self:playAnimations(Panel_role, pathEffect, true)
    -- 点击刷新
    getChristmasRomanceClickTips(true)
    fwin:addService(
        {
            callback = function(params)
                state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 181)
            end,
            delay = 0
        }
    )
    self:drawRed()
end

-- 红点注册
function ChristmasRomance:drawRed()
    for i = 1, 3 do
        state_machine.excute(
            "push_notification_center_manager",
            0,
            {
                _terminal_name = "push_notification_christmas_romance_page_push",
                _widget = self._showRedBtnList[i],
                _invoke = nil,
                _pageIndex = i-1,
                _interval = 0.5
            }
        )
    end
end

function ChristmasRomance:playAnimations(sender, file, loop)
    sender:removeAllChildren()
    local jsonFile = file .. ".json"
    local atlasFile = file .. ".atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, loop, nil)
    animation:setPosition(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
    sender:addChild(animation)
end

function ChristmasRomance:onEnterTransitionFinish()
    -- 加载ChristmasRomanceWindow界面资源.
    -- res.activity.christmas_romance.christmas_romance = res/activity/christmas_romance/christmas_romance.csb
    local csbNode = csb.createNode("activity/christmas_romance/christmas_romance.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local idResources = state_machine.excute("christmas_romance_get_resources_id")
    if idResources > 0 then
        local newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_bg.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_bg"):loadTexture(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_title.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_title"):loadTexture(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_buttun_1.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Button_gem_turntable"):loadTextureNormal(newPath)
            ccui.Helper:seekWidgetByName(root, "Button_gem_turntable"):loadTexturePressed(newPath)
            ccui.Helper:seekWidgetByName(root, "Button_gem_turntable"):loadTextureDisabled(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_buttun_2.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Button_nomoral_turntable"):loadTextureNormal(newPath)
            ccui.Helper:seekWidgetByName(root, "Button_nomoral_turntable"):loadTexturePressed(newPath)
            ccui.Helper:seekWidgetByName(root, "Button_nomoral_turntable"):loadTextureDisabled(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_buttun_3.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Button_shop"):loadTextureNormal(newPath)
            ccui.Helper:seekWidgetByName(root, "Button_shop"):loadTexturePressed(newPath)
            ccui.Helper:seekWidgetByName(root, "Button_shop"):loadTextureDisabled(newPath)
        end
    end

    -- 跳转至钻石轮盘界面
    self.Button_gem_turntable =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_gem_turntable"),
        nil,
        {
            terminal_name = "christmas_romance_jump_to_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_type = 1
        },
        nil,
        0
    )

    -- 跳转至幸运转盘界面
    self.Button_nomoral_turntable =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_nomoral_turntable"),
        nil,
        {
            terminal_name = "christmas_romance_jump_to_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_type = 2
        },
        nil,
        0
    )

    -- 跳转至兑换商店界面
    self.Button_shop =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_shop"),
        nil,
        {
            terminal_name = "christmas_romance_jump_to_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_type = 3
        },
        nil,
        0
    )

    -- 关闭
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "christmas_romance_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self._showRedBtnList = {
        self.Button_gem_turntable,
        self.Button_nomoral_turntable,
        self.Button_shop
    }

    self:onUpdateDraw()
end

function ChristmasRomance:onExit()
    -- 释放ChristmasRomanceWindow界面资源.
    state_machine.remove("christmas_romance_open")
    state_machine.remove("christmas_romance_close")
    state_machine.remove("christmas_romance_show")
    state_machine.remove("christmas_romance_hide")
    state_machine.remove("christmas_romance_jump_to_page")
    state_machine.remove("christmas_romance_get_resources_id")
end

function ChristmasRomance:close()
    -- window event : close.
end

function ChristmasRomance:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
