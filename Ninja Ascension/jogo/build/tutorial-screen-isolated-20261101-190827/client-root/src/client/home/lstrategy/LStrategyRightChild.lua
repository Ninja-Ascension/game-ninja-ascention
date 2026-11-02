
LStrategyRightChild = class("LStrategyRightChildClass", Window)
    
function LStrategyRightChild:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
	self.functionId = 0
	
    local function init_strategy_right_child_terminal()
		local lstrategy_right_child_selected_terminal = {
            _name = "lstrategy_right_child_selected",
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
					state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(lstrategy_right_child_selected_terminal)
        state_machine.init()
    end
    init_strategy_right_child_terminal()
end

function LStrategyRightChild:onUpdateDraw()
	local root = self.roots[1]
	local icon = dms.int(dms["function_param"], self.functionId, function_param.icon)
    local describe = dms.string(dms["function_param"], self.functionId, function_param.describe)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local describeInfo = ""
        local describeData = zstring.split(describe, "|")
        for i, v in pairs(describeData) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            describeInfo = describeInfo .. word_info[3]
        end
        
        describe = describeInfo
    end
    local iconPath = string.format("images/ui/function_icon/function_icon_%d.png", icon)
	ccui.Helper:seekWidgetByName(root, "Panel_hei_icon"):setBackGroundImage(iconPath)
	ccui.Helper:seekWidgetByName(root, "Text_miaoshu"):setString(describe)
end

function LStrategyRightChild:onEnterTransitionFinish()
	local csbStrategyRight = csb.createNode("system/raiders_xzs_right_list.csb")
	self:addChild(csbStrategyRight)
	local root = csbStrategyRight:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianwang"), nil, 
	{
		terminal_name = "lstrategy_right_child_selected", 
		terminal_state = 0,
		functionId = self.functionId
	}, nil, 0)
	self:onUpdateDraw()
end

function LStrategyRightChild:init(index, functionId)
	self.index = index
	self.functionId = functionId
end

function LStrategyRightChild:createCell()
	local cell = LStrategyRightChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end