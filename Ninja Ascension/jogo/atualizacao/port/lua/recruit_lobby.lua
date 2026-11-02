-- Original Naruto/Jiraiya front cards. The purchase controls remain on their
-- reverse sides and keep their existing Recruit terminals and costs.
local M={}
local function widget(root,name) return ccui.Helper:seekWidgetByName(root,name) end
function M.isInitialTutorialRecruitBlock(mission)
    if not _ED or _ED.nr_initial_tutorial~='playing' then return false end
    mission=mission or (fwin and fwin:find('TuitionControllerClass') or {})._mission
    if type(mission)~='table' or not dms or not dms.atoi then return false end
    local idIndex=rawget(_G,'mission_id')
    local eventIndex=rawget(_G,'mission_event_id')
    if not idIndex or not eventIndex then return false end
    local ok,id,event=pcall(function()
        return dms.atoi(mission,idIndex),dms.atoi(mission,eventIndex)
    end)
    return ok and id==3 and event>=4 and event<=17
end
function M.openInitialTutorialRecruit()
    -- Skip the broken first-account Recruit segment and its Sakura formation
    -- dependency. The regular Recruit screen remains available outside it.
    if M.isInitialTutorialRecruitBlock() then
        local windows=rawget(_G,'fwin')
        if windows then
            for _,name in ipairs({'NewRecruitMainClass','HeroRecruitListViewClass','HeroRecruitSuccessClass'}) do
                local open=windows:find(name)
                if open then windows:close(open) end
            end
            local controller=windows:find('TuitionControllerClass')
            if controller and controller.skipInitialRecruitSection then
                controller:skipInitialRecruitSection()
            end
        end
        return true
    end
    return false
end
local function compact(value)
    local n=tonumber(value) or 0
    if n>=1000000 then return string.format('%.1fM',n/1000000) end
    if n>=10000 then return math.floor(n/1000)..'K' end
    return tostring(n)
end
function M.refresh(window)
    if not window.__recruit_balances then return end
    local user=_ED.user_info
    window.__recruit_balances[1]:setString(compact(user.user_silver))
    window.__recruit_balances[2]:setString(compact(user.user_gold))
    window.__recruit_balances[3]:setString(tostring(user.user_food or 0)..'/'..tostring(user.max_user_food or 0))
end
-- Keep the original Recruit card art and content, but make the front/back
-- transition deterministic on the Naruto client where OrbitCamera can stall.
function M.showCardSide(window,index,side)
    local root=window and window.roots and window.roots[1]
    if not root then return false end
    local front=widget(root,'Panel_ck_f_'..tostring(index))
    local back=widget(root,'Panel_ck_b_'..tostring(index))
    if not front or not back then return false end
    front:stopAllActions();back:stopAllActions()
    front:setScale(1);back:setScale(1)
    front:setRotation(0);back:setRotation(0)
    local showBack=side=='back'
    front:setVisible(not showBack);back:setVisible(showBack)
    return true
end
function M.bindCardFlip(window,index)
    local root=window and window.roots and window.roots[1]
    if not root then return false end
    local front=widget(root,'Panel_ck_f_'..tostring(index))
    local button=widget(root,index==1 and 'Button_15' or 'Button_16')
    if not front or not button or not button.addTouchEventListener then return false end
    if button.__nr_recruit_flip_bound then return true end
    -- fwin.touch can drop taps while the tutorial's global window lock is
    -- active. Flip locally for both normal play and the required first draw.
    if fwin and fwin.removeTouchEventListener then fwin:removeTouchEventListener(button) end
    if button.setEnabled then button:setEnabled(true) end
    if button.setTouchEnabled then button:setTouchEnabled(true) end
    button:addTouchEventListener(function(_,eventType)
        if eventType~=ccui.TouchEventType.ended or not front:isVisible() then return end
        print('RECRUIT_CARD_FLIP tap index='..tostring(index)..' from=front to=back')
        if not M.showCardSide(window,index,'back') then
            print('RECRUIT_CARD_FLIP_FAILED index='..tostring(index)..' reason=card_nodes_missing')
        end
    end)
    button.__nr_recruit_flip_bound=true
    return true
