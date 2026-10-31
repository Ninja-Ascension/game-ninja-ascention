-- ----------------------------------------------------------------------------------------------------
-- 战功商店界面
-- ----------------------------------------------------------------------------------------------------
NationalWarShop = class("NationalWarShopClass", Window)

-- 打开窗口
local national_war_shop_window_open_terminal = {
    _name = "national_war_shop_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalWarShopWindow = fwin:find("NationalWarShopClass")
        if nil == nationalWarShopWindow then
            fwin:open(NationalWarShop:new():init(params._datas or params), fwin._view)
            state_machine.excute("national_war_shop_content_show", 0, 0)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local national_war_shop_window_close_terminal = {
    _name = "national_war_shop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarShopListViewClass"))
        fwin:close(fwin:find("NationalWarShopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_shop_window_open_terminal)
state_machine.add(national_war_shop_window_close_terminal)
state_machine.init()

function NationalWarShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- app load
    app.load("client.red_alert.campaign.nationalwar.NationalWarShopListView")

    self.exploits_value = nil

    -- Initialize national war shop state machine.
    local function init_national_war_shop()
        -- 显示购买内容
        local national_war_shop_content_show_terminal = {
            _name = "national_war_shop_content_show",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.listview_item = NationalWarShopListView:new()
                fwin:open(instance.listview_item, fwin._view)
                instance.listview_item:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(national_war_shop_content_show_terminal)
        state_machine.init()     
    end

    -- call func init national war shop machine.
    init_national_war_shop()
end

function NationalWarShop:init(params)
    self:onInit()
    self:registerOnNoteUpdate(self, 0)
    return self
end

function NationalWarShop:onUpdate(dt)
    local root = self.roots[1]
    if root == nil then
        return
    end
    -- 更新 战神令 数量显示 
    self.exploits_value:setString(_ED.user_info.exploits)
end

-- 绘图
function NationalWarShop:onUpdateDraw()
    local root = self.roots[1]
    self.exploits_value = ccui.Helper:seekWidgetByName(root,"Text_nationalwar_shop_icon_v")
    self.exploits_value:setString(_ED.user_info.exploits)
end


function NationalWarShop:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_shop)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root") 
    table.insert(self.roots, root)

    -- 关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_nationalwar_shop_back"), nil, 
    {
        terminal_name = "national_war_shop_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function NationalWarShop:onExit()
    self:unregisterOnNoteUpdate(self)
    state_machine.remove("national_war_shop_content_show")
end

