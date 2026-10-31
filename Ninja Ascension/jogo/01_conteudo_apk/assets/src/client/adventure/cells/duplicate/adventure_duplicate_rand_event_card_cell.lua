----------------------------------------------------------------------------------------------------
-- 说明：意外事件 -- 翻牌动画
-------------------------------------------------------------------------------------------------------
AdventureDuplicateRandEventCardCell = class("AdventureDuplicateRandEventCardCellClass", Window)
 
function AdventureDuplicateRandEventCardCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.armature = {}
	self.prop_type = 0 
	self.amount = 0 
	self.resource_type = 0
	self.panel_grid = nil
	self.Panel_Ligth0 = nil
	self.Panel_Ligth1 = nil
	self.armatureLigth0 = nil
	self.armatureLigth1 = nil
	app.load("client.adventure.cells.prop.adventure_sign_prop_icon_cell")

end

-- 卡牌抖动动画
function AdventureDuplicateRandEventCardCell:playShake(isSend)
	
	self.roots[1]:stopAllActions()
	self.action = csb.createTimeline("duplicate/maoxian_shijian_card.csb")
	self.action:play("animation0", true)
	self.roots[1]:runAction(self.action)
	ccui.Helper:seekWidgetByName(self.roots[1],"Panel_cq_b_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(self.roots[1],"Panel_cq_z_1"):setVisible(false)
	
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "window_open_over" then
			if isSend == true then
				state_machine.excute("battle_win_card_lottery_update_card_shake",0,{target = self})
				self:playTurnLight(true)
			end
		elseif str == "over" then
		end
    end)
end

-- 停止卡牌抖动动画
function AdventureDuplicateRandEventCardCell:stopPlayShake()
	
	self.roots[1]:stopAllActions()
	ccui.Helper:seekWidgetByName(self.roots[1],"Panel_cq_b_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(self.roots[1],"Panel_cq_z_1"):setVisible(false)
	
	
end
-- 卡牌翻转动画
function AdventureDuplicateRandEventCardCell:playTurn(isSend)
	--print("----开始发牌")
	self.roots[1]:stopAllActions()
	self.panel_grid:removeAllChildren()
	self.action = csb.createTimeline("duplicate/maoxian_shijian_card.csb")
	self.action:play("animation1", false)
	self.roots[1]:runAction(self.action)
	csb.animationChangeToAction(self.armatureLigth0, 0, 0, false)

	self.armatureLigth0:setVisible(true)
	self.armatureLigth0._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            armatureBack:setVisible(false)
        end
    end   
    csb.animationChangeToAction(self.armatureLigth1, 0, 0, false)
	self.armatureLigth1:setVisible(true)
	self.armatureLigth1._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            armatureBack:setVisible(false)
        end
    end   
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "window_open_over" then
		elseif str == "over" then
			if isSend == true then
				state_machine.excute("adventure_event_box_rolling_card_update",0,0)
			end
			
			self:showGoods()
		end
    end)
end

-- 卡牌翻转动画后的高亮状态
function AdventureDuplicateRandEventCardCell:playTurnLight(isSend)
	if isSend == true then
		local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_cd_light")
		panel:setVisible(true)
		-- local action = ccui.Helper:seekWidgetByName(root, "Panel_cd_light"):getChildByName("")
	else
		local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_cd_light")
		panel:setVisible(false)
	end
end

--动画结束,显示获得物-- 物品id x个数
function AdventureDuplicateRandEventCardCell:showGoods()
	self.panel_grid:removeAllChildren(true)
	local cell = adventureSignPropIconCell:createCell()
    if zstring.tonumber(self.prop_type) == 6 then          -- 目前用propIcon代表类型（道具或者货币）
        cell:init(0,  {mould_id = self.prop_id}, self.prop_amount, 0)
       
    else
        cell:init(0, {resource_type = self.prop_type}, self.prop_amount, 0)
    end
    self.panel_grid:addChild(cell)
    ccui.Helper:seekWidgetByName(self.roots[1],"Panel_cq_b_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(self.roots[1],"Panel_cq_z_1"):setVisible(true)
 
end

-- 物品模板id x数量
function AdventureDuplicateRandEventCardCell:init(prop_type, prop_id,prop_amount)
	self.prop_type = prop_type
	self.prop_id = prop_id
	self.prop_amount = prop_amount
end

-- 离开
function AdventureDuplicateRandEventCardCell:toExit()
	
end

function AdventureDuplicateRandEventCardCell:onUpdateDraw()
	
end

function AdventureDuplicateRandEventCardCell:cleanGridChild()
	if self.panel_grid ~= nil then 
		self.panel_grid:removeAllChildren(true)
	end
end

function AdventureDuplicateRandEventCardCell:onEnterTransitionFinish()
    local csbItem = csb.createNode("duplicate/maoxian_shijian_card.csb")
	local root = csbItem:getChildByName("root")
	--root:removeFromParent(true)
	self:addChild(csbItem)
	table.insert(self.roots, root)
	
	self.panel_grid = ccui.Helper:seekWidgetByName(root, "Panel_7_5")
	self.Panel_Ligth0 = ccui.Helper:seekWidgetByName(root, "Panel_cd_light_0")
	self.Panel_Ligth1 = ccui.Helper:seekWidgetByName(root, "Panel_cd_light_1")
	
	self.Panel_Ligth0:setVisible(false)
	self.Panel_Ligth1:setVisible(false)
	self.armatureLigth0 = self.Panel_Ligth0:getChildByName("ArmatureNode_2") -- 挖矿动作动画
    self.armatureLigth0:setVisible(false)
    draw.initArmature(self.armatureLigth0, nil, -1, 0, 1)
    csb.animationChangeToAction(self.armatureLigth0, 0, 0, false)
	
	self.armatureLigth1 = self.Panel_Ligth1:getChildByName("ArmatureNode_3") -- 挖矿动作动画
    self.armatureLigth1:setVisible(false)
    draw.initArmature(self.armatureLigth1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.armatureLigth1, 0, 0, false)
	
	self.action = csb.createTimeline("duplicate/maoxian_shijian_card.csb")
	self.panel_grid:setVisible(true)
	
end

function AdventureDuplicateRandEventCardCell:onExit()
	--state_machine.remove("battle_player_head_update")
end
