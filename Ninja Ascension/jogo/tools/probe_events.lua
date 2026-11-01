nrgate=nrgate or {}
nrgate.parsechain=true -- disable the native host probe's separate live-server check
nrgate.login=true
app.load('client.login.LoginLoading')
app.load('client.home.Menu')
local root=((os.getenv('NR_GAME_ROOT') or 'N:'):gsub('\\','/'):gsub('/+$',''))..'/'
local files=cc.FileUtils:getInstance()
local fixture=json.decode(files:getStringFromFile(root..'build/events-native-fixture.json'))
local oldRegister=NetworkManager.register
local lastToast=nil
local oldToast=TipDlg.drawTextDailog
TipDlg.drawTextDailog=function(text) lastToast=text end
NetworkManager.register=function() return {} end
NetworkProtocol.parser_func({resouce=files:getStringFromFile(root..'build/events-login.txt')})
app.load('client.activity.LocalEventWindow')
local opened=0
local visibleWindow=nil
NetworkManager.register=function(_,code,a,b,c,owner,callback)
    if code==protocol_command.local_event_init.code then
        local mode=protocol_command.local_event_init.param_list
        _ED.localEventsPayload=fixture[mode]
    elseif code==protocol_command.local_event_action.code then
        local wire=protocol_command.local_event_action.command_fun('7')
        assert(wire:find('ramen\r\nfood',1,true),'Wrong claim arguments')
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(root..'build/events-ramen-reply.txt')})
    else error('Event fixture attempted unrelated network request') end
    callback({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0,node=owner})
    return {}
end
for _,mode in ipairs({'event','seven'}) do
    local window=LocalEventWindow:new():init(mode)
    window:retain()
    window:onEnterTransitionFinish()
    assert(window.body and window.roots[1],'Missing Event frame')
    local pages=window.data.pages
    assert(#pages==#fixture[mode].pages,'Wrong page catalog')
    for _,page in ipairs(pages) do
        window.page=page.id
        window:render()
        if page.id=='weapons' then
            assert(window.renderedRewardIconCount>0,'Original reward item was not added to the native cell')
        end
        local expected={}
        -- The original level-fund CSB owns its separate purchase button;
        -- the reward-list button count therefore only covers milestone rows.
        if page.investment and page.id~='fund' then table.insert(expected,{available=page.canInvest}) end
        for _,row in ipairs(page.rows) do
            if page.id~='discount' or tonumber(row.day or 1)==tonumber(window.discountDay) then
                table.insert(expected,row)
            end
        end
        assert(#window.rowButtons==#expected,'Missing reward buttons: '..page.id)
        for i,btn in ipairs(window.rowButtons) do
            assert(btn:isEnabled()==expected[i].available,'Wrong availability: '..page.id)
        end
        opened=opened+1
    end
    if mode=='event' then
        window.page='ramen'
        window:request('ramen','food')
        assert(lastToast and lastToast:find('60 Stamina',1,true),'Claim did not display the received reward')
        assert(window.rowButtons[1]:getTitleText()=='Coletado','Claim did not refresh state')
    end
    if mode=='event' then visibleWindow=window else window:release() end
end
visibleWindow.page='fund'
-- Capture the representative purchased fund state from the original reference.
local fundPage=visibleWindow.data.pages[1]
fundPage.invested=true
fundPage.canInvest=false
for _,row in ipairs(fundPage.rows) do
    row.claimed=false
    row.available=true
end
visibleWindow:render()
assert(visibleWindow.renderedRewardIconCount>0,'Original fund reward icons were not added')
assert(visibleWindow.renderedFundRowCount==#visibleWindow.data.pages[1].rows,'Original fund rows were not retained in the native list')
fwin:open(visibleWindow,fwin._view)
assert(visibleWindow:getParent(),'Window manager did not attach Event')
local scheduler=cc.Director:getInstance():getScheduler()
local entry=nil
entry=scheduler:scheduleScriptFunc(function()
    scheduler:unscheduleScriptEntry(entry)
    visibleWindow:removeFromParent(false)
    local scene=cc.Director:getInstance():getRunningScene()
    scene:addChild(visibleWindow,2000)
    local size=cc.Director:getInstance():getWinSize()
    visibleWindow:setScale(math.min(size.width/visibleWindow.width,size.height/visibleWindow.height))
    visibleWindow:setPosition(cc.p(0,0))
    visibleWindow:setVisible(true)
    local state={width=visibleWindow.width,height=visibleWindow.height,windowSize=visibleWindow:getContentSize(),windowScale=visibleWindow:getScale(),rootPosition=visibleWindow.roots[1]:getPosition(),rootScale=visibleWindow.roots[1]:getScale(),rootVisible=visibleWindow.roots[1]:isVisible(),windowOpacity=visibleWindow:getOpacity(),bodySize=visibleWindow.body:getContentSize(),bodyPosition=visibleWindow.body:getPosition()}
    state.parents={}
    local node=visibleWindow.body
    while node do
        table.insert(state.parents,{name=node:getName(),visible=node:isVisible(),opacity=node:getOpacity(),x=node:getPositionX(),y=node:getPositionY(),sx=node:getScaleX(),sy=node:getScaleY()})
        node=node:getParent()
    end
    local result=assert(io.open(root..'build/events-visual-state.json','w'))
    result:write(json.encode(state));result:close()
    visibleWindow:release()
end,0.25,false)
NetworkManager.register=oldRegister
TipDlg.drawTextDailog=oldToast
print('EVENT_NATIVE_PASSED pages='..opened..' real layouts; row actions; protocol claim; visible prize; claimed state')
