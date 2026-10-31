
EggMachineWindow = class("EggMachineWindowClass", Window)

local egg_machine_window_open_terminal = {
	_name = "egg_machine_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("EggMachineWindowClass") == nil then
			fwin:open(EggMachineWindow:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local egg_machine_window_close_terminal = {
	_name = "egg_machine_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggMachineWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_machine_window_open_terminal)
state_machine.add(egg_machine_window_close_terminal)
state_machine.init()

function EggMachineWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self._text_time = nil
	self._tick_time = 0
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.egg_machine.EggMachinePreViewWindow")
    app.load("client.activity.egg_machine.EggMachineReward")

    local function init_egg_machine_window_terminal()
        local egg_machine_window_update_draw_terminal = {
            _name = "egg_machine_window_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	            	instance:drawMoney()
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local egg_machine_window_recruiting_terminal = {
            _name = "egg_machine_window_recruiting",
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
                state_machine.lock("egg_machine_window_recruiting")
                -- local info = zstring.split(activity.need_recharge_count, ",")[index]
                -- local cost = tonumber(zstring.split(info, "-")[3])
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                            local function changeActionCallbackOne( armatur )
                                if armatur then
                                    state_machine.excute("egg_machine_reward_open", 0, {index, getSceneReward(7)})
                                    armatur._invoke = nil
                                    csb.animationChangeToAction(armatur, 0, 0, false)
                                else
                                    state_machine.unlock("egg_machine_window_recruiting")
                                end
                            end
                            instance.machineAmateur._invoke = changeActionCallbackOne
                            instance.machineAmateur:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                            csb.animationChangeToAction(instance.machineAmateur, 1, 1, false)

                            state_machine.excute("egg_machine_window_update_draw", 0, "")
                            _ED.show_reward_list_group_ex = {}
                        end
                    else
                        state_machine.unlock("egg_machine_window_recruiting")
                    end
                end
                protocol_command.get_activity_reward.param_list = activity.activity_id.."\r\n"..index.."\r\n0"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(egg_machine_window_update_draw_terminal)
        state_machine.add(egg_machine_window_recruiting_terminal)
        state_machine.init()
    end
    init_egg_machine_window_terminal()
end

function EggMachineWindow:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.active_activity[154]
    local activityParam = json.decode(activity_info.activity_params)

    --背景动画
    local Panel_bg_effect = ccui.Helper:seekWidgetByName(root,"Panel_bg_effect")
    local jsonFile = "images/ui/effice/sprite_niudanjibj/sprite_niudanjibj.json"
    local atlasFile = "images/ui/effice/sprite_niudanjibj/sprite_niudanjibj.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_bg_effect:addChild(animation)

    --扭蛋机动画
    local Panel_darw_effect = ccui.Helper:seekWidgetByName(root,"Panel_darw_effect")
    local jsonFile = "images/ui/effice/sprite_niudanji/sprite_niudanji.json"
    local atlasFile = "images/ui/effice/sprite_niudanji/sprite_niudanji.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
    animation.animationNameList = {"animation", "animation2"}
    sp.initArmature(animation, false)
    -- animation._invoke = changeActionCallbackOne
    -- animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    -- animation:setPosition(cc.p(Panel_darw_effect:getContentSize().width/2, Panel_darw_effect:getContentSize().height/2))
    csb.animationChangeToAction(animation, 0, 0, false)
    self.machineAmateur = animation
    Panel_darw_effect:addChild(animation)

    --开启条件
    local Text_chat_infor = ccui.Helper:seekWidgetByName(root,"Text_draw_condition")
    -- Text_draw_condition:setString(string.format(tipStringInfo_egg_machine[1], zstring.tonumber(activityParam.lv), zstring.tonumber(activityParam.vipLv)))
    local max_width = 0
    Text_chat_infor:setString("")
    Text_chat_infor:removeAllChildren(true)
    local char_str = tipStringInfo_egg_machine[1]
    char_str = string.gsub(char_str, "!x@", activityParam.lv .. "")
    char_str = string.gsub(char_str, "!y@", activityParam.vipLv .. "")
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_chat_infor:getContentSize().width
    if richTextWidth and richTextWidth == 0 then
        richTextWidth = Text_chat_infor:getFontSize() * 50
    end

    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local fontsName = Text_chat_infor:getFontName()

    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    cc.c3b(255, 255, 255),
    cc.c3b(255, 255, 255),
    0, 
    0, 
    fontsName, 
    Text_chat_infor:getFontSize(),
    chat_rich_text_color)

    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionX(-_richText2:getContentSize().width / 2)
    _richText2:setPositionY(Text_chat_infor:getContentSize().height / 2 + Text_chat_infor:getFontSize() - 10)
    Text_chat_infor:addChild(_richText2)

    -- Text_chat_infor:setVisible((vip ~= 0 or fight ~= 0))


    --可能开出
    local ListView_reward = ccui.Helper:seekWidgetByName(root,"ListView_reward")
    ListView_reward:removeAllItems()
    local displayParams = zstring.splits(activityParam.displayParams, "~", ",")
    for i, reward in ipairs(displayParams) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, 0, tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, 0, tonumber(reward[2]),nil,nil,true,true,1)
        end
        ListView_reward:addChild(cell)
    end
    ListView_reward:requestRefreshView()

    --  消耗钻石
    local Text_darw_one_gem_n = ccui.Helper:seekWidgetByName(root,"Text_darw_one_gem_n")
    local Text_darw_ten_gem_n = ccui.Helper:seekWidgetByName(root,"Text_darw_ten_gem_n")
    Text_darw_one_gem_n:setString(activityParam.singleDraw)
    Text_darw_ten_gem_n:setString(activityParam.fiveTimesDraw)

    self:drawMoney()
    self._text_time = ccui.Helper:seekWidgetByName(root,"Text_egg_time_n")
	self._tick_time = zstring.tonumber(activity_info.end_time)/1000 - (os.time() + _ED.time_add_or_sub)
	self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
end

function EggMachineWindow:drawMoney()
    local root = self.roots[1]
    local activity_info = _ED.active_activity[154]
    local activityParam = json.decode(activity_info.activity_params)
    local Text_gem_surplus_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_gem_surplus_n")
    local user_gold = _ED.user_info.user_gold
    if tonumber( user_gold)> 1000000 then
        Text_gem_surplus_n:setString(math.floor(user_gold / 1000) .. string_equiprety_name[40])
    else
        Text_gem_surplus_n:setString(user_gold)
    end

    --武器扭蛋兑换卷
    local lvs = zstring.tonumber(dms.string(dms["shop_config"], 23, shop_config.param))
    if lvs > 0 then
        local needPropNumber = 0
        if fundPropWidthId(lvs) then
            needPropNumber = zstring.tonumber(fundPropWidthId(lvs).prop_number)
        end
        local Image_darw_one_gem = ccui.Helper:seekWidgetByName(root, "Image_darw_one_gem")
        local Image_darw_ten_gem = ccui.Helper:seekWidgetByName(root, "Image_darw_ten_gem")

        local Image_xs_one_1 = ccui.Helper:seekWidgetByName(root, "Image_xs_one_1")
        local Image_xs_ten_2 = ccui.Helper:seekWidgetByName(root, "Image_xs_ten_2")

        local Text_darw_one_gem_n = ccui.Helper:seekWidgetByName(root,"Text_darw_one_gem_n")
        local Text_darw_ten_gem_n = ccui.Helper:seekWidgetByName(root,"Text_darw_ten_gem_n")
        
        
        if needPropNumber >= 1 then
            Image_darw_one_gem:setVisible(false)
            Image_xs_one_1:setVisible(true)
            Text_darw_one_gem_n:setString("1")
        else
            Image_darw_one_gem:setVisible(true)
            Image_xs_one_1:setVisible(false)
            Text_darw_one_gem_n:setString(activityParam.singleDraw)
        end
        if needPropNumber >= 5 then
            Image_darw_ten_gem:setVisible(false)
            Image_xs_ten_2:setVisible(true)
            Text_darw_ten_gem_n:setString("5")
        else
            Image_darw_ten_gem:setVisible(true)
            Image_xs_ten_2:setVisible(false)
            Text_darw_ten_gem_n:setString(activityParam.fiveTimesDraw)
        end
    end
end

function EggMachineWindow:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
    end
end

function EggMachineWindow:init(params)
	self:onInit()
    return self
end

function EggMachineWindow:onInit()
    local csbItem = csb.createNode("activity/wonderful/egg_machine.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    -- local action = csb.createTimeline("activity/wonderful/sm_vip_chouka.csb")
   	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- csbItem:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wonderful_back"), nil, 
    {
        terminal_name = "egg_machine_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_infor"), nil, 
    {
        terminal_name = "egg_machine_preview_preview_window",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_egg_darw_one"), nil, 
    {
        terminal_name = "egg_machine_window_recruiting",
        terminal_state = 0,
        touch_black = true,
        index = 0,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_egg_darw_ten"), nil, 
    {
        terminal_name = "egg_machine_window_recruiting",
        terminal_state = 0,
        touch_black = true,
        index = 1,
    },
    nil,1)

    self:onUpdateDraw()
end

function EggMachineWindow:onEnterTransitionFinish()
end

function EggMachineWindow:onExit()
	state_machine.remove("egg_machine_window_update_draw")
	state_machine.remove("egg_machine_window_recruiting")
end

