-- Local editable campaigns inside the original Event frame.
LocalEventWindow = class("LocalEventWindowClass", Window)

local function registerProtocol()
    local function restore(value)
        if type(value)=="table" then
            for k,v in pairs(value) do value[k]=restore(v) end
        elseif type(value)=="string" then return (value:gsub("&nbsp;"," ")) end
        return value
    end
    if not NetworkProtocol.find_parser(16981) then
        table.insert(NetworkProtocol.protocol_parses,{code=16981,parser="local_events",parser_fun=function(_,_,_,_,list)
            _ED.localEventsPayload=restore(json.decode(npos(list)))
        end})
    end
    for i,name in ipairs({"local_event_init","local_event_action"}) do
        if not protocol_command[name] then
            local command={code=16979+i,command=name,param_list=""}
            command.command_fun=function(seq)
                return seq.."\r\n"..command.command.."\r\n".._ED.user_info.user_id.."\r\n"..command.param_list
            end
            protocol_command[name]=command
        end
    end
end

local function label(parent,text,x,y,width,size)
    local node=ccui.Text:create(tostring(text),"Arial",size or 20)
    node:setAnchorPoint(cc.p(0,1))
    node:setPosition(cc.p(x,y))
    node:setTextAreaSize(cc.size(width,0))
    node:setTextHorizontalAlignment(0)
    parent:addChild(node)
    return node
end

