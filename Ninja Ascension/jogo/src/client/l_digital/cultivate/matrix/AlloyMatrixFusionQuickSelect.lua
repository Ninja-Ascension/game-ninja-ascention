-----------------------------
-- 合金矩阵主界面
-----------------------------
AlloyMatrixFusionQuickSelect = class("AlloyMatrixFusionQuickSelectClass", Window)

local alloy_matrix_fusion_quick_select_open_terminal = {
	_name = "alloy_matrix_fusion_quick_select_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixFusionQuickSelectClass") == nil then
            fwin:open(AlloyMatrixFusionQuickSelect:new():init(), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_fusion_quick_select_close_terminal = {
	_name = "alloy_matrix_fusion_quick_select_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AlloyMatrixFusionQuickSelectClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_fusion_quick_select_open_terminal)
state_machine.add(alloy_matrix_fusion_quick_select_close_terminal)
state_machine.init()

function AlloyMatrixFusionQuickSelect:ctor()
	self.super:ctor()
	self.roots = {}

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFusion")
    
    app.load("client.cells.ship.hero_icon_list_cell")
    
    local function init_alloy_matrix_terminal()
        local matrix_quality_choice_yes_terminal = {
            _name = "matrix_quality_choice_yes",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local quality = {}
                for i=1,5 do
                    local check_box = ccui.Helper:seekWidgetByName(root,"CheckBox_matrix_quality_choice_list_" .. i)
                    if check_box and check_box:isSelected() then
                        table.insert(quality, (i-1))
                    end
                end
                state_machine.excute("matrix_fusion_metal_num_select", 0, {quality, 3})
                state_machine.excute("alloy_matrix_fusion_quick_select_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(matrix_quality_choice_yes_terminal)
        state_machine.init()
    end
    init_alloy_matrix_terminal()
end


function AlloyMatrixFusionQuickSelect:onUpdateDraw()
    local root = self.roots[1]
end

function AlloyMatrixFusionQuickSelect:onUpdate( dt )
    
end

function AlloyMatrixFusionQuickSelect:init(params)
    self.all_metals = params
	self:onInit()
    return self
end

function AlloyMatrixFusionQuickSelect:onInit()
    local csbItem = csb.createNode("cultivate/alloy_matrix_quality_choice.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --中级矩阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_Text_matrix_quality_choice_yes"), nil, 
    {
        terminal_name = "matrix_quality_choice_yes", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
end

function AlloyMatrixFusionQuickSelect:onEnterTransitionFinish()
end

function AlloyMatrixFusionQuickSelect:onExit()
    state_machine.remove("tab_btn_change")
end
