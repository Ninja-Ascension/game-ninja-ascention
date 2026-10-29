----------------------------------------------------------------------------------------------------
-- 说明：回收模块图标绘制 -- 装备（宝物）
-------------------------------------------------------------------------------------------------------
EquipRefineryIcon = class("EquipRefineryIconClass", Window)

function EquipRefineryIcon:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}
	self.current_type = 0
	self.enum_type = {
		_EQUIP_RESOLVE = 1,		-- 装备分解
		_TREASURE_REBORN = 2,	-- 宝物重生
		_TREASURE_UP = 3,	-- 宝物升级
	}
	self.mould_id = nil
	self.instance_id = nil
end

function EquipRefineryIcon:onUpdateDraw()
	local root = self.roots[1]
	if self.enum_type._EQUIP_RESOLVE == self.current_type or self.enum_type._TREASURE_UP == self.current_type then
		local equip_data = dms.element(dms["equipment_mould"], self.mould_id)
		local equip_name = dms.atos(equip_data, equipment_mould.equipment_name)
		local equip_color = dms.atoi(equip_data, equipment_mould.grow_level)
		local equip_icon = dms.atoi(equip_data, equipment_mould.All_icon)
		
		local name_text = ccui.Helper:seekWidgetByName(root, "Text_17")
		name_text:setString(equip_name)
		name_text:setColor(cc.c3b(color_Type[equip_color+1][1],color_Type[equip_color+1][2],color_Type[equip_color+1][3]))
		
		local icon_panel = ccui.Helper:seekWidgetByName(root, "Panel_zhuangbei")
		icon_panel:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", equip_icon))
	elseif self.enum_type._TREASURE_REBORN == self.current_type then
		local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_12") 
		cancel_button:setVisible(false)
	end
end

function EquipRefineryIcon:onEnterTransitionFinish()
	local csbItem = csb.createNode("refinery/refinery_information_flash.csb")
	local action = csb.createTimeline("refinery/refinery_information_flash.csb")
    action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- action:setFrameEventCallFunc(function (frame)
        -- if nil == frame then
            -- return
        -- end

        -- local str = frame:getEvent()
        -- if str == "exit" then
           
        -- end
    -- end)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	if self.enum_type._TREASURE_UP == self.current_type then
	else
		root:runAction(action)
	end
	
	self:onUpdateDraw()
	
	if self.enum_type._EQUIP_RESOLVE == self.current_type then
		local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_12")
		fwin:addTouchEventListener(cancel_button, nil, 
		{
			terminal_name = "equip_resolve_cancel_one", 	
			terminal_state = 0, 
			_equiment_id = self.instance_id,
			isPressedActionEnabled = true
		}, 
		nil, 2)
	end
	
	if self.enum_type._TREASURE_UP == self.current_type then
		local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_12")
		fwin:addTouchEventListener(cancel_button, nil, 
		{
			terminal_name = "treasure_resolve_cancel_one", 	
			terminal_state = 0, 
			_equiment_id = self.instance_id,
			isPressedActionEnabled = true
		}, 
		nil, 2)
	end
end

function EquipRefineryIcon:onExit()
	
end

function EquipRefineryIcon:init(interfaceType, mouldId, instanceId)
	self.current_type = interfaceType
	self.mould_id = mouldId
	self.instance_id = instanceId
end

function EquipRefineryIcon:createCell()
	local cell = EquipRefineryIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end