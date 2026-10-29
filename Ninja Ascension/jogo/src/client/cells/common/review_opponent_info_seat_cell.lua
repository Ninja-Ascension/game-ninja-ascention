-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场 -> 排行榜 -> 查看阵容 -> pageview seat
-- 创建时间：2015-03-30
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ReviewOpponentInfoSeatCell = class("ReviewOpponentInfoSeatCellClass", Window)
    
function ReviewOpponentInfoSeatCell:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.cells.campaign.icon.arena_role_icon_cell")
	
	self.roleInstance = nil
	
	
    -- Initialize ReviewOpponentInfoSeatCell page state machine.
    local function init_arena_ladder_seat_terminal()
	
		-- local arena_back_activity_terminal = {
            -- _name = "arena_back_activity",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
                
				-- fwin:open(Campaign:new(), fwin._view)
				-- fwin:close(instance)

                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(arena_back_activity_terminal)
        -- state_machine.add(arena_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ladder_seat_terminal()
end

function ReviewOpponentInfoSeatCell:initDraw()

	local root = self.roots[1]
	local role = self.roleInstance
	
	local roleIndex = 0
	local picIndex = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		picIndex= dms.int(dms["ship_mould"], role.ship_template_id, ship_mould.bust_index)
	else
		picIndex= dms.int(dms["ship_mould"], role.ship_template_id, ship_mould.All_icon)
	end

	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if dms.int(dms["ship_mould"], role.ship_template_id, ship_mould.captain_type) == 0 then
			if role.ship_picture ~= nil then
				picIndex = zstring.tonumber(role.ship_picture)
				picIndex =picIndex - 1000
			end
		end
	end

	local capacity = dms.int(dms["ship_mould"], role.ship_template_id, ship_mould.capacity)
	local country = dms.int(dms["ship_mould"], role.ship_template_id, ship_mould.camp_preference)
	--觉醒的星级属性没有,所以默认空星不处理
	
	--设置角色身体
	local roleBody = ccui.Helper:seekWidgetByName(root, "Panel_role")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--print("picIndex",picIndex)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), roleBody, nil, nil, cc.p(0.5, 0))
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			if tonumber(self.roleInstance.captain_type) == 0 then
				local shipSpine = sp.spine_sprite(roleBody, _user_pic_index[""..picIndex], spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        shipSpine:setScaleX(-1)
			    end
			else
				sp.spine_sprite(roleBody, picIndex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			end
		else
			draw.createEffect("spirte_" .. picIndex, "sprite/spirte_" .. picIndex .. ".ExportJson", roleBody, -1, nil, nil, cc.p(0.5, 0))	
		end
	else
		roleBody:setBackGroundImage("images/face/big_head/big_head_" .. picIndex .. ".png")
	end
	--国家 向性, 0无,1魏,2蜀,3吴,4群
	local countryPanel = ccui.Helper:seekWidgetByName(root, "Panel_r_5")
	if country > 0 then
		countryPanel:setBackGroundImage("images/ui/quality/leixing_" .. country .. ".png")
	end
	--战斗类型 战船标识(0:无；1:物攻型；2:法攻型 3:防御型；4:辅助型)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else	
		local ftypePanel = ccui.Helper:seekWidgetByName(root, "Panel_r_4")
		ftypePanel:setBackGroundImage("images/ui/quality/pve_leixing_" .. capacity .. ".png")
	end

	--设置名称
	local finalName = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], role.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(role.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		finalName = word_info[3]
	else
		finalName = dms.string(dms["ship_mould"], role.ship_template_id, ship_mould.captain_name)
	end

	local nameText = ccui.Helper:seekWidgetByName(root, "Text_r_1")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		if tonumber(role.captain_type) == 0 then
			finalName = _ED.player_name
		else
			finalName = role.captain_name
		end
	end
	
	--显示进化等级
	local superLv = dms.int(dms["ship_mould"], role.ship_template_id, ship_mould.initial_rank_level)
	if superLv > 0 then
		finalName = finalName .. " " .. _string_piece_info[153] .. superLv
	end
	nameText:setString(finalName)
	
	local quality = dms.int(dms["ship_mould"], role.ship_template_id, ship_mould.ship_type) + 1
	nameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	
	--觉醒
	if role.awakenLevel ~= nil then
		local awakenLevel = 0-- 觉醒等级
		local start = 0
		local maxStar = 6
		local captain_type = dms.int(dms["ship_mould"],role.ship_template_id,ship_mould.captain_type)
		if captain_type == 3 then 
			--宠物
			start =  dms.int(dms["ship_mould"],role.ship_template_id,ship_mould.initial_rank_level)
			maxStar = 5
		else
			awakenLevel = zstring.tonumber(role.awakenLevel) -- 觉醒等级
			start = math.floor(awakenLevel/10)
		end
		for i=1,6 do
			local startImage = ccui.Helper:seekWidgetByName(root, "Image_o_".. i)
			local startOffImage = ccui.Helper:seekWidgetByName(root, "Image_x_".. i)
			if startImage ~= nil and startOffImage ~= nil then
				startImage:setVisible(false)
				startOffImage:setVisible(false)
				if i <= maxStar then 
					startOffImage:setVisible(true)
				end
				if i<= start then 
					startImage:setVisible(true)
				end
			end		
		end
	end
end

function ReviewOpponentInfoSeatCell:onEnterTransitionFinish()
	
    local csbArenaRankingSeat = csb.createNode("campaign/ArenaStorage/ArenaStorage_view_line_r.csb")
	local root = csbArenaRankingSeat:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaRankingSeat)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_view_r")
	self:setContentSize(panel:getContentSize())
	
	self:initDraw()
end

function ReviewOpponentInfoSeatCell:init(role)-- 排名 战力值
	if role == -1 then self:setVisible(false) end
	self.roleInstance = role
end

function ReviewOpponentInfoSeatCell:createCell()
	local cell = ReviewOpponentInfoSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function ReviewOpponentInfoSeatCell:onExit()
	-- state_machine.remove("arena_back_activity")
end
