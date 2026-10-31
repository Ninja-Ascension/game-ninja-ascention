----------------------------------------------------------------------------------------------------
-- 说明：远征npc cell
-------------------------------------------------------------------------------------------------------
ExpeditionPveNpcCell = class("ExpeditionPveNpcCellClass", Window)
ExpeditionPveNpcCell.__size = nil

local expedition_pve_npc_create_cell_terminal = {
    _name = "expedition_pve_npc_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ExpeditionPveNpcCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(expedition_pve_npc_create_cell_terminal)
state_machine.init()

function ExpeditionPveNpcCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._state = 0
    -- 场景id
    self._scene_id = 0
    self._union_pve_info = nil
    
    app.load("client.red_alert_time.campaign.ExpeditionPveAttack")
 	local function init_expedition_pve_npc_cell_terminal()
        local expedition_pve_npc_cell_choose_terminal = {
            _name = "expedition_pve_npc_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("expedition_update_draw", 0, false)
                    end
                end
                
                if cell._state == 1 then
                    protocol_command.draw_expedition_reward.param_list = cell._index-1
                    NetworkManager:register(protocol_command.draw_expedition_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                else
                    if __lua_project_id == __lua_project_pacific_rim then
                        _ED._battle_init_type = battle_enum._fight_type._fight_type_201
                        _ED._current_scene_id = 1
                        _ED._scene_npc_id = 1
                        _ED._npc_difficulty_index = cell._index - 1
                        state_machine.excute("formation_window_open", 0, {_datas = {form_type = 8, next_terminal = "formation_defend_add_expedition_formation_info", next_terminal_params = {cell._index}}})
                        -- state_machine.excute("formation_defend_add_expedition_formation_info", 0, {cell._index})
                    else
                        state_machine.excute("expedition_pve_attack_open", 0, {cell._index})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(expedition_pve_npc_cell_choose_terminal)
        state_machine.init()
    end
	init_expedition_pve_npc_cell_terminal()        	
end

function ExpeditionPveNpcCell:onUpdateDraw()
	local root = self.roots[1]
    -- npc名字
    local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
    local npc_name = zstring.split(_ED.user_expedition_info.current_nicknames, ",")
    Text_npc_name:setString(self._index.."."..npc_name[self._index])
    local Image_npc_name_bg = ccui.Helper:seekWidgetByName(root, "Image_npc_name_bg")
    Image_npc_name_bg:setVisible(true)
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
    Panel_npc_icon:removeBackGroundImage()
    Panel_npc_icon:removeAllChildren(true)
    local pic = zstring.split(dms.string(dms["expedition_config"], 5, expedition_config.param), ",")
    Panel_npc_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic[self._index]))

    local current_enemy_formation = zstring.split(_ED.user_expedition_info.current_enemy_formation, "|")
    -- for i=1,6 do
    --     local tank_id = zstring.split(current_enemy_formation[i], ",")
    --     if tonumber(tank_id[2]) > 0 then
    --         local tank_data = dms.element(dms["ship_mould"], tank_id[2])
    --         local pic = dms.atoi(tank_data, ship_mould.All_icon)
    --         Panel_npc_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
    --         break
    --     end
    -- end

    local Image_npc_bar_bg = ccui.Helper:seekWidgetByName(root, "Image_npc_bar_bg")
    local LoadingBar_npc = ccui.Helper:seekWidgetByName(root, "LoadingBar_npc")
    local Image_npc_rock = ccui.Helper:seekWidgetByName(root, "Image_npc_rock")
    
    local Panel_attack_now_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_attack_now_effect_1")
    Image_npc_bar_bg:setVisible(false)
    LoadingBar_npc:setVisible(false)
    Image_npc_rock:setVisible(false)
    Panel_attack_now_effect_1:removeAllChildren(true)
    Panel_attack_now_effect_1:setVisible(false)
    if self._state == 0 then
        Image_npc_bar_bg:setVisible(true)
        LoadingBar_npc:setVisible(true)
        Panel_attack_now_effect_1:setVisible(true)
        local progress = 100
        local max_enemy_formation = zstring.split(_ED.user_expedition_info.max_enemy_formation, "|")
        local max_tank_count = 0
        local now_tank_count = 0
        for i=1,6 do
            local max_enemy_info = zstring.split(max_enemy_formation[i], ",")
            local current_enemy_info = zstring.split(current_enemy_formation[i], ",")
            -- if tonumber(max_enemy_info[3]) > 0 and tonumber(current_enemy_info[3]) > 0 then
                max_tank_count = max_tank_count + max_enemy_info[3]
                now_tank_count = now_tank_count + current_enemy_info[3]
            -- end
        end
        progress = now_tank_count / max_tank_count * 100
        LoadingBar_npc:setPercent(progress)

        local effice_2 = config_res.images.ui.effice.effice_pve_npc_checkpoint_2
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effice_2)
        local armature_2 = ccs.Armature:create("effice_pve_npc_checkpoint_2")
        draw.initArmature(armature_2, nil, -1, 0, 1)
        armature_2:setPosition(cc.p(Panel_attack_now_effect_1:getContentSize().width/2, Panel_attack_now_effect_1:getContentSize().height/2))
        Panel_attack_now_effect_1:addChild(armature_2)

    elseif self._state == 1 then
        Panel_npc_icon:removeBackGroundImage()
        Panel_npc_icon:removeAllChildren(true)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_box_get)
        local armature = ccs.Armature:create("effect_box_get")
        armature:getAnimation():playWithIndex(0)
        armature:setPosition(cc.p(Panel_npc_icon:getContentSize().width/2,Panel_npc_icon:getContentSize().height/2))
        Panel_npc_icon:addChild(armature)

        if self._index % 3 == 0 then
            local icon_name = string.format(config_res.images.ui.pve.treasure_box_2,1)
            local icon = ccs.Skin:create(icon_name)
            armature:getBone("Layer1"):addDisplay(icon, 0)
        end

    elseif self._state == 2 then
        root:setTouchEnabled(false)
        if self._index % 3 == 0 then
            Panel_npc_icon:setBackGroundImage(string.format(config_res.images.ui.pve.treasure_box_2,2))
        else
            Panel_npc_icon:setBackGroundImage(string.format(config_res.images.ui.pve.treasure_box,2))
        end
    else
        Image_npc_name_bg:setVisible(false)
        Text_npc_name:setString("")
        Image_npc_rock:setVisible(true)
        root:setTouchEnabled(false)
        root:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
    end
