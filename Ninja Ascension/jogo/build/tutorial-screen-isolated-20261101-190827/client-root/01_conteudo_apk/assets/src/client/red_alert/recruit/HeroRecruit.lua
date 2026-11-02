--------------------------------------------------------------------------------------------------------------
--  说明：招募首页
--------------------------------------------------------------------------------------------------------------
HeroRecruit = class("HeroRecruitClass", Window)

--打开界面
local hero_recruit_window_open_terminal = {
	_name = "hero_recruit_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        -- cacher.removeAllTextures()
        -- fwin:freeAllMemeryPool()
        cacher.addTextures(config_res.images_cached["recruit"])
        if fwin:find("HeroRecruitClass") == nil then
            fwin:open(HeroRecruit:new():init(),fwin._view)
        end
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")   
        state_machine.excute("hero_recruit_window_show",0,"")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local hero_recruit_window_close_terminal = {
	_name = "hero_recruit_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitClass"))

        if fwin:find("PacksClass") == nil then
            state_machine.excute("main_window_show",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
        end
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("seven_star_map_ui_window_hide",0,"")
        else
            state_machine.excute("player_resource_window_show",0,"")   
        end

        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(hero_recruit_window_open_terminal)
state_machine.add(hero_recruit_window_close_terminal)
state_machine.init()

function HeroRecruit:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self.gold_text = nil

    self.last_specil_time = nil
    self.last_normal_time = nil
    -- 招募状态
    self._are_recruiting = false

    app.load("client.red_alert.recruit.HeroRecruitOne")
    app.load("client.red_alert.recruit.HeroRecruitTen")
    app.load("client.red_alert.recruit.CatalogueStorage")
    app.load("client.red_alert.recruit.HeroPiecePreview")
	 -- Initialize alert_home state machine.
    local function init_hero_recruit_terminal()

		--显示所有
		local hero_recruit_window_show_terminal = {
            _name = "hero_recruit_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 隐藏所有
        local hero_recruit_window_hide_terminal = {
            _name = "hero_recruit_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
            -- 普通招募一次
        local hero_recruit_normal_once_terminal = {
            _name = "hero_recruit_normal_once",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self._are_recruiting == true then
                    return
                end
                self._are_recruiting = true
                local function recruitCallBack( response )
                    self._are_recruiting = false
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.playNormalAction ~= nil then
                            response.node:playNormalAction()
                            state_machine.excute("packs_scrollview_all_update_draw",0,"")
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
                    self._are_recruiting = false
                    return
                end
                local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))--战将刷新时间                
                if normal_recruit > 0 and tonumber(propRecruitCount) <= 0  then
                     TipDlg.drawTextDailog(red_alert_all_str[37])
                     self._are_recruiting = false
                    return
                end

                protocol_command.ship_bounty.param_list = ""..1
                NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

            -- 特殊招募一次
        local hero_recruit_specil_once_terminal = {
            _name = "hero_recruit_specil_once",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if self._are_recruiting == true then
                    return
                end
                self._are_recruiting = true
                local function recruitCallBack( response )
                    self._are_recruiting = false
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("hero_recruit_update_hero_come_times",0,"")
                        if response.node ~= nil and response.node.roots ~= nil and response.node.playSpecilAction ~= nil then
                            response.node:playSpecilAction()
                        end 
                    end
                end

                if funOpenDrawTip(130) == true then
                    self._are_recruiting = false
                    return
                end
                
                local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))--神将刷新时间

                if specil_recruit > 0 then
                    local price = countActivityHeroDiscount()
                    if tonumber(_ED.user_info.user_gold) < tonumber(price.one) then
                        TipDlg.drawTextDailog(red_alert_all_str[79])
                        self._are_recruiting = false
                        return
                    end
                end

                protocol_command.ship_bounty.param_list = ""..2
                NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

            -- 特殊招募十次
        local hero_recruit_specil_ten_terminal = {
            _name = "hero_recruit_specil_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if self._are_recruiting == true then
                    return
                end
                self._are_recruiting = true
                if funOpenDrawTip(130) == true then
                    self._are_recruiting = false
                    return
                end
                state_machine.lock("hero_recruit_normal_once")
                state_machine.lock("hero_recruit_specil_once")
                state_machine.lock("hero_recruit_specil_ten")
                local function recruitCallBack( response )
                    self._are_recruiting = false
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- print("===========十次招募成功")
                        state_machine.excute("hero_recruit_update_hero_come_times",0,"")
                        if response.node ~= nil and response.node.roots ~= nil and response.node.playSpecilActionTen ~= nil then
                            response.node:playSpecilActionTen()
                            state_machine.excute("packs_scrollview_all_update_draw",0,"")
                        else
                            state_machine.unlock("hero_recruit_normal_once")
                            state_machine.unlock("hero_recruit_specil_once")
                            state_machine.unlock("hero_recruit_specil_ten")
                        end                         
                    else
                        state_machine.unlock("hero_recruit_normal_once")
                        state_machine.unlock("hero_recruit_specil_once")
                        state_machine.unlock("hero_recruit_specil_ten")
                    end
                end 
               --十连书
                local propRecruitCount = 0 
                if fundPropWidthId(258) ~= nil then 
                    local token = fundPropWidthId(258)
                    propRecruitCount = token.prop_number
                end
                local price = countActivityHeroDiscount()
                if tonumber(_ED.user_info.user_gold) < tonumber(price.ten) and tonumber(propRecruitCount) <= 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    state_machine.unlock("hero_recruit_normal_once")
                    state_machine.unlock("hero_recruit_specil_once")
                    state_machine.unlock("hero_recruit_specil_ten")
                    self._are_recruiting = false
                    return
                end               
                protocol_command.ship_batch_bounty.param_list = ""..2
                NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 动画还原
        local hero_recruit_action_back_terminal = {
            _name = "hero_recruit_action_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playActionBack()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local hero_recruit_update_hero_come_times_terminal = {
            _name = "hero_recruit_update_hero_come_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:purHeroCome()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新活动状态
        local hero_recruit_update_activity_terminal = {
            _name = "hero_recruit_update_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateActivity()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		state_machine.add(hero_recruit_window_show_terminal)
		state_machine.add(hero_recruit_window_hide_terminal)	
        state_machine.add(hero_recruit_normal_once_terminal)
        state_machine.add(hero_recruit_specil_once_terminal)
        state_machine.add(hero_recruit_specil_ten_terminal)
        state_machine.add(hero_recruit_action_back_terminal)
        state_machine.add(hero_recruit_update_hero_come_times_terminal)
        state_machine.add(hero_recruit_update_activity_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_hero_recruit_terminal()

end

function HeroRecruit:playActionBack( ... )
    -- local action = self.actions[1]
    -- action:play("animation_recruit_back",false)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root,"Panel_ani"):setVisible(false)
end

function HeroRecruit:playNormalAction( ... )
    -- local action = self.actions[1]
    -- action:stop()
    -- action:play("animation_recruit_normal",false)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end
        
    --     local str = frame:getEvent()

    --     if str == "animation_recrui_normal_over" then
            
    --     end
    -- end)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root,"Panel_ani"):setVisible(true)
    state_machine.excute("hero_recruit_one_window_open",0,1)
    state_machine.excute("hero_recruit_one_window_hide", 0, nil)
    local Panel_recruit_effice = ccui.Helper:seekWidgetByName(root,"Panel_recruit_effice")
    Panel_recruit_effice:setVisible(true)
    Panel_recruit_effice:removeAllChildren(true)
    local armature = ccs.Armature:create("effice_recruit_one_left")
    armature:setPosition(Panel_recruit_effice:getPositionX()+Panel_recruit_effice:getContentSize().width/2,Panel_recruit_effice:getPositionY()+Panel_recruit_effice:getContentSize().height/2)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
    Panel_recruit_effice:addChild(armature)
    armature:getAnimation():playWithIndex(0,0,0)
    armature._invoke = function(armatureBack)
        
    end
    -- print("=========普通招募一次")
    armature:getAnimation():setFrameEventCallFunc(
    function(bone,evt,originFrameIndex,currentFrameIndex)
        local tempArmature = bone:getArmature()
        if tempArmature:isVisible() == true then
            if evt == "card_show" then
               Panel_recruit_effice:setVisible(false)
               state_machine.excute("hero_recruit_one_window_show", 0, nil)
               -- state_machine.excute("hero_recruit_one_window_open",0,1)
            end
        end
    end)
    
end

function HeroRecruit:playSpecilAction( ... )
    -- local action = self.actions[1]
    -- action:stop()
    -- action:play("animation_recruit_specil",false)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end
        
    --     local str = frame:getEvent()

    --     if str == "animation_recrui_spec_over" then
    --     end
    -- end)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root,"Panel_ani"):setVisible(true)
    state_machine.excute("hero_recruit_one_window_open",0,2)
    state_machine.excute("hero_recruit_one_window_hide", 0, nil)
    local Panel_recruit_effice = ccui.Helper:seekWidgetByName(root,"Panel_recruit_effice")
    Panel_recruit_effice:removeAllChildren(true)
    Panel_recruit_effice:setVisible(true)
    local armature = ccs.Armature:create("effice_recruit_one_right")
    armature:setPosition(Panel_recruit_effice:getPositionX()+Panel_recruit_effice:getContentSize().width/2,Panel_recruit_effice:getPositionY()+Panel_recruit_effice:getContentSize().height/2)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
    Panel_recruit_effice:addChild(armature)
    armature:getAnimation():playWithIndex(0,0,0)
    armature._invoke = function(armatureBack)
        
    end
    -- print("=========招募一次")
    armature:getAnimation():setFrameEventCallFunc(
    function(bone,evt,originFrameIndex,currentFrameIndex)
        local tempArmature = bone:getArmature()
        if tempArmature:isVisible() == true then
            if evt == "card_show" then
                Panel_recruit_effice:setVisible(false)
                state_machine.excute("hero_recruit_one_window_show", 0, nil)
                -- state_machine.excute("hero_recruit_one_window_open",0,1)
            end
        end
    end)
