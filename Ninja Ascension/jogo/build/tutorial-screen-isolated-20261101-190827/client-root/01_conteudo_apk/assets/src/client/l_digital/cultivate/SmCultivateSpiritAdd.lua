-----------------------------
-- 养成数码精神详细界面
-----------------------------
SmCultivateSpiritAdd = class("SmCultivateSpiritAddClass", Window)

--打开界面
local sm_cultivate_spirit_add_open_terminal = {
	_name = "sm_cultivate_spirit_add_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateSpiritAddClass") == nil then
			fwin:open(SmCultivateSpiritAdd:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_cultivate_spirit_add_close_terminal = {
	_name = "sm_cultivate_spirit_add_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local _self = params._datas._myself
        state_machine.excute("sm_cultivate_spirit_cell_update",0,{_self.cell})
		fwin:close(fwin:find("SmCultivateSpiritAddClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_spirit_add_open_terminal)
state_machine.add(sm_cultivate_spirit_add_close_terminal)
state_machine.init()

function SmCultivateSpiritAdd:ctor()
	self.super:ctor()
	self.roots = {}
	self.groupID = 0
    self._m_type = 0
    self.actionOver = true

    self._ship_name = ""

    app.load("client.cells.prop.prop_icon_new_cell")
    app.load("client.l_digital.cells.cultivate.spirit.sm_cultivate_spirit_exchange_cell")

    local function init_sm_cultivate_spirit_add_terminal()
		
		local sm_cultivate_spirit_add_select_ships_terminal = {
            _name = "sm_cultivate_spirit_add_select_ships",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local index = params._datas.index
				local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], instance.group, ship_spirit_group.ship_need_id),",")
				if ship_need_id[tonumber(index)] == nil or tonumber(ship_need_id[tonumber(index)]) <= 0 then
					return
				end

                -- if __lua_project_id == __lua_project_l_digital then
                --     if isShowHeroCard(ship_need_id[tonumber(index)]) == false then
                --         return
                --     end
                -- end

                instance.index = index
				local ship = fundShipWidthTemplateId(ship_need_id[tonumber(instance.index)])
				local function requesrDefendCheck(response)
			        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
			        	instance:drawSelectedObject(index)
			        end
			    end
				if ship ~= nil then
			    	protocol_command.ship_spirit_init.param_list = ship.ship_id
		    		NetworkManager:register(protocol_command.ship_spirit_init.code, nil, nil, nil, instance, requesrDefendCheck, false, nil)  
			    else
			    	instance:drawSelectedObject(index)
			    end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_add_left_page_terminal = {
            _name = "sm_cultivate_spirit_add_left_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.group = tonumber(instance.group) -1 
				instance.index = 1
				local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], instance.group, ship_spirit_group.ship_need_id),",")
				local ship = fundShipWidthTemplateId(ship_need_id[tonumber(instance.index)])
				local function requesrDefendCheck(response)
			        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
			        	instance:onUpdateDraw()
						instance:drawSelectedObject(instance.index)
			        end
			        state_machine.unlock("sm_cultivate_spirit_add_left_page")
			    end
			    if ship ~= nil then
			    	protocol_command.ship_spirit_init.param_list = ship.ship_id
		    		NetworkManager:register(protocol_command.ship_spirit_init.code, nil, nil, nil, instance, requesrDefendCheck, false, nil)  
		    		state_machine.lock("sm_cultivate_spirit_add_left_page")
			    else
			    	instance:onUpdateDraw()
					instance:drawSelectedObject(instance.index)
			    end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_add_right_page_terminal = {
            _name = "sm_cultivate_spirit_add_right_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.group = tonumber(instance.group) +1 
				instance.index = 1
				local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], instance.group, ship_spirit_group.ship_need_id),",")
				local ship = fundShipWidthTemplateId(ship_need_id[tonumber(instance.index)])
				local function requesrDefendCheck(response)
                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
			        	instance:onUpdateDraw()
						instance:drawSelectedObject(instance.index)
                    end
			    end
			    if ship ~= nil then
			    	protocol_command.ship_spirit_init.param_list = ship.ship_id
		    		NetworkManager:register(protocol_command.ship_spirit_init.code, nil, nil, nil, instance, requesrDefendCheck, false, nil)  
			    else
			    	instance:onUpdateDraw()
					instance:drawSelectedObject(instance.index)
			    end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_add_send_a_gift_terminal = {
            _name = "sm_cultivate_spirit_add_send_a_gift",
            _init = function (terminal)
                app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
                    protocol_command.education_change.param_list = "531"
                    if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
                        NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
                    end
                end
                local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], instance.group, ship_spirit_group.ship_need_id),",")
                local selected_ship = fundShipWidthTemplateId(ship_need_id[tonumber(instance.index)])
                if selected_ship == nil then
                    TipDlg.drawTextDailog(_new_interface_text[170])
                    return
                end
                if _ED.digital_spirit_state_info[selected_ship.ship_id] == nil then
                    return
                end
                --精神等级上限配置修改
                local limit = 100
                local limitCofig = dms.int(dms["ship_config"], 48, ship_config.param)
                if limitCofig then
                    limit = limitCofig
                end
                if zstring.tonumber(_ED.digital_spirit_state_info[selected_ship.ship_id].level) >= limit then
                    TipDlg.drawTextDailog(_new_interface_text[215])
                    return
                end

                local m_type = tonumber(params._datas.m_type)
                local prop = tonumber(params._datas.prop)
                local have_prop = false
                local need_props = zstring.split(dms.string(dms["ship_spirit_group"], instance.group, ship_spirit_group.need_props),"|")
                for i = 1, #need_props do
                    local needPropInfo = zstring.split(need_props[i],",")
                    local need_prop = tonumber(needPropInfo[2])
                    if m_type == -1 then
                        if tonumber(getPropAllCountByMouldId(need_prop)) > 0 then
                            have_prop = true
                            break
                        end 
                    elseif prop == need_prop then
                        m_type = i - 1
                        if tonumber(getPropAllCountByMouldId(need_prop)) > 0 then
                            have_prop = true
                        end 
                        break
                    end
                end

                if have_prop == false then
                    TipDlg.drawTextDailog(_new_interface_text[175])
                    return
                end
                if params._datas.m_batch == 1 then 
                    state_machine.excute("sm_cultivate_spirit_exchange_cell_open",0,{need_props,instance.group,selected_ship.ship_id})
                else 
                    instance._m_type = m_type
                    if m_type == -1 then
                        local tip = ConfirmTip:new()
                        tip:init(instance, instance.sureSendGift, string.format(_new_interface_text[179], instance._ship_name))
                        fwin:open(tip, fwin._windows)
                    else
                        instance:sureSendGift(0)
                    end
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_object_refush_terminal = {
            _name = "sm_cultivate_spirit_object_refush",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:drawSelectedObject(instance.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_spirit_add_select_ships_terminal)
        state_machine.add(sm_cultivate_spirit_add_left_page_terminal)
        state_machine.add(sm_cultivate_spirit_add_right_page_terminal)
        state_machine.add(sm_cultivate_spirit_add_send_a_gift_terminal)
        state_machine.add(sm_cultivate_spirit_object_refush_terminal)
        state_machine.init()
    end
    init_sm_cultivate_spirit_add_terminal()
end

function SmCultivateSpiritAdd:sureSendGift(sure_number)
    if sure_number ~= 0 then
        return
    end

    local m_type = self._m_type
    local need_props = zstring.split(dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.need_props),"|")

    local function requesrDefendCheck(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                if tonumber(m_type) ~= -1 then
                    --画动画
                    local Panel_digimon_big_head = ccui.Helper:seekWidgetByName(response.node.roots[1],"Panel_digimon_big_head")
                    local Image_prop_icon = ccui.Helper:seekWidgetByName(response.node.roots[1],"Image_prop_icon_"..tonumber(m_type)+1)
                    if Image_prop_icon:getChildByTag(95272) ~= nil then
                        Image_prop_icon:removeChildByTag(95272)
                    end
                    local needPropInfo = zstring.split(need_props[tonumber(m_type)+1],",")
                    local pic_index = dms.int(dms["prop_mould"], needPropInfo[2], prop_mould.pic_index)
                    local sprite = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic_index))
                    sprite:setAnchorPoint(cc.p(0, 0))
                    sprite:setScale(1)
                    sprite:setTag(95272)
                    Image_prop_icon:addChild(sprite,1000)

                    local MoveTopoint = cc.p(Panel_digimon_big_head:getPositionX()-Panel_digimon_big_head:getContentSize().width, Panel_digimon_big_head:getPositionY()) 
                    local function playOver(sender)
                        sender:removeFromParent(true)
                        -- Image_prop_icon:removeChildByTag(95272)
                        response.node:drawSelectedObject(response.node.index)
                    end
                    -- sprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.5, MoveTopoint), cc.CallFunc:create(playOver)))
                    local seq = cc.Sequence:create(
                            cc.Spawn:create({cc.ScaleTo:create(0.5, 0.1),cc.MoveTo:create(0.5, MoveTopoint)}),
                            cc.CallFunc:create(playOver)
                        )
                    sprite:runAction(seq)
                else
                    response.node:drawSelectedObject(response.node.index)
                end
                local rewardInfo = getSceneReward(7) 
                if rewardInfo ~= nil then
                    app.load("client.reward.DrawRareReward")
                    local getRewardWnd = DrawRareReward:new()
                    getRewardWnd:init(nil, rewardInfo)
                    fwin:open(getRewardWnd, fwin._ui)
                end
            end
        end
    end
    local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.ship_need_id),",")
    local selected_ship = fundShipWidthTemplateId(ship_need_id[tonumber(self.index)])
    if selected_ship == nil then
        TipDlg.drawTextDailog(_new_interface_text[170])
        return
    end
    getSceneReward(7)
    _ED.show_reward_list_group_ex = {}
    protocol_command.ship_spirit_level_up.param_list = self.group.."\r\n"..selected_ship.ship_id.."\r\n"..m_type
    NetworkManager:register(protocol_command.ship_spirit_level_up.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
end

function SmCultivateSpiritAdd:onUpdateDraw()
    local root = self.roots[1]

    local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.ship_need_id),",")

    local Button_pve_arrow_left = ccui.Helper:seekWidgetByName(root,"Button_pve_arrow_left")
    local Button_pve_arrow_right = ccui.Helper:seekWidgetByName(root,"Button_pve_arrow_right")
    Button_pve_arrow_left:setVisible(true)
    Button_pve_arrow_right:setVisible(true)
    if tonumber(self.group) == 1 then
    	Button_pve_arrow_left:setVisible(false)
    elseif tonumber(self.group) == #dms["ship_spirit_group"] then
    	Button_pve_arrow_right:setVisible(false)
    end

    --分组de图片
    local Panel_spirit_icon = ccui.Helper:seekWidgetByName(root,"Panel_spirit_icon")
    Panel_spirit_icon:removeBackGroundImage()
    local icon = dms.int(dms["ship_spirit_group"], self.group, ship_spirit_group.icon)
    Panel_spirit_icon:setBackGroundImage(string.format("images/ui/text/SMJS_res/smjs_b/smzj_b_icon_%d.png", icon))

    --分组的名称
    local Panel_spirit_name = ccui.Helper:seekWidgetByName(root,"Panel_spirit_name")
    Panel_spirit_name:removeBackGroundImage()
    Panel_spirit_name:setBackGroundImage(string.format("images/ui/text/SMJS_res/smjs_b/smjs_b_name_%d.png", icon))

    local Text_title_type = ccui.Helper:seekWidgetByName(root,"Text_title_type")
    Text_title_type:setString(string.format(_new_interface_text[150],dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.name)))
    
    

    for i=1,3 do
    	--头像
    	local Panel_digimon_head = ccui.Helper:seekWidgetByName(root,"Panel_digimon_head_"..i)
    	Panel_digimon_head:removeAllChildren(true)
    	--名称
        local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
    	local icons = nil 

        local isShowHero = ship_need_id[i] ~= nil

        if isShowHero and tonumber(ship_need_id[i]) < 0 then 
            isShowHero = false
        end
        -- if __lua_project_id == __lua_project_l_digital then
        --     if isShowHero == true then
        --         isShowHero = isShowHeroCard(ship_need_id[i])
        --     end
        -- end
        if isShowHero == true then
            --进化形象
            local evo_image = dms.string(dms["ship_mould"], ship_need_id[i], ship_mould.fitSkillTwo)
            local evo_info = zstring.split(evo_image, ",")
            --进化模板id
            local evo_mould_id = 0
            local ship = fundShipWidthTemplateId(ship_need_id[i])
            if ship ~= nil then
                local ship_evo = zstring.split(ship.evolution_status, "|")
                evo_mould_id = smGetSkinEvoIdChange(ship)
            else
                local captain_name = dms.int(dms["ship_mould"], ship_need_id[i], ship_mould.captain_name)
                evo_mould_id = evo_info[captain_name]
            end
            local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
            icons = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
            icons:setPosition(cc.p(Panel_digimon_head:getContentSize().width/2,Panel_digimon_head:getContentSize().height/2))
            Panel_digimon_head:addChild(icons)
            if ship ~= nil then
                display:ungray(icons)
            else
                display:gray(icons)
            end

            local name_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
            local name = dms.string(dms["word_mould"], name_index, word_mould.text_info)
            Text_name:setString(name)

            if nil ~= fundShipWidthTemplateId(ship_need_id[i]) then
                local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_bg_"..i)
                Image_bg:loadTexture("images/ui/quality/icon_enemy_5.png")
            else
                local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_bg_"..i)
                Image_bg:loadTexture("images/ui/quality/icon_enemy_1.png")
            end

            -- pmc武将图标显示ssr
            if true then
                local ability = dms.int(dms["ship_mould"], ship_need_id[i], ship_mould.ability)
                local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality_"..i)
                ssrIcon:setVisible(true)
                ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
            end
            -- 武将限定卡显示
            local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding_"..i)
            if Panel_xianding then 
                Panel_xianding:setVisible(false)
                Panel_xianding:removeAllChildren(true)
                DisplayLimitCard(tonumber(ship_need_id[i]) ,Panel_xianding , 1)
            end
            -- 武将限定卡SP标签
            if __lua_project_id == __lua_project_l_digital then 
                local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality_"..i)
                DisplaySpCardTag(tonumber(ship_need_id[i]), spIcon)
            end
        else
            icons = cc.Sprite:create(string.format("images/ui/props/props_%d.png", 107401))
            icons:setPosition(cc.p(Panel_digimon_head:getContentSize().width/2,Panel_digimon_head:getContentSize().height/2))
            Panel_digimon_head:addChild(icons)
            local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_bg_"..i)
            Image_bg:loadTexture("images/ui/quality/icon_enemy_1.png")
            display:gray(icons)
            Text_name:setString("")
        end
    end
