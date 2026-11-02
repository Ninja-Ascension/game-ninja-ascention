----------------------------------------------------------------------------------------------------
-- 说明：排名赛的列表
----------------------------------------------------------------------------------------------------
AdventureArenaManagerHeroList = class("AdventureArenaManagerHeroListClass", Window)
AdventureArenaManagerHeroList.__size = nil

function AdventureArenaManagerHeroList:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.arenaInfo = nil
	self.index = 0
    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_arena_manager_hero_list_hero_list_terminal()
		local adventure_arena_manager_hero_list_hero_list_requite_battle_terminal = {
            _name = "adventure_arena_manager_hero_list_hero_list_requite_battle",
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
						_ED._battle_map_type = 2
                        fwin:open(AdventureBattle:new():init(), fwin._background)
						if tonumber(_ED.attackData.isWin) == 1 then
							if AdventureArenaRankedGame.__battle_ranking >  tonumber(_ED.arena_info[1].arena_buy_number) then 
								-- 排名上升才会弹出分享
								AdventureArenaRankedGame.__battle_ranking = -1
							end
						else
							AdventureArenaRankedGame.__battle_ranking = -1
						end
                        
                    else
                    	AdventureArenaRankedGame.__battle_ranking = -1
					end
				end
				AdventureArenaRankedGame.__battle_ranking = tonumber(cell.arenaInfo.rank)
				protocol_command.arena_launch.param_list = cell.arenaInfo.rank .. "\r\n0"
				NetworkManager:register(protocol_command.arena_launch.code, nil, nil, nil, nil, requestArenaFightDatasCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_arena_manager_hero_list_hero_list_requite_battle_terminal)
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_arena_manager_hero_list_hero_list_terminal()
end

function AdventureArenaManagerHeroList:updateDraw()
	local root = self.roots[1]
	
end

function AdventureArenaManagerHeroList:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_jingji_paiweisai.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role:removeAllChildren(true)
	local cell = AdventureHeroIconCell:createCell()
	cell:init(0, {ship_template_id = self.arenaInfo.template[1]}, 1, 0, nil, nil, nil, nil, 0)
	Panel_role:addChild(cell)
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	Text_rolename:setString(self.arenaInfo.name)
	local Text_paiwei = ccui.Helper:seekWidgetByName(root, "Text_paiwei")
	Text_paiwei:setString(self.arenaInfo.rank)
	local Text_zhanli_paiwei = ccui.Helper:seekWidgetByName(root, "Text_zhanli_paiwei")
	Text_zhanli_paiwei:setString(self.arenaInfo.force)
	
	local duanweiText = ccui.Helper:seekWidgetByName(root, "Text_duanwei")
	if zstring.tonumber(self.arenaInfo.title_id) == 0 then 
		duanweiText:setString(_string_piece_info[468])
	else
		local titleName = dms.string(dms["warcraft_mould"], self.arenaInfo.title_id, warcraft_mould.title_name)
		duanweiText:setString(titleName)	
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"),       nil, 
	{
		terminal_name = "adventure_arena_manager_hero_list_hero_list_requite_battle",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	-- Get size for root node.
	if AdventureArenaManagerHeroList.__size == nil then
		local size = root:getContentSize()
		AdventureArenaManagerHeroList.__size = size
	end

	self:updateDraw()
end

function AdventureArenaManagerHeroList:onExit()
	cacher.freeRef("list/list_jingji_paiweisai.csb", self.roots[1])
	self.roots = {}
end

function AdventureArenaManagerHeroList:init(temparenaInfo, drawIndex)
	self.arenaInfo = temparenaInfo
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end

	self:setContentSize(AdventureArenaManagerHeroList.__size)
	return self
end

function AdventureArenaManagerHeroList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaManagerHeroList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_jingji_paiweisai.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaManagerHeroList:createCell()
	local cell = AdventureArenaManagerHeroList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

