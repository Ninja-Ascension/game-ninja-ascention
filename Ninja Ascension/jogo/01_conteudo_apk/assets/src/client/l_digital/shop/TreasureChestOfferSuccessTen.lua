-- ----------------------------------------------------------------------------------------------------
-- 说明：商店宝箱招募十次成功界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TreasureChestOfferSuccessTen = class("TreasureChestOfferSuccessTenClass", Window)
    
function TreasureChestOfferSuccessTen:ctor()
    self.super:ctor()
	app.load("client.cells.ship_picture_ten_cell")
	app.load("client.cells.prop.sm_packs_cell")
	app.load("client.cells.ship.ship_head_new_cell")
	app.load("client.shop.recruit.SmGeneralsCard")
	app.load("client.cells.utils.resources_icon_cell")
	self.roots = {}
	self.ship = {}
	self.ranking = 0
	self.mIndex = 0
	self.zhanjiangling = 0
	self.HeronumberGod = 0
	self.ShipIndex = 0
	self.heroIndex = 1
	self.number = 0 
	self.hero_animations = {}
	self.recruitment_data = {}

	-- 如果加速的话直接跳过动画
	self.bSpeedUp = false

    -- Initialize TreasureChestOfferSuccessTen page state machine.
    local function init_TreasureChestOfferSuccessTen_terminal()
		--返回招募预览界面
		local treasure_chest_offer_success_ten_renturn_shop_page_terminal = {
            _name = "treasure_chest_offer_success_ten_renturn_shop_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.unlock("sm_shop_chest_store_view_ten_recruiting")
            	state_machine.excute("sm_shop_chest_store_view_update_consume", 0, nil)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--招募十次
		local shop_hero_page_chick_recruit_ten_terminal = {
            _name = "shop_hero_page_chick_recruit_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	_ED.new_prop_object = {}
            	_ED.new_reward_object = {}
				local function tenrecruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                            then
                            getSceneReward(64)
                            _ED.show_reward_list_group_ex = {}
                        end
						local obj = TreasureChestOfferSuccessTen:new()
						obj:setRanking(self.ranking,self.mIndex)
						fwin:close(instance)
						fwin:open(obj,fwin._ui)
						state_machine.excute("sm_shop_chest_store_update_debris_count", 0, "")
					end
					_ED.prop_chest_store_recruiting = false
				end
				_ED.prop_chest_store_recruiting = true
				protocol_command.ship_batch_bounty.param_list =""..self.mIndex
				NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, tenrecruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local treasure_chest_offer_success_ten_open_new_show_action_special_terminal = {
            _name = "treasure_chest_offer_success_ten_open_new_show_action_special",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance == nil then
            		return
            	end
				local mPanel_32 = params._datas._Panel_32
				mPanel_32:setTouchEnabled(false)
				mPanel_32:setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_yc"):setVisible(true)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        
        local treasure_chest_offer_success_ten_speedup_terminal = {
            _name = "treasure_chest_offer_success_ten_speedup",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance == nil then
            		return
            	end
				instance.bSpeedUp = true
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
		
		state_machine.add(treasure_chest_offer_success_ten_renturn_shop_page_terminal)
		state_machine.add(shop_hero_page_chick_recruit_ten_terminal)
		state_machine.add(treasure_chest_offer_success_ten_open_new_show_action_special_terminal)
		state_machine.add(treasure_chest_offer_success_ten_speedup_terminal)
		state_machine.add(share_click_on_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_TreasureChestOfferSuccessTen_terminal()
end

function TreasureChestOfferSuccessTen:setRanking(ranking,mIndex,isplay)
	self.ranking = ranking
	
	self.mIndex = mIndex

	self.isplay = isplay or nil

	self.hero_animations = {}
	self.recruitment_data = {}
	
	self.number = 10
end

function TreasureChestOfferSuccessTen:openNewShowAction()
	local root = self.roots[1]
	local heroImage = ccui.Helper:seekWidgetByName(root,"Panel_head_icon_"..self.heroIndex)
	heroImage:removeAllChildren(true)
	if tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 6 then
		-- -- --道具
		local prop = _ED.user_prop[""..self.recruitment_data[tonumber(self.heroIndex)].random]
		local cell = ResourcesIconCell:createCell()
        cell:init(self.recruitment_data[tonumber(self.heroIndex)].m_type, tonumber(self.recruitment_data[tonumber(self.heroIndex)].number), prop.user_prop_template, nil, nil, false, true, 1)
        heroImage:addChild(cell)

	elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 7 then
		--装备
		local equip = _ED.user_equiment[""..self.recruitment_data[tonumber(self.heroIndex)].random]

		local cell = ResourcesIconCell:createCell()
        cell:init(self.recruitment_data[tonumber(self.heroIndex)].m_type, tonumber(self.recruitment_data[tonumber(self.heroIndex)].number), equip.user_equiment_template, nil, nil, false, true, 1)
        heroImage:addChild(cell)

	elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 1 then
		--钱
		local cell = ResourcesIconCell:createCell()
        cell:init(self.recruitment_data[tonumber(self.heroIndex)].m_type, tonumber(self.recruitment_data[tonumber(self.heroIndex)].number), -1, nil, nil, false, true, 1)
        -- cell:setPosition(cc.p(cell:getPositionX(),cell:getPositionY()))
        heroImage:addChild(cell)
	elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 66 then
		-- Mudra: a 1x draw uses the same reward-list screen as batch draws.
		local metal = _ED.user_alloy_matrix[tonumber(self.recruitment_data[tonumber(self.heroIndex)].random)]
		if metal then
			local cell = ResourcesIconCell:createCell()
			cell:init(66, tonumber(self.recruitment_data[tonumber(self.heroIndex)].number) or 1,
				metal.metalMould, nil, nil, false, true, 1)
			heroImage:addChild(cell)
		end
	end

	local action = csb.createTimeline("shop/recruit_settlement_animation.csb")
	action:play("window_open_hero_"..self.heroIndex, false)

	
	root:runAction(action)
	-- Saltar la animacion (tocar la pantalla) NO puede depender de que el
	-- motor aplique el frame final: con setTimeSpeed x100 cada tick avanza
	-- ~100 frames, se pasa del final sin aplicarlo, "hero_open_over" no llega
	-- y la ventana se queda sin botones (Panel_15 nunca se muestra).
	-- Ahora se salta al frame final y, si el evento no ha llegado, se lanza a mano.
	local heroOpenOver = false
	local function onFrameEvent(frame)
	-- playEffect(formatMusicFile("effect", 9988))
	if nil == frame then
		return
	end

	local str = frame:getEvent()
	if str == "hero_open_over" then
		if heroOpenOver == true then
			return
		end
		heroOpenOver = true
	end
	if str == "hero_open_over" then
		playEffect(formatMusicFile("effect", 9988))
		if self.heroIndex < self.number then
			local name = ccui.Helper:seekWidgetByName(root,"Text_hero_name_"..self.heroIndex)
			if tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 6 then
				local prop_mould_id = _ED.user_prop[""..self.recruitment_data[tonumber(self.heroIndex)].random].user_prop_template
				local prop_name = setThePropsIcon(prop_mould_id)[2]
				name:setString(prop_name)
				local quality = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.prop_quality)+1
				name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     

			elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 7 then
				--获取装备名称索引
				local nameindex = dms.int(dms["equipment_mould"], _ED.user_equiment[""..self.recruitment_data[tonumber(self.heroIndex)].random].user_equiment_template, equipment_mould.equipment_name)
				--通过索引找到word_mould
				local word_info = dms.element(dms["word_mould"], nameindex)
				local names = word_info[3]
				--绘制
				name:setString(names)
				local qua = shipOrEquipSetColour(0)
				local trace_npc_index = dms.int(dms["equipment_mould"], _ED.user_equiment[""..self.recruitment_data[tonumber(self.heroIndex)].random].user_equiment_template, equipment_mould.trace_npc_index)
				if trace_npc_index > 0 then
					qua = trace_npc_index + 1
				end
				name:setColor(cc.c3b(tipStringInfo_quality_color_Type[qua][1],tipStringInfo_quality_color_Type[qua][2],tipStringInfo_quality_color_Type[qua][3]))
			elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 1 then
				local quality = 3
				name:setString(_All_tip_string_info._fundName)
				name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     
			elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 66 then
				local metal = _ED.user_alloy_matrix[tonumber(self.recruitment_data[tonumber(self.heroIndex)].random)]
				if metal then
					local nameIndex = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.name)
					local word = dms.element(dms["word_mould"], nameIndex)
					name:setString(word[3])
					local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality) + 1
					name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
				end
			else
				--self:openNewShowActionSpecial()
			end
			self.heroIndex = self.heroIndex + 1
			self:openNewShowAction()
		else
			local name = ccui.Helper:seekWidgetByName(root,"Text_hero_name_"..self.heroIndex)
			if tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 6 then
				local prop_mould_id = _ED.user_prop[""..self.recruitment_data[tonumber(self.heroIndex)].random].user_prop_template
				local prop_name = setThePropsIcon(prop_mould_id)[2]
				name:setString(prop_name)
				local quality = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.prop_quality)+1
				name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     
			elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 7 then
				--获取装备名称索引
				local nameindex = dms.int(dms["equipment_mould"], _ED.user_equiment[""..self.recruitment_data[tonumber(self.heroIndex)].random].user_equiment_template, equipment_mould.equipment_name)
				--通过索引找到word_mould
				local word_info = dms.element(dms["word_mould"], nameindex)
				local names = word_info[3]
				--绘制
				name:setString(names)
				local qua = shipOrEquipSetColour(0)
				local trace_npc_index = dms.int(dms["equipment_mould"], _ED.user_equiment[""..self.recruitment_data[tonumber(self.heroIndex)].random].user_equiment_template, equipment_mould.trace_npc_index)
				if trace_npc_index > 0 then
					qua = trace_npc_index + 1
				end
				name:setColor(cc.c3b(tipStringInfo_quality_color_Type[qua][1],tipStringInfo_quality_color_Type[qua][2],tipStringInfo_quality_color_Type[qua][3]))
			elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 1 then
				local quality = 3
				name:setString(_All_tip_string_info._fundName)
				name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     
			elseif tonumber(self.recruitment_data[tonumber(self.heroIndex)].m_type) == 66 then
				local metal = _ED.user_alloy_matrix[tonumber(self.recruitment_data[tonumber(self.heroIndex)].random)]
				if metal then
					local nameIndex = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.name)
					local word = dms.element(dms["word_mould"], nameIndex)
					name:setString(word[3])
					local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality) + 1
					name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
				end
			end
			ccui.Helper:seekWidgetByName(root,"Panel_15"):setVisible(true)
			-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_15"), nil, {terminal_name = "treasure_chest_offer_success_ten_renturn_shop_page", terminal_state = 0}, nil, 0)
		end
	elseif str == "close" then
	end
	end
	-- EL SALTO VA EN EL TICK SIGUIENTE, NUNCA DENTRO DE OTRO BUCLE DE FRAMES
	-- (2026-09-30, iconos que desaparecian al tocar para saltar la tirada).
	-- gotoFrameAndPause emite "hero_open_over" mientras recorre las lineas de
	-- tiempo; el manejador abria ya el hueco siguiente (y ese el siguiente) y,
	-- al volver, el action de fuera terminaba de aplicar SU frame a los huecos
	-- de despues: Panel_head_icon_N volvia a su primer fotograma (446,580),
	-- arriba sobre el titulo, a media escala y girado, y la casilla se quedaba
	-- con el nombre y sin icono. Aqui se salta sin escuchar eventos y el evento
	-- se lanza a mano con el frame final ya aplicado.
	if self.bSpeedUp == true then
		root:runAction(cc.CallFunc:create(function()
			action:gotoFrameAndPause(action:getEndFrame())
			action:setFrameEventCallFunc(onFrameEvent)
			if heroOpenOver == false then
				onFrameEvent({getEvent = function() return "hero_open_over" end})
			end
		end))
	else
		action:setFrameEventCallFunc(onFrameEvent)
	end
