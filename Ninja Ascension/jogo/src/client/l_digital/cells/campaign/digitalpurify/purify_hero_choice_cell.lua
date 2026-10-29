-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化的武将选择项
-------------------------------------------------------------------------------------------------------
PurifyHeroChoiceCell = class("PurifyHeroChoiceCellClass", Window)
PurifyHeroChoiceCell.__size = nil

function PurifyHeroChoiceCell:ctor()
    self.super:ctor()
    self.roots = {}
    -- self.actions = {}

	self.m_index = 0
	self.m_data = 0
	self.m_Image_bg = nil

    -- Initialize PurifyHeroChoiceCell page state machine.
    local function init_purify_hero_choice_cell_terminal()
		
        local purify_hero_choice_cell_choice_target_terminal = {
            _name = "purify_hero_choice_cell_choice_target",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if nil ~= terminal._choice_cell then
                	local Image_hook = ccui.Helper:seekWidgetByName(terminal._choice_cell.roots[1],"Image_hook")
                	Image_hook:setVisible(false)
                	terminal._choice_cell = nil
                end
                if nil ~= cell then
	                terminal._choice_cell = cell
	                local Image_hook = ccui.Helper:seekWidgetByName(terminal._choice_cell.roots[1],"Image_hook")
	                Image_hook:setVisible(true)
	                state_machine.excute("purify_choice_window_choice_item", 0, {cell.m_data, cell.m_index})
	               end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(purify_hero_choice_cell_choice_target_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_purify_hero_choice_cell_terminal()
end

function PurifyHeroChoiceCell:initDraw()
	local root = self.roots[1]

	local shipMouldId = self.m_data[2]

	local ship = fundShipWidthTemplateId(shipMouldId)
	local shipInitGroup = 1
	if ship ~= nil then
		local ship_evo = zstring.split(ship.evolution_status, "|")
    	shipInitGroup = tonumber(ship_evo[1])
	else
		shipInitGroup = dms.int(dms["ship_mould"], tonumber(shipMouldId), ship_mould.captain_name)
	end

	local evo_image = dms.string(dms["ship_mould"], tonumber(shipMouldId), ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	local shipEvoMouldId = tonumber(evo_info[shipInitGroup])
	local picIndex = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.form_id)

	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
	Panel_digimon_icon:setBackGroundImage("images/ui/pve_sn/props_" .. picIndex .. ".png")

	local camp_preference = dms.string(dms["ship_mould"], tonumber(shipMouldId), ship_mould.camp_preference)
	local Image_bg = ccui.Helper:seekWidgetByName(root, "Image_bg_" .. camp_preference)
	Image_bg:setVisible(true)
	self.m_Image_bg = Image_bg


	local name_mould_id = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.name_index)
	local shipName = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    local Text_digimon_name = ccui.Helper:seekWidgetByName(root,"Text_digimon_name")
    Text_digimon_name:setString(shipName)

    local Image_hook = ccui.Helper:seekWidgetByName(root,"Image_hook")
    Image_hook:setVisible(false)
end

function PurifyHeroChoiceCell:onEnterTransitionFinish()
	
end

function PurifyHeroChoiceCell:onInit()
	local root = cacher.createUIRef("campaign/DigitalPurify/digital_purify_tab_1_cell.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
 	-- 选择净化的武将
    fwin:addTouchEventListener(Panel_digimon_icon, nil, 
    {
        terminal_name = "purify_hero_choice_cell_choice_target", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self,
    },
    nil,0)

 	if PurifyHeroChoiceCell.__size == nil then
		local MySize = Panel_digimon_icon:getContentSize()
	 	PurifyHeroChoiceCell.__size = MySize
	end
	self:initDraw()
end


function PurifyHeroChoiceCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PurifyHeroChoiceCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/DigitalPurify/digital_purify_tab_1_cell.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	if nil ~= self.m_Image_bg then
		self.m_Image_bg:setVisible(false)
		self.m_Image_bg = nil
	end
	self.roots = {}
end

function PurifyHeroChoiceCell:init(index, data)
	self.m_index = index
	self.m_data = data
	self:onInit()
	self:setContentSize(PurifyHeroChoiceCell.__size)
	return self
end

function PurifyHeroChoiceCell:createCell()
	local cell = PurifyHeroChoiceCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function PurifyHeroChoiceCell:onExit()
	if nil ~= self.m_Image_bg then
		self.m_Image_bg:setVisible(false)
		self.m_Image_bg = nil
	end
	cacher.freeRef("campaign/DigitalPurify/digital_purify_tab_1_cell.csb", self.roots[1])
end
