-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVELastSceneRewardShow = class("LPVELastSceneRewardShowClass", Window)

local lpve_last_scene_reward_show_open_terminal = {
    _name = "lpve_last_scene_reward_open",
    _init = function (terminal) 
		app.load("client.duplicate.pve.PVESceneStarChart")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local rewardwindow = LPVELastSceneRewardShow:new()
		rewardwindow:init()
		fwin:open(rewardwindow, fwin._windows)	
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(lpve_last_scene_reward_show_open_terminal)
state_machine.init()
function LPVELastSceneRewardShow:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions ={}
	
    local function init_lpve_scene_show_terminal()
		local lpve_last_scene_reward_show_close_terminal = {
            _name = "lpve_last_scene_reward_show_close",
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
		state_machine.add(lpve_last_scene_reward_show_close_terminal)
        state_machine.init()
    end
    
    init_lpve_scene_show_terminal()
end

function LPVELastSceneRewardShow:onUpdateDraw()
	local root = self.roots[1]
	-- debug.print_r(self.rewardlist)
	local ScrollView_bx = ccui.Helper:seekWidgetByName(root, "ScrollView_bx")
	ScrollView_bx:removeAllChildren(true)
	local rewardInfo = self.rewardlist
	local cell_width = 110
	local cell_height = 120
	local number = tonumber(rewardInfo.show_reward_item_count)
	local n = 0
	local show_numbers = 5
	if number % show_numbers == 0 then
		n = number / show_numbers
	else
		n = number / show_numbers + 1
	end
	ScrollView_bx:setInnerContainerSize(cc.size(ScrollView_bx:getInnerContainerSize().width, cell_height*n))
	local scoll_height = cell_height*n
	--cell_height*n
	for i=1, tonumber(rewardInfo.show_reward_item_count) do
		local y_index = 0
		local x_index = 0
		if i % show_numbers == 0 then
			y_index = i / show_numbers
			x_index = show_numbers
		else
			y_index = math.floor(i / show_numbers + 1)
			x_index = i % show_numbers
		end
		local posX = (x_index - 1) *cell_width
		local posY = (scoll_height - cell_height*(y_index-1)) - 20
		-- print("==============",scoll_height,posX,posY,y_index)
		local flag = false
		local rewardList = rewardInfo.show_reward_list[i]
		local id = rewardList.prop_item
		-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
		-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气18威名 19 日常任务积分 20功勋 21战功)
		--如果有钱
		if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			local name = _All_tip_string_info._fundName
			local quality = 1
			-- nameCell[i] = cell:getName()
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end
		--如果有宝石
		if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			local name = _All_tip_string_info._crystalName
			local quality = 5
			-- nameCell[i] = cell:getName()
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end
		
		--如果有魂玉
		if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			local name = _All_tip_string_info._soulName
			local quality = 5
			-- nameCell[i] = cell:getName()
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end		
		--道具
		if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			-- nameCell[i] = cell:getName()
			-- local name = dms.string(dms["prop_mould"], id, prop_mould.prop_name)
			-- local quality = dms.int(dms["prop_mould"], id, prop_mould.prop_quality) + 1
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end	
		--装备
		if tonumber(rewardList.prop_type) == 7 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			-- nameCell[i] = cell:getName()
			-- local name = dms.string(dms["equipment_mould"], id, equipment_mould.equipment_name)
			-- local quality = dms.int(dms["equipment_mould"], id, equipment_mould.grow_level) + 1
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end	
		--武将
		if tonumber(rewardList.prop_type) == 13 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			-- nameCell[i] = cell:getName()
			-- local name = dms.string(dms["ship_mould"], id, ship_mould.captain_name)
			-- local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type) + 1
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end	
		--威名
		if tonumber(rewardList.prop_type) == 18 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			-- nameCell[i] = cell:getName()
			-- local quality = 1
			-- local name = _All_tip_string_info._glories
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end	
		--声望
		if tonumber(rewardList.prop_type) == 3 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			-- nameCell[i] = cell:getName()
			-- local quality = 4
			-- local name = _All_tip_string_info._reputation
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end	
		
		--4:将魂
		if tonumber(rewardList.prop_type) == 4 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			-- nameCell[i] = cell:getName()
			-- local quality = 5
			-- local name = _All_tip_string_info._hero
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end	
		
		if tonumber(rewardList.prop_type) == 21 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = propMoneyIcon:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init("7",tonumber(rewardList.item_value), nil)
			ScrollView_bx:addChild(cell)
		end
		if tonumber(rewardList.prop_type) == 28 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:setAnchorPoint(cc.p(0, 1))
			cell:setPosition(cc.p(posX,posY))
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			ScrollView_bx:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			-- local name = _my_gane_name[13]
			-- local quality = 1
			-- nameCell[i] = cell:getName()
			-- nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			-- nameCell[i]:setString(name)
		end
	end
end

function LPVELastSceneRewardShow:onEnterTransitionFinish()
    local csbLPVEScene = csb.createNode("utils/congratulations_to_btain_1.csb")
    local root = csbLPVEScene:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbLPVEScene)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "lpve_last_scene_reward_show_close", 
		terminal_state = 0,
		isPressedActionEnabled = true}, 
	nil, 0)
	self:onUpdateDraw()
end
function LPVELastSceneRewardShow:close()

end

function LPVELastSceneRewardShow:init()
	self.rewardlist = getSceneReward(0)
	if self.rewardlist == nil then
		return
	end
end
function LPVELastSceneRewardShow:onExit()
	state_machine.remove("lpve_last_scene_reward_get")
end