end

function HeroRecruit:playSpecilActionTen( ... )
    -- local action = self.actions[1]
    -- action:stop()
    -- action:play("animation_recruit_specil",false)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end
        
    --     local str = frame:getEvent()

    --     if str == "animation_recrui_spec_over" then
    ccui.Helper:seekWidgetByName(self.roots[1],"Panel_ani"):setVisible(true)
            state_machine.excute("hero_recruit_ten_window_open",0,"")
            state_machine.unlock("hero_recruit_normal_once")
            state_machine.unlock("hero_recruit_specil_once")
            state_machine.unlock("hero_recruit_specil_ten")
    --     end
    -- end)
end

function HeroRecruit:onShow()
   self:setVisible(true)
end

function HeroRecruit:onHide()
   self:setVisible(false)
end

function HeroRecruit:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function HeroRecruit:purHeroCome( ... )
    local root = self.roots[1]
    local Panel_recruit_frequency = ccui.Helper:seekWidgetByName(root,"Panel_recruit_frequency")
    local Panel_recruit_this_time = ccui.Helper:seekWidgetByName(root,"Panel_recruit_this_time")
    local BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_1")
    local accumulateBuyGod = 0
    if tonumber(_ED.user_accumulate_buy_god) > 9 then
        accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)-10
    else
        accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)
    end
    
    local getGodShipCont = 9 - accumulateBuyGod --再抽几次就抽5星神将
    if getGodShipCont > 0 then
        BitmapFontLabel_1:setString(getGodShipCont)
        Panel_recruit_this_time:setVisible(false)
        Panel_recruit_frequency:setVisible(true)        
    elseif getGodShipCont==0 then
        Panel_recruit_this_time:setVisible(true)
        Panel_recruit_frequency:setVisible(false)
        if tonumber(_ED.user_accumulate_buy_god) > 9 then

        else

        end
    end
    
    