local function button(parent,text,x,y,width,callback)
    local node=ccui.Button:create("images/ui/button/btn_yellow_1.png","images/ui/button/btn_yellow_1.png","images/ui/button/btn_yellow_1.png",0)
    node:setScale9Enabled(true)
    node:setContentSize(cc.size(width,44))
    node:setTitleFontSize(18)
    node:setTitleText(text)
    if node:getTitleRenderer():getContentSize().width>width-12 then
        local middle=math.floor(#text/2)
        local best=nil
        for i=1,#text do
            if text:sub(i,i)==" " and (not best or math.abs(i-middle)<math.abs(best-middle)) then best=i end
        end
        if best then node:setTitleText(text:sub(1,best-1).."\n"..text:sub(best+1)) end
        node:setTitleFontSize(14)
    end
    node:setPosition(cc.p(x,y))
    node:addClickEventListener(callback)
    parent:addChild(node)
    return node
end

local function rewardText(rewards)
    local parts={}
    local names={[1]="Ryo",[2]="Gold",[12]="Stamina",[34]="Pontos de talento"}
    for _,r in ipairs(rewards or {}) do
        local name=names[tonumber(r[2])]
        if not name and tonumber(r[2])==6 then
            name=dms.string(dms["prop_mould"],tonumber(r[1]),prop_mould.prop_name)
            name=tostring(name or ("Item "..r[1])):gsub("&nbsp;"," ")
        end
        table.insert(parts,tostring(r[3]).." "..(name or ("Item "..r[1])))
    end
    return table.concat(parts," + ")
end

function LocalEventWindow:ctor()
    self.super:ctor()
    self.roots={}
    self.mode="event"
    self.page="fund"
    self.busy=false
    registerProtocol()
end

function LocalEventWindow:init(mode,page)
    self.mode=mode or "event"
    self.page=page or (self.mode=="seven" and "seven1" or "fund")
    return self
end

function LocalEventWindow:request(campaign,entry)
    if self.busy then return end
    self.busy=true
    local name=campaign and "local_event_action" or "local_event_init"
    local command=protocol_command[name]
    local args=self.mode
    if campaign then
        LocalEventWindow.requestCounter=(LocalEventWindow.requestCounter or 0)+1
        local key=os.time()..":"..math.floor(os.clock()*1000000)..":"..LocalEventWindow.requestCounter
        args=args.."\r\n"..campaign.."\r\n"..entry.."\r\n"..key
    end
    command.param_list=args
    NetworkManager:register(command.code,nil,nil,nil,self,function(response)
        self.busy=false
        if not self.roots or not self.roots[1] then return end
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS>=0 then
            self.data=_ED.localEventsPayload
            self:render()
            if campaign then
                local text=rewardText(self.data.rewards)
                TipDlg.drawTextDailog(text~="" and ("Recebido: "..text) or "Fundo adquirido")
            end
        end
    end,false,nil)
end

function LocalEventWindow:onEnterTransitionFinish()
    if self.roots[1] then return end
    local frame=csb.createNode("activity/wonderful/wonderful.csb")
    self:addChild(frame)
    local root=frame:getChildByName("root")
    table.insert(self.roots,root)
    local size=root:getContentSize()
    self.width=size.width>0 and size.width or 960
    self.height=size.height>0 and size.height or 640
    local close=ccui.Helper:seekWidgetByName(root,"Button_wonderful_back")
    if close then close:addClickEventListener(function() fwin:close(self) end) end
    self:request()
end

function LocalEventWindow:render()
    local root=self.roots[1]
    if self.body then self.body:removeFromParent() end
    local w,h=self.width,self.height
    local body=ccui.Layout:create()
    body:setContentSize(cc.size(w-16,h-86))
    body:setPosition(cc.p(8,8))
    body:setBackGroundColorType(1)
    body:setBackGroundColor(cc.c3b(29,42,49))
    root:addChild(body,100)
    self.body=body
    local contentH=h-100
    local tabs=ccui.ScrollView:create()
    tabs:setDirection(1)
    tabs:setContentSize(cc.size(166,contentH))
    tabs:setInnerContainerSize(cc.size(166,math.max(contentH,#self.data.pages*56)))
    tabs:setPosition(cc.p(0,0))
    body:addChild(tabs)
    local chosen=nil
    for i,p in ipairs(self.data.pages) do
        local page=p
        if page.id==self.page then chosen=page end
        button(tabs,page.title,82,math.max(contentH,#self.data.pages*56)-i*56+26,158,function()
            self.page=page.id;self:render()
        end)
    end
    chosen=chosen or self.data.pages[1]
    if not chosen then return end
    self.page=chosen.id
    self.rowButtons={}
    local panel=ccui.ScrollView:create()
    panel:setDirection(1)
    local panelW=w-202
    panel:setContentSize(cc.size(panelW,contentH))
    panel:setPosition(cc.p(180,0))
    local innerH=math.max(contentH,170+#chosen.rows*104+(chosen.investment and 58 or 0))
    panel:setInnerContainerSize(cc.size(panelW,innerH))
    body:addChild(panel)
    local wallet=self.data.balance
    label(panel,(self.mode=="seven" and "7-day Party" or "Event").." | Ryo "..wallet.ryo.." | Gold "..wallet.gold.." | Stamina "..wallet.food,8,innerH-8,panelW-16,18)
    label(panel,chosen.title,8,innerH-42,panelW-16,25)
    label(panel,chosen.description,8,innerH-78,panelW-16,18)
    local y=innerH-154
    if chosen.investment then
        local c=chosen
        local purchase=button(panel,c.invested and "Adquirido" or ("Investir "..c.investment.." Gold"),panelW/2,y,260,function() self:request(c.id,"invest") end)
        purchase:setEnabled(c.canInvest)
        y=y-62
    end
    if chosen.effect then
        label(panel,"Bônus aplicado automaticamente nas ações elegíveis.",8,y,panelW-16,20)
    end
    for _,r in ipairs(chosen.rows) do
        local row=r;local cid=chosen.id
        label(panel,row.label..(row.target>0 and ("  "..row.progress.."/"..row.target) or ""),8,y,panelW-180,20)
        label(panel,rewardText(row.rewards),8,y-28,panelW-180,17)
        if row.reason~="" and not row.claimed then label(panel,row.reason,8,y-54,panelW-180,16) end
        local title=row.claimed and "Coletado" or (row.cost and ("Comprar "..row.cost.." Gold") or "Coletar")
        local collect=button(panel,title,panelW-85,y-28,160,function() self:request(cid,row.id) end)
        collect:setEnabled(row.available)
        table.insert(self.rowButtons,collect)
        y=y-104
    end
end

