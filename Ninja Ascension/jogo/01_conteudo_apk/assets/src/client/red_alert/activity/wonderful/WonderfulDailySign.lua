-------------------------
-- 登录送(活动类型43)
-------------------------

WonderfulDailySign = class("WonderfulDailySignClass", Window)

local wonderful_daily_sign_window_open_terminal = {
    _name = "wonderful_daily_sign_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("WonderfulDailySignClass") then
            local panel = WonderfulDailySign:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wonderful_daily_sign_window_open_terminal)
state_machine.init()

function WonderfulDailySign:ctor()
    self.super:ctor()
    self.roots = {}

    self._now_day = 0           --当前天数

    self._list_view = nil
    -- load lua file
    app.load("client.red_alert.cells.activity.wonderful.wonderful_daily_sign_cell")

    -- Initialize wonderful daily sign state machine.
    local function init_wonderful_daily_sign_terminal()
        -- 刷新
        local wonderful_daily_sign_set_positionx_terminal = {
            _name = "wonderful_daily_sign_set_positionx",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(wonderful_daily_sign_set_positionx_terminal)   
        state_machine.init()

    end
    
    -- call func init up_level state machine.
    init_wonderful_daily_sign_terminal()
end

function WonderfulDailySign:onUpdateDraw()
    local root = self.roots[1]
    local Panel_banner_pic = ccui.Helper:seekWidgetByName(root, "Panel_banner_pic")         --标题图片
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")                       --活动时间

    Panel_banner_pic:removeBackGroundImage()
    Panel_banner_pic:setBackGroundImage(config_res.images.ui.wonderful.active_jieri_pic)
    Text_time:setString(_ED.activity_info["43"].activity_dec)

    local time_info = zstring.split(_ED.activity_info["43"].activity_add_state, ",")
    self._now_day = tonumber(time_info[2])

    self._list_view:removeAllItems()

    for i, info in pairs(_ED.activity_info["43"].activity_data[1]) do
        local cell = state_machine.excute("wonderful_daily_sign_cell_create", 0, {i, info})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self:setSignPosition()
end

-- 将当天签到移动到列表左端
function WonderfulDailySign:setSignPosition()
    self._list_view:requestRefreshView()

    local items = self._list_view:getItems()
    if items[1] == nil then
        return
    end
    local itemSize = items[1]:getContentSize()
    local pox = itemSize.width * (self._now_day -1 )
    self._list_view_pox = self._list_view:getInnerContainer():setPositionX(-pox)
end

function WonderfulDailySign:onEnterTransitionFinish()

end

function WonderfulDailySign:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful_denglusong)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._list_view = ccui.Helper:seekWidgetByName(root, "ListView_day")

    self:onUpdateDraw()
end

function WonderfulDailySign:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function WonderfulDailySign:onExit()
    state_machine.remove("wonderful_daily_sign_set_positionx")
end
