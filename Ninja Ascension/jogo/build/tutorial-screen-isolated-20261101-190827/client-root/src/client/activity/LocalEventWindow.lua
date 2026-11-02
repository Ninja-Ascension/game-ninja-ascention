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

local function findNode(parent,name)
    if not parent then return nil end
    if parent.getName and parent:getName()==name then return parent end
    local children=parent.getChildren and parent:getChildren() or {}
    for _,child in ipairs(children) do
        local found=findNode(child,name)
        if found then return found end
    end
    return nil
end

local function rewardText(rewards)
    local parts={}
    local names={[1]="Ryo",[2]="Gold",[12]="Stamina",[34]="Pontos de talento"}
    for _,r in ipairs(rewards or {}) do
        local kind=tonumber(r[2])
        local name=names[kind]
        if kind==13 then name=(tonumber(r[1])==47 and "Kiba" or ("Ninja "..tostring(r[1]))) end
        if not name and tonumber(r[2])==6 then
            name=dms.string(dms["prop_mould"],tonumber(r[1]),prop_mould.prop_name)
            name=tostring(name or ("Item "..r[1])):gsub("&nbsp;"," ")
        end
        table.insert(parts,tostring(r[3]).." "..(name or ("Item "..r[1])))
    end
    return table.concat(parts," + ")
end

local function rewardName(reward)
    local id,kind=tonumber(reward[1]),tonumber(reward[2])
    local names={[1]="Ryo",[2]="Gold",[12]="Stamina",[34]="Pontos de talento"}
    if kind==13 then return id==47 and "Kiba" or ("Ninja "..tostring(id)) end
    if kind==6 then
        local name=setThePropsIcon(id)[2]
        return (tostring(name or ("Item "..tostring(id))):gsub("&nbsp;"," "))
    end
    if kind==7 then
        local nameIndex=dms.int(dms["equipment_mould"],id,equipment_mould.equipment_name)
        local info=dms.element(dms["word_mould"],nameIndex)
        return info and tostring(info[3]) or ("Equipamento "..tostring(id))
    end
    return names[kind] or ("Item "..tostring(id))
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
                if campaign=="fund" and entry=="invest" then
                    TipDlg.drawTextDailog(_string_piece_info[279])
                elseif text~="" then
                    TipDlg.drawTextDailog(text)
                end
            end
        end
    end,false,nil)
end

-- Use the exact activity icon CSBs used by ActivityWindow for the left
-- navigation. These are native clickable controls; only their destination
-- is redirected to the local campaign renderer.
function LocalEventWindow:renderOriginalTabs()
    local root=self.roots[1]
    local list=ccui.Helper:seekWidgetByName(root,"ListView_wonder_btn")
    if not list then return end
    list:removeAllItems()
    local paths={
        fund="activity/icon/wonder_act_4.csb",
        ramen="activity/icon/wonder_act_1.csb",
        recharge="activity/icon/wonder_act_3.csb",
        first="activity/icon/wonder_act_6.csb",
        discount="activity/icon/wonder_act_48.csb",
        consume="activity/icon/wonder_act_8.csb",
        talent="activity/icon/wonder_act_59.csb",
        weapons="activity/icon/wonder_act_58.csb",
        login="activity/icon/wonder_act_72.csb",
        special="activity/icon/activity_xsyouhui.csb"
    }
    for _,page in ipairs(self.data.pages or {}) do
        local path=paths[page.id]
        local iconFrame=path and csb.createNode(path)
        local iconRoot=iconFrame and (iconFrame:getChildByName("root") or iconFrame)
        local holder=findNode(iconRoot,"Panel_172_4") or iconRoot
        if iconRoot and holder then
            iconRoot:removeFromParent(false)
            local cell=ccui.Layout:create()
            cell:setContentSize(holder:getContentSize())
            cell:addChild(iconRoot)
            local nativeButton=findNode(iconRoot,"Button_act_but")
            if nativeButton then
                nativeButton:addClickEventListener(function()
                    self.page=page.id
                    self:render()
                end)
            end
            list:addChild(cell)
        end
    end
    list:requestRefreshView()
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
    app.load("client.player.UserInformationHeroStorage")
    local userinfo=UserInformationHeroStorage:new()
    userinfo.__cname="UserInformationHeroStorageClassA"
    fwin:open(userinfo,fwin._view)
    self.userInfo=userinfo
    self:request()
end

