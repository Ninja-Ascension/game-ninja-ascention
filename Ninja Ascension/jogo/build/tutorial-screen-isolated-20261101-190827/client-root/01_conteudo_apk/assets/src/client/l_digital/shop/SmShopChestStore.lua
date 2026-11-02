-- ----------------------------------------------------------------------------------------------------
-- 说明：sm商城宝箱页
-------------------------------------------------------------------------------------------------------

SmShopChestStore = class("SmShopChestStoreClass", Window)

local sm_shop_chest_store_open_terminal = {
    _name = "sm_shop_chest_store_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local SmShopChestStoreWindow = fwin:find("SmShopChestStoreClass")
    	if SmShopChestStoreWindow ~= nil then
    		SmShopChestStoreWindow:setVisible(true)
    		return
    	end
    	local page = SmShopChestStore:new():init(params)
		return page
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_shop_chest_store_open_terminal)
state_machine.init()

function SmShopChestStore:ctor()
    self.super:ctor()
	self.roots = {}
	self.index = 2
	self.scrollView = nil
	self.roll_width = 0
	-- app.load("client.l_digital.shop.SmShopRefreshWindow")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.utils.sm_item_icon_cell")
    app.load("client.l_digital.shop.TreasureChestOfferSuccess")
    app.load("client.l_digital.shop.TreasureChestOfferSuccessTen")
    app.load("client.l_digital.shop.SmShopDebrisExchange")
	local function init_sm_shop_chest_store_terminal()
		--
		local sm_shop_chest_store_update_shop_terminal = {
            _name = "sm_shop_chest_store_update_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("sm_shop_refresh_window_open" , 0 , instance.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_chest_store_update_terminal = {
            _name = "sm_shop_chest_store_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateMoney()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_chest_store_updateDraw_terminal = {
            _name = "sm_shop_chest_store_updateDraw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --一次招募
        local sm_shop_chest_store_view_a_recruiting_terminal = {
            _name = "sm_shop_chest_store_view_a_recruiting",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --控制按钮连点
                local btn = params._datas.terminal_button
                if btn then
                    btn:setTouchEnabled(false)
                    btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn:setTouchEnabled(true)
                    end)})
                    )
                end
                local m_type = tonumber(params._datas.m_type)
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            if fwin:find("HeroRecruitSuccessClass") ~= nil then
                                fwin:close(fwin:find("HeroRecruitSuccessClass"))
                            end
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}
                            end
                            local firstReward = _ED.new_reward_object and _ED.new_reward_object[1]
                            local firstRewardType = firstReward and tonumber(firstReward.m_type)
                            -- Itens do Shop usam a mesma tela de lista do 10x/50x.
                            -- Na tela individual, tipos como props/essencia exibiam o Naruto
                            -- de demonstracao do CSB junto com a recompensa.
                            local isShopItemReward = firstRewardType == 1
                                or firstRewardType == 6
                                or firstRewardType == 7
                                or firstRewardType == 66
                                or firstRewardType == 67
                            local obj
                            if isShopItemReward then
                                -- O 1x usa a mesma janela de recompensas do 10x/50x.
                                obj = TreasureChestOfferSuccessTen:new()
                                obj:setRanking(herorIndex,m_type,true)
                                obj.number = 1
                            else
                                obj = TreasureChestOfferSuccess:new()
                                obj:setRanking(herorIndex,m_type,true)
                            end
                            fwin:open(obj,fwin._ui)
                            state_machine.excute("sm_shop_chest_store_view_update_consume",0,"sm_shop_chest_store_view_update_consume.")
                            state_machine.excute("sm_shop_chest_store_update_debris_count", 0, "")
                        end
                        _ED.prop_chest_store_recruiting = false
                    end
                    state_machine.unlock("sm_shop_chest_store_view_a_recruiting")
                    state_machine.unlock("sm_shop_chest_store_view_ten_recruiting")
                end      
                _ED.new_prop_object = {}
                _ED.new_reward_object = {}
                _ED.recruit_success_ship_id = nil
                _ED.prop_chest_store_recruiting = true
                state_machine.lock("sm_shop_chest_store_view_a_recruiting")
                state_machine.lock("sm_shop_chest_store_view_ten_recruiting")
                protocol_command.ship_bounty.param_list = ""..m_type
                NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --十次招募
        local sm_shop_chest_store_view_ten_recruiting_terminal = {
            _name = "sm_shop_chest_store_view_ten_recruiting",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --控制按钮连点
                local btn = params._datas.terminal_button
                if btn then
                    btn:setTouchEnabled(false)
                    btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn:setTouchEnabled(true)
                    end)})
                    )
                end
                local m_type = tonumber(params._datas.m_type)
                local function tenrecruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}
                            end
                            local obj = TreasureChestOfferSuccessTen:new()
                            obj:setRanking(herorIndex,m_type,true)
                            fwin:open(obj,fwin._ui)
                            state_machine.excute("sm_shop_chest_store_update_debris_count", 0, "")
                        end
                        _ED.prop_chest_store_recruiting = false
                    end
                    state_machine.unlock("sm_shop_chest_store_view_a_recruiting")
                    state_machine.unlock("sm_shop_chest_store_view_ten_recruiting")
                end
                _ED.new_prop_object = {}
                _ED.new_reward_object = {}
                _ED.recruit_success_ship_id = nil
                _ED.prop_chest_store_recruiting = true
                state_machine.lock("sm_shop_chest_store_view_a_recruiting")
                state_machine.lock("sm_shop_chest_store_view_ten_recruiting")
                protocol_command.ship_batch_bounty.param_list =""..m_type
                NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, tenrecruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新消耗
        local sm_shop_chest_store_view_update_consume_terminal = {
            _name = "sm_shop_chest_store_view_update_consume",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:drawConsume()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_chest_store_preview_window_terminal = {
            _name = "sm_shop_chest_store_preview_window",
            _init = function (terminal) 
                app.load("client.l_digital.shop.SmRecruitPreviewWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = params._datas.m_type
                state_machine.excute("sm_recruit_preview_window_open", 0, {m_type})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_chest_store_update_debris_count_terminal = {
            _name = "sm_shop_chest_store_update_debris_count",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDebrisCount()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_shop_chest_store_update_shop_terminal)
		state_machine.add(sm_shop_chest_store_update_terminal)
        state_machine.add(sm_shop_chest_store_updateDraw_terminal)
        state_machine.add(sm_shop_chest_store_view_a_recruiting_terminal)
		state_machine.add(sm_shop_chest_store_view_ten_recruiting_terminal)
        state_machine.add(sm_shop_chest_store_view_update_consume_terminal)
        state_machine.add(sm_shop_chest_store_preview_window_terminal)
        state_machine.add(sm_shop_chest_store_update_debris_count_terminal)
        state_machine.init()
	end
	init_sm_shop_chest_store_terminal()
end

function SmShopChestStore:onUpdateDraw()
	local root = self.roots[1]
    local reword = dms.string(dms["shop_config"], 6, shop_config.param)
    local rewordData = zstring.split(reword, "|")
	for i=1,4 do
        local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i)
        Panel_props_icon:removeAllChildren(true)
        local datas = zstring.split(rewordData[i], ",")
        -- local cell = ResourcesIconCell:createCell()
        -- cell:init(tonumber(datas[1]), 0, tonumber(datas[2]),nil,nil,true,true,1)
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{datas[1],datas[2],datas[3]},false,false,false,true})
        Panel_props_icon:addChild(cell)
    end
    self:drawConsume()
    self:updateDebrisCount()
