-----------------------------
-- 当前拥有的合金矩阵
-----------------------------
AlloyMatrixGetReword = class("AlloyMatrixGetRewordClass", Window)

local alloy_matrix_get_reword_window_open_terminal = {
	_name = "alloy_matrix_get_reword_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixGetRewordClass") == nil then
            fwin:open(AlloyMatrixGetReword:new():init(params), fwin._ui)   
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_get_reword_window_close_terminal = {
	_name = "alloy_matrix_get_reword_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        -- state_machine.lock("alloy_matrix_get_reword_window_close")
        local _self = params._datas._self
        if not _self.is_fun_open then
            state_machine.excute("alloy_matrix_redot_update", 0, "")
        else
            -- state_machine.excute("daily_task_window_open", 0, "")
        end
        fwin:close(fwin:find("AlloyMatrixGetRewordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_get_reword_window_open_terminal)
state_machine.add(alloy_matrix_get_reword_window_close_terminal)
state_machine.init()

function AlloyMatrixGetReword:ctor()
	self.super:ctor()
	self.roots = {}

	app.load("client.shop.recruit.HeroRecruitSuccess")
    app.load("client.shop.recruit.HeroRecruitSuccessTen")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixWindow")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixTop")
    
    local function init_alloy_matrix_get_reword_formation_terminal()
        local alloy_matrix_get_reword_one_terminal = {
            _name = "alloy_matrix_get_reword_one",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = params._datas._type
                local index = params._datas._index
                if instance.left_nums[index] <= 0 then
                	TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[2])
                	return
                end

                if index == 1 then
                	local need_gold = instance.cost[index]
                	if need_gold > tonumber(_ED.user_info.user_silver) and not (tonumber(_ED.alloy_matrix_recruit.goldFreeNum) == 1) then
                        app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                        local fightWindow = HeroPatchInformationPageGetWay:new()
                        fightWindow:init(0,6)
                        fwin:open(fightWindow, fwin._windows)
                        state_machine.unlock("hero_recruit_list_view_a_recruiting")
                        state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                        return
                    end
                elseif index == 4 then
                    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.AlloyMatrixDraw)
                    if fun_is_open == true then
                        --
                    else
                        local need_diamond = instance.cost[index]
                        if need_diamond > tonumber(_ED.user_info.user_gold) and not (tonumber(_ED.alloy_matrix_recruit.diamonFreeNum) == 1) then
                            TipDlg.drawTextDailog(_string_piece_info[74])
                            return
                        end
                    end
                end
                state_machine.lock("alloy_matrix_get_reword_one")
                state_machine.lock("alloy_matrix_get_reword_ten")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if fwin:find("HeroRecruitSuccessClass") ~= nil then
                                fwin:close(fwin:find("HeroRecruitSuccessClass"))
                            end
                            local Panel_alloy_draw_dh = ccui.Helper:seekWidgetByName(response.node.roots[1],"Panel_alloy_draw_dh")
                            local jsonFile = "images/ui/effice/effect_hjcqcq/effect_hjcqcq.json" 
                            local atlasFile = "images/ui/effice/effect_hjcqcq/effect_hjcqcq.atlas" 
                            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                            animation.animationNameList = {"animation"}
                            sp.initArmature(animation, false)
                            local function changeActionCallback( ... )
                                getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}

                                -- A janela de personagem usa o Naruto de demonstração
                                -- para recompensas sem personagem (essência/Ryo). O
                                -- sorteio 1x de Mudra deve usar a mesma lista do 10x.
                                local obj = HeroRecruitSuccessTen:new()
                                obj:setRanking(herorIndex,(m_type+2),false)
                                obj.number = 1
                                fwin:open(obj,fwin._ui)

                                state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                                state_machine.excute("alloy_matrix_get_reword_update", 0, "")
                                local ani_cq = Panel_alloy_draw_dh:getChildByName("animation_cq")
                                ani_cq:removeFromParent(true)
                            end
                            animation._invoke = changeActionCallback
                            Panel_alloy_draw_dh:addChild(animation)
                            animation:setName("animation_cq")
                            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                            csb.animationChangeToAction(animation, 0, 0, false)
                            
                            
                        end
                    else
                        state_machine.unlock("alloy_matrix_get_reword_one")
                        state_machine.unlock("alloy_matrix_get_reword_ten")
                    end
                    _ED.prop_chest_store_recruiting = false
                end

                _ED.new_prop_object = {}
                _ED.recruit_success_ship_id = nil
                _ED.new_reward_object = {}
                _ED.prop_chest_store_recruiting = true

                protocol_command.ship_bounty.param_list =""..m_type
                NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_get_reword_ten_terminal = {
            _name = "alloy_matrix_get_reword_ten",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = params._datas._type

                local index = params._datas._index
                if instance.left_nums[index] <= 0 then
                	TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[2])
                	return
                end
                if index == 2 or index == 3 then
                	local need_gold = instance.cost[index]
                	if need_gold > tonumber(_ED.user_info.user_silver) then
                        app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                        local fightWindow = HeroPatchInformationPageGetWay:new()
                        fightWindow:init(0,6)
                        fwin:open(fightWindow, fwin._windows)
                        state_machine.unlock("hero_recruit_list_view_a_recruiting")
                        state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                        return
                    end
                elseif index == 5 then
                    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.AlloyMatrixDraw)
                    if fun_is_open == true then
                        --
                    else
                        local need_diamond = instance.cost[index]
                        if need_diamond > tonumber(_ED.user_info.user_gold) then
                            TipDlg.drawTextDailog(_string_piece_info[74])
                            return
                        end
                    end
                end

                state_machine.lock("alloy_matrix_get_reword_one")
                state_machine.lock("alloy_matrix_get_reword_ten")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
                                fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
                            end
                            local Panel_alloy_draw_dh = ccui.Helper:seekWidgetByName(response.node.roots[1],"Panel_alloy_draw_dh")
                            local jsonFile = "images/ui/effice/effect_hjcqcq/effect_hjcqcq.json" 
                            local atlasFile = "images/ui/effice/effect_hjcqcq/effect_hjcqcq.atlas" 
                            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                            animation.animationNameList = {"animation"}
                            sp.initArmature(animation, false)
                            local function changeTenActionCallback( ... )
                                 getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}

                                if m_type == 6 then
                                    app.load("client.shop.recruit.HeroRecruitReward")
                                    state_machine.excute("hero_recruit_reward_window_open", 0, m_type)
                                    state_machine.unlock("alloy_matrix_get_reword_one")
                                    state_machine.unlock("alloy_matrix_get_reword_ten")
                                else
                                    local obj = HeroRecruitSuccessTen:new()
                                    obj:setRanking(herorIndex,m_type,false)
                                    fwin:open(obj,fwin._ui)
                                end
                                state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                                state_machine.excute("alloy_matrix_get_reword_update", 0, "")

                                local ani_cq = Panel_alloy_draw_dh:getChildByName("animation_cq_ten")
                                ani_cq:removeFromParent(true)
                            end
                            animation._invoke = changeTenActionCallback
                            Panel_alloy_draw_dh:addChild(animation)
                            animation:setName("animation_cq_ten")
                            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                            csb.animationChangeToAction(animation, 0, 0, false)

                           
                        end
                    else
                        state_machine.unlock("alloy_matrix_get_reword_one")
                        state_machine.unlock("alloy_matrix_get_reword_ten")
                    end
                    _ED.prop_chest_store_recruiting = false
                end

                _ED.new_prop_object = {}
                _ED.recruit_success_ship_id = nil
                _ED.new_reward_object = {}
                _ED.prop_chest_store_recruiting = true

                protocol_command.ship_batch_bounty.param_list =""..m_type
                NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_get_reword_update_terminal = {
            _name = "alloy_matrix_get_reword_update",
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

        state_machine.add(alloy_matrix_get_reword_one_terminal)
        state_machine.add(alloy_matrix_get_reword_ten_terminal)
        state_machine.add(alloy_matrix_get_reword_update_terminal)
        state_machine.init()
    end
    init_alloy_matrix_get_reword_formation_terminal()
end

function AlloyMatrixGetReword:onUpdateDraw()
	local root = self.roots[1]
	local Text_alloy_buy_jb_one_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_jb_one_n")
	local Text_alloy_buy_jb_ten_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_jb_ten_n")
	local Text_alloy_buy_jb_fifty_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_jb_fifty_n")

	local Text_alloy_buy_diamo_one_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_diamo_one_n")
	local Text_alloy_buy_diamo_ten_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_diamo_ten_n")

	local Text_alloy_buy_jb_one_time_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_jb_one_time_n")
	local Text_alloy_buy_jb_ten_time_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_jb_ten_time_n")
	local Text_alloy_buy_jb_fifty_time_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_jb_fifty_time_n")

	local Text_alloy_buy_diamo_one_time_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_diamo_one_time_n")
	local Text_alloy_buy_diamo_ten_time_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_buy_diamo_ten_time_n")

	local Panel_alloy_draw_buy_jb_fifty = ccui.Helper:seekWidgetByName(root,"Panel_alloy_draw_buy_jb_fifty")

	local max_num = zstring.splits(dms.string(dms["ship_config"], 41, ship_config.param), "|", ",")
	local used_num = zstring.split(_ED.alloy_matrix_recruit.use_num, ",")

	local all_txt = {Text_alloy_buy_jb_one_n, Text_alloy_buy_jb_ten_n, Text_alloy_buy_jb_fifty_n, Text_alloy_buy_diamo_one_n, Text_alloy_buy_diamo_ten_n}
	local all_times = {Text_alloy_buy_jb_one_time_n, Text_alloy_buy_jb_ten_time_n, Text_alloy_buy_jb_fifty_time_n, Text_alloy_buy_diamo_one_time_n, Text_alloy_buy_diamo_ten_time_n}
	self.left_nums = {}
	self.cost = {}
	for i=1,#all_txt do
		local need_cost1 = dms.int(dms["partner_bounty_param"], max_num[i][1], partner_bounty_param.spend_silver)
		local need_cost2 = dms.int(dms["partner_bounty_param"], max_num[i][1], partner_bounty_param.spend_gold)
		local need_cost = need_cost1 == 0 and need_cost2 or need_cost1

		local left_num = tonumber(max_num[i][2]) - tonumber(used_num[i])
		all_txt[i]:setString(need_cost)
		all_times[i]:setString(left_num .. "/" .. max_num[i][2])
		self.left_nums[i] = left_num
		self.cost[i] = need_cost
	end

    local Image_buy_jb = ccui.Helper:seekWidgetByName(root,"Image_buy_jb")
    local Image_buy_diam = ccui.Helper:seekWidgetByName(root,"Image_buy_diam")
	if tonumber(_ED.alloy_matrix_recruit.goldFreeNum) == 1 then
		Text_alloy_buy_jb_one_n:setString(tipStringInfo_alloy_matrix_tips[1])
        Image_buy_jb:setVisible(true)
    else
        Image_buy_jb:setVisible(false)
	end

	if tonumber(_ED.alloy_matrix_recruit.diamonFreeNum) == 1 then
		Text_alloy_buy_diamo_one_n:setString(tipStringInfo_alloy_matrix_tips[1])
        Image_buy_diam:setVisible(true)
    else
        Image_buy_diam:setVisible(false)
	end

	Panel_alloy_draw_buy_jb_fifty:setVisible(not funOpenDrawTip(183, false))

    
    --合金抽取券
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.AlloyMatrixDraw)
    if fun_is_open == true then
        local lvs = zstring.tonumber(dms.string(dms["shop_config"], 24, shop_config.param))
        if lvs > 0 then
            local needPropNumber = 0
            if fundPropWidthId(lvs) then
                needPropNumber = zstring.tonumber(fundPropWidthId(lvs).prop_number)
            end

            local Panel_alloy_draw_buy_diamo_one = ccui.Helper:seekWidgetByName(root,"Panel_alloy_draw_buy_diamo_one")
            local Panel_alloy_draw_buy_diamo_ten = ccui.Helper:seekWidgetByName(root,"Panel_alloy_draw_buy_diamo_ten")
            local one_image = Panel_alloy_draw_buy_diamo_one:getChildByName("Image_4")
            local ten_image = Panel_alloy_draw_buy_diamo_ten:getChildByName("Image_4")

            local Image_xianshi_1 = ccui.Helper:seekWidgetByName(root, "Image_xianshi_1")
            local Image_xianshi_2 = ccui.Helper:seekWidgetByName(root, "Image_xianshi_2")

            local Text_darw_ten_gem_n = ccui.Helper:seekWidgetByName(root,"Text_darw_ten_gem_n")
            
            if tonumber(_ED.alloy_matrix_recruit.diamonFreeNum) == 1 then
                one_image:setVisible(false)
                Image_xianshi_1:setVisible(true)
                Text_alloy_buy_diamo_one_n:setString(tipStringInfo_alloy_matrix_tips[1])
                 if needPropNumber >= 10 then
                    ten_image:setVisible(false)
                    Image_xianshi_2:setVisible(true)
                    Text_alloy_buy_diamo_ten_n:setString("10")
                else
                    ten_image:setVisible(true)
                    Image_xianshi_2:setVisible(false)
                    Text_alloy_buy_diamo_ten_n:setString(self.cost[5])
                end
            else
                if needPropNumber >= 1 then
                    one_image:setVisible(false)
                    Image_xianshi_1:setVisible(true)
                    Text_alloy_buy_diamo_one_n:setString("1")
                else
                    one_image:setVisible(true)
                    Image_xianshi_1:setVisible(false)
                    Text_alloy_buy_diamo_one_n:setString(self.cost[4])
                end
                if needPropNumber >= 10 then
                    ten_image:setVisible(false)
                    Image_xianshi_2:setVisible(true)
                    Text_alloy_buy_diamo_ten_n:setString("10")
                else
                    ten_image:setVisible(true)
                    Image_xianshi_2:setVisible(false)
                    Text_alloy_buy_diamo_ten_n:setString(self.cost[5])
                end
            end
        end
    end
