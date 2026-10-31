---------------------------------
---说明：
---------------------------------
ShipBodyForHomeCell = class("ShipBodyForHomeCellClass", Window)

function ShipBodyForHomeCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.heroInstance = nil
	
	-- 初始化主面上面武将的状态机
	local function init_ship_body_for_home_cell_terminal()
		-- 点击主面武将的响应事件处理
		local ship_body_for_home_cell_into_formation_page_terminal = {
            _name = "ship_body_for_home_cell_into_formation_page",
            _init = function (terminal) 
                app.load("client.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    -- --     		fwin:cleanView(fwin._background)
    -- --     		fwin:cleanView(fwin._view)
    -- --     		fwin:cleanView(fwin._viewdialog)
    -- --             fwin:cleanView(fwin._ui)

				-- -- local formation = Formation:new()
				-- -- for i = 2, 7 do
				-- -- 	local shipId = _ED.formetion[i]
				-- -- 	if tonumber(shipId) == params._datas._heroInstance.ship_id then
				-- -- 		formation:init(_ED.user_ship[_ED.formetion[i]])
				-- -- 	end
				-- -- end

				-- -- fwin:open(formation, fwin._view) 
				state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_formation", 	
						current_button_name = "Button_line-uo", 	
						but_image = "Image_line-uo", 
						_shipInstance = params._datas._heroInstance,	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

		local ship_body_for_home_cell_armature_play_terminal = {
            _name = "ship_body_for_home_cell_armature_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	params:armaturePlay()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(ship_body_for_home_cell_into_formation_page_terminal)	
		state_machine.add(ship_body_for_home_cell_armature_play_terminal)
        state_machine.init()
	end
	init_ship_body_for_home_cell_terminal()
end

function ShipBodyForHomeCell:armaturePlay()
	local root = self.roots[1]
	local Panel_hero_icon = ccui.Helper:seekWidgetByName(root, "Panel_1033_6")
	self._armature._nextAction = 1
end

function ShipBodyForHomeCell:onUpdateDraw(Path)
	local root = self.roots[1]
	if self.heroInstance ~= nil then
		local Panel_hero_icon = ccui.Helper:seekWidgetByName(root, "Panel_1033_6")
		local Panel_1033_7 = ccui.Helper:seekWidgetByName(root, "Panel_1033_7")
		local picIndex = dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.All_icon)
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			if dms.int(dms["ship_mould"], tonumber(self.heroInstance.ship_template_id), ship_mould.captain_type) == 0 then
				local fashionEquip, pic = getUserFashion()
				if fashionEquip ~= nil and pic ~= nil then
					picIndex = pic
				end
			end
		end
		local headPath = string.format("images/face/big_head/big_head_%d.png", picIndex)
		if Path ~= nil then
			headPath = Path
		end
		-- Panel_hero_icon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
		--Panel_hero_icon:setSwallowTouches(true)
		Panel_1033_7:setSwallowTouches(false)

		local function headLayerTouchEvent(sender, evenType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if ccui.TouchEventType.began == evenType then
				state_machine.excute("home_hero_update_draw_hero_move", 0, 125)
			elseif evenType == ccui.TouchEventType.moved then
			elseif ccui.TouchEventType.ended == evenType or
				ccui.TouchEventType.canceled == evenType then
			end
		end
		Panel_1033_7:addTouchEventListener(headLayerTouchEvent)

		local function changeActionCallback(armatureBack)
			local armature = armatureBack
			if armature ~= nil then
				local actionIndex = armature._actionIndex
				if actionIndex == 0 then
				elseif actionIndex == 1 then
					armature._nextAction = 0
				end
			end
		end
		self._armature = Panel_hero_icon:getChildByName("ArmatureNode_home_show")
		draw.initArmature(self._armature, nil, -1, 0, 1)
	    self._armature._show = false
	    self._armature._invoke = nil
	    self._armature._actionIndex = 0
	    self._armature:getAnimation():playWithIndex(0, 0, 1)
	    -- self.cacheFightArmature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	    self._armature._invoke = changeActionCallback
	    self._armature._nextAction = 1

	 --    self._armature = Panel_hero_icon:getChildByName("ArmatureNode_home_show")
		-- draw.initArmature(self._armature, nil, 1, 0, 1)
		-- self._armature._invoke = ShipBodyForHomeCell.changeActionCallback
		-- self._armature._needLoad = false
		-- self._armature._actionIndex = 1
		-- self._armature._nextAction = 0
		-- self._armature:getAnimation():playWithIndex(1)
		-- self._armature._invoke = ShipBodyForHomeCell.changeActionCallback
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		
		else
			local roleIcon = ccs.Skin:create(headPath)
			self._armature:getBone("Layer1"):addDisplay(roleIcon, 0)
			local roleIcon2 = ccs.Skin:create(headPath)
			self._armature:getBone("Layer13"):addDisplay(roleIcon2, 0)
		end
	end
end

function ShipBodyForHomeCell:onEnterTransitionFinish()
	local csbShipBodyForHome = csb.createNode("home/home_fanye.csb")
	local action = csb.createTimeline("home/home_fanye.csb")
	-- action:play("zhuye_huxi_1", true)
	action:gotoFrameAndPlay(0, action:getDuration(), true)
    local root = csbShipBodyForHome:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	root:runAction(action)
	table.insert(self.roots, root)
	
	self:onUpdateDraw()

	local touch_pad = ccui.Helper:seekWidgetByName(root, "Panel_1033_6")
	touch_pad:setSwallowTouches(false)
	fwin:addTouchEventListener(touch_pad, nil, 
	{
		terminal_name = "ship_body_for_home_cell_into_formation_page",
		cell = self,
		_heroInstance = self.heroInstance,
	}, 
	nil, 0)
end


function ShipBodyForHomeCell:onExit()

end

function ShipBodyForHomeCell:init(heroInstance)
	self.heroInstance = heroInstance
end

function ShipBodyForHomeCell:createCell()
	local cell = ShipBodyForHomeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end