function LocalEventWindow:renderOriginalDiscount(panel,chosen,panelW,contentH)
    app.load("client.cells.utils.resources_icon_cell")
    local frame=csb.createNode("activity/wonderful/everyday_discount.csb")
    local root=frame:getChildByName("root") or frame:getChildByName("root_pr3") or frame
    local size=root:getContentSize()
    local scale=math.min(panelW/size.width,contentH/size.height)
    frame:setScale(scale)
    frame:setAnchorPoint(cc.p(0.5,0.5))
    frame:setPosition(cc.p(panelW/2,contentH/2))
    panel:addChild(frame)

    local function widget(name)
        return ccui.Helper:seekWidgetByName(root,name)
    end
    local day=math.max(1,math.min(7,tonumber(self.discountDay or chosen.eventDay or 1)))
    self.discountDay=day
    self.rowButtons={}
    local byDay={}
    for _,row in ipairs(chosen.rows) do
        byDay[tonumber(row.day or 1)]=byDay[tonumber(row.day or 1)] or {}
        table.insert(byDay[tonumber(row.day or 1)],row)
    end

    for d=1,7 do
        local dayButton=widget("Button_day_"..d)
        if dayButton then
            dayButton:setHighlighted(d==day)
            dayButton:addClickEventListener(function()
                self.discountDay=d
                self:render()
            end)
        end
    end

    local deadline=chosen.schedule and chosen.schedule.end_at or ""
    local timer=widget("Text_32")
    local displayDeadline=chosen.schedule and chosen.schedule.display_end
    if not displayDeadline and deadline~="" then displayDeadline=deadline:sub(1,16):gsub("T"," ") end
    if timer then timer:setString(displayDeadline and ("Edição até "..displayDeadline) or "") end

    for slot=1,2 do
        local row=byDay[day] and byDay[day][slot]
        local rewards=row and row.rewards or {}
        local props=widget("Panel_props_"..slot)
        local name=widget("Text_prop_name_"..slot)
        local gold=widget("Text_prop_sell_"..slot)
        local ryo=widget("Text_prop_sell_"..slot.."_1")
        local details=widget("Text_prop_text_"..slot)
        local badge=widget("Panel_discount_"..slot)
        if props then
            props:removeAllChildren(true)
            for _,reward in ipairs(rewards) do
                local icon=ResourcesIconCell:createCell()
                icon:init(tonumber(reward[2]),tonumber(reward[3]),tonumber(reward[1]),nil,nil,true,true)
                props:addChild(icon)
            end
        end
        if name then
            local titles={}
            for _,reward in ipairs(rewards) do table.insert(titles,rewardName(reward)) end
            name:setString(row and table.concat(titles," + ") or "Sem oferta")
        end
        if gold then gold:setVisible(false) end
        if ryo then ryo:setVisible(false) end
        if details then
            local hint=""
            if row then
                if row.reason~="" then
                    hint=row.reason
                else
                    hint=tostring(row.cost_gold or row.cost or 0).." Gold + "..tostring(row.cost_ryo or 0).." Ryo | VIP "..tostring(row.vip or 0)
                end
            end
            details:setString(hint)
        end
        if badge then badge:setVisible(false) end

        local buy=widget("Button_buy_"..slot)
        if buy then
            buy:setTitleText(row and (row.claimed and "Coletado" or "Comprar") or "Indisponível")
            buy:setTouchEnabled(row~=nil and row.available==true)
            buy:setBright(row~=nil and row.available==true)
            if row then
                local id=row.id
                buy:addClickEventListener(function() self:request(chosen.id,id) end)
            end
            table.insert(self.rowButtons,buy)
        end
    end
end

