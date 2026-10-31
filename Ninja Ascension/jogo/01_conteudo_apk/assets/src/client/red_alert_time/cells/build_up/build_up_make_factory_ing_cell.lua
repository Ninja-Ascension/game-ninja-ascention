-- --------------------------------------------------------------------------------------------------
-- 说明：制造中列表cell
-- -----------------------------------------------------------------------------------------------------
BuildUpMakeFactoryIngCell = class("BuildUpMakeFactoryIngCellClass", Window)
BuildUpMakeFactoryIngCellSize = BuildUpMakeFactoryIngCellSize or nil

local build_up_make_factory_ing_cell_create_terminal = {
    _name = "build_up_make_factory_ing_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BuildUpMakeFactoryIngCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_make_factory_ing_cell_create_terminal)
state_machine.init()

function BuildUpMakeFactoryIngCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil
    self._max_time = 0
    self._start_time = 0
    self._need_gold = 0

    local function init_build_up_make_factory_ing_cell_terminal()
        local build_up_make_factory_ing_cell_quick_terminal = {
            _name = "build_up_make_factory_ing_cell_quick",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._need_gold > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end

                local tip = ConfirmTip:new()
                tip:init(cell, cell.sureCanUpgrade, string.format(red_alert_all_str[304],cell._need_gold))
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 取消
        local build_up_make_factory_ing_cell_cancel_terminal = {
            _name = "build_up_make_factory_ing_cell_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local tip = ConfirmTip:new()
                tip:init(cell, cell.sureCancelBuild, red_alert_all_str[270])
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_make_factory_ing_cell_quick_terminal)
        state_machine.add(build_up_make_factory_ing_cell_cancel_terminal)
        state_machine.init()
    end
    init_build_up_make_factory_ing_cell_terminal()           
end

-- 加速
function BuildUpMakeFactoryIngCell:sureCanUpgrade(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                local mould_id = _ED.base_prop_make_info[""..response.node._info.mould_id].get_prop_id
                local prop_name = dms.string(dms["prop_mould"], mould_id, prop_mould.prop_name)
                TipDlg.drawTextDailog(string.format(red_alert_all_str[305],prop_name))
            end
            state_machine.excute("home_map_update_prodcution_state", 0, {8})
            state_machine.excute("build_up_make_factory_ing_production_update_draw", 0, "")
            state_machine.excute("build_up_make_factory_production_update_draw", 0, "")
            checkRewardObtainDraw()
        end
    end
    if sure_number == 0 then
        protocol_command.factory_product_clear_cd.param_list = "3".."\r\n"..self._info.id
        NetworkManager:register(protocol_command.factory_product_clear_cd.code, nil, nil, nil, self, responseCallback, false, nil)   
    end
end

-- 取消
function BuildUpMakeFactoryIngCell:sureCancelBuild(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end

    if _ED.production_info["3"] == nil
        or _ED.production_info["3"][""..self._info.id] == nil
        then
        return
    end

    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("home_map_update_prodcution_state", 0, {8})
            state_machine.excute("build_up_make_factory_ing_production_update_draw", 0, "")
            state_machine.excute("build_up_make_factory_production_update_draw", 0, "")
        end
    end
    if sure_number == 0 then
        protocol_command.factory_product_cancel.param_list = "3".."\r\n"..self._info.id
        NetworkManager:register(protocol_command.factory_product_cancel.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function BuildUpMakeFactoryIngCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local mould_id = _ED.base_prop_make_info[""..self._info.mould_id].get_prop_id
    Panel_tank_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,1,mould_id,1})
    Panel_tank_icon:addChild(cell) 
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    local Image_time_icon = ccui.Helper:seekWidgetByName(root,"Image_time_icon")

    local name_width = Image_time_icon:getContentSize().width + LoadingBar_time:getContentSize().width

    local Text_rank_name = ccui.Helper:seekWidgetByName(root,"Text_rank_name")
    local prop_name = dms.string(dms["prop_mould"], mould_id, prop_mould.prop_name)
    Text_rank_name:setString("")
    Text_rank_name:removeAllChildren(true)
    local fontSize = Text_rank_name:getFontSize()
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, prop_name, "fonts/simhei.ttf",fontSize)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " *"..self._info.count, "fonts/simhei.ttf",fontSize)
    _richText_2:pushBackElement(re2)
    _richText_2:setContentSize(cc.size(name_width,fontSize))
    _richText_2:setPosition(cc.p(name_width / 2,0))
    Text_rank_name:addChild(_richText_2)

    -- LoadingBar_time:setPercent()
    -- 生产目标所需时间
    local Text_time_ing = ccui.Helper:seekWidgetByName(root,"Text_time_ing")
    local need_time = _ED.base_prop_make_info[""..self._info.mould_id].need_time
    self._start_time = self._info.production_start_time
    
    local Button_quicken = ccui.Helper:seekWidgetByName(root,"Button_quicken")
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    LoadingBar_time:setPercent(0)
    self._loading_bar = LoadingBar_time
    local Text_time_ing = ccui.Helper:seekWidgetByName(root,"Text_time_ing")
    self._text_time = Text_time_ing
    if zstring.tonumber(self._info.production_state) == 0 then       -- 生产中
        self._max_time = _ED.production_info["3"][""..self._info.id].production_start_cd
        local now_time = os.time()
        local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
        local persent = math.floor((self._max_time - leave_time) / self._max_time *100)
        self._text_time:setString(exChangeTimeToString(leave_time))
        local need_gold = dms.int(dms["major_city_config"],11,major_city_config.param)
        self._need_gold = math.ceil(leave_time/60 * need_gold)
        Button_quicken:setBright(true)
        Button_quicken:setTouchEnabled(true)
    else
        self._text_time:setString(red_alert_all_str[289])
        self._loading_bar:setPercent(0)
        Button_quicken:setBright(false)
        Button_quicken:setTouchEnabled(false)
    end
end

function BuildUpMakeFactoryIngCell:onEnterTransitionFinish()

end

function BuildUpMakeFactoryIngCell:onUpdate(dt)
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if zstring.tonumber(_ED.production_info["3"][""..self._info.id].production_state) == 0 then
                local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
                leave_time = math.min(leave_time, self._max_time)
                local persent = math.floor((self._max_time - leave_time) * 100 / self._max_time)
                self._loading_bar:setPercent(persent)
                self._text_time:setString(exChangeTimeToString(leave_time))
                local need_gold = dms.int(dms["major_city_config"],11,major_city_config.param)
                self._need_gold = math.ceil(leave_time/60 * need_gold)
            end
        end
    end
end

function BuildUpMakeFactoryIngCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_make_factory_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    if BuildUpMakeFactoryIngCellSize == nil then
        BuildUpMakeFactoryIngCellSize = size
    end
    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "build_up_make_factory_ing_cell_cancel", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true,
    },
    nil,1)
    -- 加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quicken"), nil, 
    {
        terminal_name = "build_up_make_factory_ing_cell_quick", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BuildUpMakeFactoryIngCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_make_factory_cell_2, self.roots[1])
end

function BuildUpMakeFactoryIngCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self, 0.5)
    self:onInit()
end

function BuildUpMakeFactoryIngCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_make_factory_cell_2, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpMakeFactoryIngCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_rank_name = ccui.Helper:seekWidgetByName(root,"Text_rank_name")
    local Text_time_ing = ccui.Helper:seekWidgetByName(root,"Text_time_ing")
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    local Button_quicken = ccui.Helper:seekWidgetByName(root,"Button_quicken")

    if Panel_tank_icon ~= nil then
        Panel_tank_icon:removeAllChildren(true)
        Text_rank_name:setString("")
        Text_rank_name:removeAllChildren(true)
        Text_time_ing:setString("")
        LoadingBar_time:setPercent(0)
        Button_quicken:setBright(true)
        Button_quicken:setTouchEnabled(true)
    end

    self:unregisterOnNoteUpdate(self)
end

function BuildUpMakeFactoryIngCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index ~= nil and self._index <= 8 then
        self:onInit()
    end
    self:setContentSize(BuildUpMakeFactoryIngCellSize)
end

