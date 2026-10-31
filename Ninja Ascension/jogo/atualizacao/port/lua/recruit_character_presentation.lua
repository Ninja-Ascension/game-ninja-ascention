-- Recruit card/detail presentation, using the original APK widgets and art.
-- This module only displays a recorded reward; it never grants or draws one.
local M={}
local function widget(root,name) return ccui.Helper:seekWidgetByName(root,name) end
local function label(parent,value,size,x,y)
    local node=ccui.Text:create(tostring(value),'fonts/FZYiHei-M20S.ttf',size)
    node:setPosition(cc.p(x,y));parent:addChild(node);return node
end
local function disableTouches(node)
    if node.setTouchEnabled then node:setTouchEnabled(false) end
    for _,child in ipairs(node:getChildren()) do disableTouches(child) end
end
local function backdrop(parent,size)
    local image=cc.Sprite:create('images/ui/bg/hy_zhaomu_bg.png')
    if image then
        local s=image:getContentSize()
        image:setScale(math.max(size.width/s.width,size.height/s.height))
        image:setPosition(cc.p(size.width/2,size.height/2));parent:addChild(image,-10)
    end
end
function M.show(window,reward,done)
    local layer=window.__recruit_detail
    layer:removeAllChildren(true);layer:setVisible(true)
    local size=layer:getContentSize()
    backdrop(layer,size)
    local mould=reward.duplicate_hero or reward.id
    local ship=fundShipWidthTemplateId(mould)
    local evo=zstring.split(dms.string(dms.ship_mould,mould,ship_mould.fitSkillTwo),',')[1]
    local name=dms.string(dms.word_mould,dms.int(dms.ship_evo_mould,evo,ship_evo_mould.name_index),3) or ('Ninja #'..mould)
    local stars=dms.int(dms.ship_mould,mould,ship_mould.ship_star)
    local token=window.__recruit_operation
    local index=window.__recruit_index
    local finished,ready=false,false
    local function current()
        return not tolua.isnull(window) and window.__recruit_operation==token
            and window.__recruit_index==index and window.__recruit_state~='FECHADO'
    end
    local function finish()
        if finished or not ready or not current() then return end
        finished=true;ready=false
        window:runAction(cc.CallFunc:create(function()
            if current() then done() end
        end))
    end
    local function details()
        if not ready or not current() then return end
        ready=false;window.__recruit_state='DETALHE'
        layer:removeAllChildren(true);backdrop(layer,size)
        local node=csb.createNode('shop/recruit_settlement_shici_1.csb')
        layer:addChild(node)
        local root=node:getChildByName('root')
        -- The original CSB ships with Naruto placeholder text and six stars.
        -- Name/quality/stars are rendered above by this presentation; keep only
        -- the role and skill widgets from the template, populated below.
        for _,key in ipairs({'Text_1*11','Text_2','Panel_quality_hero',
                'Image_2_1','Image_2_2','Image_2_3','Image_2_4','Image_2_5','Image_2_6'}) do
            local placeholder=widget(root,key)
            if placeholder then placeholder:setVisible(false) end
        end
        local tip=widget(root,'Text_tip');if tip then tip:setString('') end
        local panel=widget(root,'Panel_lwj_2')
        if panel then panel:setVisible(true);panel:setPosition(cc.p(0,0)) end
        local skillPanel=widget(root,'Panel_3_0')
        if skillPanel then skillPanel:setVisible(false) end
        local title=cc.Sprite:create(string.format('images/ui/quality/hero_name_quality_%d.png',dms.int(dms.ship_mould,mould,ship_mould.ship_type)))
        if title then title:setPosition(cc.p(size.width*.22,size.height*.84));layer:addChild(title) end
        label(layer,name,30,size.width*.22,size.height*.84)
        local starPanel=ccui.Layout:create();starPanel:setContentSize(cc.size(180,32))
        starPanel:setPosition(cc.p(size.width*.26-90,size.height*.75));layer:addChild(starPanel)
        neWshowShipStarTwo(starPanel,stars)
        local position=dms.int(dms.ship_evo_mould,evo,ship_evo_mould.position_index)
        widget(root,'Text_dingwei_m'):setString(dms.string(dms.word_mould,position,3))
        local talents=zstring.split(dms.string(dms.ship_evo_mould,evo,ship_evo_mould.talent_index),'|')
        local talent=zstring.split(talents[2],',')[3]
        local iconPanel=widget(root,'Panel_skill_icon');iconPanel:removeAllChildren(true)
        local picture=dms.int(dms.talent_mould,talent,talent_mould.new_skill_pic)
        local icon=cc.Sprite:create(string.format('images/ui/skills/skills_%d.png',picture))
        if icon then icon:setPosition(cc.p(iconPanel:getContentSize().width/2,iconPanel:getContentSize().height/2));iconPanel:addChild(icon) end
        local skillName=widget(root,'Text_skill_name')
        skillName:setString(skillDescriptionReplaceData(talent,mould,1,1,false))
        skillName:setPositionY(skillName:getPositionY()-size.height*.055)
        local skillIcon=widget(root,'Panel_skill_icon')
        local skillWidth=skillPanel and skillPanel:getContentSize().width or size.width*.45
        skillIcon:setPositionX(skillIcon:getPositionX()+size.width*.53)
        skillName:setPositionX(skillName:getPositionX()+size.width*.53)
        skillIcon:setPositionY(skillIcon:getPositionY()-size.height*.055)
        local description=widget(root,'Text_skill_infor')
        description:setString(skillDescriptionReplaceData(talent,mould,1,2,false))
        local scroll=widget(root,'ScrollView_1')
        if scroll then
            scroll:setPositionX(scroll:getPositionX()+size.width*.53)
            local area=scroll:getContentSize()
            description:setTextAreaSize(cc.size(area.width,0))
            local height=math.max(area.height,description:getContentSize().height)
            scroll:setInnerContainerSize(cc.size(area.width,height))
            description:setAnchorPoint(cc.p(0,1));description:setPosition(cc.p(0,height));scroll:jumpToTop()
            scroll:setPositionY(scroll:getPositionY()-size.height*.055)
        end
        app.load('client.battle.fight.FightEnum')
        local form=dms.int(dms.ship_evo_mould,evo,ship_evo_mould.form_id)
        local hero=sp.spine_sprite(layer,form,spineAnimations[_enum_animation_frame_index.animation_standby+1],true,nil,nil,cc.p(.5,0))
        layer.__recruit_hero=hero
        if cc.nrSpineCommand then cc.nrSpineCommand(hero,'advance',0) end
        local bounds=hero:getBoundingBox()
        local scale=math.min(1,size.width*.4/math.max(1,bounds.width),size.height*.57/math.max(1,bounds.height))
        hero:setScale(scale);hero:setScaleX(-scale)
        hero:setPosition(cc.p(size.width*.50,size.height*.22))
        -- Original detail confirmation replaces the temporary Continue overlay.
        local accept=widget(root,'Button_ok')
        accept:setVisible(true);accept:setEnabled(true);accept:setTouchEnabled(true)
        fwin:addTouchEventListener(accept,function(_,event)
            if event==ccui.TouchEventType.ended then finish() end
        end,nil,nil,0)
        ready=true
    end
    window.__recruit_state='CARTA'
    app.load('client.shop.recruit.SmGeneralsCard')
    local holder=ccui.Layout:create();holder:setContentSize(cc.size(size.width*.42,size.height*.75))
    holder:setPosition(cc.p(size.width*.29,size.height*.19));layer:addChild(holder)
    local card=SmGeneralsCard:new()
    -- A display-only card must not run SmGeneralsCard:onExit: that legacy
    -- method clears the global reward lists, including later rewards in 10x.
    card.onExit=function() end
    card:init({holder,false,false,mould,true,nil,nil,stars})
    holder:addChild(card)
    disableTouches(card)
    local face=widget(card.roots[1],'Panel_20')
    local dimensions=face:getContentSize()
    local base=math.min(holder:getContentSize().width/math.max(1,dimensions.width),holder:getContentSize().height/math.max(1,dimensions.height))
    face:retain();face:removeFromParent(false);holder:addChild(face);face:release()
    face:setAnchorPoint(cc.p(.5,.5));face:setPosition(cc.p(holder:getContentSize().width/2,holder:getContentSize().height/2))
    face:setScale(base*.1)
    face:runAction(cc.Sequence:create(cc.ScaleTo:create(.12,base*1.2),cc.ScaleTo:create(.02,base),cc.CallFunc:create(function() ready=true end)))
    if reward.duplicate_hero then
        label(layer,'Você já tem este Ninja; ele será convertido em',24,size.width/2,size.height*.18)
        label(layer,'Fragmento de '..reward.number..' '..name,27,size.width/2,size.height*.10)
    end
    layer:setTouchEnabled(true);layer:setSwallowTouches(true)
    fwin:addTouchEventListener(layer,function(_,event)
        if event~=ccui.TouchEventType.ended or not current() or not ready then return end
        if window.__recruit_state=='CARTA' then
            if reward.duplicate_hero then finish() else details() end
        end
    end,nil,nil,0)
end
return M