end
function M.apply(window)
    if window.__recruit_lobby then return end
    local root=window.roots and window.roots[1]
    if not root then return end
    window.__recruit_lobby=true
    -- Some builds use a different recruit card node naming scheme. Header
    -- resources and the Recruit title must still be shown even when those
    -- optional animation/card nodes are absent.
    if widget(root,'Panel_ck_f_1') then
        for i=1,2 do
            local front=widget(root,'Panel_ck_f_'..i)
            local back=widget(root,'Panel_ck_b_'..i)
            local button=widget(root,i==1 and 'Button_15' or 'Button_16')
            if front then
                local ancestor=front
                while ancestor and ancestor~=window do ancestor:setVisible(true);ancestor=ancestor:getParent() end
                front:stopAllActions();front:setVisible(true);front:setScale(1);front:setRotation(0);front:setOpacity(255)
            end
            if back then
                back:stopAllActions();back:setVisible(false);back:setScale(1);back:setRotation(0);back:setOpacity(255)
            end
            if button then
                local path=i==1 and 'images/ui/text/chouka_di_01.png' or 'images/ui/text/chouka_di_02.png'
                button:loadTextures(path,path,path);button:setVisible(true);button:setEnabled(true);button:setTouchEnabled(true)
            end
        end
    end
    for _,name in ipairs({'Image_4_1_0_0','Image_4_1_0_0_0_pr1'}) do
        local cloud=widget(root,name);if cloud then cloud:setVisible(false) end
    end
    window._isChangePage=false
    local size=cc.Director:getInstance():getWinSize()
    local title=cc.Sprite:create('images/ui/text/title_zhaomu.png')
    if title then title:setPosition(cc.p(size.width*.12,size.height*.95));window:addChild(title,30) end
    window.__recruit_balances={}
    app.load('client.utils.SmBuySilverCoins');app.load('client.utils.SmBuyPhysical')
    local specs={
        {'jinbi','user_silver','sm_buy_silver_coinsopen'},
        {'zuanshi','user_gold','activity_home_recharge_button'},
        {'tili','user_food','sm_buy_physicalopen'},
    }
    for i,spec in ipairs(specs) do
        local panel=ccui.Layout:create();panel:setContentSize(cc.size(158,42))
        panel:setPosition(cc.p(size.width*(.29+(i-1)*.20),size.height*.93))
        window:addChild(panel,30)
        local bar=cc.Sprite:create('images/ui/bar/top1.png')
        if bar then bar:setPosition(cc.p(77,21));panel:addChild(bar) end
        local icon=cc.Sprite:create('images/ui/icon/'..spec[1]..'.png')
        if icon then icon:setScale(.75);icon:setPosition(cc.p(15,21));panel:addChild(icon) end
        local value=ccui.Text:create('','fonts/FZYiHei-M20S.ttf',20)
        value:setPosition(cc.p(77,21));panel:addChild(value);window.__recruit_balances[i]=value
        local plus=ccui.Button:create('images/ui/button/add_jiahao.png','images/ui/button/add_jiahao.png')
        plus:setPosition(cc.p(145,21));panel:addChild(plus)
        fwin:addTouchEventListener(plus,nil,{terminal_name=spec[3],terminal_state=0,touch_black=true},nil,0)
    end
    M.refresh(window)
    local project=rawget(_G,'__lua_project_id')
    local naruto=rawget(_G,'__lua_project_l_naruto')
    if naruto~=nil and project==naruto then
        for i=1,2 do M.bindCardFlip(window,i) end
    end
end
function M.install(class)
    if not class or class.__recruit_lobby_installed then return end
    class.__recruit_lobby_installed=true
    for _,method in ipairs({'onEnterTransitionFinish','onInit'}) do
        local original=class[method]
        class[method]=function(self,...)
            local results={original(self,...)};M.apply(self);return unpack(results)
        end
    end
    local update=class.onUpdate
    class.onUpdate=function(self,...)
        local results={update(self,...)};M.refresh(self);return unpack(results)
    end
end
return M
