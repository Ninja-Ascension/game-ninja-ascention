
EggMachineReward = class("EggMachineRewardClass", Window)

local egg_machine_reward_open_terminal = {
	_name = "egg_machine_reward_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("EggMachineRewardClass") == nil then
			fwin:open(EggMachineReward:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local egg_machine_reward_close_terminal = {
	_name = "egg_machine_reward_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggMachineRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_machine_reward_open_terminal)
state_machine.add(egg_machine_reward_close_terminal)
state_machine.init()

function EggMachineReward:ctor()
	self.super:ctor()
	self.roots = {}
	self._text_time = nil
	self._tick_time = 0
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.egg_machine.EggMachineWindow")

    local function init_egg_machine_reward_terminal()
        local egg_machine_reward_recruiting_again_terminal = {
            _name = "egg_machine_reward_recruiting_again",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local activity = _ED.active_activity[154]
                if activity == nil then
                    return
                end
                state_machine.lock("egg_machine_reward_recruiting_again")
                -- local info = zstring.split(activity.need_recharge_count, ",")[index]
                -- local cost = tonumber(zstring.split(info, "-")[3])
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                            instance._rewardInfo = getSceneReward(7)
                            instance:onUpdateDraw()
                            state_machine.excute("egg_machine_window_update_draw", 0, "")
                            _ED.show_reward_list_group_ex = {}
                        end
                    end
                end
                protocol_command.get_activity_reward.param_list = activity.activity_id.."\r\n"..index.."\r\n0"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local egg_machine_reward_skip_animation_terminal = {
            _name = "egg_machine_reward_skip_animation",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:skipAnimation()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(egg_machine_reward_recruiting_again_terminal)
        state_machine.add(egg_machine_reward_skip_animation_terminal)
        state_machine.init()
    end
    init_egg_machine_reward_terminal()
end

function EggMachineReward:onUpdateDraw()
    local root = self.roots[1]

    local Button_ten_again = ccui.Helper:seekWidgetByName(root,"Button_ten_again")
    local Button_one_again = ccui.Helper:seekWidgetByName(root,"Button_one_again")
    Button_ten_again:setTouchEnabled(false)
    Button_one_again:setTouchEnabled(false)


    local activity_info = _ED.active_activity[154]
    local activityParam = json.decode(activity_info.activity_params)

    for i=1,5 do
        local Panel_five_icon = ccui.Helper:seekWidgetByName(root,"Panel_five_icon_" .. i)
        Panel_five_icon:removeAllChildren(true)
    end
    ccui.Helper:seekWidgetByName(root,"Panel_15"):setVisible(false)
    local Panel_egg_open = ccui.Helper:seekWidgetByName(root,"Panel_egg_open")
    local Label_36610 = ccui.Helper:seekWidgetByName(root,"Label_36610")
    local needCost = self._index == 0 and activityParam.singleDraw or activityParam.fiveTimesDraw
    Label_36610:setString(needCost)

    --添加奖励
    local function addReward( num )
        local index = self._index == 0 and 1 or num
        local reward = self._rewardInfo.show_reward_list[index]
        if not reward then
            -- ccui.Helper:seekWidgetByName(root,"Panel_15"):setVisible(true)
            return
        end
        local Panel_five_icon = ccui.Helper:seekWidgetByName(root,"Panel_five_icon_" .. num)
        if self._index == 0 then
            Panel_five_icon = nil
            Panel_five_icon = ccui.Helper:seekWidgetByName(root,"Panel_five_icon_3")
        end
        Panel_five_icon:removeAllChildren(true)
        local rewardType = zstring.tonumber(reward.prop_type)
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            -- if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
            --     table.shipStar = tonumber(reward[4])
            -- end
            cell:init(rewardType, tonumber(reward.item_value), tonumber(reward.prop_item),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward.item_value), tonumber(reward.prop_item),nil,nil,true,true,1)
        end
        local Image_15 = ccui.Helper:seekWidgetByName(root,"Image_15")
        Panel_five_icon:addChild(cell)
        -- cell:setPosition(cc.p(Image_15:getPositionX(), Image_15:getPositionY()))
        -- cell:setScale(0.1)
        -- cell:setRotation(180)
        -- local seq = cc.Sequence:create(
        --         cc.Spawn:create(cc.ScaleTo:create(0.15, 1),
        --         cc.RotateTo:create(0.15, 360),
        --         cc.MoveTo:create(0.15, cc.p(0, 0))),
        --         cc.CallFunc:create(addReward)
        --     )
        --     cell:runAction(seq)
    end

    local jsonFile = "images/ui/effice/sprite_niudanjicq/sprite_niudanjicq.json"
    local atlasFile = "images/ui/effice/sprite_niudanjicq/sprite_niudanjicq.atlas"
    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation2.animationNameList = {"animation", "animation2"}
    sp.initArmature(animation2, false)
    -- animation2._invoke = changeActionCallbackOne
    animation2:setPosition(cc.p(0, 0))
    Panel_egg_open:addChild(animation2)
    animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation2, self._index, self._index, false)

    animation2:setFrameEventCallFunc(function (bone,evt,originFrameIndex,currentFrameIndex)
        if nil == evt then
            return
        end

        if evt == "reward" then
            addReward(1)
        elseif evt == "reward2" then
            addReward(2)
        elseif evt == "reward3" then
            addReward(3)
        elseif evt == "reward4" then
            addReward(4)
        elseif evt == "reward5" then
            addReward(5)
            ccui.Helper:seekWidgetByName(root,"Panel_15"):setVisible(true)
            Button_ten_again:setTouchEnabled(true)
            Button_one_again:setTouchEnabled(true)
            state_machine.unlock("egg_machine_reward_recruiting_again")
            state_machine.unlock("egg_machine_window_recruiting")
        elseif evt == "reward6" then
            addReward(3)
            ccui.Helper:seekWidgetByName(root,"Panel_15"):setVisible(true)
            Button_ten_again:setTouchEnabled(true)
            Button_one_again:setTouchEnabled(true)
            state_machine.unlock("egg_machine_reward_recruiting_again")
            state_machine.unlock("egg_machine_window_recruiting")
        end
        
    end)

    local count = 1
    
    local Panel_consume_icon = ccui.Helper:seekWidgetByName(root, "Panel_consume_icon")
    Panel_consume_icon:setScale(1)

    Panel_consume_icon:setBackGroundImage("images/ui/icon/zuanshi.png")

    local lvs = zstring.tonumber(dms.string(dms["shop_config"], 23, shop_config.param))
    if lvs > 0 then
        local needPropNumber = 0
        if fundPropWidthId(lvs) then
            needPropNumber = zstring.tonumber(fundPropWidthId(lvs).prop_number)
        end
        local nNumber = 0
        if zstring.tonumber(self._index) == 0 then
            nNumber = 1
        else
            nNumber = 5
        end
        if needPropNumber >=nNumber then
            ccui.Helper:seekWidgetByName(root, "Label_36610"):setString(nNumber)
            local picIndex = dms.int(dms["prop_mould"], lvs, prop_mould.pic_index)          -- 物品图标索引
            Panel_consume_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
            Panel_consume_icon:setScale(0.6)
        end
   end

end

function EggMachineReward:skipAnimation()
    local root = self.roots[1]
    local Panel_egg_open = ccui.Helper:seekWidgetByName(root,"Panel_egg_open")
    Panel_egg_open:removeAllChildren(true)

    for i=1,5 do
        local Panel_five_icon = ccui.Helper:seekWidgetByName(root,"Panel_five_icon_" .. i)
        Panel_five_icon:removeAllChildren(true)
    end

    --添加奖励
    local function addReward( num )
        local index = self._index == 0 and 1 or num
        local reward = self._rewardInfo.show_reward_list[index]
        if not reward then
            return
        end
        local Panel_five_icon = ccui.Helper:seekWidgetByName(root,"Panel_five_icon_" .. num)
        if self._index == 0 then
            Panel_five_icon = nil
            Panel_five_icon = ccui.Helper:seekWidgetByName(root,"Panel_five_icon_3")
        end
        Panel_five_icon:removeAllChildren(true)
        local rewardType = zstring.tonumber(reward.prop_type)
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            cell:init(rewardType, tonumber(reward.item_value), tonumber(reward.prop_item),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward.item_value), tonumber(reward.prop_item),nil,nil,true,true,1)
        end
        Panel_five_icon:addChild(cell)
    end

    for i = 1, 5 do
        addReward(i)
    end

    ccui.Helper:seekWidgetByName(root,"Panel_15"):setVisible(true)
    ccui.Helper:seekWidgetByName(root,"Button_ten_again"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root,"Button_one_again"):setTouchEnabled(true)
    state_machine.unlock("egg_machine_reward_recruiting_again")
    state_machine.unlock("egg_machine_window_recruiting")
end

function EggMachineReward:init(params)
    self._index = params[1]
    self._rewardInfo = params[2]
	self:onInit()
    return self
end

function EggMachineReward:onInit()
    local csbItem = csb.createNode("activity/wonderful/egg_machine_get_five.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    -- local action = csb.createTimeline("activity/wonderful/sm_vip_chouka.csb")
   	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- csbItem:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ten_again"), nil, 
    {
        terminal_name = "egg_machine_reward_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_one_again"), nil, 
    {
        terminal_name = "egg_machine_reward_recruiting_again",
        terminal_state = 0,
        touch_black = true,
        index = self._index,
    },
    nil,1)

    self.Image_5_bg = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_5_bg"), nil, 
    {
        terminal_name = "egg_machine_reward_skip_animation",
        terminal_state = 0,
    },
    nil, 0)
    self.Image_5_bg:setTouchEnabled(true)
    

    ccui.Helper:seekWidgetByName(root,"Panel_15"):setVisible(false)

    self:onUpdateDraw()
end

function EggMachineReward:onEnterTransitionFinish()
end

function EggMachineReward:onExit()
	state_machine.remove("egg_machine_reward_update_draw")
	state_machine.remove("egg_machine_reward_recruiting")
end

