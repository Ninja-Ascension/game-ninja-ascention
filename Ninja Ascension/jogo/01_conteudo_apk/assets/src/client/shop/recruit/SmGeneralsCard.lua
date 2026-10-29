-----------------------------
-- 武将信息的卡牌控件
-----------------------------
SmGeneralsCard = class("SmGeneralsCardClass", Window)

--打开界面
local sm_generals_card_open_terminal = {
	_name = "sm_generals_card_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmGeneralsCardClass") == nil then
			fwin:open(SmGeneralsCard:new():init(params))		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_generals_card_close_terminal = {
	_name = "sm_generals_card_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmGeneralsCardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--facebook分享
local share_click_on_terminal = {
    _name = "share_click_on",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if __lua_project_id == __lua_project_l_naruto then
            if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
            else
                handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
            end
        end

        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
            if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[2])
            else
                handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[1])
            end
        end

        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and app.configJson.ReleaseLanguage == "en" then
            if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
            else
                handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
            end
        end
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_generals_card_open_terminal)
state_machine.add(sm_generals_card_close_terminal)
state_machine.add(share_click_on_terminal)
state_machine.init()

function SmGeneralsCard:ctor()
	self.super:ctor()
	self.roots = {}

    local function init_sm_generals_card_terminal()
        local sm_generals_card_praise_terminal = {
            _name = "sm_generals_card_praise",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = nil
				if zstring.tonumber(instance.m_type) == -1 then
					ship = instance.ship_id.ship_template_id
				else
					if instance.isMould == true then
						ship = instance.ship_id
					else
						ship = _ED.user_ship[""..instance.ship_id].ship_template_id
					end
				end
				local picIndex_name = ""
				local evo_image = dms.string(dms["ship_mould"], ship, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				local evo_mould_id = 0
				if zstring.tonumber(instance.m_type) ~= -1 then
					if instance.isMould == true then
						evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship, ship_mould.captain_name)]
						if instance.bounty_hero_param_id ~= nil then
							local baseShip = fundShipWidthTemplateId(ship)
							if baseShip ~= nil then
								local ship_evo = zstring.split(baseShip.evolution_status, "|")
								evo_mould_id = evo_info[tonumber(ship_evo[1])]
							end
						end
					else
						local ship_evo = zstring.split(_ED.user_ship[""..instance.ship_id].evolution_status, "|")
						evo_mould_id = evo_info[tonumber(ship_evo[1])]
					end
				else
					evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship, ship_mould.captain_name)]
				end
				if _ED.new_reward_object and _ED.new_reward_object ~= nil and _ED.new_reward_object[1] and _ED.new_reward_object[1] ~= nil then
					if tonumber(_ED.new_reward_object[1].m_type) == 64 then
						evo_mould_id = dms.int(dms["ship_skin_mould"], tonumber(_ED.new_reward_object[1].mould_id), ship_skin_mould.ship_evo_id)
					end
				end
				
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
			    picIndex_name = word_info[3]

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:updateShipPraiseInfo(ship)
						end
						TipDlg.drawTextDailog(string.format(_new_interface_text[304], picIndex_name))
						state_machine.excute("hero_list_view_update_ship_praise_info", 0, nil)
					end
				end
				protocol_command.ship_praise.param_list = ship
				NetworkManager:register(protocol_command.ship_praise.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_generals_card_praise_terminal)
        state_machine.init()
    end
    init_sm_generals_card_terminal()
end