end

function AlloyMatrixGetReword:onUpdate( dt )
    
end

function AlloyMatrixGetReword:init(params)
    self.is_fun_open = true
    if params._datas then
        self.is_fun_open = params._datas.is_fun_open
    end

	self:onInit()
    return self
end

function AlloyMatrixGetReword:onInit()
    local csbItem = csb.createNode("cultivate/alloy_draw_formation.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_draw_back"), nil, 
    {
        terminal_name = "alloy_matrix_get_reword_window_close", 
        terminal_state = 0, 
        _self = self,
        touch_black = true,
    }, nil, 3)

    --金币抽1个
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_buy_jb_one"), nil, 
    {
        terminal_name = "alloy_matrix_get_reword_one", 
        terminal_state = 0, 
        _type = 4,
        _index = 1,
        touch_black = true,
    }, nil, 3)
    
    -- 钻石抽1个
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_buy_diamo_one"), nil, 
    {
        terminal_name = "alloy_matrix_get_reword_one", 
        terminal_state = 0, 
        _type = 5,
        _index = 4,
        touch_black = true,
    }, nil, 3)


    -- 金币抽10个
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_buy_jb_ten"), nil, 
    {
        terminal_name = "alloy_matrix_get_reword_ten", 
        terminal_state = 0, 
        _type = 5,
        _index = 2,
        touch_black = true,
    }, nil, 3)

    -- 金币抽50个
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_buy_jb_fifty"), nil, 
    {
        terminal_name = "alloy_matrix_get_reword_ten", 
        terminal_state = 0, 
        _type = 6,
        _index = 3,
        touch_black = true,
    }, nil, 3)

     -- 钻石抽10个
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_buy_diamo_ten"), nil, 
    {
        terminal_name = "alloy_matrix_get_reword_ten", 
        terminal_state = 0, 
        _type = 7,
        _index = 5,
        touch_black = true,
    }, nil, 3)

    local Panel_alloy_draw_dh = ccui.Helper:seekWidgetByName(root,"Panel_alloy_draw_dh")
    local jsonFile = "images/ui/effice/spirte_hjcqdj.json" 
    local atlasFile = "images/ui/effice/spirte_hjcqdj.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    Panel_alloy_draw_dh:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)

    local userinfo = AlloyMatrixTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

    self:onUpdateDraw()
end

function AlloyMatrixGetReword:onEnterTransitionFinish()
end

function AlloyMatrixGetReword:onExit()
    -- state_machine.unlock("alloy_matrix_get_reword_window_close")
    state_machine.remove("tab_btn_change")
end
