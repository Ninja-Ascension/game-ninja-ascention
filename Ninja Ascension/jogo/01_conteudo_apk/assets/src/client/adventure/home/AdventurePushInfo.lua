-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险场景跑马灯
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

AdventurePushInfo = class("AdventurePushInfoClass", Window)
AdventurePushInfo._openTime = nil --打开时间
AdventurePushInfo._playingTime = 1600 -- 秒为单位
local adventure_push_info_open_terminal = {
    _name = "adventure_push_info_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params == -1 then 
            --当前场景中播放完了系统推送后再次打开场景跑马灯
            local currentTime = os.time()
            if AdventurePushInfo._openTime == nil then 
                AdventurePushInfo._openTime = os.time()
                --print("!!!!!!!!!!!!!!!!!!!!到这里来了就危险了")
            end
            if currentTime - AdventurePushInfo._openTime < AdventurePushInfo._playingTime then 
                --还没超过轮播时间 --继续播放
                local pushWindow = fwin:find("AdventurePushInfoClass")
                if pushWindow ~= nil then 
                    pushWindow:onUpdateDraw(tonumber(terminal._openPushSceneId))
                else 
                    fwin:open(AdventurePushInfo:new():init(tonumber(terminal._openPushSceneId)), fwin._taskbar)
                end
            else
                return true
            end
        else
            AdventurePushInfo._openTime = os.time()
            terminal._openPushSceneId = params
            local pushWindow = fwin:find("AdventurePushInfoClass")
            if pushWindow ~= nil then 
                pushWindow:onUpdateDraw(tonumber(params))
            else 
                fwin:open(AdventurePushInfo:new():init(tonumber(params)), fwin._taskbar)
            end
        end
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_push_info_close_terminal = {
    _name = "adventure_push_info_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("AdventurePushInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_push_info_open_terminal)
state_machine.add(adventure_push_info_close_terminal)
state_machine.init()

function AdventurePushInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.str = nil
    self.playIndex = 1
    self.actions = nil
    self.playerMaxCount = 1
    self._headLayer = nil
    self.sceneId = nil
    self.fontName = nil
    -- Initialize PushInfo page state machine.
    local function init_pushInfo_terminal()
        local push_info_Adventure_update_draw_terminal = {
                _name = "push_info_Adventure_update_draw",
                _init = function (terminal) 
                    
                end,
                _inited = false,
                _instance = self,
                _state = 0,
                _invoke = function(terminal, instance, params)
                    instance:onUpdateDraw(tonumber(params))
                    return true
                end,
                _terminal = nil,
                _terminals = nil
            }
        state_machine.add(push_info_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_pushInfo_terminal()
end

function AdventurePushInfo:cutStringMain(str, height, fontSize, width)
    local mRoot = ccui.RichText:create()
    fontSize = fontSize or 10
    local l = string.len(self.str)
    mRoot:ignoreContentAdaptWithSize(false)
    local count = 0
    while (l > 0) do
        local f,e = string.find(self.str, "%%%C-%%")
        if f == nil or e == nil then
            local re = nil
            re = ccui.RichElementText:create(1, cc.c3b(199, 171, 120), 255, self.str, self.fontName, fontSize)
            mRoot:pushBackElement(re)
            count = count + zstring.utfstrlen(self.str)
            break
        end
        if f > 1 then
            local strsub = string.sub(self.str, 1, f-1)
            count = count + zstring.utfstrlen(strsub)
            local re = nil
            re = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, strsub, self.fontName, fontSize)
       
            mRoot:pushBackElement(re)
        end
        local name = string.sub(self.str, f+1, e-1)
        local f1, e1 = string.find(name, "%d+")
        if name == nil or f1 == nil or e1 == nil then
            mRoot:removeAllChildrenWithCleanup(true)
            break
        end
        local quality = string.sub(name, f1, e1)
        local color = tonumber(quality) + 1
        name = string.sub(name, e1+2, string.len(name))
        count = count + zstring.utfstrlen(name)
        if color == nil or color <= 0 or color > 11 then
            mRoot:removeAllChildrenWithCleanup(true)
            break
        end
        local re1 = nil
        re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[color][1],color_Type[color][2],color_Type[color][3]), 255, name, self.fontName, fontSize)
       
        mRoot:pushBackElement(re1)
        self.str = string.sub(self.str, e+1, l)
        l = string.len(self.str)
    end
    if width ~= nil and width > 0 then
        mRoot:setContentSize(cc.size(width+15, height+20))
    else
        mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
    end
    return mRoot, count
end

