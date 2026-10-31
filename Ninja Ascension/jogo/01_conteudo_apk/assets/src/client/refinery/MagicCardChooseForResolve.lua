-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面魔陷卡分解界面
-- 创建时间
-------------------------------------------------------------------------------------------------------
MagicCardChooseForResolve = class("MagicCardChooseForResolveClass", Window)

function MagicCardChooseForResolve:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self.sortShip = {}
	self.selectMaxCount = 5
	self.selectCount = 0

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
    app.load("client.magicCard.MagicTrupCardCell")

    -- Initialize MagicCardChooseForResolve page state machine.
    local function init_magic_card_choose_terminal()
		-- 关闭
		local magic_card_choose_resolve_page_close_terminal = {
            _name = "magic_card_choose_resolve_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ships = {}
				local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
				local cells = ListView_1:getItems()
		
				for i, cell in pairs(cells) do
					if cell.status == true then
						table.insert(ships, cell.cardInfo)
					end
				end
				state_machine.excute("magic_card_resolve_update_info", 0, {_datas = {needShipInfo = ships}})
		
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 关闭
		local magic_card_choose_resolve_close_terminal = {
            _name = "magic_card_choose_resolve_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				state_machine.excute("magic_card_choose_resolve_page_close", 0, 0)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择分解魔陷卡
        local magic_card_sell_true_update_reslove_terminal = {
            _name = "magic_card_sell_true_update_reslove",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local counts = zstring.tonumber(params.counts)
				if counts > 0 and instance.selectCount >= instance.selectMaxCount then
					TipDlg.drawTextDailog(_string_piece_info[53])
					return true
				end
				instance.selectCount = instance.selectCount + counts
				params._cell:setSelected(counts > 0)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xzwj_2"):setString(instance.selectCount)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        
		state_machine.add(magic_card_choose_resolve_page_close_terminal)
		state_machine.add(magic_card_choose_resolve_close_terminal)
		state_machine.add(magic_card_sell_true_update_reslove_terminal)
        state_machine.init()
    end
    
    init_magic_card_choose_terminal()
end

function MagicCardChooseForResolve.loading(texture)
	local myListView = MagicCardChooseForResolve.myListView
	if myListView ~= nil then
		local cell = MagicTrupCardCell:CreateCell():init(MagicCardChooseForResolve.asyncIndex, 3, MagicCardChooseForResolve.sortShip[MagicCardChooseForResolve.asyncIndex],true)
		
		myListView:addChild(cell)
		MagicCardChooseForResolve.asyncIndex = MagicCardChooseForResolve.asyncIndex + 1
		-- myListView:requestRefreshView()

		for i, ship in pairs(MagicCardChooseForResolve._self.ships) do
			if zstring.tonumber(ship.id) == zstring.tonumber(cell.cardInfo.id) then
				cell.status = true
				cell:reload()
				cell:setSelected(true)
			end
		end
	end
end

function MagicCardChooseForResolve:onUpdateDraw()
	local root = self.roots[1]
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	
	MagicCardChooseForResolve._self = self
	MagicCardChooseForResolve.myListView = ListView_1
	
	MagicCardChooseForResolve.asyncIndex = 1
	self.sortShip = {}
	local function sortTable( a, b )
       return a.card_type > b.card_type
    end
 	for k,prop in pairs(_ED.user_magic_trap_info) do
 		if _ED.magicCard_formation[zstring.tonumber(prop.id)] == nil then 
 			local cardType = dms.int(dms["magic_trap_card_info"],prop.base_mould,magic_trap_card_info.card_type)
	    	prop.card_type = cardType
	    	if  cardType ~= nil then 
	    		table.insert(self.sortShip,prop)
	    	end
 		end
    end
    table.sort(self.sortShip, sortTable )

	MagicCardChooseForResolve.sortShip = self.sortShip
	for i, v in ipairs(self.sortShip) do
	
		self.loading(nil)
	end
	ListView_1:requestRefreshView()

	self.currentListView = ListView_1
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	

	ccui.Helper:seekWidgetByName(root, "Panel_xzwj_choose"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Panel_wj"):setVisible(false)
end

function MagicCardChooseForResolve:onUpdate(dt)
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


function MagicCardChooseForResolve:onEnterTransitionFinish()
	local csbHeroChoose = csb.createNode("packs/magic_card_sell.csb")
    local root = csbHeroChoose:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)

	self:onUpdateDraw()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "magic_card_choose_resolve_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xzwj_qd"), nil, 
	{
		terminal_name = "magic_card_choose_resolve_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	},
	nil, 2)
end

function MagicCardChooseForResolve:onExit()
	state_machine.excute("menu_show_event", 0, "menu_show_event.")
	MagicCardChooseForResolve.myListView = nil
	MagicCardChooseForResolve.asyncIndex = 1
	state_machine.remove("magic_card_choose_resolve_sort")
	state_machine.remove("magic_card_choose_resolve_page_close")
	state_machine.remove("magic_card_choose_resolve_close")
	state_machine.remove("hero_resolve_page_check_conut")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function MagicCardChooseForResolve:init(ships)
	self.ships = ships
	self.selectCount = #ships
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
end
