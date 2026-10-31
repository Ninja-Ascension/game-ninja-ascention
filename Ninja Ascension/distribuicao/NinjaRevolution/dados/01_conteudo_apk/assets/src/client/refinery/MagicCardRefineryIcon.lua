----------------------------------------------------------------------------------------------------
-- 说明：回收模块图标绘制 -- 魔陷卡
-------------------------------------------------------------------------------------------------------
MagicCardRefineryIcon = class("MagicCardRefineryIconClass", Window)

function MagicCardRefineryIcon:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}
	self.current_type = 0
	self.enum_type = {
		_magic_card_resolve = 1,		-- 武将分解
		_HERO_REBORN = 2,		-- 武将重生
	}
	self.mould_id = nil
	self.instance_id = nil
end

function MagicCardRefineryIcon:onUpdateDraw()
	local root = self.roots[1]
	
	local card_color = 2

	local magic_card_data = dms.element(dms["magic_trap_card_info"], self.mould_id)
	local picIndex = dms.atoi(magic_card_data, magic_trap_card_info.pic)	
	local cardType = dms.atoi(magic_card_data, magic_trap_card_info.card_type)
	local cardName = dms.atos(magic_card_data, magic_trap_card_info.card_name)				
	local iconpinzi = ccui.Helper:seekWidgetByName(root, "Panel_13_pinzi")
	if cardType == 0 then 
		card_color = 2 
		iconpinzi:setBackGroundImage("images/ui/battle/card_magic.png")
	else
		card_color = 4
		iconpinzi:setBackGroundImage("images/ui/battle/card_trap.png")
	end
	local name_text = ccui.Helper:seekWidgetByName(root, "Text_name")
	name_text:setString(cardName)
	name_text:setColor(cc.c3b(color_Type[card_color][1],color_Type[card_color][2],color_Type[card_color][3]))
	
	local icon_panel = ccui.Helper:seekWidgetByName(root, "Panel_4")
	
	icon_panel:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
end

function MagicCardRefineryIcon:onEnterTransitionFinish()
	local csbItem = csb.createNode("refinery/refinery_card_flash.csb")
	local action = csb.createTimeline("refinery/refinery_card_flash.csb")
    action:gotoFrameAndPlay(0, action:getDuration(), false)

	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	root:runAction(action)
	
	self:onUpdateDraw()
	
	
	local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(cancel_button, nil, 
	{
		terminal_name = "magic_card_resolve_cancel_one", 	
		terminal_state = 0, 
		cardId = self.instance_id,
		isPressedActionEnabled = true
	}, 
	nil, 2)

end

function MagicCardRefineryIcon:onExit()
	
end

function MagicCardRefineryIcon:init(mouldId, instanceId)
	self.mould_id = mouldId
	self.instance_id = instanceId
end

function MagicCardRefineryIcon:createCell()
	local cell = MagicCardRefineryIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end