-- Original Naruto/Jiraiya front cards. The purchase controls remain on their
-- reverse sides and keep their existing Recruit terminals and costs.
local M={}
local function widget(root,name) return ccui.Helper:seekWidgetByName(root,name) end
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
function M.apply(window)
    if window.__recruit_lobby or __lua_project_id~=__lua_project_l_naruto then return end
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