end

function SmShopChestStore:drawConsume()
    local root = self.roots[1]
    local image_key = ccui.Helper:seekWidgetByName(root, "image_key")
    local image_gem_1 = ccui.Helper:seekWidgetByName(root, "image_gem_1")
    local Text_gem_n_1 = ccui.Helper:seekWidgetByName(root, "Text_gem_n_1")
    image_gem_1:setVisible(false)
    image_key:setVisible(false)
    local key_mouldId = dms.int(dms["shop_config"] , 8 , shop_config.param)
    local key_number = tonumber(getPropAllCountByMouldId(key_mouldId))
    local everyDayFreeTime = tonumber(_ED.free_info[3].surplus_free_number) or 0
    if everyDayFreeTime > 0 then
        Text_gem_n_1:setString(_new_interface_text[16])
    elseif key_number == 0 then
        image_gem_1:setVisible(true)
        Text_gem_n_1:setString(dms.int(dms["partner_bounty_param"],10,partner_bounty_param.spend_gold))
    else
        image_key:setVisible(true)
        Text_gem_n_1:setString(key_number.."/1")
    end

    local image_gem_2 = ccui.Helper:seekWidgetByName(root, "image_gem_2")
    local Text_gem_n_2 = ccui.Helper:seekWidgetByName(root, "Text_gem_n_2")
    if key_number >= 10 then
        image_gem_2:loadTexture("images/ui/text/shop/zbbxys.png")
        Text_gem_n_2:setString(key_number.."/10")
    else
        image_gem_2:loadTexture("images/ui/icon/zuanshi.png")
        Text_gem_n_2:setString(dms.int(dms["partner_bounty_param"],11,partner_bounty_param.spend_gold))
    end
