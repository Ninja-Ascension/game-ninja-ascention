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
        assert(#window.rowButtons==#page.rows,'Missing reward buttons: '..page.id)
        for i,btn in ipairs(window.rowButtons) do
            assert(btn:isEnabled()==page.rows[i].available,'Wrong availability: '..page.id)
            assert(btn:getTitleText()~='','Empty reward action')
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
visibleWindow:render()
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
