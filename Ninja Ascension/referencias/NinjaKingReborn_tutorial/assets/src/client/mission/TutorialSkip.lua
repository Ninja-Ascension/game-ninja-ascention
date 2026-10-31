









TutorialSkip = TutorialSkip or {}

local FONT = "fonts/ReggaeOne-Regular.ttf"
local CARD_NEWBIE = "images/ui/decorative/juexianshi_01.png"
local CARD_VETERAN = "images/ui/decorative/juexianshi_03.png"
local CARD_CLOUD = "images/ui/decorative/juexianshi_01_dec.png"
local ART_NEWBIE = "images/face/big_head/big_head_104001.png"
local ART_VETERAN = "images/face/big_head/big_head_104101.png"
local ART_BOX = {
    [ART_NEWBIE] = { 8, 81, 436, 500 },
    [ART_VETERAN] = { 19, 75, 456, 500 },
}
local TITLE_BAR = "images/ui/bar/bar_title_1.png"
local BTN_ORANGE = "images/ui/button/btn_1.png"
local BTN_BLUE = "images/ui/button/btn.png"
local INK = cc.c4b(70, 40, 20, 255)
local GOLD = cc.c4b(255, 215, 90, 255)

local function label(text, size, color)
    local t = ccui.Text:create(tostring(text), FONT, size)
    t:setTextColor(color or cc.c4b(255, 255, 255, 255))
    t:enableOutline(cc.c4b(30, 15, 5, 255), 2)
    return t
end

local function ink(text, size, width)
    local t = ccui.Text:create(tostring(text), FONT, size)
    t:setTextColor(INK)
    if width ~= nil then
        t:ignoreContentAdaptWithSize(false)
        t:setTextAreaSize(cc.size(width, 0))
        t:setContentSize(cc.size(width, size * 8))
        t:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        t:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
    end
    return t
end

local function userKey()
    if _ED == nil or _ED.user_info == nil then return nil end
    return "l" .. tostring(_ED.user_info.user_grade) .. "e" .. tostring(_ED.user_info.user_experience)
end


local function decided()
    return TutorialSkip.decidedFor ~= nil and TutorialSkip.decidedFor == tostring(_ED.user_info.user_id)
end



function TutorialSkip.install()
    if executeMissionExt == nil or executeMissionExt == TutorialSkip.wrapper then return end
    TutorialSkip.original = executeMissionExt
    TutorialSkip.wrapper = function(missionMould, triggerTiming, emtOffVal, executeOverCallback, canExecute, cmpOffVal, executeRepeatEvent)
        local args = { missionMould, triggerTiming, emtOffVal, executeOverCallback, canExecute, cmpOffVal, executeRepeatEvent }
        if missionMould == mission_mould_tuition and cmpOffVal == "l1e0" and userKey() == "l1e0"
            and TutorialSkip.missionOver() and not decided() then
            TutorialSkip.pending = args
            TutorialSkip.openWhenLoaded()
            return true
        end
        return TutorialSkip.original(unpack(args, 1, 7))
    end
    executeMissionExt = TutorialSkip.wrapper


    if missionIsOver ~= TutorialSkip.overWrapper then
        TutorialSkip.originalOver = missionIsOver
        TutorialSkip.overWrapper = function()
            if TutorialSkip.busy or fwin:find("TutorialSkipWindowClass") ~= nil then return false end
            return TutorialSkip.originalOver()
        end
        missionIsOver = TutorialSkip.overWrapper
    end
end

function TutorialSkip.missionOver()
    return (TutorialSkip.originalOver or missionIsOver)() == true
end



function TutorialSkip.openWhenLoaded()
    if TutorialSkip.busy or fwin:find("TutorialSkipWindowClass") ~= nil then return end
    fwin:open(TutorialSkipWindow:new():init(), fwin._screen)
end


function TutorialSkip.newbie()
    TutorialSkip.decidedFor = tostring(_ED.user_info.user_id)
    local w = fwin:find("TutorialSkipWindowClass")
    if w ~= nil then fwin:close(w) end
    local args = TutorialSkip.pending
    TutorialSkip.pending = nil
    if args ~= nil then TutorialSkip.original(unpack(args, 1, 7)) end
end



local function postersAgain()
    local banner = state_machine.find("menu_window_login_popup_banner")
    if banner ~= nil then banner.isOpend = nil end
    _ED.login_popup_banner = nil
    state_machine.excute("menu_window_login_popup_banner", 0, true)
end




function TutorialSkip.postersAfterTutorial()
    local me = (_ED.user_info ~= nil) and tostring(_ED.user_info.user_id) or ""
    if TutorialSkip.postersFor == me then return end
    TutorialSkip.postersFor = me
    TutorialSkip.waitForHome()
end