end

function SmShopChestStore:updateDebrisCount()
    local root = self.roots[1]
    local Text_suipian_n = ccui.Helper:seekWidgetByName(root, "Text_suipian_n")
    if Text_suipian_n ~= nil then
        Text_suipian_n:setString(_ED.user_info.jade)
    end
end

function SmShopChestStore:onInit()
	local csbSmShopChestStore = csb.createNode("shop/shop_listview_tab_1.csb")
	local root = csbSmShopChestStore:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbSmShopChestStore)

    local Panel_box_dh = ccui.Helper:seekWidgetByName(root, "Panel_box_dh")
    Panel_box_dh:removeAllChildren(true)
    local jsonFile = "sprite/sprite_baoxiang_2.json"
    local atlasFile = "sprite/sprite_baoxiang_2.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_box_dh:addChild(animation)

    --碎片兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_spdh"), nil, 
    {
        terminal_name = "sm_shop_debris_exchange_open", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)
            
    --招募一次
    local Button_open_1 = ccui.Helper:seekWidgetByName(root, "Button_open_1")
    fwin:addTouchEventListener(Button_open_1, nil, 
	{
		terminal_name = "sm_shop_chest_store_view_a_recruiting", 
		terminal_state = 0, 
        m_type = 3,
        terminal_button = Button_open_1,
		isPressedActionEnabled = true
	},
	nil, 0)

    --招募十次
    local Button_open_10 = ccui.Helper:seekWidgetByName(root, "Button_open_10")
    fwin:addTouchEventListener(Button_open_10, nil, 
    {
        terminal_name = "sm_shop_chest_store_view_ten_recruiting", 
        terminal_state = 0, 
        m_type = 3,
        terminal_button = Button_open_10,
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 奖励预览
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yulan"), nil, 
    {
        terminal_name = "sm_shop_chest_store_preview_window", 
        terminal_state = 0,
        m_type = 3,
        isPressedActionEnabled = true
    },
    nil, 0)
	
	self:onUpdateDraw()
    local function consumptionOnTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if ccui.TouchEventType.began == evenType then
            ccui.Helper:seekWidgetByName(root, "Panel_tips_info"):setVisible(true)
        elseif ccui.TouchEventType.moved == evenType then
            if __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
            or __lua_project_id == __lua_project_red_alert 
            or __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_yugioh
            or __lua_project_id == __lua_project_warship_girl_b 
            then
                if __mpoint.x - __spoint.x > 80 
                    or __mpoint.x - __spoint.x < -80 
                    or __mpoint.y - __spoint.y > 50 
                    or __mpoint.y - __spoint.y < -50 
                    then
                    ccui.Helper:seekWidgetByName(root, "Panel_tips_info"):setVisible(false)
                end
            end
        elseif ccui.TouchEventType.ended == evenType then
            ccui.Helper:seekWidgetByName(root, "Panel_tips_info"):setVisible(false)
        end
    end

    local Button_sp_info = ccui.Helper:seekWidgetByName(root, "Button_sp_info")
    if Button_sp_info ~= nil then
        Button_sp_info:addTouchEventListener(consumptionOnTouchEvent)
    end

end

function SmShopChestStore:init(params)
	self.index = params
	self:onInit()
	return self
end

function SmShopChestStore:onExit()
	state_machine.remove("sm_shop_chest_store_update")
	state_machine.remove("sm_shop_chest_store_update_shop")
	state_machine.remove("sm_shop_chest_store_updateDraw")
    state_machine.remove("sm_shop_chest_store_view_update_consume")
    state_machine.remove("sm_shop_chest_store_preview_window")
    state_machine.remove("sm_shop_chest_store_update_debris_count")
end

