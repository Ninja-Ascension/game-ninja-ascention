---------------------------------
---说明：武将信息界面技能子界面
-- 创建时间:2015.03.17
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
---------------------------------
-- formation_hero_luck_talent_explain_cell.lua

ShipHeroSkillGetCell = class("HeroSkillGetCellClass", Window)
   
function ShipHeroSkillGetCell:ctor()
    self.super:ctor()
	self.hero = nil
	app.load("client.packs.hero.HeroPatchInformationPageGetWay")
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	local function init_ship_hero_skill_get_cell_terminal()
		local ship_hero_skill_get_cell_terminal = {
            _name = "ship_hero_skill_get_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(params._datas._shipId)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(ship_hero_skill_get_cell_terminal)
		state_machine.init()
	end
	init_ship_hero_skill_get_cell_terminal()
end


function ShipHeroSkillGetCell:onEnterTransitionFinish()
    --获取 武将碎片选项卡 美术资源
    local generals_information_4 = csb.createNode("packs/HeroStorage/generals_information_4.csb")
	local root = generals_information_4:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(generals_information_4)
	
	local text = ccui.Helper:seekWidgetByName(root, "Text_zuhe")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_jineng")
	fwin:addTouchEventListener(text, nil, 
	{
		-- func_string = [[state_machine.excute("ship_hero_skill_get_cell", 0, "ship_hero_skill_get_cell.'")]]
		terminal_name = "ship_hero_skill_get_cell",
		_shipId = self.hero,
		terminal_state = 0, 
	}, 
	nil, 0)
	local width = text:getContentSize().width
	local height = panel:getContentSize().height
	self:setContentSize(cc.size(width,height))
	
end

function ShipHeroSkillGetCell:onExit()
	state_machine.remove("ship_hero_skill_get_cell")
end

function ShipHeroSkillGetCell:init(hero)
	self.hero = hero
end

function ShipHeroSkillGetCell:createCell()
	local cell = ShipHeroSkillGetCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end