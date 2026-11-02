-----------------------------
--装甲猛兽
-----------------------------
RedAlertTimeEquipmentBeast = class("RedAlertTimeEquipmentBeastClass", Window)

local red_alert_time_equipment_beast_window_open_terminal = {
    _name = "red_alert_time_equipment_beast_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeEquipmentBeastClass") then
			fwin:open(RedAlertTimeEquipmentBeast:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_equipment_beast_window_close_terminal = {
    _name = "red_alert_time_equipment_beast_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeEquipmentBeastClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_equipment_beast_window_open_terminal)
state_machine.add(red_alert_time_equipment_beast_window_close_terminal)
state_machine.init()

function RedAlertTimeEquipmentBeast:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
	
	self.one_id = 0
	self.one_number = 0
	self.two_id = 0
	self.two_number = 0

    self.m_times = 0
    self._once_gold = 0
    self._ten_gold = 0
    self._m_type = 0
    self.have_free_times = false
    --load lua file
    app.load("client.red_alert_time.build_up.BuildUpTankProduction")
    -- Initialize red_alert_time_equipment_beast state machine.
    local function init_red_alert_time_equipment_beast_terminal()
    
        -- 抽奖
        local red_alert_time_equipment_beast_lottery_terminal = {
            _name = "red_alert_time_equipment_beast_lottery",
            _init = function (terminal) 
              
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local m_type = params._datas._type 
                if tonumber(m_type) > 0 and instance.have_free_times == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end
                instance._m_type = m_type
                local activity_add_state = zstring.split(instance._activity_type.activity_add_state,",")
                local shop_of_gold = 0
                if m_type == 0 then
                    shop_of_gold = self._once_gold
                    if tonumber(activity_add_state[4]) < tonumber(activity_add_state[5]) then
                        instance:costBeastLottery(0)
                        return
                    end
                else
                    shop_of_gold = self._ten_gold
                end
                local tip = ConfirmTip:new()
                tip:init(instance, instance.costBeastLottery, string.format(activity_str_tip[64], shop_of_gold))
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 组装
        local red_alert_time_equipment_beast_assemble_terminal = {
            _name = "red_alert_time_equipment_beast_assemble",
            _init = function (terminal) 
                  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local m_type = params._datas._type 
				local index = params._datas.index 
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							instance:onUpdateDraw()
							checkRewardObtainDraw()
                            checkPlayEffect(69)
						end
					end
				end		
				local count = 0

				if tonumber(index) == 1 then
					local datas = zstring.split(self._activity_type.activity_data[tonumber(index)][1].achieve_other_info,",")
					count = math.floor(self.one_number / tonumber(datas[3]))
				else
					local datas = zstring.split(self._activity_type.activity_data[tonumber(index)][1].achieve_other_info,",")
					count = math.floor(self.two_number / tonumber(datas[3]))
				end
				-- debug.print_r(self.activityInfo[1])
				protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n"..(tonumber(index)-1).."\r\n".."0".."\r\n"..m_type.."\r\n"..count
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 查看
        local red_alert_time_equipment_beast_infor_terminal = {
            _name = "red_alert_time_equipment_beast_infor",
            _init = function (terminal) 
                  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index
                for i,v in pairs(self._activity_type.activity_data) do
                    if i == index then
                        local datas = zstring.split(v[1].achieve_reward,",")
                        local info = {}
                        info.tank_id = datas[1]
                        state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false, nil})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_equipment_beast_lottery_terminal)
        state_machine.add(red_alert_time_equipment_beast_assemble_terminal)
        state_machine.add(red_alert_time_equipment_beast_infor_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_equipment_beast state machine.
    init_red_alert_time_equipment_beast_terminal()
end

function RedAlertTimeEquipmentBeast:costBeastLottery( sure_number )
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                local isDrawAction = false
                for i,v in pairs(_ED.user_prop) do
                    if tonumber(v.user_prop_template) == self.one_id then
                        if self.one_number ~= tonumber(v.prop_number) then
                            self:platGetAction(1)
                            isDrawAction = true
                        end
                    end
                    if tonumber(v.user_prop_template) == self.two_id then
                        if self.two_number ~= tonumber(v.prop_number) then
                            self:platGetAction(2)
                            isDrawAction = true
                        end
                    end
                end
                self:onUpdateDraw()
                -- for k,v in pairs(_ED.show_reward_list_group_ex) do
                --     for k1,v1 in pairs(v.show_reward_list) do
                --         if tonumber(v1.prop_item) == self.one_id
                --             or tonumber(v1.prop_item) == self.two_id
                --             then
                --             table.remove(v.show_reward_list,k1)
                --         end
                --     end
                -- end
                checkRewardObtainDraw()
            end
        end
    end     
    if sure_number == 0 then
        protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..self._m_type
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
    end
end

function RedAlertTimeEquipmentBeast:platGetAction(index)
    local root = self.roots[1]
    local Panel_top_box = ccui.Helper:seekWidgetByName(root,"Panel_top_box")
    local Panel_equipment_get_props = ccui.Helper:seekWidgetByName(root,"Panel_equipment_get_props_"..index)

    local posX = Panel_equipment_get_props:getPositionX()
    local posY = Panel_equipment_get_props:getPositionY()
    local offsetY = 80

    local other_info = zstring.split(self._activity_type.activity_data[index][1].achieve_other_info,",")
    local prop_id = other_info[1]
    local pic_index = zstring.split(dms.string(dms["prop_mould"], prop_id, prop_mould.pic_index), ",")
    local sprite = cc.Sprite:create(string.format(config_res.images.ui.props.props, pic_index[1]))
    Panel_top_box:addChild(sprite)

    sprite:setAnchorPoint(cc.p(0, 0))
    sprite:setScale(0.44)
    sprite:setPosition(cc.p(posX, posY + offsetY))

    local function callBack()
        sprite:removeFromParent(true)
        local armature = ccs.Armature:create("effice_recruit_get_light")
        draw.initArmature(armature, nil, -1, 0, 1)
        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        Panel_equipment_get_props:addChild(armature)
        armature:setPosition(cc.p(Panel_equipment_get_props:getContentSize().width/2, Panel_equipment_get_props:getContentSize().height/2))
        armature:getAnimation():playWithIndex(0)
    end

    sprite:runAction(cc.Sequence:create(
        cc.MoveTo:create(0.5, cc.p(posX, posY)),
        cc.CallFunc:create(callBack)))
end


function RedAlertTimeEquipmentBeast:onUpdateDraw()
    local root = self.roots[1]
	-- debug.print_r(self._activity_type)
    -- 描述
    local Text_equipment_get_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_infor_p_1")
    local Text_equipment_get_share_tit = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_share_tit")
    Text_equipment_get_share_tit:setString(self._activity_type.activity_title)
    Text_equipment_get_infor_p_1:setString("")
	Text_equipment_get_infor_p_1:removeAllChildren(true)
	local datas = dms.string(dms["activity_rule"], tonumber(self._activity_type.activity_type), activity_rule.content)
	local texts_info = zstring.split(datas, "/r/n")
	local index = 0
	for i=1,#texts_info do
		local _richText2 = ccui.RichText:create()
		_richText2:ignoreContentAdaptWithSize(false)
		_richText2:setContentSize(cc.size(Text_equipment_get_infor_p_1:getContentSize().width, 0))
		_richText2:setAnchorPoint(cc.p(0, 0))
		local char_str = texts_info[i]
		local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		char_str, 
		cc.c3b(189, 206, 224),
		cc.c3b(189, 206, 224),
		0, 
		0, 
		config_res.font.font_name, 
		20,
		chat_rich_text_color)
		_richText2:formatTextExt()
		local rsize = _richText2:getContentSize()
		_richText2:setPositionY(Text_equipment_get_infor_p_1:getContentSize().height-index)
		-- _richText2:setPositionX(400 - 0.5 * fontSize)
		Text_equipment_get_infor_p_1:addChild(_richText2)
		index = index + rsize.height
    end
	
    -- 时间
    local Text_equipment_get_time = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_time")
    Text_equipment_get_time:removeAllChildren(true)
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
    local startTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[1] / 1000))
    local endTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[2] / 1000-1))
    
    local intervalTime = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
    local _richText1 = ccui.RichText:create()
    _richText1:ignoreContentAdaptWithSize(false)
    local color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
    local re1 =ccui.RichElementText:create(1, color,255, startTime.."~"..endTime, config_res.font.font_name,20)
    _richText1:pushBackElement(re1)
    if intervalTime > 1 then
        local color2 = cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3])
        local re2 =ccui.RichElementText:create(1, color2,255, string.format(activity_str_tip[41],math.floor(intervalTime)), config_res.font.font_name,20)
        _richText1:pushBackElement(re2)
        _richText1:setContentSize(cc.size(Text_equipment_get_time:getContentSize().width,20))
        _richText1:setPositionX(Text_equipment_get_time:getContentSize().width/2)
        _richText1:setPositionY(Text_equipment_get_time:getContentSize().height/2)
        Text_equipment_get_time:addChild(_richText1)
    else
        _richText1:setAnchorPoint(0.5,0.5)
        _richText1:setContentSize(cc.size(Text_equipment_get_time:getContentSize().width,20))
        _richText1:setPositionX(Text_equipment_get_time:getContentSize().width/2)
        _richText1:setPositionY(Text_equipment_get_time:getContentSize().height/2)
        Text_equipment_get_time:addChild(_richText1)
        local time_int = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
        time_int:setName("time_int")
        time_int:setAnchorPoint(cc.p(0, 0.5))
        time_int:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        time_int:setPositionX(Text_equipment_get_time:getContentSize().width/2)
        time_int:setPositionY(Text_equipment_get_time:getContentSize().height/2)
        time_int:setTag(100)
        Text_equipment_get_time:addChild(time_int)
    end 
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    -- 抽奖
    local Button_equipment_get_free = ccui.Helper:seekWidgetByName(root,"Button_equipment_get_free")
    local Text_equipment_get_free_time = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_free_time")
    local Panel_equipment_get_one = ccui.Helper:seekWidgetByName(root,"Panel_equipment_get_one")
    local Text_equipment_get_one_gold_n = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_one_gold_n")
    local Text_equipment_get_ten_gold_n = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_ten_gold_n")
    local Text_equipment_get_ten_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_ten_old_gold_n")
    Button_equipment_get_free:setVisible(false)
    Text_equipment_get_free_time:setVisible(false)
    Panel_equipment_get_one:setVisible(false)
    if tonumber(activity_add_state[4]) >= tonumber(activity_add_state[5]) then
        Panel_equipment_get_one:setVisible(true)
        self.have_free_times = false
    else
        Button_equipment_get_free:setVisible(true)
        Text_equipment_get_free_time:setVisible(true)
        self.have_free_times = true
    end
    self._once_gold = tonumber(activity_add_state[6])
    self._ten_gold = math.ceil(self._once_gold*10*tonumber(activity_add_state[7]))
    Text_equipment_get_one_gold_n:setString(self._once_gold)
    Text_equipment_get_ten_gold_n:setString(self._ten_gold)
    Text_equipment_get_ten_old_gold_n:setString(activity_add_state[6]*10)
    -- 折扣
    local Text_get_ten_discount_n = ccui.Helper:seekWidgetByName(root,"Text_get_ten_discount_n")
    local curr = math.floor(10*tonumber(activity_add_state[7]))
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr = (10 - curr) * 10
    end
    --local discounts = string.gsub(activity_str_tip[22], "x", curr)
    local discounts = string.format(activity_str_tip[22], ""..curr)
    Text_get_ten_discount_n:setString(discounts)

	for i,v in pairs(self._activity_type.activity_data) do
        local Panel_equipment_get_point = ccui.Helper:seekWidgetByName(root,"Panel_equipment_get_point_"..i)
        local Text_equipment_get_name = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_name_"..i)
        local Panel_equipment_get_tank = ccui.Helper:seekWidgetByName(root,"Panel_equipment_get_tank_"..i)
        local Panel_equipment_get_props = ccui.Helper:seekWidgetByName(root,"Panel_equipment_get_props_"..i)
        local Text_equipment_get_props_name = ccui.Helper:seekWidgetByName(root,"Text_equipment_get_props_name_"..i)
		Text_equipment_get_props_name:removeAllChildren(true)
        local Button_equipment_get = ccui.Helper:seekWidgetByName(root,"Button_equipment_get_"..i)
        if Panel_equipment_get_point ~= nil then
            Panel_equipment_get_point:removeBackGroundImage()
            Panel_equipment_get_tank:removeBackGroundImage()
            Panel_equipment_get_props:removeAllChildren(true)

            local datas = zstring.split(v[1].achieve_reward,",")
            local tank_data = dms.element(dms["ship_mould"], datas[1])
            -- 攻击类型
            local sign_msg = dms.atoi(tank_data, ship_mould.sign_msg)
            Panel_equipment_get_point:setBackGroundImage(string.format(config_res.images.ui.icon.icon, sign_msg + 114))
            -- 名字
            local captain_name = dms.atos(tank_data, ship_mould.captain_name)
            Text_equipment_get_name:setString(captain_name)
            local quality = dms.atoi(tank_data, ship_mould.ship_type)
            Text_equipment_get_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

            -- icon
            local head_icon = dms.atoi(tank_data, ship_mould.All_icon)
            Panel_equipment_get_tank:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_icon))
            -- 消耗icon
            local other_info = zstring.split(v[1].achieve_other_info,",")
            local cell = state_machine.excute("props_icon_create_cell",0,{1,3,other_info[1],1})
            Panel_equipment_get_props:addChild(cell) 
            -- 需要数量
			local mould_datas = zstring.split(v[1].achieve_other_info,",")
			local mould_id = tonumber(mould_datas[1])
			local numbers = 0
			for i,v in pairs(_ED.user_prop) do
				if tonumber(v.user_prop_template) == mould_id then
					numbers = tonumber(v.prop_number)
				end
			end
			if i == 1 then
				self.one_id = mould_id
				self.one_number = numbers
			else
				self.two_id = mould_id
				self.two_number = numbers
			end
			
            -- local complete_count = zstring.split(numbers,"/")
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false) 
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, numbers, "fonts/simhei.ttf",20)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..other_info[3], "fonts/simhei.ttf",20)
            _richText:pushBackElement(re2)
            _richText:setPosition(cc.p(Text_equipment_get_props_name:getContentSize().width/2,Text_equipment_get_props_name:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_equipment_get_props_name:getContentSize().width,20))
            Text_equipment_get_props_name:addChild(_richText)
            if tonumber(numbers) >= tonumber(other_info[3]) then
                Button_equipment_get:setBright(true)
                Button_equipment_get:setTouchEnabled(true)
            else
                Button_equipment_get:setBright(false)
                Button_equipment_get:setTouchEnabled(false)
            end
        end
    end