end

function ExpeditionPveNpcCell:onEnterTransitionFinish()

end


function ExpeditionPveNpcCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.cells.pve.pve_map_npc_cell, 5), "root")
    table.insert(self.roots, root)
 	self:addChild(root) 

	if ExpeditionPveNpcCell.__size == nil then
		ExpeditionPveNpcCell.__size = root:getContentSize()
	end
    root:setTouchEnabled(true)
    root:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "expedition_pve_npc_cell_choose",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cell = self,
    },
    nil,1)
	
	self:onUpdateDraw()
end

function ExpeditionPveNpcCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_map_npc_cell, 5), self.roots[1])
end

function ExpeditionPveNpcCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ExpeditionPveNpcCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_npc_icon = ccui.Helper:seekWidgetByName(root, "Panel_npc_icon")
    local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
    local LoadingBar_npc = ccui.Helper:seekWidgetByName(root, "LoadingBar_npc")
    local Image_npc_name_bg = ccui.Helper:seekWidgetByName(root, "Image_npc_name_bg")
    local Panel_attack_now_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_attack_now_effect_1")

    if Panel_npc_icon ~= nil then
        Panel_attack_now_effect_1:removeAllChildren(true)
        Panel_npc_icon:removeBackGroundImage()
        Panel_npc_icon:removeAllChildren(true)
        Text_npc_name:setString("")
        LoadingBar_npc:setPercent(0)
        Image_npc_name_bg:setVisible(true)
    end
end

function ExpeditionPveNpcCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_map_npc_cell, 5), root)
	root:removeFromParent(false)
	self.roots = {}
end

function ExpeditionPveNpcCell:init(params)
    self._index = params[1]
    self._state = tonumber(params[2])
    
    -- if self._index <= 6 then
	   self:onInit()
    -- end
	self:setContentSize(ExpeditionPveNpcCell.__size)
end

