UnionFightingMain = class("UnionFightingMainClass", Window)

local union_fighting_main_open_terminal = {
	_name = "union_fighting_main_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightingMainClass")
		if window ~= nil and window:isVisible() == true then
			return true
		end
        fwin:close(fwin:find("UserTopInfoAClass"))

        state_machine.lock("union_fighting_main_open")
        local window = UnionFightingMain:new():init(params)
		fwin:open(window, fwin._view)
        if params == true and _ED.lastUnionFightMap ~= nil then
            local mapInfo = _ED.union_fight_other_map_info["".._ED.lastUnionFightMap]
            _ED.lastUnionFightMap = nil
            if mapInfo ~= nil then
                state_machine.excute("union_fight_formation_open", 0, {mapInfo, 1})  
            end
        end
        window:onShowResult()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_main_close_terminal = {
	_name = "union_fighting_main_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightingMainClass")
		if window ~= nil then
			fwin:close(window)
		end
        fwin:close(fwin:find("UnionClass"))
        state_machine.excute("Union_open", 0, "")
        if __lua_project_id ~= __lua_project_gragon_tiger_gate and __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_naruto  then
            if fwin:find("MenuClass") == nil then
               fwin:open(Menu:new(), fwin._taskbar)
            end
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_main_open_terminal)
state_machine.add(union_fighting_main_close_terminal)
state_machine.init()

function UnionFightingMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.chooseCamp = 0
    self.asyncIndex = 1
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.unionFighting.UnionFightFormation")
        app.load("client.l_digital.union.unionFighting.UnionFightRoleCell")
        app.load("client.l_digital.union.unionFighting.UnionFightRoleInfo")
        app.load("client.l_digital.union.unionFighting.UnionFightChoose")
        app.load("client.l_digital.union.unionFighting.UnionFightChooseCell")
        app.load("client.l_digital.union.unionFighting.UnionFightNpc")
        app.load("client.l_digital.union.unionFighting.UnionFightResult")
        app.load("client.l_digital.union.unionFighting.UnionFightGainReward")
        app.load("client.l_digital.cells.union.union_logo_icon_cell")
    else
        app.load("client.union.unionFighting.UnionFightFormation")
        app.load("client.union.unionFighting.UnionFightRoleCell")
        app.load("client.union.unionFighting.UnionFightRoleInfo")
        app.load("client.union.unionFighting.UnionFightChoose")
        app.load("client.union.unionFighting.UnionFightChooseCell")
        app.load("client.union.unionFighting.UnionFightNpc")
        app.load("client.union.unionFighting.UnionFightResult")
        app.load("client.union.unionFighting.UnionFightGainReward")
        app.load("client.cells.union.union_logo_icon_cell")
    end

    local function init_union_fight_main_terminal()
		local union_fight_main_return_terminal = {
            _name = "union_fight_main_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fighting_main_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_main_my_info_terminal = {
            _name = "union_fight_main_my_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.chooseCamp == 0 then
                    return
                end
                instance.chooseCamp = 0
                instance:updateNpc(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_main_other_info_terminal = {
            _name = "union_fight_main_other_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.chooseCamp == 1 then
                    return
                end
                instance.chooseCamp = 1
                instance:updateNpc(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_main_npc_change_terminal = {
            _name = "union_fight_main_npc_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateOpenNpcState(params)
                state_machine.excute("union_fight_formation_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_main_update_terminal = {
            _name = "union_fight_main_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:refreshNpcInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_main_request_refresh_terminal = {
            _name = "union_fight_main_request_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:refreshUnionFight(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_fight_main_return_terminal)
        state_machine.add(union_fight_main_my_info_terminal)
        state_machine.add(union_fight_main_other_info_terminal)
        state_machine.add(union_fight_main_npc_change_terminal)
        state_machine.add(union_fight_main_update_terminal)
        state_machine.add(union_fight_main_request_refresh_terminal)
        state_machine.init()
    end
    init_union_fight_main_terminal()
end

function UnionFightingMain:refreshUnionFight( params )
    if tonumber(_ED.union_fight_state) == 3 then
        return
    end
    local function responseCallback( response )
    end
    if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
        protocol_command.unino_map_refush.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number.."\r\n"..params
        NetworkManager:register(protocol_command.unino_map_refush.code, _ED.union_fight_url, nil, nil, nil, responseCallback, false, nil)
    end
end

function UnionFightingMain:onShowResult( ... )
    if _ED.union.user_union_info.union_fight_reward == true and _ED.union_fight_reward_info ~= nil 
        and tonumber(_ED.union_fight_state) == 3 and _ED.union_fight_result ~= nil then
        state_machine.excute("union_fight_result_open", 0, nil)
        self:updateDraw()
    end
end

function UnionFightingMain:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local myCampImg = nil
    if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
        myCampImg = ccui.Helper:seekWidgetByName(root, "Button_12")
    else
        myCampImg = ccui.Helper:seekWidgetByName(root, "Image_17")
    end
    local otherCampImg = nil
    if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
        otherCampImg = ccui.Helper:seekWidgetByName(root, "Button_12_0")
    else
        otherCampImg = ccui.Helper:seekWidgetByName(root, "Image_17_0")
    end
    if tonumber(_ED.union_fight_state) == 0 or tonumber(_ED.union_fight_state) == 1 then
        myCampImg:setVisible(false)
        otherCampImg:setVisible(false)
    else
        myCampImg:setVisible(false)
        otherCampImg:setVisible(false)
        if self.chooseCamp == 0 then
            otherCampImg:setVisible(true)
        else
            myCampImg:setVisible(true)
        end
    end
    
    ccui.Helper:seekWidgetByName(root, "Text_legion_name_1"):setString("s"..math.floor(tonumber(_ED.union_fight_owner_server_id)%1000).." ".._ED.union_fight_owner_union_name)
    if tonumber(_ED.union_fight_other_server_id) == 0 then
        ccui.Helper:seekWidgetByName(root, "Text_legion_name_2"):setString(_ED.union_fight_other_union_name)
    else
        ccui.Helper:seekWidgetByName(root, "Text_legion_name_2"):setString("s"..math.floor(tonumber(_ED.union_fight_other_server_id)%1000).." ".._ED.union_fight_other_union_name)
    end
    ccui.Helper:seekWidgetByName(root, "Text_1268"):setString(_ED.union_fight_attack_count)
    ccui.Helper:seekWidgetByName(root, "Text_1268_0"):setString(_ED.union_fight_kill_count)
    ccui.Helper:seekWidgetByName(root, "LoadingBar_left"):setPercent(tonumber(_ED.union_fight_owner_score))
    ccui.Helper:seekWidgetByName(root, "Text_loading_1"):setString(_ED.union_fight_owner_score.."/100")
    ccui.Helper:seekWidgetByName(root, "LoadingBar_right"):setPercent(tonumber(_ED.union_fight_other_score))
    ccui.Helper:seekWidgetByName(root, "Text_loading_2"):setString(_ED.union_fight_other_score.."/100")

    if tonumber(_ED.union_fight_state) == 1 then
        ccui.Helper:seekWidgetByName(root, "Text_zd_zhangtai"):setString(tipStringInfo_union_str[65])
    elseif tonumber(_ED.union_fight_state) == 2 then
        ccui.Helper:seekWidgetByName(root, "Text_zd_zhangtai"):setString(tipStringInfo_union_str[66])
    elseif tonumber(_ED.union_fight_state) == 3 then
        ccui.Helper:seekWidgetByName(root, "Text_zd_zhangtai"):setString(tipStringInfo_union_str[67])
    end

    local panelIcon = ccui.Helper:seekWidgetByName(root, "Panel_legion_bz")
    panelIcon:removeAllChildren(true)
    local cell = CnionLogoIconCell:createCell():init(_ED.union.union_info.union_kuang, _ED.union.union_info.union_icon,_ED.union.union_info.union_grade)
    panelIcon:addChild(cell)
end

function UnionFightingMain:loading_cell( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    local panel = ccui.Helper:seekWidgetByName(root, "Panel_pk_"..UnionFightingMain.asyncIndex)
    panel:removeAllChildren(true)

    local mapInfo = nil
    if self.chooseCamp == 0 then
        mapInfo = _ED.union_fight_owner_map_info[""..UnionFightingMain.asyncIndex]
    else
        mapInfo = _ED.union_fight_other_map_info[""..UnionFightingMain.asyncIndex]
    end
    local cell = UnionFightNpc:CreateCell():init(mapInfo, self.chooseCamp)
    panel:addChild(cell)
    panel.cell = cell
    UnionFightingMain.asyncIndex = UnionFightingMain.asyncIndex + 1
end

function UnionFightingMain:updateNpc( isShowEffect )
    local root = self.roots[1]
    if root == nil then
        return
    end
    if isShowEffect == true then
        local Panel_guochangdonghua = ccui.Helper:seekWidgetByName(root, "Panel_guochangdonghua")
        Panel_guochangdonghua:removeAllChildren(true)
        local effect_paths = "images/ui/effice/zhandouguodu/zhandouguodu.ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        local armature = ccs.Armature:create("zhandouguodu")
        draw.initArmature(armature, nil, -1, 0, 1)
        local function changeActionCallback( armatureBack )
            armatureBack:removeFromParent(true)
        end
        armature._invoke = changeActionCallback
        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        -- csb.animationChangeToAction(armature, 0, 0, false)
        Panel_guochangdonghua:addChild(armature)
    end
    cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    UnionFightingMain.asyncIndex = 1
    self:updateDraw()
    if self.chooseCamp == 0 then
        -- if _ED.union_fight_owner_map_info ~= nil then
        --     for i, v in pairs(_ED.union_fight_owner_map_info) do
        --         cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)  
        --     end
        -- end
        for k,v in pairs(_ED.union_fight_owner_map_info) do
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_pk_"..k)
            panel:removeAllChildren(true)
            local cell = UnionFightNpc:CreateCell()
            cell:init(v, self.chooseCamp)
            panel.cell = cell
            panel:addChild(cell)
        end
    else
        -- if _ED.union_fight_other_map_info ~= nil then
        --     for i, v in pairs(_ED.union_fight_other_map_info) do
        --         cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)  
        --     end
        -- end
        for k,v in pairs(_ED.union_fight_other_map_info) do
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_pk_"..k)
            panel:removeAllChildren(true)
            local cell = UnionFightNpc:CreateCell()
            cell:init(v, self.chooseCamp)
            panel.cell = cell
            panel:addChild(cell)
        end
    end
end

function UnionFightingMain:refreshNpcInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:updateDraw()
    if self.chooseCamp == 0 then
        for k,v in pairs(_ED.union_fight_owner_map_info) do
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_pk_"..k)
            if panel.cell ~= nil then
                panel.cell:updateInfo(v)
            end
        end
    else
        for k,v in pairs(_ED.union_fight_other_map_info) do
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_pk_"..k)
            if panel.cell ~= nil then
                panel.cell:updateInfo(v)
            end
        end
    end
end

function UnionFightingMain:updateOpenNpcState( params )
    local root = self.roots[1]
    if root == nil then
        return
    end
    local campState = params[1]
    local mapInfo = params[2]
    if tonumber(self.chooseCamp) == tonumber(campState) then
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_pk_"..mapInfo.mapId)
        if panel.cell ~= nil then
            panel.cell:updateInfo(mapInfo)
        end
    end
end

function UnionFightingMain:onInit()
    self:onLoad()
	local csbUnion = csb.createNode("legion/legion_pve_map.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	self:updateDraw()
    self:updateNpc()

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
        {
            terminal_name = "union_fight_main_return", 
            terminal_state = 0,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    else
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7_back"), nil, 
        {
            terminal_name = "union_fight_main_return", 
            terminal_state = 0,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
    {
        terminal_name = "union_fight_main_my_info", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_0"), nil, 
    {
        terminal_name = "union_fight_main_other_info", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.unlock("union_fighting_main_open")
end

function UnionFightingMain:onEnterTransitionFinish()
end

function UnionFightingMain:init(params)
    if params == true then
        self.chooseCamp = 1
    end
    self:onInit()
	return self
end

function UnionFightingMain:onExit()
    self:unLoad()
	state_machine.remove("union_fight_main_return")
    state_machine.remove("union_fight_main_my_info")
    state_machine.remove("union_fight_main_other_info")
    state_machine.remove("union_fight_main_npc_change")
    state_machine.remove("union_fight_main_update")
    state_machine.remove("union_fight_main_request_refresh")
end

function UnionFightingMain:onLoad()
    local effect_paths = "images/ui/effice/zhandouguodu/zhandouguodu.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_xiaoyan/effect_xiaoyan.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    -- effect_paths = "images/ui/effice/legion_shishou/legion_shishou.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end

function UnionFightingMain:unLoad()
    local effect_paths = "images/ui/effice/zhandouguodu/zhandouguodu.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_xiaoyan/effect_xiaoyan.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    -- effect_paths = "images/ui/effice/legion_shishou/legion_shishou.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
end
