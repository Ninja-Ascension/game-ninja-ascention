-----------------------------
--副本扫荡
-----------------------------
DuplicateRaids = class("DuplicateRaidsClass", Window)

--打开界面
local duplicate_raids_window_open_terminal = {
    _name = "duplicate_raids_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(38) == true then
            return
        end
        local _Window = fwin:find("DuplicateRaidsClass")
        if nil == _Window then
            local npc_id = params._datas.npc_id
            local scene_type = params._datas.scene_type
            fwin:open(DuplicateRaids:new():init(npc_id,scene_type), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local duplicate_raids_window_close_terminal = {
    _name = "duplicate_raids_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("DuplicateRaidsClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_raids_window_open_terminal)
state_machine.add(duplicate_raids_window_close_terminal)
state_machine.init()

function DuplicateRaids:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file

    --var
    --扫荡列表
    self.list_view = nil
    --扫荡列表Y轴坐标
    self.list_view_posY = nil
    --扫荡的npc id
    self.npc_id = nil
    --需要的体力
    self.need_food = nil
    --玩家等级
    self.last_level = nil
    --扫荡场景类型
    self.scene_type = nil
    -- Initialize DuplicateRaids state machine.
    local function init_duplicate_raids_terminal()
        --扫荡一次
        local duplicate_raids_one_terminal = {
            _name = "duplicate_raids_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(instance.need_food) then
                    state_machine.excute("buy_resource_window_open",0,{_datas = 
                    {
                        resource_type = 1
                    }})
                    return
                end 
                if funOpenDrawTip(38) == true then
                    return
                end
                local max_times = dms.int(dms["npc"],instance.npc_id,npc.daily_attack_count)
                -- 处理开战时候 次数不足
                if instance.scene_type == 15 then
                    if tonumber(_ED.npc_hard_all_attack_times) >= dms.int(dms["copy_config"],1,copy_config.param) then
                        TipDlg.drawTextDailog(red_alert_all_str[162])
                        return
                    end
                    --攻击次数
                    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(instance.npc_id)])

                    local times = max_times - attack_times
                    if times <= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                elseif instance.scene_type == 1 then
                    --攻击次数
                    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(instance.npc_id)])
                    --购买次数
                    local now_times = zstring.tonumber(_ED.npc_current_buy_count[tonumber(instance.npc_id)])
                    
                    local times = max_times - attack_times + now_times
                    if times <= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                end

                local function responsePlotCopySweepCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.onUpdateDrawListTen ~= nil then
                            if zstring.tonumber(response.node.last_level) ~= zstring.tonumber(_ED.user_info.user_grade) then
                                local food = response.node.last_food - zstring.tonumber(response.node.need_food)
                                state_machine.excute("player_upgrade_window_open",0,{response.node.last_level,food})
                                response.node.last_level = _ED.user_info.user_grade
                                response.node.last_food = _ED.user_info.user_food
                                response.node:checkMission()
                            end   
                            state_machine.excute("duplicate_title_update_hard_times",0,"")    
                            state_machine.excute("duplicate_window_update_attack_times",0,"")
                            state_machine.excute("hero_star_activation_updatedraw",0,"")
                            state_machine.excute("hero_main_star_up_change_ship",0,"")    
                            if response.node ~= nil and response.node.roots ~= nil then                 
                                response.node:onUpdateDrawListOne()
                            end
                        end
                    end
                end
                _ED.last_level = _ED.user_info.user_grade
                _ED.last_user_food = _ED.user_info.user_food
                _ED.show_reward_list_group = {}
                protocol_command.sweep.param_list = "" .. instance.npc_id .."\r\n".. 1 .."\r\n".. 1 .."\r\n".. instance.scene_type
                NetworkManager:register(protocol_command.sweep.code, nil, nil, nil, instance, responsePlotCopySweepCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --扫荡十次
        local duplicate_raids_ten_terminal = {
            _name = "duplicate_raids_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                if funOpenDrawTip(38) == true then
                    return
                end                           
                local max_times = dms.int(dms["npc"],instance.npc_id,npc.daily_attack_count)
                -- 处理开战时候 次数不足
                local times = 10
                if instance.scene_type == 15 then
                    if tonumber(_ED.npc_hard_all_attack_times) >= dms.int(dms["copy_config"],1,copy_config.param) then
                        TipDlg.drawTextDailog(red_alert_all_str[162])
                        return
                    end
                    --攻击次数
                    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(instance.npc_id)])
                    --购买次数
                    local now_times = zstring.tonumber(_ED.npc_current_buy_count[tonumber(instance.npc_id)])
                    
                    times = max_times - attack_times + now_times
                    times = math.min(10,times)
                    if times <= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                elseif instance.scene_type == 1 then
                    --攻击次数
                    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(instance.npc_id)])
                    --购买次数
                    local now_times = zstring.tonumber(_ED.npc_current_buy_count[tonumber(instance.npc_id)])
                    
                    times = max_times - attack_times + now_times
                    times = math.min(10,times)
                    if times <= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                elseif instance.scene_type == 0 then
                    times = math.min(10,times)
                end

                if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(instance.need_food)*times then
                    state_machine.excute("buy_resource_window_open",0,{_datas = 
                    {
                        resource_type = 1
                    }})
                    return
                end  

                local function responsePlotCopySweepCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.onUpdateDrawListTen ~= nil then
                            if zstring.tonumber(response.node.last_level) ~= zstring.tonumber(_ED.user_info.user_grade) then
                                local food = response.node.last_food - zstring.tonumber(response.node.need_food) * times
                                state_machine.excute("player_upgrade_window_open",0,{response.node.last_level,food})
                                response.node.last_level = _ED.user_info.user_grade
                                response.node.last_food = _ED.user_info.user_food
                                response.node:checkMission()
                            end
                            state_machine.excute("duplicate_title_update_hard_times",0,"")
                            state_machine.excute("duplicate_window_update_attack_times",0,"")
                            state_machine.excute("hero_star_activation_updatedraw",0,"")
                            state_machine.excute("hero_main_star_up_change_ship",0,"")
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:onUpdateDrawListTen()
                            end
                        end
                    end
                end
                _ED.last_level = _ED.user_info.user_grade
                _ED.last_user_food = _ED.user_info.user_food
                _ED.show_reward_list_group = {}
                protocol_command.sweep.param_list = "" .. instance.npc_id .."\r\n".. 1 .."\r\n".. times .."\r\n".. instance.scene_type
                NetworkManager:register(protocol_command.sweep.code, nil, nil, nil, instance, responsePlotCopySweepCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
		state_machine.add(duplicate_raids_one_terminal)	
		state_machine.add(duplicate_raids_ten_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_duplicate_raids_terminal()
end

--扫荡一次
function DuplicateRaids:onUpdateDrawListOne( ... )
    local root = self.roots[1]
    local ListView_duplicate_raids = ccui.Helper:seekWidgetByName(root,"ListView_duplicate_raids")
    ListView_duplicate_raids:removeAllItems()
    for i,v in pairs(_ED.show_reward_list_group) do
       local cell = state_machine.excute("duplicate_raids_create_cell",0,{v,i})
       ListView_duplicate_raids:addChild(cell)
    end
    -- local cell = state_machine.excute("duplicate_raids_create_cell",0,{nil,2})
    -- ListView_duplicate_raids:addChild(cell)  
    -- for i,v in pairs(_ED.show_reward_list_group) do
    --    local cell = state_machine.excute("duplicate_raids_create_cell",0,{v,3,1})
    --    ListView_duplicate_raids:addChild(cell)
    -- end
    ListView_duplicate_raids:requestRefreshView()  
    self.list_view = ListView_duplicate_raids
    self.list_view_posY = ListView_duplicate_raids:getInnerContainer():getPositionY()
    self:onUpdateDraw()
end

--扫荡十次
function DuplicateRaids:onUpdateDrawListTen( ... )
    local root = self.roots[1]
    local ListView_duplicate_raids = ccui.Helper:seekWidgetByName(root,"ListView_duplicate_raids")
    ListView_duplicate_raids:removeAllItems()
    local golds = 0
    local result = {}
    for i1,v1 in pairs(_ED.show_reward_list_group) do
        for i,v in ipairs(v1.show_reward_list) do
            if result[""..v.prop_type] == nil then
                result[""..v.prop_type] = {}--{item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
            end
            if result[""..v.prop_type][""..v.prop_item] == nil then 
                result[""..v.prop_type][""..v.prop_item] = {item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
            end
            result[""..v.prop_type][""..v.prop_item].item_value = tonumber(v.item_value) + tonumber(result[""..v.prop_type][""..v.prop_item].item_value)
        end
        local cell = state_machine.excute("duplicate_raids_create_cell",0,{v1,i1})
        ListView_duplicate_raids:addChild(cell)
    end

    local info = {show_reward_list = {}, show_reward_type = 2, show_reward_item_count = 0}
    for k,v in pairs(result) do
        for k1,v1 in pairs(v) do
            info.show_reward_item_count = info.show_reward_item_count + 1
            table.insert(info.show_reward_list, v1)
        end
    end
    local cell = state_machine.excute("duplicate_raids_create_cell",0,{nil,11})
    ListView_duplicate_raids:addChild(cell)  
    local cell = state_machine.excute("duplicate_raids_create_cell",0,{info,12})
    ListView_duplicate_raids:addChild(cell)
    ListView_duplicate_raids:requestRefreshView()
    self.list_view = ListView_duplicate_raids
    local height = cell:getContentSize().height

    self.list_view:getInnerContainer():setPositionY(-height*11)


    self.list_view = ListView_duplicate_raids
    self.list_view_posY = ListView_duplicate_raids:getInnerContainer():getPositionY()
    local ac = cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function(sender)
        self.action_play = true
    end)})
    self:stopAllActions()
    self:runAction(ac)
    self:onUpdateDraw()
end

--刷新精英炼狱能扫荡次数
function DuplicateRaids:onUpdateDraw()
    local root = self.roots[1]
    local Text_duplicate_raids_5 = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_5")
    --攻击次数
    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(self.npc_id)])
    --购买次数
    local now_times = zstring.tonumber(_ED.npc_current_buy_count[tonumber(self.npc_id)])
    local max_times = dms.int(dms["npc"],self.npc_id,npc.daily_attack_count)
    local times = max_times - attack_times + now_times
    times = math.min(10,times)
    if self.scene_type == 15 or self.scene_type == 1 then
        Text_duplicate_raids_5:setString(string.format(red_alert_all_str[149],times))
    end
