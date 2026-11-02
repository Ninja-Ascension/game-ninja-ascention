----------------------------------------------------------------------------------------------------
-- 说明：装备列表项
----------------------------------------------------------------------------------------------------
AdventureEquipListCell = class("AdventureEquipListCellClass", Window)
AdventureEquipListCell.__size = nil

app.load("client.adventure.cells.skill.adventure_skill_icon_cell")

function AdventureEquipListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.equip = 0
	self.hero = nil

	-- Initialize adventure equip list cell state machine.
	local function init_equip_list_cell_terminal()
        -- 装备穿戴
        local adventure_equip_list_cell_wear_terminal = {
            _name = "adventure_equip_list_cell_wear",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	if zstring.tonumber(cell.equip.user_equiment_id) <=0 then
            		return false
            	end
                local function responseSwitchEquipmentCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
							-- response.node:updateDraw()
							local listView = response.node:getParent():getParent()
							local items = listView:getItems()
							for i,v in ipairs(items) do
								v:updateDraw() 
							end
							state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0,self.hero)	
                        end
                    end
                end

                protocol_command.switch_equipment.param_list = "" .. cell.equip.user_equiment_id
                NetworkManager:register(protocol_command.switch_equipment.code, nil, nil, nil, cell, responseSwitchEquipmentCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_equip_list_cell_wear_terminal)
        state_machine.init()
	end

	-- call func init adventure equip list cell state machine.
	init_equip_list_cell_terminal()
end

function AdventureEquipListCell:onEnterTransitionFinish()

end

function AdventureEquipListCell:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	
    local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")
	Image_10:setVisible(false)

	local Text_nohuode = ccui.Helper:seekWidgetByName(root, "Text_nohuode")
	local Text_huode = ccui.Helper:seekWidgetByName(root, "Text_huode")
	local Text_zhuangbei = ccui.Helper:seekWidgetByName(root, "Text_zhuangbei")
	Text_nohuode:setVisible(false)
	Text_huode:setVisible(false)
	Text_zhuangbei:setVisible(false)

	-- 绘制装备图标
	local Panel_weapon = ccui.Helper:seekWidgetByName(root, "Panel_weapon")
	Panel_weapon:removeAllChildren(true)
	local cell = AdventureSkillIconCell:createCell()
	cell:init(0, {id = self.equip.user_equiment_template}, 0, 2)
	Panel_weapon:addChild(cell)

	-- 绘制装备名称
	local Text_weapon_name = ccui.Helper:seekWidgetByName(root, "Text_weapon_name")
	Text_weapon_name:setString(dms.atos(self.mould_data, equipment_mould.equipment_name))

	-- 绘制描述信息
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")
	local skillMouldId = dms.atoi(self.mould_data, equipment_mould.skill_mould)
    local skillMouldData = dms.element(dms["skill_mould"], skillMouldId)
    local skill_name = dms.atos(skillMouldData, skill_mould.skill_name)
	Text_shuoming:setString(skill_name)

	if zstring.tonumber(self.equip.user_equiment_id) <=0 then
		root:setColor(cc.c3b(130, 130, 130))
		cell.roots[1]:setColor(cc.c3b(130, 130, 130))
		Text_nohuode:setVisible(true)
	else
		-- 已经获得
		if zstring.tonumber(self.equip.ship_id) > 0 then
			root:setColor(cc.c3b(184, 233, 10))
			cell.roots[1]:setColor(cc.c3b(184, 233, 10))
			Text_zhuangbei:setVisible(true)
			Image_10:setVisible(true)
		else
			root:setColor(cc.c3b(255, 255, 255))
			cell.roots[1]:setColor(cc.c3b(255, 255, 255))
			Text_huode:setVisible(true)
		end
	end
end

function AdventureEquipListCell:onInit()
	local root = cacher.createUIRef("list/list_fatalism_weapon.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	if AdventureEquipListCell.__size == nil then
		AdventureEquipListCell.__size = root:getContentSize()
	end

	local Button_6 = ccui.Helper:seekWidgetByName(root, "Button_6")
	fwin:addTouchEventListener(Button_6,       nil, 
    {
        terminal_name = "adventure_equip_list_cell_wear", 
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    self:updateDraw()
end

function AdventureEquipListCell:onExit()
	cacher.freeRef("list/list_fatalism_weapon.csb", self.roots[1])
end

function AdventureEquipListCell:init(equip, drawIndex ,hero)
	self.equip = equip
	self.hero = hero
	self.mould_data = equip.mould_data or dms.element(dms["equipment_mould"], self.equip.user_equiment_template)
	self.drawIndex = drawIndex

	--if drawIndex ~= nil and drawIndex < 5 then
	self:onInit()
	--end

	self:setContentSize(AdventureEquipListCell.__size)
	return self
end

function AdventureEquipListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureEquipListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_fatalism_weapon.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureEquipListCell:createCell()
	local cell = AdventureEquipListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