end

function HeroRecruit:updateDraw()
    local root = self.roots[1]
    local action = self.actions[1]
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    
    local Text_recruit_gem_nub = ccui.Helper:seekWidgetByName(root,"Text_recruit_gem_nub")
    --钻石
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
        Text_recruit_gem_nub:setString(string.format(red_alert_all_str[122],info))
    else
        Text_recruit_gem_nub:setString(_ED.user_info.user_gold) 
    end
    self.gold_text = Text_recruit_gem_nub  

    local Text_cost_gem_number = ccui.Helper:seekWidgetByName(root,"Text_cost_gem_number")
    local Text_leave_gem_number = ccui.Helper:seekWidgetByName(root,"Text_leave_gem_number")

    local price = countActivityHeroDiscount()
    Text_cost_gem_number:setString(price.one)
    Text_leave_gem_number:setString(price.ten)        

    local Panel_role_1 = ccui.Helper:seekWidgetByName(root,"Panel_role_1")
    local Panel_role_2 = ccui.Helper:seekWidgetByName(root,"Panel_role_2")
    local Panel_role_3 = ccui.Helper:seekWidgetByName(root,"Panel_role_3")
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	if Panel_role_2~= nil then
			Panel_role_2:removeAllChildren(true)
			local function onUpdateHeroIconOne()
				local jsonPath = "sprite/spirte_zhaomu111.json"
				local atlasPath = "sprite/spirte_zhaomu111.atlas"
				if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
					local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
					animation:setPosition(cc.p(Panel_role_2:getContentSize().width/2,Panel_role_2:getContentSize().height*2))
					Panel_role_2:addChild(animation)
				end
			end
			local run_action_1 = cc.Sequence:create(cc.DelayTime:create(0.01),cc.CallFunc:create(onUpdateHeroIconOne))
			self:runAction(run_action_1)
		end
    else
		if Panel_role_1 ~= nil then
			Panel_role_1:removeAllChildren(true)
			local jsonPath = "images/face/big_head/big_head_1028.json"
			local atlasPath = "images/face/big_head/big_head_1028.atlas"
			if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
				local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
				animation:setPosition(cc.p(Panel_role_1:getContentSize().width/2,Panel_role_1:getContentSize().height/2))
				Panel_role_1:addChild(animation)
			end

			Panel_role_2:removeAllChildren(true)
			local jsonPath = "images/face/big_head/big_head_1009.json"
			local atlasPath = "images/face/big_head/big_head_1009.atlas"
			if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
				local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
				animation:setPosition(cc.p(Panel_role_2:getContentSize().width/2,Panel_role_2:getContentSize().height/2))
				Panel_role_2:addChild(animation)
			end

			Panel_role_3:removeAllChildren(true)
			local jsonPath = "images/face/big_head/big_head_1012.json"
			local atlasPath = "images/face/big_head/big_head_1012.atlas"
			if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
				local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
				animation:setPosition(cc.p(Panel_role_3:getContentSize().width/2,Panel_role_3:getContentSize().height/2))
				Panel_role_3:addChild(animation)
			end
		end
    end
    -- 送碎片活动
    local Panel_songsuipian = ccui.Helper:seekWidgetByName(root,"Panel_songsuipian")
    Panel_songsuipian:setVisible(false)
    for i=1,4 do
        local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_"..i)
        Panel_icon:removeAllChildren(true)
    end
    if _ED.activity_info ~= nil then
        if _ED.activity_info["38"] ~= nil then
            Panel_songsuipian:setVisible(true)
            action:play("animation_song", true)
            local reward_id = _ED.activity_info["38"].activity_data[1][1].achieve_reward
            local reward_items = dms.string(dms["scene_reward"],reward_id,scene_reward.reward_items)
            reward_items = zstring.split(reward_items,"|")
            for i,v in pairs(reward_items) do
                if i <= 4 then
                    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_"..i)
                    local reward_tab = zstring.split(v,",")
                    local _item_value = tonumber(reward_tab[3])
                    local _prop_type = tonumber(reward_tab[2])
                    local _prop_item = tonumber(reward_tab[1])
                    local data = 
                    {
                        item_value = _item_value,
                        prop_type = _prop_type,
                        prop_item = _prop_item,
                    }
                    local cell = nil
                    if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
                        or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
                        cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,8,0,false,true})
                        if tonumber(data.prop_type) == 7 then 
                            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,true})
                        end
                    else
                        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,true})
                    end  
                    Panel_icon:addChild(cell)
                end
            end
        end
    end
