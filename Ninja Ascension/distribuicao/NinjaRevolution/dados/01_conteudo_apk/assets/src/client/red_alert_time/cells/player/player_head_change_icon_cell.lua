----------------------------------------------------------------------------------------------------
-- 说明：头像选择cell
-------------------------------------------------------------------------------------------------------
PlayerHeadChangeIconCell = class("PlayerHeadChangeIconCellClass", Window)
PlayerHeadChangeIconCell.__size = nil

local player_head_change_icon_cell_terminal = {
    _name = "player_head_change_icon_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PlayerHeadChangeIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_head_change_icon_cell_terminal)
state_machine.init()

function PlayerHeadChangeIconCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil
	
 	local function init_player_skill_upgrade_cell_terminal()
        -- --点击
        local player_head_change_icon_cell_update_terminal = {
            _name = "player_head_change_icon_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params._datas.cells
				if terminal.old_object == nil then
					terminal.old_object = cell
					local head_activation = zstring.split(_ED.user_head_activation, ",")
					if zstring.tonumber(head_activation[tonumber(cell._info[1])]) >= 0 then
						state_machine.excute("player_stamp_settings_head_id_recording",0,cell._info[1])
						ccui.Helper:seekWidgetByName(cell.roots[1], "Image_head_icon_hook"):setVisible(true)
					else
						local mould_id = dms.int(dms["avatar_head"], cell._info[1], avatar_head.condition)
						TipDlg.drawTextDailog( dms.string(dms["achievement_mould"], mould_id, achievement_mould.achievement_dec))
					end
					return
				end
				
				if terminal.old_object ~= cell then
					local head_activation = zstring.split(_ED.user_head_activation, ",")
					-- debug.print_r(head_activation)
					if zstring.tonumber(head_activation[tonumber(cell._info[1])]) >= 0 then
						ccui.Helper:seekWidgetByName(terminal.old_object.roots[1], "Image_head_icon_hook"):setVisible(false)
						ccui.Helper:seekWidgetByName(cell.roots[1], "Image_head_icon_hook"):setVisible(true)
						terminal.old_object = cell
						state_machine.excute("player_stamp_settings_head_id_recording",0,cell._info[1])
					else
						local mould_id = dms.int(dms["avatar_head"], cell._info[1], avatar_head.condition)
						TipDlg.drawTextDailog( dms.string(dms["achievement_mould"], mould_id, achievement_mould.achievement_dec))
						-- print("asfafa=="..dms.string(dms["achievement_mould"], mould_id, achievement_mould.achievement_dec))
					end
				else
					return
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_head_change_icon_cell_update_terminal)
        state_machine.init()
    end
	init_player_skill_upgrade_cell_terminal()        	
end


function PlayerHeadChangeIconCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_head_icon = ccui.Helper:seekWidgetByName(root,"Panel_head_icon")
	Panel_head_icon:removeAllChildren(true)
	local head_info = zstring.split(dms.string(dms["avatar_head"], self._info[1], avatar_head.icon_info), ",")
	--图标
	local head_image = head_info[1]
	Panel_head_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, head_image))
	-- Text_head_type:setString(avatar_use_text[self._sort])
	ccui.Helper:seekWidgetByName(root, "Image_head_icon_hook"):setVisible(false)

end

function PlayerHeadChangeIconCell:onEnterTransitionFinish()

end

function PlayerHeadChangeIconCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.player.player_head_change_icon_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PlayerHeadChangeIconCell.__size == nil then
		PlayerHeadChangeIconCell.__size = root:getContentSize()
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
        terminal_name = "player_head_change_icon_cell_update",
        terminal_state = 0,
		cells = self
    },
    nil,1)
	
	self:onUpdateDraw()
	-- state_machine.excute("player_head_change_icon_cell_update",0,0)
end

function PlayerHeadChangeIconCell:onExit()
    local root = self.roots[1]
    local Panel_head_icon = ccui.Helper:seekWidgetByName(root,"Panel_head_icon")
    if Panel_head_icon ~= nil then
		Panel_head_icon:removeAllChildren(true)
	end
	cacher.freeRef(config_csb.cells.player.player_head_change_icon_cell, root)
end

function PlayerHeadChangeIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PlayerHeadChangeIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(config_csb.cells.player.player_head_change_icon_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function PlayerHeadChangeIconCell:init(params)
	self._info = params
	self:unload()
    self:onInit()
	self:setContentSize(PlayerHeadChangeIconCell.__size)
end

