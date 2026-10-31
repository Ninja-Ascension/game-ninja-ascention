----------------------------------------------------------------------------------------------------
-- 说明：战将夺宝奖励小图标

-------------------------------------------------------------------------------------------------------
RaidersCutRewardCell = class("RaidersCutRewardCellClass", Window)
RaidersCutRewardCell.__size = nil

local raiders_cut_reward_create_cell_terminal = {
    _name = "raiders_cut_reward_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local prop_data = params[1]
        local index = params[2]
        local cell = RaidersCutRewardCell:new()
        cell:init(prop_data,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(raiders_cut_reward_create_cell_terminal)
state_machine.init()

function RaidersCutRewardCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.raiders_data = nil
	self.prop_data = nil
	self.open_window = false
   	self.quality = nil
end


function RaidersCutRewardCell:onUpdateDraw()
	local root = self.roots[1]

	local prop_type  = self.prop_data.prop_type 	
	local prop_numbers = self.prop_data.item_value
	local prop_id = self.prop_data.prop_item

	local Panel_props_quality = ccui.Helper:seekWidgetByName(root, "Panel_props_quality") -- 道具品质
	local Panel_porps_icon = ccui.Helper:seekWidgetByName(root, "Panel_porps_icon") -- 道具图标
	local Text_props_number = ccui.Helper:seekWidgetByName(root, "Text_props_number") -- 道具数量
	local Image_props_quality_square = ccui.Helper:seekWidgetByName(root,"Image_props_quality_square") -- 碎片选中
    local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push") -- 推送红点
	
	Panel_props_quality:removeAllChildren(true)
	Panel_props_quality:removeBackGroundImage()
	Panel_porps_icon:removeAllChildren(true)
	Panel_porps_icon:removeBackGroundImage()
	Panel_porps_icon:setTouchEnabled(true)	
	Text_props_number:setString("")
	Text_props_number:setVisible(true)
	Image_props_quality_square:setVisible(false)
    Image_push:setVisible(false)

	if tonumber(prop_type) == 1 then
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_4002.png")
	elseif tonumber(prop_type) == 2 then
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_4001.png")		
	elseif tonumber(prop_type) == 5 then
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_4008.png")
	elseif tonumber(prop_type) == 6 then
		local pic_index = dms.int(dms["prop_mould"],prop_id,prop_mould.pic_index)
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_"..pic_index..".png")	
	elseif tonumber(prop_type) == 7 then
		local pic_index = dms.int(dms["equipment_mould"],prop_id,equipment_mould.pic_index)
		Panel_porps_icon:setBackGroundImage("images/ui/equip/equip_"..pic_index..".png")
	elseif tonumber(prop_type) == 13 then
		local pic_index = dms.int(dms["ship_mould"],prop_id,ship_mould.head_icon) + 10000
		Panel_porps_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
	elseif tonumber(prop_type) == 31 then
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_4016.png")
	elseif tonumber(prop_type) == 32 then
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_4017.png")
	elseif tonumber(prop_type) == 33 then
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_4019.png")
	elseif tonumber(prop_type) == 34 then
		local pic_index = dms.int(dms["gems_mould"],prop_id,gems_mould.pic)
		local level = dms.int(dms["gems_mould"],prop_id,gems_mould.level)
		prop_numbers = "+"..level
		Panel_porps_icon:setBackGroundImage("images/ui/equip_gem_icon/equip_gem_icon_"..pic_index..".png")
	end	

	Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. self.quality .. ".png")		
	if prop_numbers == 1 then
		Text_props_number:setString("")
	else
		Text_props_number:setString(prop_numbers)
	end
	

	local function buttonTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
        if ccui.TouchEventType.began == evenType then
		    local function openOtherWindow( ... )
		    	if self.open_window == false then
		    		state_machine.excute("props_information_window_open",0,{
		    			2,self.prop_data,self.prop_data,8,0,false,true,cc.p(__spoint.x,__spoint.y)
		    			})
		    		self.open_window = true
		    	else
		    		state_machine.excute("props_information_window_close", 0, 0)
		    	end
		    end 
			self.open_window = false   	    
		    local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
		    self:stopAllActions()
			self:runAction(action)
        elseif ccui.TouchEventType.moved == evenType then

        elseif ccui.TouchEventType.canceled == evenType then
        	self:stopAllActions()
        	state_machine.excute("props_information_window_close", 0, 0)
        elseif ccui.TouchEventType.ended == evenType then
        	self:stopAllActions()
        	state_machine.excute("props_information_window_close", 0, 0)
        	if self.open_window == true then
        		return
        	end
        end
    end
    
    fwin:addTouchEventListener(Panel_porps_icon, buttonTouchEvent, {terminal_name = "",_cell = self}, nil, 0)	
end

function RaidersCutRewardCell:onEnterTransitionFinish()

end

function RaidersCutRewardCell:onInit()

	local root = cacher.createUIRef("cells/packs/resource_4.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if RaidersCutRewardCell.__size == nil then
		RaidersCutRewardCell.__size = root:getContentSize()
	end
	self:onUpdateDraw()
end

function RaidersCutRewardCell:onExit()
	cacher.freeRef("cells/packs/resource_4.csb", root)

end

function RaidersCutRewardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RaidersCutRewardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("cells/packs/resource_4.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function RaidersCutRewardCell:init(raiders_data,index)
	self.raiders_data = raiders_data
	self.prop_data = raiders_data.reward_data
	self.quality = raiders_data.quality
	if index ~= nil and index < 6 then
		self:onInit()
	end
	self:setContentSize(RaidersCutRewardCell.__size)
end

