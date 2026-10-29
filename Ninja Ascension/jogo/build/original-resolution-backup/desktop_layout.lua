-- Adapt original 960x640 layouts to the desktop viewport. Keep actors uniform.
local M={entries={},proportional={},cardOffsets={}}
local bottom={Button_wujiang='Ninjas',Button_warehouse='Mochila',Button_zhaomu='Recrutar',Button_shop_0='Loja',Button_dailytasks='Tarefas',Button_yangcheng='Academia',Button_lilian_0='Desafios',Button_duplicate='Aventura',Button_jjc='Lutar'}
local right={Button_sign='Presença',Button_friends='Amigos',Button_mingren='Classificação',Button_legion='Clã'}
local bottomOrder={Button_wujiang=1,Button_warehouse=2,Button_zhaomu=3,Button_shop_0=4,Button_dailytasks=5,Button_lilian_0=6,Button_yangcheng=7,Button_jjc=8,Button_duplicate=9}
local words={['Name was successfully modified']='Nome alterado com sucesso',
 ['This guy is lazy, he did not write anything']='Nenhuma assinatura definida',
 ['System Settings']='Configurações', ['Music Settings']='Áudio', ['Ninja Info']='Informações do ninja',
 ['None']='Nenhum', ['Power']='Poder', ['Total DMG']='Dano total', ['Total DMG:']='Dano total:',
 ['History']='Histórico', ['Accept']='Aceitar', ['Confirm']='Confirmar', ['Cancel']='Cancelar',
 ['Formation']='Formação', ['Main']='Principal', ['Elite']='Elite', ['Nightmare']='Pesadelo',
 ['Fast Raid']='Incursão rápida', ['Draw x1']='Recrutar 1', ['Draw x10']='Recrutar 10',
 ['Sign in']='Presença', ['Friends']='Amigos', ['Clan']='Clã', ['Shop']='Loja', ['Bag']='Mochila',
 ['Recruit']='Recrutar', ['Quest']='Tarefas', ['Fight']='Lutar', ['Adventure']='Aventura'}
words['Upgrade']='Subir nível';words['Promote']='Promover';words['Skill']='Habilidades'
words['Cursed Seal']='Selo amaldiçoado';words['Level Up']='Subir nível'
words['Weapon']='Arma';words['Owned']='Possuídos';words['Not owned']='Não possuídos'
words['All']='Todos';words['Trial Room']='Sala de provas';words['Ninja School']='Academia Ninja'
words['Weapon Shop']='Loja de armas';words['General Shop']='Loja geral'
words['Arena Shop']='Loja da arena';words['Trial Shop']='Loja de provas';words['Clan Shop']='Loja do clã'
words['Buy']='Comprar';words['Use']='Usar';words['Sell']='Vender';words['Refresh']='Atualizar'
words['Level']='Nível';words['Skills']='Habilidades';words['Awaken']='Despertar'
function M.translate(value)
    local language=cc.UserDefault:getInstance():getStringForKey('current_language', ''):lower()
    -- Keep English and other original language packs intact.
    if language~='' and not language:find('pt',1,true) and not language:find('portug',1,true) and language~='br' then return value end
    if _ED and _ED.user_info and value==_ED.user_info.user_name then return value end
    return words[value] or value
end
local function walk(node,fn)
    fn(node)
    for _,child in ipairs(node:getChildren()) do walk(child,fn) end
end
local function valid(node) return node and not tolua.isnull(node) end
function M.aspectCorrection()
    if M.mobile then return 1 end   -- phones keep the original proportions
    local frame=cc.Director:getInstance():getOpenGLView():getFrameSize()
    if frame.width<=0 or frame.height<=0 then return 1 end
    return (frame.height/640)/(frame.width/960)
end
function M.preserve(node)
    if not M.proportional[node] then M.proportional[node]=node:getScaleX() end
    if not M.cardOffsets[node] then M.cardOffsets[node]=node:getPositionX() end
    node:setScaleX(M.proportional[node]*M.aspectCorrection())
    node:setPositionX(M.cardOffsets[node]+(M.mobile and 0 or 18))
