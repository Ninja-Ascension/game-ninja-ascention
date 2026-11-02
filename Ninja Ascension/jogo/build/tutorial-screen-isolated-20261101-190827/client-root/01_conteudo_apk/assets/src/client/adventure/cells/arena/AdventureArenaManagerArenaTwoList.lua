----------------------------------------------------------------------------------------------------
-- 说明：竞技场的list
----------------------------------------------------------------------------------------------------
AdventureArenaManagerArenaTwoList = class("AdventureArenaManagerArenaTwoListClass", Window)
AdventureArenaManagerArenaTwoList.__size = nil

function AdventureArenaManagerArenaTwoList:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.arenaInfo = nil
	self.index = 0
    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_arena_manager_arena_two_list_terminal()
		local adventure_arena_manager_arena_two_list_requite_battle_terminal = {
            _name = "adventure_arena_manager_arena_two_list_requite_battle",
            _init = function (terminal)
                app.load("client.adventure.battle.AdventureBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local function requestArenaFightDatasCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:removeAll()
                        cc.Director:getInstance():purgeCachedData()
						_ED._battle_map_type = 1
                        fwin:open(AdventureBattle:new():init(), fwin._background)
					end
				end
				protocol_command.arena_launch2.param_list = cell.index .. "\r\n1"
				NetworkManager:register(protocol_command.arena_launch2.code, nil, nil, nil, nil, requestArenaFightDatasCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_arena_manager_arena_two_list_add_terminal = {
            _name = "adventure_arena_manager_arena_two_list_add",
            _init = function (terminal)
                app.load("client.adventure.system.forums.AdventureAddFriendsForums")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				fwin:open(AdventureAddFriendsForums:new():init(cell.arenaInfo,2), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_arena_manager_arena_two_list_add_terminal)
		state_machine.add(adventure_arena_manager_arena_two_list_requite_battle_terminal)
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_arena_manager_arena_two_list_terminal()
end

function AdventureArenaManagerArenaTwoList:updateDraw()
	local root = self.roots[1]
	
end

function AdventureArenaManagerArenaTwoList:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_jingji_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role:removeAllChildren(true)
	local cell = AdventureHeroIconCell:createCell()
	cell:init(0, {ship_template_id = self.arenaInfo.template[1]}, 1, 0, nil, nil, nil, nil, 0)
	Panel_role:addChild(cell)
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	Text_rolename:setString(self.arenaInfo.name)
	-- local Text_paiwei = ccui.Helper:seekWidgetByName(root, "Text_paiwei")
	-- Text_paiwei:setString(self.arenaInfo.rank)
	local Text_zhanli_jingji = ccui.Helper:seekWidgetByName(root, "Text_zhanli_jingji")
	Text_zhanli_jingji:setString(self.arenaInfo.force)
	local xx = ccui.Helper:seekWidgetByName(root, "Button_add"):getPositionX()
	local xx2 = ccui.Helper:seekWidgetByName(root, "Button_zhandou"):getPositionX()
	if zstring.tonumber(self.arenaInfo.luck_rank) > 0 then
		ccui.Helper:seekWidgetByName(root, "Button_zhandou"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_3"):setColor(cc.c3b(210, 240, 110))
		ccui.Helper:seekWidgetByName(root, "Image_win"):setVisible(true)
		--ccui.Helper:seekWidgetByName(root, "Button_add"):setPositionX(xx2)
	else
		ccui.Helper:seekWidgetByName(root, "Button_zhandou"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_3"):setColor(cc.c3b(255, 255, 255))
		ccui.Helper:seekWidgetByName(root, "Image_win"):setVisible(false)
		--ccui.Helper:seekWidgetByName(root, "Button_add"):setPositionX(xx)
	end
	if tonumber(self.arenaInfo.robot) == 0  then 
		ccui.Helper:seekWidgetByName(root, "Button_add"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Button_add"):setVisible(false)
	end
	local textDuanwei = ccui.Helper:seekWidgetByName(root, "Text_duanwei")
	if zstring.tonumber(self.arenaInfo.title_id) == 0 then 
		textDuanwei:setString(_string_piece_info[468])
	else
		local titleName = dms.string(dms["warcraft_mould"], self.arenaInfo.title_id, warcraft_mould.title_name)
		textDuanwei:setString(titleName)	
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhandou"),       nil, 
	{
		terminal_name = "adventure_arena_manager_arena_two_list_requite_battle",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"),       nil, 
	{
		terminal_name = "adventure_arena_manager_arena_two_list_add",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	-- Get size for root node.
	if AdventureArenaManagerArenaTwoList.__size == nil then
		local size = root:getContentSize()
		AdventureArenaManagerArenaTwoList.__size = size
	end

	self:updateDraw()
end

function AdventureArenaManagerArenaTwoList:onExit()
	cacher.freeRef("list/list_jingji_1.csb", self.roots[1])
	self.roots = nil
end

function AdventureArenaManagerArenaTwoList:init(temparenaInfo, drawIndex)
	self.arenaInfo = temparenaInfo
	self.index = drawIndex
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end

	self:setContentSize(AdventureArenaManagerArenaTwoList.__size)
	return self
end

function AdventureArenaManagerArenaTwoList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaManagerArenaTwoList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_jingji_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaManagerArenaTwoList:createCell()
	local cell = AdventureArenaManagerArenaTwoList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

