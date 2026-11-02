-----------------------------
-- 天赋界面1
-----------------------------
SmTalentPageOne = class("SmTalentPageOneClass", Window)

--打开界面
local sm_talent_page_one_open_terminal = {
	_name = "sm_talent_page_one_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local page = SmTalentPageOne:new():init(params)
        return page	
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_page_one_open_terminal)
state_machine.init()

function SmTalentPageOne:ctor()
	self.super:ctor()
	self.roots = {}
    
    local function init_sm_talent_page_one_terminal()
        local sm_talent_page_one_update_terminal = {
            _name = "sm_talent_page_one_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_talent_page_one_update_terminal)
        state_machine.init()
    end
    init_sm_talent_page_one_terminal()
end

function SmTalentPageOne:onUpdateDraw()
    local root = self.roots[1]
    for i = 1 , 7 do
        local Panel_branch_tf = ccui.Helper:seekWidgetByName(root,"Panel_branch_tf_"..i)
        Panel_branch_tf:removeAllChildren(true)
        Panel_branch_tf:setSwallowTouches(false)
        local cell = state_machine.excute("sm_talent_cell_creat",0,{ 1 , i })
        Panel_branch_tf:addChild(cell)
        if i > 1 then
            local Image_arrow_bg = ccui.Helper:seekWidgetByName(root,"Image_arrow_bg_"..i)
            if Image_arrow_bg ~= nil then
                if cell.islock == false then
                    Image_arrow_bg:setVisible(true)
                else
                    Image_arrow_bg:setVisible(false)
                end
            end
        end
    end
    local Text_tip_1 = ccui.Helper:seekWidgetByName(root,"Text_tip_1")
    Text_tip_1:setString(string.format(_new_interface_text[145] , _ED.digital_talent_page_use_point_array[1])) 
end

function SmTalentPageOne:init()
	self:onInit()
    return self
end

function SmTalentPageOne:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent_tab_1.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	self:onUpdateDraw()

end

function SmTalentPageOne:onEnterTransitionFinish()
    
end


function SmTalentPageOne:onExit()
	state_machine.remove("sm_talent_page_one_update")
end