end
function M.toggle(node,group)
    local entry=assert(M.entries[node])
    local key=group=='bottom' and 'bottomCollapsed' or 'rightCollapsed'
    entry[key]=not entry[key]
    M.apply(node,entry,cc.Director:getInstance():getVisibleSize().width)
end
local function arrow(node,name,title,callback)
    local button=ccui.Button:create()
    button:setName(name);button:ignoreContentAdaptWithSize(false)
    button:setContentSize(cc.size(34,44))
    local disk=cc.DrawNode:create()
    disk:drawSolidCircle(cc.p(17,22),16,0,32,cc.c4f(0,0,0,.28));button:addChild(disk)
    local chevron=cc.Node:create();chevron:setPosition(cc.p(17,22));button:addChild(chevron)
    local shadow=cc.DrawNode:create();local ink=cc.DrawNode:create()
    shadow:drawSegment(cc.p(6,11),cc.p(-4,1),3,cc.c4f(0,0,0,.9))
    shadow:drawSegment(cc.p(-4,1),cc.p(6,-9),3,cc.c4f(0,0,0,.9))
    ink:drawSegment(cc.p(5,10),cc.p(-5,0),2,cc.c4f(1,1,1,1))
    ink:drawSegment(cc.p(-5,0),cc.p(5,-10),2,cc.c4f(1,1,1,1))
    chevron:addChild(shadow);chevron:addChild(ink);button._desktopChevron=chevron
    button:addClickEventListener(callback);node:addChild(button,9999)
    return button
end
function M.apply(node,entry,width)
    if not valid(node) then return end
    if entry.ninjaList then
        -- Correct the whole two-column list together. Correcting each card
        -- separately shrinks cards inside unchanged column spacing.
        if not M.mobile then
            local ratio=M.aspectCorrection()
            node:setScaleX(entry.sx*ratio)
            node:setPositionX(entry.x+480*entry.sx*(1-ratio))
        end
        return
    end
    if entry.saga then require('saga_layout').fit(node,entry.x);return end
    if M.mobile then
        -- Phones keep the original layout; only collapse/expand and the arrows.
        if not entry.home and not entry.header then return end
        for _,item in ipairs(entry.items) do
            local n=item.node
            if valid(n) and item.kind=='bottom' then
                local shown=item.order>=8 or not entry.bottomCollapsed or item.order==1
                n:setVisible(shown);n:setTouchEnabled(shown)
                -- leave room for the collapse arrow at the left edge
                if item.order<8 then n:setPositionX(item.x+30) end
                if item.order==1 and entry.bottomArrow then
                    entry.bottomArrow:setPosition(cc.p(18,item.cy))
                    entry.bottomArrow._desktopChevron:setRotation(entry.bottomCollapsed and 180 or 0)
                end
            elseif valid(n) and item.kind=='right' then
                local shown=not entry.rightCollapsed or item.name=='Button_sign'
                n:setVisible(shown);n:setTouchEnabled(shown)
                if item.name=='Button_sign' and entry.rightArrow then
                    entry.rightArrow:setPosition(cc.p(item.cx,item.cy+54))
                    entry.rightArrow._desktopChevron:setRotation(entry.rightCollapsed and 270 or 90)
                end
            end
        end
        return
    end
    local delta=width-960
    local aspect=M.aspectCorrection()
    node:setPositionX(entry.x+delta/2)
    if not entry.home and not entry.header then return end
    for _,item in ipairs(entry.items) do
        local n=item.node
        if valid(n) then
            if item.kind=='background' then
                n:setScaleX(item.sx*width/960)
                n:setPositionX(item.x+delta*(n:getAnchorPoint().x-.5))
            elseif item.kind=='hero' then
                n:setPositionX((item.x-600)*.9+480)
                n:setScaleX(item.sx*.9*aspect);n:setScaleY(item.sy*.9)
            elseif item.kind=='bottom' then
                local fixed=item.order>=8
                n:setVisible(fixed or not entry.bottomCollapsed or item.order==1)
                n:setTouchEnabled(fixed or not entry.bottomCollapsed or item.order==1)
                n:setScaleX(item.sx*.85*aspect);n:setScaleY(item.sy*.85)
                -- Buttons belong to different original nested panels. Place
                -- their centers in scene coordinates, then convert to parent.
                local centerX=72+(item.order-1)*78
                if item.order==8 then centerX=width-124-delta/2 end
                if item.order==9 then centerX=width-48-delta/2 end
                local size=n:getContentSize();local anchor=n:getAnchorPoint()
                local target=node:convertToWorldSpace(cc.p(centerX,item.y))
                local parentPoint=n:getParent():convertToNodeSpace(target)
                n:setPositionX(parentPoint.x-(.5-anchor.x)*size.width*n:getScaleX())
                if item.order==1 and entry.bottomArrow then
                    entry.bottomArrow:setPosition(cc.p(18,item.cy));entry.bottomArrow:setScaleX(aspect)
                    entry.bottomArrow._desktopChevron:setRotation(entry.bottomCollapsed and 180 or 0)
                end
            elseif item.kind=='right' then
                local shown=not entry.rightCollapsed or item.name=='Button_sign'
                n:setVisible(shown);n:setTouchEnabled(shown)
                n:setPositionX(item.x+delta/2)
                n:setScaleX(item.sx*.85*aspect);n:setScaleY(item.sy*.85)
                if item.name=='Button_sign' and entry.rightArrow then
                    entry.rightArrow:setPosition(cc.p(item.cx,item.cy+54));entry.rightArrow:setScaleX(aspect)
                    entry.rightArrow._desktopChevron:setRotation(entry.rightCollapsed and 270 or 90)
                end
            elseif item.kind=='profile' or item.kind=='profileText' or item.kind=='resources' then
                local factor=item.kind=='resources' and .96 or 1
                n:setScaleX(item.sx*aspect*factor);n:setScaleY(item.sy*factor)
                local anchor=n:getAnchorPoint();local size=n:getContentSize()
                if item.kind=='resources' then
                    local resourceCenters={Image_13=385,Image_14=545,Image_11=705}
                    local target=node:convertToWorldSpace(cc.p(resourceCenters[item.name],item.cy))
                    local parentPoint=n:getParent():convertToNodeSpace(target)
                    n:setPositionX(parentPoint.x-(.5-anchor.x)*size.width*n:getScaleX())
                    n:setPositionY(item.py-18+(.5-anchor.y)*size.height*(item.sy-n:getScaleY()))
                else
                    n:setPositionX(item.x+anchor.x*size.width*item.sx*(aspect-1))
                    n:setPositionY(item.py)
                end
            elseif item.kind=='message' then
                n:setScaleX(item.sx*aspect)
                n:setPositionX(item.x+8);n:setPositionY(item.py-14)
            end
        end
    end