end

function RedAlertTimeEquipmentBeast:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_equipment_get_time"):getChildByTag(100) ~= nil then
            if self.accept_the_prize == false then
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_equipment_get_time"):getChildByTag(100):setString(string.format(activity_str_tip[75],getRedAlertTimeFormat(self.m_times)))
            else
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_equipment_get_time"):getChildByTag(100):setString(string.format(activity_str_tip[62],getRedAlertTimeFormat(self.m_times)))
            end
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_equipment_beast_window_close")
            -- state_machine.excute("red_alert_time_equipment_beast_window_close",0,self._activity_type.activity_type)
        end
    end
end

function RedAlertTimeEquipmentBeast:onEnterTransitionFinish()

end

function RedAlertTimeEquipmentBeast:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.equipment_get)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_get_close"), nil, 
    {
        terminal_name = "red_alert_time_equipment_beast_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    for i=1,2 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_get_"..i), nil, 
        {
            terminal_name = "red_alert_time_equipment_beast_assemble", 
            terminal_state = 0,
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
			_type = 2,
        }, nil, 1)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equipment_get_tank_"..i), nil, 
        {
            terminal_name = "red_alert_time_equipment_beast_infor", 
            terminal_state = 0,
            touch_black = true,
            index = i,
        }, nil, 1)
    end

    -- 单次抽取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_get_one"), nil, 
    {
        terminal_name = "red_alert_time_equipment_beast_lottery", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 0,
    }, nil, 1)

    -- 免费抽取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_get_free"), nil, 
    {
        terminal_name = "red_alert_time_equipment_beast_lottery", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 0,
    }, nil, 1)

    -- 抽十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_get_ten"), nil, 
    {
        terminal_name = "red_alert_time_equipment_beast_lottery", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 1,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function RedAlertTimeEquipmentBeast:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeEquipmentBeast:onExit()
    state_machine.remove("red_alert_time_equipment_beast_lottery")
    state_machine.remove("red_alert_time_equipment_beast_assemble")
    state_machine.remove("red_alert_time_equipment_beast_infor")
end