end

-- 送碎片活动
function HeroRecruit:onUpdateActivity()
    local root = self.roots[1]
    local Panel_songsuipian = ccui.Helper:seekWidgetByName(root,"Panel_songsuipian")
    if _ED.activity_info ~= nil then
        if _ED.activity_info["38"] == nil then
            Panel_songsuipian:setVisible(false)
        end
    end
end

function HeroRecruit:onUpdate(dt)
    if self.gold_text == nil then
        return
    end
    --钻石
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
        self.gold_text:setString(string.format(red_alert_all_str[122],info))
    else
        self.gold_text:setString(_ED.user_info.user_gold)
    end

    self:onUpdateSpecilTime()
    self:onUpdateNormalTime()
    self:onUpdatePropNumber()
end

function HeroRecruit:onUpdatePropNumber( ... )
    local root = self.roots[1]
    --召唤书
    local propRecruitCount = 0 
    if fundPropWidthId(217) ~= nil then 
        local token = fundPropWidthId(217)
        propRecruitCount = zstring.tonumber(token.prop_number)
    end
    local Text_leave_number = ccui.Helper:seekWidgetByName(root,"Text_leave_number")
    Text_leave_number:setString("x"..propRecruitCount)
    local Image_free = ccui.Helper:seekWidgetByName(root,"Image_free")
    Image_free:setVisible(false)
    local Text_free_count = ccui.Helper:seekWidgetByName(root,"Text_free_count")
    if tonumber(propRecruitCount) > 0 then 
        Image_free:setVisible(true)
        Text_free_count:setString(propRecruitCount)
    end

    --十连书
    local propRecruitCount_ten = 0 
    if fundPropWidthId(258) ~= nil then 
        local token = fundPropWidthId(258)
        propRecruitCount_ten = zstring.tonumber(token.prop_number)
    end
    local Panel_choushici = ccui.Helper:seekWidgetByName(root,"Panel_choushici")
    Panel_choushici:setVisible(false)
    local Text_choushici = ccui.Helper:seekWidgetByName(root,"Text_choushici")
    Text_choushici:setVisible(true)
    local Panel_choushici_free = ccui.Helper:seekWidgetByName(root,"Panel_choushici_free")
    Panel_choushici_free:setVisible(false)
    local Text_free_count_ten = ccui.Helper:seekWidgetByName(root,"Text_free_count_ten")
    local Text_chou_free = ccui.Helper:seekWidgetByName(root,"Text_chou_free")
    if tonumber(propRecruitCount_ten) > 0 then
        Text_choushici:setVisible(false)
        Panel_choushici_free:setVisible(true)
        Text_free_count_ten:setString(propRecruitCount_ten)
        Text_chou_free:setString(string.format(red_alert_all_str[174], propRecruitCount_ten))
    else
        Panel_choushici:setVisible(true)
    end

    -- 高级侠客令
    local propRecruitCount_one = 0 
    if fundPropWidthId(232) ~= nil then 
        local token = fundPropWidthId(232)
        propRecruitCount_one = zstring.tonumber(token.prop_number)
    end
    local Panel_recruit_one_gem = ccui.Helper:seekWidgetByName(root,"Panel_recruit_one_gem")
    local Panel_free_countdown = ccui.Helper:seekWidgetByName(root,"Panel_free_countdown")
    Panel_recruit_one_gem:setVisible(false)
    Panel_free_countdown:setVisible(false)
    local Image_recruit_time = ccui.Helper:seekWidgetByName(root,"Image_recruit_time")
    Image_recruit_time:setVisible(false)
    local Text_recruit_time = ccui.Helper:seekWidgetByName(root,"Text_recruit_time")
    Text_recruit_time:setString("")
    if tonumber(propRecruitCount_one) > 0 then
        Image_recruit_time:setVisible(true)
        Text_recruit_time:setString(propRecruitCount_one)
    else
        Panel_recruit_one_gem:setVisible(true)
        Panel_free_countdown:setVisible(true)
    end
