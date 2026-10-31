----------------------------------------------------------------------------------------------------
-- 说明：文件岛商店cell
----------------------------------------------------------------------------------------------------
ExplorationShopCell = class("ExplorationShopCellClass", Window)
ExplorationShopCell.__size = nil

function ExplorationShopCell:ctor()
    self.super:ctor()

	self.roots = {}
	self.prop = nil
	self.actions = {}

	local function init_exploration_shop_cell_terminal()
		local exploration_shop_cell_buy_terminal = {
            _name = "exploration_shop_cell_buy",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	state_machine.excute("exploration_shop_buy_open", 0, {cell.prop, cell, cell.id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(exploration_shop_cell_buy_terminal)
        state_machine.init()
	end

	init_exploration_shop_cell_terminal()
end


function ExplorationShopCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	local Image_explore_success_tsb_t = ccui.Helper:seekWidgetByName(root, "Image_explore_success_tsb_t")
	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
	local Text_explore_shop_refresh_time = ccui.Helper:seekWidgetByName(root, "Text_explore_shop_refresh_time")

	Text_name:setString(self.prop.mould_name .. "*" .. self.prop.number)
	local quality = tonumber(self.prop.prop_quality)
	Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

	Text_5:setString(self.prop.sale_percentage)
	
	local cost_image = {
		[2] = "images/ui/icon/zuanshi.png",   					-- 钻石
		[1] = "images/ui/icon/jinbi.png",   					-- 金币
		[70] = "images/ui/text/TS/tsb.png", 					-- 探索币
	}
	
	Image_explore_success_tsb_t:loadTexture(cost_image[self.prop.sell_type])


	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	Panel_6:removeAllChildren(true)

	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		cell:init(tonumber(self.prop.type), 0, tonumber(self.prop.mould_id), nil, nil, nil, nil, nil, {equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type), 0, tonumber(self.prop.mould_id))
	end
	Panel_6:addChild(cell)

	local panel = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	panel:setTouchEnabled(false)

	local buy_times_string = self.current_buy_times .. "/" .. self.buy_times

	local Text_buy_times = ccui.Helper:seekWidgetByName(root, "Text_buy_times")
	Text_buy_times:setString("")
	Text_buy_times:removeAllChildren(true)
	Image_sell_out:setVisible(tonumber(self.current_buy_times) <= 0)

	 local richTextWidth = Text_buy_times:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_buy_times:getFontSize() * 8
    end
			
	local _richText = ccui.RichText:create()
	_richText:setContentSize(cc.size(richTextWidth, 0))
    _richText:setAnchorPoint(cc.p(0, 0))

    _richText:ignoreContentAdaptWithSize(false)  
     local re1 = ccui.RichElementText:create(1, cc.c3b(0,166,255), 255, tipStringInfo_cross_server_battel_tips[1], Text_buy_times:getFontName(), Text_buy_times:getFontSize())
    _richText:pushBackElement(re1)
    local color = tonumber(self.current_buy_times) <= 0 and cc.c3b(255,0,0) or cc.c3b(0,166,255)
    local re2 = ccui.RichElementText:create(1, color, 255, buy_times_string, Text_buy_times:getFontName(), Text_buy_times:getFontSize())
    _richText:pushBackElement(re2)
	_richText:setPosition(cc.p(-richTextWidth + Text_buy_times:getFontSize(), Text_buy_times:getFontSize() / 2 + 5))
    Text_buy_times:addChild(_richText)

end

function ExplorationShopCell:formatTimeString( _time )--系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function ExplorationShopCell:onUpdate(dt)

end

function ExplorationShopCell:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_shop_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_purchase"), nil, 
	{
		terminal_name = "exploration_shop_cell_buy", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if ExplorationShopCell.__size == nil then
		ExplorationShopCell.__size = panel_size
	end

	self:registerOnNoteUpdate(self, 1)
end

function ExplorationShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ExplorationShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/explore/explore_shop_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExplorationShopCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	local Text_buy_times = ccui.Helper:seekWidgetByName(root, "Text_buy_times")
	-- local Text_Sale = ccui.Helper:seekWidgetByName(root, "Text_Sale")

	if Text_name ~= nil then
		Text_name:setString("")
		Text_5:setString("")
		Panel_6:removeAllChildren(true)
		Panel_icon:removeBackGroundImage()
	end
	if Text_buy_times then
		Text_buy_times:setString("")
		Text_buy_times:removeAllChildren(true)
	end

 --    local Image_sale = ccui.Helper:seekWidgetByName(root, "Image_sale")
	-- if Image_sale ~= nil then
	-- 	Image_sale:setVisible(false)
	-- 	Text_Sale:setString("")
	-- end
end

function ExplorationShopCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/explore/explore_shop_cell.csb", self.roots[1])
end

function ExplorationShopCell:initData()
	-- 物品
	local prop_param = zstring.split(dms.atos(self.shopInfo, 2), ",") 

	local prop = {}
	-- 商品类型
	prop.type = tonumber(prop_param[1])
	-- 类型对应的模板id
	prop.mould_id = tonumber(prop_param[2])
	-- 商品数量
	prop.number = tonumber(prop_param[3])

	-- 道具
	if prop.type == 6 then
		local prop_info = dms.element(dms["prop_mould"], prop.mould_id)
		if prop.mould_name == nil then
			prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	            prop.mould_name = setThePropsIcon(prop.mould_id)[2]
	        end
		end

		if prop.prop_quality == nil then
			prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
		end

		prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			prop.mould_remarks = drawPropsDescription(prop.mould_id)
		end

	-- 武器
	elseif prop.type == 7 then
		prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
        end
        prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
        if prop.prop_quality == 0 then
            prop.prop_quality = 3
        end
        prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
	-- 圣物精华
	elseif prop.type == 69 then
		prop.mould_name = _All_tip_string_info._holy_essence
		prop.prop_quality = 3
		prop.mould_remarks = _All_tip_string_info_description._holy_essence_description
	elseif tonumber(prop.type) == 13 then
    	if prop.prop_quality == nil then
			prop.prop_quality = dms.int(dms["ship_mould"], prop.mould_id, ship_mould.ship_type)+1
		end

		if prop.mould_name == nil then
	        local evo_image = dms.string(dms["ship_mould"], prop.mould_id, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(hero.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], prop.mould_id, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
	        prop.mould_name = word_info[3]
	    end
	end

	--消耗
	local buy_param = zstring.split(dms.atos(self.shopInfo, 3), ",") 
	-- 消耗的货币类型
	prop.sell_type = tonumber(buy_param[1])
	-- 消耗的货币数量
	prop.sale_percentage = tonumber(buy_param[3])

	-- 可购买次数
	self.buy_times = dms.atoi(self.shopInfo, 4)

	self.id = dms.atoi(self.shopInfo, 1)

	-- 已购买次数
	self.current_buy_times = _ED.pokemonExplore.shopInfo.shopBuyTimes[self.id .. ""] or 0
	self.current_buy_times = self.buy_times - self.current_buy_times

	self.prop = prop

end

function ExplorationShopCell:init(params)
	self.shopInfo = params
	self:initData()
	self:onInit()

	if ExplorationShopCell.__size then
		self:setContentSize(ExplorationShopCell.__size)
	end
end

function ExplorationShopCell:createCell()
	local cell = ExplorationShopCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


