----------------------------------------------------------------------------------------------------
-- 说明：副本npc cell
-------------------------------------------------------------------------------------------------------
PveNpcCell = class("PveNpcCellClass", Window)
PveNpcCell.__size = nil

local pve_npc_create_cell_terminal = {
    _name = "pve_npc_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveNpcCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_npc_create_cell_terminal)
state_machine.init()

function PveNpcCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    -- npc id
    self._npc_id = 0
    -- npc底框索引 1:主线杂兵 2:主线精英 3:主线BOSS
    self._base_pic = 0
    -- 场景id
    self._scene_id = 0
    self._npc_index = 0
    self._union_pve_info = nil

    self._npc_state = 0
    self._is_receive = 0
    self._consume_devote = 0
    self._by_open_npc = 0

    self._show_npc = nil
    
    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
 	local function init_pve_npc_cell_terminal()
        local pve_npc_cell_choose_terminal = {
            _name = "pve_npc_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local function responseCallback(response)
                    state_machine.unlock("pve_npc_cell_choose", 0, 0)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("legion_pve_update_draw", 0, "")
                    end
                end
                
                if cell._scene_type == battle_enum._fight_type._fight_type_107 then
                    if cell._npc_state == 1
                        and cell._is_receive == 0 then
                        state_machine.lock("pve_npc_cell_choose", 0, 0)
                        if cell._consume_devote > 0 then
                            state_machine.unlock("pve_npc_cell_choose", 0, 0)
                            state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 13}})
                        else
                            local function responseCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    state_machine.excute("legion_pve_update_draw", 0, "")
                                    state_machine.excute("pve_map_update_draw", 0, "")
                                    checkRewardObtainDraw()
                                    state_machine.excute("notification_center_update", 0, "push_notification_legion_pve_receive")
                                end
                            end
                            protocol_command.draw_union_copy_reward.param_list = cell._scene_id.."\r\n"..cell._npc_id.."\r\n"..(cell._index-1).."\r\n0"
                            NetworkManager:register(protocol_command.draw_union_copy_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                        end
                    else
                        state_machine.excute("legion_pve_attack_infor_open", 0, {cell._npc_id,cell._scene_id,cell._index,cell._union_pve_info})
                    end
                else
                    if missionIsOver() == true and tonumber("" .. cell._scene_id) == 1 then
                        state_machine.excute("formation_choose_max_fighting_formation", 0, {0, {cell._npc_id, cell._scene_id}})
                    else
                        if __lua_project_id == __lua_project_pacific_rim then
                            local _is_misssion = false
                            if missionIsOver() == false then
                                _is_misssion = true
                            end
                            state_machine.excute("formation_window_open", 0, {_datas = {form_type = 3, is_misssion = _is_misssion, next_terminal = "formation_defend_add_defender_formation_info", next_terminal_params = {cell._npc_id,cell._scene_id}}})
                            -- state_machine.excute("formation_defend_add_defender_formation_info", 0, {cell._npc_id, cell._scene_id})
                        else
                            state_machine.excute("pve_attack_open", 0, {cell._npc_id,cell._scene_id})
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_npc_cell_play_boom_effect_terminal = {
            _name = "pve_npc_cell_play_boom_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local index = params[2]
                cell:playBoomEffect(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_npc_cell_choose_two_terminal = {
            _name = "pve_npc_cell_choose_two",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell ~= nil and cell._scene_id ~= nil and cell._npc_id ~= nil and cell._index ~= nil then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("legion_pve_update_draw", 0, "")
                            state_machine.excute("pve_map_update_draw", 0, "")
                            checkRewardObtainDraw()
                        end
                    end
                    protocol_command.draw_union_copy_reward.param_list = cell._scene_id.."\r\n"..cell._npc_id.."\r\n"..(cell._index-1).."\r\n0"
                    NetworkManager:register(protocol_command.draw_union_copy_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(pve_npc_cell_choose_terminal)
        state_machine.add(pve_npc_cell_play_boom_effect_terminal)
        state_machine.add(pve_npc_cell_choose_two_terminal)
        state_machine.init()
    end
	init_pve_npc_cell_terminal()        	
end

function PveNpcCell:playBoomEffect(index)
    local root = self.roots[1]
    if self._index == index then
        local Panel_npc_clearance_effect = ccui.Helper:seekWidgetByName(root, "Panel_npc_clearance_effect")
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_boom/effect_boom.ExportJson")
        local armature5 = ccs.Armature:create("effect_boom")
        draw.initArmatureTwo(armature5, nil, -1, 1000, 1, 0)

        armature5:setPosition(cc.p(Panel_npc_clearance_effect:getContentSize().width/2,Panel_npc_clearance_effect:getContentSize().height/2))
        Panel_npc_clearance_effect:addChild(armature5)
        checkPlayEffect(15)
    end
end

function PveNpcCell:onUpdateDraw()
	local root = self.roots[1]
    -- npc名字
    local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
    local Image_npc_name_bg = ccui.Helper:seekWidgetByName(root, "Image_npc_name_bg")
    local npc_name = dms.string(dms["npc"], self._npc_id, npc.npc_name)
    Text_npc_name:setString(npc_name)
    local size = Image_npc_name_bg:getContentSize()
    local len = 0
    local map = string.utf8.chars(Text_npc_name:getString())
    for k, v in pairs(map) do
        if string.len(v) == 1 then
            len = len + 1
        else
            len = len + 2
        end
    end
    len = math.ceil(len)
    local width = len * 10
    Image_npc_name_bg:setContentSize(cc.size(width, size.height))

    -- npc icon
	local Panel_npc_icon = ccui.Helper:seekWidgetByName(root, "Panel_npc_icon")
    local Panel_npc_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_npc_icon_1")
    local Panel_npc_box_icon = ccui.Helper:seekWidgetByName(root, "Panel_npc_box_icon")
    if Panel_npc_box_icon ~= nil then
        Panel_npc_box_icon:removeBackGroundImage()
        Panel_npc_box_icon:removeAllChildren(true)
    end
    local head_pic = dms.string(dms["npc"], self._npc_id, npc.head_pic)
    head_pic = zstring.split(head_pic,",")
    Panel_npc_icon:removeBackGroundImage()
    Panel_npc_icon:removeAllChildren(true)
    if self._base_pic == 1 
        or self._base_pic == 4
        or self._base_pic == 5 
        or self._base_pic == 8
        then
        Panel_npc_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_pic[1]))
    else
        Panel_npc_icon:setBackGroundImage(string.format(config_res.images.ui.home.home_build, head_pic[1]))
    end
    if Panel_npc_icon_1 ~= nil then
        Panel_npc_icon_1:removeBackGroundImage()
        Panel_npc_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_pic[2]))
    end
    local Image_npc_rock = ccui.Helper:seekWidgetByName(root, "Image_npc_rock")
    if Image_npc_rock ~= nil then
        Image_npc_rock:setVisible(false)
    end

    if self._scene_type == battle_enum._fight_type._fight_type_107 then
        local Image_npc_bar_bg = ccui.Helper:seekWidgetByName(root, "Image_npc_bar_bg")
        local LoadingBar_npc = ccui.Helper:seekWidgetByName(root, "LoadingBar_npc")
        
        local design_reward = zstring.split(dms.string(dms["pve_scene"], self._scene_id, pve_scene.design_reward), "|")
        local npc_reward = zstring.split(design_reward[self._index], ",")
        local reward_name = dms.int(dms["pve_scene"], npc_reward[1], pve_scene.design_reward) 
        self._by_open_npc = dms.string(dms["npc"], self._npc_id, npc.by_open_npc)
        self._consume_devote = tonumber(npc_reward[2])
        Image_npc_bar_bg:setVisible(false)
        LoadingBar_npc:setVisible(false)
        if self._npc_state == 0 then
            Panel_npc_icon:setTouchEnabled(true)
            Panel_npc_icon:setVisible(self._show_npc)
            Image_npc_bar_bg:setVisible(true)
            LoadingBar_npc:setVisible(true)
            if Panel_npc_box_icon ~= nil then
                Panel_npc_box_icon:setTouchEnabled(true)
            end
            local formation_info = dms.element(dms["environment_formation"], self._npc_id)
            local seat_one = dms.atoi(formation_info, environment_formation.seat_one)
            local seat_two = dms.atoi(formation_info, environment_formation.seat_two)
            local seat_three = dms.atoi(formation_info, environment_formation.seat_three)
            local seat_four = dms.atoi(formation_info, environment_formation.seat_four)
            local seat_five = dms.atoi(formation_info, environment_formation.seat_five)
            local seat_six = dms.atoi(formation_info, environment_formation.seat_six)
            local seat_info = {seat_one,seat_two,seat_three,seat_four,seat_five,seat_six}
            local progress = 100
            if tonumber(self._union_pve_info.formation_info) == nil then
                local max_tank_count = 0
                local now_tank_count = 0
                for i=1,6 do
                    local ship_data = dms.element(dms["environment_ship"], seat_info[i])
                    local level = dms.atoi(ship_data, environment_ship.level)
                    local formation_seat_info = zstring.split(self._union_pve_info.formation_info, "|")
                    local npc_info = zstring.split(formation_seat_info[i], ",")
                    max_tank_count = max_tank_count + level
                    now_tank_count = now_tank_count + npc_info[3]
                end
                progress = now_tank_count / max_tank_count * 100
            end
            LoadingBar_npc:setPercent(progress)

        elseif self._npc_state == 1 then
            root:setTouchEnabled(false)
            Panel_npc_icon:setTouchEnabled(false)
            Panel_npc_icon:removeBackGroundImage()
            Panel_npc_icon:removeAllChildren(true)
            Panel_npc_icon:setVisible(true)
            if self._base_pic == 7 then
                Panel_npc_box_icon:removeBackGroundImage()
                Panel_npc_box_icon:removeAllChildren(true)
                if self._is_receive == 1 then
                    Panel_npc_box_icon:setTouchEnabled(false)
                    Panel_npc_box_icon:setBackGroundImage(string.format(config_res.images.ui.pve.treasure_box,2))
                else
                    Panel_npc_box_icon:setTouchEnabled(true)
                    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_box_get)
                    local armature = ccs.Armature:create("effect_box_get")
                    armature:getAnimation():playWithIndex(0)
                    armature:setPosition(cc.p(Panel_npc_box_icon:getContentSize().width/2,Panel_npc_box_icon:getContentSize().height/2))
                    Panel_npc_box_icon:addChild(armature)
                end
            else
                if self._is_receive == 1 then
                    root:setTouchEnabled(false)
                    Panel_npc_icon:setTouchEnabled(false)
                    Panel_npc_icon:setBackGroundImage(string.format(config_res.images.ui.pve.treasure_box,2))
                else
                    Panel_npc_icon:setTouchEnabled(true)
                    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_box_get)
                    local armature = ccs.Armature:create("effect_box_get")
                    armature:getAnimation():playWithIndex(0)
                    armature:setPosition(cc.p(Panel_npc_icon:getContentSize().width/2,Panel_npc_icon:getContentSize().height/2))
                    Panel_npc_icon:addChild(armature)
                end
            end
        else
            root:setTouchEnabled(false)
            Panel_npc_icon:setTouchEnabled(false)
            Panel_npc_icon:setVisible(true)
            root:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
            if Panel_npc_box_icon ~= nil then
                Panel_npc_box_icon:setTouchEnabled(false)
            end
        end
    else
        -- 星级
        local star = 0
        if zstring.tonumber(_ED.npc_state[tonumber(""..self._npc_id)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self._npc_id)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self._npc_id)]) ~= 0 then
            star = tonumber(_ED.npc_max_state[tonumber(""..self._npc_id)])
        else
            star = tonumber(_ED.npc_state[tonumber(""..self._npc_id)])
        end
        for i=1,3 do
            local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_"..i)
            Panel_star:removeAllChildren(true)
            if star >= i then
                Panel_star:setBackGroundImage(config_res.images.ui.pve.pve_checkpoint_star)
            else
                Panel_star:setBackGroundImage(config_res.images.ui.pve.pve_checkpoint_star_bg)
            end
        end
        local Panel_attack_now_effect_2 = ccui.Helper:seekWidgetByName(root, "Panel_attack_now_effect_2")
        local Panel_attack_now_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_attack_now_effect_1")
        Panel_attack_now_effect_2:removeAllChildren(true)
        Panel_attack_now_effect_1:removeAllChildren(true)
        Panel_attack_now_effect_1:setVisible(false)
        Panel_attack_now_effect_2:setVisible(false)
        if tonumber(_ED.npc_state[tonumber(self._npc_id)]) == 0 then
            Panel_attack_now_effect_1:setVisible(true)
            Panel_attack_now_effect_2:setVisible(true)
            local effice_1 = config_res.images.ui.effice.effice_pve_npc_checkpoint_1
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effice_1)
            local armature_1 = ccs.Armature:create("effice_pve_npc_checkpoint_1")
            draw.initArmature(armature_1, nil, -1, 0, 1)
            armature_1:setPosition(cc.p(Panel_attack_now_effect_2:getContentSize().width/2, Panel_attack_now_effect_2:getContentSize().height/2))
            Panel_attack_now_effect_2:addChild(armature_1)

            local effice_2 = config_res.images.ui.effice.effice_pve_npc_checkpoint_2
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effice_2)
            local armature_2 = ccs.Armature:create("effice_pve_npc_checkpoint_2")
            draw.initArmature(armature_2, nil, -1, 0, 1)
            armature_2:setPosition(cc.p(Panel_attack_now_effect_1:getContentSize().width/2, Panel_attack_now_effect_1:getContentSize().height/2))
            Panel_attack_now_effect_1:addChild(armature_2)
        end
    end
