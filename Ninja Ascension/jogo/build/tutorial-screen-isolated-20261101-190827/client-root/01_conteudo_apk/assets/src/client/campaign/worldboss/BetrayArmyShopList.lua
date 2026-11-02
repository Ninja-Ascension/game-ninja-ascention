-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军商店list
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyShopList = class("BetrayArmyShopListClass", Window)
    
function BetrayArmyShopList:ctor()
    self.super:ctor()
	app.load("client.campaign.worldboss.WorldBossShopBuyNumber")
	
    self.roots = {}
    self.seatIndex  = 0
    self.count  = 0
    self.shopLimit = 0
    self.shopPrice = 0
    self.shopType = 0
	self.isRefushData = false
	
    -- Initialize BetrayArmyShopList page state machine.
    local function init_betray_army_shop_list_terminal()
		local betray_army_shop_prop_buy_terminal = {
            _name = "betray_army_shop_prop_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params._datas._target:onBuy()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local betray_army_refresh_shop_prop_buy_list_terminal = {
            _name = "betray_army_refresh_shop_prop_buy_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params._target:refushData()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(betray_army_refresh_shop_prop_buy_list_terminal)
		state_machine.add(betray_army_shop_prop_buy_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_betray_army_shop_list_terminal()
end



function BetrayArmyShopList:getPropCell(count)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = self.mid
	cellConfig.touchShowType = 1
	cellConfig.isDebris = true
	cellConfig.count = count
	cell:init(cellConfig)
	return cell
end


function BetrayArmyShopList:getShipCell()
	app.load("client.cells.ship.ship_head_cell")
	local cell = ShipHeadCell:createCell()
	cell:init(nil,12,self.mid,1)
	return cell
end

function BetrayArmyShopList:getEquipmentCell()	
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = self.mid
	cellConfig.touchShowType = 1
	cellConfig.mouldType = 7
	cell:init(cellConfig)
	return cell
end

function BetrayArmyShopList:onBuy()
	if TipDlg.drawStorageTipo({2}) == false then
		-- 检查价钱 够不够
		if self.prestigeprice > zstring.tonumber(_ED.user_info.exploit) then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				state_machine.excute("shortcut_function_silver_to_get_open",0,7)
			else
				TipDlg.drawTextDailog(tipStringInfo_betrayArmy_info[2])
			end
			
			return
		end
		
		-- 检查额外道具够不
		if self.redDebrisNum > zstring.tonumber(getPropAllCountByMouldId(self.redDebrisMID)) then
			TipDlg.drawTextDailog(tipStringInfo_betrayArmy_info[4])
			
			return
		end

		
		local config = {
			mid 	= self.mid,
			count 	= self.count,
			gtype 	= self.getCellType,
			quality = self.quality,
			name 	= self.iconName,
			existingDebris = self.existingDebris,
			price 	= self.prestigeprice,
			money 	= zstring.tonumber(_ED.user_info.exploit),
			maxBuyNum = zstring.tonumber(self.limit),
			indexId = self.index,
			redDebrisNum = self.redDebrisNum,
			redDebrisMID = self.redDebrisMID,
			_target = self, --用于刷新该条数据
			originType = 0,
		}

		local ntip = WorldBossShopBuyNumber:createCell()
		ntip:init(config)
		fwin:open(ntip, fwin._windows)
	end
end

function BetrayArmyShopList:onUpdateDraw()
	local root = self.roots[1]
	local shop = dms["rebel_army_shop_mould"]
	local prop = dms["prop_mould"]
	local equipment = dms["equipment_mould"]
	local ship = dms["ship_mould"]

	
	-- 当前索引实例id
	self.index = self.itmeInstance.commodity_id
	
	-- 模板id
	self.mid = dms.int(shop, self.index, rebel_army_shop_mould.shop_id)
	
	
	--icon
	local iconIndex = ""
	
	--name
	local name = ""
	
	--品质颜色
	local quality = 0
	
	--战功数
	local prestige = dms.int(shop, self.index, rebel_army_shop_mould.sell_price)
	self.prestigeprice = prestige
	--已拥有碎片数
	local existingDebris = nil
	
	--需要的碎片数
	local neededDebris = nil
	
	--碎片数
	local debrisString = "(%d/%d)"
	
	-- 售卖的数量 
	local count = dms.int(shop, self.index, rebel_army_shop_mould.sell_count)
	
	--今日可购买数
	local limit = dms.int(shop, self.index, rebel_army_shop_mould.total_limit)
	if limit > 0 then
		local yetCount = getBetrayArmyShopLimitCount(self.index) --获取当前限定购买中 已经购买过的
		limit = math.max(limit - yetCount, 0)
	end
	self.limit =limit
	
	--类型 0道具 1 武将 2装备
	local ptype = dms.int(shop, self.index, rebel_army_shop_mould.shop_type)
	
	--是否有需要额外道具的(红碎片)
	local redDebrisMID = dms.int(shop, self.index, rebel_army_shop_mould.extra_prop)
	self.redDebrisMID = redDebrisMID
	
	--是否有需要额外道具的(红碎片)数量
	local redDebrisNum = dms.int(shop, self.index, rebel_army_shop_mould.extra_prop_count)
	self.redDebrisNum = redDebrisNum
	
	local cell = nil
	local cellType = -1
	if ptype == 0 then
		
		quality 	= dms.int(prop, self.mid, prop_mould.prop_quality)+1
		name 		= dms.string(prop, self.mid, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            name = setThePropsIcon(self.mid)[2]
        end
		if count <= 1 then
			count = nil
		end
		
		cell = self:getPropCell(count)
		
		-- 是否碎片
		if getIsPropDebris(self.mid) then
			--获取 需要的碎片,并去遍历已有的碎片
			neededDebris = dms.int(prop, self.mid, prop_mould.split_or_merge_count)
			
			existingDebris = getPropAllCountByMouldId(self.mid)
			
			self.existingDebris = existingDebris
		end
		
		cellType = 6

	elseif ptype == 1 then
		quality 	= dms.int(ship, self.mid, ship_mould.ship_type)+1
		name 		= dms.string(ship, self.mid, ship_mould.captain_name)
		
		if false ==  self.isRefushData then
			cell = self:getShipCell()
		end
		
		cellType = 13
		
	elseif ptype == 2 then
		quality 	= dms.int(equipment, self.mid, equipment_mould.grow_level)+1
		name 		= dms.string(equipment, self.mid, equipment_mould.equipment_name)
		
		if false ==  self.isRefushData then
			cell = self:getEquipmentCell()
		end
		
		cellType = 7
		
	elseif ptype == -1 then
		-- 不会有 -1类型
	end
	
	self.getCellType = cellType
	self.iconName = name
	
	self.quality = quality
	self.count = count
	if nil ~= cell then
		if false ==  self.isRefushData then
			ccui.Helper:seekWidgetByName(root, "Panel_3"):addChild(cell)
		end
	end
	
	--name
	ccui.Helper:seekWidgetByName(root, "Text_20"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Text_20"):setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	
	--战功
	ccui.Helper:seekWidgetByName(root, "Text_22"):setString(tostring(prestige))
	--额外道具和数量
	if zstring.tonumber(redDebrisMID) > 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_21_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_22_16"):setString(redDebrisNum)
	else
		ccui.Helper:seekWidgetByName(root, "Panel_21_1"):setVisible(false)
	end
	
	--碎片数
	if nil ~= existingDebris and nil ~= neededDebris then
		debrisString = string.format(debrisString, existingDebris, neededDebris)
		ccui.Helper:seekWidgetByName(root, "Text_21"):setString(debrisString)
	end
	
	local isShowBuy = false
	--优先判定星级是否够
	--再判定限定个数是否够
	local starValue = nil

	if limit == -1 then
		isShowBuy = true
	elseif limit > 0 then
		isShowBuy = true
		starValue = string.format(tipStringInfo_betrayArmy_info[1], limit)
	else
		isShowBuy = false
		starValue = string.format(tipStringInfo_betrayArmy_info[3])
	end
	
	
	if nil ~= starValue then
		ccui.Helper:seekWidgetByName(root, "Text_23"):setString(starValue)
	end

	local buyBtn = ccui.Helper:seekWidgetByName(root, "Button_6")
	--购买按钮
	if true == isShowBuy then
		
		if false ==  self.isRefushData then
		
			fwin:addTouchEventListener(buyBtn, nil, 
			{
				terminal_name = "betray_army_shop_prop_buy", 
				terminal_state = 0, 
				_instance = self,
				_target = self,
			}, 
			nil, 0)	
		
		end
	else
		buyBtn:setBright(false)
		buyBtn:setTouchEnabled(false)
	end
end

function BetrayArmyShopList:refushData()
	-- 主要是更新 已拥有碎片
	-- 今日可购买次数
	self.isRefushData = true
	self:onUpdateDraw()
end

function BetrayArmyShopList:onEnterTransitionFinish()
	
	local csbBetrayArmyShopListFriend = csb.createNode("campaign/WorldBoss/worldBoss_shop_list.csb")
	self:addChild(csbBetrayArmyShopListFriend)
	local root = csbBetrayArmyShopListFriend:getChildByName("root")
	table.insert(self.roots, root)
	
	self:setContentSize(root:getChildByName("Panel_20"):getContentSize())
	
	local action = csb.createTimeline("campaign/WorldBoss/worldBoss_shop_list.csb") 
    root:runAction(action)
    action:play("list_view_cell_open", false)
	
	
	self:onUpdateDraw()
	
end


function BetrayArmyShopList:onExit()
	state_machine.remove("betray_army_shop_prop_buy")
	--state_machine.remove("refresh_honor_content")
end

function BetrayArmyShopList:init(index,itmeInstance)
	self.seatIndex = index -- 无效值
	self.itmeInstance = itmeInstance
	
end

function BetrayArmyShopList:createCell()
	local cell = BetrayArmyShopList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end