function SmGeneralsCard:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
	local Panel_20 = ccui.Helper:seekWidgetByName(root, "Panel_20")

	--动画或者静态图
	local Panel_digimon_big_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_big_icon")
	Panel_digimon_big_icon:removeAllChildren(true)
	local ship = nil
	if zstring.tonumber(self.m_type) == -1 then
		ship = self.ship_id.ship_template_id
	else
		if self.isMould == true then
			ship = self.ship_id
		else
			ship = _ED.user_ship[""..self.ship_id].ship_template_id
		end
	end
	-- 是否武将限定卡显示  限定卡边框
	local isLimitCard = false
	local Sprite_card_bg2 = Panel_20:getChildByName("Sprite_card_bg2")
	local Panel_effct_1 = ccui.Helper:seekWidgetByName(root, "Panel_effct_1")
	local Panel_effct_2 = ccui.Helper:seekWidgetByName(root, "Panel_effct_2")
	if Sprite_card_bg2 then 
		Panel_effct_1:removeAllChildren(true)
		Panel_effct_2:removeAllChildren(true)
		Sprite_card_bg2:setVisible(false)
		isLimitCard = DisplayLimitCard(ship ,Panel_effct_1 , 2)
		isLimitCard = DisplayLimitCard(ship ,Panel_effct_2 , 3)
	end
	--背景
    -- local Sprite_card_bg = ccui.Helper:seekWidgetByName(root, "Sprite_card_bg")
	local Sprite_card_bg = Panel_20:getChildByName("Sprite_card_bg")
	Sprite_card_bg:setVisible(false)
	local SpriteGaryBg = Sprite_card_bg
	if isLimitCard == true then
		Sprite_card_bg2:setVisible(true)
		SpriteGaryBg = Sprite_card_bg2
	else
		Sprite_card_bg:setVisible(true)
	end
	
    if self.isGrayed == true then
		display:gray(SpriteGaryBg)
	else
		display:ungray(SpriteGaryBg)
	end

	--进化形象
	local evo_image = dms.string(dms["ship_mould"], ship, ship_mould.fitSkillTwo)
	
	local evo_info = zstring.split(evo_image, ",")
	--进化模板id
	local evo_mould_id = nil
	if self.isMould == true then
		evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship, ship_mould.captain_name)]
		if self.bounty_hero_param_id ~= nil then
			local baseShip = fundShipWidthTemplateId(ship)
			if baseShip ~= nil then
				local ship_evo = zstring.split(baseShip.evolution_status, "|")
				evo_mould_id = smGetSkinEvoIdChange( baseShip )
			end
		end
	else
		if zstring.tonumber(self.m_type) == -1 then
			local ship_evo = zstring.split(_ED.other_user_ship.evolution_status, "|")
			evo_mould_id = evo_info[tonumber(ship_evo[1])]
			if _ED.other_user_ship.skin_id and zstring.tonumber(_ED.other_user_ship.skin_id) ~= 0 then
				evo_mould_id = dms.int(dms["ship_skin_mould"], _ED.other_user_ship.skin_id, ship_skin_mould.ship_evo_id)
			end
		else
			local ship_evo = zstring.split(_ED.user_ship[""..self.ship_id].evolution_status, "|")
			evo_mould_id = smGetSkinEvoIdChange( _ED.user_ship[""..self.ship_id] )
		end
	end
	if _ED.new_reward_object and _ED.new_reward_object ~= nil and _ED.new_reward_object[1] and _ED.new_reward_object[1] ~= nil then
		if tonumber(_ED.new_reward_object[1].m_type) == 64 then
			evo_mould_id = dms.int(dms["ship_skin_mould"], tonumber(_ED.new_reward_object[1].mould_id), ship_skin_mould.ship_evo_id)
		end
	end
	
	--新的形象编号
	local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	local ship_icon = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", temp_bust_index))
	if ship_icon ~= nil then
		ship_icon:setPosition(cc.p(Panel_digimon_big_icon:getContentSize().width/2,Panel_digimon_big_icon:getContentSize().height/2))
        Panel_digimon_big_icon:addChild(ship_icon)
        if self.isGrayed == true then
			display:gray(ship_icon)
		else
			display:ungray(ship_icon)
		end
	end

	--类型
	local Sprite_name_bar = Panel_20:getChildByName("Sprite_name_bar")
	local camp_preference = dms.int(dms["ship_mould"], ship, ship_mould.camp_preference)
	if camp_preference> 0 and camp_preference <=3 then
		Sprite_name_bar:setTexture(string.format("images/ui/icon/sm_type_bar_%d.png", camp_preference))
	end
	if self.isGrayed == true then
		display:gray(Sprite_name_bar)
	else
		display:ungray(Sprite_name_bar)
	end

	--名称
	local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
	local picIndex_name = nil
	--进化形象
	local evo_image = dms.string(dms["ship_mould"], ship, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	--进化模板id
	-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
	local evo_mould_id = 0
	if zstring.tonumber(self.m_type) ~= -1 then
		if self.isMould == true then
			evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship, ship_mould.captain_name)]	
			if self.bounty_hero_param_id ~= nil then
				local baseShip = fundShipWidthTemplateId(ship)
				if baseShip ~= nil then
					local ship_evo = zstring.split(baseShip.evolution_status, "|")
					evo_mould_id = smGetSkinEvoIdChange( baseShip )
				end
			end
		else
			local ship_evo = zstring.split(_ED.user_ship[""..self.ship_id].evolution_status, "|")
			evo_mould_id = smGetSkinEvoIdChange( _ED.user_ship[""..self.ship_id] )
		end
	else
		local ship_evo = zstring.split(_ED.other_user_ship.evolution_status, "|")
		evo_mould_id = evo_info[tonumber(ship_evo[1])]
		if _ED.other_user_ship.skin_id and zstring.tonumber(_ED.other_user_ship.skin_id) ~= 0 then
			evo_mould_id = dms.int(dms["ship_skin_mould"], _ED.other_user_ship.skin_id, ship_skin_mould.ship_evo_id)
		end
	end

	if _ED.new_reward_object and _ED.new_reward_object ~= nil and _ED.new_reward_object[1] and _ED.new_reward_object[1] ~= nil then
		if tonumber(_ED.new_reward_object[1].m_type) == 64 then
			evo_mould_id = dms.int(dms["ship_skin_mould"], tonumber(_ED.new_reward_object[1].mould_id), ship_skin_mould.ship_evo_id)
		end
	end

	local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	local word_info = dms.element(dms["word_mould"], name_mould_id)
    picIndex_name = word_info[3]
    if self.isMould == false then
    	if zstring.tonumber(self.m_type) == -1 then
    		if getShipNameOrder(tonumber(_ED.other_user_ship.Order)) > 0 then
		        picIndex_name = picIndex_name.." +"..getShipNameOrder(tonumber(_ED.other_user_ship.Order))
		    end
		    local quality = shipOrEquipSetColour(tonumber(_ED.other_user_ship.Order))-1
		    Text_digimon_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
    	else
		    if getShipNameOrder(tonumber(_ED.user_ship[""..self.ship_id].Order)) > 0 then
		        picIndex_name = picIndex_name.." +"..getShipNameOrder(tonumber(_ED.user_ship[""..self.ship_id].Order))
		    end
		    local quality = shipOrEquipSetColour(tonumber(_ED.user_ship[""..self.ship_id].Order))-1
		    Text_digimon_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		end
	end
	-- local colortype = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id),ship_mould.ship_type)
	Text_digimon_name:setString(picIndex_name)

	--星星
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	Panel_star:removeAllChildren(true)
	if self.isMould == false then
		if zstring.tonumber(self.m_type) == -1 then
			neWshowShipStarTwo(Panel_star,tonumber(_ED.other_user_ship.StarRating))
		else
			if self.showStar ~= 0 then
				neWshowShipStarTwo(Panel_star, self.showStar)
			elseif self.bounty_hero_param_id ~= nil then
				local star = dms.int(dms["ship_mould"], self.bounty_hero_param_id, ship_mould.ship_star)
				neWshowShipStarTwo(Panel_star, star)
			else
				neWshowShipStarTwo(Panel_star,tonumber(_ED.user_ship[""..self.ship_id].StarRating))
			end
		end
	else
		local star = dms.int(dms["ship_mould"], ship, ship_mould.ship_star)
		if self.bounty_hero_param_id ~= nil then
			local rewards = dms.string(dms["bounty_hero_param"], self.bounty_hero_param_id, bounty_hero_param.rewards)
			if rewards ~= nil then
				rewards = zstring.split(rewards, ",")
				if zstring.tonumber(rewards[4]) > 0 then
					star = zstring.tonumber(rewards[4])
				end
			end
		end
		if self.showStar ~= 0 then
			star = self.showStar
		end
		neWshowShipStarTwo(Panel_star,star)
	end
	self:updateShipPraiseInfo(ship)