end

function PveNpcCell:onEnterTransitionFinish()
    local root = self.roots[1]
    if self._scene_type == battle_enum._fight_type._fight_type_107 then
        root:setVisible(true)
    else
        self:playNpcActions()
    end
end

function PveNpcCell:playNpcActions()
    if tonumber(_ED.npc_state[tonumber(self._npc_id)]) == 0 then
        local function playActions( sender )
            
        end
        local root = self.roots[1]
        root:setVisible(true)
        local tinto1 = cc.TintTo:create(0.5, 255, 255, 255)
        local tinto2 = cc.TintTo:create(0.5, 100, 100, 100)
        root:runAction(cc.Sequence:create(tinto1, tinto2, tinto1, tinto2, tinto1, cc.CallFunc:create(playActions)))
    end
end

function PveNpcCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.cells.pve.pve_map_npc_cell, self._base_pic), "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
    if tonumber(_ED.npc_state[tonumber(self._npc_id)]) == 0 then
        root:setVisible(false)
    end
	if PveNpcCell.__size == nil then
		PveNpcCell.__size = root:getContentSize()
	end
    root:setTouchEnabled(true)
    root:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 

    local Panel_npc_icon = ccui.Helper:seekWidgetByName(root,"Panel_npc_icon")
    if Panel_npc_icon ~= nil then
        self._show_npc = Panel_npc_icon:isVisible()
    end

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "pve_npc_cell_choose",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cell = self,
    },
    nil,1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_npc_box_icon"), nil, 
    {
        terminal_name = "pve_npc_cell_choose",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cell = self,
    },
    nil,1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_npc_icon"), nil, 
    {
        terminal_name = "pve_npc_cell_choose",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cell = self,
    },
    nil,1)
	
	self:onUpdateDraw()
