----------------------------------------------------------------------------------------------------
-- 说明：武将的站立
-- 用于排位赛
-------------------------------------------------------------------------------------------------------
ShipBodyCellNew = class("ShipBodyCellNewClass", Window)

function ShipBodyCellNew:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self._picIndex = nil 
	self.isShowBottomImage = false
	self._equip = nil
	self.roleShipId = 0
	
	local function init_ship_body_cell_new_terminal()
		-- 设计在时装界面，点击武将全身图像需要处理的逻辑
		local ship_body_cell_new_show_fashion_information_terminal = {
            _name = "ship_body_cell_new_show_fashion_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.packs.fashion.FashionInformation")
            	state_machine.excute("fashion_information_open", 0, params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(ship_body_cell_new_show_fashion_information_terminal)
        state_machine.init()
	end
	init_ship_body_cell_new_terminal()
end

function ShipBodyCellNew:onUpdateDraw()
	local root = self.roots[1]
	local shipImage = ccui.Helper:seekWidgetByName(root, "Panel_14")
	self:setContentSize(shipImage:getContentSize())
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		shipImage:removeAllChildren(true)
		if self.roleShipId ~= 0 and self.roleShipId ~= nil then
			app.load("client.battle.fight.FightEnum")
			sp.spine_sprite(shipImage, self.roleShipId, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		end
	else
		shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self._picIndex))	
	end
	local bottomImage = ccui.Helper:seekWidgetByName(root, "Panel_role_xy")
	bottomImage:setVisible(self.isShowBottomImage == true)
end

function ShipBodyCellNew:onEnterTransitionFinish()
	local root = self.roots[1]
	if self._equip ~= nil then
		-- ccui.Helper:seekWidgetByName(root, "Panel_role_xy"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_14"), nil, 
		{
		    terminal_name = "ship_body_cell_new_show_fashion_information", 
		    terminal_state = 0,
		    _cell = self,
		    _equip = self._equip,
		    isPressedActionEnabled = false
		}, 
		nil, 0)
	else
		ccui.Helper:seekWidgetByName(root, "Panel_14"):setTouchEnabled(false)
	end

end

function ShipBodyCellNew:onInit()
	local csbItem = nil
	
	csbItem = csb.createNode("card/card_hero_1.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("card/card_hero_1.csb")
	root:runAction(action)
	
	action:play("role_dh", true)
	
	self:onUpdateDraw()
end

function ShipBodyCellNew:onExit()

end

--self.ship,1,nil,self.moveLayer._current_cell._index,self.moveLayer._current_cell._ship,self._lastStatus)
function ShipBodyCellNew:init(picIndex, isShowBottom, equip, roleShipId)
	self._picIndex = picIndex 
	self.isShowBottomImage = isShowBottom 
	if equip ~= nil then
		self._equip = equip
	end
	if roleShipId ~= nil then
		self.roleShipId = roleShipId
	end
	self:onInit()
end

function ShipBodyCellNew:createCell()
	local cell = ShipBodyCellNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

