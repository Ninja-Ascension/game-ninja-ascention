--------------------------------------------------------------------------------------------------------------
--  说明：祭祀
--------------------------------------------------------------------------------------------------------------
FateCell = class("FateCellClass", Window)
FateCell.__size = nil

--创建cell
local fate_create_cell_terminal = {
    _name = "fate_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local from_type = params[1]
        local cell = FateCell:new()
        cell:init(from_type)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fate_create_cell_terminal)
state_machine.init()

function FateCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.from_type = nil  -- 1 银币 2 装备 3 宝石 4 星魂
    self.select_page_index = 1 

    --推送红点
    self._push_notification = nil 

	 -- Initialize fate_cell state machine.
    local function init_fate_cell_terminal()
		
        
        local fate_cell_change_select_gems_type_terminal = {
            _name = "fate_cell_change_select_gems_type",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                cell.select_page_index = params[2]
                cell:drawGems()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
      
        state_machine.add(fate_cell_change_select_gems_type_terminal)
        state_machine.init()
    end
    
    -- call func fate_cell create state machine.
    init_fate_cell_terminal()

end

function FateCell:updateDraw()
    local root = self.roots[1]
    local Panel_fate = ccui.Helper:seekWidgetByName(root,"Panel_fate")
    local Panel_fate_bg = ccui.Helper:seekWidgetByName(root,"Panel_fate_bg")
    local Image_point = ccui.Helper:seekWidgetByName(root,"Image_point")

    self._push_notification = Image_point
    self._push_notification:setVisible(false)

    if self.from_type == 1 then
        Panel_fate:setVisible(false)
        Panel_fate_bg:setBackGroundImage("images/ui/play/fate/sacrifice_card_gold.png")
    elseif self.from_type == 2 then
        Panel_fate:setVisible(false)
        Panel_fate_bg:setBackGroundImage("images/ui/play/fate/sacrifice_card_equipment.png")
    elseif self.from_type == 3 then
        Panel_fate:setVisible(true)
        self:drawGems()
    elseif self.from_type == 4 then
        Panel_fate:setVisible(false)
        if funOpenDrawTip(110,false) == false then
            Panel_fate_bg:setBackGroundImage("images/ui/play/fate/sacrifice_card_soul_star.png")
        else
            Panel_fate_bg:setBackGroundImage("images/ui/play/fate/sacrifice_card_soul_open.png")
        end
    end
end

function FateCell:drawGems()
    local root = self.roots[1]
    local Panel_fate_bg = ccui.Helper:seekWidgetByName(root,"Panel_fate_bg")
    
    local param = dms.string(dms["major_city_config"],2,major_city_config.param)
    param = zstring.split(param,"|")
    param = zstring.split(param[tonumber(_ED.now_week_day)+1],",")

    local magic_beg_id = 0
    for i,v in pairs(param) do
        if i == self.select_page_index then
            magic_beg_id = v 
        end
    end
    
    state_machine.excute("fate_get_gemfate_id",0,magic_beg_id)
    local drop_show = dms.string(dms["magic_beg"],magic_beg_id,magic_beg.drop_show)
    local ship_mould_id = dms.string(dms["magic_beg"],magic_beg_id,magic_beg.drop_show)

    -- print("============",drop_show)
    local drop_show_table = zstring.split(drop_show,"|")
    -- debug.print_r(drop_show_table)
    for i,v in pairs(drop_show_table) do
        local temp = zstring.split(v,",")
        local gem_mould_id = temp[1]
        local gem_prop_type = temp[2]
        local gem_dec = temp[3]
        local data = {
            item_value = 1,
            prop_type = gem_prop_type,
            prop_item = gem_mould_id
        }
        local data_dec = {
            item_value = 1,
            prop_type = gem_prop_type,
            prop_item = gem_mould_id,
            dec = gem_dec,
            name = gems_type_name[dms.int(dms["gems_mould"],gem_mould_id,gems_mould.gem_type)]
        }

        Panel_fate_bg:setBackGroundImage("images/ui/play/fate/sacrifice_card_gem_".. magic_beg_id .. ".png")

        -- print("============",i)
        local Panel_altar_gem = ccui.Helper:seekWidgetByName(root,"Panel_altar_gem_"..i)
        Panel_altar_gem:removeAllChildren(true)
        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data_dec,12,0,false,false})
        Panel_altar_gem:addChild(cell)
    end
end

function FateCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.fate.fate_cell)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    if FateCell.__size == nil then
        FateCell.__size = root:getContentSize()
    end
    --换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_change"), nil, 
    {
        terminal_name = "fate_choose_window_open", 
        terminal_state = 0,
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)


    self:updateDraw()
end

function FateCell:onEnterTransitionFinish()

end

--祭祀推送
function FateCell:onUpdate()
    if self._push_notification == nil then 
        return
    end
    --金币祭祀
    if self.from_type == 1 then
        local max_free_times_gold = dms.int(dms["base_consume"],60,base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local free_times_gold = tonumber(_ED.fate_times[1].free_times)
        local leave_free_times_gold = max_free_times_gold - free_times_gold
        if funOpenDrawTip(107,false) == false then
            if leave_free_times_gold > 0 then
                self._push_notification:setVisible(true)
            else
                self._push_notification:setVisible(false)
            end
        end
    --装备祭祀
    elseif self.from_type == 2 then
        local max_free_times_equip = dms.int(dms["base_consume"],62,base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local free_times_equip = tonumber(_ED.fate_times[2].free_times)
        local leave_free_times_equip = max_free_times_equip - free_times_equip
        if funOpenDrawTip(109,false) == false then
            if leave_free_times_equip > 0 then
                self._push_notification:setVisible(true)
            else
                self._push_notification:setVisible(false)
            end
        end
    --宝石祭祀
    elseif self.from_type == 3 then
        local max_free_times_gem = dms.int(dms["base_consume"],64,base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local free_times_gem = tonumber(_ED.fate_times[3].free_times)
        local leave_free_times_gem = max_free_times_gem - free_times_gem
        if funOpenDrawTip(108,false) == false then
            if leave_free_times_gem > 0 then
                self._push_notification:setVisible(true)
            else
                self._push_notification:setVisible(false)
            end
        end
    --星魂祭祀
    elseif self.from_type == 4 then
        local max_free_times_soul = dms.int(dms["base_consume"],66,base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local free_times_soul = tonumber(_ED.fate_times[4].free_times)
        local leave_free_times_soul = max_free_times_soul - free_times_soul
        if funOpenDrawTip(110,false) == false then
            if leave_free_times_soul > 0 then
                self._push_notification:setVisible(true)
            else
                self._push_notification:setVisible(false)
            end
        end
    end
end

function FateCell:init( from_type )
    self.from_type = from_type
	self:onInit()
    self:setContentSize(FateCell.__size)
end

function FateCell:onExit()
    state_machine.remove("fate_cell_change_select_gems_type")
    state_machine.remove("fate_cell_update_gems")
end