-----------------------------
-- 秘籍包裹Scrollview
-----------------------------
WeaponBookPackScrollview = class("WeaponBookPackScrollviewClass", Window)

local weapon_book_scrollview_window_open_terminal = {
    _name = "weapon_book_scrollview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("WeaponBookPackScrollviewClass")
        if nil == _Window then
            fwin:open(WeaponBookPackScrollview:new():init(params))
        end
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_scrollview_window_open_terminal)
state_machine.init()

function WeaponBookPackScrollview:ctor()
    self.super:ctor()
    self.roots = {}
    -- 1查看，2 穿戴
    self._open_type = 0

    self.all_props = {}
    self.scroll_view = nil
    self.scroll_view_poy = nil

    local function init_weapon_book_scrollview_terminal()
		--显示界面
		local weapon_book_scrollview_show_terminal = {
            _name = "weapon_book_scrollview_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--隐藏界面
		local weapon_book_scrollview_hide_terminal = {
            _name = "weapon_book_scrollview_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
        --取消选中
        local weapon_book_scrollview_un_set_selected_terminal = {
            _name = "weapon_book_scrollview_un_set_selected",
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
        local weapon_book_scrollview_on_update_all_terminal = {
            _name = "racecourse_scrollview_on_update_all",
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

		state_machine.add(weapon_book_scrollview_show_terminal)	
		state_machine.add(weapon_book_scrollview_hide_terminal)
        state_machine.add(weapon_book_scrollview_un_set_selected_terminal)
        state_machine.add(weapon_book_scrollview_on_update_all_terminal)
        state_machine.init()
    end
    
    init_weapon_book_scrollview_terminal()
end

function WeaponBookPackScrollview:setUnSelecet()
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

function WeaponBookPackScrollview:onHide( ... )
    self:setVisible(false)
end

function WeaponBookPackScrollview:onShow( ... )
    self:setVisible(true)
    local ScrollView_packs = ccui.Helper:seekWidgetByName(self.roots[1],"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
        end
        if i == 1 then
            if v.setSelected ~= nil then
                state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = v }})
            else
                state_machine.excute("packs_prop_reset_ui", 0, nil)
            end
        end
    end
end

function WeaponBookPackScrollview:onUpdateDraw()
    local root = self.roots[1]
    local all_row = 0
    local all_col = 0
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root, "ScrollView_packs")
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

function WeaponBookPackScrollview:onUpdate(dt) 
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

function WeaponBookPackScrollview:getAllData( ... )
    local function sortHorse( a, b )
        return tonumber(a.prop.quality) > tonumber(b.prop.quality) 
            or (tonumber(a.prop.quality) == tonumber(b.prop.quality) and tonumber(a.prop.rank_level) > tonumber(b.prop.rank_level))
    end

    local result = {}
    for i,v in pairs(_ED.weapon_book) do
        if tonumber(v.ship_id) <= 0 then
            local data = 
            {
                prop_data = 
                {
                    item_value = 1,
                    prop_type = 7,
                    prop_item = v.user_equiment_template,
                    prop_id = v.user_equiment_id
                },
                prop = v,
            }
            table.insert(result, data)
        end
    end
    table.sort( result, sortHorse )

    return result
end

function WeaponBookPackScrollview:onEnterTransitionFinish()

end

function WeaponBookPackScrollview:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs_scrollview)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()	
end

function WeaponBookPackScrollview:init(params)
    local rootWindow = params[1]
    self._open_type = params[2]
    self._rootWindows = rootWindow  
    self.all_props = self:getAllData()
	self:onInit()
    return self
end

function WeaponBookPackScrollview:onExit()
    state_machine.remove("weapon_book_scrollview_show")    
    state_machine.remove("weapon_book_scrollview_hide")
    state_machine.remove("weapon_book_scrollview_un_set_selected")
    state_machine.remove("weapon_book_scrollview_on_update_all")
end
