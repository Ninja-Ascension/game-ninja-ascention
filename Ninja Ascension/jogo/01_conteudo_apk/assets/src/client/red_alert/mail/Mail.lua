-----------------------------
-- 邮件
-----------------------------
Mail = class("MailClass", Window)
--打开界面
Mail.__ListView_recive_props_posX = nil
local mail_window_open_terminal = {
	_name = "mail_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if funOpenDrawTip(58) == true then
			return true
		end

		if _ED.mail_system_have_new == true then
			local function responseCallback(response)
	            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                if fwin:find("MailClass") == nil then
						fwin:open(Mail:new():init(),fwin._ui)		
					end
	            end
	        end
	        _ED.mail_system_have_new = false
	        NetworkManager:register(protocol_command.get_user_mail.code, nil, nil, nil, nil, responseCallback, false, nil)
	    else
            if fwin:find("MailClass") == nil then
				fwin:open(Mail:new():init(),fwin._ui)		
			end
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local mail_window_close_terminal = {
	_name = "mail_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MailClass"))
		
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(mail_window_open_terminal)
state_machine.add(mail_window_close_terminal)
state_machine.init()

function Mail:ctor()
	self.super:ctor()
	self.roots = {}
	self.mail_data = nil
	self.cell = nil
	app.load("client.red_alert.cells.mail.mail_cell")
    -- Initialize mail machine.
    local function init_mail_terminal()
        --取消所有选择
        local mail_all_un_select_terminal = {
            _name = "mail_all_un_select",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:unSetSelected()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --绘制邮件信息
        local mail_draw_dec_terminal = {
            _name = "mail_draw_dec",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onUpdateDrawDec(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --领取奖励 或者 删除邮件
        local mail_get_reward_info_terminal = {
            _name = "mail_get_reward_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = instance.cell
				local mail_id = self.mail_data.mail_id
				
				local data = {}
				data.show_reward_list = instance.mail_data.mail_items
				local function responseCallback(response)
					  state_machine.excute("mail_draw_remove_cell",0,cell)
					  state_machine.excute("reward_obtain_window_open",0,{nil,data})
				end
				if #data.show_reward_list > 0 then
					protocol_command.draw_attachment_in_mail.param_list = mail_id
					NetworkManager:register(protocol_command.draw_attachment_in_mail.code, nil, nil, nil, nil, responseCallback, false, nil)
				else
					protocol_command.delete_mail.param_list = mail_id
					NetworkManager:register(protocol_command.delete_mail.code, nil, nil, nil, nil, responseCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --移除某个子cell
        local mail_draw_remove_cell_terminal = {
            _name = "mail_draw_remove_cell",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:removeCell(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(mail_all_un_select_terminal)
        state_machine.add(mail_draw_dec_terminal)
        state_machine.add(mail_get_reward_info_terminal)
        state_machine.add(mail_draw_remove_cell_terminal)
        state_machine.init()
    end

    -- call func init mail machine.
    init_mail_terminal()
end

function Mail:onUpdateDraw()
	local root = self.roots[1]
	--阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")

	local Panel_hollow = ccui.Helper:seekWidgetByName(root,"Panel_hollow")
	Panel_hollow:setVisible(false)

	Panel_hollow:setVisible(true)
	local ListView_mail_left = ccui.Helper:seekWidgetByName(root,"ListView_mail_left")
	ListView_mail_left:removeAllItems()
	local number = 0
	for i,v in pairs(_ED.mail_system) do
		number = number + 1
	end

	local Text_mail_name = ccui.Helper:seekWidgetByName(root,"Text_mail_name") -- 邮件名字
	local Text_mail_10 = ccui.Helper:seekWidgetByName(root,"Text_mail_10") --邮件起头
	local Text_mail_content = ccui.Helper:seekWidgetByName(root,"Text_mail_content") --邮件内容
	local Button_mail_receive = ccui.Helper:seekWidgetByName(root,"Button_mail_receive") --领取
	local Button_mail_de = ccui.Helper:seekWidgetByName(root,"Button_mail_de") --领取
	Text_mail_name:setString("")
	Text_mail_10:setString("")
	Text_mail_content:setString("")
	Button_mail_receive:setVisible(false)
	Button_mail_de:setVisible(false)
	if number == 0 then
		return
	end
	local index = 1
	for i,v in pairs(_ED.mail_system) do
		local cell = state_machine.excute("mail_create_cell",0,{v,index})
		if index == 1 then
			state_machine.excute("mail_cell_click",0,{ _datas = {cell = cell}})
		end
		index = index + 1
		ListView_mail_left:addChild(cell)
	end

	ListView_mail_left:requestRefreshView()

	self._list_view = ListView_mail_left
	self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function Mail:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function Mail:unSetSelected()
	local root = self.roots[1]
	local ListView_mail_left = ccui.Helper:seekWidgetByName(root,"ListView_mail_left")
	for i,cell in pairs(ListView_mail_left:getItems()) do
		cell.selected = false
		cell:SetSelected()
	end
end

function Mail:onUpdateDrawDec(cell)
	local root = self.roots[1]
	local Panel_hollow = ccui.Helper:seekWidgetByName(root,"Panel_hollow")
	Panel_hollow:setVisible(false)

	if cell == nil then
		return
	end

	-- debug.print_r(cell.mail_data)

	Panel_hollow:setVisible(true)
	self.cell = cell
	self.mail_data = cell.mail_data
	local Text_mail_name = ccui.Helper:seekWidgetByName(root,"Text_mail_name") -- 邮件名字
	local Text_mail_10 = ccui.Helper:seekWidgetByName(root,"Text_mail_10") --邮件起头
	local Text_mail_content = ccui.Helper:seekWidgetByName(root,"Text_mail_content") --邮件内容
	local ListView_recive_props = ccui.Helper:seekWidgetByName(root,"ListView_recive_props") -- 道具listview
	ListView_recive_props:removeAllItems()

    local name = email_reward_type_dec[self.mail_data.mail_channel_type]
	Text_mail_name:setString(name)
	Text_mail_10:setString(red_alert_all_str[101])
	
	local mail_dec_str = ""
	if self.mail_data.mail_channel_type == 1 then -- 竞技场邮件
		if self.mail_data.mail_channel_child_type == 2 then --竞技场排名奖励
			local arena_official = dms.int(dms["arena_reward_param"],self.mail_data.mail_dec,arena_reward_param.arena_official)
			local arena_name = dms.string(dms["arena_reward_param"],self.mail_data.mail_dec,arena_reward_param.arena_name)
		    arena_name = zstring.split(arena_name,",")
		    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
		    local temp_dec = red_alert_officer[arena_official] .. arena_name
			mail_dec_str = string.format(email_reward_type_reward_dec[1],temp_dec)
		else

		end
	elseif self.mail_data.mail_channel_type == 11 then -- 阿拉希之战
		mail_dec_str = string.format(email_reward_type_reward_dec[3],self.mail_data.mail_dec)
	elseif self.mail_data.mail_channel_type == 15 then -- 将魂试炼
		mail_dec_str = string.format(email_reward_type_reward_dec[2],self.mail_data.mail_dec)
	elseif self.mail_data.mail_channel_type == 16 then -- 系统公告
		mail_dec_str = string.format(self.mail_data.mail_dec)
	elseif self.mail_data.mail_channel_type == 5 then -- 攻城拔寨
		if self.mail_data.mail_channel_child_type == 17 then --掠夺成功
			mail_dec_str = string.format(email_reward_type_reward_dec[5],self.mail_data.mail_dec)
		elseif self.mail_data.mail_channel_child_type == 18 then -- 被抢夺
			mail_dec_str = string.format(email_reward_type_reward_dec[4],self.mail_data.mail_dec)
		elseif self.mail_data.mail_channel_child_type == 20 then -- 直接获得（放弃 或者 占领
			mail_dec_str = email_reward_type_reward_dec[6]
		end
	elseif self.mail_data.mail_channel_type == 17 then -- 开服冲top
		if self.mail_data.mail_channel_child_type == 23 then --等级
			mail_dec_str = string.format(email_reward_type_reward_dec[7],self.mail_data.mail_title,self.mail_data.mail_dec)
		elseif self.mail_data.mail_channel_child_type == 24 then -- 战力
			mail_dec_str = string.format(email_reward_type_reward_dec[8],self.mail_data.mail_title,self.mail_data.mail_dec)
		elseif self.mail_data.mail_channel_child_type == 25 then -- 侠客
			mail_dec_str = string.format(email_reward_type_reward_dec[9],self.mail_data.mail_title,self.mail_data.mail_dec)
		elseif self.mail_data.mail_channel_child_type == 26 then -- 星星
			mail_dec_str = string.format(email_reward_type_reward_dec[10],self.mail_data.mail_title,self.mail_data.mail_dec)
		end
	elseif self.mail_data.mail_channel_type == 19 then -- 帮派战
		if self.mail_data.mail_channel_child_type == 27 then
			local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould], self.mail_data.mail_title, warfare_map_mould.city_name)
			mail_dec_str = string.format(email_reward_type_reward_dec[13],city_name)
		elseif self.mail_data.mail_channel_child_type == 28 then
			mail_dec_str = string.format(email_reward_type_reward_dec[14], self.mail_data.mail_dec)
		elseif self.mail_data.mail_channel_child_type == 29 then
			mail_dec_str = string.format(email_reward_type_reward_dec[15], self.mail_data.mail_dec)
		end
	elseif self.mail_data.mail_channel_type == 21 then -- 内测返利
		mail_dec_str = email_reward_type_reward_dec[16]
    elseif self.mail_data.mail_channel_type == 22 then -- 积分榜奖励
        local count = dms.count(dms["user_stronghold"])
        local title_name = ""
        for i = count, 1, -1 do
            local score = dms.int(dms["user_stronghold"], i, user_stronghold.score)
            if zstring.tonumber(self.mail_data.mail_dec) >= score then
                title_name = dms.string(dms["user_stronghold"], i, user_stronghold.title_name)
                break
            end
        end
        mail_dec_str = string.format(email_reward_type_reward_dec[17], title_name)
	end

	-- "恭喜您在开服冲top活动,等级排行,达成%s日排行第%s名，现为您发放排名奖励。（本邮件将在七天后自动删除，请及时领取）",--7
	-- "恭喜您在开服冲top活动,战力排行,达成%s日排行第%s名，现为您发放排名奖励。（本邮件将在七天后自动删除，请及时领取）",--8
	-- "恭喜您在开服冲top活动,星星排行,达成%s日排行第%s名，现为您发放排名奖励。（本邮件将在七天后自动删除，请及时领取）",--9
	-- "恭喜您在开服冲top活动,侠客行排行,达成%s日排行第%s名，现为您发放排名奖励。（本邮件将在七天后自动删除，请及时领取）",--10
	Text_mail_content:setString(mail_dec_str)

	local Button_mail_receive = ccui.Helper:seekWidgetByName(root,"Button_mail_receive") --领取
	local Button_mail_de = ccui.Helper:seekWidgetByName(root,"Button_mail_de") --领取
	Button_mail_receive:setVisible(false)
	Button_mail_de:setVisible(false)
	if #self.mail_data.mail_items ~= 0 then
		Button_mail_receive:setVisible(true)
		for i,v in pairs(self.mail_data.mail_items) do
			if tonumber(v.prop_type) == 6 then
	            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
	                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0  then
	                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,true,true})
	            else
	                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
	            end  
	        elseif tonumber(v.prop_type) == 34 then    
	            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})   
	        else
	            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
	        end
	        ListView_recive_props:addChild(cell)
		end

		local tpx=120--每个奖励框大小
		local x= ListView_recive_props:getContentSize().width
		local _tables=ListView_recive_props:getItems()
		if _tables == 0 then
			return
		end
		if Mail.__ListView_recive_props_posX == nil then
			Mail.__ListView_recive_props_posX = ListView_recive_props:getPositionX()
		end
		tpx=_tables[1].roots[1]:getContentSize().width
		ListView_recive_props:setPositionX( Mail.__ListView_recive_props_posX + (x - #self.mail_data.mail_items * tpx)*0.4)

		-- for i, v in pairs(_tables) do
		-- 	tpx=v.roots[1]:getContentSize().width
		-- 	v.roots[1]:setPositionX(v.roots[1]:getPositionX()+(x-tpx*(#self.mail_data.mail_items))/2)
		-- end
	else
		Button_mail_de:setVisible(true)
	end
end

function Mail:removeCell(cell)
	local root = self.roots[1]
	local ListView_mail_left = ccui.Helper:seekWidgetByName(root,"ListView_mail_left")
	ListView_mail_left:removeItem(ListView_mail_left:getIndex(cell))
	ListView_mail_left:requestRefreshView()

	state_machine.excute("mail_cell_click",0,{ _datas = {cell = ListView_mail_left:getItems()[1]}})
end

function Mail:init()
	self:onInit()
    return self
end

function Mail:onInit()
	-- debug.print_r(_ED.user_info)
    local csbItem = csb.createNode(config_csb.mail.mail)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    --确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_close"), nil, 
    {
        terminal_name = "mail_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    --领取
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_receive"), nil, 
    {
        terminal_name = "mail_get_reward_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    --删除邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_de"), nil, 
    {
        terminal_name = "mail_get_reward_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    self:onUpdateDraw()
end

function Mail:onEnterTransitionFinish()
    
end


function Mail:onExit()
	state_machine.remove("mail_all_un_select")
	state_machine.remove("mail_draw_dec")
	state_machine.remove("mail_get_reward_info")
	state_machine.remove("mail_draw_remove_cell")
end

