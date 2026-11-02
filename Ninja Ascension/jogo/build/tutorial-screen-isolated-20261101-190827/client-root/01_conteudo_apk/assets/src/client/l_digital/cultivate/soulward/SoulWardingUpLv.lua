--------------------------------------------------------------------------------------------------------------
--  说明：灵魂守卫升级成功界面  
--------------------------------------------------------------------------------------------------------------
SoulWardingUpLv = class("SoulWardingUpLvClass", Window)

local soul_warding_up_lv_open_terminal = {
    _name = "soul_warding_up_lv_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SoulWardingUpLvClass") == nil then           
            fwin:open(SoulWardingUpLv:new():init(params), fwin._ui)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local soul_warding_up_lv_close_terminal = {
    _name = "soul_warding_up_lv_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SoulWardingUpLvClass") then
            fwin:close(fwin:find("SoulWardingUpLvClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(soul_warding_up_lv_open_terminal)
state_machine.add(soul_warding_up_lv_close_terminal)
state_machine.init()

function SoulWardingUpLv:ctor()
    self.super:ctor()
    self.roots = {} 
    self.actions = {}
    self.allInfo = {}
end

function SoulWardingUpLv:updateDraw()

   
    local limitnew = zstring.splits(dms.string(dms["soul_guard_level_mould"], self.allInfo[1], 4),"|",",")     --后上限

    local Text_name_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_1")   --升级前上限
    Text_name_1:setString(_new_interface_text[30].."."..self.allInfo[1] - 1)

    local Text_name_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_2")   --升级后上限
    Text_name_2:setString(_new_interface_text[30].."."..self.allInfo[1])

    local Text_fighting_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fighting_n_1")   --攻击

    local Text_speed_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_speed_n_1")   --增加后攻击

    local Text_fighting_n_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fighting_n_3")   --生命
  
    local Text_speed_n_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_speed_n_3")   --增加后的生命

    local Text_fighting_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fighting_n_2")   --防御

    local Text_speed_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_speed_n_2")   --增加后的防御

    for k,v in pairs(limitnew) do
        if tonumber(v[1]) == 0 then
             Text_speed_n_1:setString(limitnew[1][2])
        elseif tonumber(v[1]) == 1 then
            Text_speed_n_2:setString(limitnew[2][2])
        elseif tonumber(v[1]) == 2 then
            Text_speed_n_3:setString(limitnew[3][2])
        end
    end
    
    if tonumber(self.allInfo[1]) == 1 then
        Text_fighting_n_1:setString(0)
        Text_fighting_n_2:setString(0)
        Text_fighting_n_3:setString(0)
        return
    end
    local limit = zstring.splits(dms.string(dms["soul_guard_level_mould"], self.allInfo[1]-1, 4),"|",",")     --前上限
    for k,v in pairs(limitnew) do
        if tonumber(v[1]) == 0 then
             Text_fighting_n_1:setString(limit[1][2])
        elseif tonumber(v[1]) == 1 then
            Text_fighting_n_2:setString(limit[2][2])
        elseif tonumber(v[1]) == 2 then
            Text_fighting_n_3:setString(limit[3][2])
        end
    end
end


function SoulWardingUpLv:onUpdate(dt)
    
end

function SoulWardingUpLv:onEnterTransitionFinish()
    local csbNode = csb.createNode("cultivate/soul_warding_up.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)
    local action = csb.createTimeline("cultivate/soul_warding_up.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("zhankai", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil, 
    {
        terminal_name = "soul_warding_up_lv_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 0)

  
    self:updateDraw()
end


function SoulWardingUpLv:init(params)
    self.allInfo = params
    return self
end

function SoulWardingUpLv:onExit()
    
end