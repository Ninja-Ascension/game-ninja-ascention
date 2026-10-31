-- Keep the original 960x640 logical UI filling the PC window.
-- Android retains its native viewport and scaling.
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
function M.aspectCorrection() return 1 end
function M.preserve(node)
    -- The original card scale is already correct on the uniform canvas.
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
    local chevron=cc.Sprite:create('images/ui/button/bar_arrow_pj.png')
    if chevron then
        chevron:setPosition(cc.p(17,22));chevron:setScale(.72)
        button:addChild(chevron);button._desktopChevron=chevron
    end
    button:addClickEventListener(callback);node:addChild(button,9999)
    return button
end
function M.apply(node,entry,width)
    if not valid(node) then return end
    for _,item in ipairs(entry.items or {}) do
        local n=item.node
        if valid(n) and item.kind=='bottom' then
            local shown=item.order>=8 or not entry.bottomCollapsed or item.order==1
            n:setVisible(shown);n:setTouchEnabled(shown)
            if item.order==1 and entry.bottomArrow then
                entry.bottomArrow:setPosition(cc.p(18,item.cy))
                entry.bottomArrow._desktopChevron:setRotation(270)
            end
        elseif valid(n) and item.kind=='right' then
            local shown=not entry.rightCollapsed or item.name=='Button_sign'
            n:setVisible(shown);n:setTouchEnabled(shown)
            if item.name=='Button_sign' and entry.rightArrow then
                entry.rightArrow:setPosition(cc.p(item.cx,item.cy+70))
                entry.rightArrow._desktopChevron:setRotation(0)
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
    if not M.mobile then
        local scaledResourceGroups={}
        for _,item in ipairs(entry.items) do
            if item.kind=='bottom' and item.order and item.order<=7 then
                item.node:setScaleX(item.sx*.88);item.node:setScaleY(item.sy*.88)
                item.node:setPositionX(item.x+18)
            elseif item.kind=='right' then
                item.node:setScaleX(item.sx*.88);item.node:setScaleY(item.sy*.88)
                item.node:setPositionY(item.py+18)
            elseif item.kind=='message' then
                item.node:setScaleX(item.sx*.97);item.node:setScaleY(item.sy*.97)
                item.node:setPositionY(item.py-8)
            elseif item.kind=='resources' then
                local group=item.node:getParent()
                if group and not scaledResourceGroups[group] then
                    scaledResourceGroups[group]=true
                    group:setScaleX(group:getScaleX()*.9)
                    group:setScaleY(group:getScaleY()*.9)
                    group:setPositionX(group:getPositionX()+40)
                    group:setPositionY(group:getPositionY()+50)
                end
            end
        end
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
    -- Original assets and CSB layouts share a 960x640 canvas. Axmol renders
    -- that logical canvas uniformly; Android retains the original framework's
    -- physical viewport and app.scaleFactor (setting both would double-scale).
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
end
return M
