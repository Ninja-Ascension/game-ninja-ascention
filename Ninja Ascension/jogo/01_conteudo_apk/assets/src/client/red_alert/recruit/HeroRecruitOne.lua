--------------------------------------------------------------------------------------------------------------
--  说明：招募一次csb
--------------------------------------------------------------------------------------------------------------
HeroRecruitOne = class("HeroRecruitOneClass", Window)

--打开界面
local hero_recruit_one_window_open_terminal = {
	_name = "hero_recruit_one_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local _wind = fwin:find("HeroRecruitOneClass")
        if _wind == nil then
            fwin:open(HeroRecruitOne:new():init(params),fwin._viewdialog)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local hero_recruit_one_window_close_terminal = {
	_name = "hero_recruit_one_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitOneClass"))
        state_machine.excute("hero_recruit_action_back",0,"")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(hero_recruit_one_window_open_terminal)
state_machine.add(hero_recruit_one_window_close_terminal)
state_machine.init()

function HeroRecruitOne:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self.types = 1
    self.panel_card_show = nil
	 -- Initialize hero_recruit_one state machine.
    local function init_hero_recruit_one_terminal()

		--显示所有
		local hero_recruit_one_window_show_terminal = {
            _name = "hero_recruit_one_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:setHeroIcon()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 隐藏所有
        local hero_recruit_one_window_hide_terminal = {
            _name = "hero_recruit_one_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	       --再抽一次
        local hero_recruit_one_rerecruit_terminal = {
            _name = "hero_recruit_one_rerecruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local types = instance.types
                state_machine.excute("hero_recruit_one_window_close",0,"")
                if types == 1 then
                    -- instance:reRecruitNormal()
                    state_machine.excute("hero_recruit_normal_once",0,"")
                elseif types == 2 then
                    -- instance:reRecruitSpecil()
                    state_machine.excute("hero_recruit_specil_once",0,"")
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        -- 查看角色信息
        local hero_recruit_one_look_infor_terminal = {
            _name = "hero_recruit_one_look_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.red_alert.recruit.CatalogueStorage")
                state_machine.excute("catalogue_storage_window_open",0,"")
                local ship_template_id = params._datas.ship_template_id
                state_machine.excute("catalogue_storage_choose_on_ship",0,ship_template_id)
                state_machine.excute("catalogue_storage_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(hero_recruit_one_window_show_terminal)
		state_machine.add(hero_recruit_one_window_hide_terminal)	
        state_machine.add(hero_recruit_one_rerecruit_terminal)	
        state_machine.add(hero_recruit_one_look_infor_terminal)  
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_hero_recruit_one_terminal()

end

function HeroRecruitOne:reRecruitSpecil()
    local function recruitCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            --print("===========神将再次招募成功")
            state_machine.excute("hero_recruit_update_hero_come_times",0,"")
            if response.node ~= nil and response.node.roots ~= nil and response.node.updateDrawForSpecil ~= nil then
                response.node:rePlayAction(2)
            end
        end
    end 
    local price = countActivityHeroDiscount()
    if tonumber(_ED.user_info.user_gold) < tonumber(price.one) then
        TipDlg.drawTextDailog(red_alert_all_str[79])
        return
    end
    protocol_command.ship_bounty.param_list = ""..2
    NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)    
end

function HeroRecruitOne:reRecruitNormal( ... )
    local function recruitCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            --print("===========战将再次招募成功")
            state_machine.excute("hero_recruit_update_hero_come_times",0,"")
            if response.node ~= nil and response.node.roots ~= nil and response.node.updateDrawForNormal ~= nil then
                response.node:rePlayAction(1)
            end
        end
    end 
    local everyDayFreeTime = tonumber(_ED.free_info[1].surplus_free_number) or 0 
    --召唤书
    local propRecruitCount = 0 
    if fundPropWidthId(217) ~= nil then 
        local token = fundPropWidthId(217)
        propRecruitCount = token.prop_number
    end

    if everyDayFreeTime <= 0 and tonumber(propRecruitCount) <= 0 then
        TipDlg.drawTextDailog(red_alert_all_str[36])
        return
    end
    local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))--战将刷新时间                
    if normal_recruit > 0 and tonumber(propRecruitCount) <= 0  then
        TipDlg.drawTextDailog(red_alert_all_str[37])
        return
    end
    protocol_command.ship_bounty.param_list = ""..1
    NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)
