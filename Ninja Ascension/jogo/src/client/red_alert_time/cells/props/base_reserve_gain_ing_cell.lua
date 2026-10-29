-- --------------------------------------------------------------------------------------------------
-- 说明：基地储备增益cell
-- -----------------------------------------------------------------------------------------------------
BaseReserveGainIngCell = class("BaseReserveGainIngCellClass", Window)
BaseReserveGainCellSize = BaseReserveGainCellSize or nil

local base_reserve_gain_ing_cell_create_terminal = {
    _name = "base_reserve_gain_ing_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BaseReserveGainIngCell:new()
        local index = params[1]
        local base_build_buff = params[2]
        cell:init(index, base_build_buff)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(base_reserve_gain_ing_cell_create_terminal)
state_machine.init()

function BaseReserveGainIngCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._base_build_buff = nil 

    self._buff_info = {}
    self._max_time = 0
    self._start_time = 0
    self._need_gold = 0

    self._loading_bar = nil
    self._text_time = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_base_reserve_gain_ing_cell_terminal()

        local base_reserve_gain_ing_cell_use_terminal = {
            _name = "base_reserve_gain_ing_cell_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local shop_id = cell._base_build_buff.shop_id
                if shop_id > 0 then
                    local prop_ids_info = dms.string(dms["build_shop"], shop_id, build_shop.prop_ids)
                    local prop_ids = zstring.split(prop_ids_info, ",")
                    local buy_type = dms.int(dms["build_shop"], shop_id, build_shop.buy_type)
                    state_machine.excute("props_use_window_open",0,{shop_id, prop_ids, buy_type})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(base_reserve_gain_ing_cell_use_terminal)       
        state_machine.init()
    end
    init_base_reserve_gain_ing_cell_terminal()           
end

function BaseReserveGainIngCell:onUpdateDraw()
    local root = self.roots[1]

    local Panel_base_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_base_res_icon")
    Panel_base_res_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_build_buff.id,6})
    Panel_base_res_icon:addChild(cell) 
    local Text_base_res_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_gain_infor")
    Text_base_res_gain_infor:removeAllChildren(true)
    Text_base_res_gain_infor:setString("")
    
    for k,v in pairs(_ED.factor_info) do
        if tonumber(v.build_buff_id) == tonumber(self._base_build_buff.id) then
            table.insert(self._buff_info, v)
            break
        end
    end

    if tonumber(self._base_build_buff.id) == 22 then
        local telent_id = 0
        if table.nums(self._buff_info) > 0 then
            for k,v in pairs(self._buff_info) do
                if tonumber(v.build_buff_id) == tonumber(self._base_build_buff.id) then
                    telent_id = tonumber(v.mould_id)
                end
            end
        end
        local talent_name = dms.string(dms["talent_mould"], telent_id, talent_mould.talent_name)
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, self._base_build_buff.info, "fonts/simhei.ttf",21)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, "  "..talent_name, "fonts/simhei.ttf",21)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_base_res_gain_infor:getContentSize().width/2,Text_base_res_gain_infor:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_base_res_gain_infor:getContentSize().width,21))
        Text_base_res_gain_infor:addChild(_richText)
    else
        Text_base_res_gain_infor:setString(self._base_build_buff.info)
    end

    local Button_base_res_add = ccui.Helper:seekWidgetByName(root,"Button_base_res_add")
    if self._base_build_buff.shop_id < 0 then
        Button_base_res_add:setVisible(false)
    else
        Button_base_res_add:setVisible(true)
    end

    -- 显示增益倒计时
    local LoadingBar_base_add_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_base_add_time")
    local Text_base_time_ing = ccui.Helper:seekWidgetByName(root,"Text_base_time_ing")
    self._loading_bar = LoadingBar_base_add_time
    self._text_time = Text_base_time_ing

    local max_time = 0
    local start_time = 0
    if table.nums(self._buff_info) > 0 then
        for k,v in pairs(self._buff_info) do
            max_time = tonumber(v.factor_cd_time)-- + max_time
            start_time = tonumber(v.factor_start_time)-- + start_time
        end
    end
    self._max_time = max_time
    self._start_time = start_time
    local now_time = os.time()
    local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
    local persent = math.floor((self._max_time - leave_time) / self._max_time * 100)

    self._loading_bar:setPercent(persent)
    self._text_time:setString(exChangeTimeToString(leave_time))
end

function BaseReserveGainIngCell:onUpdate(dt)
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if table.nums(self._buff_info) > 0 then
                local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
                if leave_time > 0 then
                    local persent = math.floor((self._max_time - leave_time) / self._max_time * 100)
                    self._loading_bar:setPercent(persent)
                    self._text_time:setString(exChangeTimeToString(leave_time))
                else
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                for k,v in pairs(self._buff_info) do
                                    if _ED.factor_info[""..v.id] == nil then     
                                        state_machine.excute("base_reserve_update_draw_page", 0, "")
                                    end
                                end
                            end
                        end
                    end
                    if tonumber(self._base_build_buff.id) == 24 then        -- 守卫战增益
                        NetworkManager:register(protocol_command.guard_check_gain_cd_time.code, nil, nil, nil, self, responseCallback, false, nil)
                    else
                        NetworkManager:register(protocol_command.gain_limit_check.code, nil, nil, nil, self, responseCallback, false, nil)
                    end
                end
            end
        end
    end
end

function BaseReserveGainIngCell:setSelected()

end

function BaseReserveGainIngCell:onEnterTransitionFinish()

end

function BaseReserveGainIngCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.props.base_reserve_gain_ing_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BaseReserveGainCellSize == nil then
        BaseReserveGainCellSize = size
    end

    root:setSwallowTouches(false)
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "base_reserve_gain_ing_cell_use", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_base_res_add"), nil, 
    {
        terminal_name = "base_reserve_gain_ing_cell_use",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BaseReserveGainIngCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.base_reserve_gain_ing_cell, self.roots[1])
end

function BaseReserveGainIngCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 0.5)
end

function BaseReserveGainIngCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.base_reserve_gain_ing_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BaseReserveGainIngCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_base_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_base_res_icon")
    local Text_base_res_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_gain_infor")
    local Button_base_res_add = ccui.Helper:seekWidgetByName(root,"Button_base_res_add")
    local LoadingBar_base_add_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_base_add_time")
    local Text_base_time_ing = ccui.Helper:seekWidgetByName(root,"Text_base_time_ing")

    if Panel_base_res_icon ~= nil then
        Panel_base_res_icon:removeAllChildren(true)
        Text_base_res_gain_infor:setString("")
        Text_base_res_gain_infor:removeAllChildren(true)
        Button_base_res_add:setVisible(true)
        LoadingBar_base_add_time:setPercent(0)
        Text_base_time_ing:setString("")
    end
    self._max_time = 0
    self._start_time = 0
    self._need_gold = 0
    self._loading_bar = nil
    self._text_time = nil
    self:unregisterOnNoteUpdate(self)
end

function BaseReserveGainIngCell:init(index, base_build_buff) 
    self._index = index
    self._base_build_buff = base_build_buff

    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(BaseReserveGainCellSize)
end