end

--刷新扫荡列表Y轴(一次)
function DuplicateRaids:onUpdateListView(dt)
    if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + 138 * 2 < 0 or tempY > 138 + 138 * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--设置扫荡列表Y轴(十次)
function DuplicateRaids:onUpdate(dt)
    self:onUpdateListView(dt)
    if self.list_view ~= nil then
        if self.action_play == true then
            local y = self.list_view:getInnerContainer():getPositionY()
            if y + 25  > 0 then
                self.action_play = false
            else
                self.list_view:getInnerContainer():setPositionY(y+25)
            end
        end
    end
end

function DuplicateRaids:onEnterTransitionFinish()

end

--初始化界面
function DuplicateRaids:onInit( )
    local csbItem = csb.createNode(config_csb.duplicate.duplicate_raids)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    local npc_name = dms.string(dms["npc"],self.npc_id,npc.npc_name)
    local Text_duplicate_raids_objects = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_objects")  --npc名字
    Text_duplicate_raids_objects:setString(npc_name)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_duplicate_raids_close"), nil, 
    {
        terminal_name = "duplicate_raids_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 扫荡一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_duplicate_raids_one"), nil, 
    {
        terminal_name = "duplicate_raids_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    -- 扫荡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_duplicate_raids_ten"), nil, 
    {
        terminal_name = "duplicate_raids_ten", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
    local attack_need_food = dms.int(dms["npc"],self.npc_id,npc.attack_need_food)
    self.need_food = attack_need_food    
	self:onUpdateDraw()
    self.last_level = _ED.user_info.user_grade
    self.last_food = _ED.user_info.user_food
end

--初始化
function DuplicateRaids:init(npc_id,scene_type)
    self.npc_id = npc_id
    self.scene_type = scene_type
	self:onInit()
    return self
end

--移除状态机
function DuplicateRaids:onExit()
    state_machine.remove("duplicate_raids_one") 
    state_machine.remove("duplicate_raids_ten")
end

function DuplicateRaids:checkMission( ... )
    if zstring.tonumber("".._ED._user_last_grade) < zstring.tonumber("".._ED.user_info.user_grade) then
        _ED._user_last_grade = _ED.user_info.user_grade
        executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, true, nil, false)
        if missionIsOver() == false then
            state_machine.excute("duplicate_raids_window_close", 0, nil)
            state_machine.excute("duplicate_npc_window_close", 0, nil)
            local windowLock = fwin:find("WindowLockClass")
            if windowLock == nil then
                fwin:open(WindowLock:new():init(), fwin._windows)
            end
        end
    end
end