end

function HeroRecruit:onUpdateNormalTime( ... )
    local root = self.roots[1]
    local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))--战将刷新时间
    local Panel_normal_free_time = ccui.Helper:seekWidgetByName(root,"Panel_normal_free_time")
    local Text_recruit_one = ccui.Helper:seekWidgetByName(root,"Text_recruit_one")
    local Text_free_time_one = ccui.Helper:seekWidgetByName(root,"Text_free_time_one")
    local Text_normal_free_time = ccui.Helper:seekWidgetByName(root,"Text_normal_free_time")
    local everyDayFreeTime = tonumber(_ED.free_info[1].surplus_free_number) or 0 
    if self.last_normal_time == normal_recruit then
        return
    end
    
    if everyDayFreeTime <= 0 then
        Text_recruit_one:setVisible(true)
        Text_free_time_one:setVisible(false)        
        return
    end

    -- print("=========",everyDayFreeTime)
    if tonumber(normal_recruit) < 0 and everyDayFreeTime > 0  then
        Panel_normal_free_time:setVisible(false)
        Text_recruit_one:setVisible(false)
        Text_free_time_one:setVisible(true)
        return
    end
    -- print("===================",self:formatTimeString(normal_recruit),normal_recruit)
    Panel_normal_free_time:setVisible(true)
    Text_recruit_one:setVisible(true)
    Text_free_time_one:setVisible(false)  
    Text_normal_free_time:setString(self:formatTimeString(normal_recruit))
    self.last_normal_time = normal_recruit
