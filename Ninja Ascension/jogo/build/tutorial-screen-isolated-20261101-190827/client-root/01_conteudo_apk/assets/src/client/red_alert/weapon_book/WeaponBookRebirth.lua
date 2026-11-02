-- 兵符拆解页面

WeaponBookRebirth = class("WeaponBookRebirthClass", Window)
--打开
local weapon_book_rebirth_window_open_terminal = {
    _name = "weapon_book_rebirth_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _WeaponBookRebirthWindow = fwin:find("WeaponBookRebirthClass")
        if nil == _WeaponBookRebirthWindow then
            fwin:open(WeaponBookRebirth:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local weapon_book_rebirth_window_close_terminal = {
    _name = "weapon_book_rebirth_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookRebirthClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_rebirth_window_open_terminal)
state_machine.add(weapon_book_rebirth_window_close_terminal)
state_machine.init()

function WeaponBookRebirth:ctor()
    self.super:ctor()
    self.roots = {}

    self._select_ship = nil
    self.scroll_view = nil

    local function init_weapon_book_rebirth_terminal()
        local weapon_book_rebirth_left_prop_draw_terminal = {
            _name = "weapon_book_rebirth_left_prop_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local horse = params[1]
                local index = params[2]
                instance:onUpdateDrawLeftProp(horse,index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 兵符拆解
        local weapon_book_rebirth_break_down_terminal = {
            _name = "weapon_book_rebirth_break_down",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("break down")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --取消选中
        local weapon_book_rebirth_un_set_selected_terminal = {
            _name = "weapon_book_rebirth_un_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setUnSelecet()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --刷新
        local weapon_book_rebirth_on_update_all_terminal = {
            _name = "weapon_book_rebirth_on_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.all_props = instance:getAllData()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(weapon_book_rebirth_left_prop_draw_terminal)
        state_machine.add(weapon_book_rebirth_break_down_terminal)
        state_machine.add(weapon_book_rebirth_un_set_selected_terminal)
        state_machine.add(weapon_book_rebirth_on_update_all_terminal)
        state_machine.init()
    end
    init_weapon_book_rebirth_terminal()
end

function WeaponBookRebirth:onUpdateDrawLeftProp( horse ,index)
    local root = self.roots[1]

end

function WeaponBookRebirth:onUpdateDraw()
    local root = self.roots[1]

    self:onUpdateProp()
end

function WeaponBookRebirth:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
            return
        end
    end
end

function WeaponBookRebirth:getAllData( ... )
    local function sortHorse( a, b )
        local quality_a = dms.int(dms["horse_mould"], a.prop.mould_id, horse_mould.quality)
        local star_a = dms.int(dms["horse_mould"], a.prop.mould_id, horse_mould.star)
        local quality_b = dms.int(dms["horse_mould"], b.prop.mould_id, horse_mould.quality)
        local star_b = dms.int(dms["horse_mould"], b.prop.mould_id, horse_mould.star)
        return tonumber(quality_a) > tonumber(quality_b) 
            or (tonumber(quality_a) == tonumber(quality_b) and tonumber(star_a) > tonumber(star_b))
    end

    local result = {}

    return result
end


function WeaponBookRebirth:onUpdateProp()
    local root = self.roots[1]
    local all_row = 0
    local all_col = 0
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root, "ScrollView_rebirth")
    ScrollView_packs:removeAllChildren(true)
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    local width = ScrollView_packs:getContentSize().width
    local height = ScrollView_packs:getContentSize().height
    local scroll_height = 0
    local index = 0
    for i = 1,10000 do
        local v = self.all_props[i]
        index = index + 1
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    if index % 4 == 0 then
        scroll_height = index / 4
    else
        scroll_height = math.floor(index / 4) + 1
    end

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end

    for i = 1,10000 do
        local v = self.all_props[i]
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end

        if i % 4 == 0 then
            height_n = i / 4
        else
            height_n = math.floor(i / 4) + 1
        end
        local cell = nil 
        if v == nil then
            cell = state_machine.excute("packs_icon_bg_create_cell",0,"")
        else
            cell = state_machine.excute("all_resource_create_cell",0,{5, v.prop_data, v.prop, 17, height_n})
            if i == 1 then
                state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = cell}})
            end
        end
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_packs:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    ScrollView_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_packs:jumpToTop()  
    self.scroll_view = ScrollView_packs
    self.scroll_view_poy = ScrollView_packs:getInnerContainer():getPositionY()       
end

function WeaponBookRebirth:onUpdate(dt) 
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
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

function WeaponBookRebirth:onInit( )
    local csbItem = csb.createNode(config_csb.weapon_book.weapon_book_rebirth)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebirth_close"), nil, 
    {
        terminal_name = "weapon_book_rebirth_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 拆解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebirth"), nil, 
    {
        terminal_name = "weapon_book_rebirth_break_down",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    self:onUpdateDraw()
end

function WeaponBookRebirth:init(params)
    self._open_type = params[1]
    self._select_ship = params[2]
    self.all_props = self:getAllData()
    self:onInit()
    return self
end

function WeaponBookRebirth:onExit()
    state_machine.remove("weapon_book_rebirth_left_prop_draw")
    state_machine.remove("weapon_book_rebirth_break_down")
    state_machine.remove("weapon_book_rebirth_un_set_selected")
    state_machine.remove("weapon_book_rebirth_on_update_all")
end