end

function HeroRecruitOne:rePlayAction(index)
    local root = self.roots[1]
    local Panel_recruit_card_role = ccui.Helper:seekWidgetByName(root,"Panel_recruit_card_role")
    Panel_recruit_card_role:removeBackGroundImage()
    local armature = nil
    if index == 1 then
        armature = ccs.Armature:create("effice_recruit_one_left")
    elseif index == 2 then
        armature = ccs.Armature:create("effice_recruit_one_right")
    end
    
    armature:setPosition(root:getPositionX()+root:getContentSize().width/2,root:getPositionY()+root:getContentSize().height/2)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
    root:addChild(armature)
    armature:getAnimation():playWithIndex(0,0,0)
    armature._invoke = function(armatureBack)

    end

    self:setHeroIconEX()

    armature:getAnimation():setFrameEventCallFunc(
    function(bone,evt,originFrameIndex,currentFrameIndex)
        local tempArmature = bone:getArmature()
        if tempArmature:isVisible() == true then
            if evt == "card_show" then
                if index == 1 then
                    self:updateDrawForNormal()
                elseif index == 2 then
                    self:updateDrawForSpecil()
                end     
            end
        end
    end)
end

function HeroRecruitOne:updateDrawForNormal()
    local root = self.roots[1]
    local Panel_recruit_show_make = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_make")
    local Panel_recruit_show_gem = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_gem")
    Panel_recruit_show_make:setVisible(true)
    Panel_recruit_show_gem:setVisible(false)
    self.panel_card_show:setVisible(true)
    --召唤书
    local propRecruitCount = 0 
    if fundPropWidthId(217) ~= nil then 
        local token = fundPropWidthId(217)
        propRecruitCount = token.prop_number
    end
    local Text_recruit_show_make_leave = ccui.Helper:seekWidgetByName(root,"Text_recruit_show_make_leave")
    Text_recruit_show_make_leave:setString("x"..propRecruitCount)

    self:setHeroIcon()
    playEffect(formatMusicFile("effect", 10001))
end

function HeroRecruitOne:updateDrawForSpecil()
    local root = self.roots[1]
    local Panel_recruit_show_make = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_make")
    local Panel_recruit_show_gem = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_gem")
    self.panel_card_show:setVisible(true)
    local price = countActivityHeroDiscount()

    Panel_recruit_show_make:setVisible(false)
    Panel_recruit_show_gem:setVisible(true)  
    local Text_recruit_show_gem_nub = ccui.Helper:seekWidgetByName(root,"Text_recruit_show_gem_nub")
    Text_recruit_show_gem_nub:setString(price.one)


    local Panel_recruit_time = ccui.Helper:seekWidgetByName(root,"Panel_recruit_time")
    local Panel_recruit_this_time = ccui.Helper:seekWidgetByName(root,"Panel_recruit_this_time")
    local BitmapFontLabel_recruit_time = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_recruit_time")
    local accumulateBuyGod = 0
    if tonumber(_ED.user_accumulate_buy_god) > 9 then
        accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)-10
    else
        accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)
    end
    
    local getGodShipCont = 9 - accumulateBuyGod --再抽几次就抽5星神将
    if getGodShipCont > 0 then
        BitmapFontLabel_recruit_time:setString(getGodShipCont)
        Panel_recruit_this_time:setVisible(false)
        Panel_recruit_time:setVisible(true)        
    elseif getGodShipCont==0 then
        Panel_recruit_this_time:setVisible(true)
        Panel_recruit_time:setVisible(false)
        if tonumber(_ED.user_accumulate_buy_god) > 9 then

        else

        end
    end

    -- 高级侠客令
    local propRecruitCount_one = 0 
    if fundPropWidthId(232) ~= nil then 
        local token = fundPropWidthId(232)
        propRecruitCount_one = zstring.tonumber(token.prop_number)
    end
    local Image_recruit_time = ccui.Helper:seekWidgetByName(root,"Image_recruit_time")
    Image_recruit_time:setVisible(false)
    local Text_recruit_time = ccui.Helper:seekWidgetByName(root,"Text_recruit_time")
    Text_recruit_time:setString("")
    if tonumber(propRecruitCount_one) > 0 then
        Panel_recruit_show_gem:setVisible(false)  
        Image_recruit_time:setVisible(true)
        Text_recruit_time:setString(propRecruitCount_one)
    else
        Panel_recruit_show_gem:setVisible(true)
    end
    self:setHeroIcon()
    playEffect(formatMusicFile("effect", 10001))
