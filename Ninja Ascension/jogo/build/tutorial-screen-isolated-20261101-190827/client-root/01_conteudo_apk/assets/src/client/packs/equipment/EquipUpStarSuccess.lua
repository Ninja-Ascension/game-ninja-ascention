----------------------------------------------------------------------------------------------------
-- 说明：装备升星动画
-------------------------------------------------------------------------------------------------------
EquipUpStarSuccess = class("EquipUpStarSuccessClass", Window)

function EquipUpStarSuccess:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	self.equipmentInstance = nil -- 装备数据
	self.befor_add_attribute = nil
	self.befor_star_level = 0
	self._controlcount = 0
	self.add_attribute_value = 0 
	
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_hero_advance_success_terminal()
		
		-- 设计在升级界面，点击武将全身图像需要处理的逻辑
		local equip_up_star_success_show_end_terminal = {
            _name = "equip_up_star_success_show_end",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- if nil ~= instance.keepOutPanel then
					-- instance.keepOutPanel[1]:setVisible(true)
					-- instance.keepOutPanel[2]:setVisible(false)
				-- end

				local action = nil
		
				action = csb.createTimeline("packs/EquipStorage/equipment_shengxingdh.csb")
				action:play("advanced_show_over", false)
				instance.roots[1]:runAction(action)
				
				action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end
					
					local str = frame:getEvent()
					if str == "show_break_through_over" then
						fwin:close(instance)
						
					elseif str == "close" then
					end
				
				end)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(equip_up_star_success_show_end_terminal)		
        state_machine.init()
	end
	init_hero_advance_success_terminal()
end

function EquipUpStarSuccess:onUpdateDraw() -- Text_45
	local root = self.roots[1]
	if root == nil then 
		return
	end

	local equipName = dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name)
	local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
	local picIndex = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.All_icon)
	local allPic = ccui.Helper:seekWidgetByName(root, "Panel_hero_tupo")
	ccui.Helper:seekWidgetByName(root, "Text_jiesuo_01"):setString(equipName)
	allPic:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", picIndex))

	local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)
	
	local currentStar = zstring.tonumber(self.equipmentInstance.current_star_level)
	local afterStar = zstring.tonumber(_ED.user_equiment[self.equipmentInstance.user_equiment_id].current_star_level)
	for i=1,5 do
		local ImageStarOpenBefor = ccui.Helper:seekWidgetByName(root, "Image_o_"..i)
		local ImageStarCloseBefor = ccui.Helper:seekWidgetByName(root, "Image_c_"..i)


		local ImageStarOpenAfter = ccui.Helper:seekWidgetByName(root, "Image_o_"..i.."_0")
		local ImageStarCloseAfter = ccui.Helper:seekWidgetByName(root, "Image_c_"..i.."_0")

		ImageStarOpenBefor:setVisible(false)
		ImageStarCloseBefor:setVisible(false)
		ImageStarOpenAfter:setVisible(false)
		ImageStarCloseAfter:setVisible(false)
		if i <= maxStar then 
			ImageStarCloseBefor:setVisible(true)
			ImageStarCloseAfter:setVisible(true)
		end
		if i <= self.befor_star_level then 
			ImageStarOpenBefor:setVisible(true)
		end
		if i <= afterStar then 
			ImageStarOpenAfter:setVisible(true)
		end
	end
	if self.befor_add_attribute ~= nil then 
		local adds = zstring.split(self.befor_add_attribute,",")

		ccui.Helper:seekWidgetByName(root, "Text_7"):setString(_influence_type[zstring.tonumber(adds[1])+1]..":")
		ccui.Helper:seekWidgetByName(root, "Text_7_1"):setString(_influence_type[zstring.tonumber(adds[1]+1)]..":")
		ccui.Helper:seekWidgetByName(root, "Text_45"):setString(""..self.add_attribute_value)
		local addsAfter = zstring.split(_ED.user_equiment[self.equipmentInstance.user_equiment_id].add_attribute,",")
		ccui.Helper:seekWidgetByName(root, "Text_41"):setString(""..addsAfter[2])	
	end
	
end

function EquipUpStarSuccess:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/EquipStorage/equipment_shengxingdh.csb")
	local root = nil
	root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	root:setTouchEnabled(true)
	local action = csb.createTimeline("packs/EquipStorage/equipment_shengxingdh.csb")
	action:play("advanced_show", false)
	root:runAction(action)
	table.insert(self.actions,action)
	action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "information_popup_over" then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_14"), nil, {terminal_name = "equip_up_star_success_show_end"}, nil, 0)
		elseif str == "close" then
		end
		
		end)
	
	self:onUpdateDraw()
	playEffectForAbilityUp()
	
end

function EquipUpStarSuccess:close( ... )

end
function EquipUpStarSuccess:onExit()
	self._controlcount = 0
	state_machine.remove("equip_up_star_success_show_end")
end

function EquipUpStarSuccess:init(equipment,add_attribute,star_level,attribute_value)
	self.equipmentInstance = equipment
	self.befor_add_attribute = add_attribute
	self.befor_star_level = star_level
	self.add_attribute_value = attribute_value
end

