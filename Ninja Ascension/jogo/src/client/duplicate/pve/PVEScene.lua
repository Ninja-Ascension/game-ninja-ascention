-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景管理
-------------------------------------------------------------------------------------------------------
PVEScene = class("PVESceneClass", Window)

function PVEScene:ctor()
    self.super:ctor()
    self.roots = {}
	self.pveSceneID = 0
	self.sceneNameTxt = ""  --当前场景名称
	self.getStarCount = 0	--当前场景拥有星数
	self.sceneStarNum = 0	--当前场景总星数
	self.rewardNeedStar = {}	--得奖所需星数表
	self.starRewardState = 0	-- 

	app.load("client.duplicate.pve.PVEMap")
	app.load("client.duplicate.pve.PVESceneStarChart")
	app.load("client.duplicate.pve.PVEMapInformation")
	app.load("client.cells.copy.plot_copy_chest")
    -- Initialize PVEScene page state machine.
    local function init_pve_scene_terminal()	
		-- 打开副本星数排行榜
		local plot_copy_window_open_star_chart_terminal = {
            _name = "plot_copy_window_open_star_chart",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local star = PVESceneStarChart:new()
				star:init()
				fwin:open(star, fwin._view)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--关闭当前窗口
		local pve_scene_close_terminal = {
            _name = "pve_scene_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:close(instance)
				fwin:removeAll()
				fwin:open(Menu:new(), fwin._taskbar)
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_duplicate", 	
							but_image = "Image_duplicate", 		
							terminal_state = 0, 
							touch_scale = true
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(plot_copy_window_open_star_chart_terminal)
        state_machine.add(pve_scene_close_terminal)
        state_machine.init()
    end
    
    -- call func init PVEScene state machine.
    init_pve_scene_terminal()
end

function PVEScene:onUpdateDraw()
	local userStar 	= (self.getStarCount/self.sceneStarNum) * 100						--星数进度条
	--进度条数值限制
	if userStar < 0 then
		userStar = 0
	elseif userStar > 100 then
		userStar = 100
	end
	
	local SceneName = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1")
	local SceneStar = ccui.Helper:seekWidgetByName(self.roots[1], "Text_2")
	local LoadingBarStar = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1")
	
	SceneName:setString(self.sceneNameTxt)
	SceneStar:setString(self.getStarCount.."/"..self.sceneStarNum)
	LoadingBarStar:setPercent(userStar)
	
	local chestsPanelName = {
		"Panel_14484",
		"Panel_14485",
		"Panel_14486",
	}
	
	local index = 0
	local sceneId = self.pveSceneID
	for i = 1, table.getn(self.rewardNeedStar) do
		index = table.getn(chestsPanelName) - i + 1
		local chest = ccui.Helper:seekWidgetByName(self.roots[1], chestsPanelName[index])
		local chest_cell = PlotCopyChest:createCell()
		local param = {state = 0, starNum = zstring.tonumber(self.rewardNeedStar[i])}
		if self.starRewardState < index then
			if param.starNum <= self.getStarCount then
				param.state = 1
			end
		else
			param.state = 2
		end
		chest_cell:init(index, param, sceneId)
		chest:addChild(chest_cell)
	end
	
end

function PVEScene:init(pveSceneID)
	self.pveSceneID = pveSceneID
	-- 实现实现pve场景的绘制
	self.rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.reward_need_star), ",")
	self.sceneNameTxt = dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.scene_name)
	self.sceneStarNum = dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.total_star)
	self.getStarCount = tonumber(_ED.get_star_count[self.pveSceneID])
	self.starRewardState = zstring.tonumber(_ED.star_reward_state[self.pveSceneID])
end

function PVEScene:onEnterTransitionFinish()
	local csbPveDuplicate = csb.createNode("duplicate/pve_duplicate.csb")
    local root = csbPveDuplicate:getChildByName("root")
	root:removeFromParent()
	table.insert(self.roots, root)
    self:addChild(root)
	--场景的绘制
    self:onUpdateDraw()
	
	local Map = PVEMap:new()
	Map:init(self.pveSceneID)
	fwin:open(Map, fwin._background)
	if __lua_project_id ~= __lua_project_red_alert_time then
		fwin:open(PVEMapInformation:new(), fwin._view)
	end
	
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, 
	{
		terminal_name = "pve_scene_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 2)
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"), nil, 
	{
		terminal_name = "plot_copy_window_open_star_chart", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 0)
end

function PVEScene:onExit()
    state_machine.remove("plot_copy_window_open_star_chart")
    state_machine.remove("pve_scene_close")
end