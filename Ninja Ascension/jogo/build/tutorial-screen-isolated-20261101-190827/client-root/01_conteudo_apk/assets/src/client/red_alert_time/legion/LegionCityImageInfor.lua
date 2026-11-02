-- ------------------------------------------------------------------------------------------------------------
--  说明：城市战玩法说明
-- ------------------------------------------------------------------------------------------------------------
LegionCityImageInfor = class("LegionCityImageInforClass", Window)

--打开界面
local legion_city_image_infor_window_open_terminal = {
    _name = "legion_city_image_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionCityImageInforClass") == nil then
            local _win = LegionCityImageInfor:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_image_infor_window_close_terminal = {
    _name = "legion_city_image_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityImageInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_image_infor_window_open_terminal)
state_machine.add(legion_city_image_infor_window_close_terminal)
state_machine.init()

function LegionCityImageInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._current_page = 0
    self._max_page = 0
    
     -- Initialize alert_home state machine.
    local function init_legion_city_image_infor_terminal()
        local legion_city_image_infor_change_page_terminal = {
            _name = "legion_city_image_infor_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local add_page = params._datas.add_page
                instance._current_page = instance._current_page + add_page
                instance._current_page = math.max(1, instance._current_page)
                instance._current_page = math.min(instance._max_page, instance._current_page)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_image_infor_change_page_terminal)   
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_city_image_infor_terminal()
end

-- 显示信息
function LegionCityImageInfor:onUpdateDraw()
    local root = self.roots[1]
    local Panel_legion_city_image = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_image")
    local Text_legion_city_image_infor = ccui.Helper:seekWidgetByName(root, "Text_legion_city_image_infor")

    -- 图片说明
    Panel_legion_city_image:removeBackGroundImage()
    Panel_legion_city_image:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_images, self._current_page))

    Text_legion_city_image_infor:setString(world_city_image_help_tip_str[self._current_page])
end

--初始化界面
function LegionCityImageInfor:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_image_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self._max_page = #world_city_image_help_tip_str

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_member_vs_close"), nil, 
    {
        terminal_name = "legion_city_image_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_image_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_legion_city_image_infor_l"), nil, 
    {
        terminal_name = "legion_city_image_infor_change_page", 
        terminal_state = 0, 
        add_page = -1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_legion_city_image_infor_r"), nil, 
    {
        terminal_name = "legion_city_image_infor_change_page", 
        terminal_state = 0, 
        add_page = 1,
    }, nil, 1)

    self._current_page = 1
    self:onUpdateDraw()
end

--初始化
function LegionCityImageInfor:init()

    self:onInit()
end

--移除状态机
function LegionCityImageInfor:onExit()

end