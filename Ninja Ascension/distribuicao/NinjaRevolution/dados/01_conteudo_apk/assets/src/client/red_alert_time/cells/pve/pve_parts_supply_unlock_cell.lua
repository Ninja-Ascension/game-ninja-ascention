----------------------------------------------------------------------------------------------------
-- 说明：配件补给已解锁cell
-------------------------------------------------------------------------------------------------------
PvePartSupplyUnlockCell = class("PvePartSupplyUnlockCellClass", Window)
PvePartSupplyUnlockCell.__size = nil

local pve_parts_supply_unlock_create_cell_terminal = {
    _name = "pve_parts_supply_unlock_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PvePartSupplyUnlockCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_parts_supply_unlock_create_cell_terminal)
state_machine.init()

function PvePartSupplyUnlockCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._index = 0
    -- 章节ID
	self._scene_id = 0
    -- 章节开启状态
    self._state = 0

    self._npc_id = 0

    self._type = 0  --1配件副本，2装甲副本

 	local function init_pve_parts_supply_unlock_cell_terminal()
        local pve_parts_supply_unlock_cell_choose_terminal = {
            _name = "pve_parts_supply_unlock_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._type == 1 then
                    state_machine.excute("pve_parts_supply_tab_attck_index", 0, cell._index)
                elseif cell._type == 2 then
                    if getArmorPveAttackTimes() <= 0 then
                        TipDlg.drawTextDailog(armor_tip_str[36])
                        return
                    end
                end

                if __lua_project_id == __lua_project_pacific_rim then
                    _ED._current_scene_id = cell._scene_id
                    _ED._scene_npc_id = cell._npc_id
                    _ED._battle_init_type = dms.int(dms["pve_scene"], cell._scene_id, pve_scene.scene_type) 
                    _ED._npc_difficulty_index = "1"
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 3, next_terminal = "formation_defend_add_defender_formation_info", next_terminal_params = {cell._npc_id, cell._scene_id}}})
                    -- state_machine.excute("formation_defend_add_defender_formation_info", 0, {cell._npc_id, cell._scene_id})
                else
                    state_machine.excute("pve_attack_open", 0, {cell._npc_id,cell._scene_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 通关动画
        local pve_parts_supply_unlock_cell_play_complete_effect_terminal = {
            _name = "pve_parts_supply_unlock_cell_play_complete_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:playCompleteEffect()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(pve_parts_supply_unlock_cell_choose_terminal)
        state_machine.add(pve_parts_supply_unlock_cell_play_complete_effect_terminal)
        state_machine.init()
    end
	init_pve_parts_supply_unlock_cell_terminal()        	
end

function PvePartSupplyUnlockCell:playCompleteEffect()
    local root = self.roots[1]
    checkPlayEffect(50)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boom_pve)
    local armature = ccs.Armature:create("effect_boom_pve")
    draw.initArmatureTwo(armature, nil, -1, 1000, 1, 0)

    armature:setPosition(cc.p(root:getContentSize().width/2,root:getContentSize().height/2))
    root:addChild(armature)
end

function PvePartSupplyUnlockCell:onUpdateDraw()
	local root = self.roots[1]
    local Text_chapter_star_n = ccui.Helper:seekWidgetByName(root, "Text_chapter_star_n")
    local pve_scene_mould = dms.element(dms["pve_scene"], self._scene_id)
    self._npc_id = dms.atoi(pve_scene_mould, pve_scene.npcs)

    -- 底图
    local Panel_chapter_pic = ccui.Helper:seekWidgetByName(root, "Panel_chapter_pic")
    Panel_chapter_pic:removeBackGroundImage()
    local pic = dms.atoi(pve_scene_mould, pve_scene.scene_entry_pic)
    local Sprite_chapter_pic = root:getChildByName("Panel_chapter_pic"):getChildByName("Sprite_chapter_pic")
    Sprite_chapter_pic:setTexture(string.format(config_res.images.ui.pve.pve_chapter_pic, pic))
    display:ungray(Sprite_chapter_pic)
	-- Panel_chapter_pic:setBackGroundImage(string.format(config_res.images.ui.pve.pve_chapter_pic, pic))
    -- 章节名
    local Text_chapter_name = ccui.Helper:seekWidgetByName(root, "Text_chapter_name")
    local name = dms.atos(pve_scene_mould, pve_scene.scene_name)
    Text_chapter_name:setString(name)

    -- 星级
    local star = 0
    if zstring.tonumber(_ED.npc_state[tonumber(""..self._npc_id)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self._npc_id)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self._npc_id)]) ~= 0 then
        star = tonumber(_ED.npc_max_state[tonumber(""..self._npc_id)])
    else
        star = tonumber(_ED.npc_state[tonumber(""..self._npc_id)])
    end
    for i=1,3 do
        local Image_chapter_star = ccui.Helper:seekWidgetByName(root, "Image_chapter_star_"..i)
        Image_chapter_star:setVisible(false)
        if star >= i then
            Image_chapter_star:setVisible(true)
        end
    end

    -- 开启状态
    local Text_checkpoint_state_n = ccui.Helper:seekWidgetByName(root, "Text_checkpoint_state_n")
    local Sprite_checkpoint_state_bg = root:getChildByName("Sprite_checkpoint_state_bg")
    local Button_pve_parts_attack = ccui.Helper:seekWidgetByName(root, "Button_pve_parts_attack")
    
    Text_checkpoint_state_n:setString("")
    Panel_chapter_pic:setTouchEnabled(false)
    Sprite_checkpoint_state_bg:setVisible(false)
    Button_pve_parts_attack:setVisible(false)

    local max_times = dms.int(dms["npc"],self._npc_id,npc.daily_attack_count)
    local attack_times = _ED.npc_current_attack_count[tonumber(""..self._npc_id)]
    local times = max_times - attack_times
    if tonumber(self._state) < 0 then
        display:gray(Sprite_chapter_pic)
    elseif times > 0 then
        Panel_chapter_pic:setTouchEnabled(true)
        Button_pve_parts_attack:setVisible(true)
    elseif times <= 0 then
        Text_checkpoint_state_n:setString(red_alert_time_str[24])
        Sprite_checkpoint_state_bg:setVisible(true)
    end

