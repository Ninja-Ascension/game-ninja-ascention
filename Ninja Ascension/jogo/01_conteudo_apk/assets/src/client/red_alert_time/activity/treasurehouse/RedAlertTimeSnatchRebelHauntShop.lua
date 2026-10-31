--------------------------------------------------------------------------------------------------------------
--  说明：夺回黑匣子 军火库
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSnatchRebelHauntShop = class("RedAlertTimeSnatchRebelHauntShopClass", Window)

--打开界面
local red_alert_time_snatch_rebel_haunt_shop_open_terminal = {
    _name = "red_alert_time_snatch_rebel_haunt_shop_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeSnatchRebelHauntShop:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_snatch_rebel_haunt_shop_open_terminal)
state_machine.init()

function RedAlertTimeSnatchRebelHauntShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = 0

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_snatch_rebel_haunt_pack_cell")
    
    local function init_red_alert_time_snatch_rebel_haunt_shop_terminal()
        local red_alert_time_snatch_rebel_haunt_shop_show_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_shop_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_snatch_rebel_haunt_shop_hide_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_shop_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local red_alert_time_snatch_rebel_haunt_shop_updata_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_shop_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_snatch_rebel_haunt_shop_updata_terminal)
        state_machine.add(red_alert_time_snatch_rebel_haunt_shop_hide_terminal)
        state_machine.add(red_alert_time_snatch_rebel_haunt_shop_show_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_snatch_rebel_haunt_shop_terminal()
end

function RedAlertTimeSnatchRebelHauntShop:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state_arry = zstring.split(activity_info.activity_add_state, "!")
    local activity_add_state = zstring.split(activity_add_state_arry[1], ",")

    local Text_snatch_rebel_haunt_rew_n = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_rew_n")
    Text_snatch_rebel_haunt_rew_n:setString(activity_add_state[11])

    local ListView_snatch_rebel_haunt = ccui.Helper:seekWidgetByName(root,"ListView_snatch_rebel_haunt")
    ListView_snatch_rebel_haunt:removeAllItems()

    local result = activity_info.activity_data[2]

    local items = ListView_snatch_rebel_haunt:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_snatch_rebel_haunt_pack_cell_update_info", 0, {cell = v, info = result[k], a_type = self._activity_type, index = k, group = 2})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_snatch_rebel_haunt:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_snatch_rebel_haunt_pack_cell_create", 0, {result[i], i, self._activity_type, 2})
            ListView_snatch_rebel_haunt:addChild(cell)
        end
    end
    ListView_snatch_rebel_haunt:requestRefreshView()
    self._list_view = ListView_snatch_rebel_haunt
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

--初始化
function RedAlertTimeSnatchRebelHauntShop:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.snatch_rebel_haunt_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self:updateDraw()
end

function RedAlertTimeSnatchRebelHauntShop:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function RedAlertTimeSnatchRebelHauntShop:onEnterTransitionFinish()

end

function RedAlertTimeSnatchRebelHauntShop:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeSnatchRebelHauntShop:onExit()
    state_machine.remove("red_alert_time_snatch_rebel_haunt_shop_show")
    state_machine.remove("red_alert_time_snatch_rebel_haunt_shop_hide")
    state_machine.remove("red_alert_time_snatch_rebel_haunt_shop_updata")
end