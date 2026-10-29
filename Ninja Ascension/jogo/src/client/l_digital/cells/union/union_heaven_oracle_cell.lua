--------------------------------------------------------------------------------------------------------------
--  说明：封坛祭天神官信息
--------------------------------------------------------------------------------------------------------------
UnionHeavenOracleCell = class("UnionHeavenOracleCellClass", Window)

function UnionHeavenOracleCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union heaven oracle cell machine.
    local function init_union_heaven_oracle_cell_terminal()
		-- 点击神官切换描述信息
		local union_heaven_oracle_cell_change_info_terminal = {
            _name = "union_heaven_oracle_cell_change_info",
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
		--确认按钮
		local union_heaven_oracle_cell_ensure_button_terminal = {
            _name = "union_heaven_oracle_cell_ensure_button",
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
		
		state_machine.add(union_heaven_oracle_cell_change_info_terminal)
		state_machine.add(union_heaven_oracle_cell_ensure_button_terminal)
        state_machine.init()
    end
    -- call func init union heaven oracle cell state machine.
    init_union_heaven_oracle_cell_terminal()

end

function UnionHeavenOracleCell:updateDraw()

end

function UnionHeavenOracleCell:onInit()
	self:updateDraw()
end

function UnionHeavenOracleCell:onEnterTransitionFinish()

end

function UnionHeavenOracleCell:init()
	self:onInit()
	return self
end

function UnionHeavenOracleCell:onExit()

end

function UnionHeavenOracleCell:createCell()
	local cell = UnionHeavenOracleCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