function AdventurePushInfo:onUpdateDraw(sceneId)
    if sceneId == nil then 
        return
    end
    local root = self.roots[1]
    local array = {}
    
    local fontSize = 20/CC_CONTENT_SCALE_FACTOR()
    local content = "" --"我靠阿拉打瞌睡的房价阿斯利康的房价|撒打发斯蒂芬撒地方家科技的 就浪费就|阿萨德飞洒地方撒地方撒地方撒地方商店|阿斯顿发送到多少递胜递负"
    
    local mould_date = dms.element(dms["scene_local_push"], tonumber(sceneId))

    if mould_date ~= nil then 
       content = dms.atos(mould_date, scene_local_push.push_content)
    else 
       
        return 
    end
    if content == nil or content == "" then 
        return
    end
    local strArr = zstring.split(content, "|")
    self.playIndex = 1
    self.playerMaxCount = 1
    self.actions = {}
    local isPlayServer = false
    self._headLayer:removeAllChildren(true)
    if zstring.tonumber(sceneId) == 1 then 
        for i, v in pairs(_ED.send_information) do
            self.str = v.information_content
            if zstring.tonumber(v.information_type) == 0 then 
                local _rootm = self._headLayer:getContentSize()
                local _richText, l = self:cutStringMain(self.str, _rootm.height, fontSize)
                local _pos = cc.p(_richText:getPositionX() - _rootm.width, _richText:getPositionY())
                local action  = cc.MoveTo:create(17, _pos)
                action:retain()
                table.insert(self.actions, action)
                self.playerMaxCount = self.playerMaxCount + 1
                _richText:setName("push1")
                self._headLayer:addChild(_richText, -1)
                local anchor = _richText:getAnchorPoint()
                local currentPos = cc.p((l*fontSize+_rootm.width)*anchor.x+500, -_rootm.height*anchor.y/2+10)
                _richText:setPosition(currentPos)
                isPlayServer = true
                
                table.remove(_ED.send_information, i)
                break
            end
        end
    end
    
    if strArr == nil then 
        return
    end
    for i, v in pairs(strArr) do
        self.str = v
        --print("--测试..AdventurePushInfo2..",i)
        local _rootm = self._headLayer:getContentSize()
        local _richText, l = self:cutStringMain(self.str, _rootm.height, fontSize)
        
        local _pos = cc.p(_richText:getPositionX() - _rootm.width, _richText:getPositionY())
        local action  = cc.MoveTo:create(17, _pos)
        action:retain()

        table.insert(self.actions, action)
        self.playerMaxCount = self.playerMaxCount + 1
        if isPlayServer == true then 
            _richText:setName("push".. self.playIndex +i)
        else    
            _richText:setName("push".. self.playIndex)
        end
        
        self._headLayer:addChild(_richText, -1)
        local anchor = _richText:getAnchorPoint()
        local currentPos = cc.p((l*fontSize+_rootm.width)*anchor.x+500, -_rootm.height*anchor.y/2+10)
        _richText:setPosition(currentPos)   
        
    end

    local function playOver()

        self.playIndex = self.playIndex + 1
        
        local currentTime = os.time()
        if currentTime - AdventurePushInfo._openTime > AdventurePushInfo._playingTime then 
            --已经过了轮播时间 -- 需要关闭
            state_machine.excute("adventure_push_info_close",0,0)
            return 
        end
    
        if self.playIndex < self.playerMaxCount then 
            local child = self._headLayer :getChildByName("push"..self.playIndex)
            if child ~= nil then
                child:runAction( cc.Sequence:create(self.actions[self.playIndex],cc.CallFunc:create(playOver)))  
            else
                state_machine.excute("adventure_push_info_close",0,0)
            end
        else 
            --结束了继续
            self:onUpdateDraw(self.sceneId)
        end
    end
    if #strArr > 0 or isPlayServer == true then
        local child = self._headLayer :getChildByName("push"..self.playIndex)
        if child ~= nil then
            child:runAction( cc.Sequence:create(self.actions[self.playIndex],cc.CallFunc:create(playOver)))  
        end
    end
end

function AdventurePushInfo:onEnterTransitionFinish()
    local csbPushInfo = csb.createNode("home/home_notice.csb")
    local root = csbPushInfo:getChildByName("root")
    table.insert(self.roots, root)
    self._headLayer = ccui.Helper:seekWidgetByName(root, "ImageView_notice")
    if zstring.tonumber(_game_platform_version_type) == 2 then 
        self.fontName = ""
    else
        self.fontName = ccui.Helper:seekWidgetByName(root, "Label_312"):getFontName()    
    end
    
    self:onUpdateDraw(self.sceneId)
    self:addChild(csbPushInfo)
end

function AdventurePushInfo:onExit()
    state_machine.remove("push_info_Adventure_update_draw")
    if self._headLayer ~= nil then 
        local childs = self._headLayer:getChildren()
        for i, v in pairs(childs) do
            v:stopAllActions()
        end
    end
end

function AdventurePushInfo:init(sceneId)
    self.sceneId = sceneId
    return self
end

function AdventurePushInfo:createCell()
    local cell = AdventurePushInfo:new()
    cell:registerOnNodeEvent(cell)
    return cell
end