SmTalentFourCell = class("SmTalentFourCellClass", Window)
SmTalentFourCell.__size = nil

local sm_talent_four_cell_creat_terminal = {
	_name = "sm_talent_four_cell_creat",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local cell = SmTalentFourCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_four_cell_creat_terminal)
state_machine.init()

function SmTalentFourCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.index = 0
    self.talent_id = 0
    
    local function init_sm_talent_four_cell_terminal()
		local sm_talent_four_cell_update_info_terminal = {
            _name = "sm_talent_four_cell_update_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                    params:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_talent_four_cell_update_info_terminal)
        state_machine.init()
    end
    init_sm_talent_four_cell_terminal()
end

function SmTalentFourCell:onUpdateDraw()
    local root = self.roots[1]
    local index = 0
    local nextTalentId = self.talent_id
    local Panel_branch_text = ccui.Helper:seekWidgetByName(root, "Panel_branch_text")
    Panel_branch_text:removeBackGroundImage()
    Panel_branch_text:setBackGroundImage("images/ui/text/TF_res/tf_text_"..self.index..".png")
    while true do
        index = index + 1
        local function addTalentIcon( index, talent_id )
            local Panel_branch_tf = ccui.Helper:seekWidgetByName(root, "Panel_branch_tf_"..index)
            Panel_branch_tf:removeAllChildren(true)
            Panel_branch_tf:setSwallowTouches(false)
            local cell = state_machine.excute("sm_talent_cell_creat",0,{4, 0, talent_id})
            Panel_branch_tf:addChild(cell)
            if index > 1 then
                local Image_arrow_bg = ccui.Helper:seekWidgetByName(root,"Image_arrow_bg_"..index)
                if Image_arrow_bg ~= nil then
                    if cell.islock == false then
                        Image_arrow_bg:setVisible(true)
                    else
                        Image_arrow_bg:setVisible(false)
                    end
                end
            end
        end
        if nextTalentId <= 0 then
            break
        end
        addTalentIcon(index, nextTalentId)
        nextTalentId = dms.int(dms["ship_talent_mould"], nextTalentId, ship_talent_mould.unlock_mould)
        if nextTalentId <= 0 then
            break
        end
    end
end

function SmTalentFourCell:init(params)
    self.index = tonumber(params[1])
    self.talent_id = tonumber(params[2])
	self:onInit()
    self:setContentSize(SmTalentFourCell.__size)
    return self
end

function SmTalentFourCell:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent_tab_4_cell.csb")
    local root = csbItem:getChildByName("root")
    -- local root = cacher.createUIRef("cultivate/cultivate_talent_icon.csb", "root")
    table.insert(self.roots, root)
    self:addChild(csbItem) 
    if SmTalentFourCell.__size == nil then
        SmTalentFourCell.__size = root:getContentSize()
    end

	-- self:onUpdateDraw()
end

function SmTalentFourCell:onExit()

end


