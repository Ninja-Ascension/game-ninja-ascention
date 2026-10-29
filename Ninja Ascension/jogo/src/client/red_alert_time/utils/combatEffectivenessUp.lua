-- The layout's "root" node can be nested below the top node; search all levels.
local function nrFindRoot(node)
    if node == nil then return nil end
    if node:getName() == "root" then return node end
    for _, child in ipairs(node:getChildren()) do
        local found = nrFindRoot(child)
        if found then return found end
    end
    return nil
end

-----------------------------
--战斗力提升
-----------------------------
CombatEffectivenessUp = class("CombatEffectivenessUpClass", Window)

local combat_effectiveness_up_window_open_terminal = {
    _name = "combat_effectiveness_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("CombatEffectivenessUpClass") then
            fwin:open(CombatEffectivenessUp:new():init(params), fwin._display_log)
            return true
        else
            state_machine.excute("combat_effectiveness_up_window_close", 0, "")
        end
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

local combat_effectiveness_up_window_close_terminal = {
    _name = "combat_effectiveness_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:addService({
			callback = function ( params )
				fwin:close(fwin:find("CombatEffectivenessUpClass"))
                if __lua_project_id == __lua_project_red_alert_time
                    or __lua_project_id == __lua_project_pacific_rim
                    then
                    showFightUpOrDown()
                else
                    smFightingChange()
                end
			end,
			params = self
		})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(combat_effectiveness_up_window_open_terminal)
state_machine.add(combat_effectiveness_up_window_close_terminal)
state_machine.init()

function CombatEffectivenessUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self.number = 0
	self.BitmapFontLabel_fight = nil
	self.isJumpDigital = false
	self.Displacement = 0

    self._is_continue = false
    self._root_posY = 0
    self._current_fight_number = 0

    local function init_combat_effectiveness_up_terminal()
        local combat_effectiveness_up_continue_play_terminal = {
            _name = "combat_effectiveness_up_continue_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._is_continue = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local combat_effectiveness_up_on_close_terminal = {
            _name = "combat_effectiveness_up_on_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_continue == false then
                    state_machine.excute("combat_effectiveness_up_window_close",0,"")
                else
                    instance._is_continue = false
                    instance.number = 0
                    instance:continuePlayEffect()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(combat_effectiveness_up_continue_play_terminal)
        state_machine.add(combat_effectiveness_up_on_close_terminal)
        state_machine.init()
    end
    
    -- call func effect_play create state machine.
    init_combat_effectiveness_up_terminal()

    -- var 
    self._now_show_numbers = {}
end

function CombatEffectivenessUp:onEnterTransitionFinish()

end

function CombatEffectivenessUp:continuePlayEffect()
    local addNumbers = tonumber(_ED.user_info.fighter_capacity) - tonumber(_ED.last_fight_number)
    local desplacement = 0
    if addNumbers > 0 then
        desplacement = 20
    else
        desplacement = -20
    end

    if desplacement * self.Displacement < 0 then
        local root = self.roots[1]
        self:removeChild(root)
        self.roots = {}

        if addNumbers > 0 then
            csbItem = csb.createNode(config_csb.utils.fight_up)
        else
            csbItem = csb.createNode(config_csb.utils.fight_down)
        end
        self:addChild(csbItem)
        local root = nrFindRoot(csbItem) or csbItem
    if not root then return end
        table.insert(self.roots, root)
    end
    self.Displacement = desplacement

    self:onUpdateDraw()
end

function CombatEffectivenessUp:onUpdateDraw()
    local root = self.roots[1]
    root:setPositionY(self._root_posY)
    local addNumbers = 0
    if __lua_project_id == __lua_project_red_alert_time
        or __lua_project_id == __lua_project_pacific_rim
        then
        self.BitmapFontLabel_fight = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_fight_n")
        addNumbers = tonumber(_ED.user_info.fighter_capacity) - tonumber(_ED.last_fight_number)
    else
        self.BitmapFontLabel_fight = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_fight")
        addNumbers = tonumber(_ED.user_info.fight_capacity) - tonumber(_ED.last_fight_number)
    end
    if addNumbers == 0 then
        state_machine.excute("combat_effectiveness_up_on_close", 0, "")
    end
    self.addNumbers = addNumbers
    self.BitmapFontLabel_fight:setString(tonumber(_ED.last_fight_number))
    -- local addNumbers = tonumber(_ED.user_info.fighter_capacity) - tonumber(_ED.last_fight_number)
    local Text_fight_up = ccui.Helper:seekWidgetByName(root,"Text_fight_up")
    Text_fight_up:setString("")
    -- print("======addNumbers=====",addNumbers,_ED.last_fight_number)
    for i = 1 , 9 do
        local one_add_number = math.floor(addNumbers / 9 *(i-1))
        -- print("======one_add_number=====",one_add_number)
        table.insert(self._now_show_numbers,one_add_number)
    end
    root:setVisible(false)
    
    function blinkOutCallback(sender)
        root:setVisible(true)
    end
    
    function blinkOutCallback1(sender)
        self.isJumpDigital = true
        if addNumbers > 0 then
            Text_fight_up:setString("+"..addNumbers)
        else
            Text_fight_up:setString(addNumbers)
        end
        
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            local Image_fight_t = ccui.Helper:seekWidgetByName(root,"Image_fight_t")
            if Image_fight_t._y == nil then
                Image_fight_t._y = Image_fight_t:getPositionY()
            end
            local BitmapFontLabel_fight = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_fight")
            if BitmapFontLabel_fight._y == nil then
                BitmapFontLabel_fight._y = BitmapFontLabel_fight:getPositionY()
            end
            Image_fight_t:setPositionY(Image_fight_t._y-21)
            BitmapFontLabel_fight:setPositionY(BitmapFontLabel_fight._y-21)
            root:setVisible(true)
            local onesSprint1 = cc.Spawn:create(cc.MoveTo:create(0.17, cc.p(Image_fight_t:getPositionX(), Image_fight_t._y+42)),cc.FadeTo:create(0.17, 255),cc.ScaleTo:create(0.17, 1,2))
            local onesSprint2 = cc.Spawn:create(cc.MoveTo:create(0.17, cc.p(Image_fight_t:getPositionX(), Image_fight_t._y)),cc.ScaleTo:create(0.17, 1,1))
            local twoSprint1 = cc.Spawn:create(cc.MoveTo:create(0.17, cc.p(BitmapFontLabel_fight:getPositionX(), BitmapFontLabel_fight._y+42)),cc.FadeTo:create(0.17, 255),cc.ScaleTo:create(0.17, 1,2))
            local twoSprint2 = cc.Spawn:create(cc.MoveTo:create(0.17, cc.p(BitmapFontLabel_fight:getPositionX(), BitmapFontLabel_fight._y)),cc.ScaleTo:create(0.17, 1,1))
            BitmapFontLabel_fight:runAction(cc.Sequence:create(
                            cc.FadeTo:create(0, 0),
                            twoSprint1,
                            twoSprint2,
                            cc.DelayTime:create(1.19),
                            cc.FadeTo:create(0.235, 255)
                            ))
            Image_fight_t:runAction(cc.Sequence:create(
                            cc.FadeTo:create(0, 0),
                            onesSprint1,
                            onesSprint2,
                            cc.DelayTime:create(1.19),
                            cc.FadeTo:create(0.235, 255)
                            ))

            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital then
                local jsonFile = "sprite/effice_fight_up_light0.json"
                local atlasFile = "sprite/effice_fight_up_light0.atlas"

                local Panel_fight_light = ccui.Helper:seekWidgetByName(root,"Panel_fight_light")
                if Panel_fight_light ~= nil then
                    if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
                        Panel_fight_light:removeAllChildren(true)

                        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", true, nil)
                        animation:setPosition(cc.p(Panel_fight_light:getContentSize().width/2, Panel_fight_light:getContentSize().height/2))
                        Panel_fight_light:addChild(animation)
                    end
                end
            end
        else
            if self.bitmapFont ~= nil then
                local ArmatureNode_fight_light = root:getChildByName("ArmatureNode_fight_light")
                local animation = ArmatureNode_fight_light:getAnimation()
                animation:playWithIndex(0, 0, 0)
            else
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_fight_up_light/effice_fight_up_light.ExportJson")
                local armature2 = ccs.Armature:create("effice_fight_up_light")
                armature2:setPositionY(self.BitmapFontLabel_fight:getContentSize().height/2)
                armature2:getAnimation():playWithIndex(0)
                self.BitmapFontLabel_fight:addChild(armature2,-100)
            end
        end
    end
    if __lua_project_id == __lua_project_red_alert_time
        or __lua_project_id == __lua_project_pacific_rim
        then
        _ED.last_fight_number = _ED.user_info.fighter_capacity
        self._current_fight_number = _ED.user_info.fighter_capacity
    else
        _ED.last_fight_number = _ED.user_info.fight_capacity
        self._current_fight_number = _ED.user_info.fight_capacity
    end
    
    local twoSprint = cc.Spawn:create(cc.MoveTo:create(0.5, cc.p(root:getPositionX(), root:getPositionY()+self.Displacement)),cc.FadeTo:create(0.5, 255))
    if self.bitmapFont ~= nil then
        root:runAction(cc.Sequence:create(
                        -- cc.DelayTime:create(1),
                        -- cc.FadeTo:create(0, 0),
                        cc.CallFunc:create(blinkOutCallback),
                        -- twoSprint,
                        cc.CallFunc:create(blinkOutCallback1)
                        ))
    else
        root:runAction(cc.Sequence:create(
                        -- cc.DelayTime:create(1),
                        cc.FadeTo:create(0, 0),
                        cc.CallFunc:create(blinkOutCallback),
                        twoSprint,
                        cc.CallFunc:create(blinkOutCallback1)
                        ))
    end
end

function CombatEffectivenessUp:init(params)
	self:onInit(params)
    return self
end

function CombatEffectivenessUp:onInit(params)
    local csbItem = nil
	local addNumbers = 0
    if __lua_project_id == __lua_project_red_alert_time
        or __lua_project_id == __lua_project_pacific_rim
        then
        addNumbers = tonumber(_ED.user_info.fighter_capacity) - tonumber(_ED.last_fight_number)
    	if addNumbers > 0 then
    		csbItem = csb.createNode(config_csb.utils.fight_up)
    	else
    		csbItem = csb.createNode(config_csb.utils.fight_down)
    	end
    else
        addNumbers = tonumber(_ED.user_info.fight_capacity) - tonumber(_ED.last_fight_number)
        -- res/configs/csb/config.lua is not loaded in normal play: use the original layout path.
        csbItem = csb.createNode((config_csb and config_csb.utils and config_csb.utils.fight_up) or "utils/fight_up.csb")
    end
    if not csbItem or not nrFindRoot(csbItem) then
        -- Recovered packs can lack the original power-toast layout.
        -- A short, non-interactive label preserves feedback without a broken window.
        -- fight_up.csb does not load in this engine: rebuild the original
        -- look from the same assets ("Power" picture, fnt_fight_up digits,
        -- green zd_xue_jia gain). Plain text only if those assets fail too.
        -- Original timing: pop in, digits count up from the old power to the
        -- new one with the +gain beside the total, hold, then blink and fade
        -- out in steps while rising.
        local from=tonumber(_ED.last_fight_number) or 0
        local to=tonumber(_ED.user_info.fight_capacity) or 0
        local gain=(addNumbers>=0 and "+" or "")..tostring(addNumbers)
        local box=cc.Node:create()
        local title=cc.Sprite:create("images/ui/text/text_fight.png")
        local number=ccui.TextBMFont and ccui.TextBMFont:create(tostring(from), "fonts/fnt_fight_up.fnt")
        local plus=ccui.TextBMFont and ccui.TextBMFont:create(gain, "fonts/zd_xue_jia.fnt")
        if title and number and plus then
            title:setAnchorPoint(cc.p(0, 0)); title:setPosition(cc.p(-150, 30))
            number:setAnchorPoint(cc.p(0, 0.5)); number:setPosition(cc.p(-160, 0))
            plus:setAnchorPoint(cc.p(0, 0.5))
            box:addChild(title); box:addChild(number); box:addChild(plus)
            local function placePlus() plus:setPosition(cc.p(-160 + number:getContentSize().width + 10, 0)) end
            placePlus()
            plus:setOpacity(0)
            self._hostPowerToastTime=3.0
            self._hostCount={number=number, from=from, to=to, t=0, dur=0.7, place=placePlus}
            plus:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.FadeIn:create(0.15),
                cc.ScaleTo:create(0.1, 1.3), cc.ScaleTo:create(0.1, 1)))
            box:setCascadeOpacityEnabled(true)
            box:setScale(0.1)
            box:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.12, 1.15), cc.ScaleTo:create(0.08, 1),
                cc.DelayTime:create(1.6),
                cc.FadeTo:create(0.1, 80), cc.FadeTo:create(0.1, 255),
                cc.FadeTo:create(0.1, 80), cc.FadeTo:create(0.1, 255),
                cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(0, 20)), cc.FadeOut:create(0.5))))
        else
            self._hostPowerToastTime=1.6
            box:addChild(ccui.Text:create(require("desktop_layout").translate("Power")..": "..tostring(_ED.user_info.fight_capacity).." ("..gain..")", "Arial", 26))
        end
        box:setPosition(cc.p(480,380))
        self:addChild(box)
        return
    end
    self:addChild(csbItem)
    local root = nrFindRoot(csbItem) or csbItem
    if not root then return end
    table.insert(self.roots, root)
	if addNumbers > 0 then
		self.Displacement = 20
	else
		self.Displacement = -20
	end

    self._root_posY = root:getPositionY()
	
	-- root:setPositionY(root:getPositionY()+self.Displacement*2)
	-- root:setPositionX(root:getPositionX()+displacement_x)
    local BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_1")
    if BitmapFontLabel_1 ~= nil then
        self.bitmapFont = BitmapFontLabel_1
    end
    self:onUpdateDraw()
    