-- Render list-based local events with the same panel and reward cell used by
-- the original game's accumulated-reward activities. Only the data and click
-- callbacks are local; the visual hierarchy comes from the shipped CSB files.
function LocalEventWindow:renderOriginalRewardList(panel,chosen,panelW,contentH)
    app.load("client.cells.utils.resources_icon_cell")
    local frame=csb.createNode("activity/wonderful/landed_gifts.csb")
    local root=frame:getChildByName("root")
    if not root then return end
    local size=root:getContentSize()
    if size.width<=0 or size.height<=0 then return end
    local scale=math.min(panelW/size.width,contentH/size.height)
    frame:setScale(scale)
    frame:setAnchorPoint(cc.p(0.5,0.5))
    frame:setPosition(cc.p(panelW/2,contentH/2))
    panel:addChild(frame)

    local function widget(name)
        return ccui.Helper:seekWidgetByName(root,name)
    end
    local title=widget("Text_032")
    if title then title:setString(chosen.title or "") end
    local heading=widget("Text_45")
    if heading then heading:setString("Recompensas do evento") end
    local timer=widget("Text_32")
    if timer then
        local deadline=chosen.schedule and (chosen.schedule.display_end or chosen.schedule.end_at) or ""
        timer:setString(deadline~="" and ("Edição até "..deadline) or "")
    end
    local rewardDeadline=widget("Text_44")
    if rewardDeadline then rewardDeadline:setVisible(false) end

    local list=widget("ListView_1")
    if not list then return end
    list:removeAllItems()
    self.renderedRewardIconCount=0
    local rows={}
    if chosen.investment then
        table.insert(rows,{
            id="invest",label="Adquirir fundo por "..tostring(chosen.investment).." Gold",
            target=0,progress="",available=chosen.canInvest==true,
            claimed=chosen.invested==true,rewards={}
        })
    end
    for _,row in ipairs(chosen.rows or {}) do table.insert(rows,row) end

    for index,row in ipairs(rows) do
        local rowFrame=csb.createNode("activity/wonderful/landed_gifts_list.csb")
        local rowRoot=rowFrame and rowFrame:getChildByName("root")
        if rowRoot then
            local function rowWidget(name)
                return ccui.Helper:seekWidgetByName(rowRoot,name)
            end
            local cell=ccui.Layout:create()
            local rowPanel=rowWidget("Panel_land_list")
            local cellSize=rowPanel and rowPanel:getContentSize() or rowRoot:getContentSize()
            cell:setContentSize(cellSize)
            cell:addChild(rowFrame)

            local name=rowWidget("Text_11")
            if name then name:setString(tostring(row.label or "Evento")) end
            local progress=rowWidget("Text_13")
            if progress then
                local text=""
                if row.target and tonumber(row.target)>0 then
                    text=tostring(row.progress or 0).."/"..tostring(row.target)
                end
                progress:setString(text)
                progress:setVisible(text~="")
            end
            local go=rowWidget("Button_13")
            if go then go:setVisible(false);go:setTouchEnabled(false) end
            local claimed=rowWidget("Image_13")
            if claimed then claimed:setVisible(row.claimed==true) end

            local icons=rowWidget("ScrollView_icon")
            local iconList=rowWidget("ListView_11")
            if icons then icons:removeAllChildren(true) end
            if iconList then iconList:removeAllItems();iconList:setLocalZOrder(100) end
            local iconCells={}
            for _,reward in ipairs(row.rewards or {}) do
                local icon=ResourcesIconCell:createCell()
                icon:init(tonumber(reward[2]),tonumber(reward[3]),tonumber(reward[1]),nil,nil,true,true)
                table.insert(iconCells,icon)
                self.renderedRewardIconCount=self.renderedRewardIconCount+1
                if icons then
                    icons:addChild(icon)
                elseif iconList then
                    iconList:addChild(icon)
                    if tonumber(reward[2])==6 then
                        local picture=setThePropsIcon(tonumber(reward[1]))[1]
                        local artwork=cc.Sprite:create(string.format("images/ui/props/props_%d.png",picture))
                        if artwork then
                            local area=iconList:getContentSize()
                            local iconPosition=#iconCells
                            artwork:setPosition(cc.p(60+(iconPosition-1)*130,area.height/2))
                            artwork:setLocalZOrder(200)
                            artwork:setScale(0.72)
                            iconList:addChild(artwork)
                        end
                    end
                end
            end
            if icons then
                local iconChildren=icons:getChildren()
                local area=icons:getContentSize()
                local iconSize=iconChildren[1] and iconChildren[1]:getContentSize() or cc.size(0,0)
                local columns=2
                local innerH=math.max(area.height,math.ceil(#(row.rewards or {})/columns)*(iconSize.height-24))
                icons:setInnerContainerSize(cc.size(area.width,innerH))
                for iconIndex,icon in ipairs(iconChildren) do
                    local col=(iconIndex-1)%columns
                    local line=math.floor((iconIndex-1)/columns)
                    icon:setPosition(cc.p(area.width*(col+0.5)/columns,innerH-(line+0.5)*(iconSize.height-24)))
                end
            end
            if iconList then
                local area=iconList:getContentSize()
                iconList:setInnerContainerSize(area)
                iconList:requestRefreshView()
                for iconIndex,icon in ipairs(iconCells) do
                    icon:setLocalZOrder(100)
                    icon:setPosition(cc.p(60+(iconIndex-1)*130,area.height/2))
                end
            end

            local collect=rowWidget("Button_12")
            if collect then
                local text=row.claimed and "Coletado" or "Coletar"
                if row.id=="invest" then text=row.claimed and "Adquirido" or "Investir" end
                collect:setTitleText(text)
                collect:setVisible(true)
                collect:setTouchEnabled(row.available==true)
                collect:setBright(row.available==true)
                collect:setEnabled(row.available==true)
                collect:addClickEventListener(function()
                    self:request(chosen.id,row.id)
                end)
                table.insert(self.rowButtons,collect)
            end
            list:addChild(cell)
        end
    end
    list:requestRefreshView()
end

-- The level fund has its own original illustrated screen and reward row.
-- Keep the game's artwork and widget hierarchy, while binding the controls
-- to the local event API instead of the original global activity protocol.
function LocalEventWindow:renderOriginalFund(panel,chosen,panelW,contentH)
    app.load("client.cells.activity.open_server_list_cell_new")
    local frame=csb.createNode("activity/wonderful/open_service_fund_1.csb")
    local root=frame and frame:getChildByName("root")
    if not root then return end
    local size=root:getContentSize()
    if size.width<=0 or size.height<=0 then return end
    local scale=math.min(panelW/size.width,contentH/size.height)
    frame:setScale(scale)
    frame:setAnchorPoint(cc.p(0.5,0.5))
    frame:setPosition(cc.p(panelW/2,contentH/2))
    panel:addChild(frame)

    local function widget(parent,name)
        return ccui.Helper:seekWidgetByName(parent,name)
    end
    local cost=widget(root,"Text_fund_mis_n")
    if cost then cost:setString(tostring(chosen.investment or 200)) end
    local vip=widget(root,"BitmapFontLabel_2_2")
    if vip then vip:setString(tostring(chosen.vip or 3)) end
    local buy=widget(root,"Button_kf_14_6")
    local purchased=chosen.invested==true
    if buy then
        buy:setVisible(not purchased)
        buy:setTouchEnabled(not purchased and chosen.canInvest==true)
        buy:setBright(not purchased and chosen.canInvest==true)
        buy:addClickEventListener(function() self:request(chosen.id,"invest") end)
    end
    local purchasedMark=widget(root,"Image_5")
    if purchasedMark then purchasedMark:setVisible(purchased) end
    local purchaseInfo=widget(root,"Panel_7")
    if purchaseInfo then purchaseInfo:setVisible(not purchased) end
    local purchasedInfo=widget(root,"Panel_8")
    if purchasedInfo then purchasedInfo:setVisible(purchased) end

    local list=widget(root,"ListView_4")
    if not list then return end
    list:removeAllItems()
    self.renderedRewardIconCount=0
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.activity.open_server_list_cell_new")
    local textRenderer=OpenServerListCellNew:new()
    for _,row in ipairs(chosen.rows or {}) do
        local rowRoot=nil
        if __lua_project_id==__lua_project_l_naruto then
            rowRoot=cacher.createUIRef("activity/wonderful/open_service_fund_list_1.csb","root")
        else
            local rowFrame=csb.createNode("activity/wonderful/open_service_fund_list_1.csb")
            rowRoot=rowFrame and rowFrame:getChildByName("root")
        end
        if rowRoot then
            rowRoot:removeFromParent(false)
            local cell=ccui.Layout:create()
            cell:setContentSize(rowRoot:getContentSize())
            cell:addChild(rowRoot)
            local goal=widget(rowRoot,"Text_kf_2")
            local reward=row.rewards and row.rewards[1]
            local amount=reward and tostring(reward[3]) or ""
            if goal then
                local heading=amount~="" and (amount.." ".._string_piece_info[284]) or _string_piece_info[284]
                if verifySupportLanguage(_lua_release_language_en)==true then
                    textRenderer:drawText(goal,heading,_string_piece_info[6]..tostring(row.target),_string_piece_info[283],22,goal:getFontName())
                else
                    textRenderer:drawText(goal,heading,tostring(row.target).._string_piece_info[6],_string_piece_info[283],22,goal:getFontName())
                end
                local rich=goal:getChildren()[1]
                if rich then rich:setPositionX(0) end
            end
            local progress=widget(rowRoot,"Text_kf_jd")
            if progress then
                local current,target=tonumber(row.progress) or 0,tonumber(row.target) or 0
                progress:setString(current.."/"..target)
                progress:setColor(current>=target and cc.c3b(15,255,0) or cc.c3b(255,255,255))
            end
            -- Text_kf_2_0 is a child of the claim button in the original CSB.
            -- Putting the reward quantity there overlays the native button title.
            local buttonAmount=widget(rowRoot,"Text_kf_2_0")
            if buttonAmount then buttonAmount:setString("") end
            local prizeName=widget(rowRoot,"Text_kfjj_01")
            if prizeName then prizeName:setString("") end
            local rewardPanel=widget(rowRoot,"Panel_kfjj_03")
            if rewardPanel then
                rewardPanel:removeAllChildren(true)
                app.load("client.cells.equip.equip_icon_cell")
                app.load("client.cells.prop.prop_icon_cell")
                app.load("client.cells.prop.prop_money_icon")
                local reward=row.rewards and row.rewards[1]
                if reward then
                    local kind=tonumber(reward[2])
                    local id=tonumber(reward[1])
                    local count=tonumber(reward[3])
                    local icon=nil
                    if kind==1 then
                        icon=propMoneyIcon:createCell()
                        icon:init("1",-1,nil)
                    elseif kind==2 then
                        icon=ResourcesIconCell:createCell()
                        icon:init("2",0,-1,nil,nil,true,true,0)
                    elseif kind==12 then
                        icon=ResourcesIconCell:createCell()
                        icon:init("12",-1,-1)
                    elseif kind==6 then
                        icon=PropIconCell:createCell()
                        if icon.hideNameAndCount then icon:hideNameAndCount() end
                        icon:init(23,{user_prop_template=id,prop_number=-1},-1)
                    elseif kind==7 then
                        icon=EquipIconCell:createCell()
                        if icon.hideNameAndCount then icon:hideNameAndCount() end
                        icon:init(10,nil,id,nil)
                    elseif kind==13 then
                        icon=ResourcesIconCell:createCell()
                        icon:init(tostring(id),0,count,nil,nil,true,true,0)
                    else
                        icon=ResourcesIconCell:createCell()
                        icon:init(tostring(kind),0,count,nil,nil,true,true,0)
                    end
                    if icon then
                        local iconArea=rewardPanel:getContentSize()
                        icon:setScale(0.7)
                        icon:setPosition(cc.p(iconArea.width/2,iconArea.height/2))
                        icon:setLocalZOrder(100)
                        rewardPanel:addChild(icon)
                        self.renderedRewardIconCount=self.renderedRewardIconCount+1
                    end
                end
            end
            local stamp=widget(rowRoot,"Image_3")
            if stamp then stamp:setVisible(row.claimed==true) end
            local collect=widget(rowRoot,"Button_kf_01")
            if collect then
                collect:setTitleText("Coletar")
                collect:setVisible(not row.claimed)
                collect:setTouchEnabled(row.available==true)
                collect:setBright(row.available==true)
                collect:setEnabled(row.available==true)
                collect:setLocalZOrder(100)
                collect:addClickEventListener(function() self:request(chosen.id,row.id) end)
                table.insert(self.rowButtons,collect)
            end
            list:addChild(cell)
        end
    end
    list:requestRefreshView()
    list:jumpToTop()
    self.renderedFundRowCount=#list:getItems()
end

function LocalEventWindow:render()
    local root=self.roots[1]
    if self.body then self.body:removeFromParent() end
    self:renderOriginalTabs()
    local w,h=self.width,self.height
    local body=ccui.Layout:create()
    body:setContentSize(cc.size(w-16,h-86))
    body:setPosition(cc.p(8,8))
    body:setBackGroundColorType(0)
    root:addChild(body,100)
    self.body=body
    local contentH=h-100
    local chosen=nil
    for i,p in ipairs(self.data.pages) do
        local page=p
        if page.id==self.page then chosen=page end
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
    if chosen.id=="fund" then
        local originalW,originalH=w-16,contentH
        panel:setContentSize(cc.size(originalW,contentH))
        panel:setInnerContainerSize(cc.size(originalW,contentH))
        panel:setPosition(cc.p(0,0))
        body:addChild(panel)
        self:renderOriginalFund(panel,chosen,originalW,originalH)
        return
    elseif chosen.id=="discount" then
        local originalW,originalH=w-16,contentH
        panel:setContentSize(cc.size(originalW,contentH))
        panel:setInnerContainerSize(cc.size(originalW,contentH))
        panel:setPosition(cc.p(0,0))
        body:addChild(panel)
        self:renderOriginalDiscount(panel,chosen,originalW,originalH)
        return
    end
    panel:setInnerContainerSize(cc.size(panelW,contentH))
    body:addChild(panel)
    self:renderOriginalRewardList(panel,chosen,panelW,contentH)
end

