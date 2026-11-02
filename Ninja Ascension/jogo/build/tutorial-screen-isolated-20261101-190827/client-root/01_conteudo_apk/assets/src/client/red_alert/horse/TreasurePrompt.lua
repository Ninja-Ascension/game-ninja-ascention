-----------------------------
-- max捕获二次确认
-----------------------------
TreasurePrompt = class("TreasurePromptClass", Window)
--打开
local treasure_prompt_window_open_terminal = {
    _name = "treasure_prompt_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _TreasurePromptWindow = fwin:find("TreasurePromptClass")
        if nil == _TreasurePromptWindow then
            fwin:open(TreasurePrompt:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local treasure_prompt_window_close_terminal = {
    _name = "treasure_prompt_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TreasurePromptClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(treasure_prompt_window_open_terminal)
state_machine.add(treasure_prompt_window_close_terminal)
state_machine.init()

function TreasurePrompt:ctor()
    self.super:ctor()
    self.roots = {}

    -- 购买类型
    self._buy_type = nil
    -- 消耗
    self._cost = nil
    -- 次数
    self._max_count = nil 

    local function init_treasure_prompt_terminal()
        -- 宝物购买
        local treasure_prompt_count_buy_terminal = {
            _name = "treasure_prompt_count_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance._cost) <= 0 and tonumber(self._buy_type) ~= 1 then
                    state_machine.excute("horse_recruit_choose", 0, {instance._max_count})
                    state_machine.excute("treasure_prompt_window_close", 0, nil)
                    return
                end
                local function recruitCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("horse_recruit_choose", 0, {instance._max_count})
                            state_machine.excute("treasure_prompt_window_close", 0, nil)
                        end
                    end
                end
                protocol_command.find_horse.param_list = instance._buy_type .."\r\n" .. instance._max_count
                NetworkManager:register(protocol_command.find_horse.code, nil, nil, nil, instance, recruitCallBack, false, nil)           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(treasure_prompt_count_buy_terminal)
    end
    init_treasure_prompt_terminal()
end


--初始化附魔列表
function TreasurePrompt:onUpdateDraw()
    local root = self.roots[1]
    -- 消费类型
    local Image_a = ccui.Helper:seekWidgetByName(root, "Image_a") 
    local Image_b = ccui.Helper:seekWidgetByName(root, "Image_b") 
    Image_a:setVisible(false)
    Image_b:setVisible(false)
    if self._buy_type == 0 then
        Image_a:setVisible(true)
    else
        Image_b:setVisible(true)
    end
    -- 消费数量
    local Text_money = ccui.Helper:seekWidgetByName(root, "Text_money") 
    Text_money:setString(self._cost)
    -- 捕获次数
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number") 
    Text_number:setString(self._max_count)

end


function TreasurePrompt:onInit()
    local csbItem = csb.createNode(config_csb.horse.treasure_prompt)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_canel"), nil, 
    {
        terminal_name = "treasure_prompt_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "treasure_prompt_count_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw() 
end

function TreasurePrompt:init(params)
    self._buy_type = params[1]
    self._cost = params[2]
    self._max_count = params[3]
    self:onInit()
    return self
end

function TreasurePrompt:onExit()
    state_machine.remove("treasure_prompt_count_buy")
end