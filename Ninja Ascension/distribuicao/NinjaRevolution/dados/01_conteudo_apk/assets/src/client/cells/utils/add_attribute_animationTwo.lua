----------------------------------------------------------------------------------------------------
-- 说明：各种升级属性动画
-------------------------------------------------------------------------------------------------------
AddAttributeAnimationTwo = class("AddAttributeAnimationTwoClass", Window)

function AddAttributeAnimationTwo:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}			-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.action = nil		-- 动画缓存
	self.text = {}			-- 文本集
	self.textData = {}		-- 传入文本信息
	self.endType = {}		-- 文字消失方式   1.向下隐藏    2.向上隐藏
	self.endPosition = nil	-- 文字消失位子(绝对位子)
	self.endTime = 1		-- 文字消失时间
	self.types = nil
	local function init_add_attribute_animation_two_terminal()
	--通过改变其他页面内容更新本类信息
		local add_attribute_animation_two_close_terminal = {
            _name = "add_attribute_animation_two_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(add_attribute_animation_two_close_terminal)
		state_machine.init()		
	end
	init_add_attribute_animation_two_terminal()
end

function AddAttributeAnimationTwo:onUpdateDraw()
	-- 按顺序获取控件
	for i = 1,#self.text do
		if self.textData[i] ~= nil then
			self.text[11-i]:setString(self.textData[i])
		else
			self.text[11-i]:setString("")
		end
	end
end

function AddAttributeAnimationTwo:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/EquipStorage/equipment_loading_tex.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.action = csb.createTimeline("packs/EquipStorage/equipment_loading_tex.csb")
	self.action:play("Panel_up_23_in", false)
	self.roots[1]:runAction(self.action)
	
	
	self.text = {
		ccui.Helper:seekWidgetByName(root, "Text_ing_15_64"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_16_66"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_17_68"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_18_70"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_19_72"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_20_74"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_21_76"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_22_78"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_23_80"),
		ccui.Helper:seekWidgetByName(root, "Text_ing_24_82")
	}
	if self.types == 1 then
		self.text[1]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[2]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[3]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[4]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[5]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[6]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[7]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[8]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[9]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		self.text[10]:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
	end
	
	self.action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
		
        if str == "over1" then
			if self.endType == 1 then
				self.action:play("Panel_up_23_out_1", false)
				local action = cc.MoveTo:create(self.endTime, self.endPosition)
				ccui.Helper:seekWidgetByName(root, "Panel_up_23"):runAction(action)
			elseif self.endType == 2 then
				self.action:play("Panel_up_23_out_2", false)
			end
        end
		
        if str == "over2" then
        	fwin:close(self)
			-- state_machine.excute("add_attribute_animation_two_close",0,self)
        end
        if str == "over3" then
        	fwin:close(self)
			-- state_machine.excute("add_attribute_animation_two_close",0,self)
        end
		
    end)
	self:onUpdateDraw()
end

function AddAttributeAnimationTwo:onExit()
	-- state_machine.remove("add_attribute_animation_two_close")
end

function AddAttributeAnimationTwo:init(textData, endType, endPosition, endTime, types)
	-- endPosition = cc.p(0,0)
	-- endTime = 1
	-- endType = 1
	self.textData = textData
	self.endType = endType
	self.endPosition = cc.p(endPosition.x - fwin._width, endPosition.y - fwin._height)
	self.endTime = endTime
	self.types = types
end

function AddAttributeAnimationTwo:createCell()
	local cell = AddAttributeAnimationTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

