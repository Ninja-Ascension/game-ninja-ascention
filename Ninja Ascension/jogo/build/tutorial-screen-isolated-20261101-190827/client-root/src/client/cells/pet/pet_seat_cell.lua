---------------------------------
---说明：宠物信息选项卡
-- 作者：李潮
-- 修改记录：
-- 最后修改人：
---------------------------------
PetSeatCell = class("PetSeatCellClass", Window)
PetSeatCell.__size = nil
PetSeatCell.__userHeroFontName = nil
function PetSeatCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.heroInstance = nil
	self.num = nil
	app.load("client.cells.ship.ship_head_new_cell")
    local function init_HeroSeat_terminal()
	
		local pet_seat_update_terminal = {
            _name = "pet_seat_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if params ~= nil and params.roots ~= nil then 
            		params:onUpdateDraw()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 拉回弹框
		local pet_storage_show_listview_bounce_terminal = {
            _name = "pet_storage_show_listview_bounce",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("pet_expansion_action_start", 0, {_datas = {cell = params._datas}})
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--刷新上阵状态
		local pet_storage_show_listview_formation_terminal = {
            _name = "pet_storage_show_listview_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params ~= nil then 
					params:onUpdateFormation()
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_seat_update_terminal)
		state_machine.add(pet_storage_show_listview_bounce_terminal)
		state_machine.add(pet_storage_show_listview_formation_terminal)
        state_machine.init()
    end
    
    init_HeroSeat_terminal()
end

function PetSeatCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		--cell 在unload状态，没有root
		return
	end
	local hero_mould_id = self.heroInstance.ship_template_id
	local hero_data = dms.element(dms["ship_mould"], hero_mould_id)
	
	local hero_head = ShipHeadNewCell:createCell()
	hero_head:init(self.heroInstance,hero_head.enum_type._SHOW_SHIP_INFORMATION)
	
	local hero_name = self.heroInstance.captain_name
	local hero_grade = self.heroInstance.ship_grade
	local colortype = dms.atoi(hero_data, ship_mould.ship_type)

	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	
	Text_name:setString(hero_name)
	Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))

	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
	headPanel:removeAllChildren(true)
	headPanel:addChild(hero_head)
	
	local rankLevelFront = dms.atoi(hero_data, ship_mould.initial_rank_level)  --进阶前的进阶等级
	ccui.Helper:seekWidgetByName(root, "Text_2_0"):setString(hero_grade)

	--阶数
	ccui.Helper:seekWidgetByName(root, "Text_3_0"):setString("".. self.heroInstance.train_level .. _string_piece_info[46])
	--战斗力
	ccui.Helper:seekWidgetByName(root, "Text_22"):setString("".. self.heroInstance.hero_fight)
	
	if zstring.tonumber(self.heroInstance.pet_equip_ship_id) > 0 then 
		ccui.Helper:seekWidgetByName(root, "Image_38_1"):setVisible(true)
	end
	local awakenLevel = dms.atoi(hero_data, ship_mould.initial_rank_level)  --进阶前的进阶等级
	local maxStarLevel = dms.atoi(hero_data, ship_mould.rank_grow_up_limit)
	for i=1,5 do
		local startImage = ccui.Helper:seekWidgetByName(root, "Image_x_"..i)
		startImage:setVisible(false)
		if i <= awakenLevel then 
			startImage:setVisible(true)
		end
	end
	self:onUpdateFormation()
end

function PetSeatCell:onEnterTransitionFinish()

end

--更新阵容图标信息
function PetSeatCell:onUpdateFormation()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if zstring.tonumber(_ED.formation_pet_id) == zstring.tonumber(self.heroInstance.ship_id) then 
		ccui.Helper:seekWidgetByName(root, "Image_38"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Image_38"):setVisible(false)
	end
end

function PetSeatCell:onInit()
	local root = cacher.createUIRef("packs/PetStorage/list_PetStorage_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	local action = csb.createTimeline("packs/PetStorage/list_PetStorage_1.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)
 	if PetSeatCell.__size == nil then
 		PetSeatCell.__size = root:getChildByName("Panel_13"):getContentSize()
 	end
	
	local expansion_pad = ccui.Helper:seekWidgetByName(root, "Panel_xiala")
		expansion_pad:setSwallowTouches(false)
	if expansion_pad._pos == nil then
 		expansion_pad._pos = cc.p(expansion_pad:getPosition())
 	else
		expansion_pad:removeAllChildren(true)
 		expansion_pad:setPosition(expansion_pad._pos)
 	end

 	local expansion_pad_parent = expansion_pad:getParent()
 	if expansion_pad_parent._pos == nil then
 		expansion_pad_parent._pos = cc.p(expansion_pad_parent:getPosition())
 	else
 		expansion_pad_parent:setPosition(expansion_pad_parent._pos)
 	end
	
	ccui.Helper:seekWidgetByName(root, "Panel_props"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Button_xia"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Button_shou"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Image_38"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_38_1"):setVisible(false)
	
	
	--扩展界面展开                                                                                     
	local seat_expansion_on_button = ccui.Helper:seekWidgetByName(root, "Panel_btn_jh")
	
	fwin:addTouchEventListener(seat_expansion_on_button, nil, 
	{
		terminal_name = "pet_expansion_action_start", 
		
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	--seat_expansion_on_button:addTouchEventListener(headLayerTouchEvent)
	
	--扩展界面回收                                                                               
	local seat_expansion_off_button = ccui.Helper:seekWidgetByName(root, "Button_shou")
	fwin:addTouchEventListener(seat_expansion_off_button, nil, 
	{
		terminal_name = "pet_expansion_action_start", 
		next_terminal_name = "general", 
		but_image = "Image_home", 	
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	local expandButton = ccui.Helper:seekWidgetByName(root, "Button_xia")
	fwin:addTouchEventListener(expandButton, nil, 
	{
		terminal_name = "pet_expansion_action_start", 
		next_terminal_name = "general", 
		but_image = "Image_home", 	
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function PetSeatCell:close( ... )

	local headPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_props")
	headPanel:removeAllChildren(true)
	
end

function PetSeatCell:onExit()
	local root = self.roots[1]
	if root ~= nil then
		cacher.freeRef("packs/PetStorage/list_PetStorage_1.csb", self.roots[1])
	end
	self.roots = nil
end

function PetSeatCell:init(heroInstance, num, index)
	self.heroInstance = heroInstance
	self.num = num


	if index ~= nil and index < 8 then
		self:onInit()
	end

	self:setContentSize(PetSeatCell.__size)
	return self
end

function PetSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PetSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
	headPanel:removeAllChildren(true)

	cacher.freeRef("packs/PetStorage/list_PetStorage_1.csb", root)
	
	root:removeFromParent(false)
	self.roots = {}
	self.csbHeroSell = nil
end

function PetSeatCell:createCell()
	local cell = PetSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end