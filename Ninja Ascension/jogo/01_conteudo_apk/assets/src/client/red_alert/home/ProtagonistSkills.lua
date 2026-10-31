-----------------------------
--主公技
-----------------------------
ProtagonistSkills= class("ProtagonistSkillsClass", Window)

local protagonist_skills_window_open_terminal = {
    _name = "protagonist_skills_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(105) == true then
            return
        end 
        local _Window = fwin:find("ProtagonistSkillsClass")
        if nil == _Window then
            fwin:open(ProtagonistSkills:new():init(), fwin._ui)
        end
        state_machine.excute("home_select_action_window_close",0,"")        
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        state_machine.excute("duplicate_title_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local protagonist_skills_window_close_terminal = {
    _name = "protagonist_skills_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ProtagonistSkillsClass"))

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("player_resource_window_show",0,"")   
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("chat_view_window_show",0,"")
        state_machine.excute("duplicate_title_window_show",0,"")
        
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(protagonist_skills_window_open_terminal)
state_machine.add(protagonist_skills_window_close_terminal)
state_machine.init()

function ProtagonistSkills:ctor()
    self.super:ctor()
    self.roots = {}
    self.pageIndex = 1
    self.skill_cells = {}
    self.old_majesty_skill = {}
    -- Initialize protagonist_skills state machine.
    app.load("client.red_alert.cells.home.protagonist_skills_cell")
    app.load("client.red_alert.home.ProtagonistSkillsInfor")
    
    local function init_protagonist_skills_terminal()
	    --添加技能
		local protagonist_skills_add_skill_terminal = {
            _name = "protagonist_skills_add_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local add_index = params._datas.add_index
                local open_level = dms.int(dms["majesty_skill"],add_index,majesty_skill.open_level)
                local home_city_level = tonumber(_ED.home_build["1"].level)
                if home_city_level < open_level then
                    return
                end
                state_machine.lock("protagonist_skills_add_skill")
                state_machine.lock("protagonist_skills_remove_skill")
                instance:WearMejestySkill(tonumber(add_index))

                local skill_name = dms.string(dms["majesty_skill"],add_index,majesty_skill.skill_name)
                -- print("=========add===",add_index,skill_name)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 移除技能
        local protagonist_skills_remove_skill_terminal = {
            _name = "protagonist_skills_remove_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local remove_index = params._datas.remove_index
                if zstring.tonumber(_ED.majesty_info[remove_index]) == 0 then
                    return
                end
                state_machine.lock("protagonist_skills_add_skill")
                state_machine.lock("protagonist_skills_remove_skill")
                local skill_name = dms.string(dms["majesty_skill"],remove_index,majesty_skill.skill_name)
                -- print("=========remove===",_ED.majesty_info[remove_index],skill_name)
                instance:unloadMejestySkill(tonumber(_ED.majesty_info[remove_index]))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        -- 翻页
        local protagonist_skills_turn_page_terminal = {
            _name = "protagonist_skills_turn_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local to_turn_page = params._datas.to_turn_page
                instance:scrollToPageIndex(to_turn_page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  	

        -- 刷新
        local protagonist_skills_update_draw_terminal = {
            _name = "protagonist_skills_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawCell()
                instance:onUpdateDrawWearCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 刷新
        local protagonist_skills_move_icon_terminal = {
            _name = "protagonist_skills_move_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local wear_type = params[1]
                local majesty_skill_id = params[2]
                instance:skillIconMove(wear_type,majesty_skill_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        	
        state_machine.add(protagonist_skills_add_skill_terminal)	
        state_machine.add(protagonist_skills_remove_skill_terminal)
        state_machine.add(protagonist_skills_turn_page_terminal)
        state_machine.add(protagonist_skills_update_draw_terminal)
        state_machine.add(protagonist_skills_move_icon_terminal)
        state_machine.init()
    end
    
    -- call func init protagonist_skills state machine.
    init_protagonist_skills_terminal()
end

function ProtagonistSkills:onUpdateDrawCell()
    for i,cell in pairs(self.skill_cells) do
        if cell ~= nil and cell.updateDraw ~= nil then
            cell:updateDraw()
        end
    end
    
end


function ProtagonistSkills:onUpdateDrawWearCell()
    local root = self.roots[1]

    local Panel_skill_icon = ccui.Helper:seekWidgetByName(root,"Panel_skill_icon")
    local major_city_config_str = dms.string(dms["major_city_config"],1,major_city_config.param)
    major_city_config_str = zstring.split(major_city_config_str,",")
    for i,v in pairs(_ED.majesty_info) do
        local Panel_skill_icon_child = Panel_skill_icon:getChildByName("Panel_skills_icon_"..i)
        if tonumber(v) == 0 then
            Panel_skill_icon_child:removeBackGroundImage()
        else
            local pic = dms.int(dms["majesty_skill"],tonumber(v),majesty_skill.skill_pic)
            Panel_skill_icon_child:setBackGroundImage("images/ui/role_skills/protagonist_skills/protagonist_skills_".. pic .. ".png")
        end
    end    
end

function ProtagonistSkills:WearMejestySkill(majesty_skill_id)

    local major_city_config_str = dms.string(dms["major_city_config"],1,major_city_config.param)
    major_city_config_str = zstring.split(major_city_config_str,",")

    local home_city_level = tonumber(_ED.home_build["1"].level)
    local open_skills = 0
    for i,v in pairs(major_city_config_str) do
        if home_city_level >= tonumber(v) then
            open_skills = open_skills + 1
        end
    end

    local wear_type = 0 -- 0穿戴。1卸下
    local can_wear = false
    for i,v in pairs(_ED.majesty_info) do
        if tonumber(v) == majesty_skill_id then
            wear_type = 1 
            break
        end
        if i > open_skills then
            break
        end
        if tonumber(v) <= 0 then
            can_wear = true
        end
    end
    
    if can_wear == false and wear_type == 0 then
        TipDlg.drawTextDailog(red_alert_all_str[92])
        state_machine.unlock("protagonist_skills_add_skill")
        state_machine.unlock("protagonist_skills_remove_skill")
        return
    end

    local skill_type = dms.int(dms["majesty_skill"],majesty_skill_id,majesty_skill.skill_type)

    for i,v in pairs(_ED.majesty_info) do
        if tonumber(v) == majesty_skill_id then
            wear_type = 1 
            break
        end        
        if tonumber(v) ~= 0 then
            local temp_skill_type = dms.int(dms["majesty_skill"],tonumber(v),majesty_skill.skill_type)
            if skill_type == temp_skill_type then
                state_machine.unlock("protagonist_skills_add_skill")
                state_machine.unlock("protagonist_skills_remove_skill")
                return TipDlg.drawTextDailog(red_alert_all_str[93])
            end
        end
    end

    if wear_type == 0 then
        local majesty_info_temp = _ED.majesty_info
        for i,v in pairs(majesty_info_temp) do
            if tonumber(v) <= 0 then
                majesty_info_temp[i] = majesty_skill_id
                break
            end
        end

        local request_str = ""
        for i,v in pairs(majesty_info_temp) do
            if request_str == "" then
                request_str = v
            else
                request_str = request_str .. "," ..  v
            end
        end

        -- print("=========wear====",request_str)
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                state_machine.excute("protagonist_skills_move_icon",0,{wear_type,majesty_skill_id})
                
            end
        end
        protocol_command.wear_majesty_change.param_list = request_str
        NetworkManager:register(protocol_command.wear_majesty_change.code, nil, nil, nil, nil, responseCallback, false, nil)
    elseif wear_type == 1 then
        self:unloadMejestySkill(majesty_skill_id)
    end

end

function ProtagonistSkills:unloadMejestySkill(unload_mejesty_skill_id)
    local majesty_info_temp = _ED.majesty_info
    for i,v in pairs(majesty_info_temp) do
        self.old_majesty_skill[i] = v
        if tonumber(v) == unload_mejesty_skill_id then
            majesty_info_temp[i] = 0
        end
    end

    local request_str = ""
    for i,v in pairs(majesty_info_temp) do
        if request_str == "" then
            request_str = v
        else
            request_str = request_str .. "," ..  v
        end
    end
    -- print("=========unload====",request_str)

    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("protagonist_skills_move_icon",0,{1,unload_mejesty_skill_id})
        end
    end
    protocol_command.wear_majesty_change.param_list = request_str
    NetworkManager:register(protocol_command.wear_majesty_change.code, nil, nil, nil, nil, responseCallback, false, nil)
end

function ProtagonistSkills:skillIconMove( wear_type , majesty_skill_id )
    local root = self.roots[1]
    local pic = dms.int(dms["majesty_skill"],majesty_skill_id,majesty_skill.skill_pic)
    if wear_type == 0 then
        local Panel_protagonist_skills_cell = ccui.Helper:seekWidgetByName(root,"Panel_protagonist_skills_cell_".. majesty_skill_id)
        local sprite = cc.Sprite:create("images/ui/role_skills/protagonist_skills/protagonist_skills_".. pic .. ".png")
        local PanelParent = Panel_protagonist_skills_cell:getParent()

        local new_pos = draw.convertChangeToParentPos(root,Panel_protagonist_skills_cell)
        sprite:setAnchorPoint(cc.p(0.5, 0.5))   
        sprite:setPosition(cc.p(new_pos))
        sprite:setGlobalZOrder(1)
        root:addChild(sprite)
        local Panel_xy = nil
        for i,v in pairs(_ED.majesty_info) do
            if tonumber(majesty_skill_id) == tonumber(v) then
                Panel_xy = PanelParent:getChildByName("Panel_xy_"..i)
            end
        end

        local move_x = 0
        local move_y = 0
        if Panel_xy ~= nil then
            local move_pos = draw.convertChangeToParentPos(root,Panel_xy)
            move_x = move_pos.x
            move_y = move_pos.y
        end

        function MoveCallBack()
            sprite:removeFromParent()
            state_machine.excute("protagonist_skills_update_draw",0,"")
            state_machine.unlock("protagonist_skills_add_skill")
            state_machine.unlock("protagonist_skills_remove_skill")            
        end

        local action_move = cc.Sequence:create(cc.MoveTo:create(0.8,cc.p(move_x,move_y)),cc.CallFunc:create(MoveCallBack))
        sprite:runAction(action_move)
    elseif wear_type == 1 then
        local startPanel = nil
        for i,v in pairs(self.old_majesty_skill) do
            if tonumber(majesty_skill_id) == tonumber(v) then
                startPanel = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon_"..i)
            end
        end

        local Panel_x_y = ccui.Helper:seekWidgetByName(root,"Panel_x_y")
        local sprite = cc.Sprite:create("images/ui/role_skills/protagonist_skills/protagonist_skills_".. pic .. ".png")
        local new_pos = draw.convertChangeToParentPos(root,startPanel)
        sprite:setAnchorPoint(cc.p(0.5, 0.5)) 
        sprite:setPosition(cc.p(new_pos))
        sprite:setGlobalZOrder(1)        
        root:addChild(sprite)
        local move_pos = draw.convertChangeToParentPos(root,Panel_x_y)
        local move_x = move_pos.x
        local move_y = move_pos.y

        function MoveCallBack()
            sprite:removeFromParent()
            state_machine.excute("protagonist_skills_update_draw",0,"")
            state_machine.unlock("protagonist_skills_add_skill")
            state_machine.unlock("protagonist_skills_remove_skill")            
        end

        local action_move = cc.Sequence:create(cc.MoveTo:create(0.3,cc.p(move_x,move_y)),cc.CallFunc:create(MoveCallBack))
        sprite:runAction(action_move)        
    end
end

function ProtagonistSkills:scrollToPageIndex(pageIndex)
    local root = self.roots[1]
    local PageView_protagonist_skills = ccui.Helper:seekWidgetByName(root,"PageView_protagonist_skills")
    PageView_protagonist_skills:scrollToPage(pageIndex)
end

function ProtagonistSkills:turnButtonCheckShow()
    local root = self.roots[1]
    local Button_protagonist_skills_left = ccui.Helper:seekWidgetByName(root,"Button_protagonist_skills_left")
    local Button_protagonist_skills_right = ccui.Helper:seekWidgetByName(root,"Button_protagonist_skills_right")

    if self.pageIndex == 1 then
        Button_protagonist_skills_left:setVisible(false)
        Button_protagonist_skills_right:setVisible(true)            
    elseif self.pageIndex == 2 then
        Button_protagonist_skills_left:setVisible(true)
        Button_protagonist_skills_right:setVisible(false)
    end

end

function ProtagonistSkills:initPageViewScrollTouchListen()
    local root = self.roots[1]
    local PageView_protagonist_skills = ccui.Helper:seekWidgetByName(root, "PageView_protagonist_skills")
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local nowPageIndex = sender:getCurPageIndex()
            if nowPageIndex == 0 then
                self.pageIndex = 1 
            elseif nowPageIndex == 1 then
                self.pageIndex = 2 
            end
            self:turnButtonCheckShow()
        end
    end 
    PageView_protagonist_skills:addEventListener(pageViewEvent)
end

function ProtagonistSkills:onUpdateDraw()
    local root = self.roots[1]
    local home_city_level = tonumber(_ED.home_build["1"].level)
    local Text_protagonist_skills_13 = ccui.Helper:seekWidgetByName(root,"Text_protagonist_skills_13") -- 主公殿等级
    local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")--主角
    Panel_role:removeAllChildren(true)
    if tonumber(_ED.user_info.user_gender) == 1 then
        jsonPath = "sprite/spirte_nanzhu.json"
        atlasPath = "sprite/spirte_nanzhu.atlas"
    elseif tonumber(_ED.user_info.user_gender) == 2 then    
        jsonPath = "sprite/spirte_nvzhu.json"
        atlasPath = "sprite/spirte_nvzhu.atlas"
    end
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
    animation:setPosition(cc.p(Panel_role:getContentSize().width/2,Panel_role:getContentSize().height/2))
    Panel_role:addChild(animation)
    Text_protagonist_skills_13:setString(home_city_level - 1)

    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")

    for i=1,dms.count(dms["majesty_skill"]) do
        local skill_type = dms.int(dms["majesty_skill"],i,majesty_skill.skill_type)
        if skill_type ~= 0 then
            local cell = state_machine.excute("protagonist_skills_create_cell",0,{i})
            local Panel_protagonist_skills_cell = ccui.Helper:seekWidgetByName(root,"Panel_protagonist_skills_cell_"..i)
            Panel_protagonist_skills_cell:removeAllChildren(true)
            table.insert(self.skill_cells,cell)
            Panel_protagonist_skills_cell:addChild(cell)
        end
    end
   

    local major_city_config_str = dms.string(dms["major_city_config"],1,major_city_config.param)
    major_city_config_str = zstring.split(major_city_config_str,",")

    local Panel_skill_icon = ccui.Helper:seekWidgetByName(root,"Panel_skill_icon")
    
    for i,v in pairs(major_city_config_str) do
        local Image_skills_icon_lock = Panel_skill_icon:getChildByName("Image_skills_icon_lock_"..i)
        local Text_skills_icon_lock_lv = Image_skills_icon_lock:getChildByName("Text_skills_icon_lock_lv_"..i)
        if home_city_level >= tonumber(v) then --开启了   
            Image_skills_icon_lock:setVisible(false)
            if zstring.tonumber(_ED.majesty_info[i]) > 0 then
                local Panel_skill_icon_child = Panel_skill_icon:getChildByName("Panel_skills_icon_"..i)
                local pic = dms.int(dms["majesty_skill"],zstring.tonumber(_ED.majesty_info[i]),majesty_skill.skill_pic)
                Panel_skill_icon_child:setBackGroundImage("images/ui/role_skills/protagonist_skills/protagonist_skills_".. pic .. ".png")

                    --关闭
            end
        else
            Image_skills_icon_lock:setVisible(true)
            Text_skills_icon_lock_lv:setString(v - 1)
        end   
    end

end


function ProtagonistSkills:onInit( )
    local csbItem = csb.createNode(config_csb.home.protagonist_skills)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_protagonist_skills_back"), nil, 
    {
        terminal_name = "protagonist_skills_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --翻页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_protagonist_skills_right"), nil, 
    {
        terminal_name = "protagonist_skills_turn_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        to_turn_page = 1,
    }, nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_protagonist_skills_left"), nil, 
    {
        terminal_name = "protagonist_skills_turn_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        to_turn_page = 0,
    }, nil, 0)

    for i=1,12 do
        local Panel_protagonist_skills_cell = ccui.Helper:seekWidgetByName(root,"Panel_protagonist_skills_cell_"..i)
        --添加技能
        local function buttonTouchEvent(sender, evenType)
            local __spoint = sender:getTouchBeganPosition()
            if ccui.TouchEventType.began == evenType then
                local function openOtherWindow( ... )
                    if self.open_window == false then
                        state_machine.excute("protagonist_skills_infor_window_open",0,{
                            i,cc.p(__spoint.x,__spoint.y)
                            })
                        self.open_window = true
                    else
                        state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
                    end
                end 
                self.open_window = false        
                local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
                self:stopAllActions()
                self:runAction(action)
            elseif ccui.TouchEventType.moved == evenType then

            elseif ccui.TouchEventType.canceled == evenType then
                self:stopAllActions()
                state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
            
            elseif ccui.TouchEventType.ended == evenType then
                self:stopAllActions()
                state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
            if self.open_window == true then
                return
            end
            state_machine.excute("protagonist_skills_add_skill",0,{_datas = {add_index = i}})
        end
    end

        fwin:addTouchEventListener(Panel_protagonist_skills_cell, buttonTouchEvent, 
        {
            -- terminal_name = "protagonist_skills_add_skill", 
            terminal_state = 0, 
            add_index = i,
        }, nil, 0)
        
    end

    for i=1,4 do 
        local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon_"..i)
        
        local function buttonTouchEvent(sender, evenType)
            local __spoint = sender:getTouchBeganPosition()
            if ccui.TouchEventType.began == evenType then
                local function openOtherWindow( ... )
                    if self.open_window == false then
                        state_machine.excute("protagonist_skills_infor_window_open",0,{
                            tonumber(_ED.majesty_info[i]),cc.p(__spoint.x,__spoint.y)
                            })
                        self.open_window = true
                    else
                        state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
                    end
                end 
                self.open_window = false        
                local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
                self:stopAllActions()
                self:runAction(action)
            elseif ccui.TouchEventType.moved == evenType then

            elseif ccui.TouchEventType.canceled == evenType then
                self:stopAllActions()
                state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
            
            elseif ccui.TouchEventType.ended == evenType then
                self:stopAllActions()
                state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
                if self.open_window == true then
                    return
                end
                state_machine.excute("protagonist_skills_remove_skill",0,{_datas = {remove_index = i}})
            end
        end

        --移除技能        
        fwin:addTouchEventListener(Panel_skills_icon, buttonTouchEvent, 
        {
            -- terminal_name = "protagonist_skills_remove_skill", 
            terminal_state = 0, 
            remove_index = i,
        }, nil, 0)
    end 
    self.pageIndex = 1
    self:initPageViewScrollTouchListen()
    self:turnButtonCheckShow()
    self:onUpdateDraw() 
    -- self:updateDrawHero() 
end

function ProtagonistSkills:init()
	self:onInit()
    return self
end

function ProtagonistSkills:onExit()
    state_machine.remove("protagonist_skills_add_skill")    
    state_machine.remove("protagonist_skills_remove_skill")
    state_machine.remove("protagonist_skills_turn_page")
    state_machine.remove("protagonist_skills_update_draw")
    state_machine.remove("protagonist_skills_move_icon")
end
