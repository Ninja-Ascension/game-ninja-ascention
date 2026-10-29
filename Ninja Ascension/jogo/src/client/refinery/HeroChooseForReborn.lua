-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面武将重生界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroChooseForReborn = class("HeroChooseForRebornClass", Window)
	
function HeroChooseForReborn:ctor()
    self.super:ctor()
	
	self.roots = {}
    
    -- Initialize HeroChooseForReborn page state machine.
    local function init_HeroChooseForReborn_terminal()
		-- 关闭
		local hero_choose_reborn_close_terminal = {
            _name = "hero_choose_reborn_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
				else
					state_machine.excute("menu_show_event", 0, "menu_show_event.")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_choose_reborn_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_HeroChooseForReborn_terminal()
end

function HeroChooseForReborn:sortHerosForRebornFun()
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_ship) do
			local inRosouce = false
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				if v.inResourceFromation == true then
					inRosouce = true
				end
			end
			local captain_type = dms.int(dms["ship_mould"],v.ship_template_id,ship_mould.captain_type)
			if captain_type == 3 then 
				--宠物
				inRosouce = true
			end
			if inRosouce == false then
				local shipId = v.ship_id
				local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
				local fitSkillOne = 0
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					fitSkillOne = dms.atoi(shipData, ship_mould.fitSkillOne)
				end
				local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
				local shipRankLevel = dms.atoi(shipData, ship_mould.initial_rank_level) 
				if tonumber(v.ship_base_template_id) < 1148 or tonumber(v.ship_base_template_id) > 1150 then
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						if shipQuality >= 2 and zstring.tonumber(v.formation_index) == 0 and zstring.tonumber(v.little_partner_formation_index) == 0 then
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
								if fitSkillOne ~= -1 then 
									list[j] = v
									j = j+1
								end
							else
						  	if tonumber(v.ship_grade) > 1 or tonumber(v.ship_skillstren.skill_level) > 1 or tonumber(shipRankLevel) > 0 then
								list[j] = v
								j = j+1
								end
							end
						end
					else
						if shipQuality >= 2 and (zstring.tonumber(v.formation_index) == 0)
						  and (zstring.tonumber(v.little_partner_formation_index) == 0) then
							list[j] = v
							j = j+1
						end
					end
				end
			end
		end
		return list
	end
	
	local function compare(a, b)
		local a_quality = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
		local b_quality = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
		if a_quality > b_quality then
			return false
		elseif a_quality == b_quality then
			if tonumber(a.ship_grade) > tonumber(b.ship_grade) then
				return false
			end
		end
		return true
	end
	
	local function sortList(list)
		local count = #list
		
		for i=1, count do
			for j=1, count-i do
				if compare(list[j], list[j+1]) == false then
					list[j], list[j+1] = list[j+1], list[j]
				end
			end
		end
		return list
	end
	
	return sortList(chooseHero())
end

function HeroChooseForReborn.loading(texture)
	local myListView = HeroChooseForReborn.myListView
	if myListView ~= nil then
		local cell = HeroChooseForRebornCell:createCell()
		cell:init(HeroChooseForReborn.sortHerosForReborn[HeroChooseForReborn.asyncIndex])
		myListView:addChild(cell)
		HeroChooseForReborn.asyncIndex = HeroChooseForReborn.asyncIndex + 1
		myListView:requestRefreshView()
	end
end

function HeroChooseForReborn:onUpdateDraw()
	local ListView_wjcs = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_wjcs")
	app.load("client.cells.ship.hero_choose_for_reborn_cell")
	-- for i,v in ipairs(self:sortHerosForReborn()) do
	-- 	local cellList = HeroChooseForRebornCell:createCell()
	-- 	cellList:init(v)
	-- 	ListView_wjcs:addChild(cellList)
	-- end

	HeroChooseForReborn.myListView = ListView_wjcs
	HeroChooseForReborn.sortHerosForReborn = self:sortHerosForRebornFun()
	HeroChooseForReborn.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local MylistViewCell = nil
		for i, v in ipairs(HeroChooseForReborn.sortHerosForReborn) do
			local cell = HeroChooseForRebornCell:createCell()
			cell:init(HeroChooseForReborn.sortHerosForReborn[HeroChooseForReborn.asyncIndex])
			if MylistViewCell == nil then
				MylistViewCell = MultipleListViewCell:createCell()
				MylistViewCell:init(HeroChooseForReborn.myListView, cc.size(446,130))
				HeroChooseForReborn.myListView:addChild(MylistViewCell)
				MylistViewCell.prev = preMultipleCell
				if preMultipleCell ~= nil then
					preMultipleCell.next = MylistViewCell
				end
			end
			MylistViewCell:addNode(cell)
			if MylistViewCell.child2 ~= nil then
				preMultipleCell = MylistViewCell
				MylistViewCell = nil
			end
			HeroChooseForReborn.asyncIndex = HeroChooseForReborn.asyncIndex + 1
		end	
	else
		for i, v in ipairs(HeroChooseForReborn.sortHerosForReborn) do
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
		end
	end
end

function HeroChooseForReborn:onEnterTransitionFinish()
	local csbHeroChooseForReborn = csb.createNode("packs/HeroStorage/generals_renascence.csb")
	self:addChild(csbHeroChooseForReborn)
	local root = csbHeroChooseForReborn:getChildByName("root_1")
	table.insert(self.roots, root)
	
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
	self:onUpdateDraw()
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wjcs_fanhui"), nil, 
	{
		terminal_name = "hero_choose_reborn_close", 
		isPressedActionEnabled = true
	}, 
	nil, 2)
end

function HeroChooseForReborn:onExit()
	HeroChooseForReborn.myListView = nil
	HeroChooseForReborn.asyncIndex = 1
	state_machine.remove("hero_choose_reborn_close")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end