-----------------------------
--分解滚动层 -战马
-----------------------------
RefiningScrollviewHorse = class("RefiningScrollviewHorseClass", Window)

local refining_scrollview_horse_window_open_terminal = {
    _name = "refining_scrollview_horse_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RefiningScrollviewHorseClass")
        if nil == _Window then
            fwin:open(RefiningScrollviewHorse:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(refining_scrollview_horse_window_open_terminal)
state_machine.init()

function RefiningScrollviewHorse:ctor()
    self.super:ctor()
    self.roots = {}
    self.user_horses = {}
    self.scroll_view = nil
    self.scroll_view_poy = nil
    -- Initialize refining_scrollview_horse state machine.
    local function init_refining_scrollview_horse_terminal()
        --显示界面
        local refining_scrollview_horse_window_show_terminal = {
            _name = "refining_scrollview_horse_window_show",
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
        local refining_scrollview_horse_window_hide_terminal = {
            _name = "refining_scrollview_horse_window_hide",
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
        local refining_scrollview_horse_un_set_selected_terminal = {
            _name = "refining_scrollview_horse_un_set_selected",
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

        -- 批量添加
        local refining_scrollview_horse_add_batch_terminal = {
            _name = "refining_scrollview_horse_add_batch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("refining_scrollview_horse_un_set_selected",0,"")
                instance:addBatch(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 分解后更新
        local refining_scrollview_horse_updatedraw_all_terminal = {
            _name = "refining_scrollview_horse_updatedraw_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.user_horses = instance:getAllData() 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(refining_scrollview_horse_window_show_terminal)    
        state_machine.add(refining_scrollview_horse_window_hide_terminal)
        state_machine.add(refining_scrollview_horse_un_set_selected_terminal)
        state_machine.add(refining_scrollview_horse_add_batch_terminal)
        state_machine.add(refining_scrollview_horse_updatedraw_all_terminal)
        state_machine.init()
    end
    
    init_refining_scrollview_horse_terminal()
end

function RefiningScrollviewHorse:onHide( ... )
    self:setVisible(false)
end

function RefiningScrollviewHorse:onShow( ... )
    self:setVisible(true)
end

function RefiningScrollviewHorse:addBatch(select_index_table)
    local select_table = {}
    for i,ship_data in pairs(self.user_horses) do
        for j,k in pairs(select_index_table) do
            local quality = dms.int(dms["horse_mould"], ship_data.prop.mould_id, horse_mould.quality)
            if quality == k then
                table.insert(select_table, ship_data.prop.id)
            end
        end
    end
    self:setAllSelecet(select_table)
    state_machine.excute("refining_add_batch_item", 0, select_table)
end

function RefiningScrollviewHorse:setAllSelecet(select_table)
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        for j,k in pairs(select_table) do
            if v.prop ~= nil then
                if tonumber(v.prop.id) == tonumber(k) then
                    v.selected = true
                    v:setSelected()
                end
            end
        end
    end
end

function RefiningScrollviewHorse:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true and v.setSelected ~= nil then
            v.selected = false
            v:setSelected()
        end
    end
end

function RefiningScrollviewHorse:onUpdateDraw()
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
        local v = self.user_horses[i]
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
        local v = self.user_horses[i] 
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
            cell = state_machine.excute("all_resource_create_cell",0,{6, v.prop_data, v.prop, 3, height_n})
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

function RefiningScrollviewHorse:onUpdate(dt) 
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

function RefiningScrollviewHorse:getAllData()
    local function sortHorse( a, b )
        local quality_a = dms.int(dms["horse_mould"], a.prop.mould_id, horse_mould.quality)
        local star_a = dms.int(dms["horse_mould"], a.prop.mould_id, horse_mould.star)
        local quality_b = dms.int(dms["horse_mould"], b.prop.mould_id, horse_mould.quality)
        local star_b = dms.int(dms["horse_mould"], b.prop.mould_id, horse_mould.star)
        return tonumber(quality_a) > tonumber(quality_b) 
            or (tonumber(quality_a) == tonumber(quality_b) and tonumber(star_a) > tonumber(star_b))
    end

    local result = {}
    for i,v in pairs(_ED.horses) do
        if tonumber(v.ship_id) == 0 then
            local data = 
            {
                prop_data = 
                {
                    item_value = 1,
                    prop_type = 35,
                    prop_item = v.mould_id,
                    prop_id = v.id
                },
                prop = v,
            }
            table.insert(result,data)
        end
    end
    table.sort( result, sortHorse )
    return result
end

function RefiningScrollviewHorse:onEnterTransitionFinish()

end

function RefiningScrollviewHorse:onInit( )
    local csbItem = csb.createNode(config_csb.forging.forging_scrollview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function RefiningScrollviewHorse:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.user_horses = self:getAllData()
    self:onInit()
    return self
end

function RefiningScrollviewHorse:onExit()
    state_machine.remove("refining_scrollview_horse_window_show")    
    state_machine.remove("refining_scrollview_horse_window_hide")
    state_machine.remove("refining_scrollview_horse_un_set_selected")
    state_machine.remove("refining_scrollview_horse_add_batch")
    state_machine.remove("refining_scrollview_horse_updatedraw_all")
end
