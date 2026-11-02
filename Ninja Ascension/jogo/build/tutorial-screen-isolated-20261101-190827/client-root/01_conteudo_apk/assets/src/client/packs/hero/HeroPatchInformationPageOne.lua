-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageOne = class("HeroPatchInformationPageOneClass", Window)

function HeroPatchInformationPageOne:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = nil
	self.types = nil
	app.load("client.packs.equipment.EquipFragmentAcquire")
	app.load("client.cells.prop.prop_icon_new_cell")
    local function init_hero_patch_information_page_one_terminal()
		
		--选择被培养的武将
		-- local hero_patch_information_close_terminal = {
            -- _name = "hero_patch_information_close",
            -- _init = function (terminal)
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- fwin:close(instance)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(hero_patch_information_close_terminal)
        state_machine.init()
    end
    init_hero_patch_information_page_one_terminal()
end

function HeroPatchInformationPageOne:onUpdateDraw()
	local root = self.roots[1]
	local Panel_icons = ccui.Helper:seekWidgetByName(root, "Panel_icons")	--头像图片
	local Text_leixin = ccui.Helper:seekWidgetByName(root, "Text_leixin")	--武将类型(物攻型)
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")		--武将名字
	local Text_6 = ccui.Helper:seekWidgetByName(root, "Text_6")				--武将碎片描述
	local Text_shuliang_0 = ccui.Helper:seekWidgetByName(root, "Text_shuliang_0")--武将碎片数量
	local num = 0              --数量
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(self.shipId) then
		    num = v.prop_number
		end
	end
	
	Text_shuliang_0:setString(num.."/"..dms.int(dms["prop_mould"], self.shipId, prop_mould.split_or_merge_count))
	
	local hero_head = PropIconNewCell:createCell()
	hero_head:init(hero_head.enum_type._SHOW_EQUIP_INFO, self.shipId)
	Panel_icons:removeAllChildren(true)
	Panel_icons:addChild(hero_head)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        Text_name:setString(setThePropsIcon(self.shipId)[2])
        Text_6:setString(drawPropsDescription(self.shipId))
	else
		Text_name:setString(dms.string(dms["prop_mould"], self.shipId, prop_mould.prop_name))
		Text_6:setString(dms.string(dms["prop_mould"], self.shipId, prop_mould.remarks))
	end

	local colortype = dms.int(dms["prop_mould"], self.shipId, prop_mould.prop_quality)
	Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	
	
	local dataId = dms.int(dms["prop_mould"], self.shipId, prop_mould.use_of_ship)
	local heroType = dms.int(dms["ship_mould"], dataId, ship_mould.capacity)
	if heroType == 0 then
		
	elseif heroType == 1 then
		Text_leixin:setString(_string_piece_info[58])
	elseif heroType == 2 then
		Text_leixin:setString(_string_piece_info[59])
	elseif heroType == 3 then
		Text_leixin:setString(_string_piece_info[60])
	elseif heroType == 4 then
		Text_leixin:setString(_string_piece_info[61])
	end
	
	local getWay = dms.string(dms["prop_mould"], self.shipId, prop_mould.trace_address)
	if getWay ~= nil and zstring.tonumber(getWay) ~= -1 then
		local temp = zstring.split(getWay, ",")
		for i, v in pairs(temp) do
			if tonumber(v) > 0 then 
				local cell = EquipFragmentAcquire:createCell()
				cell:init(v)
				ccui.Helper:seekWidgetByName(root, "ListView_1"):addChild(cell)
			end
		end
	else
		ccui.Helper:seekWidgetByName(root, "Text_huode_xx"):setString(_string_piece_info[365])
	end
	
end

function HeroPatchInformationPageOne:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		return
	end
	local csbHeroPatchInformationPageOne= csb.createNode("packs/Fragmentation_info.csb")
	
    self:addChild(csbHeroPatchInformationPageOne)
	local root = csbHeroPatchInformationPageOne:getChildByName("root")
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function HeroPatchInformationPageOne:onLoad( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local csbHeroPatchInformationPageOne= csb.createNode("packs/Fragmentation_info.csb")
	
	    self:addChild(csbHeroPatchInformationPageOne)
		local root = csbHeroPatchInformationPageOne:getChildByName("root")
		table.insert(self.roots, root)
		self:onUpdateDraw()
	end
end

function HeroPatchInformationPageOne:onExit()
	-- state_machine.remove("hero_patch_information_close")
end

function HeroPatchInformationPageOne:init(shipId)
	self.shipId = shipId	--模板id
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self:setContentSize(HeroPatchInformation.__size)
	end
end

function HeroPatchInformationPageOne:createCell()
	local cell = HeroPatchInformationPageOne:new()
	cell:registerOnNodeEvent(cell)
	return cell
end