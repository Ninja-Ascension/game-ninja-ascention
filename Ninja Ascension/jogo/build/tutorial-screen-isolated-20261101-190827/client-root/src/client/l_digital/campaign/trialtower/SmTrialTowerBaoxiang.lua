-----------------------------
-- 试炼宝箱的界面
-----------------------------
SmTrialTowerBaoxiang = class("SmTrialTowerBaoxiangClass", Window)

--打开界面
local sm_trial_tower_baoxiang_open_terminal = {
	_name = "sm_trial_tower_baoxiang_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerBaoxiangClass") == nil then
			fwin:open(SmTrialTowerBaoxiang:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_baoxiang_close_terminal = {
	_name = "sm_trial_tower_baoxiang_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("trial_tower_insert_new_cell_data",0,"0")
		fwin:close(fwin:find("SmTrialTowerBaoxiangClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_baoxiang_open_terminal)
state_machine.add(sm_trial_tower_baoxiang_close_terminal)
state_machine.init()

function SmTrialTowerBaoxiang:ctor()
	self.super:ctor()
	self.roots = {}

	self._isBuy = false

    local function init_sm_trial_tower_baoxiang_terminal()
        --
        local sm_trial_tower_baoxiang_the_first_place_terminal = {
            _name = "sm_trial_tower_baoxiang_the_first_place",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --打开宝箱获得奖励
                local Panel_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_1")
                local Panel_dh = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_dh")
                local Image_box = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_box")
                local Button_open = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_open")
                local Sprite_open = Button_open:getChildByName("Sprite_open")
                local Sprite_open_2 = Button_open:getChildByName("Sprite_open_2")
                local Button_cancel = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_cancel")
                local Image_zs_icon = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_zs_icon")
				local Text_zuanshi_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_zuanshi_n")
				-- DSC重塑
				if __lua_project_id == __lua_project_l_digital then 
					local Text_open_1 = Button_open:getChildByName("Text_open_1")
					local Text_open_2 = Button_open:getChildByName("Text_open_2")
					if Text_open_1 and Text_open_2 then 
						Sprite_open = Text_open_1
						Sprite_open_2 = Text_open_2
					end
				end
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                        	for i=1, 2 do
                                local Panel_props = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_props_"..i)
                                Panel_props:removeAllChildren(true)
                            end
                            local function changeActionCallbackTwo( armatureBack ) 
                            	if armatureBack ~= nil then
                            		armatureBack:removeFromParent(true)
                            	end
                            	local reward = getSceneReward(37)
                            	for i=1, tonumber(reward.show_reward_item_count) do
	                                local scheduler = cc.Director:getInstance():getScheduler()  
	                                local schedulerID = nil  
	                                schedulerID = scheduler:scheduleScriptFunc(function ()
	                                	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
			                                local Panel_props = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_props_"..i)
			                                Panel_props:removeAllChildren(true)
			                                local cell = ResourcesIconCell:createCell()
			                                cell:init(tonumber(reward.show_reward_list[i].prop_type), tonumber(reward.show_reward_list[i].item_value),tonumber(reward.show_reward_list[i].prop_item))
			                                cell:showName(tonumber(reward.show_reward_list[i].prop_item), tonumber(reward.show_reward_list[i].prop_type))
			                                Panel_props:addChild(cell)
			                                cell:setAnchorPoint(0.5,0.5)
			                                cell:setVisible(false)
			                                cell:ignoreAnchorPointForPosition(false)
			                                if i == 1 then
			                                	cell:setPositionX(100)
			                                else
			                                	cell:setPositionX(-100)
			                                end

	                                        -- cell:setPosition(cc.p(Image_box:getPositionX(),Image_box:getPositionY()))
	                                        cell:setScale(0.1)
	                                        cell:setVisible(true)
	                                        local MoveTopoint = cc.p(0, 0)
	                                        local seq = cc.Sequence:create(
	                                        cc.Spawn:create({cc.ScaleTo:create(0.25, 1),cc.MoveTo:create(0.25, MoveTopoint),
	                                            cc.RotateBy:create(0.25, 360)
	                                            }))
	                                        cell:runAction(seq)

	                                        local Text_zuanshi_n = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_zuanshi_n")
											local needgood = zstring.split(dms.string(dms["play_config"], 27, play_config.param),",")
											if tonumber(_ED.three_kingdoms_view.current_npc_pos) >= #needgood then
												Text_zuanshi_n:setString(needgood[#needgood])
											else
												Text_zuanshi_n:setString(needgood[tonumber(_ED.three_kingdoms_view.current_npc_pos)])
											end
											
											Button_open:setVisible(true)
											Button_cancel:setVisible(true)
											Image_zs_icon:setVisible(true)
											Text_zuanshi_n:setVisible(true)
										end
	                                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
	                                end,0.25*(i-1),false)
	                            end
                            end
                            Image_box:setVisible(false)
                            if instance._isBuy == true then
                            	changeActionCallbackTwo()
                            else
                            	if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		                        	Panel_dh:setVisible(false)
		                        	changeActionCallbackTwo()
		                        else
		                            local jsonFile = "sprite/sprite_baoxiang.json"
			                        local atlasFile = "sprite/sprite_baoxiang.atlas"
			                        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "box_open", true, nil)
			                        animation2.animationNameList = {"box_open"}
			                        sp.initArmature(animation2, false)
			                        animation2._invoke = changeActionCallbackTwo
			                        Panel_dh:addChild(animation2)
			                        animation2:setPosition(-Panel_dh:getContentSize().width/2, -Panel_dh:getContentSize().height/2)
			                        animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
			                        csb.animationChangeToAction(animation2, 0, 0, false)
			                   end
		                    end
	                        state_machine.excute("sm_trial_tower_update_info", 0, nil)
                            instance._isBuy = true
                        end 
                    else
                    	Button_open:setVisible(true)
						Button_cancel:setVisible(true)
						Image_zs_icon:setVisible(true)
						Text_zuanshi_n:setVisible(true)
                    end
                end
                -- Image_box:setVisible(true)
                Sprite_open:setVisible(false)
                Sprite_open_2:setVisible(true)
                Button_open:setVisible(false)
                Button_cancel:setVisible(false)
                Image_zs_icon:setVisible(false)
				Text_zuanshi_n:setVisible(false)
                protocol_command.three_kingdoms_launch.param_list = "54".."\r\n"..dms.string(dms["play_config"], 26, play_config.param).."\r\n".."0".."\r\n".."0".."\r\n".."0".."\r\n"..
                _ED.integral_current_index.."\r\n".."".."\r\n".."".."\r\n".."".."\r\n".."0"
                NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                --清除记录
		   	 	cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), "-1")
		    	cc.UserDefault:getInstance():flush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_baoxiang_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_trial_tower_baoxiang_terminal()
end

function SmTrialTowerBaoxiang:updateDraw()
	local root = self.roots[1]

	local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root,"Text_zuanshi_n")
	local needgood = zstring.split(dms.string(dms["play_config"], 27, play_config.param),",")
	if tonumber(_ED.three_kingdoms_view.current_npc_pos) >= #needgood then
		Text_zuanshi_n:setString(needgood[#needgood])
	else
		Text_zuanshi_n:setString(needgood[tonumber(_ED.three_kingdoms_view.current_npc_pos)])
	end
	if _ED.recruit_success_ship_id ~= nil and _ED.recruit_success_ship_id ~= "" then
		app.load("client.packs.hero.SmHeroSynthesisSuccess")
		local obj = SmHeroSynthesisSuccess:new()
		fwin:open(obj,fwin._windows)
	end
end

function SmTrialTowerBaoxiang:init(params)
	self:onInit()
    return self
end

function SmTrialTowerBaoxiang:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_baoxiang.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    
    --继续
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_open"), nil, 
    {
        terminal_name = "sm_trial_tower_baoxiang_the_first_place", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_trial_tower_baoxiang_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()
end

function SmTrialTowerBaoxiang:onEnterTransitionFinish()
    
end


function SmTrialTowerBaoxiang:onExit()
    state_machine.remove("sm_trial_tower_baoxiang_change_page")
	state_machine.remove("sm_trial_tower_baoxiang_open_rank")
end

