----------------------------------------------------------------------------------------------------
-- 说明：装备信息界面下滑列(描述)
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipInfoDescribeListCell = class("EquipInfoDescribeListCellClass", Window)

function EquipInfoDescribeListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
    local function equip_info_describe_list_cell_terminal()
		local equip_info_describe_list_terminal = {
            _name = "equip_info_describe_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_info_Refine_list_terminal)
        state_machine.init()
    end
    
    equip_info_describe_list_cell_terminal()
end

function EquipInfoDescribeListCell:onUpdateDraw()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "Text_5")
	local panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	
	local sizeX = panel_3:getContentSize().width
	local sizeY = panel_3:getContentSize().height
	local textX = text:getContentSize().width
	local textY = text:getPositionY()
	local tipHeight = 0
	local textInfo = dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.trace_remarks)
	
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
		lableCell:getFontSize(), cc.size(lableBaseSize.width-30, 0), 
		cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)	
	else
		lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
		lableCell:getFontSize(), cc.size(lableBaseSize.width+45, 0), 
		cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)	
	end
	lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
	panel_3:addChild(lableCell)
	lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
	local lableSize = lableCell:getContentSize()
	tipHeight = tipHeight + lableSize.height
	-- lableCell:setPosition(cc.p(lableCell:getPositionX()+20, -1 * tipHeight+sizeY-42))
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		lableCell:setPosition(cc.p(lableCell:getPositionX()+60, -1*tipHeight+textY))	
	else
		lableCell:setPosition(cc.p(lableCell:getPositionX()+30, -1*tipHeight+textY))	
	end
	
	panel_3:setContentSize(cc.size(sizeX,tipHeight + sizeY))

	
end

function EquipInfoDescribeListCell:onEnterTransitionFinish()
    local csbEquipInfoDescribeListCell = csb.createNode("packs/EquipStorage/equipment_information_list_4.csb")
	local root = csbEquipInfoDescribeListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()
	-- Text_5 描述
	
	
end


function EquipInfoDescribeListCell:onExit()
	state_machine.remove("equip_info_describe_list")
end

function EquipInfoDescribeListCell:init(equipmentInstance)
	self.equipmentInstance = equipmentInstance
end

function EquipInfoDescribeListCell:createCell()
	local cell = EquipInfoDescribeListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end