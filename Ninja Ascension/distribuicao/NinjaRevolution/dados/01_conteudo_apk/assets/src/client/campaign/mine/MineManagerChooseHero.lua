----------------------------------------------------------------------------------------------------
-- 说明：选择武将巡逻
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerChooseHero = class("MineManagerChooseHeroClass", Window)
    
function MineManagerChooseHero:ctor()
    self.super:ctor()
    self.roots = {}
	self._id = nil
	app.load("client.campaign.mine.MineManagerChooseHeroList")
    -- Initialize MineManager page state machine.
    local function init_mine_manager_choose_hero_patrol_terminal()
	
		--返回
		local mine_manager_manor_choose_hero_back_terminal = {
            _name = "mine_manager_manor_choose_hero_back",
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
		
		state_machine.add(mine_manager_manor_choose_hero_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_choose_hero_patrol_terminal()
end


function MineManagerChooseHero:ergodicHero(mid)
	local city = _ED.manor_info.player.city

	for k, v in pairs(city) do
		
		if mid == v.ship_mould_id then
		
			return true
		end
		
	end

	return false
end

function MineManagerChooseHero:onUpdateDraw()

	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_bwcs")
	
	local userShip = {}
	for k, v in pairs(_ED.user_ship) do
		table.insert(userShip, v)
	end
	
	function qualitySort(a,b)
		local qualityA = dms.int(dms["ship_mould"], tonumber(a.ship_template_id), ship_mould.ship_type)
		local qualityB = dms.int(dms["ship_mould"], tonumber(b.ship_template_id), ship_mould.ship_type)
	
		if qualityA > qualityB then
			return true
		end
		return false
	end
	table.sort(userShip, qualitySort)
	
	local heroList = {}
	local patrolHeroList = {}
	
	function hasRepeat (list,v)
		for i = 1 , table.getn(list) do
			local item = list[i]
			if item.v.ship_base_template_id == v.ship_base_template_id then
				return true
			end
		end
		
		return false
	end
	
	
	for i, v in ipairs(userShip) do
		if tonumber(v.captain_type) == 1 then
			--1. 品质紫色以上 --2. 排除已经在巡逻的同模板武将
			local quality = dms.int(dms["ship_mould"], tonumber(v.ship_template_id), ship_mould.ship_type)
			if quality >= 3 then
				if false == self:ergodicHero(tonumber(v.ship_base_template_id))  then
					
					if false == hasRepeat(heroList,v) then
						table.insert(heroList, {v = v, id = self._id, isPatrol = false})
					end
				else
					-- 标记为 已在巡逻
					if false == hasRepeat(patrolHeroList, v) then
						table.insert(patrolHeroList, {v = v, id = self._id, isPatrol = true})
					end
				end
			end
		end
	end
	
	
	for i = 1 , table.getn(patrolHeroList) do
		table.insert(heroList, patrolHeroList[i])
	end
	
	MineManagerChooseHero.heroList = heroList
	
	
	local length = table.getn(heroList)
	if length > 0 then
		-- 填充开始
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		MineManagerChooseHero.asyncIndex = 1
		MineManagerChooseHero.cacheListView = listView
		
		for i, v in ipairs(heroList) do
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
		
	end
end



function MineManagerChooseHero:loading_cell()
	if MineManagerChooseHero.cacheListView == nil then
		return 
	end
	local data = MineManagerChooseHero.heroList
	local item = data[MineManagerChooseHero.asyncIndex]
	local cell = MineManagerChooseHeroList:createCell()
	cell:init(item.v,item.id,item.isPatrol)
	MineManagerChooseHero.cacheListView:addChild(cell)
	MineManagerChooseHero.cacheListView:requestRefreshView()
	MineManagerChooseHero.asyncIndex = MineManagerChooseHero.asyncIndex + 1
end

function MineManagerChooseHero:onEnterTransitionFinish()

    local csbMineManagerChooseHero = csb.createNode("campaign/MineManager/attack_territory_choose.csb")
    self:addChild(csbMineManagerChooseHero)
	
   	local root = csbMineManagerChooseHero:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bwcs_fanhui"), nil, 
	{
		func_string = [[state_machine.excute("mine_manager_manor_choose_hero_back", 0, "mine_manager_manor_choose_hero_back.'")]],
		isPressedActionEnabled = true
	}, nil, 0)

	self:onUpdateDraw()
end

function MineManagerChooseHero:onExit()
	state_machine.remove("mine_manager_manor_choose_hero_back")
	MineManagerChooseHero.heroList = nil
	MineManagerChooseHero.asyncIndex = 1
	MineManagerChooseHero.cacheListView = nil
end

function MineManagerChooseHero:init(id)
	self._id = id	--领地ID
end

function MineManagerChooseHero:createCell()
	local cell = MineManagerChooseHero:new()
	cell:registerOnNodeEvent(cell)
	return cell
end