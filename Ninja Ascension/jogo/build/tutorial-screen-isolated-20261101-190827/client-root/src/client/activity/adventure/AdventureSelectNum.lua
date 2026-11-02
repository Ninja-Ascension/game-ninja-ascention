-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险扣除事件
-------------------------------------------------------------------------------------------------------
AdventureSelectNum = class("AdventureSelectNumClass", Window)

local adventure_select_num_open_terminal = {
    _name = "adventure_select_num_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureSelectNumClass") == nil then
            fwin:open(AdventureSelectNum:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_select_num_close_terminal = {
    _name = "adventure_select_num_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureSelectNumClass") then
            fwin:close(fwin:find("AdventureSelectNumClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_select_num_open_terminal)
state_machine.add(adventure_select_num_close_terminal)
state_machine.init()

function AdventureSelectNum:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.adventure.AdventureWindow")

    local function adventure_select_num_terminal()
        --选择数字
        local select_num_result_terminal = {
            _name = "select_num_result",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local num = params._datas.num
                local function callBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.mission.missionex.WindowLock")
                        local windowLock = fwin:find("WindowLockClass")
                        if windowLock == nil then
                            fwin:open(WindowLock:new():init(), fwin._windows)
                        end
                       state_machine.excute("select_num_update", 0, "") 
                       state_machine.excute("adventure_select_num_close", 0, "") 
                    end
                end
                protocol_command.monopoly_throw.param_list = "2".."\r\n"..num
                NetworkManager:register(protocol_command.monopoly_throw.code, nil, nil, nil, instance, callBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(select_num_result_terminal)
        state_machine.init()
    end

    adventure_select_num_terminal()
end

function AdventureSelectNum:init(params)
    return self
end

function AdventureSelectNum:onUpdate(dt)
end

function AdventureSelectNum:onUpdateDraw()
    local root = self.roots[1]
end


function AdventureSelectNum:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/adventure/adv_number.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "adventure_select_num_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    for i=1,6 do
        local Image_dice = ccui.Helper:seekWidgetByName(root, "Image_dice_" .. i)
        Image_dice:setTouchEnabled(true)
        fwin:addTouchEventListener(Image_dice, nil, 
        {
            terminal_name = "select_num_result", 
            isPressedActionEnabled = true,
            num = i
        },
        nil, 0)
    end

    self:onUpdateDraw()
end

function AdventureSelectNum:onExit()

end
