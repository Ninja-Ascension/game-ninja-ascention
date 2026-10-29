----------------------------------------------------------------------------------------------------
-- 说明：图鉴图标绘制
----------------------------------------------------------------------------------------------------
CatalogueStorageIconCell = class("CatalogueStorageIconCellClass", Window)
CatalogueStorageIconCell.__size = nil

function CatalogueStorageIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.heroId = nil
	self.allHeros = nil

	-- Initialize adventure hero icon cell state machine.
	local function init_catalogue_storage_icon_cell_terminal()
        -- 显示武将信息
        local catalogue_show_info_icon_cell_click_head_terminal = {
            _name = "catalogue_show_info_icon_cell_click_head",
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
	
		state_machine.add(catalogue_show_info_icon_cell_click_head_terminal)	
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_catalogue_storage_icon_cell_terminal()
end

function CatalogueStorageIconCell:onEnterTransitionFinish()

end

function CatalogueStorageIconCell:updateDraw()
	local roots = self.roots[1]
	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	Panel_kuang:removeBackGroundImage()
	Panel_head:removeBackGroundImage()
	-- Panel_head:removeAllChildren(true)
	local id = zstring.tonumber(self.heroId)
	local name = ccui.Helper:seekWidgetByName(roots, "Label_name")
	local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)
	local pic = dms.int(dms["ship_mould"], id, ship_mould.head_icon)
	local quality_path = nil
	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	cc.Director:getInstance():getTextureCache():addImage(big_icon_path)
	Panel_kuang:setColor(cc.c3b(255, 255, 255))
	Panel_head:setColor(cc.c3b(255, 255, 255))

	Panel_head:setBackGroundImage(big_icon_path)
	local next_ship_id = dms.int(dms["ship_mould"], id, ship_mould.way_of_gain)
	Panel_head:setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(roots, "Image_jiantou"):setVisible(false)	
	if next_ship_id ~= nil and next_ship_id ~= -1 then 
		ccui.Helper:seekWidgetByName(roots, "Image_jiantou"):setVisible(true)	
	end
	
	if self.allHeros[id] ~= nil and self.allHeros[id] == true then 
	else
		Panel_head:setColor(cc.c3b(150, 150, 150))
		Panel_kuang:setColor(cc.c3b(150, 150, 150))
	end
	quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
	Panel_kuang:setBackGroundImage(quality_path)
	
	name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], id, ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		_name = word_info[3]
		name:setString(_name)
	else
		name:setString(dms.string(dms["ship_mould"], id, ship_mould.captain_name))
	end
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "catalogue_show_info_click_head", 	
		_id = self.heroId,
		terminal_state = 0,
	}, 
	nil, 0)

end

function CatalogueStorageIconCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("icon/item_tujian.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
 	self.actions = {}
 	
	-- Get size for root node.
	if CatalogueStorageIconCell.__size == nil then
		local size = root:getContentSize()
		CatalogueStorageIconCell.__size = size
	end
	
	self:updateDraw()
end

function CatalogueStorageIconCell:onExit()
	cacher.freeRef("icon/item_tujian.csb", self.roots[1])
	self.roots = {}
end


function CatalogueStorageIconCell:init(heroId,heros)

	self.heroId = heroId
	self.allHeros = heros
	self:onInit()

	self:setContentSize(CatalogueStorageIconCell.__size)
	return self
end

function CatalogueStorageIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CatalogueStorageIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	root:stopAllActions()
	
	cacher.freeRef("icon/item_tujian.csb", root)
	root:removeFromParent(false)
	self.roots = {}

end

function CatalogueStorageIconCell:createCell()
	local cell = CatalogueStorageIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

