----------------------------------------------------------------------------------------------------
-- 说明：副本宝箱元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
LPveRewardCell = class("LPveRewardCellClass", Window)
 
local lpve_reward_cell_create_terminal = {
    _name = "lpve_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LPveRewardCell:new()
        cell:init(params[1], params[2], params[3], params[4], params[5])
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lpve_reward_cell_create_terminal)
state_machine.init()

function LPveRewardCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.sceneId = 0 -- 场景id
	self.npcId = 0
	self.openState = {}  -- state = 0.关闭状态  1.开启未获取宝物状态 2.开启并已经获取状态  starNum 星数
	self.chestState = 0 --0.Npc宝箱   1.铜箱子  2.铁箱子  3.金箱子  4.龙虎门Npc宝箱
	self.starReward = -1
	self.isCanPlayGetAni = false

    local function init_lpve_reward_cell_terminal()	
		-- NPC宝箱领取
		local lpve_reward_cell_click_1_terminal = {
			_name = "lpve_reward_cell_click_1",
			_init = function (terminal) 
				app.load("client.landscape.duplicate.pve.LPVENpcRewardBox")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local prb = LPVENpcRewardBox:new()
				local tmpSeatCell = {npcState = params._datas._npcState}
				if params._datas._npcState == nil then
					tmpSeatCell = nil
				end
				prb:init(params._datas._sceneId, params._datas._npcId, tmpSeatCell, params._datas._cell)
				fwin:open(prb, fwin._ui)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- NPC宝箱领取(舰娘)
		local lpve_reward_cell_click_2_terminal = {
			_name = "lpve_reward_cell_click_2",
			_init = function (terminal) 
				app.load("client.duplicate.pve.PVENpcRewardBox")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local prb = PVENpcRewardBox:new()
				local tmpSeatCell = {npcState = params._datas._npcState}
				if params._datas._npcState == nil then
					tmpSeatCell = nil
				end
				prb:init(params._datas._sceneId, params._datas._npcId, tmpSeatCell, params._datas._cell)
				fwin:open(prb, fwin._ui)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开场景星级奖励界面
		local lpve_reward_cell_click_3_terminal = {
            _name = "lpve_reward_cell_click_3",
            _init = function (terminal) 
                app.load("client.duplicate.pve.PVESceneStarReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local sceneId = params._datas._sceneId
				local openState = params._datas._openState
				local chestState = params._datas._chestState
                local pveSceneStarReward = PVESceneStarReward:new()
				pveSceneStarReward:init(sceneId, chestState, openState)
				fwin:open(pveSceneStarReward, fwin._windows)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(lpve_reward_cell_click_1_terminal)
		state_machine.add(lpve_reward_cell_click_2_terminal)
        state_machine.add(lpve_reward_cell_click_3_terminal)
        state_machine.init()
    end
    
    init_lpve_reward_cell_terminal()
end

function LPveRewardCell:onUpdateDraw()
	local root = self.roots[1]

	self.starReward = tonumber(self.starReward)
	self.chestState = tonumber(self.chestState)
	
	local sourceName = self.chestState
	if self.chestState == 5 then
		sourceName = 3
	end
	local imageName = ""
	local isShowAni = false
	if self.openState.state == 0 then
		if (self.starReward == 1 and self.chestState == 1)
			or (self.starReward == 2 and self.chestState == 2)
			or (self.starReward == 4 and self.chestState == 3)
			or (self.starReward == 3 and (self.chestState == 1 or self.chestState == 2))
			or (self.starReward == 5 and (self.chestState == 1 or self.chestState == 3))
			or (self.starReward == 6 and (self.chestState == 2 or self.chestState == 3))
			or self.starReward == 7
			then
			imageName = "gq_pic_bx"..sourceName.."open"
		else
			imageName = "gq_pic_bx"..sourceName
		end
		if self.chestState == 4 then
			imageName = "gq_pic_bx"..sourceName
		elseif self.chestState == 5 then
			imageName = "gq_pic_bx"..sourceName
		end
	elseif self.openState.state == 1 then
		if self.starReward == 0 then
			imageName = "gq_pic_bx"..sourceName
			isShowAni = true
		elseif self.starReward == 1 then
			if self.chestState == 1 then
				imageName = "gq_pic_bx"..sourceName.."open"
			else
				imageName = "gq_pic_bx"..sourceName
				isShowAni = true
			end
		elseif self.starReward == 2 then
			if self.chestState == 2 then
				imageName = "gq_pic_bx"..sourceName.."open"
			else
				imageName = "gq_pic_bx"..sourceName
				isShowAni = true
			end
		elseif self.starReward == 4 then
			if self.chestState == 3 then
				imageName = "gq_pic_bx"..sourceName.."open"
			else
				imageName = "gq_pic_bx"..sourceName
				isShowAni = true
			end
		elseif self.starReward == 3 then
			if self.chestState == 1 or self.chestState == 2 then
				imageName = "gq_pic_bx"..sourceName.."open"
			else
				imageName = "gq_pic_bx"..sourceName
				isShowAni = true
			end
		elseif self.starReward == 5 then
			if self.chestState == 1 or self.chestState == 3 then
				imageName = "gq_pic_bx"..sourceName.."open"
			else
				imageName = "gq_pic_bx"..sourceName
				isShowAni = true
			end
		elseif self.starReward == 6 then
			if self.chestState == 2 or self.chestState == 3 then
				imageName = "gq_pic_bx"..sourceName.."open"
			else
				imageName = "gq_pic_bx"..sourceName
				isShowAni = true
			end
		elseif self.starReward == 7 then
			imageName = "gq_pic_bx"..sourceName.."open"
		end
		if self.chestState == 4 then
			-- imageName = "gq_pic_bx"..sourceName
		elseif self.chestState == 5 then
			imageName = "gq_pic_bx"..sourceName
		end
	elseif self.openState.state == 2 then
		if self.chestState == 5 then
			imageName = "gq_pic_bx"..sourceName.."open"
        elseif self.chestState == 4 then
			imageName = "gq_pic_bx"..sourceName.."open"
		end
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box")
		local animationChild = panel:getChildByTag(1024)
		if animationChild ~= nil then 
			panel:removeChildByTag(1024)
		end
		if self.chestState == 4 then
			local file_path = "images/ui/effice/effect_31/effect_31.ExportJson"
			local armature_name = "effect_31"
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(file_path)
			local cell = ccs.Armature:create(armature_name)
			cell:setTag(1024)
			
			if tonumber(self.openState.state) == 0 then
				--未开不能开
				cell:getAnimation():playWithIndex(0)
				panel:addChild(cell)
			elseif tonumber(self.openState.state) == 1 then
				--未开可以开
				cell:getAnimation():playWithIndex(1)
				panel:addChild(cell)
			elseif tonumber(self.openState.state) == 2 then
				--开过了
				cell:getAnimation():playWithIndex(2)
				panel:addChild(cell)
			end
		end
		if self.chestState == 4 then
		else
			-- 是否显示红点，0不显示，1显示
			local isShowRedot = 0
			if self.openState.state == 1 and isShowAni == true then
				isShowRedot = 1
				ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec"):setVisible(false)
			end
			if imageName ~= "" then
				ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"):setBackGroundImage("images/ui/reward/"..imageName..".png")
			end
			-- DSC通关宝箱领取提示
			if __lua_project_id == __lua_project_l_digital then
				self:showRedDot(isShowRedot)
			end
		end
	else
		if self.openState.state == 1 and isShowAni == true then
			ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec"):setVisible(false)
		end

		if imageName ~= "" then
			ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"):setBackGroundImage("images/ui/reward/"..imageName..".png")
		end
	end

	

	local starNum = ccui.Helper:seekWidgetByName(root, "Text_pve_reward_star")
	starNum:setString(self.openState.starNum)
	if self.chestState == 4 then
		starNum:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "ImageView_pve_reward_star"):setVisible(false)
	elseif self.chestState == 5 then
		starNum:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "ImageView_pve_reward_star"):setVisible(false)
	else
		starNum:setVisible(true)
		ccui.Helper:seekWidgetByName(root, "ImageView_pve_reward_star"):setVisible(true)
	end
end

-- 控制红点的显隐
function LPveRewardCell:showRedDot(showState)
	local root = self.roots[1]
	local Image_tip = ccui.Helper:seekWidgetByName(root, "Image_tip")
	if Image_tip ~= nil then
		if tonumber(showState) == 1 then
			Image_tip:setVisible(true)
		else
			Image_tip:setVisible(false)
		end
	end
end

function LPveRewardCell:onUpdateDrawEX( ... )
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"):removeBackGroundImage()
	if self.openState.state == 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"):setBackGroundImage("images/ui/reward/gq_pic_bx3.png")
	else
		ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"):setBackGroundImage("images/ui/reward/gq_pic_bx3open.png")
	end
	if self.openState.showAni == true then
		ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec"):setVisible(false)
	end

	ccui.Helper:seekWidgetByName(root, "Text_pve_reward_star"):setString("")
	ccui.Helper:seekWidgetByName(root, "ImageView_pve_reward_star"):setVisible(false)
end

function LPveRewardCell:onInit( ... )
	local root = cacher.createUIRef("duplicate/pve_reward_sm.csb", "root")
	table.insert(self.roots, root)
	self:addChild(root)
	
	if __lua_project_id == __lua_project_l_digital then
		local Image_tip = ccui.Helper:seekWidgetByName(root, "Image_tip")
		if Image_tip ~= nil then
			Image_tip:setVisible(false)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"):setTouchEnabled(true)
	if self.chestState == -1 then
		ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"):setTouchEnabled(false)
	elseif self.chestState == 4 then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"), nil, 
		{
			terminal_name = "lpve_reward_cell_click_1", 
			terminal_state = 0, 
			touch_scale = true,
			_sceneId = self.sceneId,
			_npcId = self.npcId,
			_npcState = self.npcState,
			_cell = self,
		},nil, 0)
	elseif self.chestState == 5 then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"), nil, 
		{
			terminal_name = "lpve_reward_cell_click_2", 
			terminal_state = 0, 
			touch_scale = true,
			_sceneId = self.sceneId,
			_npcId = self.npcId,
			_npcState = self.npcState,
			_cell = self,
		},nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"), nil, 
		{
			terminal_name = "lpve_reward_cell_click_3", 
			terminal_state = 0, 
			touch_scale = true,
			_sceneId = self.sceneId,
			_openState = self.openState,
			_chestState = self.chestState
		},nil, 0)
	end
	if self.chestState == -1 then
		self:onUpdateDrawEX()
	else
		self:onUpdateDraw()
	end
