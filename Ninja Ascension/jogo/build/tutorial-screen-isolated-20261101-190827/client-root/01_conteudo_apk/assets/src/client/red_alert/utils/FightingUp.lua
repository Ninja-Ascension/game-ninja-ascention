-----------------------------
--战力提升
-----------------------------
FightingUp = class("FightingUpClass", Window)

local fighting_up_window_open_terminal = {
    _name = "fighting_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("fighting_up_window_close",0,"")
        -- 战力提升动画资源加载
        for i, v in pairs(config_res.sprites_cached["fighting"]) do
            cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
        end
        if nil == fwin:find("FightingUpClass") then
            fwin:open(FightingUp:new():init(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local fighting_up_window_close_terminal = {
    _name = "fighting_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FightingUpClass"))
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fighting_up_window_open_terminal)
state_machine.add(fighting_up_window_close_terminal)
state_machine.init()

function FightingUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var 
    self._now_show_numbers = {}
end

function FightingUp:onEnterTransitionFinish()

end

function FightingUp:onUpdateDraw()
    local root = self.roots[1]
end

function FightingUp:init(params)
	self:onInit(params)
    return self
end

function FightingUp:onInit(params)
    local csbItem = csb.createNode(config_csb.utils.fighting_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.utils.fighting_up) 
    table.insert(self.actions, action )
    csbItem:runAction(action)

    local BitmapFontLabel_fight = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_fight")
    BitmapFontLabel_fight:setString(_ED.last_fight_number)
    local addNumbers = tonumber(_ED.user_info.fighter_capacity) - tonumber(_ED.last_fight_number)
    -- print("======addNumbers=====",addNumbers,_ED.last_fight_number)
    for i = 1 , 9 do
        local one_add_number = math.floor(addNumbers / 9 *(i-1))
        -- print("======one_add_number=====",one_add_number)
        table.insert(self._now_show_numbers,one_add_number)
    end

    local function playNumberAction( _self )
        -- action:setTimeSpeed(app.getTimeSpeed())
        _self.actions[1]:play("anim_fight",false)
        _self.actions[1]:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end
            
            local str = frame:getEvent()
            if str == "text_up_1" then
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[8])
            elseif str == "text_up_2" then  
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[7])
            elseif str == "text_up_3" then     
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[6])
            elseif str == "text_up_4" then   
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[5])
            elseif str == "text_up_5" then   
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[4])
            elseif str == "text_up_6" then  
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[3])
            elseif str == "text_up_7" then   
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[2])
            elseif str == "text_up_8" then    
                BitmapFontLabel_fight:setString(tonumber(_ED.user_info.fighter_capacity) - self._now_show_numbers[1])
            elseif str == "text_up_9" then  
                BitmapFontLabel_fight:setString(_ED.user_info.fighter_capacity)
            elseif str == "text_up_10" then  
                state_machine.excute("fighting_up_window_close",0,"")
            end
        end)
    end

    local Panel_zhanli_bg = ccui.Helper:seekWidgetByName(root,"Panel_zhanli_bg")
    local Image_fight = ccui.Helper:seekWidgetByName(root,"Image_fight")
    Panel_zhanli_bg:setVisible(false)
    Image_fight:setVisible(false)
    if params == true then
        Panel_zhanli_bg:setVisible(true)
        local ArmatureNode_zl = Panel_zhanli_bg:getChildByName("ArmatureNode_zl")
        -- local function changeActionCallback( armatureBack )
        -- end
        -- ArmatureNode_zl._invoke = changeActionCallback
        ArmatureNode_zl:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        playNumberAction(self)
        draw.initArmature(ArmatureNode_zl, nil, -1, 0, 1)
        csb.animationChangeToAction(ArmatureNode_zl, 0, 0, false)

        local sound = dms.int(dms["sound_effect_param"], 46, sound_effect_param.special_effect)
        if zstring.tonumber(sound) > 0 then
            playEffectMusic(sound)
        end
    else
        local sound = dms.int(dms["sound_effect_param"], 47, sound_effect_param.special_effect)
        if sound > 0 then
            playEffectMusic(sound)
        end
        Image_fight:setVisible(true)
        playNumberAction(self)
    end
    
-- print("===========战力提升")
    -- self:onUpdateDraw() 
end


function FightingUp:onExit()

end
