-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE副本场景管理
-------------------------------------------------------------------------------------------------------
PVERaidSelectPanel = class("PVERaidSelectPanelClass", Window)

function PVERaidSelectPanel:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.PVERaidSelectPanelID = 0
	self.sceneNameTxt = ""  --当前场景名称
	self.getStarCount = 0	--当前场景拥有星数
	self.sceneStarNum = 0	--当前场景总星数
	
	self.maxMapCount = 0
    self.openSceneList = nil
    self.currentPageType = 1
    self.currentSceneType = 0

    self.enum_page_type = {
        _page_type_plot_copy = 1,                   -- 主线副本
        _page_type_elite_copy = 2,                  -- 精英副本
        _page_type_great_copy = 3,                  -- 名将副本
        _page_type_daily_activity_copy = 4,         -- 日常活动副本
    }
	
	app.load("client.cells.duplicate.duplicate_select_seat_cell")

	-- app.load("client.duplicate.pve.PVEMap")
	-- app.load("client.duplicate.pve.PVERaidSelectPanelStarChart")
	-- app.load("client.duplicate.pve.PVEMapInformation")
	-- app.load("client.cells.copy.plot_copy_chest")
    -- Initialize PVERaidSelectPanel page state machine.
    local function init_pve_raid_select_terminal()
		local pve_raid_select_panel_manager_terminal = {
            _name = "pve_raid_select_panel_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    if state_machine.excute(params._datas.next_terminal_name, 0, params) == true then
                        terminal.last_terminal_name = params._datas.next_terminal_name
                    else
                        return false
                    end
				end
				
				-- set select ui button is highlighted
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
				end
				terminal.page_name = params._datas.but_image
				if terminal.select_button == nil and params._datas.current_button_name ~= nil then
					terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				else
					terminal.select_button = params
				end
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 普通副本
		local pve_raid_select_panel_plot_copy_terminal = {
            _name = "pve_raid_select_panel_plot_copy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:init(1, 0)
            	instance:onUpdateDraw()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 精英副本
		local pve_raid_select_panel_elite_copy_terminal = {
            _name = "pve_raid_select_panel_elite_copy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local user_grade=dms.int(dms["fun_open_condition"], 26, fun_open_condition.level)
                if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
                    instance:init(2, 1)
                    instance:onUpdateDraw()
                else
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 26, fun_open_condition.tip_info))
                    return false
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 打开副本星数排行榜
		-- local plot_copy_window_open_star_chart_terminal = {
            -- _name = "plot_copy_window_open_star_chart",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		--关闭当前窗口
		local pve_raid_select_close_terminal = {
            _name = "pve_raid_select_close",
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

        state_machine.add(pve_raid_select_panel_manager_terminal)
        state_machine.add(pve_raid_select_panel_plot_copy_terminal)
        state_machine.add(pve_raid_select_panel_elite_copy_terminal)
        state_machine.add(pve_raid_select_close_terminal)
        -- state_machine.add(pve_scene_close_terminal)
        state_machine.init()
    end
    
    -- call func init PVERaidSelectPanel state machine.
    init_pve_raid_select_terminal()
end

function PVERaidSelectPanel:init(_currentPageType, _currentSceneType)
    self.currentPageType = _currentPageType
	self.currentSceneType = _currentSceneType
    return self
end

function PVERaidSelectPanel:loading_cell()
	if PVERaidSelectPanel.cacheListView == nil then 
		return
	end

	local v = self.openSceneList[PVERaidSelectPanel.nCount - PVERaidSelectPanel.asyncIndex + 1]
	local tmpDSSC = DuplicateSelectSeatCell:createCell()
	tmpDSSC:init(v, self.currentPageType)
	PVERaidSelectPanel.cacheListView:addChild(tmpDSSC)
	PVERaidSelectPanel.cacheListView:requestRefreshView()
	PVERaidSelectPanel.asyncIndex = PVERaidSelectPanel.asyncIndex + 1
end

function PVERaidSelectPanel:onUpdateDraw()
	
	--显示所有seat
	local sCountCurrent = 0 --用于记录当前有多少条场景
    local normalScene = {}
    local sCount = 0
    local maxCount = 0
    local bLastScene = false
    
    local function getOpenSceneList()
        for i = 1,table.getn(_ED.scene_current_state) do
            local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type) --tonumber(elementAtToString(pveScene,i,pve_scene.scene_type))
            if _scene_type == self.currentSceneType then
                if _ED.scene_current_state[i] == nil or _ED.scene_current_state[i] == "" then
                    return
                end
                if tonumber(_ED.scene_current_state[i]) < 0 then
                    return
                end
                sCount = sCount + 1
                sCountCurrent = sCount
                normalScene[sCount] = i
            end
        end
    end
    getOpenSceneList()
	
    maxCount = sCount
    self.maxMapCount = sCount
    self.openSceneList = normalScene
	self.cacheListView:removeAllItems()
	--for i, v in pairs(self.openSceneList) do
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	PVERaidSelectPanel.asyncIndex = 1
	PVERaidSelectPanel.cacheListView = self.cacheListView
	
	local nCount = table.getn(self.openSceneList)
	PVERaidSelectPanel.nCount = nCount
	
	for i = 1, nCount do
		-- local v = self.openSceneList[nCount - i + 1]
		-- local tmpDSSC = DuplicateSelectSeatCell:createCell()
		-- tmpDSSC:init(v, self.currentPageType)
		-- self.cacheListView:addChild(tmpDSSC)
		
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
	end
	self.cacheListView:refreshView()


    -- draw tile 
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Panel_chapter"):setVisible(self.currentPageType <= 2)
    ccui.Helper:seekWidgetByName(root, "Text_zhangjie"):setString(_plot_copy_name[self.currentPageType])
end

-- function PVERaidSelectPanel:init(PVERaidSelectPanelID)
	-- self.PVERaidSelectPanelID = PVERaidSelectPanelID
	-- 实现实现pve场景的绘制
	-- self.rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(self.PVERaidSelectPanelID), pve_scene.reward_need_star), ",")
	-- self.sceneNameTxt = dms.string(dms["pve_scene"], tonumber(self.PVERaidSelectPanelID), pve_scene.scene_name)
	-- self.sceneStarNum = dms.string(dms["pve_scene"], tonumber(self.PVERaidSelectPanelID), pve_scene.total_star)
	-- self.getStarCount = tonumber(_ED.get_star_count[self.PVERaidSelectPanelID])
	-- self.starRewardState = zstring.tonumber(_ED.star_reward_state[self.PVERaidSelectPanelID])
