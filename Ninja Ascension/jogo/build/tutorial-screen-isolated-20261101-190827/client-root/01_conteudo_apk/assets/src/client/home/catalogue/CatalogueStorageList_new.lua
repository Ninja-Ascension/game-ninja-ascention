-- ----------------------------------------------------------------------------------------------------
-- 说明：图鉴cell
-- 创建时间
-- 作者：李潮
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CatalogueStorageListNew = class("CatalogueStorageListNewClass", Window)
CatalogueStorageListNew.__start_position = nil
CatalogueStorageListNew.__start_size = nil
	
function CatalogueStorageListNew:ctor()
    self.super:ctor()
    self.roots = {}
	self.ship = nil
	self.num = 0
	self.typenumber = 0   -- 分阵营
	self.allHero = {}
	self.hero_panel = {}
	self.Allroot = {}
	app.load("client.home.catalogue.CatalogueStorageIconCell")
    -- Initialize CatalogueStorage page state machine.
    local function init_catalogue_storage_new_terminal()
        local catalogue_show_info_click_head_terminal = {
            _name = "catalogue_show_info_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.Home)
			
				app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				cell:init(params._datas._id, nil , nil, 2)
				fwin:open(cell, fwin._windows)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(catalogue_show_info_click_head_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_catalogue_storage_new_terminal()
end

function CatalogueStorageListNew:onUpdateDrawPic()
	local root = self.roots[1]
	-- [[绘制滚动层
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "Panel_403")
	local image = ccui.Helper:seekWidgetByName(root, "Image_1")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	local Text_156 = ccui.Helper:seekWidgetByName(root, "Text_156")
	local Text_204 = ccui.Helper:seekWidgetByName(root, "Text_204")
	local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	m_ScrollView:removeAllChildren(true)
	local panel = ccui.Layout:create()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	panel:setName("cellPanel")
	m_ScrollView:addChild(panel)
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getContentSize()
	local cellWidth = sSize.width / 4

	local height = table.getn(self.ship) - 1--math.floor((table.getn(self.ship)-1) / 5 + 1)-1			--高度 
	Panel_2:setContentSize(cc.size(Panel_2:getContentSize().width, Panel_2:getContentSize().height+height*125))
	self:setContentSize(Panel_2:getContentSize())
	image:setContentSize(cc.size(image:getContentSize().width, image:getContentSize().height+height*125))
	Image_2:setPosition(cc.p(Image_2:getPositionX(),Image_2:getPositionY()+height*125))
	Text_156:setPosition(cc.p(Text_156:getPositionX(),Text_156:getPositionY()+height*125))
	Text_204:setPosition(cc.p(Text_204:getPositionX(),Text_204:getPositionY()+height*125))
	Text_3:setPosition(cc.p(Text_3:getPositionX(),Text_3:getPositionY()+height*125))
	m_ScrollView:setPosition(cc.p(m_ScrollView:getPositionX(),m_ScrollView:getPositionY()+height*125))


	local function addRewardScrollView(_index,id)
		local tempCell = nil
			--数码宝贝进化形象
		-- debug.print_r(self.allHero)
		local ship_basic = dms.int(dms["ship_mould"],id, ship_mould.base_mould)
		local current_ship = ship_basic
		for i=1,4 do
			local next_ship_id = dms.int(dms["ship_mould"], current_ship, ship_mould.way_of_gain)
			if current_ship ~= -1 and current_ship ~= nil then 
				--tempCell = self:onHeadDraw(current_ship)
				tempCell = CatalogueStorageIconCell:createCell()
				tempCell:init(current_ship,self.allHero)

				local cellHeight = tempCell:getContentSize().height+20
				local row = _index
				local col = i - 1
				local controlHeight = row * cellHeight
				if controlHeight < sSize.height then
					controlSize.height = sSize.height
				else
					controlSize.height = controlHeight
				end
				
				m_ScrollView:setContentSize(cc.size(controlSize.width, controlSize.height))
				
				local pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
					sSize.height - cellHeight * row)
				tempCell:setPosition(pos)
				panel:addChild(tempCell)
			end
			current_ship = next_ship_id
		end
	end

	local data = zstring.split(_ED.catalogue_hero_is_have, ",")
	self.allHero = {}
	local base_ship = {}
	 
	for i,v in pairs(data) do
		self.allHero[zstring.tonumber(v)] = true
 		local shipElement = dms.element(dms["ship_mould"], zstring.tonumber(v))
		local camp = zstring.tonumber(dms.atoi(shipElement, ship_mould.camp_preference))
		local ship_basic_id = zstring.tonumber(dms.atoi(shipElement, ship_mould.base_mould))
		local typenum1 = dms.int(dms["ship_mould"], ship_basic_id , ship_mould.ship_type)
		local typenum2 = dms.int(dms["ship_mould"], self.ship[1] , ship_mould.ship_type)
		local sameship = false
		if ship_basic_id ~= nil and  typenum2 == typenum1 and camp == self.typenumber then
			for a,b in pairs(base_ship) do
				if b == ship_basic_id then
					sameship = true
					break
				end
			end
			if sameship == true then
				sameship = false
			else
				base_ship[self.num] = ship_basic_id
				self.num = self.num + 1
			end
		end
	end

	local index = 0
	local function repetBack( ... )
		index = index + 1
		if index > table.getn(self.ship) then
			self:stopAllActions()
			return
		end
		addRewardScrollView(index, self.ship[index])
	end
	repetBack()
	self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(repetBack))))

	-- for i = 1 , table.getn(self.ship) do
	-- 	addRewardScrollView(i,self.ship[i])
	-- end

	local types = dms.int(dms["ship_mould"], self.ship[1], ship_mould.ship_type)
	local quality = types + 1
	Text_156:setString(_ship_types_by_color[quality])
	Text_156:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	Text_3:setString(self.num .. "/" ..table.getn(self.ship))
end

function CatalogueStorageListNew:onInit()
	
	local csbCatalogueStorage = csb.createNode("system/Atlas_list.csb")
	self:addChild(csbCatalogueStorage)
	local root = csbCatalogueStorage:getChildByName("root")
	table.insert(self.roots, root)
	self:onUpdateDrawPic()
end

function CatalogueStorageListNew:onEnterTransitionFinish()
	
end

function CatalogueStorageListNew:onExit()
	local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_403")
	panel:removeAllChildren(true)
end

function CatalogueStorageListNew:init(ship, typenumber)
	if typenumber ~= nil then
		self.typenumber = typenumber
	end
	self.ship = ship
	self.drawIndex = drawIndex
	--if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	--end
	
	return self
end

function CatalogueStorageListNew:createCell()
	local cell = CatalogueStorageListNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end