-- ----------------------------------------------------------------------------------------------------
-- 说明：邮件详情
-------------------------------------------------------------------------------------------------------

EmailInfomation = class("EmailInfomationClass", Window)

function EmailInfomation:ctor()
    self.super:ctor()
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.utils.sm_item_icon_cell")
	app.load("client.reward.DrawRareReward")
	self.roots = {}
	self.email = nil

	self._list_view = nil
	self._list_view_posx = 0

	self.reworld_sorting = {}

    local function init_EmailInfomation_terminal()
		local reward_gain_button_terminal = {
            _name = "reward_gain_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _rewardId = params._datas.rewardId
				local _rewardType = params._datas.rewardType
				local data_type = params._datas.dataType
				_ED.show_reward_list_group_ex = {}
				local function responsePropCompoundCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- emailLocalWrite(_rewardId , data_type)
						local email, index = fundEmailById(_rewardId, data_type)
						if email ~= nil then
							email.read_type = 1
							email.draw_state = 1
							_ED._reward_centre[index].read_type = 1
							_ED._reward_centre[index].draw_state = 1
						end

						local reworld_sorting = nil
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
							reworld_sorting = instance.reworld_sorting
						end

						state_machine.excute("email_infomation_window_close",0,"email_infomation_window_close.")
						state_machine.excute("email_manager_one_updata",0,"email_manager_one_updata.")

						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
							checkRewardObtainDraw()
						else
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7, tempRewardInfo)
							fwin:open(getRewardWnd,fwin._windows)
						end
						state_machine.excute("email_manager_email_number_show",0,"email_manager_email_number_show.")
						state_machine.excute("notification_center_update", 0, "push_notification_center_mall_all")
					end
				end
				if tonumber(data_type) == 1 then
					protocol_command.draw_reward_center.param_list = "".."1".."\r\n".._rewardId..",".._rewardType
					NetworkManager:register(protocol_command.draw_reward_center.code, nil, nil, nil, instance, responsePropCompoundCallback, false, nil)
				else
					protocol_command.draw_attachment_in_mail.param_list = _rewardId
					NetworkManager:register(protocol_command.draw_attachment_in_mail.code, nil, nil, nil, instance, responsePropCompoundCallback, false, nil)
				end

			  	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local email_infomation_window_close_terminal = {
            _name = "email_infomation_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	fwin:close(instance)
			  	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(email_infomation_window_close_terminal)
		state_machine.add(reward_gain_button_terminal)
        state_machine.init()
    end
    
    init_EmailInfomation_terminal()
end

function EmailInfomation:upDataDraw()
	local root = self.roots[1]
	
	local RewardName = ccui.Helper:seekWidgetByName(root, "Text_mail_infor_title")	--奖励类型：名字
	local RewardCount = ccui.Helper:seekWidgetByName(root, "Text_mail_infor")	--奖励介绍
	local RewardListView = ccui.Helper:seekWidgetByName(root, "ListView_mail_reward")	--奖励内容
	local Text_mail_infor_from_t = ccui.Helper:seekWidgetByName(root, "Text_mail_infor_from_t")	--发件人
	local Button_mail_infor_rec = ccui.Helper:seekWidgetByName(root, "Button_mail_infor_rec")	--领取按钮
	local Image_mail_rec = ccui.Helper:seekWidgetByName(root, "Image_mail_rec") -- 已领取
	Button_mail_infor_rec:setVisible(false)
	Image_mail_rec:setVisible(false)
	if tonumber(self.email.mail_item_type) == 0 then
	else
		if tonumber(self.email.draw_state) == 0 then
			Button_mail_infor_rec:setVisible(true)
		else
			Image_mail_rec:setVisible(true)
		end
	end
	--标题
	RewardName:setString(self.email.title)
	-- 介绍
	RewardCount:setString(self.email.text_info)
	-- RewardCount:removeAllChildren(true)
	-- local fontName = RewardCount:getFontName()
	-- local fontSize = RewardCount:getFontSize()
	-- self.email.text_info = zstring.exchangeFrom(smWidthSingle(self.email.text_info,fontSize*2/3,RewardCount:getContentSize().width))
	-- local e_text_info = zstring.split(zstring.exchangeTo(self.email.text_info),"&#13;&#10;")
	-- local m_leg = 0
	-- for i,v in pairs(e_text_info) do
	--     local _richText2 = ccui.RichText:create()
	--     _richText2:ignoreContentAdaptWithSize(false)

	--     local richTextWidth = RewardCount:getContentSize().width-fontSize*2
 --        if richTextWidth == 0 then
	--         richTextWidth = RewardCount:getFontSize() * 6
	--     end
			    
	--     _richText2:setContentSize(cc.size(richTextWidth, 0))
	--     _richText2:setAnchorPoint(cc.p(0, 0))

	--     local rt, count, text = draw.richTextCollectionMethod(_richText2, 
	--     v, 
	--     cc.c3b(255, 255, 255),
	--     cc.c3b(255, 255, 255),
	--     0, 
	--     0, 
	--     fontName, 
	--     fontSize,
	--     chat_rich_text_color)

	--     _richText2:formatTextExt()
	--     local rsize = _richText2:getContentSize()
	--     _richText2:setPositionY(m_leg + RewardCount:getContentSize().height)
	--     _richText2:setPositionX(0)
	--     RewardCount:addChild(_richText2)
	--     m_leg = m_leg - rsize.height
	-- end
	-- RewardCount:setString("")

	
	-- local curr_height = 0
	-- local _richText1 = ccui.RichText:create()
 --    _richText1:ignoreContentAdaptWithSize(false)
 --    _richText1:setContentSize(cc.size(RewardCount:getContentSize().width,fontSize))
 --    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255,self.email.text_info,fontName, fontSize)
 --    _richText1:pushBackElement(re1)
 --    _richText1:formatTextExt()
 --    _richText1:setPosition(cc.p(RewardCount:getPositionX() + _richText1:getContentSize().width / 2,RewardCount:getContentSize().height))
 --    RewardCount:addChild(_richText1)
 
    -- curr_height = curr_height + _richText1:getContentSize().height

    -- if tonumber(self.email._reward_type) == 6 then
    -- 	curr_height = curr_height * 2
    -- end

    -- local _richText2 = ccui.RichText:create()
    -- _richText2:ignoreContentAdaptWithSize(false)
    -- _richText2:setContentSize(cc.size(RewardCount:getContentSize().width,fontSize))
    -- local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255,"  "..self.email.text_info,fontName, fontSize)
    -- _richText2:pushBackElement(re2)
    -- _richText2:formatTextExt()
    -- _richText2:setPosition(cc.p(0,curr_height))
    -- RewardCount:addChild(_richText2)
    -- curr_height = curr_height + _richText2:getContentSize().height

    -- if tonumber(self.email._reward_type) == 6 then
    -- else
    -- 	local _richText3 = ccui.RichText:create()
	   --  _richText3:ignoreContentAdaptWithSize(false)
	   --  _richText3:setContentSize(cc.size(RewardCount:getContentSize().width,fontSize))
	   --  local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255,"   ".._sm_email_tip_string[12],fontName, fontSize)
	   --  _richText3:pushBackElement(re3)
	   --  _richText3:formatTextExt()
	   --  _richText3:setPosition(cc.p(0,curr_height))
	   --  RewardCount:addChild(_richText3)
    -- end	
    --发件人
    Text_mail_infor_from_t:setString(self.email.form)

    --奖励
    RewardListView:removeAllItems()
   	
	local index = 1
    for i=1, tonumber(self.email._reward_item_count) do
    	local data = self.email._reward_list[i]
		-- local cell = ResourcesIconCell:createCell()
		local cell = nil

        local table = {}
        table.lazy = true
        if i <= 4 then
        	table.lazy = false
        end
		if tonumber(data.prop_type) == 13 then
            if data.ship_star ~= nil and tonumber(data.ship_star) > 0 then
                table.shipStar = data.ship_star
            end
            -- cell:init(data.prop_type, data.item_value, data.prop_item,nil,nil,nil,true,0,table)
            cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data.prop_type,data.prop_item,data.item_value},false,true,false,true,table})
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
				local rewardinfo = {}
		        rewardinfo.type = data.prop_type
		        rewardinfo.id = data.prop_item
		        rewardinfo.number = data.item_value
		        self.reworld_sorting[index] = rewardinfo
		        index = index + 1
			end
		elseif tonumber(data.prop_type) == 71 then

			local property_info = dms.string(dms["ship_silk_bag_mould"],data.prop_item,ship_silk_bag_mould.base_property)
			local basePropertyList = {}
			if nil ~= property_info then
				local add_property_info = zstring.split(property_info,"|")
				local i = 1
				for k,v in pairs(add_property_info) do
					local add_property_per = zstring.split(v,",")
					if nil ~= add_property_per then
						local a = tipStringInfo_rescue_silkbag_property["0"]
						local baseProperty ={}
						baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
						baseProperty.property_value = add_property_per[2]
						basePropertyList[i] = baseProperty
						i = i + 1 
					end
				end
				
			end
			-- cell:init(data.prop_type, data.item_value, data.prop_item,nil,nil,nil,true,0,table)
			cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data.prop_type,data.prop_item,data.item_value},false,true,false,true,{basePropertyList,0}})
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
				local rewardinfo = {}
				rewardinfo.type = data.prop_type
				rewardinfo.id = data.prop_item
				rewardinfo.number = data.item_value
				self.reworld_sorting[index] = rewardinfo
				index = index + 1
			end
		elseif tonumber(data.prop_type) == 73 then
			app.load("client.packs.FightSpirit.FightSpiritHandle")
			app.load("client.packs.FightSpirit.fightspiritskill1")
			app.load("client.cells.utils.resources_icon_cell")
			local fightSp = FightSpiritHandle.getFightSpiritByMouldId(data.prop_item)
			
			cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data.prop_type,data.prop_item,data.item_value},false,true,false,true,{fightSp,0}})
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
				local rewardinfo = {}
				rewardinfo.type = data.prop_type
				rewardinfo.id = data.prop_item
				rewardinfo.number = data.item_value
				self.reworld_sorting[index] = rewardinfo
				index = index + 1
			end
        else
        	-- cell:init(data.prop_type, data.item_value, data.prop_item,nil,nil,nil,true,0,table)
        	cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data.prop_type,data.prop_item,data.item_value},false,true,false,true,table})
        	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
				local rewardinfo = {}
		        rewardinfo.type = data.prop_type
		        rewardinfo.id = data.prop_item
		        rewardinfo.number = data.item_value
		        self.reworld_sorting[index] = rewardinfo
		        index = index + 1
		    end
        end
		RewardListView:addChild(cell)
    end

	RewardListView:requestRefreshView()	

	self._list_view = RewardListView
	self._list_view_posx = self._list_view:getInnerContainer():getPositionX()