end

function PveNpcCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_map_npc_cell, self._base_pic), self.roots[1])
end

function PveNpcCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PveNpcCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_npc_icon = ccui.Helper:seekWidgetByName(root, "Panel_npc_icon")
    local Panel_npc_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_npc_icon_1")
    local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
    local Panel_attack_now_effect_2 = ccui.Helper:seekWidgetByName(root, "Panel_attack_now_effect_2")
    local Panel_attack_now_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_attack_now_effect_1")
    local Panel_star_1 = ccui.Helper:seekWidgetByName(root, "Panel_star_1")
    local Panel_star_2 = ccui.Helper:seekWidgetByName(root, "Panel_star_2")
    local Panel_star_3 = ccui.Helper:seekWidgetByName(root, "Panel_star_3")
    local LoadingBar_npc = ccui.Helper:seekWidgetByName(root, "LoadingBar_npc")
    local Panel_npc_box_icon = ccui.Helper:seekWidgetByName(root, "Panel_npc_box_icon")

    if Panel_npc_icon ~= nil then
        Panel_npc_icon:removeBackGroundImage()
        Panel_npc_icon:removeAllChildren(true)
        Panel_npc_icon:setVisible(self._show_npc)
        Text_npc_name:setString("")
    end
    if LoadingBar_npc ~= nil then
        LoadingBar_npc:setPercent(0)
    end
    if Panel_attack_now_effect_1 ~= nil then
        Panel_attack_now_effect_1:removeAllChildren(true)
    end
    if Panel_attack_now_effect_2 ~= nil then
        Panel_attack_now_effect_2:removeAllChildren(true)
        Panel_star_1:removeAllChildren(true)
        Panel_star_2:removeAllChildren(true)
        Panel_star_3:removeAllChildren(true)
        Panel_star_1:removeBackGroundImage()
        Panel_star_2:removeBackGroundImage()
        Panel_star_3:removeBackGroundImage()
    end
    if Panel_npc_icon_1 ~= nil then
        Panel_npc_icon_1:removeBackGroundImage()
        Panel_npc_icon_1:removeAllChildren(true)
    end
    if Panel_npc_box_icon ~= nil then
        Panel_npc_box_icon:removeBackGroundImage()
        Panel_npc_box_icon:removeAllChildren(true)
    end