function TutorialSkip.waitForHome()
    local tries = 0
    local function check()
        tries = tries + 1

        if fwin:find("MenuClass") ~= nil and fwin:find("LoginLoadingClass") == nil and missionIsOver() == true
            and fwin:find("ActivityRichFirstRechargeClass") == nil and tries > 2 then
            postersAgain()
            return
        end
        if tries < 1200 then
            fwin:addService({ callback = check, delay = 0.5, params = nil })
        end
    end
    fwin:addService({ callback = check, delay = 0.5, params = nil })
end


local function loginAgain()
    local server = _ED.all_servers[_ED.selected_server]
    NetworkManager:register(protocol_command.login_init.code, server.server_link, nil, nil, nil, function(response)
        TutorialSkip.busy = false
        if not (response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0) then return end
        fwin:close(fwin:find("ConnectingViewClass"))
        cacher.removeAllObject()
        NetworkManager:registerUrl(server.server_link, nil, server.server_link_rf)
        fwin:removeAll()
        app.load("client.home.Menu")
        app.load("client.utils.texture_cache")
        cacher.removeAllTextures()
        resetMission()
        app.load("client.login.LoginLoading")
        fwin:open(LoginLoading:new():init(), fwin._screen)
        NetworkManager:register(protocol_command.user_create_time.code, nil, nil, nil, nil, nil, false, nil)


    end, false, nil)
end


function TutorialSkip.veteran()
    if TutorialSkip.busy then return end
    TutorialSkip.busy = true
    NetworkManager:register(protocol_command.tutorial_skip.code, nil, nil, nil, nil, function(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TutorialSkip.decidedFor = tostring(_ED.user_info.user_id)
            TutorialSkip.pending = nil
            local w = fwin:find("TutorialSkipWindowClass")
            if w ~= nil then fwin:close(w) end
            loginAgain()
        else
            TutorialSkip.busy = false
        end
    end, false, nil)
end


TutorialSkipWindow = class("TutorialSkipWindowClass", Window)

function TutorialSkipWindow:ctor()
    self.super:ctor()
end

function TutorialSkipWindow:init()
    return self
end

function TutorialSkipWindow:onEnterTransitionFinish()
    local dir = cc.Director:getInstance()
    local vo, vs = dir:getVisibleOrigin(), dir:getVisibleSize()
    local bl = self:convertToNodeSpace(cc.p(vo.x, vo.y))
    local tr = self:convertToNodeSpace(cc.p(vo.x + vs.width, vo.y + vs.height))
    local W, H = tr.x - bl.x, tr.y - bl.y
    local root = ccui.Layout:create()
    root:setContentSize(cc.size(W, H))
    root:setPosition(bl)
    root:setTouchEnabled(true)
    root:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    root:setBackGroundColor(cc.c3b(0, 0, 0))
    root:setBackGroundColorOpacity(255)
    self:addChild(root)
    self.root = root
    local bg = cc.Sprite:create("images/ui/text/TF_res/combination_card/combination_card_bg_2.png")
    if bg ~= nil then
        local s = bg:getContentSize()
        bg:setScale(math.max(W / s.width, H / s.height))
        bg:setPosition(cc.p(W / 2, H / 2))
        bg:setColor(cc.c3b(150, 150, 150))
        root:addChild(bg)
    end


    local bar = ccui.ImageView:create(TITLE_BAR)
    bar:setScale9Enabled(true)
    bar:setContentSize(cc.size(math.min(W * 0.6, 620), 64))
    bar:setPosition(cc.p(W / 2, H - 52))
    root:addChild(bar, 2)
    local title = label("Welcome to Ninja King: Reborn!", 32, GOLD)
    title:enableOutline(cc.c4b(60, 20, 0, 255), 3)
    title:setPosition(cc.p(W / 2, H - 50))
    root:addChild(title, 3)
    local sub = label("Before your journey begins, tell us what kind of ninja you are.", 20)
    sub:setPosition(cc.p(W / 2, H - 100))
    root:addChild(sub, 3)

    local cardH = math.min(H - 210, 420)
    local scale = cardH / 508
    local gap = W * 0.08
    local cw = 300 * scale
    self:card(W / 2 - gap / 2 - cw / 2, (H - 120) / 2 + 22, scale, CARD_NEWBIE, ART_NEWBIE, "NEWBIE",
        "New to the ninja world?\nPlay the tutorial and learn every step of the game.",
        BTN_ORANGE, "Play Tutorial", function() TutorialSkip.newbie() end)
    self:card(W / 2 + gap / 2 + cw / 2, (H - 120) / 2 + 22, scale, CARD_VETERAN, ART_VETERAN, "VETERAN",
        "Know the way of the ninja?\nSkip the tutorial and get the SAME rewards.",
        BTN_BLUE, "Skip Tutorial", function() self:confirmSkip() end)
end


function TutorialSkipWindow:card(x, y, scale, frame, art, name, note, btnImage, btnTitle, onTap)
    local holder = cc.Node:create()
    holder:setPosition(cc.p(x, y))
    holder:setScale(scale)
    self.root:addChild(holder, 2)



    local f = cc.Sprite:create(frame)
    f:setPosition(cc.p(-42, 0))
    holder:addChild(f, 0)
    local px1, px2, py1, py2 = -140, 140, -247, 224
    local stencil = cc.DrawNode:create()
    stencil:drawSolidRect(cc.p(px1, py1), cc.p(px2, py2), cc.c4f(1, 1, 1, 1))
    local clip = cc.ClippingNode:create(stencil)
    holder:addChild(clip, 1)
    local a = cc.Sprite:create(art)
    if a ~= nil then

        local box = ART_BOX[art] or { 0, 0, a:getContentSize().width, a:getContentSize().height }
        local s = a:getContentSize()
        local areaBottom, areaTop = py1 + 140, py2
        local k = math.max((px2 - px1) / (box[3] - box[1]), (areaTop - areaBottom) / (box[4] - box[2]))
        a:setScale(k)
        a:setAnchorPoint(cc.p((box[1] + box[3]) / 2 / s.width, (s.height - box[4]) / s.height))
        a:setPosition(cc.p((px1 + px2) / 2, areaBottom))
        clip:addChild(a)
    end

    local plate = cc.DrawNode:create()
    plate:drawSolidRect(cc.p(px1, py1), cc.p(px2, py1 + 158), cc.c4f(0.93, 0.88, 0.76, 0.96))
    holder:addChild(plate, 2)
    local cloud = cc.Sprite:create(CARD_CLOUD)
    cloud:setPosition(cc.p((px1 + px2) / 2, py1 + 170))
    holder:addChild(cloud, 3)
    local n = label(name, 36, GOLD)
    n:enableOutline(cc.c4b(90, 30, 0, 255), 3)
    n:setPosition(cc.p((px1 + px2) / 2, py1 + 122))
    holder:addChild(n, 4)
    local t = ink(note, 15, px2 - px1 - 22)
    t:setAnchorPoint(cc.p(0.5, 1))
    t:setPosition(cc.p((px1 + px2) / 2, py1 + 96))
    holder:addChild(t, 4)

    local b = ccui.Button:create(btnImage)
    b:setScale9Enabled(true)
    b:setContentSize(cc.size(200, 58))
    b:setTitleFontName(FONT)
    b:setTitleFontSize(22)
    b:setTitleText(btnTitle)
    b:setPosition(cc.p(0, -254 - 40))
    b:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then onTap() end
    end)
    holder:addChild(b, 5)

    holder:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.ScaleTo:create(1.2, scale * 1.015), cc.ScaleTo:create(1.2, scale))))
