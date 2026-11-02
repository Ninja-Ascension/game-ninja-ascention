-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景星星数奖励面板
-------------------------------------------------------------------------------------------------------
PVEStarCheatPanel = class("PVEStarCheatPanelClass", Window)

local open_star_cheat_panel_terminal = {
    _name = "open_star_cheat_panel",
    _init = function (terminal) 
		
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if __lua_project_id == __lua_project_gragon_tiger_gate 
    		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    		or __lua_project_id == __lua_project_red_alert 
    		then
	    	local sceneID = params[1]
	    	local types = params[2]
	    	local pcp = PVEStarCheatPanel:new()
			pcp:init(sceneID,types)
			fwin:open(pcp, fwin._ui)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(open_star_cheat_panel_terminal)
state_machine.init()

function PVEStarCheatPanel:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.pveSceneID = -1
	self.rewardNeedStar = nil
	self.starRewardState = -1
	
	self.cacheLoadingBar = nil
	self.cacheInfoText = nil
	
	self.getStarCount = 0		--已经获得星星的总数
	self.types = nil
	-- Initialize PlotCopyChest page state machine.
    local function init_pve_star_cheat_terminal()
	
		-- 关闭场景星级奖励界面
		local pve_star_cheat_panel_close_terminal = {
            _name = "pve_star_cheat_panel_close",
            _init = function (terminal) 
                app.load("client.duplicate.pve.PVESceneStarReward")
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
		
		-- 更新界面
		local pve_star_cheat_update_panel_terminal = {
            _name = "pve_star_cheat_update_panel",
            _init = function (terminal) 
                -- app.load("client.duplicate.pve.PVESceneStarReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            		or __lua_project_id == __lua_project_l_naruto 
            		then
            		instance:onUpdateAllDraw()
            	else
            		instance:onUpdateDraw()
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
				--章节列表
		local lpve_star_cheat_goto_open_list_terminal = {
            _name = "lpve_star_cheat_goto_open_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		app.load("client.landscape.duplicate.pve.LPVERaidSelectPanel")
        		if fwin:find("LPVERaidSelectPanelClass") == nil then			
					state_machine.excute("lpve_raid_select_open",0,{LDuplicateWindow._infoDatas._type,0})
					return
        		end
				if fwin:find("LPVERaidSelectPanelClass") ~= nil then
					state_machine.excute("lpve_raid_select_panel_close_action",0,"")
        		end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

						--章节列表
		local lpve_star_cheat_button_change_state_terminal = {
            _name = "lpve_star_cheat_button_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if params == 1 then
            		local root = instance.roots[1]
            		local Image_ar_0 = ccui.Helper:seekWidgetByName(root,"Image_ar_0")
            		local Image_ar = ccui.Helper:seekWidgetByName(root,"Image_ar")
            		Image_ar_0:setVisible(true)
            		Image_ar:setVisible(false)
            	else
            		local root = instance.roots[1]
            		local Image_ar_0 = ccui.Helper:seekWidgetByName(root,"Image_ar_0")
            		local Image_ar = ccui.Helper:seekWidgetByName(root,"Image_ar")
            		Image_ar_0:setVisible(false)
            		Image_ar:setVisible(true)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

				-- 刷出宝箱
		local pve_star_cheat_update_panel_box_terminal = {
            _name = "pve_star_cheat_update_panel_box",
            _init = function (terminal) 
                -- app.load("client.duplicate.pve.PVESceneStarReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateAllDraw()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_star_cheat_update_info_terminal = {
            _name = "pve_star_cheat_update_info",
            _init = function (terminal) 
                -- app.load("client.duplicate.pve.PVESceneStarReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance.pveSceneID = params[1]
				instance.types = params[2]
				instance.getStarCount = tonumber(_ED.get_star_count[instance.pveSceneID])
				instance:onUpdateAllDraw()
				instance:onUpdateBoxDraw()
				state_machine.excute("lduplicate_window_remove_old_page",0,"")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_star_cheat_panel_close_terminal)
        state_machine.add(pve_star_cheat_update_panel_terminal)
        state_machine.add(lpve_star_cheat_goto_open_list_terminal)
        state_machine.add(lpve_star_cheat_button_change_state_terminal)
        state_machine.add(pve_star_cheat_update_panel_box_terminal)
        state_machine.add(pve_star_cheat_update_info_terminal)
        state_machine.init()
    end
    
    -- call func init PlotCopyChest state machine.
    init_pve_star_cheat_terminal()
end

function PVEStarCheatPanel:onUpdateBoxDraw()
	--已经获得星星的数量
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self.getStarCount = tonumber(_ED.get_star_count[self.pveSceneID])
		local index = 0
		local sceneId = self.pveSceneID
		
		--总星数
		local maxStar = dms.int(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.total_star)
		
		--左上角显示
		self.cacheInfoText:setString(self.getStarCount .. " / " .. maxStar)
		
		--更新进度条
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	        then
        	self.cacheLoadingBar:setPercent(self.getStarCount / maxStar * 100)
    	else
			local tmpHoldStar = self.getStarCount - 5
			if tmpHoldStar < 0 then tmpHoldStar = 0 end
			local tmpMaxStar = maxStar - 5
			self.cacheLoadingBar:setPercent(tmpHoldStar / tmpMaxStar * 100)

			local sceneNameText = ccui.Helper:seekWidgetByName(self.roots[1], "BitmapFontLabel_zj_name")
			local name = dms.string(dms["pve_scene"], self.pveSceneID, pve_scene.scene_name)

			sceneNameText:getVirtualRenderer():setDimensions(36,0) -- setContentSize(cc.size(36,500))
			sceneNameText:setString(name)
			sceneNameText:setContentSize(sceneNameText:getVirtualRenderer():getContentSize())
		end
	end
end

function PVEStarCheatPanel:onUpdateAllDraw()
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		app.load("client.cells.copy.plot_copy_chest")

		self.starRewardState = zstring.tonumber(_ED.star_reward_state[self.pveSceneID])
		self.rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.reward_need_star), ",")
		
		--已经获得星星的数量
		self.getStarCount = tonumber(_ED.get_star_count[self.pveSceneID])
		
		local chestsPanelName = {}
		for i=7,9 do
			local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_"..i)
			panel:removeAllChildren(true)
			table.insert(chestsPanelName, panel)
		end

		if #self.rewardNeedStar == 1 then
			chestsPanelName[1] = chestsPanelName[2]
		end

		--总星数
		local maxStar = dms.int(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.total_star)

		local size = self.cacheLoadingBar:getContentSize()
		local startPosX = self.cacheLoadingBar:getPositionX() - (size.width * self.cacheLoadingBar:getAnchorPoint().x)

		local index = 0
		local sceneId = self.pveSceneID
		for i = 1, table.getn(self.rewardNeedStar) do
			local chest = chestsPanelName[i]
			local param = {state = 0, starNum = zstring.tonumber(self.rewardNeedStar[i]), boxIndex = i}
			-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_stars_number_" .. (i + 1)):setString(param.starNum)
			if param.starNum <= self.getStarCount then
				param.state = 1
			end
			local chest_cell = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
				or __lua_project_id == __lua_project_l_naruto
				then
				chest_cell = state_machine.excute("lpve_reward_cell_create", 0, {i, param, sceneId})
			else
				chest_cell = PlotCopyChest:createCell()
				chest_cell:init(i, param, sceneId)
			end

			local cell_size = chest:getContentSize()
			chest:addChild(chest_cell)
			chest:setPositionX(startPosX + size.width * param.starNum / maxStar - cell_size.width/2)
			chest:setTouchEnabled(false)
		end
		state_machine.unlock("lduplicate_window_pve_quick_entrance")
	end
end

function PVEStarCheatPanel:onUpdateDraw()
	app.load("client.cells.copy.plot_copy_chest")
	-- local sceneId = params._datas._sceneId
	-- local openState = params._datas._openState
	-- local chestState = params._datas._chestState
	-- local pveSceneStarReward = PVESceneStarReward:new()
	-- PVESceneStarReward:init(sceneId, chestState, openState)
	-- fwin:open(pveSceneStarReward, fwin._windows)
	
	self.starRewardState = zstring.tonumber(_ED.star_reward_state[self.pveSceneID])
	self.rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.reward_need_star), ",")
	
	--已经获得星星的数量
	self.getStarCount = tonumber(_ED.get_star_count[self.pveSceneID])
	
	local chestsPanelName = {
		"Panel_7",
		"Panel_8",
		"Panel_9"
	}

	if #self.rewardNeedStar == 1 then
		chestsPanelName[1] = chestsPanelName[2]
	end

	local index = 0
	local sceneId = self.pveSceneID
	for i = 1, table.getn(self.rewardNeedStar) do
		local chest = ccui.Helper:seekWidgetByName(self.roots[1], chestsPanelName[i])
		local chest_cell = PlotCopyChest:createCell()
		local param = {state = 0, starNum = zstring.tonumber(self.rewardNeedStar[i]), boxIndex = i}
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_stars_number_" .. (i + 1)):setString(param.starNum)
		if param.starNum <= self.getStarCount then
			param.state = 1
		end
		chest_cell:init(i, param, sceneId)
		chest:setTouchEnabled(false)
		chest:removeAllChildren(true)
		
		chest:addChild(chest_cell)
	end
	
	--总星数
	local maxStar = dms.int(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.total_star)
	
	--左上角显示
	self.cacheInfoText:setString(self.getStarCount .. " / " .. maxStar)
	
	local tmpHoldStar = self.getStarCount - 5
	if tmpHoldStar < 0 then tmpHoldStar = 0 end
	local tmpMaxStar = maxStar - 5
	
	--更新进度条
	self.cacheLoadingBar:setPercent(tmpHoldStar / tmpMaxStar * 100)

end

function PVEStarCheatPanel:onEnterTransitionFinish()
	local csbPveMap = csb.createNode("duplicate/pve_baoxianglingqu.csb")
    local root = csbPveMap:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPveMap)
	
	self.cacheLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_stars")
	self.cacheInfoText = ccui.Helper:seekWidgetByName(root, "Text_stars_number")
	local sceneText = ccui.Helper:seekWidgetByName(self.roots[1], "BitmapFontLabel_zj_name")	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		for i=7,9 do
			ccui.Helper:seekWidgetByName(root, "Panel_" .. i):setTouchEnabled(false)
		end
	else
		self:addTouchEventFunc("Button_1", "pve_star_cheat_panel_close", true)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if self.types == nil then
			self:onUpdateAllDraw()
			self:onUpdateBoxDraw()
		elseif self.types == 1 then
			self:onUpdateBoxDraw()
		end
	    local Button_zhangjie_list = ccui.Helper:seekWidgetByName(root, "Button_zhangjie_list")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhangjie_list"), nil, 
		{
			terminal_name = "lpve_star_cheat_goto_open_list", 	
			terminal_state = 0, 
			isPressedActionEnabled = false

		}, 
		nil, 0)
		
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_ordinary_the_chest",
		_widget = ccui.Helper:seekWidgetByName(root, "Panel_zx_tuishong"),
		_invoke = nil,
		_interval = 0.5,})
	else
    	self:onUpdateDraw()
    end
end

--通用按钮点击事件添加
function PVEStarCheatPanel:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = "", 
		but_image = "",
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	},
	nil, 2)
	return tmpArt
end

function PVEStarCheatPanel:init(sceneID,types)
	self.pveSceneID = sceneID
	self.getStarCount = tonumber(_ED.get_star_count[self.pveSceneID])
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.types = types
	end
	-- self.sceneStarNum = dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.total_star)
end

--切换了普通，精英副本后刷新
function PVEStarCheatPanel:changePageRefresh()
	local root = self.roots[1]
	if root == nil then
		return
	end
end

function PVEStarCheatPanel:onExit()
	state_machine.remove("pve_star_cheat_panel_close")
	state_machine.remove("pve_star_cheat_update_panel")
	state_machine.remove("lpve_star_cheat_goto_open_list")
	state_machine.remove("lpve_star_cheat_button_change_state")
	state_machine.remove("pve_star_cheat_update_panel_box")
	state_machine.remove("pve_star_cheat_update_info")
end
