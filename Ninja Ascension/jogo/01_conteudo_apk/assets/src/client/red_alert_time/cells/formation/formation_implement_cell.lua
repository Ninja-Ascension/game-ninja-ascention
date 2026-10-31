----------------------------------------------------------------------------------------------------
-- 说明：行军队列列表cell
-------------------------------------------------------------------------------------------------------
FormationImplementCell = class("FormationImplementCellClass", Window)
FormationImplementCell.__size = nil

local formation_implement_cell_create_terminal = {
    _name = "formation_implement_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FormationImplementCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_implement_cell_create_terminal)
state_machine.init()

function FormationImplementCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil
    self._state = 0             -- 0：已开启，>0：未开启
    self.m_object = nil

    self._loading_bar = nil
    self._text_time = nil

    self.local_time = 0
    self.m_second = 0
    self.old_local_time = 0
    self.old_event_type = 0
    self.second_increase_time = 1
    self.second_total = 0
    self.m_mineral = nil

    local function init_formation_implement_cell_terminal()
        local formation_implement_cell_update_info_terminal = {
            _name = "formation_implement_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                local last_info = cell._info
                cell._info = params._info
                cell.m_object = cell._info
                if cell._info ~= nil then
                    -- if cell._index <= 6 then
                        -- cell:reload()
                        cell:onUpdateDraw()
                    -- else
                        -- cell:unload()
                    -- end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --时间结束校验时间
        local formation_implement_cell_time_over_terminal = {
            _name = "formation_implement_cell_time_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --加速或者撤销
        local formation_implement_cell_accelerate_or_revoked_terminal = {
            _name = "formation_implement_cell_accelerate_or_revoked",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if cell ~= nil and cell._info ~= nil then
                    if cell._last_event_type ~= tonumber(cell._info._event_type) then
                        -- 行军状态改变
                        return
                    end
                    if tonumber(cell._info._event_type) == 19 then
                        local city_type = dms.int(dms["world_city_mould"], cell._info._world_mine_mould_id, world_city_mould.city_type)
                        if city_type == 3002 then
                            TipDlg.drawTextDailog(world_city_tip_str[69])
                            return
                        end
                    end
                    cell.isAccelerate = true
                    local fighting_type = "0"
                    if tonumber(cell._info._event_type) == 0 
                        or tonumber(cell._info._event_type) == 6 
                        or tonumber(cell._info._event_type) == 19
                        then
                        fighting_type = "2"
                    elseif tonumber(cell._info._event_type) == 1 
                        or tonumber(cell._info._event_type) == 18 
                        or tonumber(cell._info._event_type) == 23 
                        then 
                        fighting_type = "3"
                    elseif tonumber(cell._info._event_type) == 5 then    
                        fighting_type = "4"
                    elseif tonumber(cell._info._event_type) == 7 then
                        fighting_type = "16"
                    elseif tonumber(cell._info._event_type) == 20 then
                        fighting_type = "21"
                    end
                    local _x = cell._info._dx
                    local _y = cell._info._dy
                    local function requestAttackCheck(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                if response.node._info ~= nil 
                                    and fighting_type == "2" 
                                    and response.node.old_event_type == 0
                                    then
                                    local info = _ED.world_map.world_map_info_list[_x .. "," .. _y]
                                    if info ~= nil and ((info._type >= 0 and info._type <= 5) or info._type == 1000) then
                                        state_machine.excute("adventure_mine_get_cells_obj", 0, {_x, _y})
                                    end
                                    response.node.old_event_type = response.node._info._event_type
                                end
                            end 
                        end
                    end
                    local m_times = 0
                    if zstring.tonumber(cell._info._target_type) == 1000 then
                        m_times = getWorldTwopointMovementTime(cell._info._sx,cell._info._sy,cell._info._dx,cell._info._dy, 1000)
                    else
                        if zstring.tonumber(cell._info._event_type) == 6 then
                            m_times = getWorldTwopointMovementTime(cell._info._sx,cell._info._sy,cell._info._dx,cell._info._dy, nil, true)
                        else
                            m_times = getWorldTwopointMovementTime(cell._info._sx,cell._info._sy,cell._info._dx,cell._info._dy)
                        end
                    end
                    protocol_command.world_add_target_event.param_list = fighting_type .. "\r\n" ..cell._info._dx.."\r\n" ..cell._info._dy.."\r\n"..m_times.."\r\n"..cell._info._time.."\r\n-"
                    NetworkManager:register(protocol_command.world_add_target_event.code, nil, nil, nil, cell, requestAttackCheck, false, nil)
                    state_machine.excute("adventure_mine_attack_update", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --操作提示
        local formation_implement_cell_request_accelerate_terminal = {
            _name = "formation_implement_cell_request_accelerate",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if cell ~= nil and cell._info ~= nil then
                    cell._last_event_type = tonumber(cell._info._event_type)
                    --0攻击移动，1回城移动，2攻击，3加速返回，4请求撤离，5驻守状态，6协防移动，7协防中，8打玩家移动，9校验
                    if tonumber(cell._info._event_type) == 5 then
                        if tonumber(cell.second_total) ~= tonumber(cell._info._max_out_put) then
                            state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 23}})
                        else
                            state_machine.excute("formation_implement_cell_accelerate_or_revoked", 0, {_datas = {cells = cell}})
                        end
                    else
                        --火线支援活动加成
                        local isChange = false
                        if tonumber(cell._info._target_type) == 1000 and tonumber(cell._info._event_type) == 0 then
                            if _ED.activity_info["91"] ~= nil then
                                local timesData = zstring.split(_ED.activity_info["91"].activity_add_state, ",")
                                local activity_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                                if activity_times > 0 then
                                    isChange = true
                                end
                            end
                            -- 狂欢时刻活动加成
                            if _ED.activity_info["130"] ~= nil then
                                local timesData = zstring.split(_ED.activity_info["130"].activity_add_state, ",")
                                local activity_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                                if activity_times > 0 then
                                    isChange = true
                                end
                            end
                        end
                        if isChange == true then
                            cell.costGoods = 0 
                        else
                            cell.costGoods = cell.local_time
                        end
                        if tonumber(cell._info._event_type) == 0 
                            or tonumber(cell._info._event_type) == 1 
                            or tonumber(cell._info._event_type) == 6 
                            or tonumber(cell._info._event_type) == 18 
                            or tonumber(cell._info._event_type) == 19
                            or tonumber(cell._info._event_type) == 23
                            then
                            state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 24}})
                        else
                            state_machine.excute("formation_implement_cell_accelerate_or_revoked", 0, {_datas = {cells = cell}})
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_implement_cell_look_info_terminal = {
            _name = "formation_implement_cell_look_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                state_machine.excute("world_battle_troops_infor_open", 0, {cell._info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(formation_implement_cell_update_info_terminal)
        state_machine.add(formation_implement_cell_time_over_terminal)
        state_machine.add(formation_implement_cell_accelerate_or_revoked_terminal)
        state_machine.add(formation_implement_cell_request_accelerate_terminal)
        state_machine.add(formation_implement_cell_look_info_terminal)
        state_machine.init()
    end
    init_formation_implement_cell_terminal()         
end

function FormationImplementCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_attack_res_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_res_name_lv")        --攻打的名称
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    local Text_build_time_ing = ccui.Helper:seekWidgetByName(root,"Text_build_time_ing")
    Text_attack_res_name_lv:removeAllChildren(true)

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)   
    -- 攻打的名称，等级
    local re1 = nil
    local level = 0
    local font_size = Text_attack_res_name_lv:getFontSize()
    
    self.old_event_type = zstring.tonumber(self._info._event_type)
    if zstring.tonumber(self._info._target_type) > 0 and zstring.tonumber(self._info._target_type) < 1000 then
        self.m_mineral = dms.element(dms["world_mine_mould"], self._info._world_mine_mould_id)
        local second_info = zstring.split(dms.atos(self.m_mineral, world_mine_mould.per_second_output), ",")
        if tonumber(self._info._quality) == 0 then
            if self._info._bonus_value ~= 0 then
                self.m_second = tonumber(second_info[2])*(1+self._info._bonus_value/100)
            else
                self.m_second = tonumber(second_info[2])
            end
        else
            if self._info._bonus_value ~= 0 then
                self.m_second = tonumber(second_info[2]) * (1+tonumber(self._info._quality)*0.5+self._info._bonus_value/100)
            else
                self.m_second = tonumber(second_info[2]) * (1+tonumber(self._info._quality)*0.5)
            end
        end
        local mine_name = dms.atos(self.m_mineral, world_mine_mould.name)
        local color = cc.c3b(color_Type[tonumber(self._info._quality)+1][1], color_Type[tonumber(self._info._quality)+1][2], color_Type[tonumber(self._info._quality)+1][3])
        re1 = ccui.RichElementText:create(1, color,255, mine_name, config_res.font.font_name,font_size)
        level = dms.atos(self.m_mineral, world_mine_mould.level)
    elseif zstring.tonumber(self._info._target_type) == 1000 then
        local npcId = dms.int(dms["rebel_haunt_mould"], self._info._world_mine_mould_id, rebel_haunt_mould.npc_mould_id)
        local npcName = dms.string(dms["npc"], npcId, npc.npc_name)
        re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, npcName, config_res.font.font_name,font_size)
        level = _ED.world_level
    elseif zstring.tonumber(self._info._target_type) == 3000 or zstring.tonumber(self._info._target_type) == 3001 or zstring.tonumber(self._info._target_type) == 3002 then
        local npcName = dms.string(dms["world_city_mould"], self._info._world_mine_mould_id, world_city_mould.name)
        local city_level = dms.int(dms["world_city_mould"], self._info._world_mine_mould_id, world_city_mould.level)
        re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, npcName, config_res.font.font_name,font_size)
        level = city_level
    else
        re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, self._info._nickname, config_res.font.font_name,font_size)
        level = self._info._level
    end
    _richText:pushBackElement(re1)  

    -- 攻打的坐标    
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, " "..friends_tip_string[12]..level.." "..string.format(red_alert_time_str[6],self._info._dx, self._info._dy), config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)

    _richText:setPosition(cc.p(Text_attack_res_name_lv:getContentSize().width/2,Text_attack_res_name_lv:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_attack_res_name_lv:getContentSize().width,22))
    Text_attack_res_name_lv:addChild(_richText)

    --移动和采集的进度条
    self.local_time = (tonumber(self._info._start_time)/1000+tonumber(self._info._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
    if tonumber(self._info._event_type) == 5 then
        self.local_time = (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))-(tonumber(self._info._start_time)/1000)
        if self.local_time < 0 then
            self.local_time = 0
        end
    end
    local m_times = 0
    if zstring.tonumber(self._info._target_type) == 1000 then
        m_times = getWorldTwopointMovementTime(self._info._sx,self._info._sy,self._info._dx,self._info._dy, true)
    else
        if zstring.tonumber(self._info._event_type) == 6 then
            m_times = getWorldTwopointMovementTime(self._info._sx,self._info._sy,self._info._dx,self._info._dy, nil, true)
        else
            m_times = getWorldTwopointMovementTime(self._info._sx,self._info._sy,self._info._dx,self._info._dy)
        end
    end
    self.old_local_time = tonumber(self._info._complete_time)
    
    if tonumber(self._info._event_type) == 5 then
        local prev_out_put = zstring.tonumber(self._info._prev_out_put) + self.m_second*self.local_time
        prev_out_put = math.max(0,prev_out_put)
        self.second_total = prev_out_put
        Text_build_time_ing:setString(exChangeNumToString(prev_out_put).."/"..exChangeNumToString(tonumber(self._info._max_out_put)))
        local progress = math.min((zstring.tonumber(self._info._prev_out_put) + self.m_second*self.local_time)/tonumber(self._info._max_out_put)*100)
        LoadingBar_time:setPercent(progress)
    elseif(tonumber(self._info._event_type) == 0 
        or tonumber(self._info._event_type) == 1 
        or tonumber(self._info._event_type) == 6 
        or tonumber(self._info._event_type) == 8
        or tonumber(self._info._event_type) == 18
        or tonumber(self._info._event_type) == 19
        or tonumber(self._info._event_type) == 23) 
        and self.local_time ~= 0 
        then 
        Text_build_time_ing:setString(exChangeTimeToString(self.local_time))
        local progress = math.min((self.old_local_time-self.local_time)/self.old_local_time*100)
        LoadingBar_time:setPercent(progress)
    elseif tonumber(self._info._event_type) == 7 then
        Text_build_time_ing:setString(red_alert_time_str[270])
        LoadingBar_time:setPercent(0)
    elseif tonumber(self._info._event_type) == 20 then
        Text_build_time_ing:setString(red_alert_time_str[272])
        LoadingBar_time:setVisible(false)
    end
    
    --加速和撤销的按钮
    local Button_quicken = ccui.Helper:seekWidgetByName(root,"Button_quicken")
    --队列图标（移动，占领，返回）
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    Panel_implement_icon:removeBackGroundImage()
    local b_image_name = nil
    local image_name = nil
    
    if tonumber(self._info._event_type) == 0 or tonumber(self._info._event_type) == 8 or tonumber(self._info._event_type) == 6 or tonumber(self._info._event_type) == 19 then--移动（去）
        image_name = "images/ui/share/world_implement_icon_1.png"
        b_image_name = "images/ui/share/button_quicken_1.png"
    elseif tonumber(self._info._event_type) == 1 or tonumber(self._info._event_type) == 18 or tonumber(self._info._event_type) == 23 then--移动（回）
        image_name = "images/ui/share/world_implement_icon_3.png"
        b_image_name = "images/ui/share/button_quicken_1.png"
    elseif tonumber(self._info._event_type) == 7 then
        image_name = "images/ui/share/world_implement_icon_7.png"
        b_image_name = "images/ui/share/button_back_1.png"  
    else
        image_name = "images/ui/share/world_implement_icon_2.png"
        b_image_name = "images/ui/share/button_back_1.png"
    end
    Panel_implement_icon:setBackGroundImage(image_name)
    Button_quicken:loadTextureNormal(b_image_name, 1)
    Button_quicken:loadTexturePressed(b_image_name, 1)
    Button_quicken:loadTextureDisabled(b_image_name, 1)

    self._text_time = Text_build_time_ing
    self._loading_bar = LoadingBar_time

    self:onUpdate(0)
end

function FormationImplementCell:onUpdate(dt)
    if self.roots == nil or self.roots[1] == nil then
        return
    end

    if self._info == nil then
        return
    end

    --0攻击移动，1回城移动，2攻击，3加速返回，4请求撤离，5驻守状态，6协防移动，7协防中，8打玩家移动，9校验
    if (tonumber(self._info._event_type) == 0 
        or tonumber(self._info._event_type) == 1 
        or tonumber(self._info._event_type) == 6 
        or tonumber(self._info._event_type) == 8 
        or tonumber(self._info._event_type) == 18
        or tonumber(self._info._event_type) == 19
        or tonumber(self._info._event_type) == 23) 
        and self.local_time ~= 0 
        then
        self.local_time = (tonumber(self._info._start_time)/1000+tonumber(self._info._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
        if self.local_time <= -1 then--客户端多延时一秒
            self.local_time = 0
            state_machine.excute("formation_implement_cell_time_over", 0, {_datas={cells = self}})
        end
        self._text_time:setString(exChangeTimeToString(self.local_time))
        local progress = math.min((self.old_local_time-self.local_time)/self.old_local_time*100)
        self._loading_bar:setPercent(progress)
    elseif tonumber(self._info._event_type) == 5 then
        self.second_increase_time = self.second_increase_time + dt
        if self.second_increase_time >= 1 and self.second_total < tonumber(self._info._max_out_put) then
            self.second_increase_time = 0
            self.local_time = (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))-(tonumber(self._info._start_time)/1000)
            self.second_total = zstring.tonumber(self._info._prev_out_put) + self.m_second*self.local_time
        elseif self.second_total >= tonumber(self._info._max_out_put) then
            self.second_total = tonumber(self._info._max_out_put)
        end
        self.second_total = math.max(0,self.second_total)
        self._text_time:setString(exChangeNumToString(math.floor(self.second_total)).."/"..exChangeNumToString(tonumber(self._info._max_out_put)))
        local progress = math.min(self.second_total/tonumber(self._info._max_out_put)*100)
        self._loading_bar:setPercent(progress)
    elseif tonumber(self._info._event_type) == 7 then    --协防中
        self._loading_bar:setPercent(0)
        self._text_time:setString(red_alert_time_str[270])
    end
end

function FormationImplementCell:onEnterTransitionFinish()

end

function FormationImplementCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_implement_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if FormationImplementCell.__size == nil then
        FormationImplementCell.__size = root:getContentSize()
    end

    --充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_implement_vip_recharge") , nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)  
    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel") , nil, 
    {
        terminal_name = "formation_implement_cell_look_info", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true, 
        cells = self,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quicken") , nil, 
    {
        terminal_name = "formation_implement_cell_request_accelerate", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true, 
        cells = self,
    }, nil, 1)  

    self:onUpdateDraw()
end

function FormationImplementCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_implement_cell, self.roots[1])
end

function FormationImplementCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function FormationImplementCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_implement_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationImplementCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    local Text_attack_res_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_res_name_lv")
    local Text_build_time_ing = ccui.Helper:seekWidgetByName(root,"Text_build_time_ing")
    if Panel_implement_icon ~= nil then
        Panel_implement_icon:removeBackGroundImage()
        Text_attack_res_name_lv:removeAllChildren(true)
        Text_attack_res_name_lv:setString("")
        Text_build_time_ing:setString("")
    end

    self:unregisterOnNoteUpdate(self)
end

function FormationImplementCell:init(params)
    self._index = params[1]
    self._info = params[2]

    self.m_object = self._info
    self:onInit()
    self:setContentSize(FormationImplementCell.__size)
end

