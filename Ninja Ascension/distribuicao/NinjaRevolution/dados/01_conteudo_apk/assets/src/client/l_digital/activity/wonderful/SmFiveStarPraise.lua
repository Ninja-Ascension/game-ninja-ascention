-----------------------------
-- 五星好评
-----------------------------
SmFiveStarPraise = class("SmFiveStarPraiseClass", Window)

local sm_five_star_praise_window_open_terminal = {
    _name = "sm_five_star_praise_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
            if nil == fwin:find("SmFiveStarPraiseClass") then
                fwin:open(SmFiveStarPraise:new():init(params), fwin._windows)
            end
        -- end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_five_star_praise_window_close_terminal = {
    _name = "sm_five_star_praise_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("SmFiveStarPraiseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_five_star_praise_window_open_terminal)
state_machine.add(sm_five_star_praise_window_close_terminal)
state_machine.init()

function SmFiveStarPraise:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._listInfo = {}
    self._index = 0

    -- var

    local function init_sm_five_star_praise_terminal()
        local sm_five_star_praise_goto_terminal = {
            _name = "sm_five_star_praise_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                NetworkManager:register(protocol_command.five_star_praise.code, nil, nil, nil, instance, nil, false, nil)
                if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
                    handlePlatformRequest(0, CC_OPEN_URL, _web_page_jump[4])
                else
                    handlePlatformRequest(0, CC_OPEN_URL, _web_page_jump[6])
                end
                state_machine.excute("sm_five_star_praise_window_close", 0, ".")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_five_star_praise_goto_terminal)
        state_machine.init()
    end
    
    init_sm_five_star_praise_terminal()
end

function SmFiveStarPraise:onSelectChoose()
    local root = self.roots[1]
end

function SmFiveStarPraise:onEnterTransitionFinish()

end


function SmFiveStarPraise:onInit( )
    local csbItem = csb.createNode("utils/fivestarevaluation.csb")
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    -- 残忍拒绝
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_8"), nil, 
    {
        terminal_name = "sm_five_star_praise_window_close",
        terminal_state = 0,
    }, nil, 0)

    -- 不好玩
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil, 
    {
        terminal_name = "sm_five_star_praise_goto",
        terminal_state = 0,
    }, nil, 0)

    --给个好评
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil, 
    {
        terminal_name = "sm_five_star_praise_goto",
        terminal_state = 0,
    }, nil, 0)

end

function SmFiveStarPraise:init(params)
	self:onInit()
    return self
end

function SmFiveStarPraise:onExit()
    state_machine.remove("sm_five_star_praise_goto")
end
