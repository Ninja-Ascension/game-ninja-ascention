-- ----------------------------------------------------------------------------------------------------
-- 说明：重生魔陷卡选择
-------------------------------------------------------------------------------------------------------
MagicCardChooseForReborn = class("MagicCardChooseForRebornClass", Window)
	
function MagicCardChooseForReborn:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
    
    app.load("client.magicCard.MagicTrupCardCell")
    -- Initialize MagicCardChooseForReborn page state machine.
    local function init_MagicCardChooseForReborn_terminal()
		-- 关闭
		local magic_card_choose_reborn_close_terminal = {
            _name = "magic_card_choose_reborn_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				state_machine.excute("menu_show_event", 0, "menu_show_event.")
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(magic_card_choose_reborn_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_MagicCardChooseForReborn_terminal()
end

function MagicCardChooseForReborn:sortHerosForRebornFun()
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_magic_trap_info) do
			if _ED.magicCard_formation[zstring.tonumber(v.id)] == nil then 
				--没有上阵
				local startLevel = dms.int(dms["magic_trap_card_info"],v.base_mould,magic_trap_card_info.current_star)
				local cardType = dms.int(dms["magic_trap_card_info"],v.base_mould,magic_trap_card_info.card_type)
				local strongLevel = zstring.tonumber(v.strong_level)
				if cardType ~= nil and (startLevel > 0 or strongLevel > 0) then 
					v.card_type = cardType
					table.insert(list,v)
				end
			end
			
		end
		return list
	end
	
	local function compare(a, b)
		return a.card_type > b.card_type
	end
	local cardList = chooseHero()
	table.sort( cardList, compare)
	return cardList
end

function MagicCardChooseForReborn:onUpdate(dt)
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
function MagicCardChooseForReborn.loading(texture)
	local myListView = MagicCardChooseForReborn.myListView
	if myListView ~= nil then
		local cell = MagicTrupCardCell:CreateCell():init(MagicCardChooseForReborn.asyncIndex, 4, MagicCardChooseForReborn.sortHerosForReborn[MagicCardChooseForReborn.asyncIndex],false)
		myListView:addChild(cell)
		MagicCardChooseForReborn.asyncIndex = MagicCardChooseForReborn.asyncIndex + 1
		myListView:requestRefreshView()
	end
end

function MagicCardChooseForReborn:onUpdateDraw()
	local ListView_wjcs = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_wjcs")

	MagicCardChooseForReborn.myListView = ListView_wjcs
	MagicCardChooseForReborn.sortHerosForReborn = self:sortHerosForRebornFun()
	MagicCardChooseForReborn.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)

	self.currentListView = ListView_wjcs
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	for i, v in ipairs(MagicCardChooseForReborn.sortHerosForReborn) do
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
	end
end

function MagicCardChooseForReborn:onEnterTransitionFinish()
	local csbMagicCardChooseForReborn = csb.createNode("packs/HeroStorage/generals_renascence.csb")
	self:addChild(csbMagicCardChooseForReborn)
	local root = csbMagicCardChooseForReborn:getChildByName("root_1")
	table.insert(self.roots, root)
	
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
	self:onUpdateDraw()
	
	ccui.Helper:seekWidgetByName(root, "Text_zizhi"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_card_cs"):setVisible(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wjcs_fanhui"), nil, 
	{
		terminal_name = "magic_card_choose_reborn_close", 
		isPressedActionEnabled = true
	}, 
	nil, 2)
end

function MagicCardChooseForReborn:onExit()
	MagicCardChooseForReborn.myListView = nil
	MagicCardChooseForReborn.asyncIndex = 1
	state_machine.remove("magic_card_choose_reborn_close")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end