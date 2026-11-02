----------------------------------------------------------------------------------------------------
-- 说明：基地储备cell
-------------------------------------------------------------------------------------------------------
BaseReservePackCell = class("BaseReservePackCellClass", Window)
BaseReservePackCell.__size = nil

local base_reserve_pack_create_cell_terminal = {
    _name = "base_reserve_pack_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BaseReservePackCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(base_reserve_pack_create_cell_terminal)
state_machine.init()

function BaseReservePackCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = {}

    app.load("client.red_alert_time.props.PropsInforPrompt")
    app.load("client.red_alert_time.props.PropsUse")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
 	local function init_base_reserve_pack_cell_terminal()
        -- 打开购买界面
        local base_reserve_pack_cell_to_use_terminal = {
            _name = "base_reserve_pack_cell_to_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local info = _ED.base_build_shop_info["1"][""..cell._info[1]]
                state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 产量
        local base_reserve_pack_cell_produce_terminal = {
            _name = "base_reserve_pack_cell_produce",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params._datas.cell
                state_machine.excute("base_res_yield_infor_window_open",0,{cell._info[2],cell._info[6], cell._index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 道具详情
        local base_reserve_pack_cell_props_info_terminal = {
            _name = "base_reserve_pack_cell_props_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("props_infor_prompt_window_open", 0, {resource_prop_id[cell._info[1]]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(base_reserve_pack_cell_to_use_terminal)
        state_machine.add(base_reserve_pack_cell_produce_terminal)
        state_machine.add(base_reserve_pack_cell_props_info_terminal)
        state_machine.init()
    end
	init_base_reserve_pack_cell_terminal()        	
end

function BaseReservePackCell:onUpdateDraw()
	local root = self.roots[1]
    -- 道具icon
    local Panel_props_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_res_icon")
    Panel_props_res_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{1,1,resource_prop_id[self._info[1]],5})
    Panel_props_res_icon:addChild(cell) 
    -- 道具名字(已建造个数)
    local Text_props_res_name = ccui.Helper:seekWidgetByName(root,"Text_props_res_name")
    Text_props_res_name:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, self._info[2], "fonts/simhei.ttf",21)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, (string.format(red_alert_all_str[276], self._info[5])), "fonts/simhei.ttf",21)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_props_res_name:getContentSize().width/2,Text_props_res_name:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_props_res_name:getContentSize().width,21))
    Text_props_res_name:addChild(_richText)

    -- 拥有
    local Text_props_res_have_n = ccui.Helper:seekWidgetByName(root,"Text_props_res_have_n")
    Text_props_res_have_n:setString(exChangeNumToString(self._info[3]).."/"..exChangeNumToString(self._info[4]))

    -- 产量
    local Text_props_res_yield_n = ccui.Helper:seekWidgetByName(root,"Text_props_res_yield_n")
    Text_props_res_yield_n:setString(string.format(red_alert_all_str[77],exChangeNumToString(self._info[6])))
    
    local LoadingBar_res_have_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_res_have_1")
    local persent_1 = tonumber(self._info[3]) / tonumber(self._info[4]) * 100
    LoadingBar_res_have_1:setPercent(persent_1)

    -- 受保护进度条
    local LoadingBar_res_have_2 = ccui.Helper:seekWidgetByName(root,"LoadingBar_res_have_2")
    local persent_2 = tonumber(self._info[7]) / tonumber(self._info[4]) * 100
    if persent_2 > persent_1 then
        persent_2 = persent_1
    end
    LoadingBar_res_have_2:setPercent(persent_2)

    -- 仓库状态
    local Text_res_plunder_state = ccui.Helper:seekWidgetByName(root,"Text_res_plunder_state")
    Text_res_plunder_state:setString("")
    local index = 1
    if tonumber(self._info[3]) > tonumber(self._info[4]) then
        index = 3
    elseif tonumber(self._info[3]) > tonumber(self._info[7]) then
        index = 2
    else
        index = 1
    end
    Text_res_plunder_state:setString(red_alert_time_str[10 + index])
    Text_res_plunder_state:setColor(cc.c3b(boom_window_color_Type[index][1],boom_window_color_Type[index][2],boom_window_color_Type[index][3]))

    -- 是否有增益状态
    local is_have_factor = false
    for k, v in pairs(_ED.factor_info) do
        if tonumber(v.build_buff_id) == self._index then
            is_have_factor = true
            break
        end
    end
    local Image_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_arrow_down")
    local currFlore = tonumber(_ED.user_info.booming)
    local maxFlore = tonumber(_ED.user_info.forage)
    local loss_boom_resources = 0
    if currFlore < maxFlore then
        local boom_bar = currFlore/maxFlore
        for i= 1, dms.count(dms["build_boom_lose"]) do
            local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
            if boom_bar >= tonumber(boom_proportion) then
                loss_boom_resources = dms.int(dms["build_boom_lose"], i, build_boom_lose.loss_boom_resources)
                break
            end
        end
    end
    if loss_boom_resources > 0 then
        Image_arrow_down:setVisible(true)
        is_have_factor = false
    else
        Image_arrow_down:setVisible(false)
    end

    local Image_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_arrow_up")
    Image_arrow_up:setVisible(false)
    if is_have_factor == true then
        Image_arrow_up:setVisible(true)
    else
        Image_arrow_up:setVisible(false)
    end
end

function BaseReservePackCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.props.base_reserve_pack_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if BaseReservePackCell.__size == nil then
		BaseReservePackCell.__size = root:getContentSize()
	end

    -- 使用
    root:setSwallowTouches(false)
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "base_reserve_pack_cell_to_use",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_res_add"), nil, 
    {
        terminal_name = "base_reserve_pack_cell_to_use",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 产量
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_res_infor"), nil, 
    {
        terminal_name = "base_reserve_pack_cell_produce",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 道具详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_res_icon"), nil, 
    {
        terminal_name = "base_reserve_pack_cell_props_info",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

	self:onUpdateDraw()
end

function BaseReservePackCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.props.base_reserve_pack_cell, self.roots[1])
end

function BaseReservePackCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function BaseReservePackCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.props.base_reserve_pack_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function BaseReservePackCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_res_icon")
    local Text_props_res_name = ccui.Helper:seekWidgetByName(root,"Text_props_res_name")
    local Text_props_res_have_n = ccui.Helper:seekWidgetByName(root,"Text_props_res_have_n")
    local Text_props_res_yield_n = ccui.Helper:seekWidgetByName(root,"Text_props_res_yield_n")
    local LoadingBar_res_have_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_res_have_1")
    local LoadingBar_res_have_2 = ccui.Helper:seekWidgetByName(root,"LoadingBar_res_have_2")
    local Text_res_plunder_state = ccui.Helper:seekWidgetByName(root,"Text_res_plunder_state")
    local Image_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_arrow_up")

    if Panel_props_res_icon ~= nil then
        Panel_props_res_icon:removeAllChildren(true)
        Text_props_res_name:setString("")
        Text_props_res_name:removeAllChildren(true)
        Text_props_res_have_n:setString("")
        Text_props_res_yield_n:setString("")
        LoadingBar_res_have_1:setPercent(0)
        LoadingBar_res_have_2:setPercent(0)
        Text_res_plunder_state:setString("")
        Text_res_plunder_state:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Image_arrow_up:setVisible(false)
    end
end

function BaseReservePackCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index <= 6 then
        self:onInit()
    end
	self:setContentSize(BaseReservePackCell.__size)
end

