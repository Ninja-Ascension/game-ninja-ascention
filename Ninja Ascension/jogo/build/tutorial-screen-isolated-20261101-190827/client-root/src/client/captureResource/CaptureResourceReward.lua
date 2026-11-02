
CaptureResourceReward = class("CaptureResourceRewardClass", Window)

local capture_resource_reward_open_terminal = {
    _name = "capture_resource_reward_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
                state_machine.excute("capture_resource_rank_close",0,"")
        -- state_machine.lock("capture_resource_reward_open")
        -- local function responseCallback(response)
        --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        --         state_machine.unlock("capture_resource_reward_open")
                local win = CaptureResourceReward:new()
                win:init()
                fwin:open(win,fwin._ui)
        --     else
        --         state_machine.unlock("capture_resource_reward_open")
        --     end
        -- end
        -- NetworkManager:register(protocol_command.hold_integral_init.code, nil, nil, nil, nil, responseCallback, false, nil)

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local capture_resource_reward_close_terminal = {
    _name = "capture_resource_reward_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("CaptureResourceRewardClass")
        if win ~= nil then
            fwin:close(win)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(capture_resource_reward_open_terminal)
state_machine.add(capture_resource_reward_close_terminal)
state_machine.init()

function CaptureResourceReward:ctor()
	self.super:ctor()
	self.roots = {}
    self.list_view = nil
    self.list_view_posY = nil

    local function init_capture_resource_reward_terminal()
		-- local capture_resource_get_reward_terminal = {
  --           _name = "capture_resource_get_reward",
  --           _init = function (terminal)
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
  --               state_machine.lock("capture_resource_get_reward")
  --               local function responseCallback(response)
  --                   if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
  --                       state_machine.unlock("capture_resource_get_reward")
  --                       -- print("==========领取奖励")
  --                       app.load("client.reward.DrawRareReward")
  --                       _ED.capture.rank_reward_state = "1"
  --                       local getRewardWnd = DrawRareReward:new()
  --                       getRewardWnd:init(55)
  --                       fwin:open(getRewardWnd, fwin._ui)                        
  --                       local btn = params._datas.btn_cell
  --                       btn:setVisible(false)

  --                   else
  --                       state_machine.unlock("capture_resource_get_reward")
  --                   end
  --               end
  --               NetworkManager:register(protocol_command.draw_hold_integral_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }

  --       state_machine.add(capture_resource_get_reward_terminal)
        state_machine.init()
    end
    init_capture_resource_reward_terminal()
end



function CaptureResourceReward:onUpdate( dt )
    if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end    
end

function CaptureResourceReward:updateDraw()
    app.load("client.cells.CaptureResource.capture_resource_reward_list_cell")
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    for i = 1, #dms["hold_reward_param"] do
        local reward_data = dms.element(dms["hold_reward_param"],i)
        local cell = CaptureResourceRewardListCell:createCell()
        cell:init(reward_data,i)
        ListView_1:addChild(cell)
    end
    ListView_1:requestRefreshView()
    self.list_view = ListView_1
    self.list_view_posY = self.list_view:getInnerContainer():getPositionY()
end

function CaptureResourceReward:onEnterTransitionFinish()

end
function CaptureResourceReward:onInit( )
    local csbSocietyInfo = csb.createNode("secret_society/secret_award.csb")
    local root = csbSocietyInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocietyInfo)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
    {
        terminal_name = "capture_resource_reward_close", 
        isPressedActionEnabled = true
    },
    nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chaknpaihang"), nil, 
    {
        terminal_name = "capture_resource_rank_open", 
        isPressedActionEnabled = true,
        page = 2
    },
    nil, 1)   
    
    self:updateDraw()
end
function CaptureResourceReward:init( )
    self:onInit()
end

function CaptureResourceReward:onExit()
    -- state_machine.remove("capture_resource_get_reward")
end