end

function RandFetch(list,num,poolSize,pool) -- list 存放筛选结果，num 筛取个数，poolSize 筛取源大小，pool 筛取源
    pool = pool or {}
    math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)))
    for i=1,num do
        local rand = math.random(i,poolSize)
        local tmp = pool[rand] or rand -- 对于第二个池子，序号跟id号是一致的
        pool[rand] = pool[i] or i
        pool[i] = tmp

        table.insert(list, tmp)
    end
end

function TreasureChestOfferSuccessTen:ShowUI()
	local csbTreasureChestOfferSuccessTen = csb.createNode("shop/recruit_settlement_animation.csb")
	local csbTreasureChestOfferSuccessTen_root = csbTreasureChestOfferSuccessTen:getChildByName("root")
	table.insert(self.roots, csbTreasureChestOfferSuccessTen_root)
	self:addChild(csbTreasureChestOfferSuccessTen)
	--把道具数据和武将数据合在一个数组里

	for i=1,#_ED.new_reward_object do
		local m_datas = {}
		m_datas.m_type = tonumber(_ED.new_reward_object[i].m_type) 
		m_datas.random = tonumber(_ED.new_reward_object[i].mould_id) 
		m_datas.number = tonumber(_ED.new_reward_object[i].number)
		if m_datas.m_type == 66 and m_datas.number == nil then
			m_datas.number = 1
		end
		table.insert(self.recruitment_data, m_datas)
	end
	--随机打乱数组
	local lists = self.recruitment_data
	local lists_two = {}
	RandFetch(lists_two,#lists,#lists,lists)
	self.recruitment_data = lists_two
	-- Keep normal 10x/50x behavior, but let the Mudra 1x caller display its one result.
	if self.number == 1 then
		self.number = #self.recruitment_data
	end

	if self.isplay ~= nil and self.isplay == true then
		playEffect(formatMusicFile("effect", 9983))
		local function changeActionCallback( armatureBack ) 
			ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccessTen_root,"Panel_yc"):setVisible(true)
			self:openNewShowAction()
			armatureBack:removeFromParent(true)
		end
		ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccessTen_root,"Panel_yc"):setVisible(false)
		local Panel_zhaomu_open = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccessTen_root,"Panel_zhaomu_open")
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
		self:openNewShowAction()
	end
	local Panel_consume_icon = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccessTen_root,"Panel_consume_icon")
	Panel_consume_icon:removeBackGroundImage()
	local Label_36610 = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccessTen_root,"Label_36610")
	
	local key_mouldId = dms.int(dms["shop_config"] , 8 , shop_config.param)
    local key_number = tonumber(getPropAllCountByMouldId(key_mouldId))
    if key_number >= 10 then
        Panel_consume_icon:setBackGroundImage("images/ui/text/shop/zbbxys.png")
        Label_36610:setString(key_number.."/10")
    else
        Panel_consume_icon:setBackGroundImage("images/ui/icon/zuanshi.png")
        Label_36610:setString(dms.int(dms["partner_bounty_param"],11,partner_bounty_param.spend_gold))
	end  	
	
	-- DSC重塑
	local Text_points = ccui.Helper:seekWidgetByName(csbTreasureChestOfferSuccessTen_root, "Text_points")
	if __lua_project_id == __lua_project_l_digital and Text_points then
		Text_points:setVisible(false)
	end
	
	local RecruitStr =dms.string(dms["pirates_config"], 273, pirates_config.param)
	local pMouID = zstring.split(RecruitStr,",")	
	local propRecruitCount = getPropAllCountByMouldId(pMouID[13])--战将招募令数量
	local propGodRecruitCount = getPropAllCountByMouldId(pMouID[14])--神将招募令数量
	self.zhanjiangling = tonumber(propRecruitCount) or 0			--用户拥有战将领
	self.HeronumberGod = tonumber(propGodRecruitCount) or 0
	
	-- [[
	self.ShipIndex = 0
end

-- function TreasureChestOfferSuccessTen:openNewShowActionSpecial()
-- 	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
-- 		local ship_mould_id = self.recruitment_data[tonumber(self.heroIndex)].random
-- 		--进化形象
-- 		local evo_image = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.fitSkillTwo)
-- 		local evo_info = zstring.split(evo_image, ",")
-- 		--进化模板id
-- 		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_mould_id, ship_mould.captain_name)]
-- 		local FB_share = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.Kill_feature)
-- 			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_show") ~= nil then
-- 			    if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
-- 			        if FB_share == 1 then
-- 			            ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(true)
-- 			        else
-- 			            ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(false)
-- 			        end
-- 			    else
-- 			        ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(false)
-- 			    end
-- 			end
-- 	end
-- end


