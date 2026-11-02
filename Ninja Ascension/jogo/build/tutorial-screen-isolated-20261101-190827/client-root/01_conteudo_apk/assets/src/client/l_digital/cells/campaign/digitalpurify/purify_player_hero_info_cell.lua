-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化的武将选择项
-------------------------------------------------------------------------------------------------------
PurifyPlayerHeroInfoCell = class("PurifyPlayerHeroInfoCellClass", Window)
PurifyPlayerHeroInfoCell.__size = nil

function PurifyPlayerHeroInfoCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0

    -- Initialize PurifyPlayerHeroInfoCell page state machine.
    local function init_purify_player_hero_info_cell_terminal()
		
        local purify_player_hero_info_cell_choice_hero_join_formation_terminal = {
            _name = "purify_player_hero_info_cell_choice_hero_join_formation",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                local function responseDigitalPurifyTeamPrivilegeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            return
                        end
                        state_machine.excute("purify_team_window_update_draw", 0, 0)
                        state_machine.excute("purify_hero_list_window_close", 0, 0)
                    end
                end
                protocol_command.ship_purify_team_manager.param_list = "6\r\n" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. _ED.digital_purify_info._team_info.team_key .. "\r\n"..cell.m_ship.ship_id
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamPrivilegeCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(purify_player_hero_info_cell_choice_hero_join_formation_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_purify_player_hero_info_cell_terminal()
end

function PurifyPlayerHeroInfoCell:createHeadHead(ship,objectType)
	app.load("client.cells.ship.ship_head_new_cell")
	local cell = ShipHeadNewCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function PurifyPlayerHeroInfoCell:initDraw()
	local root = self.roots[1]
	--画头像
	local heroIcon = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	heroIcon:removeAllChildren(true)
	local picCell = nil
	picCell = PurifyPlayerHeroInfoCell:createHeadHead(self.m_ship, 2)
	heroIcon:addChild(picCell)
	--画名称
	local heroName = ccui.Helper:seekWidgetByName(root, "Text_dengji")
	local rankLevelFront = dms.int(dms["ship_mould"], self.m_ship.ship_template_id, ship_mould.initial_rank_level)
	local str = ""
	if rankLevelFront ~= 0 then
		str = " +"..rankLevelFront
	end
	--进化形象
	local evo_image = dms.string(dms["ship_mould"], self.m_ship.ship_template_id, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	--进化模板id
	local ship_evo = zstring.split(self.m_ship.evolution_status, "|")
	local evo_mould_id = evo_info[tonumber(ship_evo[1])]
	local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	local word_info = dms.element(dms["word_mould"], name_mould_id)
	_name = word_info[3]
	heroName:setString(_name .. str)
	local quality = 1
    quality = shipOrEquipSetColour(tonumber(self.m_ship.Order))
    local color_R = tipStringInfo_quality_color_Type[quality][1]
    local color_G = tipStringInfo_quality_color_Type[quality][2]
    local color_B = tipStringInfo_quality_color_Type[quality][3]
    heroName:setColor(cc.c3b(color_R, color_G, color_B))

    --战力
	local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
	Text_fighting_n:setString(self.m_ship.hero_fight)

	local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
	Panel_strengthen_stye:removeBackGroundImage()
	local camp_preference = dms.int(dms["ship_mould"], self.m_ship.ship_template_id, ship_mould.camp_preference)
	if camp_preference> 0 and camp_preference <=3 then
		Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
	end

	local isGoBattle = false
	local myformation = nil
	for i,v in pairs(_ED.digital_purify_info._team_info.members) do
		if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
			myformation = v
			break
		end
	end

	local formationdatas = zstring.split(myformation.formation_info, "@")
	local battleFormation = zstring.split(formationdatas[2], ":")
	if tonumber(battleFormation[7]) == tonumber(self.m_ship.ship_id) then
		isGoBattle = true
		ccui.Helper:seekWidgetByName(picCell.roots[1], "Image_3"):setVisible(true)
	else
		isGoBattle = false	
		ccui.Helper:seekWidgetByName(picCell.roots[1], "Image_3"):setVisible(false)
	end

	if isGoBattle == true then
		ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(true)
	end
			
end

function PurifyPlayerHeroInfoCell:onEnterTransitionFinish()
	
end

function PurifyPlayerHeroInfoCell:onInit()
	local root = cacher.createUIRef("campaign/DigitalPurify/digital_purify_change_window_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	local Button_shangzhen = ccui.Helper:seekWidgetByName(root, "Button_shangzhen")
 	-- 选择净化的武将
    fwin:addTouchEventListener(Button_shangzhen, nil, 
    {
        terminal_name = "purify_player_hero_info_cell_choice_hero_join_formation", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self,
    },
    nil,0)

 	if PurifyPlayerHeroInfoCell.__size == nil then
		local MySize = root:getContentSize()
	 	PurifyPlayerHeroInfoCell.__size = MySize
	end
	self:initDraw()
end


function PurifyPlayerHeroInfoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PurifyPlayerHeroInfoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("campaign/DigitalPurify/digital_purify_change_window_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function PurifyPlayerHeroInfoCell:init(index, ship)
	self.m_index = index
	self.m_ship = ship
	if index < 6 then
		self:onInit()
	end
	self:setContentSize(PurifyPlayerHeroInfoCell.__size)
	return self
end

function PurifyPlayerHeroInfoCell:createCell()
	local cell = PurifyPlayerHeroInfoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function PurifyPlayerHeroInfoCell:clearUIInfo( ... )
	local root = self.roots[1]
	local heroIcon = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	if heroIcon ~= nil then
		heroIcon:removeAllChildren(true)
	end
end

function PurifyPlayerHeroInfoCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("campaign/DigitalPurify/digital_purify_change_window_list.csb", self.roots[1])
end
