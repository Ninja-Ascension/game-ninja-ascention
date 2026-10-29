-- ----------------------------------------------------------------------------------------------------
-- 说明：商店宝箱招募成功界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TreasureChestOfferSuccess = class("TreasureChestOfferSuccessClass", Window)
    
function TreasureChestOfferSuccess:ctor()
    self.super:ctor()
	app.load("client.cells.ship_picture_cell_ten")
	app.load("client.cells.prop.sm_packs_cell")
	app.load("client.cells.ship.ship_head_new_cell")
	app.load("client.shop.recruit.SmGeneralsCard")
	app.load("client.cells.utils.resources_icon_cell")
	self.roots = {}
	self.zhanjiangling = 0
	self.ship = nil
	self.ranking = 0
	self.mIndex = 0
	self.HeronumberGod = 0

	self.play_types = 0
	self.hero_state = false
	self.hero_animation = nil
    -- Initialize TreasureChestOfferSuccess page state machine.
    local function init_TreasureChestOfferSuccess_terminal()
		--返回招募预览界面
		local treasure_chest_offer_success_renturn_shop_page_terminal = {
            _name = "treasure_chest_offer_success_renturn_shop_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.unlock("sm_shop_chest_store_view_a_recruiting")
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--再招一次
		local shop_hero_page_chick_recruit_onee_terminal = {
            _name = "shop_hero_page_chick_recruit_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	_ED.new_prop_object = {}
            	_ED.new_reward_object = {}
				_ED.recruit_success_ship_id = nil
				if TipDlg.drawStorageTipo() == false then
					 _ED.recruit_success_ship_id = nil
					local _goldNumber = tonumber(dms.string(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold))
					local function recruitCallBack(response)
						if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and params.status ~= nil then
							state_machine.excute("use_diamond_confirm_tip_close",0,"")
						end
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}
                            end
							local obj = TreasureChestOfferSuccess:new()
							obj:setRanking(self.ranking,self.mIndex)
							fwin:close(instance)
							fwin:open(obj,fwin._ui)
							state_machine.excute("sm_shop_chest_store_view_update_consume",0,"sm_shop_chest_store_view_update_consume.")
							state_machine.excute("sm_shop_chest_store_update_debris_count", 0, "")
						end
						_ED.prop_chest_store_recruiting = false
					end
					_ED.prop_chest_store_recruiting = true
					protocol_command.ship_bounty.param_list = ""..self.mIndex
					NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				end
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
		
		state_machine.add(shop_hero_page_chick_recruit_onee_terminal)
		state_machine.add(treasure_chest_offer_success_renturn_shop_page_terminal)
		state_machine.add(treasure_chest_offer_success_play_hero_animation_terminal)
		state_machine.add(share_click_on_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_TreasureChestOfferSuccess_terminal()
end

function TreasureChestOfferSuccess:setRanking(ranking,mIndex,isPlay)
	self.ranking = ranking
	self.mIndex = mIndex
	self.isPlay = isPlay or nil
end

function TreasureChestOfferSuccess:ShowUI()
	local csbTreasureChestOfferSuccess = csb.createNode("shop/recruit_settlement_ten.csb")
	local csbTreasureChestOfferSuccess_root = csbTreasureChestOfferSuccess:getChildByName("root")
	local action = csb.createTimeline("shop/recruit_settlement_ten.csb")
	table.insert(self.roots, csbTreasureChestOfferSuccess_root)
	self:addChild(csbTreasureChestOfferSuccess)
	--ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(false)

	local Panel_consume_icon = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Panel_consume_icon")
	Panel_consume_icon:removeBackGroundImage()
	--Panel_consume_icon:setBackGroundImage("images/ui/icon/zuanshi.png")
	local Label_36610 = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Label_36610")
	local key_mouldId = dms.int(dms["shop_config"] , 8 , shop_config.param)
    local key_number = tonumber(getPropAllCountByMouldId(key_mouldId))
    local everyDayFreeTime = tonumber(_ED.free_info[3].surplus_free_number) or 0
    Panel_consume_icon:setVisible(true)
    if everyDayFreeTime > 0 then
    	Panel_consume_icon:setVisible(false)
        Label_36610:setString(_new_interface_text[16])
    elseif key_number == 0 then
        Panel_consume_icon:setBackGroundImage("images/ui/icon/zuanshi.png")
        Label_36610:setString(dms.int(dms["partner_bounty_param"],10,partner_bounty_param.spend_gold))
    else
        Panel_consume_icon:setBackGroundImage("images/ui/text/shop/zbbxys.png")
        Label_36610:setString(key_number.."/1")
	end
	
	-- DSC重塑
	local Text_points = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Text_points")
	if __lua_project_id == __lua_project_l_digital and Text_points then
		Text_points:setVisible(false)
	end

    local Text_name = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Text_name")
	local Panel_icon = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Panel_icon")
	Panel_icon:removeAllChildren(true)
	-- O servidor local nao retorna um personagem nesse sorteio. Limpe o ID
	-- anterior do login para o CSB nao abrir o Naruto de demonstracao.
	local isMudraReward = _ED.new_reward_object and _ED.new_reward_object[1]
		and tonumber(_ED.new_reward_object[1].m_type) == 66
	if isMudraReward then
		_ED.recruit_success_ship_id = 0
	end
	-- local size = Panel_icon:getContentSize()
	-- local panel_zhedang = ccui.Layout:create()
	-- panel_zhedang:setSwallowTouches(true)
	-- panel_zhedang:setTouchEnabled(true)
	-- panel_zhedang:setContentSize(cc.size(size.width, size.height))
	-- panel_zhedang:setAnchorPoint(cc.p(Panel_icon:getAnchorPoint().x, Panel_icon:getAnchorPoint().y))

	if tonumber(_ED.new_reward_object[1].m_type) == 6 then
		--道具
		local prop = _ED.user_prop["".._ED.new_reward_object[1].mould_id]

		local cell = ResourcesIconCell:createCell()
        cell:init(6, _ED.new_reward_object[1].number, prop.user_prop_template, nil, nil, false, true, 1)
        Panel_icon:addChild(cell)
		
		local prop_name = setThePropsIcon(prop.user_prop_template)[2]
		Text_name:setString(prop_name)
		local quality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)+1
		Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     
	elseif tonumber(_ED.new_reward_object[1].m_type) == 7 then
		--装备
		local equip = _ED.user_equiment["".._ED.new_reward_object[1].mould_id]

		local cell = ResourcesIconCell:createCell()
        cell:init(7, _ED.new_reward_object[1].number, equip.user_equiment_template, nil, nil, false, true, 1)
        Panel_icon:addChild(cell)
		
		--获取装备名称索引
		local nameindex = dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.equipment_name)
		--通过索引找到word_mould
		local word_info = dms.element(dms["word_mould"], nameindex)
		local name = word_info[3]
		--绘制
		Text_name:setString(name)
		local qua = shipOrEquipSetColour(0)
		local trace_npc_index = dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.trace_npc_index)
		if trace_npc_index > 0 then
			qua = trace_npc_index + 1
		end
		Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[qua][1],tipStringInfo_quality_color_Type[qua][2],tipStringInfo_quality_color_Type[qua][3]))
	elseif tonumber(_ED.new_reward_object[1].m_type) == 1 then
		local cell = ResourcesIconCell:createCell()
        cell:init(_ED.new_reward_object[1].m_type, tonumber(_ED.new_reward_object[1].number), -1,nil,nil,false,true,1)
		Panel_icon:addChild(cell)
		local quality = 3
		Text_name:setString(_All_tip_string_info._fundName)
		Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     
	elseif tonumber(_ED.new_reward_object[1].m_type) == 66 then
		-- Mudra: o sorteio 1x tambem devolve uma peca Alloy Matrix (14112).
		-- Use o mesmo modelo e nome da tela HeroRecruitSuccess.
		local metal = _ED.user_alloy_matrix[tonumber(_ED.new_reward_object[1].mould_id)]
		if metal then
			local metal_mould = tonumber(metal.metalMould)
			local cell = ResourcesIconCell:createCell()
			cell:init(66, 1, metal_mould, nil, nil, true, true, 1)
			Panel_icon:addChild(cell)
			local name_index = dms.int(dms["ship_metal_mould"], metal_mould, ship_metal_mould.name)
			local word_info = dms.element(dms["word_mould"], name_index)
			Text_name:setString(word_info[3])
			local quality = dms.int(dms["ship_metal_mould"], metal_mould, ship_metal_mould.quality) + 1
			Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3]))
		end
	else
	end
	-- O CSB desta janela reutiliza um painel de demonstração com Naruto.
	-- A animação "window_open" altera a visibilidade desse painel, portanto
	-- escondê-lo apenas antes da animação não basta.
	local heroInfoPanel = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Panel_23")
	local heroInfoRoot = heroInfoPanel:getChildByName("ProjectNode_1"):getChildByName("root")
	local function hideHeroSample()
		if not isMudraReward then
			return
		end
		-- A timeline reativa o painel pai inteiro, nao apenas o root do ProjectNode.
		heroInfoPanel:setVisible(false)
		heroInfoRoot:setVisible(false)
		local touchPanel = ccui.Helper:seekWidgetByName(heroInfoRoot, "Panel_lwj_2")
		if touchPanel then
			touchPanel:setSwallowTouches(false)
			touchPanel:setTouchEnabled(false)
		end
	end
	local function keepHeroSampleHidden()
		if not isMudraReward then
			return
		end
		local scheduler = cc.Director:getInstance():getScheduler()
		local ticks = 0
		local entry
		entry = scheduler:scheduleScriptFunc(function()
			if fwin:find("TreasureChestOfferSuccessClass") == nil then
				scheduler:unscheduleScriptEntry(entry)
				return
			end
			hideHeroSample()
			ticks = ticks + 1
			if ticks >= 40 then
				scheduler:unscheduleScriptEntry(entry)
			end
		end, 0.05, false)
	end
	-- Mantém o exemplar oculto durante a sequência de abertura, inclusive nos
	-- quadros em que a timeline volta a aplicar o estado gravado no CSB.
	hideHeroSample()
	if self.isPlay ~= nil and self.isPlay == true then
		playEffect(formatMusicFile("effect", 9983))
		local function changeActionCallback( armatureBack ) 
			-- DSC重塑
			if __lua_project_id == __lua_project_l_digital then 
				ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Panel_36549_1"):setVisible(true)
			end
			ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Panel_icon"):setVisible(true)
			ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Text_name"):setVisible(true)
			ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root,"Panel_yc"):setVisible(true)
			action:play("window_open", false)
			hideHeroSample()
			keepHeroSampleHidden()
			armatureBack:removeFromParent(true)
			if zstring.tonumber(_ED.recruit_success_ship_id) == 0 then
				playEffect(formatMusicFile("effect", 9988))
			else
				playEffect(formatMusicFile("effect", 9982))
			end
		end
		-- DSC重塑
		if __lua_project_id == __lua_project_l_digital then 
			ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Panel_36549_1"):setVisible(false)
		end
		ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Panel_icon"):setVisible(false)
		ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Text_name"):setVisible(false)
		local Panel_zhaomu_open = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root,"Panel_zhaomu_open")
		Panel_zhaomu_open:removeAllChildren(true)
		local jsonFile = "sprite/sprite_baoxiang_2.json"
		local atlasFile = "sprite/sprite_baoxiang_2.atlas"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "box_open", true, nil)
		animation.animationNameList = {"box_open"}
		sp.initArmature(animation, false)
		animation._invoke = changeActionCallback
		Panel_zhaomu_open:addChild(animation)
		animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		csb.animationChangeToAction(animation, 0, 0, false)
	else
		ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root,"Panel_yc"):setVisible(true)
		action:play("window_open", false)
		hideHeroSample()
		keepHeroSampleHidden()
		if zstring.tonumber(_ED.recruit_success_ship_id) == 0 then
			playEffect(formatMusicFile("effect", 9988))
		else
			playEffect(formatMusicFile("effect", 9982))
		end
	end
	-- action:play("window_open", false)
	csbTreasureChestOfferSuccess:runAction(action)

	local Panel_head_card = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root,"Panel_card_icon")
	local Panel_bg = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root,"Panel_bg")
	Panel_bg:removeAllChildren(true)

	hideHeroSample()
	ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Image_12"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccess_root, "Image_12"):setTouchEnabled(false)
