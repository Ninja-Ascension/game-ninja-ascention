-- ----------------------------------------------------------------------------------------------------
-- 说明：攻略cell
-- 创建时间	2015.5.4
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

StrategyListChild = class("StrategyListChildClass", Window)

    
function StrategyListChild:ctor()
    self.super:ctor()
    self.roots = {}
	self.data = nil

    local function init_strategy_list_child_terminal()
		
		local strategy_list_child_in_terminal = {
            _name = "strategy_list_child_in",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local traceFunctionId = params._datas.trace_function_id
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

		state_machine.add(strategy_list_child_in_terminal)
        state_machine.init()
    end
    
    init_strategy_list_child_terminal()
end

function StrategyListChild:onUpdateDraw()
	local root = self.roots[1]
	-- Panel_333
	local pic = dms.int(dms["function_param"], self.data, function_param.icon)
	local name = dms.string(dms["function_param"], self.data, function_param.name)
	local des = dms.string(dms["function_param"], self.data, function_param.describe)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local describeInfo = ""
        local describeData = zstring.split(des, "|")
        for i, v in pairs(describeData) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            describeInfo = describeInfo .. word_info[3]
        end
        
        des = describeInfo
    end
	ccui.Helper:seekWidgetByName(root, "Text_135"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Text_135_0"):setString(des)
	ccui.Helper:seekWidgetByName(root, "Panel_333"):setBackGroundImage(string.format("images/ui/function_icon/function_icon_%d.png", pic))
	
	
end

function StrategyListChild:onEnterTransitionFinish()
	local csbStrategyList = csb.createNode("system/raiders_detailed_list.csb")
	self:addChild(csbStrategyList)
	local action = csb.createTimeline("system/raiders_detailed_list.csb")
    csbStrategyList:runAction(action)
	action:play("list_view_cell_open", false)
	local root = csbStrategyList:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_236"):getContentSize())
	self:onUpdateDraw()
	ccui.Helper:seekWidgetByName(root, "Panel_236"):setSwallowTouches(false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_132"), nil, 
	{
		terminal_name = "strategy_list_child_in", 
		terminal_state = 0,
		trace_function_id = self.data,
		isPressedActionEnabled = true
	}, nil, 0)

	
end


function StrategyListChild:init(data)
	self.data = data
end

function StrategyListChild:onExit()
	state_machine.remove("strategy_list_child_in")
end

function StrategyListChild:createCell()
	local cell = StrategyListChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end