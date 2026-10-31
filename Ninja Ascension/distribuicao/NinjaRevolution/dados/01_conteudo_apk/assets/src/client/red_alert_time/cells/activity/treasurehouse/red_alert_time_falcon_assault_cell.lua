--------------------------------------------------------------------------------------------------------------
--  猎鹰突击改造cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeFalconAssaultCell = class("RedAlertTimeFalconAssaultCellClass", Window)
RedAlertTimeFalconAssaultCell.__size = nil

-- 创建cell
local red_alert_time_falcon_assault_cell_create_terminal = {
    _name = "red_alert_time_falcon_assault_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeFalconAssaultCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_falcon_assault_cell_create_terminal)
state_machine.init()

function RedAlertTimeFalconAssaultCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._index = 0
    self._reform_tank_id = 0
    
    -- 加载lua文件
    
    -- 初始化状态机
    local function init_red_alert_time_falcon_assault_cell_terminal()
        local red_alert_time_falcon_assault_cell_reform_terminal = {
            _name = "red_alert_time_falcon_assault_cell_reform",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell 
                if __lua_project_id == __lua_project_red_alert_time then
                    tank_info = {}
                    tank_info.tank_id = cell._reform_tank_id
                    state_machine.excute("build_up_tank_production_window_open", 0, {3, tank_info, true})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_falcon_assault_cell_reform_terminal)
        state_machine.init()
    end 
    init_red_alert_time_falcon_assault_cell_terminal()

end

-- 刷新
function RedAlertTimeFalconAssaultCell:updateDraw()
    local root = self.roots[1]

    local Panel_falcon_assault_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_falcon_assault_tank_icon")
    local Text_falcon_assault_tank_name = ccui.Helper:seekWidgetByName(root,"Text_falcon_assault_tank_name")

    local tank_data = dms.element(dms["ship_mould"], self._reform_tank_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)
    local pic_index = dms.atos(tank_data, ship_mould.All_icon)

    local reform_tank_count = 0
    local reform_tank_info =  fundShipWidthTemplateId(self._reform_tank_id)
    if reform_tank_info ~= nil then
        reform_tank_count = tonumber(reform_tank_info.current_count)
    end

     -- 名称
    local Text_falcon_assault_tank_name = ccui.Helper:seekWidgetByName(root,"Text_falcon_assault_tank_name")
    Text_falcon_assault_tank_name:removeAllChildren(true)
    Text_falcon_assault_tank_name:setString("")
    local font_size = Text_falcon_assault_tank_name:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setContentSize(cc.size(Text_falcon_assault_tank_name:getContentSize().width, Text_falcon_assault_tank_name:getContentSize().height))  
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, tank_name, config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "*"..reform_tank_count, config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    _richText:formatTextExt()
    _richText:setPosition(cc.p(Text_falcon_assault_tank_name:getContentSize().width, Text_falcon_assault_tank_name:getContentSize().height))  
    Text_falcon_assault_tank_name:addChild(_richText)

    -- 图标
    local Panel_falcon_assault_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_falcon_assault_tank_icon")
    Panel_falcon_assault_tank_icon:removeBackGroundImage()
    Panel_falcon_assault_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic_index))
end 

function RedAlertTimeFalconAssaultCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.falcon_assault_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeFalconAssaultCell.__size == nil then
        RedAlertTimeFalconAssaultCell.__size = root:getContentSize()
    end

    local Panel_falcon_assault_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_falcon_assault_tank_icon")
    Panel_falcon_assault_tank_icon:setTouchEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_falcon_assault_tank_icon"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_cell_reform", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeFalconAssaultCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function RedAlertTimeFalconAssaultCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_falcon_assault_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_falcon_assault_tank_icon")
    local Text_falcon_assault_tank_name = ccui.Helper:seekWidgetByName(root,"Text_falcon_assault_tank_name")
    if Panel_falcon_assault_tank_icon ~= nil then
        Panel_falcon_assault_tank_icon:removeBackGroundImage()
        Text_falcon_assault_tank_name:setString("")
        Text_falcon_assault_tank_name:removeAllChildren(true)
    end
end

function RedAlertTimeFalconAssaultCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeFalconAssaultCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.falcon_assault_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeFalconAssaultCell:init(params)
    -- 初始化参数
    self._index = params[1]
    self._reform_tank_id = params[2]

    self:onInit()
    self:setContentSize(RedAlertTimeFalconAssaultCell.__size)
    return self
end

function RedAlertTimeFalconAssaultCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.falcon_assault_cell, self.roots[1])
end