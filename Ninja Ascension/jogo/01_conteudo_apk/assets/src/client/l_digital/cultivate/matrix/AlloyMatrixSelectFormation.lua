-----------------------------
-- 合金矩阵主界面
-----------------------------
AlloyMatrixSelectFormation = class("AlloyMatrixSelectFormationClass", Window)

local alloy_matrix_select_formation_open_terminal = {
	_name = "alloy_matrix_select_formation_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixSelectFormationClass") == nil then
            fwin:open(AlloyMatrixSelectFormation:new():init(params), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_select_formation_close_terminal = {
	_name = "alloy_matrix_select_formation_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AlloyMatrixSelectFormationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_select_formation_open_terminal)
state_machine.add(alloy_matrix_select_formation_close_terminal)
state_machine.init()

function AlloyMatrixSelectFormation:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentIndex = 1

    self._choose_ship = nil

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixSelectFormationCell")
    
    -- local function init_alloy_matrix_terminal()
    --     local alloy_matrix_ship_choose_terminal = {
    --         _name = "alloy_matrix_ship_choose",
    --         _init = function (terminal)
    --         end,
    --         _inited = false,
    --         _instance = self,
    --         _state = 0,
    --         _invoke = function(terminal, instance, params)
    --             instance:setIndex(params)
    --             return true
    --         end,
    --         _terminal = nil,
    --         _terminals = nil
    --     }

    --     state_machine.add(constellation_rule_open_terminal)
    --     state_machine.init()
    -- end
    -- init_alloy_matrix_terminal()
end

function AlloyMatrixSelectFormation:onUpdateDraw()
    local root = self.roots[1]
    local Image_recommend_no = ccui.Helper:seekWidgetByName(root,"Image_recommend_no")
    local ListView_serial_recommend_list_box = ccui.Helper:seekWidgetByName(root,"ListView_serial_recommend_list_box")
    ListView_serial_recommend_list_box:removeAllItems()
    local keys = table.keys(self.choose_matrix)

    --判断是否有符合的合金矩阵
    function getChooseMatrix( keys, id )
        for i,v in ipairs(keys) do
            if tonumber(v) == tonumber(id) then
                return v
            end
        end
        return nil
    end
    Image_recommend_no:setVisible(false)
    local ship_need_matrix = zstring.split(dms.string(dms["ship_mould"], self.ship.ship_template_id, 68), ",") 
    local count = 0
    for i=#ship_need_matrix, 1, -1 do
        local id = getChooseMatrix(keys, ship_need_matrix[i])
        if id then
            local cell = AlloyMatrixSelectFormationCell:createCell()
            cell:init(id, self.choose_matrix[id], self.index, self.ship, self.cell_parent)
            ListView_serial_recommend_list_box:addChild(cell)
            count = count + 1
        end
    end
    if count == 0 then
        Image_recommend_no:setVisible(true)
    end

    ListView_serial_recommend_list_box:refreshView()
end

function AlloyMatrixSelectFormation:initMetalMatrixInfo()
    self.choose_matrix = {}
    local lock_levels = zstring.split(dms.string(dms["ship_config"], 39, ship_config.param), "!")[self.index]
    local lock_level = zstring.splits(lock_levels, "|", ":")
    local unlock = 0
    for k,v in ipairs(lock_level) do
        if tonumber(lock_level[k][2]) <= tonumber(_ED.user_info.user_grade) then
            unlock = unlock + 1
        end
    end

    for i = 1, #dms["ship_matrix_mould"] do
        local need_metals = zstring.splits(dms.string(dms["ship_matrix_mould"], i, ship_matrix_mould.metal_need), "|", ",")
        local new_need_metals = self:getNewMatrixInfo(need_metals)

        local need_metal_num = table.nums(new_need_metals)
        local max_num = unlock < (self.index + 1)*2 and unlock or (self.index + 1)*2
        if need_metal_num <= max_num and table.nums(self.sort_metals) > 0 then
            local need_have_metals = {}
            for k,v in ipairs(new_need_metals) do
                for _type, metal in pairs(self.sort_metals) do
                    if _type == tonumber(new_need_metals[k][1]) and metal[tonumber(new_need_metals[k][2])] then
                        table.insert(need_have_metals, metal[tonumber(new_need_metals[k][2])])
                    end
                end
            end
            if table.nums(new_need_metals) == table.nums(need_have_metals) then
                self.choose_matrix[i] = need_have_metals
            end
        end
    end
end

function AlloyMatrixSelectFormation:getNewMatrixInfo( metals )
    local new_metals = {}
    for i, metal in ipairs(metals) do
        local num = tonumber(metal[2])
        if num > 1 then
            for k = 1, num do
                local temp = {}
                temp[1] = metal[1]
                temp[2] = k .. ""
                table.insert(new_metals, temp)
            end
        else
            table.insert(new_metals, metal)
        end
    end
    return new_metals

end

function AlloyMatrixSelectFormation:sortMyMetals()
     local function qualityCapacity(a,b)
        local quality1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.quality)
        local quality2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.quality)

        local mould_type1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.mould_type)
        local mould_type2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.mould_type)

        local add_type1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.add_type)
        local add_type2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.add_type)
        if quality1 > quality2 then
            return true
        elseif quality1 == quality2 then
            if tonumber(a.metalRankLevel) > tonumber(b.metalRankLevel) then
                return true
            elseif tonumber(a.metalRankLevel) == tonumber(b.metalRankLevel) then
                if tonumber(a.metalLevel) > tonumber(b.metalLevel) then
                    return true
                elseif tonumber(a.metalLevel) == tonumber(b.metalLevel) then
                    if mould_type1 > mould_type2 then
                        return true
                    elseif mould_type1 == mould_type2 then
                        if add_type1 > add_type2 then
                            return true
                        else
                            return false
                        end
                    else
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    end

    --去掉相同id的合金，每个id的合金只留一个
    local filter_metals = {}
    
    for id = 1, #dms["ship_metal_mould"] do
        local temp_metals = {}
        for k,metal in pairs(_ED.user_alloy_matrix) do
            if metal and id == tonumber(metal.metalMould) and tonumber(metal.shipId) <= 0 then
                table.insert(temp_metals, metal)
            end
        end
        if table.nums(temp_metals) > 0 then
            table.sort(temp_metals, qualityCapacity)
            filter_metals[id] = temp_metals[1]
        end
    end

    self.sort_metals = {}
    local max_type = dms.int(dms["ship_metal_mould"], #dms["ship_metal_mould"], ship_metal_mould.mould_type)
    for i = 1, max_type do
        local metal_type = {}
        for k,metal in pairs(filter_metals) do
            local _type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.mould_type)
            if _type == i then
                table.insert(metal_type, metal)
            end
        end

        if table.nums(metal_type) > 0 then
            table.sort(metal_type, qualityCapacity)
            self.sort_metals[i] = metal_type
        end
    end
end

function AlloyMatrixSelectFormation:onUpdate( dt )
    
end

function AlloyMatrixSelectFormation:init(params)
    self.index = params[1]
    self.ship = params[2]
    self.cell_parent = params[3]
	self:onInit()
    return self
end

function AlloyMatrixSelectFormation:onInit()
    local csbItem = csb.createNode("cultivate/alloy_serial_recommend_list.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_recommend_list_close"), nil, 
    {
        terminal_name = "alloy_matrix_select_formation_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:sortMyMetals()
    self:initMetalMatrixInfo()
    self:onUpdateDraw()
end

function AlloyMatrixSelectFormation:onEnterTransitionFinish()
end

function AlloyMatrixSelectFormation:onExit()
    state_machine.remove("tab_btn_change")
end
