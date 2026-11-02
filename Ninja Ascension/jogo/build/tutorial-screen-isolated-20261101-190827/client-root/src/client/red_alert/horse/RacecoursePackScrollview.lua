-----------------------------
--马场包裹滚动层
-----------------------------
RacecoursePackScrollview = class("RacecoursePackScrollviewClass", Window)

local racecourse_scrollview_window_open_terminal = {
    _name = "racecourse_scrollview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RacecoursePackScrollviewClass")
        if nil == _Window then
            fwin:open(RacecoursePackScrollview:new():init(params))
        end
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_scrollview_window_open_terminal)
state_machine.init()

function RacecoursePackScrollview:ctor()
    self.super:ctor()
    self.roots = {}
    -- 1战马，2 马魂
    self._rececourse_type = 1
    self._isShowSui = false
    -- 珍兽信息
    self._horse = nil
    self.all_props = {}
    self.prop_numbers = 0
    self.scroll_view = nil
    self.scroll_view_poy = nil

    local function init_racecourse_scrollview_terminal()
		--显示界面
		local racecourse_scrollview_show_terminal = {
            _name = "racecourse_scrollview_show",
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
		local racecourse_scrollview_hide_terminal = {
            _name = "racecourse_scrollview_hide",
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
        local racecourse_scrollview_un_set_selected_terminal = {
            _name = "racecourse_scrollview_un_set_selected",
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
        local racecourse_scrollview_on_update_all_terminal = {
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
		state_machine.add(racecourse_scrollview_show_terminal)	
		state_machine.add(racecourse_scrollview_hide_terminal)
        state_machine.add(racecourse_scrollview_un_set_selected_terminal)
        state_machine.add(racecourse_scrollview_on_update_all_terminal)
        state_machine.init()
    end
    
    init_racecourse_scrollview_terminal()
end

function RacecoursePackScrollview:setUnSelecet()
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

function RacecoursePackScrollview:onHide( ... )
    self:setVisible(false)
end

function RacecoursePackScrollview:onShow( ... )
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

function RacecoursePackScrollview:onUpdateDraw()
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
            if self._rececourse_type == 1 then
                cell = state_machine.excute("all_resource_create_cell",0,{6, v.prop_data, v.prop, 14, height_n})
            else
                if tonumber(v.prop_data.prop_item) == 0 then
                    cell = state_machine.excute("all_resource_create_cell",0,{3, v.prop_data, v.prop, 15, height_n, true, true, 4})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{5, v.prop_data, v.prop, 15, height_n})
                end
            end
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

function RacecoursePackScrollview:onUpdate(dt) 
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

function RacecoursePackScrollview:getAllData( ... )
    local function sortTable( a, b )
        local quality_a = dms.int(dms["horse_spirit_mould"], a.prop.mould_id, horse_spirit_mould.quality)
        local level_a = dms.int(dms["horse_spirit_mould"], a.prop.mould_id, horse_spirit_mould.level)
        local quality_b = dms.int(dms["horse_spirit_mould"], b.prop.mould_id, horse_spirit_mould.quality)
        local level_b = dms.int(dms["horse_spirit_mould"], b.prop.mould_id, horse_spirit_mould.level)
        return tonumber(quality_a) > tonumber(quality_b) 
            or (tonumber(quality_a) == tonumber(quality_b) and tonumber(level_a) > tonumber(level_b))
    end

    local function sortHorse( a, b )
        local quality_a = dms.int(dms["horse_mould"], a.prop.mould_id, horse_mould.quality)
        local star_a = dms.int(dms["horse_mould"], a.prop.mould_id, horse_mould.star)
        local quality_b = dms.int(dms["horse_mould"], b.prop.mould_id, horse_mould.quality)
        local star_b = dms.int(dms["horse_mould"], b.prop.mould_id, horse_mould.star)
        return tonumber(quality_a) > tonumber(quality_b) 
            or (tonumber(quality_a) == tonumber(quality_b) and tonumber(star_a) > tonumber(star_b))
    end

    local result = {}
    local horse_spirits_type = {}
    self.prop_numbers = 0
    -- 获取已穿戴兽魂类型
    if self._horse ~= nil then 
        for i,v in pairs(self._horse.horse_spirits) do
            if tonumber(v) ~= 0 then
                local spirits = _ED.horse_spirits[""..v].mould_id
                local same_type_id = dms.int(dms["horse_spirit_mould"], spirits, horse_spirit_mould.same_type_id)
                table.insert(horse_spirits_type,same_type_id)
            end
        end
    end
    if self._rececourse_type == 1 then
        for i,v in pairs(_ED.horses) do
            local isShow = true
            if self._isShowSui == false and tonumber(v.ship_id) > 0 then
                isShow = false
            end
            if isShow == true then
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
                self.prop_numbers = self.prop_numbers + 1
                table.insert(result, data)
            end
        end
        table.sort( result, sortHorse )
    else
        local prop_result = {}
        local prop_count = 0
        for i,v in pairs(_ED.horse_spirits) do
            if tonumber(v.horse_id) == 0 then
                local data = 
                {
                    prop_data = 
                    {
                        item_value = 1,
                        prop_type = 36,
                        prop_item = v.mould_id,
                    },
                    prop = v,
                }
                local horse_spirit_type = dms.int(dms["horse_spirit_mould"], v.mould_id, horse_spirit_mould.horse_spirit_type)
                local same_type_id = dms.int(dms["horse_spirit_mould"], v.mould_id, horse_spirit_mould.same_type_id)
                if horse_spirit_type == 1 then
                    self.prop_numbers = self.prop_numbers + 1
                    local have_type = false
                    -- 如果已穿戴兽魂,屏蔽同类型兽魂
                    if #horse_spirits_type ~= 0 then 
                        for i,v in pairs(horse_spirits_type) do
                            if same_type_id == tonumber(v) then
                                have_type = true
                                break
                            end
                        end
                        if have_type == false then
                            table.insert(result, data)
                        end
                    else
                        table.insert(result, data)
                    end
                elseif horse_spirit_type == 2 then
                    if self._isShowSui == true then
                        table.insert(prop_result, data)
                    end
                end
            end
        end
        table.sort(result, sortTable)
        for k,v in pairs(prop_result) do
            table.insert(result, v)
        end

        if self._isShowSui == true then
            if tonumber(_ED.user_info.horse_spirits_patch) > 0 then
                local data = 
                {
                    prop_data = 
                    {
                        item_value = tonumber(_ED.user_info.horse_spirits_patch),
                        prop_type = 36,
                        prop_item = 0,
                    },
                }
                local result_copy = {}
                table.insert(result_copy, data)
                for k,v in pairs(result) do
                    table.insert(result_copy, v)
                end
                result = result_copy
            end
        end
    end
    return result
end

function RacecoursePackScrollview:onEnterTransitionFinish()

end

function RacecoursePackScrollview:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs_scrollview)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()	
end

function RacecoursePackScrollview:init(params)
    local rootWindow = params[1]
    self._rececourse_type = params[2]
    if params[3] ~= nil then
        self._isShowSui = params[3]
    end
    if params[4] ~= nil then
        self._horse = params[4]
    end
    self._rootWindows = rootWindow  
    self.all_props = self:getAllData()
	self:onInit()
    return self
end

function RacecoursePackScrollview:onExit()
    state_machine.remove("racecourse_scrollview_show")    
    state_machine.remove("racecourse_scrollview_hide")
    state_machine.remove("racecourse_scrollview_un_set_selected")
    state_machine.remove("racecourse_scrollview_on_update_all")
end