end

function HeroRecruitOne:setHeroIcon( ... )
    self.actions[1]:play("animation_show_one",false)
end

function HeroRecruitOne:setHeroIconEX( )
    local root = self.roots[1]
    for i,v in pairs(_ED.user_ship) do
        if _ED.recruit_success_ship_id == v.ship_id then
            self.ship = v
        end
    end
    -- print("======",self.ship.captain_name)
    local Panel_recruit_card_role = ccui.Helper:seekWidgetByName(root,"Panel_recruit_card_role")
    Panel_recruit_card_role:removeBackGroundImage()
    local temp_bust_index = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.bust_index)
    Panel_recruit_card_role:setBackGroundImage("images/face/card_hero/card_hero_"..temp_bust_index..".png")
    
    local Panel_hero_spine_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_spine_role")
    if Panel_hero_spine_role ~= nil then
        Panel_hero_spine_role:removeAllChildren(true)
        local jsonPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".json"
        local atlasPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".atlas"
        if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
            local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
            animation:setPosition(cc.p(Panel_hero_spine_role:getContentSize().width/2,Panel_hero_spine_role:getContentSize().height/2))
            Panel_hero_spine_role:addChild(animation)
        end
    end

    -- 查看角色信息
    local Button_look_infor = ccui.Helper:seekWidgetByName(root,"Button_look_infor")
    if tonumber(self.ship.ship_type) < 3 then
        Button_look_infor:setVisible(false)
    end
    fwin:addTouchEventListener(Button_look_infor, nil, 
    {
        terminal_name = "hero_recruit_one_look_infor", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ship_template_id = self.ship.ship_base_template_id,
    },
    nil,0)
end

function HeroRecruitOne:onInit()
    local csbItem = csb.createNode(config_csb.recruit.hero_recruit_one)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    local action = csb.createTimeline(config_csb.recruit.hero_recruit_one) 
    table.insert(self.actions, action)
    csbItem:runAction(action)

    self:setVisible(false)

    local Panel_card_show = ccui.Helper:seekWidgetByName(root,"Panel_card_show")
    self.panel_card_show = Panel_card_show
    --返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_show_back"), nil, 
    {
        terminal_name = "hero_recruit_one_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    --在抽一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_show_one"), nil, 
    {
        terminal_name = "hero_recruit_one_rerecruit", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    self:setHeroIconEX()
    if self.types == 1 then
	   self:updateDrawForNormal()
    elseif self.types == 2 then
       self:updateDrawForSpecil() 
    end
end

function HeroRecruitOne:onEnterTransitionFinish()

end

function HeroRecruitOne:init( _type )
    self.types = _type
	self:onInit()
    return self
end

function HeroRecruitOne:onExit()
    state_machine.remove("hero_recruit_one_window_show")
    state_machine.remove("hero_recruit_one_window_hide")
    state_machine.remove("hero_recruit_one_rerecruit")      
    state_machine.remove("hero_recruit_one_look_infor")
end