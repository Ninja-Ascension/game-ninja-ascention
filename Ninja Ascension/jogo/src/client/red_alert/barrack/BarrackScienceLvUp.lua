-----------------------------
--兵营科技升级
-----------------------------
BarrackScienceLvUp = class("BarrackScienceLvUpClass", Window)

--打开兵营科技升级界面
local barrack_science_lv_up_window_open_terminal = {
    _name = "barrack_science_lv_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local barrack_id = params[1]
        local index = params[2]
        if nil == fwin:find("BarrackScienceLvUpClass") then
            fwin:open(BarrackScienceLvUp:new():init(barrack_id,index), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭兵营科技升级界面
local barrack_science_lv_up_window_close_terminal = {
    _name = "barrack_science_lv_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BarrackScienceLvUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(barrack_science_lv_up_window_open_terminal)
state_machine.add(barrack_science_lv_up_window_close_terminal)
state_machine.init()

function BarrackScienceLvUp:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --兵营id
    self.barrack_id = nil
    --兵营数据
    self.barrack_data = nil
    --科技升级冷却最大时间
    self.max_time = nil
    self.index = nil
    self._text_table = {}
    -- Initialize barrack_science_lv_up state machine.
    local function init_barrack_science_lv_up_terminal()
	    --确认
        local barrack_science_lv_up_sure_terminal = {
            _name = "barrack_science_lv_up_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local text_table = instance._text_table
                local index = instance.index
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("barrack_science_update_cell",0,response.node.barrack_id)
                            if index > 8 then
                                if index > 16 then
                                    index = index - 16
                                else
                                    index = index - 8
                                end
                            end
                            state_machine.excute("add_number_window_open",0,{index + 15,text_table})
                        end
                            playEffect(formatMusicFile("effect", 10014))
                            state_machine.excute("barrack_science_lv_up_window_close",0,"")
                    end
                end

                local leava_time = math.max(_ED.barracks_leave_time - (os.time() - _ED.barracks_start_time),0)

                if leava_time > instance.max_time then
                    TipDlg.drawTextDailog(red_alert_all_str[90])    
                    return
                end

                protocol_command.barracks_teach_update.param_list = instance.barrack_id
                NetworkManager:register(protocol_command.barracks_teach_update.code, nil, nil, nil, instance, responseCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        state_machine.add(barrack_science_lv_up_sure_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_barrack_science_lv_up_terminal()
end

--刷新兵营科技升级界面
function BarrackScienceLvUp:onUpdateDraw()
    -- 解析兵营科技数据
    if _ED.barracks_escalate_info == nil or table.nums(_ED.barracks_escalate_info) == 0 then
        initAllBarracksEscapeData()
    end
    local root = self.roots[1]
    local Panel_skill_icon = ccui.Helper:seekWidgetByName(root,"Panel_skill_icon")      --兵营科技技能图标
    Panel_skill_icon:removeAllChildren(true)
    local cell = state_machine.excute("barrack_science_icon_create_cell",0,{self.barrack_id,2})
    Panel_skill_icon:addChild(cell)

    local Button_lv_up = ccui.Helper:seekWidgetByName(root,"Button_lv_up")              --升级按钮
    --需求兵营等级
    local Text_need_lv_up = ccui.Helper:seekWidgetByName(root,"Text_need_lv_up")        
    local need_level = _ED.barracks_escalate_info[""..self.barrack_id][""..self.barrack_data.barrack_level].need_barracks_level
    Text_need_lv_up:setString(string.format(red_alert_all_str[84],need_level - 1))

    if need_level > tonumber(_ED.home_build[""..2].level) then
        Button_lv_up:setVisible(false)
    else
        if need_level == -1 then
            Button_lv_up:setVisible(false) 
            Text_need_lv_up:setVisible(true)
        else   
            Button_lv_up:setVisible(true)
            Text_need_lv_up:setVisible(false)
        end
    end

    local Text_level_up_to = ccui.Helper:seekWidgetByName(root,"Text_level_up_to")          --提升等级text
    local Text_lv_up_spend_v = ccui.Helper:seekWidgetByName(root,"Text_lv_up_spend_v")      --升级所需木材text
    
    local Text_time_spend = ccui.Helper:seekWidgetByName(root,"Text_time_spend") 
    local Text_time_spend_v = ccui.Helper:seekWidgetByName(root,"Text_time_spend_v")        --升级所需时间text
    local need_time = _ED.barracks_escalate_info[""..self.barrack_id][""..self.barrack_data.barrack_level].need_time            --升级需求时间
    local need_resource = _ED.barracks_escalate_info[""..self.barrack_id][""..self.barrack_data.barrack_level].need_resource    --升级消耗
    local attributes = _ED.barracks_escalate_info[""..self.barrack_id][""..self.barrack_data.barrack_level].attribute           --当前属性值
    local next_attribute = _ED.barracks_escalate_info[""..self.barrack_id][""..(tonumber(self.barrack_data.barrack_level)+1)].attribute  --下一级增属性值
    local pos_type = _ED.barracks_escalate_info[""..self.barrack_id][""..self.barrack_data.barrack_level].pos_type              --增加属性对应的布阵类型
    Text_level_up_to:setString(string.format(red_alert_all_str[89],self.barrack_data.name,self.barrack_data.barrack_level+1))
    Text_time_spend_v:setString(self:formatTimeStringChinese(need_time))
    Text_lv_up_spend_v:setString(need_resource)
    Text_time_spend_v:setPositionX(Text_time_spend:getPositionX()+Text_time_spend:getContentSize().width*1.3)

    local Panel_effect_inner_2 = ccui.Helper:seekWidgetByName(root,"Panel_effect_inner_2")  --第二排效果
    if #attributes == 1 then
        Panel_effect_inner_2:setVisible(false)
    else
        Panel_effect_inner_2:setVisible(true)
    end

    for i,v in pairs(attributes) do
        --属性icon
        local Panel_effect_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_effect_icon_"..i)
        local attribute_type = tonumber(v.add_type)+1
        Panel_effect_icon_1:setBackGroundImage(string.format(config_res.images.ui.barrack.barrack_effect_icon, attribute_type))
        --增加属性对应的布阵类型
        local Text_effect_1 = ccui.Helper:seekWidgetByName(root,"Text_effect_"..i)      
        Text_effect_1:setString(refining_pos_des[pos_type]..attribute[attribute_type]..":")
        --当前属性值
        local Text_effect_v_1 = ccui.Helper:seekWidgetByName(root,"Text_effect_v_"..i)
        Text_effect_v_1:setString(v.add_number)
        --下一级增加属性值
        local Text_effect_v_add_1 = ccui.Helper:seekWidgetByName(root,"Text_effect_v_add_"..i)
        local next_add = tonumber(next_attribute[i].add_number) - tonumber(v.add_number)
        Text_effect_v_add_1:setString(" +"..next_add)
        table.insert(self._text_table,attribute[attribute_type] .. "+" .. v.add_number)
        Text_effect_v_add_1:setPositionX(Text_effect_1:getPositionX()+Text_effect_1:getContentSize().width*1.5+15)
    end
end

function BarrackScienceLvUp:formatTimeStringChinese(_time)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    if math.floor(now_time/3600) ~= 0 then
        timeString = string.format(red_alert_all_str[86], math.floor(now_time/3600))
    end
    if math.floor((now_time%3600)/60) ~= 0 then
        timeString =timeString.. string.format(red_alert_all_str[87], math.floor((now_time%3600)/60))
    end
    timeString =timeString.. string.format(red_alert_all_str[88], math.floor(now_time%60))
    return timeString
end

function BarrackScienceLvUp:onEnterTransitionFinish()

end

--初始化界面
function BarrackScienceLvUp:onInit( )
    local csbItem = csb.createNode(config_csb.barrack.barrack_science_lv_up)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_barrack_lv_up"), nil, 
    {
        terminal_name = "barrack_science_lv_up_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    --升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_lv_up"), nil, 
    {
        terminal_name = "barrack_science_lv_up_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()
end

--初始化科技升级冷却最大时间
function BarrackScienceLvUp:initData()
    local level = _ED.home_build["2"].level
    local update_group_id = dms.int(dms["build_mould"],2,build_mould.update_id)     --升级库组id
    local barrack_build_info = _ED.build_escalate_info[""..update_group_id][""..level]
    self.max_time = tonumber(barrack_build_info.max_volumn)
end

function BarrackScienceLvUp:init(barrack_id,index)
    self.barrack_id = barrack_id 
    self.index = index
    self.barrack_data = _ED.barracks_info[""..self.barrack_id]
    self:initData()
	self:onInit()
    return self
end

--移除状态机
function BarrackScience:onExit()
    state_machine.remove("barrack_science_lv_up_sure",0,"")
end
