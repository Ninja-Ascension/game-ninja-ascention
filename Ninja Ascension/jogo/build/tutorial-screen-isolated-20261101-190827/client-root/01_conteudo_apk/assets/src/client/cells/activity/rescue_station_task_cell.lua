--[[ ----------------------------------------------------------------------------
-- 奖励预览列表控件
--]] ----------------------------------------------------------------------------
RescueStationTaskCell = class("RescueStationTaskCellClass", Window)
RescueStationTaskCell.__size = nil

-- 创建Cell实例
local rescue_station_task_cell_create_terminal = {
	_name = "rescue_station_task_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RescueStationTaskCell then
			local cell = RescueStationTaskCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_task_cell_create_terminal)
state_machine.init()

-- 构造器
function RescueStationTaskCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    app.load("client.activity.rescuestation.RescueStationTask")
	-- var
	local function init_rescue_station_task_cell_terminal()
		local rescue_station_task_list_cell_terminal = {
            _name = "rescue_station_go_task",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local traceFunctionId = tonumber(params._datas._cell._info.task_type) 
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if traceFunctionId == 9999 then
                        app.load("client.system.share.ShareCenter")
                        local invite_id = 0
                        for i=1,#dms["share_reward_mould"] do
                            local share_type = dms.int(dms["share_reward_mould"],i,share_reward_mould.share_type)
                            if share_type == 5 then
                                invite_id = dms.int(dms["share_reward_mould"],i,share_reward_mould.id)
                                break
                            end
                        end
                        state_machine.excute("shareCenter_to_getdata_and_open_share_dlg",0,{ _datas = { share_id = invite_id } })                   
                        return
                    end
                end
              
                local openparmId = dms.int(dms["role_rescue_task"], traceFunctionId,7)
                local openFunctionId = dms.int(dms["function_param"], openparmId, function_param.open_function)              
                if openFunctionId == -1 then
                    if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
                        fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
	                end
	                state_machine.excute("shortcut_function_trace", 0, {trace_function_id = openparmId, _datas = {}})
                else
	                if dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
	                    if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
	                        fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
	                    end
	                    state_machine.excute("shortcut_function_trace", 0, {trace_function_id = openparmId, _datas = {}})
	                else
	                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
	                end
                end
               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         local rescue_station_task_list_send_call_terminal = {
            _name = "rescue_station_task_list_send_call",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                    local function callBack( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        	state_machine.excute("rescue_station_task_update", 0, nil)
                        end
                    end
                    protocol_command.activity_pockmon_rescue_show_task.param_list = params[1]
                    NetworkManager:register(protocol_command.activity_pockmon_rescue_show_task.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
  
        state_machine.add(rescue_station_task_list_cell_terminal)
        state_machine.add(rescue_station_task_list_send_call_terminal)
		state_machine.init()
	end
	init_rescue_station_task_cell_terminal()
end

-- 对象初始化
function RescueStationTaskCell:init(params)
	self._info = params[1]
	self._idex = self._info.task_id
	self:onInit(params)
	self:setContentSize(RescueStationTaskCell.__size)
	return self
end

function RescueStationTaskCell:onUpdateDraw()
	local root = self.roots[1]
    local task_info =  dms.searchs(dms["role_rescue_task"],4,tonumber(self._info.task_type))
    task_info = task_info[1]

    -- 任务完成时显示
	self.Image_task_already = ccui.Helper:seekWidgetByName(root, "Image_task_already")

	-- -- 任务名称
	self.Text_station_task_name = ccui.Helper:seekWidgetByName(root, "Text_station_task_name")

	local tasktwo = tonumber(task_info[2])
    local word_info_two = dms.element(dms["word_mould"], tasktwo)
    name_two = word_info_two[3]   
    self.Text_station_task_name:setString(name_two)
    
    -- 完成数量
	self.Text_station_task_fins_time_n = ccui.Helper:seekWidgetByName(root, "Text_station_task_fins_time_n")
	self.Text_station_task_fins_time_n:setString(self._info.count.."/"..self._info.max_count)

    local Image_station_task_not_opened =  ccui.Helper:seekWidgetByName(root, "Image_station_task_not_opened")
    if self._info.isopen == 0 then
    	self.Button_station_task_go:setVisible(false)
    	Image_station_task_not_opened:setVisible(true)
    	self.Text_station_task_fins_time_n:setVisible(false)
    else
    	self.Button_station_task_go:setVisible(true)
    	Image_station_task_not_opened:setVisible(false)
    	self.Text_station_task_fins_time_n:setVisible(true)
    end

    if tonumber(self._info.count) >= tonumber(self._info.max_count) then
        self.Image_task_already:setVisible(true)
        self.Button_station_task_go:setVisible(false)
        Image_station_task_not_opened:setVisible(false)
        self.Text_station_task_fins_time_n:setVisible(false)
    else
       self.Image_task_already:setVisible(false)
    end
    
	-- 任务描述
	self.Text_station_task_info = ccui.Helper:seekWidgetByName(root, "Text_station_task_info")

    local taskone = tonumber(task_info[3])
    local word_info_one = dms.element(dms["word_mould"], taskone)
    name_one = word_info_one[3]   
    self.Text_station_task_info:setString(name_one)

	-- 奖励积分
	self.Text_station_task_reward_n = ccui.Helper:seekWidgetByName(root, "Text_station_task_reward_n")
    self.Text_station_task_reward_n:setString(self._info.get_score) 

	local jsonFile = "images/ui/effice/effect_bkmxly/effect_bkmxly.json"      --背景光效
    local atlasFile = "images/ui/effice/effect_bkmxly/effect_bkmxly.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)

	-- 任务完成时播放动画
	self.Panel_station_task_effect = ccui.Helper:seekWidgetByName(root, "Panel_station_task_effect")
	function Callback(sender)
        self.Panel_station_task_effect:removeAllChildren(true) 
        state_machine.excute("rescue_station_task_list_send_call", 0, {self._idex})
    end
    if tonumber(self._info.is_show) == 1 then
        self.Panel_station_task_effect:addChild(animation)

        self:runAction(cc.Sequence:create(
        cc.DelayTime:create(1),
        cc.CallFunc:create(Callback)
        ))
    end

end

function RescueStationTaskCell:onEnterTransitionFinish()
	
end

function RescueStationTaskCell:onInit(params)
	
	local root = cacher.createUIRef("activity/rescue_station/rescue_station_task_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RescueStationTaskCell.__size == nil then
		RescueStationTaskCell.__size = root:getContentSize()
	end

	-- 前往
	self.Button_station_task_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_station_task_go"), nil,
	{
		terminal_name = "rescue_station_go_task",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_cell = self
	}, nil, 0)	


	self:onUpdateDraw()
end

function RescueStationTaskCell:onExit()
	-- 释放RescueStationTaskCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/ue_station_task_cell.csb", root)
	-- ]]
end

function RescueStationTaskCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RescueStationTaskCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/ue_station_task_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