end

function CombatEffectivenessUp:playNumberAction( str )
	local root = self.roots[1]
	if str == 2 then
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[8]))
	elseif str == 4 then  
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[7]))
	elseif str == 6 then     
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[6]))
	elseif str == 8 then   
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[5]))
	elseif str == 10 then   
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[4]))
	elseif str == 12 then  
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[3]))
	elseif str == 14 then   
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[2]))
	elseif str == 16 then    
		self.BitmapFontLabel_fight:setString(tonumber(self._current_fight_number) - tonumber(self._now_show_numbers[1]))
	elseif str == 18 then  
		self.BitmapFontLabel_fight:setString(self._current_fight_number)
		-- state_machine.excute("combat_effectiveness_up_window_close",0,"")
		-- _ED.last_fight_number = _ED.user_info.fighter_capacity
		self.isJumpDigital = false
        if self.bitmapFont ~= nil then
            function Len_Reverse( num )
                -- body
                local s = string.format('%s',num)
                return s:len()
            end   
            local fontWidth = 26
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    fontWidth = 26
                else
                    fontWidth = 36
                end
            end
            self.bitmapFont:setPositionX(self.BitmapFontLabel_fight:getPositionX()+Len_Reverse(tonumber(_ED.user_info.fight_capacity))*fontWidth+10)
            self.bitmapFont:setOpacity(0)
            self.bitmapFont:setString("+"..self.addNumbers)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                if self.bitmapFont._y == nil then
                    self.bitmapFont._y = self.bitmapFont:getPositionY()
                end
                self.bitmapFont:setPositionY(self.bitmapFont._y-19)
                local FontSprint1 = cc.Spawn:create(cc.MoveTo:create(1.78, cc.p(self.bitmapFont:getPositionX(), self.bitmapFont._y+12)),cc.FadeTo:create(0.17, 255))
                self.bitmapFont:runAction(cc.Sequence:create(
                        FontSprint1,
                        cc.FadeTo:create(0.235, 255)
                        ))
            else
                self.bitmapFont:runAction(cc.Sequence:create(
                        cc.FadeTo:create(0.5, 255),
                        cc.FadeTo:create(0.1, 0),
                        cc.FadeTo:create(0.1, 255),
                        cc.FadeTo:create(0.1, 0),
                        cc.FadeTo:create(0.1, 255),
                        cc.FadeTo:create(0.5, 0)
                        ))
            end
        end
		function blinkOutCallback1(sender)
			state_machine.excute("combat_effectiveness_up_on_close",0,"")
		end
		
        if self.bitmapFont ~= nil then
            root:runAction(cc.Sequence:create(
                cc.DelayTime:create(1.53),
                cc.CallFunc:create(blinkOutCallback1)
                ))
        else
            root:runAction(cc.Sequence:create(
                cc.DelayTime:create(1.53),
                cc.Spawn:create(cc.MoveTo:create(0.5, cc.p(root:getPositionX(), root:getPositionY()+self.Displacement)),cc.FadeTo:create(0.5, 0)),
                cc.CallFunc:create(blinkOutCallback1)
                ))
        end
	end
end
	
function CombatEffectivenessUp:onUpdate(dt)
    if self._hostPowerToastTime then
        self._hostPowerToastTime=self._hostPowerToastTime-dt
        local c=self._hostCount
        if c and c.t<c.dur then
            c.t=math.min(c.dur,c.t+dt)
            if not tolua.isnull(c.number) then
                c.number:setString(tostring(math.floor(c.from+(c.to-c.from)*c.t/c.dur+0.5)))
                c.place()
            end
        end
        if self._hostPowerToastTime<=0 then
            _ED.last_fight_number=_ED.user_info.fight_capacity
            state_machine.excute("combat_effectiveness_up_window_close",0,"")
        end
        return
    end
	if self.isJumpDigital == true then
		self.number = self.number + 1
		if self.number <= 20 then
			self:playNumberAction(self.number)
		end
	end
end

function CombatEffectivenessUp:onExit()
    state_machine.remove("combat_effectiveness_up_continue_play")
    state_machine.remove("combat_effectiveness_up_on_close")
end
