----------------------------------------------------------------------------------------------------
-- 说明：角色创建选择项
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CharacterCreateChooseCell = class("CharacterCreateChooseCellClass", Window)
 
function CharacterCreateChooseCell:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.nIndex = -1
	self.bSelected = false
	
	self.bigOne = nil
	self.normalOne = nil
	
    local function init_character_create_choose_cell_terminal()
		local character_cell_selected_change_terminal = {
			_name = "character_cell_selected_change",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("character_cell_unselected_all", 0, "")
			
				local cell = params._datas._cell
				cell.bSelected = true
				cell:onUpdateDraw()
				
				state_machine.excute("character_selectIndex_change", 0, cell.nIndex - 1)
				
				state_machine.excute("Q_character_change", 0, "")
				
				state_machine.excute("character_list_refresh", 0, "")
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local character_cell_unselected_terminal = {
			_name = "character_cell_unselected",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._cell
				cell.bSelected = false
				cell:onUpdateDraw()
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(character_cell_selected_change_terminal)
		state_machine.add(character_cell_unselected_terminal)
        state_machine.init()
    end
	
    init_character_create_choose_cell_terminal()
end

function CharacterCreateChooseCell:onUpdateDraw()
	if self.bSelected == false then
		self.normalOne:setVisible(true)
		self.bigOne:setVisible(false)
		self:setContentSize(self.normalOne:getContentSize())

	elseif self.bSelected == true then
		self.normalOne:setVisible(false)
		self.bigOne:setVisible(true)
		self:setContentSize(self.bigOne:getContentSize())

	end
	
	state_machine.excute("character_list_role_info_refresh", 0, {index = self.nIndex,selected = self.bSelected}) --通知 信息隐藏显示
end

function CharacterCreateChooseCell:onEnterTransitionFinish()
	local csbCharacterCreateChooseCell = csb.createNode("login/character_creation_list.csb")
	local root = csbCharacterCreateChooseCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.bigOne = ccui.Helper:seekWidgetByName(root, "Panel_rols_2")
	self.normalOne = ccui.Helper:seekWidgetByName(root, "Panel_rols_1")
	
	self.bigOne:setBackGroundImage(string.format("images/ui/login/login_role_%d_%d.png", self.nIndex, 2))
	self.normalOne:setBackGroundImage(string.format("images/ui/login/login_role_%d_%d.png", self.nIndex, 1))

	fwin:addTouchEventListener(root, nil, 
	{
		terminal_name = "character_cell_selected_change", 
		terminal_state = 0, 
		_cell = self
	},
	nil,0)
	
	self:onUpdateDraw()
end

function CharacterCreateChooseCell:onExit()

end

function CharacterCreateChooseCell:init(_nIndex, _bSelected)
	self.nIndex = _nIndex
	self.bSelected = _bSelected or false
end

function CharacterCreateChooseCell:createCell()
	local cell = CharacterCreateChooseCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end