end

function LPveRewardCell:onEnterTransitionFinish()
end

function LPveRewardCell:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_pve_reward_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box")
	local Panel_pve_reward_box_rec = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec")
	local Text_pve_reward_star = ccui.Helper:seekWidgetByName(root, "Text_pve_reward_star")
	if Panel_pve_reward_box ~= nil then
		Panel_pve_reward_box:removeBackGroundImage()
	end
	if Panel_pve_reward_box_rec ~= nil then
		Panel_pve_reward_box_rec:setVisible(false)
	end
	
	if __lua_project_id == __lua_project_l_digital then
		local Image_tip = ccui.Helper:seekWidgetByName(root, "Image_tip")
		if Image_tip ~= nil then
			Image_tip:setVisible(false)
		end
	end
	if Text_pve_reward_star ~= nil then
		Text_pve_reward_star:setString("")
	end
end

function LPveRewardCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("duplicate/pve_reward_sm.csb", self.roots[1])
end

function LPveRewardCell:changeState(_state)
    self.openState.state = _state
    self:clearUIInfo()
	self:onUpdateDraw()
end

function LPveRewardCell:init(chestState, openState, sceneId, npcId, npcState)
	self.chestState = chestState
	self.openState	= openState
	self.sceneId = sceneId
	self.npcId = npcId
	self.npcState = npcState
	self.starReward = zstring.tonumber(_ED.star_reward_state[self.sceneId])
	self:onInit()
end
