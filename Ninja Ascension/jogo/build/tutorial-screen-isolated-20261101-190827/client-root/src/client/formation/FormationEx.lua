-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的阵容界面
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
Formation = class("FormationClass", Window)
Formation.__userHeroFontName = nil
function Formation:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipArray={}
	self.ship = nil
	self.pageView = nil
    local function init_formation_terminal()
		--点击头像刷新阵容
		local click_formation_refresh_terminal = {
            _name = "click_formation_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			instance:init(params)
             --点击事件
			local function responseLoginInitCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
				end
			end
			instance:onUpdateShow()
			return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local open_formation_head_info_terminal = {
			_name = "open_formation_head_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
             --点击事件
			-- app.load("client.formation.HeroInformation")
			-- local heroInfo = HeroInformation:new()
			-- local kkk = nil
			-- for i,v in pairs(_ED.user_ship) do
				-- if i == 1 then
					-- kkk = v
				-- end
			-- end
			-- heroInfo:init(kkk)
			
			return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		state_machine.add(click_formation_refresh_terminal)	
		state_machine.add(open_formation_head_info_terminal)	
        state_machine.init()
    end 

    init_formation_terminal()
end

function Formation:init(ship)
	self.ship = ship
end

function Formation:createShipHead(ship,objectType)
	local cell = FormationCarHeadCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function Formation:createEquipHead(ship,objectType)
	local cell = FormationEquipmentCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function Formation:createHeadPageViewHead(ship)
	local cell = FormationHeadPageviewCellClass:createCell()
	cell:init(ship)
	return cell
end

function Formation:onUpdateShow()
	self:shipImageliseShow()
	self:equipshow()
	self:shipAttribute()
	self:shipRelationshow()
end

function Formation:onEnterTransitionFinish()	
	app.load("client.cells.formation_car_head_cell")
	app.load("client.cells.formation_equipment_cell")
	app.load("client.cells.formation_head_pageview_cell")
    local csbFormation = csb.createNode("formation/line_up.csb")
    self:addChild(csbFormation)
	
	local root = csbFormation:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("formation/line_up.csb")
    csbFormation:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	self.pageView = ccui.Helper:seekWidgetByName(root, "PageView_1")
	--kongjian_tonch
	self:onUpdateShow()
	self:shipWholeBody()
end

--画小头像
function Formation:shipImageliseShow()
	local root = self.roots[1]
	-- [[-------------------------主公-----------------------------------
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListView_1:setItemModel(FormationCarHeadCell:createCell())
	
	local Panel_8 = ccui.Helper:seekWidgetByName(root, "Panel_8")

	local ships = {}
	for i = 2, 7 do
		local shipId = _ED.formetion[i]
		if tonumber(shipId) > 0 then
			local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
			if tonumber(isleadtype) > 0 then
				table.insert(ships, _ED.user_ship[shipId])
				local cell = self:createShipHead(_ED.user_ship[shipId],3)
				cell:setPosition(cc.p(i * cell:getContentSize().width,0))
				ListView_1:addChild(cell)
			else
				local roleHeadCell = self:createShipHead(_ED.user_ship[_ED.formetion[i]],3)
				Panel_8:addChild(roleHeadCell)
			end
		end
	end
	
	for i = 1, table.getn(ships) do
        ListView_1:pushBackDefaultItem()
    end
	
	local items = ListView_1:getItems()
    local items_count = table.getn(items)
	for i = 1, items_count do
		local cell = items[i]
		-- cell:init(ships[i])
    end
	
	
	--]]-------------------------------------------------------------
end

--画武将装备
function Formation:equipshow()
	local root = self.roots[1]
	local shop_equip_position = {
		"Panel_17_1",
		"Panel_17_4",
		"Panel_17_2",
		"Panel_17_5",
		"Panel_17_3",
		"Panel_17_6",
	}
	--绘制武将装备位上的装备
	for i=1, 6 do
		local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
		equipPlaceInfo:removeChild(equipPlaceInfo._nodeChild, true)
		equipPlaceInfo._nodeChild = nil
	end
	
	for i, equip in pairs(self.ship.equipment) do
		local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
		if tonumber(equip.ship_id) > 0 then
			local cell = self:createEquipHead(equip,2)
			equipPlaceInfo:addChild(cell,10)
			equipPlaceInfo._nodeChild = cell
		end
	end
end

--画武将属性
function Formation:shipAttribute()
	local root = self.roots[1]
	local shipAttribute={
		"Text_3_5",--等级
		"Text_3_6",--攻击
		"Text_3_7",--生命
		"Text_3_8",--物防
		"Text_3_9",--法防
		"Text_41",--名称
	}
	if self.ship ~= nil then
		ccui.Helper:seekWidgetByName(root, shipAttribute[1]):setString(self.ship.ship_grade)
		ccui.Helper:seekWidgetByName(root, shipAttribute[2]):setString(self.ship.ship_courage)
		ccui.Helper:seekWidgetByName(root, shipAttribute[3]):setString(self.ship.ship_health)
		ccui.Helper:seekWidgetByName(root, shipAttribute[4]):setString(self.ship.ship_intellect)
		ccui.Helper:seekWidgetByName(root, shipAttribute[5]):setString(self.ship.ship_quick)
		local name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
		else
			name = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name)
		end
		if ___is_open_leadname == true then
			if Formation.__userHeroFontName == nil then
				Formation.__userHeroFontName = ccui.Helper:seekWidgetByName(root, shipAttribute[6]):getFontName()
			end
			if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
				ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setFontName("")
				ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setFontSize(ccui.Helper:seekWidgetByName(root, shipAttribute[6]):getFontSize())-->设置字体大小
			else
				ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setFontName(Formation.__userHeroFontName)
			end
		end

		ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setString(name)
		local quality = tonumber(self.ship.ship_type)+1
		ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	else
		ccui.Helper:seekWidgetByName(root, shipAttribute[1]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[2]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[3]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[4]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[5]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setString(" ")
	end
	local isleadtype = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type)
	if tonumber(isleadtype) > 0 then
		ccui.Helper:seekWidgetByName(root, "Button_5_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_5_1"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Button_5_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_5_1"):setVisible(false)
	end
	
end

--画武将羁绊
function Formation:shipRelationshow()
	local root = self.roots[1]
	local shipRelation={
		"Text_27",--缘分1
		"Text_27_2",--缘分2
		"Text_27_0",--缘分3
		"Text_27_3",--缘分4
		"Text_27_1",--缘分5
		"Text_27_4",--缘分6
	}
	for i=1, 6 do
		local relationship = self.ship.relationship[i]
		local relationshipLabel = ccui.Helper:seekWidgetByName(root, shipRelation[i])
		if relationship ~= nil then
			local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
			relationshipLabel:setString(relationName)
			if tonumber(relationship.is_activited) == 1 then
				relationshipLabel:setColor(cc.c3b(formation_relationship_color_Type[1][1],formation_relationship_color_Type[1][2],formation_relationship_color_Type[1][3]))
			else
				relationshipLabel:setColor(cc.c3b(formation_relationship_color_Type[5][1],formation_relationship_color_Type[5][2],formation_relationship_color_Type[5][3]))
			end
			
		else
			relationshipLabel:setString(" ")
		end
	end
end

--武将大形象
function Formation:shipWholeBody()
	local root = self.roots[1]
	local pageview = ccui.Helper:seekWidgetByName(root, "PageView_2")
	for i=1,6 do
		pageview:removePageAtIndex(0)
	end
	local ships = {}
	for i = 2, 7 do
		local shipId = _ED.formetion[i]
		if tonumber(shipId) > 0 then
			local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
			local cell = self:createHeadPageViewHead(_ED.user_ship[shipId])
			if tonumber(isleadtype) > 0 then
				--pageview:addPage(layout)
				pageview:insertPage(cell, i-2)
				table.insert(ships, _ED.user_ship[shipId])
			else
                pageview:insertPage(cell, 0)
				self.shipArray[1] = _ED.user_ship[shipId]
			end
		end
	end
	
	for i = 1, table.getn(ships) do
		table.insert(self.shipArray, ships[i])
    end
	
	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local pageview = sender
            local pageInfo = string.format("page %d " , pageview:getCurPageIndex())
			self:init(self.shipArray[pageview:getCurPageIndex()+1])
			self:onUpdateShow()
        end
    end 
    pageview:addEventListener(pageViewEvent)
end

function Formation:onExit()
	state_machine.remove("click_formation_refresh")
end