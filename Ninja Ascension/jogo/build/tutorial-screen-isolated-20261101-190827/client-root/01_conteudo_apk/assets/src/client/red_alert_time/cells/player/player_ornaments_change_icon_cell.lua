----------------------------------------------------------------------------------------------------
-- 说明：头像选择cell
-------------------------------------------------------------------------------------------------------
playerOrnamentsChangeIconCell = class("playerOrnamentsChangeIconCellClass", Window)
playerOrnamentsChangeIconCell.__size = nil

local player_ornaments_change_icon_cell_terminal = {
    _name = "player_ornaments_change_icon_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = playerOrnamentsChangeIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_ornaments_change_icon_cell_terminal)
state_machine.init()

function playerOrnamentsChangeIconCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil
	
 	local function init_player_skill_upgrade_cell_terminal()
        -- --点击
        local player_ornaments_change_icon_cell_update_terminal = {
            _name = "player_ornaments_change_icon_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params._datas.cells
                if cell == nil then
                    if terminal.old_object ~= nil then
                        ccui.Helper:seekWidgetByName(terminal.old_object.roots[1],"Panel_head_icon"):setBackGroundImage("images/ui/props/props_200.png")
                        state_machine.excute("player_stamp_settings_ornament_id_recording",0,0)
                    end
                    terminal.old_object = cell
                    return
                end
				if terminal.old_object == nil then
					local head_activation = zstring.split(_ED.user_head_activation, ",")
					if zstring.tonumber(head_activation[tonumber(cell._info[1])]) >= 0 then
						terminal.old_object = cell
						-- ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_head_icon"):setVisible(true)
						-- 图标
						local Panel_head_icon = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_head_icon")
						local head_data = zstring.split(_ED.user_info.user_head_id, ",")
						local head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
						local head_image = head_info[1]
						Panel_head_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, head_image))
	
						state_machine.excute("player_stamp_settings_ornament_id_recording",0,cell._info[1])
					else
						local mould_id = dms.int(dms["avatar_head"], cell._info[1], avatar_head.condition)
						TipDlg.drawTextDailog( dms.string(dms["achievement_mould"], mould_id, achievement_mould.achievement_dec))
					end
					return
				end
				
				if terminal.old_object ~= cell then
					local head_activation = zstring.split(_ED.user_head_activation, ",")
					if zstring.tonumber(head_activation[tonumber(cell._info[1])]) >= 0 then
						ccui.Helper:seekWidgetByName(terminal.old_object.roots[1],"Panel_head_icon"):setBackGroundImage("images/ui/props/props_200.png")
						-- ccui.Helper:seekWidgetByName(terminal.old_object.roots[1],"Panel_head_icon"):setVisible(false)
						-- ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_head_icon"):setVisible(true)
						
						-- 图标
						local Panel_head_icon = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_head_icon")
						local head_data = zstring.split(_ED.user_info.user_head_id, ",")
						local head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
						local head_image = head_info[1]
						Panel_head_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, head_image))
						
						terminal.old_object = cell
						state_machine.excute("player_stamp_settings_ornament_id_recording",0,cell._info[1])
					else
						local mould_id = dms.int(dms["avatar_head"], cell._info[1], avatar_head.condition)
						TipDlg.drawTextDailog( dms.string(dms["achievement_mould"], mould_id, achievement_mould.achievement_dec))
					end
				else
					return
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_ornaments_change_icon_cell_update_terminal)
        state_machine.init()
    end
	init_player_skill_upgrade_cell_terminal()        	
end


function playerOrnamentsChangeIconCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_head_icon = ccui.Helper:seekWidgetByName(root,"Panel_head_icon")
	Panel_head_icon:removeAllChildren(true)
	-- 1是头像，挂饰，称号
	local head_data = zstring.split(_ED.user_info.user_head_id, ",")
	
	-- local head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
	-- 图标
	-- local head_image = head_info[1]
	Panel_head_icon:setBackGroundImage("images/ui/props/props_200.png")
	-- Panel_head_icon:setVisible(false)
	
	--挂饰
	local Panel_head_ornaments_effect = ccui.Helper:seekWidgetByName(root,"Panel_head_ornaments_effect")
	Panel_head_ornaments_effect:removeAllChildren(true)
	local accessories_data = dms.int(dms["avatar_head"], self._info[1], avatar_head.animation)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/biaoqing/effect_deco_1/effect_deco_1.ExportJson")
	local armature = ccs.Armature:create("effect_deco_1")
	local roleIcon = ccs.Skin:create("images/ui/biaoqing/effect_deco_" .. accessories_data .. ".png")
	armature:getBone("Layer1"):addDisplay(roleIcon, 0)
	armature:getAnimation():playWithIndex(0)
	Panel_head_ornaments_effect:addChild(armature)
	-- Text_head_type:setString(avatar_use_text[self._sort])
	ccui.Helper:seekWidgetByName(root, "Image_head_ornaments_hook"):setVisible(false)

end

function playerOrnamentsChangeIconCell:onEnterTransitionFinish()

end

function playerOrnamentsChangeIconCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.player.player_head_ornaments_icon_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if playerOrnamentsChangeIconCell.__size == nil then
		playerOrnamentsChangeIconCell.__size = root:getContentSize()
	end
	-- local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")
	-- local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
	-- local Image_head_typetitle_bg = ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")
	-- local Text_head_type = ccui.Helper:seekWidgetByName(root,"Text_head_type")
	-- Image_head_type_list_box:setContentSize(cc.size(Image_head_type_list_box:getContentSize().width, Image_head_type_list_box:getContentSize().height))
	-- Image_head_type_list_box:setPositionY(Image_head_type_list_box:getPositionY())
	-- Image_head_typetitle_bg:setPositionY(Image_head_typetitle_bg:getPositionY())
	-- Text_head_type:setPositionY(Text_head_type:getPositionY())
	-- m_ScrollView:setContentSize(m_ScrollView:getContentSize())
	-- m_ScrollView:setPositionY(m_ScrollView:getPositionY())
	ccui.Helper:seekWidgetByName(root,"Panel_head_icon"):setSwallowTouches(false)
    -- -- 点击
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_head_icon"), nil, 
    {
        terminal_name = "player_ornaments_change_icon_cell_update",
        terminal_state = 0,
		cells = self
    },
    nil,1)
	
	self:onUpdateDraw()
	-- state_machine.excute("player_ornaments_change_icon_cell_update",0,0)
end

function playerOrnamentsChangeIconCell:onExit()
    local root = self.roots[1]
	cacher.freeRef(config_csb.cells.player.player_head_ornaments_icon_cell, root)
end

function playerOrnamentsChangeIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function playerOrnamentsChangeIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(config_csb.cells.player.player_head_ornaments_icon_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function playerOrnamentsChangeIconCell:init(params)
	self._info = params
	self:unload()
    self:onInit()
	self:setContentSize(playerOrnamentsChangeIconCell.__size)
end

