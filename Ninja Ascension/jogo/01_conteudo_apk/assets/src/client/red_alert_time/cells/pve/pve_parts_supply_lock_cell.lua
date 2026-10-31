----------------------------------------------------------------------------------------------------
-- 说明：配件补给未解锁cell
-------------------------------------------------------------------------------------------------------
PvePartSupplyLockCell = class("PvePartSupplyLockCellClass", Window)
PvePartSupplyLockCell.__size = nil

local pve_parts_supply_lock_create_cell_terminal = {
    _name = "pve_parts_supply_lock_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PvePartSupplyLockCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_parts_supply_lock_create_cell_terminal)
state_machine.init()

function PvePartSupplyLockCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._index = 0
    -- 章节ID
	self._scene_id = 0
    -- 章节开启状态
    self._state = 0
 	local function init_pve_parts_supply_lock_cell_terminal()

        state_machine.init()
    end
	init_pve_parts_supply_lock_cell_terminal()        	
end

function PvePartSupplyLockCell:onUpdateDraw()
	local root = self.roots[1]
    local Text_chapter_star_n = ccui.Helper:seekWidgetByName(root, "Text_chapter_star_n")
    local pve_scene_mould = dms.element(dms["pve_scene"], self._scene_id)

    -- 底图
    local Panel_pve_parts_pic = ccui.Helper:seekWidgetByName(root, "Panel_pve_parts_pic")
    local pic = dms.atoi(pve_scene_mould, pve_scene.scene_entry_pic)
	local Sprite_pve_parts_pic = root:getChildByName("Panel_pve_parts_pic"):getChildByName("Sprite_pve_parts_pic")
	Sprite_pve_parts_pic:setTexture(string.format(config_res.images.ui.pve.pve_chapter_pic, pic))
    display:gray(Sprite_pve_parts_pic)

    -- 章节名
    local Text_chapter_name = ccui.Helper:seekWidgetByName(root, "Text_chapter_name")
    local name = dms.atos(pve_scene_mould, pve_scene.scene_name)
    Text_chapter_name:setString(name)

    local Text_parts_attack_have_lv_n = ccui.Helper:seekWidgetByName(root, "Text_parts_attack_have_lv_n")
    local open_level = dms.atoi(pve_scene_mould, pve_scene.open_level)
    Text_parts_attack_have_lv_n:setString(open_level)
end

function PvePartSupplyLockCell:onEnterTransitionFinish()

end

function PvePartSupplyLockCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.cells.pve.pve_parts_supply_cell, 2), "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PvePartSupplyLockCell.__size == nil then
		PvePartSupplyLockCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function PvePartSupplyLockCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_parts_supply_cell, 2), self.roots[1])
end

function PvePartSupplyLockCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PvePartSupplyLockCell:clearUIInfo()
    local root = self.roots[1]
    if root ~= nil then
        local Panel_pve_parts_pic = ccui.Helper:seekWidgetByName(root,"Panel_pve_parts_pic")
        local Text_parts_attack_have_lv_n = ccui.Helper:seekWidgetByName(root,"Text_parts_attack_have_lv_n")
        local Text_chapter_name = ccui.Helper:seekWidgetByName(root,"Text_chapter_name")
        local Sprite_pve_parts_pic = root:getChildByName("Panel_pve_parts_pic"):getChildByName("Sprite_pve_parts_pic")
        if Panel_pve_parts_pic ~= nil then
            Panel_pve_parts_pic:setTouchEnabled(true)
            Panel_pve_parts_pic:removeBackGroundImage()
            Text_parts_attack_have_lv_n:setString("")
            Text_chapter_name:setString("")
            display:gray(Sprite_pve_parts_pic)
        end
    end
end

function PvePartSupplyLockCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.pve.pve_parts_supply_cell, 2), root)
	root:removeFromParent(false)
	self.roots = {}
end

function PvePartSupplyLockCell:init(params)
    self._index = params[1]
    self._scene_id = params[2]
    self._state = params[3]
    if PvePartSupplyLockCell.__size == nil or self._index <= 6 then
	   self:onInit()
    end
	self:setContentSize(PvePartSupplyLockCell.__size)
end