end

--获取用户招募完成后的信息更新
function TreasureChestOfferSuccess:UserInitInfo()
	
end


function TreasureChestOfferSuccess:onEnterTransitionFinish()
	self:ShowUI()
	self:UserInitInfo()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_36550"), nil, 
			{
			terminal_name = "shop_hero_page_chick_recruit_one", 
			terminal_state = self.ranking, 
			touch_scale = true,
			isPressedActionEnabled = true
			},
			nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_36551"), nil, {
		terminal_name = "treasure_chest_offer_success_renturn_shop_page", 
		terminal_state = 0,
		touch_scale = true,
		isPressedActionEnabled = true
		}, nil, 2)

	if ccui.Helper:seekWidgetByName(self.roots[1], "Button_show") ~= nil then
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setTouchEnabled(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"), nil, {
			terminal_name = "share_click_on", 
			terminal_state = 0
			}, nil, 2)
	end

	if ccui.Helper:seekWidgetByName(self.roots[1], "Button_show") ~= nil then
        if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
            ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(false)
        end
    end
end

function TreasureChestOfferSuccess:onExit()
	-- state_machine.remove("treasure_chest_offer_success_renturn_shop_page")
	-- state_machine.remove("shop_hero_page_chick_recruit_one")
	-- state_machine.remove("hero_purple_close")
	-- state_machine.remove("check_information_hero_shop")
end

function TreasureChestOfferSuccess:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
          sp.SkeletonRenderer:clear()
    end     
    cacher.removeAllTextures()     
    audioUtilUncacheAll() 
end
