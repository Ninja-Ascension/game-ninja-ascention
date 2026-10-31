-----------------------------
--龙马合成
-----------------------------
RacecourseDragonHorseMake = class("RacecourseDragonHorseMakeClass", Window)
--打开
local racecourse_dragon_horse_make_window_open_terminal = {
    _name = "racecourse_dragon_horse_make_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("home_select_action_window_close",0,"")
        local _RacecourseWindow = fwin:find("RacecourseDragonHorseMakeClass")
        if nil == _RacecourseWindow then
            fwin:open(RacecourseDragonHorseMake:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_dragon_horse_make_window_close_terminal = {
    _name = "racecourse_dragon_horse_make_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseDragonHorseMakeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_dragon_horse_make_window_open_terminal)
state_machine.add(racecourse_dragon_horse_make_window_close_terminal)
state_machine.init()

function RacecourseDragonHorseMake:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_racecourse_dragon_horse_make_terminal()
        --合成
        local racecourse_dragon_horse_synthetic_terminal = {
            _name = "racecourse_attribute_give_up_spirit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local reward_data = getSceneReward(75)
                        state_machine.excute("racecourse_recruit_window_open",0,{reward_data})
                        state_machine.excute("racecourse_dragon_horse_make_window_close", 0, nil)
                        state_machine.excute("racecourse_update_draw", 0, nil)
                        state_machine.excute("racecourse_ride_update_draw", 0, nil)
                    end
                end
                NetworkManager:register(protocol_command.combing_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecourse_dragon_horse_synthetic_terminal)
        state_machine.init()
    end
    init_racecourse_dragon_horse_make_terminal()
end 

function RacecourseDragonHorseMake:onUpdateDraw()
    local root = self.roots[1]
    --拥有碎片/所需碎片
    local Panel_piece_number = ccui.Helper:seekWidgetByName(root,"Panel_piece_number")  --碎片层
    local x,y = Panel_piece_number:getPosition()    --获取层坐标
    --_ED.user_info.dragon_horse_patch  拥有碎片
    local max_count = dms.int(dms["horse_config"], 4, horse_config.param)   --所需碎片
    Panel_piece_number:removeAllChildren(true)
    -- 神兽碎片进度条
    local LoadingBar_2 = ccui.Helper:seekWidgetByName(root, "LoadingBar_2")   
    LoadingBar_2:setPercent((_ED.user_info.dragon_horse_patch/max_count)*100)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)  
    local re1 = nil
    local re2 = nil
    re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, _ED.user_info.dragon_horse_patch.."/" , "fonts/simhei.ttf",20)
    _richText:pushBackElement(re1)
    re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, max_count , "fonts/simhei.ttf",20)
    _richText:pushBackElement(re2)
    _richText:setAnchorPoint(0,0)
    _richText:setContentSize(cc.size(100,20))
    Panel_piece_number:addChild(_richText)
    --合成次数
    local Image_legion_treasure_time_1 = ccui.Helper:seekWidgetByName(root,"Image_legion_treasure_time_1")  --再合成多少次获得
    local Image_legion_treasure_time_2 = ccui.Helper:seekWidgetByName(root,"Image_legion_treasure_time_2")  --本次合成必得
    local BitmapFontLabel_legion_treasure_time = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_legion_treasure_time")  --次数
    Image_legion_treasure_time_1:setVisible(false)
    Image_legion_treasure_time_2:setVisible(false)
    BitmapFontLabel_legion_treasure_time:setVisible(false)
    max_count = dms.int(dms["horse_config"], 5, horse_config.param)
    if max_count - tonumber(_ED.coming_horse_value + 1) > 0 then
        Image_legion_treasure_time_1:setVisible(true)
        BitmapFontLabel_legion_treasure_time:setVisible(true)
        BitmapFontLabel_legion_treasure_time:setString(max_count - tonumber(_ED.coming_horse_value + 1))
    elseif max_count - tonumber(_ED.coming_horse_value + 1) == 0 then
        Image_legion_treasure_time_2:setVisible(true)
    end
end

-- 播放滚动动画
function RacecourseDragonHorseMake:playActions()
    local root = self.roots[1]
    local horse_data = dms.searchs(dms["horse_mould"], horse_mould.quality, 4)
    local _widget = ccui.Helper:seekWidgetByName(root, "Panel_9")
    local _widget_size = _widget:getContentSize()
    local Panel_actions = {"Panel_12345", "Panel_67890"}
    local Panel_horse = {"Panel_horse_1", "Panel_horse_2"}
    local controllerLayerSize = ccui.Helper:seekWidgetByName(_widget, "Panel_12345"):getContentSize()
    local horse_count = table.getn(horse_data)
    local current_index = math.random(1, horse_count)--随机开始
    local _index = 0
    if current_index % 2 == 0 then--第一个必须为奇数
        current_index = current_index + 1
    end
    local create_horseHead = nil
    local addActionToHorse1 = nil
    local addActionToHorse2 = nil
    local function createHorseBody(index, sender)
        local drawShips = nil
        local tPanel = nil
        local uiLayer = nil
        local curIndex =  (index - 1) % 2 + 1
        if sender ~= nil then 
            tPanel = sender
            drawShips = sender.horse_data
            uiLayer = sender._uiLayer
        else
            tPanel = ccui.Helper:seekWidgetByName(_widget, Panel_actions[curIndex])
            tPanel.horse_data = horse_data
            tPanel._uiLayer = self._uiLayer
            drawShips = tPanel.horse_data
            uiLayer = tPanel._uiLayer
        end
        local nsCount = table.getn(drawShips)
        local ship = drawShips[((index - 1) % nsCount) + 1]
        local shipId = dms.atoi(ship,horse_mould.id)   
        local _horsePanel = ccui.Helper:seekWidgetByName(_widget, Panel_horse[curIndex])
        _horsePanel:removeAllChildren(true)
        local body_icon = dms.int(dms["horse_mould"], shipId, horse_mould.body_icon)
        local baseName = "sprite/spirte_" .. body_icon
        local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        skeletonNode:registerSpineEventHandler(function (event)
        end, sp.EventType.ANIMATION_COMPLETE)
        skeletonNode:setAnimation(0, "animation", true)
        _horsePanel:addChild(skeletonNode)
        local horse_name = dms.string(dms["horse_mould"], shipId,horse_mould.horse_name)
        local Text_name_1 = ccui.Helper:seekWidgetByName(root, "Text_name_1")
        local Text_name_2 = ccui.Helper:seekWidgetByName(root, "Text_name_2")
        _index = _index+1
        if _index % 2 ~= 0 then
            local quality = dms.string(dms["horse_mould"], shipId,horse_mould.quality)
            if quality ~= nil then
                Text_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
            end
            Text_name_1:setString(horse_name)
        else
            local quality = dms.string(dms["horse_mould"], shipId,horse_mould.quality)
            if quality ~= nil then
                Text_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
            end
            Text_name_2:setString(horse_name)
        end
        return tPanel
    end
    local function createHorseFunN2(sender)
        local curr_horse2 = createHorseBody(current_index, sender)
        curr_horse2:setPosition(cc.p(_widget_size.width, curr_horse2:getPositionY()))
        addActionToHorse2(curr_horse2)
        local curr_horse1 = sender._mxb
        addActionToHorse1(curr_horse1)
        current_index = current_index + 1
        
        if current_index % 10 == 0 then
            cc.Director:getInstance():getTextureCache():removeUnusedTextures() --内存释放
        end
    end
    addActionToHorse1 = function(_headLayer, _wait)
        local array = {}
        local _pos = cc.p(_headLayer:getPositionX() - _widget_size.width, _headLayer:getPositionY())
        local actions  = cc.MoveTo:create(8, _pos)
        if _wait == true then
            table.insert(array, cc.DelayTime:create(1.0))
        end
        table.insert(array, actions)
        table.insert(array, cc.CallFunc:create(createHorseFunN2))
        local seq = cc.Sequence:create(array)
        _headLayer:runAction(seq)
        return _headLayer
    end
    addActionToHorse2 = function(_headLayer, _wait)
        local array = {}
        local _pos = cc.p(_headLayer:getPositionX() - _widget_size.width, _headLayer:getPositionY())
        local actions  = cc.MoveTo:create(8, _pos)
        if _wait == true then
            table.insert(array, cc.DelayTime:create(1))
        end
        table.insert(array, actions)
        local seq = cc.Sequence:create(array)
        _headLayer:runAction(seq)
        return _headLayer
    end
    createHorse1 = function ()
        local curr_horse1 = createHorseBody(current_index, nil)
        local curr_horse2 = createHorseBody(current_index + 1, nil)
        current_index = current_index + 2
        curr_horse1._mxb = curr_horse2
        curr_horse2._mxb = curr_horse1
        addActionToHorse1(curr_horse1, true)
        addActionToHorse2(curr_horse2, true)
        return curr_horse
    end
    
    createHorse1()
end

function RacecourseDragonHorseMake:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_legend_treasure_make)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "racecourse_dragon_horse_make_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_synthetic"), nil, 
    {
        terminal_name = "racecourse_attribute_give_up_spirit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
    self:playActions()
end


function RacecourseDragonHorseMake:init()
	self:onInit()
    return self
end

function RacecourseDragonHorseMake:onExit()
    state_machine.remove("racecourse_attribute_give_up_spirit", 0, nil)
end