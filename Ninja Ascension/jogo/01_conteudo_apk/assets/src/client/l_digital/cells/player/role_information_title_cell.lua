--------------------------------------------------------------------------------------------------------------
RoleInformationTitleCell = class("RoleInformationTitleCellClass", Window)
RoleInformationTitleCell.__size = nil
RoleInformationTitleCell.__current_cell = nil

local role_information_title_cell_create_terminal = {
	_name = "role_information_title_cell_create",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local cell = RoleInformationTitleCell:new()
		cell:init(params)
		cell:registerOnNodeEvent(cell)
		-- cell:registerOnNoteUpdate(cell)
		return cell
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_information_title_cell_create_terminal)
state_machine.init()

function RoleInformationTitleCell:ctor()
	self.super:ctor()
	self.roots = {}

	-- var
	self._title_info = nil

	-- load lua files.

	app.load("client.cells.utils.resources_icon_cell")

	local function init_role_information_title_cell_terminal()
		local role_information_title_cell_change_user_title_terminal = {
			_name = "role_information_title_cell_change_user_title",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				local cell = params._datas.cell
				if "0" == cell._title_info[2] then
					TipDlg.drawTextDailog(dms.string(dms["word_mould"], dms.string(dms["title_param"], cell._title_info[1], title_param.lock_tips), word_mould.text_info))
					return false
				end

				local function responseCallback(response)
					state_machine.unlock("role_information_title_cell_change_user_title")
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
							if nil ~= RoleInformationTitleCell.__current_cell then
								RoleInformationTitleCell.__current_cell:unselected()
							end
							if tonumber(response.node._title_info[1]) == tonumber(_ED.user_rank_title_info._current_title) then
								response.node:selected()
							end
						end
					else
						if tonumber(response.node._title_info[1]) == tonumber(_ED.user_rank_title_info._current_title) then
							response.node:selected()
						end
					end
				end

				state_machine.lock("role_information_title_cell_change_user_title")

				protocol_command.user_title_modify.param_list = "" .. cell._title_info[1]
				NetworkManager:register(protocol_command.user_title_modify.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_information_title_cell_change_user_title_terminal)
		state_machine.init()
	end
	init_role_information_title_cell_terminal()
end

function RoleInformationTitleCell:unselected()
	local root = self.roots[1]
	self.Button_bg_select:setHighlighted(false)

	RoleInformationTitleCell.__current_cell = nil
end

function RoleInformationTitleCell:selected()
	self.Button_bg_select:setHighlighted(true)
	
	RoleInformationTitleCell.__current_cell = self
end

function RoleInformationTitleCell:updateDraw()
	local root = self.roots[1]

	local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
	local Panel_bg_view = ccui.Helper:seekWidgetByName(root, "Panel_bg_view")

	if self._title_info[1] == "0" then
		Image_lock:setVisible(false)
		Panel_bg_view:setVisible(false)

		local bg = ccui.Helper:seekWidgetByName(root, "Button_bg_select")
		local label = cc.Label:createWithSystemFont(_title_param_mail[8] or "", "", 20)
		label:setPosition(cc.p(bg:getContentSize().width / 2, bg:getContentSize().height / 2))
		bg:addChild(label)

	else
		Panel_bg_view:setBackGroundImage(string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], self._title_info[1], title_param.pic_index)))
		Image_lock:setVisible(0 == tonumber( self._title_info[2]))
	end

	if tonumber(self._title_info[1]) == tonumber(_ED.user_rank_title_info._current_title) then
		self:selected()
	else
		self.Button_bg_select:setHighlighted(false)
	end

end

function RoleInformationTitleCell:onInit()
	local csbNode = csb.createNode("player/role_information_title_cell.csb")
	local root = csbNode:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)

	if RoleInformationTitleCell.__size == nil then
		RoleInformationTitleCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_2"):getContentSize()
	end

	self.Button_bg_select = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bg_select"), nil, 
	{
		terminal_name = "role_information_title_cell_change_user_title", 
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, nil, 1)

	self:updateDraw()
end

function RoleInformationTitleCell:onEnterTransitionFinish()

end

function RoleInformationTitleCell:init(params)
	self._title_info = params

	self:onInit()
	self:setContentSize(RoleInformationTitleCell.__size)
	return self
end

function RoleInformationTitleCell:onExit()
	if self == RoleInformationTitleCell.__current_cell then
		RoleInformationTitleCell.__current_cell = nil
	end
end