-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军商店主界面
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyShop = class("BetrayArmyShopClass", Window)
    
function BetrayArmyShop:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions={}

	self.MylistViewCell = nil
	self.preMultipleCell = nil
	app.load("client.campaign.worldboss.BetrayArmyShopList")
	self.cacheListView = nil	
    -- Initialize BetrayArmyShop page state machine.
    local function init_world_boss_terminal()
	
		local betray_army_shop_back_terminal = {
            _name = "betray_army_shop_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--购买
		local betray_army_refresh_honor_content_terminal = {
            _name = "betray_army_refresh_honor_content",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawOne()
				state_machine.excute("world_boss_refresh_honor", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(betray_army_refresh_honor_content_terminal)
		state_machine.add(betray_army_shop_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end


function BetrayArmyShop:onUpdateDrawOne()
	local root = self.roots[1]
	local ExploitText = ccui.Helper:seekWidgetByName(root, "Text_wb_3")
	ExploitText:setString(_ED.user_info.exploit)
end
function BetrayArmyShop:onUpdateDraw()
	local root = self.roots[1]
	local shopListView = ccui.Helper:seekWidgetByName(root, "ListView_1")

	local list = {}
	local empty = {}
	for i , v in ipairs(_ED.rebel_exploit_shop.shop_info) do
		local visibleLevel = dms.int(dms["rebel_army_shop_mould"], v.commodity_id, rebel_army_shop_mould.visible_level)
		local totalLimit = dms.int(dms["rebel_army_shop_mould"], v.commodity_id, rebel_army_shop_mould.total_limit)
		-- 1. 过滤掉 当前不可显示的
		if visibleLevel == nil then
			visibleLevel = 30
		end
		if tonumber(_ED.user_info.user_grade) >=  visibleLevel then
			v._goodsIndex = i
			if totalLimit == -1 or totalLimit - getBetrayArmyShopLimitCount(v.commodity_id) > 0 then
				table.insert(list, v)
			else
				table.insert(empty, v)
			end
		end
	end
	-- 2. 将购买已达上限的,移到末尾
	for i = 1 , table.getn(empty) do
		table.insert(list, empty[i])
	end
	BetrayArmyShop.shopInfo = list

	local length = table.getn(BetrayArmyShop.shopInfo)
	if length > 0 then
		-- 填充开始
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		BetrayArmyShop.asyncIndex = 1
		BetrayArmyShop.cacheListView = shopListView 
		
		for i, v in ipairs(BetrayArmyShop.shopInfo) do
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
		
	end
end

function BetrayArmyShop:loading_cell()
	if BetrayArmyShop.cacheListView == nil then
		return 
	end
	local data = BetrayArmyShop.shopInfo
	local item = data[BetrayArmyShop.asyncIndex]

	local cell = BetrayArmyShopList:createCell()
	cell:init(nil,item)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--双列表				
		app.load("client.cells.utils.multiple_list_view_cell")
		if self.MylistViewCell == nil then
			self.MylistViewCell = MultipleListViewCell:createCell()
			self.MylistViewCell:init(BetrayArmyShop.cacheListView, cc.size(440,148))
			BetrayArmyShop.cacheListView:addChild(self.MylistViewCell)
			self.MylistViewCell.prev = self.preMultipleCell
			if self.preMultipleCell ~= nil then
				self.preMultipleCell.next = self.MylistViewCell
			end
		end
		self.MylistViewCell:addNode(cell)
		if self.MylistViewCell.child2 ~= nil then
			self.preMultipleCell = self.MylistViewCell
			self.MylistViewCell = nil
		end

	else
		BetrayArmyShop.cacheListView:addChild(cell)
	end
	BetrayArmyShop.cacheListView:requestRefreshView()
	BetrayArmyShop.asyncIndex = BetrayArmyShop.asyncIndex + 1
end
function BetrayArmyShop:onEnterTransitionFinish()
	
	local csbBetrayArmyShopFriend = csb.createNode("campaign/WorldBoss/worldBoss_shop.csb")
	self:addChild(csbBetrayArmyShopFriend)
	local root = csbBetrayArmyShopFriend:getChildByName("root")
	table.insert(self.roots, root)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert  then
		local action = csb.createTimeline("campaign/WorldBoss/worldBoss_shop.csb") 
		table.insert(self.actions, action )
		csbBetrayArmyShopFriend:runAction(action)
		action:play("window_open", false)
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wb_shop"), nil, 
		{
		terminal_name = "betray_army_shop_back",
		terminal_state = 0,
		isPressedActionEnabled = true
		}, nil, 0)
	self:onUpdateDraw()
	self:onUpdateDrawOne()
	
	app.load("client.player.UserTopInfoA") 
	self.userInfo = UserTopInfoA:new()
	fwin:open(self.userInfo,fwin._view)
end

function BetrayArmyShop:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:close(self.userInfo)
	end
end

function BetrayArmyShop:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then

	else
		fwin:close(self.userInfo)
	end
	state_machine.remove("betray_army_shop_back")
	state_machine.remove("refresh_honor_content")
	BetrayArmyShop.shopInfo = nil
	BetrayArmyShop.asyncIndex = 1
	BetrayArmyShop.cacheListView = nil
end