function TreasureChestOfferSuccessTen:onEnterTransitionFinish()
	self:ShowUI()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_36550"), nil, {terminal_name = "shop_hero_page_chick_recruit_ten", terminal_state = self.ranking, touch_scale = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_36551"), nil, {terminal_name = "treasure_chest_offer_success_ten_renturn_shop_page", terminal_state = 0, touch_scale = true}, nil, 0)
	-- local Close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_15"), nil, {terminal_name = "treasure_chest_offer_success_ten_renturn_shop_page", terminal_state = 0, touch_scale = true}, nil, 0)
	
	local Panel_15 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_15")
	Panel_15:setTouchEnabled(false)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_come_on_the_stage"), nil, {terminal_name = "treasure_chest_offer_success_ten_speedup", terminal_state = 0, touch_scale = false}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_shop_bg"), nil, {terminal_name = "treasure_chest_offer_success_ten_speedup", terminal_state = 0, touch_scale = false}, nil, 0)

	for i=1,10 do
		local infoPanel = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_show_hero_"..i)
		local infoRoot = infoPanel:getChildByName("ProjectNode_2"):getChildByName("root")
		-- Item chests reuse the recruitment layout, not its hero details.
		infoRoot:setVisible(false)
		local Panel_32=  ccui.Helper:seekWidgetByName(infoRoot, "Panel_lwj_2")
		Panel_32:setVisible(false)
		local Button_ok = ccui.Helper:seekWidgetByName(infoRoot, "Button_ok")
		fwin:addTouchEventListener(Button_ok, nil, {terminal_name = "treasure_chest_offer_success_ten_open_new_show_action_special", terminal_state = 0, touch_scale = true ,_Panel_32 = Button_ok}, nil, 0)
	end

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

    if ccui.Helper:seekWidgetByName(self.roots[1], "Button_show") ~= nil and __lua_project_id == __lua_project_l_pokemon then
        ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(false)
    end

    --ccui.Helper:seekWidgetByName(self.roots[1], "Button_show"):setVisible(false)
end
