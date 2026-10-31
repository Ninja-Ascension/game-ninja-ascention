--------------------------------------------------------------------------------------------------------------
--  说明：将领招募十次
--------------------------------------------------------------------------------------------------------------
LeaderRecruitTen = class("LeaderRecruitTenClass", Window)

--打开界面
local leader_recruit_ten_window_open_terminal = {
	_name = "leader_recruit_ten_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(LeaderRecruitTen:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local leader_recruit_ten_window_close_terminal = {
    _name = "leader_recruit_ten_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderRecruitTenClass"))
        state_machine.excute("leader_team_list_update", 0, "")
        state_machine.excute("leader_exchange_list_update", 0, "")
        _ED.show_reward_list_group = {}
        _ED.show_reward_list_group_ex = {}
        state_machine.unlock("leader_recruit_choose_recruit")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_recruit_ten_window_open_terminal)
state_machine.add(leader_recruit_ten_window_close_terminal)
state_machine.init()

function LeaderRecruitTen:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._action_index = 0
    self._begin_pos_x = 0
    self._begin_pos_y = 0
    self._move_panel = nil
    self._move_zorder = 150

    self._get_prop_id = 0
    self._get_prop_num = 0
    self._get_prop_type = 0
    self._panel_prop_icon = nil

    self._play_state = 0

    local function init_leader_recruit_ten_terminal()
        local leader_recruit_ten_sure_recruit_terminal = {
            _name = "leader_recruit_ten_sure_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local price = countActivityHeroDiscount()
                local need_gold = price.ten 
                if _ED.activity_info ~= nil and _ED.activity_info["8"] ~= nil then
                    local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
                    need_gold = math.floor(need_gold * tonumber(a_datas[6]))
                end
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold, 10, 3}, m_type = 12}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_ten_play_back_action_terminal = {
            _name = "leader_recruit_ten_play_back_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playBackAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_ten_update_draw_terminal = {
            _name = "leader_recruit_ten_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_ten_update_ani_state_terminal = {
            _name = "leader_recruit_ten_update_ani_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showActionAni(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_recruit_ten_sure_recruit_terminal)
        state_machine.add(leader_recruit_ten_play_back_action_terminal)
        state_machine.add(leader_recruit_ten_update_draw_terminal)
        state_machine.add(leader_recruit_ten_update_ani_state_terminal)
        state_machine.init()
    end
    init_leader_recruit_ten_terminal()
end

function LeaderRecruitTen:sureRecruit(sure_number)
    local function recruitCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
            state_machine.excute("leader_recruit_update", 0, nil)
        end
    end
    if sure_number == 0 then
        protocol_command.ship_batch_bounty.param_list = ""..2
        NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)   
    end
end

function LeaderRecruitTen:playBackAction( ... )
    if self._play_state ~= 2 then
        return
    end
    self._play_state = 3

    function actionEnd(sender)
        if sender ~= nil then
            sender:getParent():reorderChild(sender, self._move_zorder)
            sender._self:playSuccessAction()
        end
    end
    local Image_recruit_get_special_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_recruit_get_special_bg")
    Image_recruit_get_special_bg:setVisible(false)

    self._panel_prop_icon:removeAllChildren(true)
    local cell = nil
    if self._get_prop_type == 1 then
        cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, self._get_prop_id, 3, self._get_prop_num,true})
    else
        cell = state_machine.excute("props_icon_create_cell", 0, {9, 1, self._get_prop_id, 1, self._get_prop_num})
    end
    self._panel_prop_icon:addChild(cell)

    self._move_panel:runAction(cc.Sequence:create(
        cc.Spawn:create({cc.MoveTo:create(0.3, cc.p(self._begin_pos_x, self._begin_pos_y)),
                cc.ScaleTo:create(0.3, 1)
            }),
        cc.CallFunc:create(actionEnd)
        ))
end

