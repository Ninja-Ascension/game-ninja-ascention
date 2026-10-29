----------------------------------------------------------------------------------------------------
-- 说明：宿命武器界面选项卡图标
----------------------------------------------------------------------------------------------------
AdventureEquipListIconCell = class("AdventureEquipListIconCellClass", Window)
AdventureEquipListIconCell.__size = nil

app.load("client.adventure.cells.skill.adventure_skill_icon_cell")

function AdventureEquipListIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.equip = 0
	self.selected = false

	-- Initialize adventure equip list cell state machine.
	local function init_equip_list_icon_cell_terminal()
        -- 选取宿命武器
        local adventure_equip_list_icon_cell_select_terminal = {
            _name = "adventure_equip_list_icon_cell_select",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	        	if terminal._selectCell ~= nil then
	        		terminal._selectCell:unselect()
	        	end
	        	local cell = params._datas.cell
	        	terminal._selectCell = cell
	        	terminal._selectCell:select()
	        	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新选中的武器图标.
        local adventure_equip_list_icon_cell_update_draw_terminal = {
            _name = "adventure_equip_list_icon_cell_update_draw",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	        	local cell = params
	        	if cell ~= nil and cell.roots ~= nil then
	        		cell:updateDraw()
	        	end
	        	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_equip_list_icon_cell_select_terminal)
        state_machine.add(adventure_equip_list_icon_cell_update_draw_terminal)
        state_machine.init()
	end

	-- call func init adventure equip list icon cell state machine.
	init_equip_list_icon_cell_terminal()
end

function AdventureEquipListIconCell:onEnterTransitionFinish()

end

function AdventureEquipListIconCell:select()
	self.selected = true
	self:updateDraw()
	state_machine.excute("adventure_mercenary_equipment_fate_update_draw", 0, self)
end

function AdventureEquipListIconCell:unselect()
	self.selected = false
	self:updateDraw()
end

function AdventureEquipListIconCell:updateDraw()
	local root = self.roots[1]

	local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
	local Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")

	-- 绘制装备图标
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop:removeAllChildren(true)
	local cell = AdventureSkillIconCell:createCell()
	cell:init(0, {id = self.equip.user_equiment_template}, 0, 2, 1)
	Panel_prop:addChild(cell)

	if self.selected == false then
		root:setColor(cc.c3b(130, 130, 130))
		cell.roots[1]:setColor(cc.c3b(130, 130, 130))
	else
		root:setColor(cc.c3b(255, 255, 255))
		cell.roots[1]:setColor(cc.c3b(255, 255, 255))
	end
	-- 获得
	if zstring.tonumber(self.equip.user_equiment_id) <=0 then
		Image_choose:setVisible(false)
		Image_lock:setVisible(true)
		Image_choose:setVisible(false)
	else
		Image_lock:setVisible(false)
		Image_choose:setVisible(false)
	end

	-- 
	if zstring.tonumber(self.equip.ship_id) > 0 then 
		Image_choose:setVisible(true)   
    end
end


function AdventureEquipListIconCell:onInit()
	local root = cacher.createUIRef("icon/item_shuming_prop.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	if AdventureEquipListIconCell.__size == nil then
		AdventureEquipListIconCell.__size = root:getContentSize()
	end

	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	fwin:addTouchEventListener(Panel_prop,       nil, 
    {
        terminal_name = "adventure_equip_list_icon_cell_select", 
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

	self:updateDraw()
end

function AdventureEquipListIconCell:onExit()
	cacher.freeRef("icon/item_shuming_prop.csb", self.roots[1])
end

function AdventureEquipListIconCell:init(equip, drawIndex)
	self.equip = equip
	self.mould_data = equip.mould_data or dms.element(dms["equipment_mould"], self.equip.user_equiment_template)
	self.drawIndex = drawIndex

	-- if drawIndex ~= nil and drawIndex < 5 then
		self:onInit()
	-- end

	self:setContentSize(AdventureEquipListIconCell.__size)
	return self
end

function AdventureEquipListIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureEquipListIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("icon/item_shuming_prop.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureEquipListIconCell:createCell()
	local cell = AdventureEquipListIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