end

function PveNpcCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_map_npc_cell, self._base_pic), root)
	root:removeFromParent(false)
	self.roots = {}
end

function PveNpcCell:init(params)
    self._index = params[1]
    self._npc_id = params[2]
    self._base_pic = dms.int(dms["npc"], self._npc_id, npc.base_pic)
    self._scene_id = params[3]
    self._scene_type = dms.int(dms["pve_scene"], self._scene_id, pve_scene.scene_type) 
    local scene_id = dms.int(dms["pve_scene"], self._scene_id, pve_scene.scene_id) 
    
    if self._scene_type == 107 then
        if _ED.union_pve_info ~= nil then
            self._union_pve_info = _ED.union_pve_info[""..scene_id][""..self._index]
        end
        self._npc_state = tonumber(_ED.union_pve_info[""..scene_id][""..self._index].npc_state)
        -- self._is_receive = _ED.union_pve_info[""..scene_id][""..self._index].is_receive
        local scene_is_receive = zstring.split(_ED.union_pve_is_receive[scene_id], ",")
        self._is_receive = tonumber(scene_is_receive[self._index])
        if self._base_pic == 3 then
            self._base_pic = 7
        else
            self._base_pic = 8
        end
    end
    -- if self._index <= 6 then
	   self:onInit()
    -- end
	self:setContentSize(PveNpcCell.__size)
end

