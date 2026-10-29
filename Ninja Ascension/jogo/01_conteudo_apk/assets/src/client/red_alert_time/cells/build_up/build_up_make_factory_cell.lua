-- --------------------------------------------------------------------------------------------------
-- 说明：制造列表cell
-- -----------------------------------------------------------------------------------------------------
BuildUpMakeFactoryCell = class("BuildUpMakeFactoryCellClass", Window)
BuildUpMakeFactoryCell.__size = nil

local build_up_make_factory_cell_create_terminal = {
    _name = "build_up_make_factory_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BuildUpMakeFactoryCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_make_factory_cell_create_terminal)
state_machine.init()

function BuildUpMakeFactoryCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil

    local function init_build_up_make_factory_cell_terminal()
        local build_up_make_factory_cell_click_terminal = {
            _name = "build_up_make_factory_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("build_up_make_props_open", 0, {cell._info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_make_factory_cell_update_info_terminal = {
            _name = "build_up_make_factory_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                if cell.roots[1] ~= nil then
                    cell:updateInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_make_factory_cell_click_terminal)
        state_machine.add(build_up_make_factory_cell_update_info_terminal)
        state_machine.init()
    end
    init_build_up_make_factory_cell_terminal()           
end

function BuildUpMakeFactoryCell:updateInfo( ... )
    local root = self.roots[1]
    -- 道具拥有数量
    local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n")
    local prop_count = 0 
    if fundPropWidthId(self._info.get_prop_id) ~= nil then 
        local token = fundPropWidthId(self._info.get_prop_id)
        prop_count = zstring.tonumber(token.prop_number)
    end
    Text_have_n:setString(prop_count)
end

function BuildUpMakeFactoryCell:onUpdateDraw()
    local root = self.roots[1]
    -- 制造道具图标
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    Panel_tank_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,1,self._info.get_prop_id,1})
    Panel_tank_icon:addChild(cell) 

    -- 制造道具名字
    local Text_res_name = ccui.Helper:seekWidgetByName(root,"Text_res_name")
    local prop_name = dms.string(dms["prop_mould"], self._info.get_prop_id, prop_mould.prop_name)
    Text_res_name:setString(prop_name)

    local Text_have_t = ccui.Helper:seekWidgetByName(root,"Text_have_t")
    Text_have_t:setString("")
    Text_have_t:removeAllChildren(true)
    -- 道具拥有数量
    local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n")
    Text_have_n:setVisible(false)
    local prop_count = 0 
    if fundPropWidthId(self._info.get_prop_id) ~= nil then 
        local token = fundPropWidthId(self._info.get_prop_id)
        prop_count = zstring.tonumber(token.prop_number)
    end
    Text_have_n:setString(prop_count)
    -- 科研目标所需时间
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")
    Text_time:setVisible(false)
    Text_time:setString(exChangeTimeToString(self._info.need_time))
    local Image_time_icon = ccui.Helper:seekWidgetByName(root,"Image_time_icon")
    Image_time_icon:setVisible(false)

    -- VIP等级不足设置不可点击
    local Button_build = ccui.Helper:seekWidgetByName(root,"Button_build")
    if tonumber(_ED.vip_grade) >= self._info.need_vip_level then 
        Button_build:setBright(true)
        Button_build:setTouchEnabled(true)
        root:setTouchEnabled(true)
        Text_have_t:setString(tipStringInfo_build_up_info[25])
        Text_have_n:setVisible(true)
        Text_time:setVisible(true)
        Image_time_icon:setVisible(true)
    else
        Button_build:setBright(false)
        Button_build:setTouchEnabled(false)
        root:setTouchEnabled(false)
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]),255, string.format(tipStringInfo_build_up_info[21],self._info.need_vip_level), "fonts/simhei.ttf",20)
        _richText_2:pushBackElement(re1)  
        _richText_2:setContentSize(cc.size(200,20))
        _richText_2:setPosition(cc.p(100,0))
        Text_have_t:addChild(_richText_2)
    end
end

function BuildUpMakeFactoryCell:onEnterTransitionFinish()

end

function BuildUpMakeFactoryCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_make_factory_cell_1, "root")
    self:addChild(root) 
    table.insert(self.roots, root)

    if BuildUpMakeFactoryCell.__size == nil then
        BuildUpMakeFactoryCell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"root"), nil, 
    {
        terminal_name = "build_up_make_factory_cell_click", 
        terminal_state = 0,
        -- touch_scale = true,
        cell = self,
        -- touch_scale_xy = 0.95, 
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_build"), nil, 
    {
        terminal_name = "build_up_make_factory_cell_click", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BuildUpMakeFactoryCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_make_factory_cell_1, self.roots[1])
end

function BuildUpMakeFactoryCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function BuildUpMakeFactoryCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_make_factory_cell_1, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpMakeFactoryCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_res_name = ccui.Helper:seekWidgetByName(root,"Text_res_name")
    local Text_have_t = ccui.Helper:seekWidgetByName(root,"Text_have_t")
    local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n")
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")
    local Image_time_icon = ccui.Helper:seekWidgetByName(root,"Image_time_icon")
    local Button_build = ccui.Helper:seekWidgetByName(root,"Button_build")

    if Panel_tank_icon ~= nil then
        Panel_tank_icon:removeAllChildren(true)
        Text_res_name:setString("")
        Text_have_t:setString("")
        Text_have_t:removeAllChildren(true)
        Text_have_n:setString("")
        Text_have_n:setVisible(true)
        Text_time:setString("")
        Text_time:setVisible(true)
        Image_time_icon:setVisible(true)
        Button_build:setBright(false)
        Button_build:setTouchEnabled(false)
    end
end

function BuildUpMakeFactoryCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index ~= nil and self._index <= 8 then
        self:onInit()
    end
    self:setContentSize(BuildUpMakeFactoryCell.__size)
end

