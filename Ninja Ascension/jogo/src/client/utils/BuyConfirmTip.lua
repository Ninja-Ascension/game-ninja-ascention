-- ----------------------------------------------------------------------------------------------------
-- 说明：购买界面二级确认面板
-------------------------------------------------------------------------------------------------------
BuyConfirmTip = class("BuyConfirmTipClass", Window)

local buy_confirm_tip_open_terminal = {
    _name = "buy_confirm_tip_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("BuyConfirmTipClass")
        if nil == _homeWindow then
            local panel = BuyConfirmTip:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local buy_confirm_tip_window_close_terminal = {
    _name = "buy_confirm_tip_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("BuyConfirmTipClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("BuyConfirmTipClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(buy_confirm_tip_open_terminal)
state_machine.add(buy_confirm_tip_window_close_terminal)
state_machine.init()
    
function BuyConfirmTip:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_buy_confirm_tip_window_terminal()
        local buy_confirm_tip_window_confirm_terminal = {
            _name = "buy_confirm_tip_window_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local next_terminal_name = params._datas.next_terminal_name
                if not next_terminal_name and not instance then
                    return
                end
                state_machine.excute(next_terminal_name, 0, {_datas = instance.params})
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(buy_confirm_tip_window_confirm_terminal)
        state_machine.init()
    end
    init_buy_confirm_tip_window_terminal()
end

function BuyConfirmTip:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local cost_types ={
        [1] = "images/ui/icon/zuanshi.png",         -- 钻石
        [2] = "images/ui/icon/jinbi.png",           -- 金币
    }
    local Text_buy_power_title = ccui.Helper:seekWidgetByName(root,"Text_buy_power_title")
    local Image_buy_power_gem = ccui.Helper:seekWidgetByName(root,"Image_buy_power_gem")
    local Text_gem_n = ccui.Helper:seekWidgetByName(root,"Text_gem_n")
    local Text_consume_power = ccui.Helper:seekWidgetByName(root,"Text_consume_power")
    if self.title then
        Text_buy_power_title:setString(self.title)
    end
    Image_buy_power_gem:loadTexture(cost_types[self.cost_type])
    Text_gem_n:setString(self.cost_num)
    Text_consume_power:setString(self.cost_des)
    local spacing = Text_gem_n:getContentSize().width
    local posX = Text_consume_power:getPositionX()
    Text_consume_power:setPositionX(posX+spacing-30)
end

---------------------------------------------------
--1 金币类型（1、钻石， 2、金币）
--2 金币数量
--3 购买描述
--4 确认回调
--5 其他参数（回调协议中的参数）
--6 标题（没有默认是购买皮肤）
---------------------------------------------------
function BuyConfirmTip:init(params)
    self.cost_type = params[1]
    self.cost_num = params[2]
    self.cost_des = params[3]
    self.callback = params[4]
    self.params = params[5]
    self.title = params[6]
    self:onInit()
    return self
end

function BuyConfirmTip:onInit()
    local csbSmActivityBuyEnergy = csb.createNode("utils/prompt_buy.csb")
    local root = csbSmActivityBuyEnergy:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmActivityBuyEnergy)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_power_close"), nil, 
    {
        terminal_name = "buy_confirm_tip_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_power"), nil, 
    {
        terminal_name = "buy_confirm_tip_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	--确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_power_connle"), nil, 
    {
        terminal_name = "buy_confirm_tip_window_confirm",
        next_terminal_name = self.callback,
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
end

function BuyConfirmTip:onExit()
    state_machine.remove("buy_confirm_tip_window_confirm")
end