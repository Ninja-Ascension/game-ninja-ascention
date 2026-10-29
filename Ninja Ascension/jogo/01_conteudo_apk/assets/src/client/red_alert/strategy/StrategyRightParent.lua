--------------------------------------------
-- 攻略右侧主界面
--------------------------------------------
StrategyRightParent = class("StrategyRightParentClass", Window)
StrategyRightParent.__BaseSize = nil
    
function StrategyRightParent:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
	self.strategyId = 0
	self.isSelected = false
	
    local function init_strategy_right_parent_terminal()
        --前往
		local strategy_right_parent_selected_terminal = {
            _name = "strategy_right_parent_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local traceFunctionId = params._datas.functionId
				local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
				if dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
					if dms.int(dms["function_param"], traceFunctionId, function_param.genre) == 12 then
						local lastSceneId = -1
						local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 9)
						for i, v in pairs(_scenes) do
							local tempSceneId = dms.atoi(v, pve_scene.id)
							if _ED.scene_current_state[tempSceneId] == nil
								or _ED.scene_current_state[tempSceneId] == ""
								or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
								then
								break
							end
							lastSceneId = tempSceneId
						end
						if lastSceneId < 0 then
							local dySceneDes = dms.atos(_scenes[1], pve_scene.open_condition_describe)
							TipDlg.drawTextDailog(dySceneDes)
							return
						end
					end
					
					if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
						fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
					end
					state_machine.excute("short_cut_go_to_other_window", 0, {traceFunctionId})
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
				end
				state_machine.excute("strategy_main_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(strategy_right_parent_selected_terminal)
        state_machine.init()
    end
    init_strategy_right_parent_terminal()
end

function StrategyRightParent:onUpdateDraw()
	local root = self.roots[1]
	-- 标题
    local title = dms.string(dms["strategy"], self.strategyId, strategy.title)			
    local Text_title_name = ccui.Helper:seekWidgetByName(root, "Text_title_name")
    Text_title_name:setString(title)
    -- 描述
    local dialogue = dms.string(dms["strategy"], self.strategyId, strategy.dialogue)	
    local Text_miaoshu = ccui.Helper:seekWidgetByName(root, "Text_miaoshu")
    Text_miaoshu:setString(dialogue)
    -- 图标
    local pic = dms.int(dms["strategy"], self.strategyId, strategy.pic)					
    local iconPath = string.format("images/ui/raiders_icon/fenxiang_%d.png", pic)
    local Panel_hei_icon = ccui.Helper:seekWidgetByName(root, "Panel_hei_icon")
	Panel_hei_icon:setBackGroundImage(iconPath)
	-- 开启条件
    local fun_open_condition = dms.string(dms["strategy"], self.strategyId, strategy.fun_open_condition)	
    local Text_funopen = ccui.Helper:seekWidgetByName(root, "Text_funopen")
    Text_funopen:setString(fun_open_condition)
    -- 跳转id
    local function_point = dms.int(dms["strategy"], self.strategyId, strategy.function_point)	
    -- 前往
	local Button_hong = ccui.Helper:seekWidgetByName(root, "Button_hong")
	local Text_qianwang = ccui.Helper:seekWidgetByName(root, "Text_qianwang")
	if function_point > 0 then 
		Button_hong:setVisible(true)
		Text_qianwang:setVisible(true)
	else
		Button_hong:setVisible(false)
		Text_qianwang:setVisible(false)
	end
	fwin:addTouchEventListener(Button_hong, nil, 
	{
		terminal_name = "strategy_right_parent_selected", 
		terminal_state = 0,
		_cell = self,
		functionId = function_point,
		isPressedActionEnabled = true
	}, nil, 0)

	ccui.Helper:seekWidgetByName(root, "Image_zhankai"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_shouqi_0"):setVisible(false)

	
end

function StrategyRightParent:updateSelectState( ... )
	self.more_panel:removeAllChildren(true)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Image_zhankai"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_shouqi_0"):setVisible(false)
	if self.isSelected == true then
		local strategyData = dms.element(dms["strategy"], self.strategyId)
		local function_points = zstring.split(dms.atos(strategyData, strategy.function_point), ",")
		local totalCount = #function_points
		local totalHeight = 0
		for i=1,totalCount do
			local index = totalCount + 1 - i
			local functionId = function_points[index]
			local genre = dms.int(dms["function_param"], functionId, function_param.genre)
			if genre == 99 or genre == 100 then
				local cell = StrategyRightFormation:createCell()
				cell:init(i, functionId, genre)
				self.more_panel:addChild(cell)
				cell:setPosition(cc.p(0, totalHeight))
				totalHeight = totalHeight + cell:getContentSize().height
			else
				local cell = StrategyRightChild:createCell()
				cell:init(i, functionId)
				self.more_panel:addChild(cell)
				cell:setPosition(cc.p(0, totalHeight))
				totalHeight = totalHeight + cell:getContentSize().height
			end
		end
		self.more_panel:setContentSize(StrategyRightParent.__BaseSize.width, totalHeight)
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setPosition(cc.p(0, totalHeight))
		self.more_panel:setPosition(cc.p(0, 0))
		self:setContentSize(StrategyRightParent.__BaseSize.width,
			StrategyRightParent.__BaseSize.height + totalHeight)
	else
		self.more_panel:setContentSize(StrategyRightParent.__BaseSize)
		self:setContentSize(StrategyRightParent.__BaseSize)
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setPosition(cc.p(0, 0))
	end
end

function StrategyRightParent:onEnterTransitionFinish()
	local root = cacher.createUIRef(config_csb.system.raiders_xzs_right, "root")
	self:addChild(root)

	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())
	if StrategyRightParent.__BaseSize == nil then
		StrategyRightParent.__BaseSize = self:getContentSize()
	end
	self.more_panel = ccui.Helper:seekWidgetByName(root, "Panel_list_xia")
	
	self:onUpdateDraw()
end

function StrategyRightParent:onExit( ... )
	cacher.freeRef(config_csb.system.raiders_xzs_right, self.roots[1])
end

function StrategyRightParent:init(index, strategyId)
	self.index = index
	self.strategyId = strategyId
end

function StrategyRightParent:createCell()
	local cell = StrategyRightParent:new()
	cell:registerOnNodeEvent(cell)
	return cell
end