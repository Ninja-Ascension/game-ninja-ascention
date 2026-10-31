-----------------------------
-- 天赋界面4
-----------------------------
SmTalentPageFour = class("SmTalentPageFourClass", Window)

--打开界面
local sm_talent_page_four_open_terminal = {
    _name = "sm_talent_page_four_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local page = SmTalentPageFour:new():init()
        return page 
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_talent_page_four_open_terminal)
state_machine.init()

function SmTalentPageFour:ctor()
    self.super:ctor()
    self.roots = {}
    
    local function init_sm_talent_page_four_terminal()
        local sm_talent_page_four_update_terminal = {
            _name = "sm_talent_page_four_update",
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

        state_machine.add(sm_talent_page_four_update_terminal)
        state_machine.init()
    end
    init_sm_talent_page_four_terminal()
end

function SmTalentPageFour:onUpdateDraw()
    local root = self.roots[1]
    local ListView_tf_tab_4 = ccui.Helper:seekWidgetByName(root, "ListView_tf_tab_4")
    
    for k,v in pairs(ListView_tf_tab_4:getItems()) do
        state_machine.excute("sm_talent_four_cell_update_info", 0, v)
    end

    local Text_tip_3 = ccui.Helper:seekWidgetByName(root,"Text_tip_3")
    local needLv = 0
    local needPage = ""
    local needPoint = 0
    local unLockData = zstring.split(dms.string(dms["ship_talent_group"],4,ship_talent_group.unlock_lv),"|")
    for i , v in pairs(unLockData) do
        local needData = zstring.split(v , ",")
        if tonumber(needData[1]) == 1 then --等级判定
            needLv = tonumber(needData[2])
        else
            needPoint = tonumber(needData[3])
            needPage = numberToStringArg[tonumber(needData[2])]
        end
    end
    if _ED.digital_talent_page_is_lock[4] == true then
        Text_tip_3:setString(string.format(_new_interface_text[146] , needPage, needPoint, needLv))
    else
        Text_tip_3:setString(string.format(_new_interface_text[145], _ED.digital_talent_page_use_point_array[4])) 
    end
end

function SmTalentPageFour:initTalentInfo( ... )
    local root = self.roots[1]
    local ListView_tf_tab_4 = ccui.Helper:seekWidgetByName(root, "ListView_tf_tab_4")
    ListView_tf_tab_4:removeAllItems()
    local pageTalents = zstring.split(dms.string(dms["ship_talent_group"], 4, ship_talent_group.first_mould), ",")
    for k,v in pairs(pageTalents) do
        ListView_tf_tab_4:addChild(state_machine.excute("sm_talent_four_cell_creat", 0, {k, v}))
    end
    ListView_tf_tab_4:requestRefreshView()
end

function SmTalentPageFour:init()
    self:onInit()
    return self
end

function SmTalentPageFour:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent_tab_4.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    self:initTalentInfo()
    self:onUpdateDraw()
end

function SmTalentPageFour:onEnterTransitionFinish()
    
end

function SmTalentPageFour:onExit()
    state_machine.remove("sm_talent_page_four_update")
end

