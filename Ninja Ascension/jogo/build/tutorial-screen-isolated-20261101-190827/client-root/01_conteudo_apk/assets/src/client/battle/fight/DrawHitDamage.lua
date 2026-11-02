-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗中的连击伤害绘制
-------------------------------------------------------------------------------------------------------
DrawHitDamage = class("DrawHitDamageClass", Window)
DrawHitDamage.__cmoroon = true

local draw_hit_damage_check_window_terminal = {
    _name = "draw_hit_damage_check_window",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local camp = params
        if camp == 0 or camp == 1 then
            local wIndex = camp + 1
            terminal.windows = terminal.windows or {}
            local dhdWindow = terminal.windows[wIndex]
            if dhdWindow ~= nil and dhdWindow.roots == nil then
                terminal.windows[wIndex] = nil
                dhdWindow = nil
            end
            if dhdWindow ~= nil and dhdWindow:isVisible() == false then
                if dhdWindow ~= nil and dhdWindow.playExitAction ~= nil then
                    dhdWindow:playExitAction()
                end
                dhdWindow = nil
                terminal.windows[wIndex] = nil
            end
            if dhdWindow == nil then
                dhdWindow = DrawHitDamage:new():init(0, 0, camp)
                fwin:open(dhdWindow, fwin._view)
                terminal.windows[wIndex] = dhdWindow
            end

            local cIdx = camp == 0 and 2 or 1
            local dhdWindow = terminal.windows[cIdx]
            if dhdWindow ~= nil and dhdWindow.playExitAction ~= nil then
                dhdWindow:playExitAction()
            end
            terminal.windows[cIdx] = nil
        else
            if terminal.windows ~= nil then
                if params == nil then
                    local dhdWindow = terminal.windows[1]
                    if dhdWindow ~= nil and dhdWindow.playExitAction ~= nil then
                        dhdWindow:playExitAction()
                    end
                    dhdWindow = terminal.windows[2]
                    if dhdWindow ~= nil and dhdWindow.playExitAction ~= nil then
                        dhdWindow:playExitAction()
                    end
                    terminal.windows = {}
                else
                    local cIdx = math.abs(params)
                    local dhdWindow = terminal.windows[cIdx]
                    if dhdWindow ~= nil and dhdWindow.playExitAction ~= nil then
                        dhdWindow:playExitAction()
                    end
                    terminal.windows[cIdx] = nil
                end
            end
        end

        -- local camp = params
        -- if camp == nil or camp < 0 then
        --     terminal.camp = -1
        --     state_machine.excute("draw_hit_damage_exit", 0, 0)
        --     -- fwin:close(fwin:find("DrawHitDamageClass"))
        --     return
        -- end
        -- if terminal.camp ~= camp then
        --     terminal.camp = camp
        --     state_machine.excute("draw_hit_damage_exit", 0, 0)
        --     -- fwin:close(fwin:find("DrawHitDamageClass"))
        --     fwin:open(DrawHitDamage:new():init(0, 0), fwin._view)
        -- end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(draw_hit_damage_check_window_terminal)
state_machine.init()

function DrawHitDamage:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._duration = _battle_controller == nil and 0 or (_battle_controller._draw_hit_damage_duration or 2)
    self._elapsed = 0

    self._camp = 0
    self._attackHitCount = 0
    self._hitDamage = 0

    self._drawAttackHitCount = 0
    self._drawHitDamage = 0
    self._lastDrawAttackHitCount = 0
    self._lastDdrawHitDamage = -1

    self._drawHitDamageCount = 1

    self._draw_hit_count_states = {    
        -- {类型（0：打击数， 1：伤害）,数值, 绘制的帧计数, 绘制的状态(0：未绘制,1：已绘制)}
        -- {_type = 0, _value = 1, _frame = 0, _state = 0}
        -- {1, 100, 0}
    }

    self._draw_hit_damage_states = {   
        -- {类型（0：打击数， 1：伤害）,数值, 绘制的帧计数, 绘制的状态(0：未绘制,1：已绘制)}
        -- {_type = 0, _value = 1, _frame = 0, _state = 0}
        -- {1, 100, 0}
    }

    self._draw_exit_states = {   
        -- {类型（0：打击数， 1：伤害, 2：退出）,数值, 绘制的帧计数, 绘制的状态(0：未绘制,1：已绘制)}
        -- {_type = 0, _value = 1, _frame = 0, _state = 0}
        -- {1, 100, 0}
    }

    -- Initialize draw hit damage state machine.
    local function init_draw_hit_damage_terminal()
        local draw_hit_damage_draw_hit_count_terminal = {
            _name = "draw_hit_damage_draw_hit_count",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    local _terminal = state_machine.find("draw_hit_damage_check_window")
                    if params ~= nil and params[2] ~= nil then
                        local wIndex = params[2] + 1
                        instance = _terminal.windows[wIndex]
                        if instance ~= nil and instance._draw_hit_count_states ~= nil then
                            instance._elapsed = 0
                            table.insert(instance._draw_hit_count_states, {_type = 0, _value = (params[1] or 0), _frame = 2, _state = 0})
                        end
                    end
                else
    				if fwin:find("DrawHitDamageClass") ~= nil and instance ~= nil and instance._draw_hit_count_states ~= nil then
                        -- instance._elapsed = 0
    					table.insert(instance._draw_hit_count_states, {_type = 0, _value = (params or 0), _frame = 2, _state = 0})
    				end
                    -- if instance._drawAttackHitCount > 0 or #instance._draw_hit_count_states > 1 then
                    --     instance:udpateDrawHitCount()
                    -- end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local draw_hit_damage_draw_hit_damage_terminal = {
            _name = "draw_hit_damage_draw_hit_damage",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    local _terminal = state_machine.find("draw_hit_damage_check_window")
                    local wIndex = params[2] + 1
                    instance = _terminal.windows[wIndex]
                    if instance ~= nil and instance._drawHitDamage ~= nil then
                        instance._elapsed = 0
                        if instance._draw_hit_damage_states == nil then 
                            instance._draw_hit_damage_states = {} 
                        end
                        table.insert(instance._draw_hit_damage_states, {_type = 1, _value = (params[1] or 0), _frame = 2, _state = 0})
                    end
                else
                    -- table.insert(instance._draw_hit_damage_states, {_type = 1, _value = (params or 0), _frame = 2, _state = 0})
                    if fwin:find("DrawHitDamageClass") ~= nil and instance ~= nil and instance._drawHitDamage ~= nil then
                        -- instance._elapsed = 0

                        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                            if instance._draw_hit_damage_states == nil then 
                                instance._draw_hit_damage_states = {} 
                            end
                            table.insert(instance._draw_hit_damage_states, {_type = 1, _value = (params or 0), _frame = 2, _state = 0})
                        else
                            instance._drawHitDamage = instance._drawHitDamage + (params or 0)
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local draw_hit_damage_exit_terminal = {
            _name = "draw_hit_damage_exit",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    if fwin:find("DrawHitDamageClass") ~= nil and instance ~= nil then
                        fwin:close(instance)
                    end
                else
                    -- table.insert(instance._draw_exit_states, {_type = 2, _value = 0, _frame = 20, _state = 0})
    				if fwin:find("DrawHitDamageClass") ~= nil and instance ~=nil and instance.udpateDrawTotalDamage ~= nil then
                        instance._elapsed = 0
    					if instance._draw_hit_damage_states == nil then 
    						instance._draw_hit_damage_states = {} 
    					end
    					table.insert(instance._draw_hit_damage_states, {_type = 1, _value = instance._drawHitDamage, _frame = 2, _state = 0})
    					instance:udpateDrawTotalDamage()
    				end
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(draw_hit_damage_draw_hit_count_terminal)
        state_machine.add(draw_hit_damage_draw_hit_damage_terminal)
        state_machine.add(draw_hit_damage_exit_terminal)
        state_machine.init()
    end

    -- call func init draw hit damage machine.
    init_draw_hit_damage_terminal()
end

function DrawHitDamage:init(_attackHitCount, _hitDamage, camp)
    self._attackHitCount = _attackHitCount
    self._hitDamage = _hitDamage
    self._camp = camp
    return self
end

function DrawHitDamage:onUpdateDraw(_drawType)
    if _drawType == 0 then
        if self._lastDrawAttackHitCount ~= self._drawAttackHitCount then
            local root = self.roots[1]
            self._lastDrawAttackHitCount = self._drawAttackHitCount

            if __lua_project_id == __lua_project_gragon_tiger_gate 
                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_legendary_game 
                then
                local numberString = ""..self._drawAttackHitCount
                local placeCount = #numberString
                for i = 1, 3 do
                    ccui.Helper:seekWidgetByName(root, "AtlasLabel_lianji_"..i):setString("")
                    ccui.Helper:seekWidgetByName(root, "AtlasLabel_lianji_0_"..i):setString("")
                end
                for i = 1, placeCount do
                    local numberChar = ""..(string.byte(numberString, i) - 48)
                    local nIndex = (placeCount - i + 1) -- self._camp == 0 and i or (placeCount - i + 1)
                    if placeCount == 1 then
                        nIndex = 2
                    end
                    ccui.Helper:seekWidgetByName(root, "AtlasLabel_lianji_"..nIndex):setString(numberChar) 
                    ccui.Helper:seekWidgetByName(root, "AtlasLabel_lianji_0_"..nIndex):setString(numberChar)     
                end
            else
                ccui.Helper:seekWidgetByName(root, "AtlasLabel_lianji"):setString(""..self._drawAttackHitCount)
                
                -- 添加连击的附加特效文字
                local additionEffectLabel = ccui.Helper:seekWidgetByName(root, "AtlasLabel_lianji_0")
                if additionEffectLabel ~= nil then
                    additionEffectLabel:setString(""..self._drawAttackHitCount)
                end
            end
        end
    elseif _drawType == 1 then
        if self._lastDdrawHitDamage ~= self._drawHitDamage then
            local root = self.roots[2]
            self._lastDdrawHitDamage = self._drawHitDamage
            local labelObject = ccui.Helper:seekWidgetByName(root, "AtlasLabel_xue")
            labelObject:setString(""..self._drawHitDamage)

            local hpTile = ccui.Helper:seekWidgetByName(root, "Image_2")
            hpTile:setVisible(true)

            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                -- local _terminal = state_machine.find("draw_hit_damage_check_window")
                if self._camp ~= nil and self._camp ~= 0 then
                    -- hpTile:setPositionX(hpTile._base_postion_x - labelObject:getContentSize().width)
                else
                    -- hpTile:setPositionX(hpTile._base_postion_x - labelObject:getContentSize().width)
                end
            else
                hpTile:setPositionX(hpTile._base_postion_x - labelObject:getContentSize().width)
            end
        end
    end

    if nil ~= self.Sprite_ljm then
        local hIdx = self._drawAttackHitCount % 4
        self.Sprite_ljm:setTexture("images/ui/battle/ljm_" .. hIdx .. ".png")
    end
end

function DrawHitDamage:udpateDrawHitCount()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        return
    end
    -- local root = self.roots[1]
    -- root:setVisible(true)
    -- local v = self._draw_hit_count_states[1]
    -- if v ~= nil then
    --     if v._state == 0 then
    --         local hit_count_action = self.actions[1]
    --         local action_name = self._drawAttackHitCount == 0 and "combo_damage_big_move" or "combo_damage_move"
    --         self._drawAttackHitCount = self._drawAttackHitCount + v._value
    --         v._state = 1
    --         self:onUpdateDraw(0)
    --         hit_count_action:play(action_name, false)
    --     end
    -- else
    --     self:udpateDrawTotalDamage()
    -- end
    if self._drawAttackHitCount > 0 or #self._draw_hit_count_states > 1 then
        local nCount = 0
        for i, v in pairs(self._draw_hit_count_states) do
            if v._state == 0 then
                nCount = nCount + 1
            end
        end
        if nCount <= 0 then
            self:udpateDrawTotalDamage()
        end
    end
end

function DrawHitDamage:udpateDrawTotalDamage()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        return
    end

    if self._drawAttackHitCount < 2 then
        fwin:close(self)
    else
        -- if #self._draw_hit_count_states == 0 and #self._draw_hit_damage_states == 1 then
        if #self._draw_hit_damage_states == 1 then
            self._draw_hit_damage_states = {}
            local hit_damage_action = self.actions[2]
            self:onUpdateDraw(1)
            hit_damage_action:play("zongshanghai_move", false)
        end
    end
end

function DrawHitDamage:playExitAction()
    local hit_count_action = self.actions[1]
    local hit_damage_action = self.actions[2]

    hit_count_action:play("combo_damage_move_xs", false)
    hit_damage_action:play("zongshanghai_move_xs", false)
end

function DrawHitDamage:onUpdate(dt)
    self._elapsed = self._elapsed + dt
    if self._elapsed >= self._duration * __fight_recorder_action_time_speed then
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
            -- state_machine.excute("draw_hit_damage_check_window", 0, -1)
            -- fwin:close(self)
            -- self:setVisible(false)
            self._draw_hit_count_states = {}
            self._draw_hit_damage_states = {}
            self._draw_exit_states = {}
            state_machine.excute("draw_hit_damage_check_window", 0, -1 * (self._camp + 1))
            return
        end
    end

    local hit_count_action = self.actions[1]
    local hit_damage_action = self.actions[2]
    local exit_action = self.actions[3]

    -- if exit_action ~= nil then
    --     for i, v in pairs(self._draw_exit_states) do
    --         if v._frame > 0 then
    --             if v._state == 0 then
    --                 self._drawHitDamage = self._drawHitDamage + v._value
    --                 v._state = 1
    --                 -- self:onUpdateDraw()
    --                 -- exit_action:play("zongshanghai_move", false)
    --             end
    --             v._frame = v._frame - 1
    --             break
    --         else
    --             fwin:close(self)
    --             return
    --         end
    --     end
    -- end

    if #self._draw_hit_count_states < 2 
        -- or #self._draw_hit_damage_states < 2 
        then
        return
    end

    local root = self.roots[1]
    root:setVisible(true)
    local nCount = 0
    if hit_count_action ~= nil then
        for i, v in pairs(self._draw_hit_count_states) do
            if v._frame > 0 then
                if v._state == 0 then
                    local action_name = self._drawAttackHitCount == 0 and "combo_damage_big_move" or "combo_damage_move"
                    self._drawAttackHitCount = self._drawAttackHitCount + v._value
                    v._state = 1
                    self:onUpdateDraw(0)
                    hit_count_action:play(action_name, false)
                end
                v._frame = v._frame - 1
                nCount = nCount + 1
                break
            end
        end
    end

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        if hit_damage_action ~= nil then
            for i, v in pairs(self._draw_hit_damage_states) do
                if v._frame > 0 then
                    if v._state == 0 then
                        local action_name = self._drawHitDamage == 0 and "zongshanghai_big_move" or "zongshanghai_move"
                        self._drawHitDamage = self._drawHitDamage + v._value
                        v._state = 1
                        self:onUpdateDraw(1)
                        hit_damage_action:play(action_name, false)
                    end
                    v._frame = v._frame - 1
                    nCount = nCount + 1
                    break
                end
            end
        end
    else
        if self._drawAttackHitCount > 0 then
            if nCount == 0 then
                self:udpateDrawTotalDamage(0)
            end
        end

        -- if hit_damage_action ~= nil then
        --     for i, v in pairs(self._draw_hit_damage_states) do
        --         if v._frame > 0 then
        --             if v._state == 0 then
        --                 self._drawHitDamage = self._drawHitDamage + v._value
        --                 v._state = 1
        --                 self:onUpdateDraw()
        --                 hit_damage_action:play("zongshanghai_move", false)
        --             end
        --             v._frame = v._frame - 1
        --             break
        --         end
        --     end
        -- end
    end
end

function DrawHitDamage:onEnterTransitionFinish()
    local hitCountCSBFileName = "battle/injury_settlement_batter%s.csb"
    local totalDamageCSBFileName = "battle/injury_settlement%s.csb"

    -- local _terminal = state_machine.find("draw_hit_damage_check_window")
    if self._camp ~= nil and self._camp ~= 0 then
        hitCountCSBFileName = string.format(hitCountCSBFileName, "_0")
        totalDamageCSBFileName = string.format(totalDamageCSBFileName, "_0")
    else
        hitCountCSBFileName = string.format(hitCountCSBFileName, "")
        totalDamageCSBFileName = string.format(totalDamageCSBFileName, "")
    end

    local csbInjury = csb.createNode(hitCountCSBFileName)
    local root = csbInjury:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbInjury)

    root:setVisible(false)

    local csbInjuryDamage = csb.createNode(totalDamageCSBFileName)
    local root_damage = csbInjuryDamage:getChildByName("root")
    table.insert(self.roots, root_damage)
    self:addChild(csbInjuryDamage)

    local hpTile = ccui.Helper:seekWidgetByName(root_damage, "Image_2")
    hpTile:setVisible(false)
    hpTile._base_postion_x = hpTile:getPositionX()

    if __lua_project_id == __lua_project_l_naruto then
        local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
        local Sprite_ljm = Panel_4:getChildByName("Sprite_ljm")

        if nil ~= Sprite_ljm then
            local hIdx = self._drawAttackHitCount % 4
            Sprite_ljm:setTexture("images/ui/battle/ljm_" .. hIdx .. ".png")
            self.Sprite_ljm = Sprite_ljm
        end
    end

    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_legendary_game 
        then
        local hit_count_action = csb.createTimeline(hitCountCSBFileName)
        table.insert(self.actions, hit_count_action)
        csbInjury:runAction(hit_count_action)
        hit_count_action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "combo_damage_move_xs_over" then
                fwin:close(self)
            end
        end)

        local hit_damage_action = csb.createTimeline(totalDamageCSBFileName)
        table.insert(self.actions, hit_damage_action)
        csbInjuryDamage:runAction(hit_damage_action)
        -- hit_damage_action:setFrameEventCallFunc(function (frame)
        --     if nil == frame then
        --         return
        --     end

        --     local str = frame:getEvent()
        --     if str == "zongshanghai_big_move_over" then
        --         -- self:udpateDrawTotalDamage(0)
        --     elseif str == "zongshanghai_move_over" then
        --         -- self:udpateDrawTotalDamage(0)
        --     end
        -- end)
    else
        local hit_count_action = csb.createTimeline(hitCountCSBFileName)
        table.insert(self.actions, hit_count_action)
        csbInjury:runAction(hit_count_action)
        hit_count_action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "combo_damage_big_move_over" then
                -- table.remove(self._draw_hit_count_states, "1")
                self:udpateDrawHitCount(0)
            elseif str == "combo_damage_move_over" then
                -- table.remove(self._draw_hit_count_states, "1")
                self:udpateDrawHitCount(0)
            end
        end)

        -- action:play("combo_damage_big_move", false)
        -- self._drawAttackHitCount = self._drawAttackHitCount + 1
        -- self:onUpdateDraw()

        local hit_damage_action = csb.createTimeline(totalDamageCSBFileName)
        table.insert(self.actions, hit_damage_action)
        csbInjuryDamage:runAction(hit_damage_action)
        hit_damage_action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "zongshanghai_move_over" then
                fwin:close(self)
            end
        end)

        local exit_action = csb.createTimeline(totalDamageCSBFileName)
        table.insert(self.actions, exit_action)
        csbInjuryDamage:runAction(exit_action)
        exit_action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "zongshanghai_move_over" then
                fwin:close(self)
            end
        end)    
    end

    -- local csbInjury = csb.createNode("battle/injury_settlement.csb")
    -- local root = csbInjury:getChildByName("root")
    -- table.insert(self.roots, root)
    -- local action = csb.createTimeline("battle/injury_settlement.csb")

    -- local hpTile = ccui.Helper:seekWidgetByName(root, "Image_2")
    -- hpTile:setVisible(false)
    -- hpTile._base_postion_x = hpTile:getPositionX() 
    -- csbInjury:runAction(action)
    -- -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end

    --     local str = frame:getEvent()
    --     if str == "combo_damage_big_move_over" then
    --         action:play("combo_damage_move", false)
    --         self._drawAttackHitCount = self._drawAttackHitCount + 1
    --         self:onUpdateDraw()
    --     elseif str == "combo_damage_move_over" then
    --         if self._drawAttackHitCount == self._attackHitCount then
    --             self._drawHitDamage = self._hitDamage
    --             self:onUpdateDraw()

    --             action:play("zongshanghai_move", false)
    --         else
    --             action:play("combo_damage_move", false)
    --             self._drawAttackHitCount = self._drawAttackHitCount + 1
    --             self:onUpdateDraw()
    --         end
    --     elseif str == "zongshanghai_move_over" then
    --         fwin:close(self)
    --         -- if self._drawHitDamageCount == self._attackHitCount then
    --         --     fwin:close(self)
    --         -- else
    --         --     action:play("zongshanghai_move", false)
    --         --     -- self._drawHitDamage = math.floor(self._hitDamage * self._drawHitDamageCount / self._attackHitCount)
    --         --     self._drawHitDamage = self._hitDamage
    --         --     self._drawHitDamageCount  = self._attackHitCount
    --         --     self:onUpdateDraw()
    --         --     --self._drawHitDamageCount = self._drawHitDamageCount + 1
    --         -- end
    --     end
    -- end)

    -- action:play("combo_damage_big_move", false)

    -- self:addChild(csbInjury)

    -- self._drawAttackHitCount = self._drawAttackHitCount + 1
    -- self:onUpdateDraw()

end

function DrawHitDamage:onExit()
    self.roots = nil    
end
