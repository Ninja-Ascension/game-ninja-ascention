-----------------------------
--合成滚动层 -英雄
-----------------------------
CombiningScrollviewHero = class("CombiningScrollviewHeroClass", Window)

local combining_scrollview_hero_window_open_terminal = {
    _name = "combining_scrollview_hero_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("CombiningScrollviewHeroClass")
        if nil == _Window then
            fwin:open(CombiningScrollviewHero:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(combining_scrollview_hero_window_open_terminal)
state_machine.init()

function CombiningScrollviewHero:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_numbers = 0
    self.user_prop_ships = {}
    -- Initialize combining_scrollview_hero state machine.
    local function init_combining_scrollview_hero_terminal()
        --显示界面
        local combining_scrollview_hero_window_show_terminal = {
            _name = "combining_scrollview_hero_window_show",
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
        local combining_scrollview_hero_window_hide_terminal = {
            _name = "combining_scrollview_hero_window_hide",
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
        --取消所有选中
        local combining_scrollview_hero_un_set_selected_terminal = {
            _name = "combining_scrollview_hero_un_set_selected",
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

        -- 刷新所有 或者单个
        local combining_scrollview_hero_update_all_terminal = {
            _name = "combining_scrollview_hero_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateAll()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(combining_scrollview_hero_window_show_terminal)    
        state_machine.add(combining_scrollview_hero_window_hide_terminal)
        state_machine.add(combining_scrollview_hero_un_set_selected_terminal)
        state_machine.add(combining_scrollview_hero_update_all_terminal)
        state_machine.init()
    end
    
    -- call func init combining_scrollview_hero state machine.
    init_combining_scrollview_hero_terminal()
end

function CombiningScrollviewHero:onHide( ... )
    self:setVisible(false)
end

function CombiningScrollviewHero:onShow( ... )
    self:setVisible(true)
end

function CombiningScrollviewHero:onUpdateAll( )
    local root = self.roots[1]
    self.user_prop_ships = self:getAllData()
    -- print("=================================================================================")
    self:onUpdateDraw()
end

function CombiningScrollviewHero:setUnSelecet()
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

function CombiningScrollviewHero:onUpdateDraw()
    local root = self.roots[1]
    local all_row = 0
    local all_col = 0
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    ScrollView_packs:removeAllChildren(true)
    local width = ScrollView_packs:getContentSize().width
    local height = ScrollView_packs:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    for i = 1,10000 do
        local v = self.user_prop_ships[i]
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
        local v = self.user_prop_ships[i]
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
            cell = state_machine.excute("all_resource_create_cell",0,{3,v.prop_data,v.prop,4,0,true,true,1})
        end

        cell:setAnchorPoint(cc.p(0,1))
        -- print("============",wight_n,height_n,(wight_n-1)*(width/4),height - (height_n-1)*92)
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_packs:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_packs:jumpToTop()    
end

function CombiningScrollviewHero:getAllData()
    local all_prop_ships = {}
    self.prop_numbers = 0
    for i,v in pairs(_ED.user_prop) do
        local ship_mould_id =  zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.use_of_ship))
        if ship_mould_id > 0 then
            local data = 
            {
                prop_data = 
                {
                    item_value = v.prop_number,
                    prop_type = 6,
                    prop_item = v.user_prop_template,
                },
                prop = v ,
                ship_type = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.ship_type),
            }
            table.insert(all_prop_ships,data)
            self.prop_numbers = self.prop_numbers + 1
        end
    end

    local function sortEquipType( a, b ) -- 按品质
        return tonumber(a.ship_type) > tonumber(b.ship_type)
    end
    table.sort(all_prop_ships, sortEquipType)

    return all_prop_ships
end

function CombiningScrollviewHero:onEnterTransitionFinish()

end

function CombiningScrollviewHero:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs_scrollview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function CombiningScrollviewHero:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.user_prop_ships = self:getAllData()
    self:onInit()
    return self
end

function CombiningScrollviewHero:onExit()
    state_machine.remove("combining_scrollview_hero_window_show")    
    state_machine.remove("combining_scrollview_hero_window_hide")
    state_machine.remove("combining_scrollview_hero_un_set_selected")
    state_machine.remove("combining_scrollview_hero_update_all")
end