end
function M.track(node,path)
    if path=='packs/HeroStorage/generals_list_sui.csb' then
        local entry={x=node:getPositionX(),sx=node:getScaleX(),ninjaList=true}
        M.entries[node]=entry;M.apply(node,entry,960);return
    end
    if path=='cultivate/ninja_biographies/ninja_biographies_divine.csb' then
        local entry={x=node:getPositionX(),saga=true}
        M.entries[node]=entry;M.apply(node,entry,960);return
    end
    if path=='Chat/chat_home_window.csb' then
        node:setVisible(false)
        return
    end
    if path~='home/home_button.csb' and path~='home/home_juese.csb' and path~='home/home.csb'
        and path~='player/user_information.csb' and path~='player/role_information.csb' then return end
    local entry={x=node:getPositionX(),home=path=='home/home_button.csb' or path=='home/home_juese.csb',header=path=='player/user_information.csb',items={}}
    if entry.home or entry.header then
        walk(node,function(n)
            local name=n:getName():gsub('_pr%d+$','')
            if name=='Panel_effice_piaoluo' then n:setVisible(false) end
            local kind=(name=='Panel_home_bg' or name=='Panel_dh_bg' or name=='Panel_animation') and 'background' or name:match('^Panel_role_0[1-6]$') and 'hero' or bottom[name] and 'bottom' or right[name] and 'right'
            if entry.header then
                kind=n:getName()=='Panel_zuo_1_xr1' and 'profile' or n:getName()=='Panel_zuo_2_xr1' and 'profileText'
                    or (name=='Image_13' or name=='Image_14' or name=='Image_11') and 'resources' or nil
            elseif name=='Button_mail' or name=='Button_chat' then kind='message' end
            if kind then
                local scenePosition=node:convertToNodeSpace(n:getParent():convertToWorldSpace(cc.p(n:getPositionX(),n:getPositionY())))
                local size=n:getContentSize()
                local center=node:convertToNodeSpace(n:convertToWorldSpace(cc.p(size.width/2,size.height/2)))
                entry.items[#entry.items+1]={node=n,kind=kind,name=name,x=n:getPositionX(),py=n:getPositionY(),y=scenePosition.y,cx=center.x,cy=center.y,sx=n:getScaleX(),sy=n:getScaleY(),order=bottomOrder[name]}
            end
        end)
    end
    M.entries[node]=entry
    if path=='home/home_button.csb' then
        entry.bottomArrow=arrow(node,'__desktop_bottom_arrow','<',function() M.toggle(node,'bottom') end)
        entry.rightArrow=arrow(node,'__desktop_right_arrow','^',function() M.toggle(node,'right') end)
    end
    M.apply(node,entry,cc.Director:getInstance():getVisibleSize().width)
end
function M.install()
    if M.installed then return end
    M.installed=true
    -- One logical canvas for every scene, modal, list and touch target.
    -- EXACT_FIT maps the entire original canvas to the client area; no
    -- screen-specific blank strip remains to the right of legacy layouts.
    -- Phones keep the APK's own resolution policy (EXACT_FIT would stretch).
    local platform=cc.Application:getInstance():getTargetPlatform()
    M.mobile=platform==cc.PLATFORM_OS_ANDROID or platform==cc.PLATFORM_OS_IPHONE or platform==cc.PLATFORM_OS_IPAD
    if not M.mobile then
        cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(960,640,cc.ResolutionPolicy.EXACT_FIT)
    end
    for _,class in ipairs({ccui.Text,ccui.Button,cc.Label}) do
        local method=class==ccui.Button and 'setTitleText' or 'setString'
        local original=class[method]
        if original then class[method]=function(self,value,...) return original(self,M.translate(value),...) end end
    end
    local original=csb.createNode
    csb.createNode=function(path,...)
        local node=original(path,...)
        if node then
            walk(node,function(n)
                if n.getString and n.setString then
                    local value=n:getString();local translated=M.translate(value)
                    if value~=translated then n:setString(translated) end
                end
            end)
            M.track(node,path)
        end
        return node
    end
    local lastWidth=0
    local initialFrame=cc.Director:getInstance():getOpenGLView():getFrameSize()
    local lastFrame=tostring(initialFrame.width)..':'..tostring(initialFrame.height)
    if M.mobile then return end   -- no desktop resize/aspect compensation on phones
    app.scheduler:scheduleScriptFunc(function()
        local view=cc.Director:getInstance():getOpenGLView()
        local frame=view:getFrameSize()
        local frameKey=tostring(frame.width)..':'..tostring(frame.height)
        local frameChanged=frame.height>0 and frameKey~=lastFrame
        if frameChanged then
            lastFrame=frameKey
            -- The native view reapplies its existing EXACT_FIT policy when
            -- the user resizes. Screen navigation never resets the viewport.
        end
        local width=cc.Director:getInstance():getVisibleSize().width
        if width~=lastWidth or frameChanged then
            lastWidth=width
            for node,entry in pairs(M.entries) do
                if valid(node) then M.apply(node,entry,width) else M.entries[node]=nil end
            end
        end
        local ninjaOpen=fwin and (fwin:find('HeroStorageClass')~=nil or fwin:find('HeroListViewClass')~=nil)
        for node,scale in pairs(M.proportional) do
            if valid(node) then
                local target=scale*(ninjaOpen and M.aspectCorrection() or 1)
                if math.abs(node:getScaleX()-target)>.0001 then node:setScaleX(target) end
                local targetX=M.cardOffsets[node]+(ninjaOpen and 18 or 0)
                if math.abs(node:getPositionX()-targetX)>.001 then node:setPositionX(targetX) end
            else M.proportional[node]=nil;M.cardOffsets[node]=nil end
        end
    end,.1,false)
end
return M
