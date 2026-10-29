-----------------------------
-- 合金矩阵主界面
-----------------------------
AlloyMatrixFusion = class("AlloyMatrixFusionClass", Window)

local alloy_matrix_fusion_open_terminal = {
	_name = "alloy_matrix_fusion_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixFusionClass") == nil then
            fwin:open(AlloyMatrixFusion:new():init(params), fwin._ui)  
        end
        
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_fusion_close_terminal = {
	_name = "alloy_matrix_fusion_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AlloyMatrixFusionClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_fusion_open_terminal)
state_machine.add(alloy_matrix_fusion_close_terminal)
state_machine.init()

function AlloyMatrixFusion:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentSelect = {}

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFusionCell")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFusionQuickSelect")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixStrengthenOne")
    
    state_machine.excute("alloy_matrix_strengthen_one_show_hide",0, true)
    local function init_alloy_matrix_terminal()
        local alloy_matrix_fusion_confirm_terminal = {
            _name = "alloy_matrix_fusion_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if not instance.currentSelect or table.nums(instance.currentSelect) <=0 then
                    TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[9])
                    return
                end
                local metal_params = ""
                for k,v in pairs(instance.currentSelect) do
                    if v then
                        metal_params = metal_params .. v .. ","
                    end
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- Piezas sin mejorar devuelven 0 esencia y 0 oro: el servidor no manda
                        -- el S2C 171 y la ventana de premio salia vacia. Sin premio, un aviso.
                        if getSceneReward(7, true) ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd,fwin._ui)
                        else
                            TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[14])
                        end
                        
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            instance.currentSelect = {}
                            response.node:onUpdateDraw()
                        end 
                    end
                end
                protocol_command.ship_metal_dissolve.param_list = metal_params
                NetworkManager:register(protocol_command.ship_metal_dissolve.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local matrix_fusion_quick_choice_terminal = {
            _name = "matrix_fusion_quick_choice",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("alloy_matrix_fusion_quick_select_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local matrix_fusion_metal_num_select_terminal = {
            _name = "matrix_fusion_metal_num_select",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local id = params[1]
                local _type = params[2]
                if _type == 1 then
                    instance.currentSelect[id] = id
                elseif _type == -1 then
                    instance.currentSelect[id] = nil
                elseif _type == 3 then
                    -- Con todo desmarcado (o calidades sin piezas) tambien se limpia la
                    -- seleccion y se repinta: antes seguia viva la anterior.
                    instance.currentSelect = {}
                    local choos_metals = {}
                    for i,v in ipairs(id or {}) do
                        if instance.quality_metals[v] then
                            table.add(choos_metals, instance.quality_metals[v])
                        end
                    end
                    for k,metal in ipairs(choos_metals) do
                        if metal then
                            instance.currentSelect[metal.id] = metal.id
                        end
                    end
                    instance:onUpdateDraw(choos_metals)
                    
                end
                if instance.roots and instance.roots[1] then
                    local Text_alloy_matrixl_fusion_stuff_n_2 = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_alloy_matrixl_fusion_stuff_n_2")
                    local Text_alloy_matrixl_fusion_stuff_n_1 = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_alloy_matrixl_fusion_stuff_n_1")
                    local Text_alloy_matrixl_fusion_jb_n_1 = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_alloy_matrixl_fusion_jb_n_1")
                    local Text_alloy_matrixl_fusion_stuff_t_1 = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_alloy_matrixl_fusion_stuff_t_1")
                    local Image_4 = ccui.Helper:seekWidgetByName(instance.roots[1],"Image_4")
                    local Image_4_0 = ccui.Helper:seekWidgetByName(instance.roots[1],"Image_4_0")
                    Text_alloy_matrixl_fusion_stuff_n_2:setString(table.nums(instance.currentSelect))
                    
                    local consumeEssence = 0
                    local consumeGold = 0
                    local rate = zstring.split(dms.string(dms["ship_config"], 37, ship_config.param), ",")
                    for k,id in pairs(instance.currentSelect) do
                        local essence = tonumber(_ED.user_alloy_matrix[id].consumeEssence)
                        local gold = tonumber(_ED.user_alloy_matrix[id].consumeSilver)
                        consumeEssence = consumeEssence + essence*tonumber(rate[1])
                        consumeGold = consumeGold + gold*tonumber(rate[2])
                    end
                    Text_alloy_matrixl_fusion_stuff_n_1:setString(consumeEssence)
                    Text_alloy_matrixl_fusion_jb_n_1:setString(consumeGold)

                    Text_alloy_matrixl_fusion_stuff_n_1:setVisible(table.nums(instance.currentSelect) > 0)
                    Text_alloy_matrixl_fusion_jb_n_1:setVisible(table.nums(instance.currentSelect) > 0)
                    Image_4:setVisible(table.nums(instance.currentSelect) > 0)
                    Image_4_0:setVisible(table.nums(instance.currentSelect) > 0)

                    local des = table.nums(instance.currentSelect) > 0 and tipStringInfo_alloy_matrix_tips[17] or tipStringInfo_alloy_matrix_tips[18]
                    Text_alloy_matrixl_fusion_stuff_t_1:setString(des)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(alloy_matrix_fusion_confirm_terminal)
        state_machine.add(matrix_fusion_quick_choice_terminal)
        state_machine.add(matrix_fusion_metal_num_select_terminal)
        state_machine.init()
    end
    init_alloy_matrix_terminal()
end

function AlloyMatrixFusion:onUpdateDraw(choosMetals)
    local root = self.roots[1]
    self:sortMyMetals(metals)
    local current_metals = self.all_metals

    local txt_num = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_fusion_stuff_n_2")
    local Text_alloy_matrixl_fusion_stuff_t_1 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_fusion_stuff_t_1")
    local Text_alloy_matrixl_fusion_stuff_n_1 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_fusion_stuff_n_1")
    local Text_alloy_matrixl_fusion_jb_n_1 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_fusion_jb_n_1")
    local Image_4 = ccui.Helper:seekWidgetByName(root,"Image_4")
    local Image_4_0 = ccui.Helper:seekWidgetByName(root,"Image_4_0")
    txt_num:setString(0)
    Text_alloy_matrixl_fusion_stuff_n_1:setString(0)
    Text_alloy_matrixl_fusion_jb_n_1:setString(0)
    Text_alloy_matrixl_fusion_stuff_t_1:setString(tipStringInfo_alloy_matrix_tips[18])

    Text_alloy_matrixl_fusion_stuff_n_1:setVisible(false)
    Text_alloy_matrixl_fusion_jb_n_1:setVisible(false)
    Image_4:setVisible(false)
    Image_4_0:setVisible(false)

    local ScrollView_alloy_matrix_fusion_list_box = ccui.Helper:seekWidgetByName(root,"ScrollView_alloy_matrix_fusion_list_box")
    ScrollView_alloy_matrix_fusion_list_box:removeAllChildren(true)

    local cell_size = nil
    local all = table.nums(current_metals)
    local width_n = math.ceil(all/2)
    local index = 1
    local Hlindex = 0
    local tHeight = 0
    local cell_height = 0
    local InnerHeight = math.max(120 * width_n , ScrollView_alloy_matrix_fusion_list_box:getContentSize().height)
    local InnerWidth = ScrollView_alloy_matrix_fusion_list_box:getInnerContainer():getContentSize().width
    ScrollView_alloy_matrix_fusion_list_box:getInnerContainer():setContentSize(cc.size(InnerWidth , InnerHeight))
    for k,v in ipairs(current_metals) do
        local cell = AlloyMatrixFusionCell:createCell()
        local cellSelected = false
        if choosMetals then
            for i,choose in pairs(choosMetals) do
                 if tonumber(v.id) == tonumber(choose.id) then
                    cellSelected = true
                    break
                 end
            end 
        end
        cell:init(v, index, cellSelected)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
        ScrollView_alloy_matrix_fusion_list_box:addChild(cell)

        cell_height = cell:getContentSize().height
        if (index-1)%2 ==0 then
            Hlindex = Hlindex+1
            tHeight = InnerHeight - cell_height*Hlindex  
        end
        if index <= 2 then
            tHeight = InnerHeight - cell_height
        end

        cell:setPosition(cc.p( (1 - index%2 )* (cell_size.width + 40),  tHeight))
        index = index + 1
    end

    ScrollView_alloy_matrix_fusion_list_box:runAction(cc.Sequence:create({cc.DelayTime:create(0.01), cc.CallFunc:create(function ( sender )
            ScrollView_alloy_matrix_fusion_list_box:jumpToTop()
        end)}))

    self._scroll_view = ScrollView_alloy_matrix_fusion_list_box
    self._scroll_view_poy = ScrollView_alloy_matrix_fusion_list_box:getInnerContainer():getPositionY()

end

function AlloyMatrixFusion:sortMyMetals(metals)
     local function qualityCapacity(a,b)
        local quality1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.quality)
        local quality2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.quality)

        local mould_type1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.mould_type)
        local mould_type2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.mould_type)

        local add_type1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.add_type)
        local add_type2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.add_type)
        if quality1 < quality2 then
            return true
        elseif quality1 == quality2 then
            if tonumber(a.metalRankLevel) < tonumber(b.metalRankLevel) then
                return true
            elseif tonumber(a.metalRankLevel) == tonumber(b.metalRankLevel) then
                if tonumber(a.metalLevel) < tonumber(b.metalLevel) then
                    return true
                elseif tonumber(a.metalLevel) == tonumber(b.metalLevel) then
                    if mould_type1 < mould_type2 then
                        return true
                    elseif mould_type1 == mould_type2 then
                        if add_type1 < add_type2 then
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
    --排序
    if metals then
        table.sort(metals, qualityCapacity)
    end

    --根据品质分类 品质0-4
    self.quality_metals = {}
    self.all_metals = {}
    local max_num = dms.int(dms["ship_config"], 38, ship_config.param)
    for i = 0, 4 do
        local metal_type = {}
        local index = 1
        for k,metal in pairs(_ED.user_alloy_matrix) do
            if metal and tonumber(metal.shipId) <= 0 then
                local _type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)
                if _type == i and index <= max_num then
                    table.insert(metal_type, metal)
                    index = index + 1
                end
            end
        end

        if table.nums(metal_type) > 0 then
            table.sort(metal_type, qualityCapacity)
            self.quality_metals[i] = metal_type
        else
            self.quality_metals[i] = metal_type
        end
    end
    -- 过滤已经放置的合金
    for k,metal in pairs(_ED.user_alloy_matrix) do
        if metal and tonumber(metal.shipId) <= 0 then
            table.insert(self.all_metals, metal)
        end
    end
    table.sort(self.all_metals, qualityCapacity)
end

function AlloyMatrixFusion:onUpdate( dt )
    if self._scroll_view ~= nil then
        local size = self._scroll_view:getContentSize()
        local posY = self._scroll_view:getInnerContainer():getPositionY()
        if self._scroll_view_poy == posY then
            return
        end
        self._scroll_view_poy = posY
        local items = self._scroll_view:getChildren()

        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function AlloyMatrixFusion:init(params)
    self.index = params[1]
    self.ship = params[2]
	self:onInit()
    return self
end

function AlloyMatrixFusion:onInit()
    local csbItem = csb.createNode("cultivate/alloy_matrix_fusion.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_fusion_back"), nil, 
    {
        terminal_name = "alloy_matrix_fusion_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_fusion_yes"), nil, 
    {
        terminal_name = "alloy_matrix_fusion_confirm", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --快速选定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_fusion_quick_choice"), nil, 
    {
        terminal_name = "matrix_fusion_quick_choice", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function AlloyMatrixFusion:onEnterTransitionFinish()
end

function AlloyMatrixFusion:onExit()
    state_machine.remove("tab_btn_change")
end
