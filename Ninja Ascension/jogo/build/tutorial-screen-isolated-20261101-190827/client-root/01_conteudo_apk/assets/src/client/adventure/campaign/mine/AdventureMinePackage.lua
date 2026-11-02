-- ----------------------------------------------------------------------------------------------------
-- 说明：矿山仓库
-------------------------------------------------------------------------------------------------------
AdventureMinePackage = class("AdventureMinePackageClass", Window)
    
function AdventureMinePackage:ctor()
    self.super:ctor()
    self.roots = {}
	self.index = 1
	app.load("client.adventure.cells.mine.adventure_mine_mineral_bag_cell")
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
    -- Initialize adventure mine package state machine.
    local function init_adventure_mine_package_terminal()
        -- 矿石
        local adventure_mine_package_mine_ore_terminal = {
            _name = "adventure_mine_package_mine_ore",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.index = 1
				instance:onUpdateDrawList()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 矿工包
        local adventure_mine_package_miners_package_terminal = {
            _name = "adventure_mine_package_miners_package",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.index = 2
				instance:onUpdateDrawList()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mine_package_mine_ore_terminal)
        state_machine.add(adventure_mine_package_miners_package_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mine package state machine.
    init_adventure_mine_package_terminal()
end

function AdventureMinePackage:init(index)
    self.index = index
	return self
end

function AdventureMinePackage:onUpdateDrawList()
	local root = self.roots[1]
	local myPanelOne = ccui.Helper:seekWidgetByName(root, "Panel_12")
	local myPanelTwo = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local mylist = ccui.Helper:seekWidgetByName(root, "ListView_2")
	local button_one =ccui.Helper:seekWidgetByName(root, "Button_kshi")
	local button_two =ccui.Helper:seekWidgetByName(root, "Button_kgbao")
	if tonumber(self.index) == 1 then
		button_one:setTouchEnabled(false)
		button_one:setHighlighted(true)
		button_two:setTouchEnabled(true)
		button_two:setHighlighted(false)
        button_two:setColor(cc.c3b(150, 150, 150))
        button_one:setColor(cc.c3b(255, 255, 255))
        -- 修改层级关系
        button_two:getParent():reorderChild(button_two, 0)
        button_one:getParent():reorderChild(button_one, 10)
		myPanelOne:setVisible(true)
		myPanelTwo:setVisible(false)


        local prop_list = {}
        for i,w in pairs(_ED.user_prop) do
            local moulddatas = dms.element(dms["prop_mould"], w.user_prop_template)
            if dms.atoi(moulddatas, prop_mould.storage_page_index) == 3 then
                prop_list["" .. w.user_prop_template] = tonumber(w.prop_number)
            end
        end
		local config = zstring.split(dms.string(dms["pirates_config"], 302, pirates_config.param), "|")
		local propPokedexList = zstring.split(_ED.mine_prop_list_info, "|")
		for i=1,#config do
			local propIdlist = zstring.split(config[i], ",")
			for j,v in pairs(propIdlist) do
				local cell = adventureNewSmallPropIconCell:createCell()
				if prop_list[v] ~= nil and prop_list[v] > 0 then
					cell:init(0, {mould_id = propIdlist[j]} ,nil,nil,prop_list[v],0)
				else

					cell:init(0, {mould_id = propIdlist[j]} ,nil,nil,0,0)
				end
				if i== 1 then
					ccui.Helper:seekWidgetByName(root, "Panel_low"):getChildByName("Panel_prop_"..j):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(root, "Panel_low"):getChildByName("Panel_prop_"..j):addChild(cell)
				elseif i == 2 then
					ccui.Helper:seekWidgetByName(root, "Panel_mid"):getChildByName("Panel_prop_"..j):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(root, "Panel_mid"):getChildByName("Panel_prop_"..j):addChild(cell)
				elseif i == 3 then
					ccui.Helper:seekWidgetByName(root, "Panel_high"):getChildByName("Panel_prop_"..j):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(root, "Panel_high"):getChildByName("Panel_prop_"..j):addChild(cell)
				end
			end
		end
		
	else
		mylist:removeAllItems()
		button_one:setTouchEnabled(true)
		button_one:setHighlighted(false)
        button_one:setColor(cc.c3b(150, 150, 150))
        button_two:setColor(cc.c3b(255, 255, 255))
        -- 修改层级关系
        button_two:getParent():reorderChild(button_two, 10)
        button_one:getParent():reorderChild(button_one, 0)
		button_two:setTouchEnabled(false)
		button_two:setHighlighted(true)
		myPanelOne:setVisible(false)
		myPanelTwo:setVisible(true)
		local config = zstring.split(dms.string(dms["pirates_config"], 303, pirates_config.param), ",")
		for i = 1, #config do
			local cell = AdventureMineMineralBagCell:createCell()
			cell:init(config[i])
			mylist:addChild(cell)
		end
		
	end
end

function AdventureMinePackage:onEnterTransitionFinish()
	local csbAdventureMinePackage = csb.createNode("campaign/Mining/wakuang_zyck_kuangshi.csb")
    local root = csbAdventureMinePackage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMinePackage)

	self:onUpdateDrawList()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMinePackageClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 矿石
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kshi"), nil, 
    {
        terminal_name = "adventure_mine_package_mine_ore", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 矿工包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kgbao"), nil, 
    {
        terminal_name = "adventure_mine_package_miners_package", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureMinePackage:onExit()
    state_machine.remove("adventure_mine_package_mine_ore")
end