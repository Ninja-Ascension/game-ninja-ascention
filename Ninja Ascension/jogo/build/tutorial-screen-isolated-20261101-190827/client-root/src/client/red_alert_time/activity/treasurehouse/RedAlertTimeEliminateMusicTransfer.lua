--------------------------------------------------------------------------------------------------------------
--  说明：消消乐界面1
--------------------------------------------------------------------------------------------------------------
RedAlertTimeEliminateMusicTransfer = class("RedAlertTimeEliminateMusicTransferClass", Window)

--打开界面
local red_alert_time_eliminate_music_transfer_open_terminal = {
	_name = "red_alert_time_eliminate_music_transfer_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeEliminateMusicTransferClass") == nil then
    		fwin:open(RedAlertTimeEliminateMusicTransfer:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_eliminate_music_transfer_close_terminal = {
	_name = "red_alert_time_eliminate_music_transfer_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeEliminateMusicTransferClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_eliminate_music_transfer_open_terminal)
state_machine.add(red_alert_time_eliminate_music_transfer_close_terminal)
state_machine.init()

function RedAlertTimeEliminateMusicTransfer:ctor()
	self.super:ctor()
	self.roots = {}
    self.m_times = 0
    self._activity_type = nil
    -- self.choosePos = {
    --     cellType = 0,--类型
    --     index = 0,--下标
    --     x = 0,
    --     y = 0,--坐标
    -- }
    self.choosePos = nil --当前点击图标
    --self.ChooseImage = nil --当前选择的选择框
    self.allIconArry = {} -- 所有的图标
    self.clearIconArry = {}--待消除表
    self.clearAllImage = {}-- 待消除的选择框
    self.laveIconArry = {} --剩下的图标表
    self.IconHeight = nil
    self.newIconPanel = nil
    self.need_gold = 0
    self.free = false
    self.m_reset_times = 0
    self.m_times = 0
    self.text_reset_times = nil
    self.text_m_times = nil

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeEliminateMusicRewardLook")
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_eliminate_music_reward_look_cell")
	
    local function init_red_alert_time_eliminate_music_transfer_terminal()
        local red_alert_time_eliminate_music_transfer_show_terminal = {
            _name = "red_alert_time_eliminate_music_transfer_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_eliminate_music_transfer_hide_terminal = {
            _name = "red_alert_time_eliminate_music_transfer_hide",
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

        -- 规则
        local red_alert_time_eliminate_music_rule_open_terminal = {
            _name = "red_alert_time_eliminate_music_rule_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,98)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 确认消除
        local red_alert_time_eliminate_music_ok_terminal = {
            _name = "red_alert_time_eliminate_music_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.choosePos == nil then
                    TipDlg.drawTextDailog(activity_str_tip[112])
                    return
                end
                if instance.free == true then
                    state_machine.excute("red_alert_time_eliminate_music_protocol",0,"")
                else
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {instance.need_gold}, m_type = 28}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择一个
        local red_alert_time_eliminate_music_choose_one_terminal = {
            _name = "red_alert_time_eliminate_music_choose_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                instance.choosePos = self.allIconArry[index]
                instance:getAllWillClear()
                -- instance.ChooseImage:setVisible(true)
                -- instance.ChooseImage:setAnchorPoint(cc.p(0.5 ,0.5))
                -- instance.ChooseImage:setPosition(cc.p(instance.choosePos:getPositionX(), instance.choosePos:getPositionY()))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --奖励预览
        local red_alert_time_eliminate_music_reward_show_terminal = {
            _name = "red_alert_time_eliminate_music_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local activity_add_state_arry = zstring.split(instance._activity_type.activity_add_state,"!")
                local activity_add_state = zstring.split(activity_add_state_arry[2],"|")
                local dropGroup = 0
                local dropGroup2 = 0
                local data = nil
                local data2 = nil
                local name = nil 
                local name2 = nil
                if index == 1 then
                    data = zstring.split(activity_add_state[1],",")
                    data2 = zstring.split(activity_add_state[4],",") 
                elseif index == 2 then
                    data = zstring.split(activity_add_state[2],",")
                else
                    data = zstring.split(activity_add_state[3],",")
                    data2 = zstring.split(activity_add_state[5],",")
                end
                dropGroup = tonumber(data[3])
                local reworld = zstring.split(dms.string(dms["scene_reward"], dropGroup, scene_reward.reward_items),"|")
                name = dms.string(dms["prop_mould"] , tonumber(data[1]) , prop_mould.prop_name)
                name = string.format(activity_str_tip[135] ,tonumber(data[2]) , name)
                
                local reworld2 = nil
                local data2_info = nil 
                if data2 ~= nil then
                    dropGroup2 = tonumber(data2[3])
                    reworld2 = zstring.split(dms.string(dms["scene_reward"], dropGroup2, scene_reward.reward_items),"|")
                    name2 = dms.string(dms["prop_mould"] , tonumber(data2[1]) , prop_mould.prop_name)
                    name2 = string.format(activity_str_tip[135] ,tonumber(data2[2]) , name2)
                    data2_info = {reworld2, name2}
                end
                state_machine.excute("red_alert_time_eliminate_music_reward_look_window_open",0,{ _data = {{reworld, name}, data2_info} , _name = activity_str_tip[134]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 消除请求
        local red_alert_time_eliminate_music_protocol_terminal = {
            _name = "red_alert_time_eliminate_music_protocol",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("red_alert_time_eliminate_music_ok")
                state_machine.lock("red_alert_time_eliminate_music_choose_one")
                local acitvity = _ED.activity_info[""..instance._activity_type.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node._activity_type = _ED.activity_info[""..response.node._activity_type.activity_type]
                            response.node:playClearArmature()
                        end
                        state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_eliminate_music")
                    else
                        state_machine.unlock("red_alert_time_eliminate_music_ok")
                        state_machine.unlock("red_alert_time_eliminate_music_choose_one")
                    end
                end
                --instance.ChooseImage:setVisible(false)
                local x = ""..instance.choosePos.x
                local y = ""..instance.choosePos.y
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."0".."\r\n"..x.."\r\n"..y
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_eliminate_music_protocol_terminal)
        state_machine.add(red_alert_time_eliminate_music_reward_show_terminal)
        state_machine.add(red_alert_time_eliminate_music_choose_one_terminal)
        state_machine.add(red_alert_time_eliminate_music_transfer_show_terminal)
        state_machine.add(red_alert_time_eliminate_music_transfer_hide_terminal)
        state_machine.add(red_alert_time_eliminate_music_rule_open_terminal)
        state_machine.add(red_alert_time_eliminate_music_ok_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_eliminate_music_transfer_terminal()
end
--播放消除动画
function RedAlertTimeEliminateMusicTransfer:playClearArmature()
    local root = self.roots[1]
    local Panel_eliminate_music_new_icon = ccui.Helper:seekWidgetByName(root, "Panel_eliminate_music_new_icon")

    --将没消除的图标重新定位
    self.laveIconArry = {}
    for i ,v in pairs(self.allIconArry) do
        local isLave = true
        for j ,w in pairs(self.clearIconArry) do
            if v == w then
                isLave = false
                break
            end
        end
        if isLave == true then
            table.insert(self.laveIconArry , v)
        end
    end
    for i ,v in pairs(self.laveIconArry) do
        local belowClearNumber = 0
        for j ,w in pairs(self.clearIconArry) do
            if w.x == v.x and w.y > v.y then
                belowClearNumber = belowClearNumber + 1
            end
        end
        v.y = v.y + belowClearNumber
        v.index = v.index + belowClearNumber * 3
    end 

    for i ,v in pairs(self.clearIconArry) do
        local function playActions()
            v:setVisible(false)
            self.clearAllImage[i]:removeFromParent(true) 
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)
            local armature = ccs.Armature:create("effice_recruit_get_light")
            armature:setPosition(cc.p(v:getPositionX(), v:getPositionY()))
            armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
            self.newIconPanel:addChild(armature)
            armature:getAnimation():playWithIndex(0)
            armature._invoke = function(armatureBack)
                armature:removeFromParent(true)
                if i == #self.clearIconArry then
                    for i ,v in pairs(self.clearIconArry) do
                        v:removeFromParent(true)
                    end
                    self.clearIconArry = {}
                    self.clearAllImage = {}
                    self.choosePos = nil
                    self:updateDraw()
                    state_machine.excute("red_alert_time_eliminate_music_task_updata", 0, "")--任务刷新
                    checkRewardObtainDraw()
                    self:addNewIcon()
                end
            end
        end
        v:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(playActions)))
    end
end

--添加新的icon
function RedAlertTimeEliminateMusicTransfer:addNewIcon()
    local root = self.roots[1]
    self.allIconArry = {}
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"!")
    local removeIconData = zstring.split(activity_add_state_arry[3],"|")

    --记录每列新增个数，然后安排高度
    local rowAddNumber = {3,3,3}
    for i ,v in pairs(self.laveIconArry) do
        if v.x == 0 then
            rowAddNumber[1] = rowAddNumber[1] - 1
        elseif v.x == 1 then
            rowAddNumber[2] = rowAddNumber[2] - 1
        else
            rowAddNumber[3] = rowAddNumber[3] - 1
        end
    end

    for i = 1 , 9 do
        local Image_eliminate_music_rew = ccui.Helper:seekWidgetByName(root, "Image_eliminate_music_rew_"..i)
        if currHeight == nil then
            currHeight = Image_eliminate_music_rew:getContentSize().height
        end
        local isHave = false
        for j ,w in pairs(self.laveIconArry) do
            if w.index == i then
                table.insert(self.allIconArry, w)
                isHave = true
            end
        end
        if isHave == false then
            local data = zstring.split(removeIconData[i], ",")
            pic_index = dms.string(dms["prop_mould"], tonumber(data[1]), prop_mould.pic_index)
            pic_index = zstring.split(pic_index, ",")
            local currIcon = cc.Sprite:create(string.format(config_res.images.ui.props.props, pic_index[1]))
            currIcon:setAnchorPoint(cc.p(0.5 ,0.5))
            self.newIconPanel:addChild(currIcon)
            currIcon.cellType = tonumber(data[1])
            currIcon.x = ( i - 1 ) % 3
            currIcon.y = math.floor(( i - 1 ) / 3) 
            currIcon.index = i
            currIcon:setPosition(cc.p(Image_eliminate_music_rew:getPositionX() ,Image_eliminate_music_rew:getPositionY() + rowAddNumber[currIcon.x + 1] * currHeight))
            table.insert(self.allIconArry, currIcon)
        end
    end
    for i ,v in pairs(self.allIconArry) do
        local Image_eliminate_music_rew = ccui.Helper:seekWidgetByName(root, "Image_eliminate_music_rew_"..i)
        local function playActions()
            if i == #self.allIconArry then
                state_machine.unlock("red_alert_time_eliminate_music_ok")
                state_machine.unlock("red_alert_time_eliminate_music_choose_one")
            end
        end
        v:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(Image_eliminate_music_rew:getPosition())), cc.CallFunc:create(playActions)))
    end
    self.laveIconArry = {}
end

--得到要消除的表
function RedAlertTimeEliminateMusicTransfer:getAllWillClear()
    local root = self.roots[1]
    self.clearIconArry = {}
    local waitAddArry = {self.choosePos}
    for i = 1 , 7 do
        if waitAddArry[1] ~= nil then
            self.clearIconArry = self:tableAddOtherTable(self.clearIconArry ,waitAddArry)
            local currArray = waitAddArry
            waitAddArry = {}
            for i ,v in pairs(currArray) do
                local newSameArry =  self:getOneSideSame(v)
                if newSameArry[1] ~= nil then
                    waitAddArry = self:tableAddOtherTable(waitAddArry ,newSameArry)
                end
            end
        end
    end
    if self.clearAllImage[1] ~= nil then
        for i ,v in pairs(self.clearAllImage) do
            v:removeFromParent(true)
        end
    end
    self.clearAllImage = {}
    for i ,v in pairs(self.clearIconArry) do
        local ImageChoose = cc.Sprite:create(config_res.images.ui.wonderful.eliminate_music_box_hook)
        ImageChoose:setAnchorPoint(cc.p(0.5 ,0.5))
        ImageChoose:setPosition(cc.p(v:getPositionX(), v:getPositionY()))
        self.newIconPanel:addChild(ImageChoose)
        table.insert(self.clearAllImage, ImageChoose)
    end
end

function RedAlertTimeEliminateMusicTransfer:tableAddOtherTable( table1 , table2)
    local arry = table1 or {}
    if table2[1] ~= nil then
        for i ,v in pairs(table2) do
            if self:isAlreadyAdd(arry,v) == false then
                table.insert(arry , v)
            end
        end
    end
    return arry 
end

--寻找周围是否有相同且没加入表的
function RedAlertTimeEliminateMusicTransfer:getOneSideSame( Icon )
    local waitAddArry = {}
    --左边
    if Icon.x > 0 then
        if self.allIconArry[Icon.index - 1].cellType == Icon.cellType 
            and self:isAlreadyAdd(self.clearIconArry,self.allIconArry[Icon.index - 1]) == false
            then
            table.insert(waitAddArry , self.allIconArry[Icon.index - 1])
        end
    end
    --右边
    if Icon.x < 2 then
        if self.allIconArry[Icon.index + 1].cellType == Icon.cellType 
            and self:isAlreadyAdd(self.clearIconArry,self.allIconArry[Icon.index + 1]) == false
            then
            table.insert(waitAddArry , self.allIconArry[Icon.index + 1])
        end
    end
    --上边
    if Icon.y > 0 then
        if self.allIconArry[Icon.index - 3].cellType == Icon.cellType 
            and self:isAlreadyAdd(self.clearIconArry,self.allIconArry[Icon.index - 3]) == false
            then
            table.insert(waitAddArry , self.allIconArry[Icon.index - 3])
        end
    end
    --下边
    if Icon.y < 2 then
        if self.allIconArry[Icon.index + 3].cellType == Icon.cellType 
            and self:isAlreadyAdd(self.clearIconArry,self.allIconArry[Icon.index + 3]) == false
            then
            table.insert(waitAddArry , self.allIconArry[Icon.index + 3])
        end
    end
    return waitAddArry
end

function RedAlertTimeEliminateMusicTransfer:isAlreadyAdd( table ,Icon )
    local result = false
    for i ,v in pairs(table) do
        if v == Icon then
            result = true
        end
    end
    return result
end

function RedAlertTimeEliminateMusicTransfer:updateDraw()
    local root = self.roots[1]
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local Button_eliminate_music_xc = ccui.Helper:seekWidgetByName(root, "Button_eliminate_music_xc")
	--信息
    local Text_eliminate_music_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_eliminate_music_infor_p_1")
	Text_eliminate_music_infor_p_1:setString(self._activity_type.activity_dec)

	-- 时间
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"!")
    local activity_add_state = zstring.split(activity_add_state_arry[1],",")
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    time_str = activity_str_tip[93]
    -- 关闭倒计时
    local Text_eliminate_music_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_eliminate_music_act_time_1")
    Text_eliminate_music_act_time_1:removeAllChildren(true)
    Text_eliminate_music_act_time_1:setString("")
    Text_eliminate_music_act_time_1:setVisible(true)
    local font_size = Text_eliminate_music_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_eliminate_music_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_eliminate_music_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_eliminate_music_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_eliminate_music_act_time_1:addChild(time_int)
    self.text_m_times = Text_eliminate_music_act_time_1
    --下次免费倒计时
    local Text_eliminate_music_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_eliminate_music_act_time_2")
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    Text_eliminate_music_act_time_2:removeAllChildren(true)
    Text_eliminate_music_act_time_2:setString("")
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_eliminate_music_act_time_2:getContentSize().width - 80)
    reset_time_int:setPositionY(Text_eliminate_music_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_eliminate_music_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_eliminate_music_act_time_2:getContentSize().width - 80)
    reset_time_info:setPositionY(Text_eliminate_music_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_eliminate_music_act_time_2:addChild(reset_time_info)
    self.text_reset_times = Text_eliminate_music_act_time_2
    
    --价格
    local Text_eliminate_music_gold_n = ccui.Helper:seekWidgetByName(root, "Text_eliminate_music_gold_n")
    local Image_eliminate_music_gold = ccui.Helper:seekWidgetByName(root, "Image_eliminate_music_gold")
    local blueButtonTexture = config_res.images.ui.share.blue_button
    local yellowButtonTexture = config_res.images.ui.share.yellow_button
    local grayButtonTexture = config_res.images.ui.share.gray_button
    if tonumber(activity_add_state[7]) < tonumber(activity_add_state[8]) then
        Text_eliminate_music_gold_n:setString(activity_str_tip[132])
        Image_eliminate_music_gold:setVisible(false)
        Button_eliminate_music_xc:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
        self.free = true
    else
        Text_eliminate_music_gold_n:setString(activity_add_state[9])
        Image_eliminate_music_gold:setVisible(true)
        Button_eliminate_music_xc:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
        self.free = false
    end
    self.need_gold = tonumber(activity_add_state[9])


    --上面三个图标显示
    local rewardIconData = zstring.split(activity_add_state_arry[2],"|")
    local reward_data = self._activity_type.activity_data[2]
    for i = 1 , 3 do
        local Panel_eliminate_music_icon = ccui.Helper:seekWidgetByName(root, "Panel_eliminate_music_icon_"..i)
        local Text_eliminate_music_name = ccui.Helper:seekWidgetByName(root, "Text_eliminate_music_name_"..i) -- 名称
        local currdata = zstring.split(rewardIconData[i], ",")
        local id = zstring.tonumber(currdata[1])
        local name = dms.string(dms["prop_mould"] , id , prop_mould.prop_name)
        Text_eliminate_music_name:setString(name)
        if i == 1 or i == 3 then
            local Text_eliminate_music_num = ccui.Helper:seekWidgetByName(root, "Text_eliminate_music_num_"..i) -- 数量
            Text_eliminate_music_num:setString("")
            Text_eliminate_music_num:removeAllChildren(true)
            local fontSize = Text_eliminate_music_num:getFontSize()
            local currnumber = tonumber(activity_add_state[i + 3])
            local totalnumber = 0
            local currShowNumber = nil
            if i == 1 then
                currShowNumber = zstring.split(rewardIconData[4], ",")
            else
                currShowNumber = zstring.split(rewardIconData[5], ",")
            end
            totalnumber = tonumber(currShowNumber[2])
            local _richText_1 = ccui.RichText:create()
            _richText_1:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[8][1],color_Type[8][2],color_Type[8][3]),255, currnumber , config_res.font.font_name,fontSize)
            _richText_1:pushBackElement(re1)
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..totalnumber, config_res.font.font_name,fontSize)
            _richText_1:pushBackElement(re2)
            _richText_1:setPosition(cc.p(Text_eliminate_music_num:getContentSize().width/2,Text_eliminate_music_num:getContentSize().height/2))
            _richText_1:setContentSize(cc.size(Text_eliminate_music_num:getContentSize().width,fontSize))
            Text_eliminate_music_num:addChild(_richText_1)
        end

        Panel_eliminate_music_icon:removeAllChildren(true)
        local data = { currdata[1] , 6 , 1}
        pic_index = dms.string(dms["prop_mould"], tonumber(currdata[1]), prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        Panel_eliminate_music_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    end
end

function RedAlertTimeEliminateMusicTransfer:initIcon()
    local root = self.roots[1]
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"!")
    local removeIconData = zstring.split(activity_add_state_arry[3],"|")
    self.allIconArry = {}
    for i = 1 , 9 do
        local Image_eliminate_music_rew = ccui.Helper:seekWidgetByName(root, "Image_eliminate_music_rew_"..i)
        local data = zstring.split(removeIconData[i], ",")
        pic_index = dms.string(dms["prop_mould"], tonumber(data[1]), prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        local currIcon = cc.Sprite:create(string.format(config_res.images.ui.props.props, pic_index[1]))
        currIcon:setAnchorPoint(cc.p(0.5 ,0.5))
        currIcon:setPosition(cc.p(Image_eliminate_music_rew:getPosition()))
        self.newIconPanel:addChild(currIcon)
        currIcon.cellType = tonumber(data[1])
        currIcon.x = ( i - 1 ) % 3
        currIcon.y = math.floor(( i - 1 ) / 3) 
        currIcon.index = i
        table.insert(self.allIconArry, currIcon)
    end
end

--初始化
function RedAlertTimeEliminateMusicTransfer:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.eliminate_music_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_eliminate_music_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_eliminate_music_rule_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_eliminate_music_xc"), nil, 
    {
        terminal_name = "red_alert_time_eliminate_music_ok", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    for i = 1 , 9 do 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_eliminate_music_rew_"..i), nil, 
        {
            terminal_name = "red_alert_time_eliminate_music_choose_one", 
            terminal_state = 0, 
            index = i,
        }, nil, 1)
    end
    for i = 1 , 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_eliminate_music_icon_"..i), nil, 
        {
            terminal_name = "red_alert_time_eliminate_music_reward_show", 
            terminal_state = 0, 
            index = i,
        }, nil, 1)
    end
    -- self.ChooseImage = cc.Sprite:create(config_res.images.ui.wonderful.eliminate_music_box_hook)
    -- root:addChild(self.ChooseImage)
    -- self.ChooseImage:setVisible(false)

    self.IconHeight = ccui.Helper:seekWidgetByName(root, "Image_eliminate_music_rew_1"):getContentSize().height
    self.newIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_eliminate_music_new_icon")
    self:initIcon()
    self:updateDraw()
end

function RedAlertTimeEliminateMusicTransfer:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.text_m_times ~= nil and self.text_m_times:getChildByTag(100) ~= nil then
            self.text_m_times:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_eliminate_music_window_close")
        end
    end
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self.text_reset_times ~= nil and self.text_reset_times:getChildByTag(100) ~= nil then
            self.text_reset_times:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:updateDraw()
        end
    end
end

function RedAlertTimeEliminateMusicTransfer:onEnterTransitionFinish()

end

function RedAlertTimeEliminateMusicTransfer:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeEliminateMusicTransfer:onExit()
    state_machine.remove("red_alert_time_eliminate_music_rule_open")
    state_machine.remove("red_alert_time_eliminate_music_ok")
    state_machine.remove("red_alert_time_eliminate_music_transfer_show")
    state_machine.remove("red_alert_time_eliminate_music_transfer_hide")
    state_machine.remove("red_alert_time_eliminate_music_choose_one")
    state_machine.remove("red_alert_time_eliminate_music_reward_show")
    state_machine.remove("red_alert_time_eliminate_music_protocol")
end