end

function PvePartSupplyUnlockCell:onEnterTransitionFinish()

end

function PvePartSupplyUnlockCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.cells.pve.pve_parts_supply_cell, 1), "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PvePartSupplyUnlockCell.__size == nil then
		PvePartSupplyUnlockCell.__size = root:getContentSize()
	end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic"), nil, 
    {
        terminal_name = "pve_parts_supply_unlock_cell_choose",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_parts_attack"), nil, 
    {
        terminal_name = "pve_parts_supply_unlock_cell_choose",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
	
	self:onUpdateDraw()
end

function PvePartSupplyUnlockCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_parts_supply_cell, 1), self.roots[1])
end

function PvePartSupplyUnlockCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PvePartSupplyUnlockCell:clearUIInfo()
    local root = self.roots[1]
    if root ~= nil then
        local Text_chapter_name = ccui.Helper:seekWidgetByName(root, "Text_chapter_name")
        local Text_checkpoint_state_n = ccui.Helper:seekWidgetByName(root, "Text_checkpoint_state_n")
        local Button_pve_parts_attack = ccui.Helper:seekWidgetByName(root, "Button_pve_parts_attack")
        local Panel_chapter_pic = ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic")
        local Sprite_chapter_pic = root:getChildByName("Panel_chapter_pic"):getChildByName("Sprite_chapter_pic")
        if Text_chapter_name ~= nil then
            Text_chapter_name:setString("")
            Text_checkpoint_state_n:setString("")
            Button_pve_parts_attack:setVisible(true)
            Panel_chapter_pic:setTouchEnabled(true)
            Panel_chapter_pic:removeBackGroundImage()
            display:gray(Sprite_chapter_pic)
        end
    end
end

function PvePartSupplyUnlockCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_parts_supply_cell, 1), root)
	root:removeFromParent(false)
	self.roots = {}
end

function PvePartSupplyUnlockCell:init(params)
    self._index = params[1]
    self._scene_id = params[2]
    self._state = params[3]
    self._type = params[4]
    if PvePartSupplyUnlockCell.__size == nil or self._index <= 6 then
        self:onInit()
    end
	self:setContentSize(PvePartSupplyUnlockCell.__size)
end

