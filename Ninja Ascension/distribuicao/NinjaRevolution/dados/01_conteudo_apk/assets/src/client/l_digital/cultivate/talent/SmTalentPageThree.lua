-----------------------------
-- 天赋界面3
-----------------------------
SmTalentPageThree = class("SmTalentPageThreeClass", Window)

--打开界面
local sm_talent_page_three_open_terminal = {
    _name = "sm_talent_page_three_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local page = SmTalentPageThree:new():init()
        return page 
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_talent_page_three_open_terminal)
state_machine.init()

function SmTalentPageThree:ctor()
    self.super:ctor()
    self.roots = {}
    
    local function init_sm_talent_page_three_terminal()
        local sm_talent_page_three_update_terminal = {
            _name = "sm_talent_page_three_update",
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

        state_machine.add(sm_talent_page_three_update_terminal)
        state_machine.init()
    end
    init_sm_talent_page_three_terminal()
end

function SmTalentPageThree:onUpdateDraw()
    local root = self.roots[1]
    for i = 1 , 10 do
        local Panel_branch_tf = ccui.Helper:seekWidgetByName(root,"Panel_branch_tf_"..i)
        Panel_branch_tf:removeAllChildren(true)
        Panel_branch_tf:setSwallowTouches(false)
        local cell = state_machine.excute("sm_talent_cell_creat",0,{ 3 , i})
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
    local Text_tip_3 = ccui.Helper:seekWidgetByName(root,"Text_tip_3")
    local needLv = 0
    local needPage = ""
    local needPoint = 0
    local unLockData = zstring.split(dms.string(dms["ship_talent_group"],3,ship_talent_group.unlock_lv),"|")
    for i , v in pairs(unLockData) do
        local needData = zstring.split(v , ",")
        if tonumber(needData[1]) == 1 then --等级判定
            needLv = tonumber(needData[2])
        else
            needPoint = tonumber(needData[3])
            needPage = numberToStringArg[tonumber(needData[2])]
        end
    end
    if _ED.digital_talent_page_is_lock[3] == true then
        Text_tip_3:setString(string.format(_new_interface_text[146] , needPage, needPoint, needLv))
    else
       Text_tip_3:setString(string.format(_new_interface_text[145] , _ED.digital_talent_page_use_point_array[3])) 
    end
end

function SmTalentPageThree:init()
    self:onInit()
    return self
end

function SmTalentPageThree:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent_tab_3.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    self:onUpdateDraw()

end

function SmTalentPageThree:onEnterTransitionFinish()
    
end


function SmTalentPageThree:onExit()
    state_machine.remove("sm_talent_page_three_update")
end

