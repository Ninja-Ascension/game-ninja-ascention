-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE副本场景管理
-------------------------------------------------------------------------------------------------------
LPVERaidSelectPanel = class("LPVERaidSelectPanelClass", Window)
local lpve_raid_select_open_terminal = {
    _name = "lpve_raid_select_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("lpve_raid_select_open")
        local _type = params[1]
        local currentSceneType = params[2]
        local _LPVERaidSelectPanel = LPVERaidSelectPanel:new()
        _LPVERaidSelectPanel:init(_type,currentSceneType)
        fwin:open(_LPVERaidSelectPanel,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(lpve_raid_select_open_terminal)
state_machine.init()
function LPVERaidSelectPanel:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}

	self.LPVERaidSelectPanelID = 0
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
	
	app.load("client.landscape.cells.duplicate.lduplicate_select_seat_cell")

    local function init_pve_raid_select_terminal()
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
        -- 精英副本
        local lpve_raid_select_panel_close_action_terminal = {
            _name = "lpve_raid_select_panel_close_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("lpve_star_cheat_goto_open_list")
                instance:playCloseAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_raid_select_panel_plot_copy_terminal)
        state_machine.add(pve_raid_select_panel_elite_copy_terminal)
        state_machine.add(lpve_raid_select_panel_close_action_terminal)
        state_machine.init()
    end
    
    -- call func init LPVERaidSelectPanel state machine.
    init_pve_raid_select_terminal()
end
function LPVERaidSelectPanel:playCloseAction()
    self.actions[1]:play("zhangjie_list_2",false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "zhangjie_list_2_over" then
            state_machine.excute("lpve_star_cheat_button_change_state",0,2)
            fwin:close(self)
            state_machine.unlock("lpve_star_cheat_goto_open_list")
        end
        
    end)
end
function LPVERaidSelectPanel:init(_currentPageType, _currentSceneType)
    self.currentPageType = _currentPageType
	self.currentSceneType = _currentSceneType
    return self
end

function LPVERaidSelectPanel:loading_cell()
	if LPVERaidSelectPanel.cacheListView == nil then 
		return
	end

	-- local openFlag = not (LPVERaidSelectPanel.asyncIndex == 1) and true or false
	
	local v = self.openSceneList[LPVERaidSelectPanel.nCount - LPVERaidSelectPanel.asyncIndex + 1]
	if v ~= nil then
        local tmpDSSC = LDuplicateSelectSeatCell:createCell()
    	tmpDSSC:init(v, self.currentPageType, LPVERaidSelectPanel.asyncIndex, #self.openSceneList)
    	LPVERaidSelectPanel.cacheListView:insertCustomItem(tmpDSSC, 0)
    	LPVERaidSelectPanel.cacheListView:requestRefreshView()
    	LPVERaidSelectPanel.cacheListView:getInnerContainer():setPositionX(-LPVERaidSelectPanel.cacheListView:getInnerContainer():getContentSize().width)
    	LPVERaidSelectPanel.asyncIndex = LPVERaidSelectPanel.asyncIndex + 1
    end
end

function LPVERaidSelectPanel:onUpdateDraw()
	
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
					-- -- 未开启章节
					-- sCount = sCount + 1
					-- sCountCurrent = sCount
					-- normalScene[sCount] = i
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
    
    if self.maxMapCount < 6 then
        local Image_13 = ccui.Helper:seekWidgetByName(self.roots[1],"Image_13")
        local size = self.cacheListView:getContentSize()
        local imageSize = Image_13:getContentSize()
        self.cacheListView:setContentSize(cc.size(70*self.maxMapCount,size.height))
        Image_13:setContentSize(cc.size(70*self.maxMapCount+10*self.maxMapCount,imageSize.height))
    end

    self.openSceneList = normalScene
	self.cacheListView:removeAllItems()
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	LPVERaidSelectPanel.asyncIndex = 1
	LPVERaidSelectPanel.cacheListView = self.cacheListView
	
	local nCount = table.getn(self.openSceneList)
	LPVERaidSelectPanel.nCount = nCount
	
	for i = 1, nCount do
		if LPVERaidSelectPanel.asyncIndex <= 8 then
			self:loading_cell()
		else
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end
	self.cacheListView:refreshView()
    state_machine.unlock("lpve_raid_select_open")
end

function LPVERaidSelectPanel:onEnterTransitionFinish()
	local csbPveDuplicate = csb.createNode("duplicate/pve_main_zx_listview.csb")
    local root = csbPveDuplicate:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPveDuplicate)
	
    local action = csb.createTimeline("duplicate/pve_main_zx_listview.csb")
    table.insert(self.actions, action)
    csbPveDuplicate:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("zhangjie_list_1", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "zhangjie_list_1_over" then
            state_machine.excute("lpve_star_cheat_button_change_state",0,1)
        end
        
    end)
	self.cacheListView = ccui.Helper:seekWidgetByName(root, "ListView_pve_zx")
	
	--显示场景数据

    local Panel_list_xy = ccui.Helper:seekWidgetByName(root, "Panel_list_xy")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_list_xy"), nil, 
    {
        terminal_name = "lpve_raid_select_panel_close_action",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    if self.currentPageType == 1 then
        state_machine.excute("pve_raid_select_panel_plot_copy", 0, "")
    elseif self.currentPageType == 2 then 
        state_machine.excute("pve_raid_select_panel_elite_copy", 0, "")
    else
        self:onUpdateDraw()
    end
end

function LPVERaidSelectPanel:onExit()
	LPVERaidSelectPanel.asyncIndex = 1
	LPVERaidSelectPanel.cacheListView = nil
	LPVERaidSelectPanel.nCount = 1
end

function LPVERaidSelectPanel:createCell()
	local cell = LPVERaidSelectPanel:new()
	cell:registerOnNodeEvent(cell)
	return cell
end