function LeaderRecruitTen:playSuccessAction( ... )
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    self._action_index = self._action_index + 1
    if self._action_index > 10 then
        self:updateState(true)
        return
    end

    self._play_state = 1

    local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..self._action_index)
    
    function actionCallBack(sender)
        sender._self:playSuccessAction()
    end

    function actionCallBack2(sender)
        if sender ~= nil then
            self._play_state = 2

            local Image_recruit_get_special_bg = ccui.Helper:seekWidgetByName(root, "Image_recruit_get_special_bg")
            Image_recruit_get_special_bg:setTouchEnabled(true)

            self._panel_prop_icon:removeAllChildren(true)
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_leader)
            local armature = ccs.Armature:create("effect_leader")
            armature:getAnimation():playWithIndex(0)
            armature:setPosition(cc.p(self._panel_prop_icon:getContentSize().width/2,self._panel_prop_icon:getContentSize().height/2))
            self._panel_prop_icon:addChild(armature)
            local cell = state_machine.excute("leader_big_head_create_cell", 0, {self._get_prop_id, self._get_prop_num, self._get_prop_type})
            local size = self._panel_prop_icon:getContentSize()
            cell:setAnchorPoint(cc.p(0.5, 0.5))
            cell:setPosition(cc.p(size.width / 2, size.height / 2))
            self._panel_prop_icon:addChild(cell)
        end
    end
    self._get_prop_type = tonumber(_ED.random_Patch[self._action_index].random_patch_type)
    local get_prop_id = tonumber(_ED.random_Patch[self._action_index].random_patch_id)
    local get_prop_num = tonumber(_ED.random_Patch[self._action_index].random_patch_num) 
    local cell = nil 
    if self._get_prop_type == 0 then
        checkPlayEffect(57)
        cell = state_machine.excute("props_icon_create_cell",0,{9,1,get_prop_id,1,get_prop_num,true})
    elseif self._get_prop_type == 1 then
        checkPlayEffect(58)
        cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, get_prop_id, 3,get_prop_num,true})
    else
        checkPlayEffect(58)
        cell = state_machine.excute("props_icon_create_cell",0,{9,1,get_prop_id,1,get_prop_num,true})
    end
    Panel_leader_get_icon:addChild(cell)

    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_leader_get_icon:addChild(armature)
    armature:setPosition(cc.p(Panel_leader_get_icon:getContentSize().width/2, Panel_leader_get_icon:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    -- Panel_leader_get_icon:setBackGroundImage("images/ui/props/props_3.png")
    Panel_leader_get_icon._self = self

    if self._get_prop_type == 1 or self._get_prop_type == 2 then
        local Panel_recruit_get_special_icon = ccui.Helper:seekWidgetByName(root, "Panel_recruit_get_special_icon")
        local Image_recruit_get_special_bg = ccui.Helper:seekWidgetByName(root, "Image_recruit_get_special_bg")
        Image_recruit_get_special_bg:setVisible(true)
        Image_recruit_get_special_bg:setTouchEnabled(false)
        self._begin_pos_x, self._begin_pos_y = Panel_leader_get_icon:getPosition()
        self._move_panel = Panel_leader_get_icon
        Panel_leader_get_icon:getParent():reorderChild(Panel_leader_get_icon, 10000)

        self._get_prop_id = get_prop_id
        self._panel_prop_icon = Panel_leader_get_icon
        self._get_prop_num = get_prop_num

        local posx, posy = Panel_recruit_get_special_icon:getPosition()
        Panel_leader_get_icon:runAction(cc.Sequence:create(
            cc.Spawn:create({cc.MoveTo:create(0.2, cc.p(posx, posy)),
                    cc.ScaleTo:create(0.2, 1)
                }),
            cc.CallFunc:create(actionCallBack2)
            ))
    else
        Panel_leader_get_icon:runAction(cc.Sequence:create(
            cc.ScaleTo:create(0.15, 1),
            cc.CallFunc:create(actionCallBack)
            ))
    end
end

function LeaderRecruitTen:playAction( ... )
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("ani_leader_get_icon", false)
    checkPlayEffect(57)
    for i=1,10 do
        local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
        local get_prop_type = tonumber(_ED.random_Patch[i].random_patch_type)
        local get_prop_id = tonumber(_ED.random_Patch[i].random_patch_id)
        local get_prop_num = tonumber(_ED.random_Patch[i].random_patch_num) 
        local cell = nil 
        if get_prop_type == 0 then
            -- checkPlayEffect(57)
            cell = state_machine.excute("props_icon_create_cell",0,{9,1,get_prop_id,1,get_prop_num,true})
        elseif get_prop_type == 1 then
            -- checkPlayEffect(58)
            cell = state_machine.excute("props_icon_create_cell", 0, {2,9,get_prop_id, 3,get_prop_num,true})
        else
            get_prop_id = dms.int(dms["prop_mould"], get_prop_id, prop_mould.use_of_ship)
            -- checkPlayEffect(58)
            cell = state_machine.excute("props_icon_create_cell", 0, {2,9,get_prop_id,3,get_prop_num,true})
        end
        Panel_leader_get_icon:addChild(cell)
    end
end

function LeaderRecruitTen:showActionAni( state )
    local root = self.roots[1]
    if state <= 2 then
        checkPlayEffect(57)
    end
    for i=1,10 do
        local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
        if state == 1 then
            if i <= 4 then
                self:createEffect(Panel_leader_get_icon, i)
            end
        elseif state == 2 then
            if i > 4 and i <= 8 then
                self:createEffect(Panel_leader_get_icon, i)
            end
        elseif state == 3 then
            if i > 8 then
                self:createEffect(Panel_leader_get_icon, i)
            end
        end
    end
end

function LeaderRecruitTen:createEffect( panel, index )
    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    panel:addChild(armature)
    armature:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    if tonumber(_ED.random_Patch[index].random_patch_type) ~= 0 then
        local armature1 = ccs.Armature:create("effect_luck_draw")
        draw.initArmature(armature1, nil, -1, 0, 1)
        armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        panel:addChild(armature1)
        armature1:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
        armature1:getAnimation():playWithIndex(0)
    end
end

function LeaderRecruitTen:onUpdateDraw(  )
    local root = self.roots[1]
    local Text_recruit_gold_n = ccui.Helper:seekWidgetByName(root, "Text_recruit_gold_n")
    local Panel_get_text_effice = ccui.Helper:seekWidgetByName(root, "Panel_get_text_effice")

    local price = countActivityHeroDiscount()
    local percent = 1
    local Image_leader_draw_get_10 = ccui.Helper:seekWidgetByName(root, "Image_leader_draw_get_10")
    local Image_ten_get_10_delete = ccui.Helper:seekWidgetByName(root, "Image_ten_get_10_delete")
    local Text_ten_get_10_consume_discount_n = ccui.Helper:seekWidgetByName(root, "Text_ten_get_10_consume_discount_n")
    Image_leader_draw_get_10:setVisible(false)
    Image_ten_get_10_delete:setVisible(false)
    Text_ten_get_10_consume_discount_n:setVisible(false)
    Text_ten_get_10_consume_discount_n:setString("")
    if _ED.activity_info ~= nil and _ED.activity_info["8"] ~= nil then
        local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
        percent = tonumber(a_datas[6])
        Image_leader_draw_get_10:setVisible(true)
        Image_ten_get_10_delete:setVisible(true)
        Text_ten_get_10_consume_discount_n:setVisible(true)
        Text_ten_get_10_consume_discount_n:setString(price.ten)
    end
    Text_recruit_gold_n:setString(math.floor(price.ten*percent))

    Panel_get_text_effice:removeAllChildren(true)
    local armature1 = ccs.Armature:create("effice_recruit_get_text")
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_get_text_effice:addChild(armature1)
    armature1:getAnimation():playWithIndex(0)

    for i=1,10 do
        local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
        Panel_leader_get_icon:removeAllChildren(true)
        -- Panel_leader_get_icon:stopAllActions()
        -- Panel_leader_get_icon:removeBackGroundImage()
        -- Panel_leader_get_icon:setScale(0.1)
    end

    self._action_index = 0
    -- self:updateState(false)
    -- self:playSuccessAction()
    self:playAction()
end

function LeaderRecruitTen:updateState( state )
    local root = self.roots[1]
    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root, "Button_senior_recruit")
    local Button_recruit_sure = ccui.Helper:seekWidgetByName(root, "Button_recruit_sure")
    local Image_recruit_gold_icon = ccui.Helper:seekWidgetByName(root, "Image_recruit_gold_icon")
    local Text_recruit_gold_n = ccui.Helper:seekWidgetByName(root, "Text_recruit_gold_n")
    local Image_leader_draw_get_10 = ccui.Helper:seekWidgetByName(root, "Image_leader_draw_get_10")
    local Image_ten_get_10_delete = ccui.Helper:seekWidgetByName(root, "Image_ten_get_10_delete")
    local Text_ten_get_10_consume_discount_n = ccui.Helper:seekWidgetByName(root, "Text_ten_get_10_consume_discount_n")
    
    Button_senior_recruit:setVisible(state)
    Button_recruit_sure:setVisible(state)
    Image_recruit_gold_icon:setVisible(state)
    Text_recruit_gold_n:setVisible(state)
    if _ED.activity_info ~= nil and _ED.activity_info["8"] ~= nil then
        Image_leader_draw_get_10:setVisible(state)
        Image_ten_get_10_delete:setVisible(state)
        Text_ten_get_10_consume_discount_n:setVisible(state)
    else
        Image_leader_draw_get_10:setVisible(false)
        Image_ten_get_10_delete:setVisible(false)
        Text_ten_get_10_consume_discount_n:setVisible(false)
    end
end

function LeaderRecruitTen:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_get_ten)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.leader.leader_recruit_get_ten)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "ani_leader_get_icon_1" then
            state_machine.excute("leader_recruit_ten_update_ani_state", 0, 1)
        elseif str == "ani_leader_get_icon_2" then
            state_machine.excute("leader_recruit_ten_update_ani_state", 0, 2)
        elseif str == "ani_leader_get_icon_3" then
            state_machine.excute("leader_recruit_ten_update_ani_state", 0, 3)
        elseif str == "ani_leader_get_icon_over" then
            
        end
    end)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_recruit"), nil, 
    {
        terminal_name = "leader_recruit_ten_sure_recruit", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"), nil, 
    {
        terminal_name = "leader_recruit_ten_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_recruit_get_special_bg"), nil, 
    {
        terminal_name = "leader_recruit_ten_play_back_action", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        -- touch_black = true,
    }, nil, 1)
    
    self:onUpdateDraw()
end

function LeaderRecruitTen:onEnterTransitionFinish()

end

function LeaderRecruitTen:init(params)
	self:onInit()
    return self
end

function LeaderRecruitTen:onExit()
    state_machine.remove("leader_recruit_ten_sure_recruit")
    state_machine.remove("leader_recruit_ten_play_back_action")
    state_machine.remove("leader_recruit_ten_update_draw")
    state_machine.remove("leader_recruit_ten_update_ani_state")
end