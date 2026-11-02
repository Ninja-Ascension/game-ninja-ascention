-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE 二级战斗 场景上的 覆盖层(返回/宝箱进度/星星榜)
-------------------------------------------------------------------------------------------------------
PVESecondarySceneCover = class("PVESecondarySceneCoverClass", Window)

function PVESecondarySceneCover:ctor()
    self.super:ctor()
    self.roots = {}
	self.pveSceneID = 0				--场景ID
	self.needUpdateRefreshCd = false
	self.interval = 0
	app.load("client.utils.TimeUtil")
	local function init_terminal()
		
		--返回
		local duplicate_pve_secondary_scene_back_click_terminal = {
            _name = "duplicate_pve_secondary_scene_back_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("duplicate_pve_secondary_scene_back_home", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 副本星级排行榜
		local duplicate_pve_secondary_scene_star_ranklist_click_terminal = {
            _name = "duplicate_pve_secondary_scene_star_ranklist_click",
            _init = function (terminal) 
            	app.load("client.duplicate.pve.PVESceneStarChart")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local star = PVESceneStarChart:new()
				star:init(instance.currentPageType)
				fwin:open(star, fwin._windows)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 更新界面
		local duplicate_pve_secondary_scene_star_box_update_panel_terminal = {
            _name = "duplicate_pve_secondary_scene_star_box_update_panel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if nil ~= fwin:find("PVESecondarySceneClass") then
					instance:updateStarBox(true)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --弹出魔陷商人
		local duplicate_pve_secondary_scene_meet_shopmen_terminal = {
            _name = "duplicate_pve_secondary_scene_meet_shopmen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil and instance.roots ~= nil then 
					app.load("client.magicCard.MagicCardShop")
            		local showWindow = MagicCardShop:createCell()
            		fwin:open(showWindow, fwin._viewdialog)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--核对是否有魔陷商人
		local duplicate_pve_secondary_scene_check_magic_shop_terminal = {
            _name = "duplicate_pve_secondary_scene_check_magic_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil and instance.roots ~= nil then 
					instance:checkHasMagicShop()
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(duplicate_pve_secondary_scene_star_box_update_panel_terminal)
		state_machine.add(duplicate_pve_secondary_scene_back_click_terminal)
		state_machine.add(duplicate_pve_secondary_scene_star_ranklist_click_terminal)
		state_machine.add(duplicate_pve_secondary_scene_meet_shopmen_terminal)
		state_machine.add(duplicate_pve_secondary_scene_check_magic_shop_terminal)
        state_machine.init()
	end
	
	init_terminal()
	
end


function PVESecondarySceneCover:onUpdateDrawBottom()
	local root = self.roots[1]
	local getStarCount = tonumber(_ED.get_star_count[self.sceneID])
	local sceneStarNum = dms.int(dms["pve_scene"], tonumber(self.sceneID), pve_scene.total_star)
	if self.currentPageType ~= 3 then 
		ccui.Helper:seekWidgetByName(root, "Text_2"):setString(getStarCount .. " / " .. sceneStarNum)
	end
	
	local Button_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_2")
	--评审状态不显示排行榜
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
		if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
			Button_2:setVisible(true)
		else
			Button_2:setVisible(false)
		end
	end
	--副本星级排行榜
	self:addTouchEventFunc("Button_2", "duplicate_pve_secondary_scene_star_ranklist_click", true)

	app.load("client.cells.copy.plot_copy_chest")

	local starRewardState = zstring.tonumber(_ED.star_reward_state[self.sceneID])
	local rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.reward_need_star), ",")
	
	--已经获得星星的数量
	local getStarCount = tonumber(_ED.get_star_count[self.sceneID])
	self:updateStarBox()

	--总星数
	local maxStar = dms.int(dms["pve_scene"], tonumber(self.sceneID), pve_scene.total_star)

	if __lua_project_id == __lua_project_yugioh then
		ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_1"):setPercent(getStarCount / maxStar * 100)
	else
		local tmpHoldStar = getStarCount - 5
		if tmpHoldStar < 0 then tmpHoldStar = 0 end
		local tmpMaxStar = maxStar - 5
		--更新进度条
		ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_1"):setPercent(tmpHoldStar / tmpMaxStar * 100)
	end
end


function PVESecondarySceneCover:updateStarBox(isbool)

	local starRewardState = zstring.tonumber(_ED.star_reward_state[self.sceneID])
	local rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.reward_need_star), ",")
	--已经获得星星的数量
	local getStarCount = tonumber(_ED.get_star_count[self.sceneID])
	
	local chestsPanelName = {
		"Panel_14484",
		"Panel_14485",
		"Panel_14486"
	}

	for i = 1, table.getn(rewardNeedStar) do
		local chest = ccui.Helper:seekWidgetByName(self.roots[1], chestsPanelName[i])
		local chest_cell = PlotCopyChest:createCell()
		local param = {state = 0, starNum = zstring.tonumber(rewardNeedStar[i]), boxIndex = i}
		if param.starNum <= getStarCount then
			param.state = 1
		end
		chest_cell:init(i, param, self.sceneID)
		
		--使用前先清空
		for _, v in pairs(chest:getChildren()) do
			chest:removeChild(v)
		end
		
		chest:addChild(chest_cell)
	end
	
	
	-- if true == isbool then
		-- 外部的更新
	-- end
	
end

function PVESecondarySceneCover:onUpdate(dt)
	if __lua_project_id == __lua_project_yugioh then 
		
		if zstring.tonumber(_ED.secret_shopPerson_pageIndex) == 1 then 
			if self.interval > 0 then
		        local interval = (_ED.secret_shopPerson_init_info.native_time + zstring.tonumber(_ED.secret_shopPerson_init_info.leave_time)/1000) - os.time()
		        if self.interval ~= interval then
		            self.interval = interval
		            self:updateRefreshCd()
		        end
    		end
		end
	end
end

function PVESecondarySceneCover:updateRefreshCd()
	if self.needUpdateRefreshCd == false then
        return
    end
	local root = self.roots[1]
    local interval = self.interval

	if interval <= 0 then
		local timeText = ccui.Helper:seekWidgetByName(root, "Text_time")
		timeText:setString("00:00:00")
		timeText:setVisible(false)
		self.needUpdateRefreshCd = false
		ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(false)
	else
		self.interval = math.max(0, self.interval)
		self.needUpdateRefreshCd = true
		
        local timeTabel = formatTime(self.interval)
        self.strtime = timeTabel.hour
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.minute)
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.second)
		local timeText = ccui.Helper:seekWidgetByName(root, "Text_time")
        timeText:setString(self.strtime)
        timeText:setVisible(true)
	end
