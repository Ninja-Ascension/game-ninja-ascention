----------------------------------------------------------------------------------------------------
-- 说明：文件岛商店cell
----------------------------------------------------------------------------------------------------
TreasureShopWindowCell = class("TreasureShopWindowCellClass", Window)
TreasureShopWindowCell.__size = nil

function TreasureShopWindowCell:ctor()
    self.super:ctor()

	self.roots = {}
	self.prop = nil
	self.actions = {}
	app.load("client.cells.utils.resources_icon_cell")

	local function init_treasure_shop_cell_terminal()
		local treasure_shop_cell_buy_terminal = {
            _name = "treasure_shop_cell_buy",
            _init = function (terminal)
            	app.load("client.activity.treasure.TreasureShopBuy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local isOpenPopWindow = true
				if isOpenPopWindow then
					local cell = params._datas._cell
					local params = json.decode(_ED.active_activity[148].activity_params)
					local all_money = tonumber(params.score)

					if tonumber(all_money) < tonumber(cell.prop.sale_percentage) then
						TipDlg.drawTextDailog(tipStringInfo_pokemon_treasure_tips[5])
						return
					end
					--这里添加兑换弹窗
					app.load("client.packs.prop.ComExchange")
					state_machine.excute("com_exchange_use_open",0,cell)
				else
					local cell = params._datas._cell
					state_machine.excute("treasure_shop_buy_open", 0, cell)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(treasure_shop_cell_buy_terminal)
        state_machine.init()
	end

	init_treasure_shop_cell_terminal()
end


function TreasureShopWindowCell:onUpdateDraw()
	local Text_name = self.Text_props_name
	local Text_5 = self.Text_rare_treasure_in
	local Panel_6 = self.Panel_props_icon

	Text_name:setString(self.prop.mould_name .. "*" .. self.prop.number)
	local quality = tonumber(self.prop.prop_quality)
	Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

	Text_5:setString(self.prop.sale_percentage)

	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		cell:init(tonumber(self.prop.type), 0, tonumber(self.prop.mould_id), nil, nil, nil, true, nil, {equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type), 0, tonumber(self.prop.mould_id), nil, nil, nil, true)
	end

	Panel_6:addChild(cell)
	Panel_6:setVisible(true)
	Panel_6:setTouchEnabled(false)

	local panel = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	--panel:setTouchEnabled(false)

	local buy_times_string = self.current_buy_times .. "/" .. self.buy_times

	local Text_buy_times = self.Text_integral_all_n
	if tonumber(self.buy_times) == -1 then
		Text_buy_times:setString(tipStringInfo_pokemon_treasure_tips[6])
	else
		Text_buy_times:setString(buy_times_string)
	end
	
end

function TreasureShopWindowCell:formatTimeString( _time )--系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function TreasureShopWindowCell:onUpdate(dt)

end

function TreasureShopWindowCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/rare_treasure_shop_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_rare_treasure_shop"), nil, 
	{
		terminal_name = "treasure_shop_cell_buy", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	self.Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
	self.Text_rare_treasure_in = ccui.Helper:seekWidgetByName(root, "Text_rare_treasure_in")
	self.Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
	self.Text_integral_all_n = ccui.Helper:seekWidgetByName(root, "Text_integral_all_n")


	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if TreasureShopWindowCell.__size == nil then
		TreasureShopWindowCell.__size = panel_size
	end

	self:registerOnNoteUpdate(self, 1)
end

function TreasureShopWindowCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function TreasureShopWindowCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/rare_treasure_shop_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function TreasureShopWindowCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_rare_treasure_in")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
	local Text_buy_times = ccui.Helper:seekWidgetByName(root, "Text_integral_all_n")
	-- local Text_Sale = ccui.Helper:seekWidgetByName(root, "Text_Sale")

	if Text_name ~= nil then
		Text_name:setString("")
		Text_5:setString("")
		Panel_6:removeAllChildren(true)
	end
	if Text_buy_times then
		Text_buy_times:setString("")
	end
end

function TreasureShopWindowCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/rare_treasure_shop_cell.csb", self.roots[1])
end

function TreasureShopWindowCell:initData()
	local params = json.decode(_ED.active_activity[148].activity_params)
	self.allScore = params.score
	local buyInfo = params.shopInfo
	-- 物品
	local prop_param = zstring.split(self.shopInfo.item, ",") 

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
	elseif tonumber(prop.type) == 7 then
	   local prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
        end
        prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
        if prop.prop_quality == 0 then
            prop.prop_quality = 3
        end
        prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
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
	elseif tonumber(prop.type) == 71 then 
			prop.prop_quality = dms.int(dms["ship_silk_bag_mould"], prop.mould_id, ship_silk_bag_mould.quality_level)
			--获取锦囊名称索引
			local nameindex = dms.int(dms["ship_silk_bag_mould"], prop.mould_id, equipment_mould.equipment_name)
			--通过锦囊索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]
			--绘制
			prop.mould_name = names	
	else
		if prop.prop_quality == nil then
			prop.prop_quality = 0
		end
		if prop.mould_name == nil then
	        prop.mould_name = _All_tip_string_info._fundName
	    end
	end
	--需要消耗的积分
	local buy_num = tonumber(self.shopInfo.score)
	-- 消耗的积分数量
	prop.sale_percentage = buy_num
	-- 最大可购买次数
	self.buy_times = tonumber(self.shopInfo.num)
	-- 已购买次数
	self.current_buy_times = buyInfo[self.id .. ""] or 0
	-- 还可以购买的次数
	self.current_buy_times = self.buy_times - self.current_buy_times
	--当前积分可以购买的次数
	local may_num = math.floor(self.allScore / buy_num )
	prop.prop_number = self.current_buy_times
	if may_num < self.current_buy_times or self.buy_times == -1 then
		prop.prop_number = may_num
	end
	prop.id = self.id
	self.prop = prop
end

function TreasureShopWindowCell:init(params)
	self.shopInfo = params[1]
	self.id = params[2]
	self.form_cell = "treasure_shop_cell"  --来自秘宝cell
	self:initData()
	self:onInit()

	if TreasureShopWindowCell.__size then
		self:setContentSize(TreasureShopWindowCell.__size)
	end
end

function TreasureShopWindowCell:createCell()
	local cell = TreasureShopWindowCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


