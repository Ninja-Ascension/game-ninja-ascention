-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化主界面
-------------------------------------------------------------------------------------------------------
DigitalPurifyWindow = class("DigitalPurifyWindowClass", Window)

local digital_purify_window_open_terminal = {
    _name = "digital_purify_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if fwin:find("DigitalPurifyWindowClass") == nil then
            fwin:open(DigitalPurifyWindow:new():init(params), fwin._view)
        end
        -- local function responseDigitalPurifyInitCallback(response)
        --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        --         if fwin:find("DigitalPurifyWindowClass") == nil then
        --             fwin:open(DigitalPurifyWindow:new():init(params), fwin._view)
        --         end
        --     end
        -- end
        -- protocol_command.ship_purify_init.param_list = ""
        -- NetworkManager:register(protocol_command.ship_purify_init.code, nil, nil, nil, nil, responseDigitalPurifyInitCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local digital_purify_window_close_terminal = {
    _name = "digital_purify_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        state_machine.unlock("explore_window_open_fun_window")
        if nil == fwin:find("ExploreWindowClass") then
            state_machine.excute("explore_window_open", 0, "") 
        end
        fwin:close(fwin:find("DigitalPurifyWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(digital_purify_window_open_terminal)
state_machine.add(digital_purify_window_close_terminal)
state_machine.init()

function DigitalPurifyWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- load luf file
    app.load("client.l_digital.campaign.digitalpurify.PurifyChoiceWindow")
    app.load("client.l_digital.campaign.digitalpurify.PurifyTeamWindow")
    app.load("client.l_digital.campaign.digitalpurify.PurifyHelpWindow")

    -- var
    
    -- Initialize digital purify page state machine.
    local function init_digital_purify_terminal()

        state_machine.init()
    end
    
    -- call func init digital purify state machine.
    init_digital_purify_terminal()
end

function DigitalPurifyWindow:init( params )
    return self
end

function DigitalPurifyWindow:onUpdate(dt)

end

function DigitalPurifyWindow:onUpdateDraw()
    local root = self.roots[1]
end

function DigitalPurifyWindow:onEnterTransitionFinish()
    local csbDigitalPurifyWindow = csb.createNode("campaign/DigitalPurify/digital_purify.csb")
    self:addChild(csbDigitalPurifyWindow)
    local root = csbDigitalPurifyWindow:getChildByName("root")
    table.insert(self.roots, root)

    app.load("client.player.UserInformationHeroStorage")
    fwin:open(UserInformationHeroStorage:new(), fwin._view)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb_back"), nil, 
    {
        terminal_name = "digital_purify_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)


    self:onUpdateDraw()

    local function responseDigitalPurifyInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node == nil or response.node.roots == nil then
                return
            end

            -- debug.print_r(_ED.digital_purify_info)

            if nil ~= _ED.digital_purify_info then
                if nil ~= _ED.digital_purify_info._team_info 
                    and nil ~= _ED.digital_purify_info._team_info.team_type
                    and _ED.digital_purify_info._team_info.team_type >= 0 
                    then
                    state_machine.excute("purify_team_window_open", 0, response.node)
                else
                    state_machine.excute("purify_choice_window_open", 0, response.node)
                end
            end
        end
    end
    -- if nil ~= _ED.digital_purify_info then
    --     responseDigitalPurifyInitCallback({node = self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
    -- else
        protocol_command.ship_purify_init.param_list = ""
        NetworkManager:register(protocol_command.ship_purify_init.code, nil, nil, nil, self, responseDigitalPurifyInitCallback, false, nil)
    -- end

    -- 彩蛋事件添加
    showEasterEggEvent(7,-1,root)
end

function DigitalPurifyWindow:onExit()

end

function DigitalPurifyWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end
