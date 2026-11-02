---------------------------------
---魔法卡出售
---------------------------------

MagicCardSell = class("MagicCardSellClass", Window)
   
function MagicCardSell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.data = {}
	self.selNum = 0 --卖出个数
	self.selMoney = 0
	self.sortShip = nil
	self.status = false
	self.isCanSell = true -- 能否出售 没有商品不能出售
	self.index = 0 
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	
    local function init_magic_card_terminal()
 		local magic_card_sell_return_page_terminal = {
            _name = "magic_card_sell_return_page",
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
		
	
		local magic_card_sell_sure_sell_terminal = {
            _name = "magic_card_sell_sure_sell",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroSellTipTwo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isCanSell == false then 
					TipDlg.drawTextDailog(_magic_card_tip[2])
					return
				end
				local root = instance.roots[1]
				local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
				local items = listView:getItems()
				local num = 1
				instance.data = {}
				local status = false

				for i, v in pairs(items) do
					local cell = v
					local cardData = cell.cardInfo
					
					if cell.status == true then
						instance.data[num] = cardData
						num = num + 1
						
					end
				end
			
				if num == 1 then
					TipDlg.drawTextDailog(_magic_card_tip[1])
					return
				end	
					
				app.load("client.packs.hero.HeroSellTip")
				local heroSellTip = HeroSellTip:new()
				heroSellTip:init(instance.data,2)
				fwin:open(heroSellTip, fwin._dialog)
				
				
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		local magic_card_sell_true_update_cell_status_terminal = {
            _name = "magic_card_sell_true_update_cell_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:cleanListView()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择魔法卡后刷新出售价格
		local magic_card_sell_true_update_price_terminal = {
            _name = "magic_card_sell_true_update_price",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateSellInfo1()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(magic_card_sell_return_page_terminal)
		state_machine.add(magic_card_sell_sure_sell_terminal)
		state_machine.add(magic_card_sell_true_update_cell_status_terminal)
		state_machine.add(magic_card_sell_true_update_price_terminal)
		state_machine.init()
    end
    
    init_magic_card_terminal()
end

function MagicCardSell:cleanListView()
	local root = self.roots[1]
	if root == nil then 
		return
	end

	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local items = listView:getItems()
	for i, v in pairs(items) do
		if v.status == true then
			listView:removeItem(listView:getIndex(v))
		end
	end
		
	self.selNum = 0
	self.selMoney = 0
	self:updateSellInfo()
	self.data = {}
	local item = listView:getItems()
	local tip = false
	for i, v in pairs(item) do
		if v.status == true then 
			listView:removeItem(v)
		end
	end
	listView:requestRefreshView()
	
end

function MagicCardSell:init(index)
	self.index = index
	return self
end
function MagicCardSell:updateSellInfo()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_wjshul"):setString(""..self.selNum)
	ccui.Helper:seekWidgetByName(root, "Text_wjjiag"):setString(""..self.selMoney)
end

function MagicCardSell:updateSellInfo1()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local items = listView:getItems()
	local num = 0

	local price = 0
	for i, v in pairs(items) do
		local cell = v
		local cardData = cell.cardInfo
		if cell.status == true then
			num = num + 1
			price = price + dms.int(dms["prop_mould"], cardData.user_prop_template, prop_mould.silver_price)
			
		end
	end
	ccui.Helper:seekWidgetByName(root, "Text_wjshul"):setString(""..num)
	ccui.Helper:seekWidgetByName(root, "Text_wjjiag"):setString(""..price)
end

function MagicCardSell:onUpdateDraw()
	local root = self.roots[1]
	self.isCanSell = true
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.asyncIndex = 1
	if self.index == 0 then 
		--出售魔法卡
		for i,prop in pairs(_ED.user_magic_trap_info) do
	        local cardType = dms.int(dms["magic_trap_card_info"],prop.base_mould,magic_trap_card_info.card_type)
	        if card_type == 0  then 
    	      	if _ED.magicCard_formation[zstring.tonumber(prop.id)] == nil then 
            
			        local cell = MagicTrupCardCell:CreateCell():init(self.asyncIndex, 1, prop,true)
			        listView:addChild(cell)
			        listView:requestRefreshView()
			        self.asyncIndex = self.asyncIndex + 1
			    end
		    end
		end
		if self.asyncIndex == 1 then 
			self.isCanSell = false
		end
	else
		--出售陷阱卡
	
		for i,prop in pairs(_ED.user_magic_trap_info) do
	        local cardType = dms.int(dms["magic_trap_card_info"],prop.base_mould,magic_trap_card_info.card_type)
	        if card_type == 1  then 
            	--if _ED.magicCard_formation[zstring.tonumber(prop.id)] == nil then 
			        local cell = MagicTrupCardCell:CreateCell():init(self.asyncIndex, 2, prop,true)
			        listView:addChild(cell)
			        listView:requestRefreshView()
			        self.asyncIndex = self.asyncIndex + 1
			    --end
		    end
		end
		if self.asyncIndex == 1 then 
			self.isCanSell = false
		end
	end
	listView:requestRefreshView()

	self.currentListView = listView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

end

function MagicCardSell:onUpdate(dt)
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
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

function MagicCardSell:onEnterTransitionFinish()
    local csbHeroSell = csb.createNode("packs/magic_card_sell.csb")
    self:addChild(csbHeroSell)
	
	local root = csbHeroSell:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, {func_string = [[state_machine.excute("magic_card_sell_return_page", 0, 0)]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {func_string = [[state_machine.excute("magic_card_sell_sure_sell", 0, "click hero_sell_sure_sell.'")]], 
									isPressedActionEnabled = true}, nil, 0)
		
	self:onUpdateDraw()
	self:updateSellInfo()
end

function MagicCardSell:onExit()
	MagicCardSell.myListView = nil
	MagicCardSell.asyncIndex = 1
	state_machine.remove("magic_card_sell_return_page")
	
	state_machine.remove("magic_card_sell_sure_sell")
	state_machine.remove("card_sell_true_update_cell_status")
	-- state_machine.remove("hero_sell_update_cell_status")
	
	
end