end

function PVESecondarySceneCover:init(sceneID,currentPageType)
	
	self.sceneID = sceneID
	self.currentPageType = currentPageType
end

function PVESecondarySceneCover:onEnterTransitionFinish()
	local csbPVESecondarySceneCover = csb.createNode("duplicate/pve_duplicate.csb")
	
	local root = csbPVESecondarySceneCover:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVESecondarySceneCover)
	local backBtn = ccui.Helper:seekWidgetByName(root, "Button_1_backBtn")
	fwin:addTouchEventListener(backBtn, nil, 
	{
		terminal_name = "duplicate_pve_secondary_scene_back_click", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		sceneID = self.sceneID,
		currentPageType = self.currentPageType
	},
	nil, 0)
	

	local name = dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.scene_name)
	ccui.Helper:seekWidgetByName(root, "Text_1"):setString(name)

	if self.currentPageType == 1 or self.currentPageType == 2 then
		self:onUpdateDrawBottom()
	else
		ccui.Helper:seekWidgetByName(root, "Panel_3"):setVisible(false)
	end

	if __lua_project_id == __lua_project_yugioh then 
		self:checkHasMagicShop()
	end
end

function PVESecondarySceneCover:checkHasMagicShop()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local magicButton = ccui.Helper:seekWidgetByName(root, "Button_1")
	if zstring.tonumber(_ED.secret_shopPerson_pageIndex) == 1 and (self.currentPageType == 1 or self.currentPageType == 2) then 
		self.interval = zstring.tonumber(_ED.secret_shopPerson_init_info.leave_time) /1000
		fwin:addTouchEventListener(magicButton, nil, 
		{
			terminal_name = "duplicate_pve_secondary_scene_meet_shopmen", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
		},
		nil, 0)
		if self.interval > 0  then
			local remainTime = _ED.secret_shopPerson_init_info.native_time + self.interval - os.time()
			if remainTime > 0 then 
				self.needUpdateRefreshCd = true
				if _ED.secret_shopPerson_init_info.goods_info ~= nil then
					for i,v in pairs(_ED.secret_shopPerson_init_info.goods_info) do
						if zstring.tonumber(v.remain_times) > 0 then 
							isCanBuy = true
							state_machine.excute("duplicate_pve_secondary_scene_meet_shopmen",0,0)
							break
						end
					end
				end
				self:registerOnNoteUpdate(self, 0)
				magicButton:setVisible(true)
			end
		end
	else
		magicButton:setVisible(false)
	end		
end

--通用按钮点击事件添加
function PVESecondarySceneCover:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = "", 
		but_image = "",
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	},
	nil, 0)
	return tmpArt
end

function PVESecondarySceneCover:onExit()
end

function PVESecondarySceneCover:createCell()
	local cell = PVESecondarySceneCover:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