end

function EmailInfomation:onUpdate(dt)
	if self._list_view ~= nil then
		local posX = self._list_view:getInnerContainer():getPositionX()
        if posX == self._list_view_posx then
            return
        end
        self._list_view_posx = posX

        local size = self._list_view:getContentSize()
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempX = v:getPositionX() + posX
            if tempX + itemSize.width * 2 < 0 or tempX > size.width + itemSize.width * 2 then
                v:unload()
            else
                v:reload()
            end
        end
	end
end

function EmailInfomation:onEnterTransitionFinish()
    local csbEmailInfomation = csb.createNode("email/email_infor_window.csb")
	local root = csbEmailInfomation:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)

    ccui.Helper:seekWidgetByName(root, "Image_37"):setTouchEnabled(true)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mail_infor_close"), nil, 
	{
		terminal_name = "email_infomation_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_mail_bg"), nil, 
	{
		terminal_name = "email_infomation_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
    --领奖
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mail_infor_rec"), nil, 
	{
		terminal_name = "reward_gain_button", 
		terminal_state = 0, 
		rewardId = self.email._reward_centre_id,
		rewardType = self.email._reward_type,
		dataType = self.email.data_type,
		isPressedActionEnabled = true
	},
	nil,0)
	
	self:upDataDraw()
	
end

function EmailInfomation:init(email)
	self.email = email
end


function EmailInfomation:createCell()
	local cell = EmailInfomation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function EmailInfomation:onExit()
	state_machine.remove("email_infomation_window_close")
	state_machine.remove("reward_gain_button")
end