end

function HeroRecruit:onUpdateSpecilTime( ... )
    local root = self.roots[1]
    local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))--神将刷新时间
    local Panel_free_countdown = ccui.Helper:seekWidgetByName(root,"Panel_free_countdown")
    local Text_free_time = ccui.Helper:seekWidgetByName(root,"Text_free_time")
    local Text_chouyici_free = ccui.Helper:seekWidgetByName(root,"Text_chouyici_free")
    local Text_chouyici = ccui.Helper:seekWidgetByName(root,"Text_chouyici")
    local Panel_recruit_one_gem = ccui.Helper:seekWidgetByName(root,"Panel_recruit_one_gem")    --抽一次需消耗宝石的层
    local Panel_free_light = ccui.Helper:seekWidgetByName(root,"Panel_free_light")
    
    if self.last_specil_time == specil_recruit then
        return
    end
    if tonumber(specil_recruit) < 0  then
        Panel_free_countdown:setVisible(false)
        Text_chouyici:setVisible(false)
        Text_chouyici_free:setVisible(true)
        Panel_recruit_one_gem:setVisible(false)
        Panel_free_light:setVisible(true)
        return
    end
    Panel_free_countdown:setVisible(true)
    -- print("===================",self:formatTimeString(specil_recruit))
    Text_free_time:setString(self:formatTimeString(specil_recruit))
    self.last_specil_time = specil_recruit
    Text_chouyici:setVisible(true)
    Text_chouyici_free:setVisible(false)  
    Panel_recruit_one_gem:setVisible(true)  
    Panel_free_light:setVisible(false)
end

function HeroRecruit:onInit()
    -- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_one_left/effice_recruit_one_left.ExportJson")
    -- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_one_right/effice_recruit_one_right.ExportJson")
    -- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_main/effice_recruit_main.ExportJson")
    -- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_main2/effice_recruit_main2.ExportJson")
    for i, v in pairs(config_res.armatures_cached["recruit"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end

    local csbItem = csb.createNode(config_csb.recruit.hero_recruit)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local Panel_recruit_bg = ccui.Helper:seekWidgetByName(root,"Panel_recruit_bg")
		Panel_recruit_bg:setBackGroundImage("images/ui/bg/recruit_bg.png")
    end
    local action = csb.createTimeline(config_csb.recruit.hero_recruit) 
    table.insert(self.actions, action)
    csbItem:runAction(action)

    --关闭 -- 返回主页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_back"), nil, 
    {
        terminal_name = "hero_recruit_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    -- 招募一次 - 普通
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_normal_one"), nil, 
    {
        terminal_name = "hero_recruit_normal_once", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)
    
    -- 特殊一次 - 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_specil_one"), nil, 
    {
        terminal_name = "hero_recruit_specil_once", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    -- 特殊十次 - 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_specil_ten"), nil, 
    {
        terminal_name = "hero_recruit_specil_ten", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)
    
    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_gem_add"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_add_gem"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0,
    },
    nil,0)

    -- 图鉴
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_role_register"), nil, 
    {
        -- func_string = [[funOpenDrawTip(104)]],
        terminal_name = "catalogue_storage_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)    

    -- 送碎片
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_suipian"), nil, 
    {
        terminal_name = "hero_piece_preview_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)  
    self:updateDraw()
    self:purHeroCome()
end

function HeroRecruit:onEnterTransitionFinish()
    
end

function HeroRecruit:init()
	self:onInit()
    return self
end

function HeroRecruit:onExit()
    state_machine.remove("hero_recruit_window_show")
    state_machine.remove("hero_recruit_window_hide")
    state_machine.remove("hero_recruit_normal_once")
    state_machine.remove("hero_recruit_specil_once")
    state_machine.remove("hero_recruit_specil_ten")
    state_machine.remove("hero_recruit_action_back")
    state_machine.remove("hero_recruit_update_hero_come_times")
    state_machine.remove("hero_recruit_update_activity")
    for i, v in pairs(config_res.armatures_cached["recruit"]) do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v)
    end
end