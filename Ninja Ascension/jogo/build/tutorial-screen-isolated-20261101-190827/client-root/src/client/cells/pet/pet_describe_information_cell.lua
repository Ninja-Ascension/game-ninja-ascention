---------------------------------
---说明：宠物信息界面的 简介

---------------------------------

PetDescribeformation = class("PetDescribeformationClass", Window)
   
function PetDescribeformation:ctor()
    self.super:ctor()
	self.hero = nil
	self.userfashion = nil  
	self.info = {}
	self.listPositionX = nil
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	local function init_formation_hero_train_terminal()
		-- local pet_information_to_train_terminal = {
  --           _name = "pet_information_to_train",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
				
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }
		
		--state_machine.add(pet_information_to_train_terminal)
		state_machine.init()
	end
	init_formation_hero_train_terminal()
end

function PetDescribeformation:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local Text_miaoshu = ccui.Helper:seekWidgetByName(root, "Text_miaoshu")
	local miaoshu_string = dms.string(dms["ship_mould"],self.hero.ship_template_id,ship_mould.introduce)
	Text_miaoshu:setString(miaoshu_string)
end

function PetDescribeformation:onEnterTransitionFinish()

    --获取 宠物碎片选项卡 美术资源
    local csbGeneralsInformation_4 = csb.createNode("packs/PetStorage/PetStorage_information_list_5.csb")
	local root = csbGeneralsInformation_4:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_4)

    local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	self:onUpdateDraw()
end

function PetDescribeformation:onExit()

end

function PetDescribeformation:init(hero,userfashion,listPositionX)
	self.hero = hero
end

function PetDescribeformation:createCell()
	local cell = PetDescribeformation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end