end


function SmGeneralsCard:playAnimations(sender, file)
    local jsonFile = file .. ".json"
    local atlasFile = file .. ".atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
    animation:setPosition(cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2))
    sender:addChild(animation)
end

function SmGeneralsCard:updateShipPraiseInfo( ship_id )
	local root = self.roots[1]
	local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	if Panel_1 ~= nil then
		local Text_good = ccui.Helper:seekWidgetByName(root, "Text_good")
		local ArmatureNode_1 = Panel_1:getChildByName("ArmatureNode_1")
		local Panel_good = ccui.Helper:seekWidgetByName(root, "Panel_good")
		ArmatureNode_1:setVisible(true)
		Panel_good:setVisible(false)
		if _ED.user_ship_praise_rank_list ~= nil 
			and _ED.user_ship_praise_rank_list[""..ship_id] ~= nil
			then
			local rank = tonumber(_ED.user_ship_praise_rank_list[""..ship_id].rank)
			if rank <= 10 then
				Text_good:setString(_ED.user_ship_praise_rank_list[""..ship_id].count.."(NO."..rank..")")
			else
				Text_good:setString(_ED.user_ship_praise_rank_list[""..ship_id].count)
			end
		else
			Text_good:setString("0")
		end
		if _ED.user_ship_praise_state_info ~= nil then
			for k,v in pairs(_ED.user_ship_praise_state_info) do
				if tonumber(v) == tonumber(ship_id) then
					ArmatureNode_1:setVisible(false)
					Panel_good:setVisible(true)
					ccui.Helper:seekWidgetByName(root, "Image_good"):setTouchEnabled(false)
					break
				end
			end
		end
	end
end

function SmGeneralsCard:init(params)
	--1，父亲，2，是否灰，3，是否话动画,4,卡牌的id, 5,是否是模板id
	local rootWindow = params[1]
    self._rootWindows = rootWindow    
    self.isGrayed = params[2]
    self.isAnimation = params[3]
    self.ship_id = params[4]
    --self.ship_id = 120
    self.isMould = params[5]
    self.m_type = params[6] or nil
    self.bounty_hero_param_id = params[7]
    self.showStar = params[8] or 0
	self:onInit()
    return self
end

function SmGeneralsCard:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/sm_generals_card.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_good"), nil, 
	{
		terminal_name = "sm_generals_card_praise", 	
		terminal_state = 0,
		isPressedActionEnabled = true
	},	
	nil, 0)

    self:onUpdateDraw()
end

function SmGeneralsCard:onEnterTransitionFinish()
    
end

function SmGeneralsCard:onExit()
	state_machine.remove("sm_generals_card_praise")
	_ED.new_reward_object = {}
	_ED.new_prop_object = {}
end