-- end

function PVERaidSelectPanel:onEnterTransitionFinish()
	local csbPveDuplicate = csb.createNode("duplicate/pve_zhangjie.csb")
    local root = csbPveDuplicate:getChildByName("root")
	-- root:removeFromParent(true)
	table.insert(self.roots, root)

    local action = csb.createTimeline("duplicate/pve_zhangjie.csb")
    csbPveDuplicate:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)

    self:addChild(csbPveDuplicate)
	self.cacheListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self:addTouchEventFunc("Button_4", "pve_raid_select_close", true)
	-- self:addTouchEventFunc("Button_5", "pve_raid_select_close", true)
	-- self:addTouchEventFunc("Button_5_0", "pve_raid_select_close", true)

    -- 普通副本
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"),            nil, 
    {
        terminal_name = "pve_raid_select_panel_manager",     
        next_terminal_name = "pve_raid_select_panel_plot_copy",       
        current_button_name = "Button_5",    
        but_image = "Image_copy",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_list_ordinary_the_chest",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_5"),
	_invoke = nil,
	_interval = 0.5,})

    -- 精英副本
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_0"), nil, 
    {
        terminal_name = "pve_raid_select_panel_manager",     
        next_terminal_name = "pve_raid_select_panel_elite_copy",      
        current_button_name = "Button_5_0",
        but_image = "Image_elite_copy",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 0)
	
	--显示场景数据
    if self.currentPageType == 1 or self.currentPageType == 2 then
        state_machine.excute("pve_raid_select_panel_manager", 0, 
        {
            _datas = 
            {
                terminal_name = "pve_raid_select_panel_manager",     
                next_terminal_name = self.currentPageType == 1 and "pve_raid_select_panel_plot_copy" or "pve_raid_select_panel_elite_copy",      
                current_button_name = "Button_5",
                but_image = self.currentPageType == 1 and "Image_copy" or "Image_elite_copy",       
                terminal_state = 0, 
                isPressedActionEnabled = true
            }
        })
    else
        self:onUpdateDraw()
    end
end

function PVERaidSelectPanel:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = eventName, 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	},
	nil, 0)
	return tmpArt
end

function PVERaidSelectPanel:onExit()
	PVERaidSelectPanel.asyncIndex = 1
	PVERaidSelectPanel.cacheListView = nil
	PVERaidSelectPanel.nCount = 1
	
    state_machine.remove("pve_raid_select_close")
    -- state_machine.remove("pve_scene_close")
end