end


function TutorialSkipWindow:confirmSkip()
    if self.confirm ~= nil then return end
    local W, H = self.root:getContentSize().width, self.root:getContentSize().height
    local o = ccui.Layout:create()
    o:setContentSize(cc.size(W, H))
    o:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    o:setBackGroundColor(cc.c3b(0, 0, 0))
    o:setBackGroundColorOpacity(170)
    o:setTouchEnabled(true)
    self.root:addChild(o, 50)
    self.confirm = o
    local w, h = 560, 280
    local panel = ccui.ImageView:create("images/ui/edit_box/lipinma_paper.png")
    panel:setScale9Enabled(true)
    panel:setContentSize(cc.size(w, h))
    panel:setPosition(cc.p(W / 2, H / 2))
    o:addChild(panel)
    local title = label("SKIP THE TUTORIAL?", 30, GOLD)
    title:enableOutline(cc.c4b(90, 30, 0, 255), 3)
    title:setPosition(cc.p(w / 2, h - 46))
    panel:addChild(title)
    local msg = ink("You will receive every tutorial reward and start right after stage 2-2.", 18, w - 80)
    msg:setAnchorPoint(cc.p(0.5, 1))
    msg:setPosition(cc.p(w / 2, h - 86))
    panel:addChild(msg)
    local function btn(image, text, x, onTap)
        local b = ccui.Button:create(image)
        b:setScale9Enabled(true)
        b:setContentSize(cc.size(190, 58))
        b:setTitleFontName(FONT)
        b:setTitleFontSize(22)
        b:setTitleText(text)
        b:setPosition(cc.p(x, 56))
        b:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then onTap() end
        end)
        panel:addChild(b)
    end
    btn("images/ui/button/btn_2.png", "Cancel", w / 2 - 115, function()
        o:removeFromParent()
        self.confirm = nil
    end)
    btn(BTN_BLUE, "Skip", w / 2 + 115, function() TutorialSkip.veteran() end)
end

function TutorialSkipWindow:onExit()
end
