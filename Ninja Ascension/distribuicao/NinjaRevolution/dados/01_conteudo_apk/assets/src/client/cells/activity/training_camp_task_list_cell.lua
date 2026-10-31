--------------------------------------------------------------------------------------------------------------
--  说明：大师训练营任务cell
--------------------------------------------------------------------------------------------------------------
training_camp_task_list_cell = class("training_camp_task_list_cellClass", Window)
training_camp_task_list_cell.__size = nil

--创建cell
local training_camp_task_list_cell_terminal = {
    _name = "training_camp_task_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = training_camp_task_list_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(training_camp_task_list_cell_terminal)
state_machine.init()

function training_camp_task_list_cell:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
    app.load("client.activity.dailytask.newachieve.achievement_list_cell_new")

    local function init_training_camp_task_list_cell_terminal()
        local training_camp_task_list_cell_terminal = {
            _name = "training_camp_go_task",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if self._is_finsh then
                    TipDlg.drawTextDailog(tipStringInfo_training_camp_name[19])
                end
                local traceFunctionId = params._datas.trace_function_id
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
              
                local openparmId = dms.int(dms["activity_pm_task_mould"], traceFunctionId,8)
                local openFunctionId = dms.int(dms["function_param"], openparmId, function_param.open_function)
                if dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
                    if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
                        fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
                    end
                    state_machine.excute("shortcut_function_trace", 0, {trace_function_id = openparmId, _datas = {}})
                else
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local training_camp_task_list_send_call_terminal = {
            _name = "training_camp_task_list_send_call",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                    local function callBack( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        end
                    end
                    NetworkManager:register(protocol_command.activity_pokemon_master_show_task.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(training_camp_task_list_cell_terminal) 
        state_machine.add(training_camp_task_list_send_call_terminal)
        state_machine.init()
    end 
    init_training_camp_task_list_cell_terminal()

end

function training_camp_task_list_cell:updateDrawInfo(info)
    local root = self.roots[1]
   
    local AtlasLabel_exp_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_exp_n")    --经验值
    local Text_traing_task_infor = ccui.Helper:seekWidgetByName(root, "Text_traing_task_infor")  --任务描述
    local Text_traing_task_tip = ccui.Helper:seekWidgetByName(root, "Text_traing_task_tip")  --任务提示
    local Text_traing_task_infor_n = ccui.Helper:seekWidgetByName(root, "Text_traing_task_infor_n")  --次数

    local jsonFile = "images/ui/effice/effect_bkmxly/effect_bkmxly.json"      --背景光效
    local atlasFile = "images/ui/effice/effect_bkmxly/effect_bkmxly.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_task_fnish_effect = ccui.Helper:seekWidgetByName(root, "Panel_task_fnish_effect") 
    
    function Callback(sender)
        Panel_task_fnish_effect:removeAllChildren(true) 
        state_machine.excute("training_camp_task_list_send_call", 0, nil)
    end
    if tonumber(self.activity.taskShow) == 1 then
        Panel_task_fnish_effect:addChild(animation)

        self:runAction(cc.Sequence:create(
        cc.DelayTime:create(1),
        cc.CallFunc:create(Callback)
        ))
    end
    
    local completeCount = dms.int(dms["activity_pm_task_mould"], self.activity.taskId,5)  
    local exp = dms.int(dms["activity_pm_task_mould"], self.activity.taskId,7)  
    local tasktwo = dms.int(dms["activity_pm_task_mould"], self.activity.taskId,3)   
    AtlasLabel_exp_n:setString(exp)
    Text_traing_task_infor_n:setString(self.activity.completeCount)

    local taskone = dms.int(dms["activity_pm_task_mould"], self.activity.taskId,2)  
    local tasktwo = dms.int(dms["activity_pm_task_mould"], self.activity.taskId,3)   

    local word_info_one = dms.element(dms["word_mould"], taskone)
    name_one = word_info_one[3]   
    Text_traing_task_infor:setString(name_one)

    local word_info_two = dms.element(dms["word_mould"], tasktwo)
    name_two = word_info_two[3]   
    Text_traing_task_tip:setString(name_two.."       "..self.activity.count.."/"..completeCount)

end

function training_camp_task_list_cell:onUpdate(dt)
    
end


function training_camp_task_list_cell:onInit()
    local root = cacher.createUIRef("activity/wonderful/training_camp_task_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    if training_camp_task_list_cell.__size == nil then
        training_camp_task_list_cell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_training_task_go"), nil, 
    {
        terminal_name = "training_camp_go_task", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
        trace_function_id = self.activity.taskId,
    }, nil, 1)
     
    self:clearUIInfo()
	self:updateDrawInfo()
end

function training_camp_task_list_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function training_camp_task_list_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local AtlasLabel_exp_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_exp_n")    --经验值
    local Text_traing_task_infor = ccui.Helper:seekWidgetByName(root, "Text_traing_task_infor")  --任务描述
    local Text_traing_task_tip = ccui.Helper:seekWidgetByName(root, "Text_traing_task_tip")  --任务提示
    local Text_traing_task_infor_n = ccui.Helper:seekWidgetByName(root, "Text_traing_task_infor_n")  --次数
    local Panel_task_fnish_effect = ccui.Helper:seekWidgetByName(root, "Panel_task_fnish_effect")  --光效
    
    if Text_exp_n then
        Text_exp_n:setString("")
        Text_traing_task_infor:setString("")
        Text_traing_task_tip:setString("")
        Text_traing_task_infor_n:setString("")
        AtlasLabel_exp_n:setString("")
        Panel_task_fnish_effect:removeAllChildren(true) 
    end
end

function training_camp_task_list_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function training_camp_task_list_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_task_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function training_camp_task_list_cell:init(params)
    self.activity = params[1]
    self._is_finsh =  params[2]
	self:onInit()
    self:setContentSize(training_camp_task_list_cell.__size)
    return self
end

function training_camp_task_list_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_task_cell.csb", self.roots[1])
end