end

function SmCultivateSpiritAdd:drawSelectedObject(index)
	local root = self.roots[1]

    local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.ship_need_id),",")
	local selected_ship = fundShipWidthTemplateId(ship_need_id[tonumber(index)])
	if selected_ship ~= nil then
		if _ED.digital_spirit_state_info[selected_ship.ship_id] == nil then
			_ED.digital_spirit_state_info[selected_ship.ship_id] = {}
			_ED.digital_spirit_state_info[selected_ship.ship_id].level = 1
			_ED.digital_spirit_state_info[selected_ship.ship_id].good_opinion = 0
			_ED.digital_spirit_state_info[selected_ship.ship_id].stalls = 1
		end
	end
	--数码精神档位的显示
    local Panel_hgd_icon = ccui.Helper:seekWidgetByName(root,"Panel_hgd_icon")
    Panel_hgd_icon:removeBackGroundImage()

    --属性库组id
    self.groupID = zstring.split(dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.ship_attribute_group),",")[tonumber(index)]
    local groups = dms.searchs(dms["ship_spirit_mould"], ship_spirit_mould.group_id, self.groupID)
    local level = 0
    local stalls = 0
    if selected_ship ~= nil then
    	level = _ED.digital_spirit_state_info[selected_ship.ship_id].level
    	stalls = _ED.digital_spirit_state_info[selected_ship.ship_id].stalls
    else
    	level = 1
    	stalls = 1
    end
    local attributesData = nil
    local m_index = 0
    for i,v in pairs(groups) do
    	m_index = m_index + 1
    	-- local attribution = zstring.split(v[3],",")
    	if tonumber(v[3]) == tonumber(stalls) and tonumber(v[4]) == tonumber(level) then
    		attributesData = v
    		break
    	end
    end
    --增加的速度
    local Text_team_speed_n = ccui.Helper:seekWidgetByName(root,"Text_team_speed_n")
    local add_speed = 0
    if selected_ship ~= nil then
        add_speed = math.floor(selected_ship.ship_wisdom)
    else
    end
    Text_team_speed_n:setString(add_speed)

    local attributes_info = zstring.split(attributesData[5],"|")
    --攻击加成
    local Text_sx_1_0 = ccui.Helper:seekWidgetByName(root,"Text_sx_1_0")
    Text_sx_1_0:setString("+"..zstring.split(attributes_info[1],",")[2])
    --防御加成
    local Text_sx_2_0 = ccui.Helper:seekWidgetByName(root,"Text_sx_2_0")
    Text_sx_2_0:setString("+"..zstring.split(attributes_info[2],",")[2])
    --生命加成
    local Text_sx_3_0 = ccui.Helper:seekWidgetByName(root,"Text_sx_3_0")
    Text_sx_3_0:setString("+"..zstring.split(attributes_info[3],",")[2])
    --格挡率加成
    local Text_sx_4 = ccui.Helper:seekWidgetByName(root,"Text_sx_4")
    local Text_sx_4_0 = ccui.Helper:seekWidgetByName(root,"Text_sx_4_0")
    Text_sx_4:setString(cultivate_spirit_attributes_name[tonumber(self.groupID)*2-1])
    Text_sx_4_0:setString("+"..zstring.split(attributes_info[4],",")[2].."%")

    --破格挡率加成
    local Text_sx_5 = ccui.Helper:seekWidgetByName(root,"Text_sx_5") 
    local Text_sx_5_0 = ccui.Helper:seekWidgetByName(root,"Text_sx_5_0")
    Text_sx_5:setString(cultivate_spirit_attributes_name[tonumber(self.groupID)*2])
    Text_sx_5_0:setString("+"..zstring.split(attributes_info[5],",")[2].."%")

    --下一级
    local nextAttributesData = groups[m_index+1]
    --下一级的加成属性名
    local Text_next_sx = ccui.Helper:seekWidgetByName(root,"Text_next_sx")

    --下一级加成的属性值
    local Text_next_sx_n = ccui.Helper:seekWidgetByName(root,"Text_next_sx_n")
    if nextAttributesData == nil then
    	Text_next_sx:setVisible(false)
    	Text_next_sx_n:setVisible(false)
    else
    	Text_next_sx:setVisible(true)
    	Text_next_sx_n:setVisible(true)
    	local nextAttributes_info = zstring.split(nextAttributesData[5],"|")
    	for i=1, #attributes_info do
    		if tonumber(zstring.split(attributes_info[i],",")[2]) < tonumber(zstring.split(nextAttributes_info[i],",")[2]) then
                	local addTo = tonumber(zstring.split(nextAttributes_info[i],",")[2]) * 10000 - tonumber(zstring.split(attributes_info[i],",")[2]) * 10000
                	addTo = addTo / 10000
    			if i == 4 then
    				Text_next_sx:setString(cultivate_spirit_attributes_name[tonumber(self.groupID)*2-1])
    				Text_next_sx_n:setString("+"..addTo.."%")
    			elseif i == 5 then
    				Text_next_sx:setString(cultivate_spirit_attributes_name[tonumber(self.groupID)*2])
    				Text_next_sx_n:setString("+"..addTo.."%")
    			else
    				Text_next_sx:setString(cultivate_spirit_attributes_name[6+i])
    				Text_next_sx_n:setString("+"..addTo)
    			end
    			break
    		end
    	end
    end

    -- 是否武将限定卡显示
	local isLimitCard = false
	local Panel_card_animation = ccui.Helper:seekWidgetByName(root, "Panel_card_animation")
	local Panel_tag_animation = ccui.Helper:seekWidgetByName(root, "Panel_tag_animation")
	if Panel_card_animation and Panel_tag_animation then 
		Panel_card_animation:removeAllChildren(true)
		Panel_tag_animation:removeAllChildren(true)
        -- 限定卡边框动画
        DisplayLimitCard(ship_need_id[tonumber(index)] ,Panel_card_animation , 2)
        -- 限定卡标签显示
        DisplayLimitCard(ship_need_id[tonumber(index)] ,Panel_tag_animation , 3)
	end

    --形象图
    local Panel_digimon_big_head = ccui.Helper:seekWidgetByName(root,"Panel_digimon_big_head")
    Panel_digimon_big_head:removeAllChildren(true)
    
    local shipIcons = nil
    local evo_mould_id = 0
    local evo_image = dms.string(dms["ship_mould"], ship_need_id[tonumber(index)], ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    if selected_ship ~= nil then
        local ship_evo = zstring.split(selected_ship.evolution_status, "|")
        evo_mould_id = smGetSkinEvoIdChange(selected_ship)
        Panel_hgd_icon:setBackGroundImage(string.format("images/ui/text/SMJS_res/hgd/hgd_%d.png", _ED.digital_spirit_state_info[selected_ship.ship_id].stalls))
        ccui.Helper:seekWidgetByName(root,"Button_yjsl"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_hgjj"):setVisible(false)
    else
    	local captain_name = dms.int(dms["ship_mould"], ship_need_id[tonumber(index)], ship_mould.captain_name)
       	evo_mould_id = evo_info[captain_name]
       	Panel_hgd_icon:setBackGroundImage(string.format("images/ui/text/SMJS_res/hgd/hgd_%d.png", 0))
        ccui.Helper:seekWidgetByName(root,"Button_yjsl"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_hgjj"):setVisible(true)
    end
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        -- Sin spine en el paquete (sprite/spirte_<form_id>.json): SkeletonAnimation:create
        -- aborta con "Invalid skeleton JSON" y la ventana no llega a abrirse (Fury:
        -- heroes 367-371, mesas 41-44). Se deja el hueco sin figura.
        if cc.FileUtils:getInstance():isFileExist(string.format("sprite/spirte_%s.json", picIndex)) then
        local armature_hero = sp.spine_sprite(Panel_digimon_big_head, picIndex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
            Panel_digimon_big_head:removeAllChildren(true)
            Panel_digimon_big_head:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
        end
        armature_hero:setScaleX(-1)
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(armature_hero, true)
        end
        local Image_bg_lock = ccui.Helper:seekWidgetByName(root,"Image_bg_lock")
        if Image_bg_lock ~= nil then
            if selected_ship ~= nil then
                Image_bg_lock:setVisible(false)
            else
                Image_bg_lock:setVisible(true)
            end
        end
    else
        shipIcons = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", picIndex))
        shipIcons:setPosition(cc.p(Panel_digimon_big_head:getContentSize().width/2,Panel_digimon_big_head:getContentSize().height/2))
        Panel_digimon_big_head:addChild(shipIcons)
        if selected_ship ~= nil then
            display:ungray(shipIcons)
        else
            display:gray(shipIcons)
        end
    end
    local name_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local name = dms.string(dms["word_mould"], name_index, word_mould.text_info)
    self._ship_name = name

    local need_props = zstring.split(dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.need_props),"|")

    for i=1,3 do
    	local Image_hook = ccui.Helper:seekWidgetByName(root,"Image_hook_"..i)
    	Image_hook:setVisible(false)
    	if i == tonumber(index) then
    		Image_hook:setVisible(true)
    	end
    	--道具
    	local Image_prop_icon = ccui.Helper:seekWidgetByName(root,"Image_prop_icon_"..i)
        Image_prop_icon:removeAllChildren(true)
        local needPropInfo = zstring.split(need_props[i],",")
    	local cell = PropIconNewCell:createCell()
    	local props_number = tonumber(getPropAllCountByMouldId(needPropInfo[2]))
    	if props_number > 0 then
	    	cell:init(cell.enum_type._CUITIVATE_SPIRIT_USE, needPropInfo[2])
	    else
	    	cell:init(cell.enum_type._CUITIVATE_SPIRIT_USE, needPropInfo[2],false,true)
	    end
    	Image_prop_icon:addChild(cell)
    	--道具名称
    	local Text_prop_name = ccui.Helper:seekWidgetByName(root,"Text_prop_name_"..i)
    	Text_prop_name:setString(setThePropsIcon(needPropInfo[2])[2])
    end

    --好感度进度
    local LoadingBar_hgd = ccui.Helper:seekWidgetByName(root,"LoadingBar_hgd")
    local Text_hgd_n = ccui.Helper:seekWidgetByName(root,"Text_hgd_n")

    --好感等级
    local Text_hgd_lv = ccui.Helper:seekWidgetByName(root,"Text_hgd_lv")
    if selected_ship ~= nil then
    	Text_hgd_lv:setString("Lv.".._ED.digital_spirit_state_info[selected_ship.ship_id].level)
        local infos = dms.searchs(dms["ship_spirit_param"], ship_spirit_param.stalls, _ED.digital_spirit_state_info[selected_ship.ship_id].stalls)
        local needEXP = 0--dms.int(dms["ship_spirit_param"], _ED.digital_spirit_state_info[selected_ship.ship_id].level, ship_spirit_param.next_exp)
        for k,v in pairs(infos) do
            if tonumber(v[2]) == tonumber(_ED.digital_spirit_state_info[selected_ship.ship_id].level) then
                needEXP = tonumber(v[3])
                break
            end
        end
    	local persent = 0
    	if tonumber(_ED.digital_spirit_state_info[selected_ship.ship_id].level) > #infos then
    		persent = 100
    	else
    		persent = math.floor(tonumber(_ED.digital_spirit_state_info[selected_ship.ship_id].good_opinion)*100/needEXP)
    	end
	    Text_hgd_n:setString(_ED.digital_spirit_state_info[selected_ship.ship_id].good_opinion.."/"..needEXP)
	    LoadingBar_hgd:setPercent(persent)
    else
    	Text_hgd_lv:setString("Lv.0")
    	local needEXP = dms.int(dms["ship_spirit_param"], 1, ship_spirit_param.next_exp)
	    local persent = math.floor(0/needEXP*100)
	    Text_hgd_n:setString("0".."/"..needEXP)
	    LoadingBar_hgd:setPercent(persent)
    end
end


function SmCultivateSpiritAdd:playAnimations(sender, file)
    local jsonFile = file .. ".json"
    local atlasFile = file .. ".atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
    animation:setPosition(cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2))
    sender:addChild(animation)
end

function SmCultivateSpiritAdd:init(params)
	self.cell = params[1]
    self.index  = params[2]
	self.group = self.cell.index
	self:onInit()
    return self
end

function SmCultivateSpiritAdd:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_spirit_add.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
        protocol_command.education_change.param_list = "530"
        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
        end
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_cultivate_spirit_add_close", 
        terminal_state = 0,
        _myself = self,
        touch_black = true,
    }, nil, 3)

    local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], self.group, ship_spirit_group.ship_need_id),",")
    for i=1, 3 do
    	local Panel_digimon_head = ccui.Helper:seekWidgetByName(root,"Panel_digimon_head_"..i)
        fwin:addTouchEventListener(Panel_digimon_head, nil, 
        {
            terminal_name = "sm_cultivate_spirit_add_select_ships", 
            terminal_state = 0, 
            index = i,
        }, nil, 0)
    end

    --一键送礼
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_yjsl"), nil, 
    {
        terminal_name = "sm_cultivate_spirit_add_send_a_gift", 
        terminal_state = 0, 
        m_type = -1,
        m_batch = 1,
        touch_black = true,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hgjj"), nil, 
    {
        terminal_name = "sm_cultivate_spirit_add_send_a_gift", 
        terminal_state = 0, 
        m_type = -1,
        touch_black = true,
    }, nil, 0)
    

    local Button_pve_arrow_left = ccui.Helper:seekWidgetByName(root,"Button_pve_arrow_left")
    fwin:addTouchEventListener(Button_pve_arrow_left, nil, 
    {
        terminal_name = "sm_cultivate_spirit_add_left_page", 
        terminal_state = 0, 
    }, nil, 0)

    local Button_pve_arrow_right = ccui.Helper:seekWidgetByName(root,"Button_pve_arrow_right")
    fwin:addTouchEventListener(Button_pve_arrow_right, nil, 
    {
        terminal_name = "sm_cultivate_spirit_add_right_page", 
        terminal_state = 0, 
    }, nil, 0)
    local ship = fundShipWidthTemplateId(ship_need_id[tonumber(self.index)])
    if ship ~= nil then
    	local function requesrDefendCheck(response)
	        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
                response.node:drawSelectedObject(response.node.index)
	        end
	    end
	    protocol_command.ship_spirit_init.param_list = ship.ship_id
	    NetworkManager:register(protocol_command.ship_spirit_init.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
    else

        -- if __lua_project_id == __lua_project_l_digital then
        --     for i = 1, 3 do
        --         local shipMouldId = tonumber(ship_need_id[i])
        --         if isShowHeroCard(shipMouldId) == true then
        --             self.index = i
        --             break
        --         end
        --     end
        -- end

    	self:onUpdateDraw()
		self:drawSelectedObject(self.index)
    end
    local Panel_digimon_big_head_0 = ccui.Helper:seekWidgetByName(root,"Panel_digimon_big_head_0")
    if Panel_digimon_big_head_0 ~= nil then
        Panel_digimon_big_head_0:removeAllChildren(true)
        local jsonFile = "sprite/sprite_wzzz_dizuo.json"
        local atlasFile = "sprite/sprite_wzzz_dizuo.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation_2", true, nil)
        Panel_digimon_big_head_0:addChild(animation)
    end
end

function SmCultivateSpiritAdd:onEnterTransitionFinish()
    
end


function SmCultivateSpiritAdd:onExit()
    state_machine.remove("sm_cultivate_spirit_object_refush")
end

