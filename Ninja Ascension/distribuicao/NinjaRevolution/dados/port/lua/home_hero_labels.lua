local M={}
local function outline(text)
    local label=text:getVirtualRenderer()
    if label and label.enableOutline then label:enableOutline(cc.c4b(0,0,0,235),1) end
end
local shortNames={'Sasuke','Naruto','Madara','Indra','Obito','Shisui','Itachi','Sakura','Kakashi','Minato','Hashirama','Tobirama','Hiruzen','Tsunade','Jiraiya','Orochimaru','Gaara','Hinata','Neji','Rock Lee','Shikamaru','Konohamaru','Pain','Nagato','Kisame','Deidara','Sasori','Kakuzu','Hidan','Rin','Kaguya','Kimimaro'}
function M.shortName(title)
    for _,name in ipairs(shortNames) do
        if title:find('%f[%a]'..name..'%f[%A]') then return name end
    end
    return title:match('^(.-)%s+%-%s+') or title
end
function M.apply(root,index,ship)
    local text=ccui.Helper:seekWidgetByName(root,'Text_name_'..index)
    local stars=ccui.Helper:seekWidgetByName(root,'Panel_star_'..index)
    local caption=ccui.Helper:seekWidgetByName(root,'Panel_role_name_'..index)
    local actor=ccui.Helper:seekWidgetByName(root,string.format('Panel_role_0%d',index))
    local badge=ccui.Helper:seekWidgetByName(root,'Panel_strengthen_stye_'..index)
    if not text or not caption then return end
    -- Anchor the complete caption to the actor, not to its previous text width.
    if actor then
        local size=actor:getContentSize()
        local point=caption:getParent():convertToNodeSpace(actor:convertToWorldSpace(cc.p(size.width/2,0)))
        local width=root:getContentSize().width
        if width<=0 then width=960 end
        caption:setPositionX(math.max(86,math.min(width-86,point.x)))
    end
    local currentY=caption:getPositionY()
    if currentY~=caption.__nrCaptionY then caption.__nrBaseY=currentY end
    caption.__nrCaptionY=(caption.__nrBaseY or currentY)+24
    caption:setPositionY(caption.__nrCaptionY)
    local title=text:getString():gsub('%s*Lv%.%s*%d+$',''):gsub('%s*Nv%.%s*%d+$','')
    title=M.shortName(title)
    text:ignoreContentAdaptWithSize(true)
    text:setFontSize(14)
    text:setString(title)
    text:setAnchorPoint(cc.p(0.5,0.5))
    local quality=shipOrEquipSetColour(tonumber(ship.Order) or 0)
    local color=tipStringInfo_quality_color_Type[quality] or {255,255,255}
    text:setColor(cc.c3b(color[1],color[2],color[3]))
    outline(text)
    local level=caption:getChildByName('__desktop_hero_level')
    if not level then
        level=ccui.Text:create();level:setName('__desktop_hero_level');caption:addChild(level)
    end
    level:ignoreContentAdaptWithSize(true)
    level:setFontSize(14)
    local levelText=string.format((_new_interface_text and _new_interface_text[1]) or 'Lv.%d',tonumber(ship.ship_grade) or 1)
    levelText=levelText:gsub('^Ninja%s*','')
    level:setString(levelText)
    level:setColor(cc.c3b(255,0,0))
    level:setAnchorPoint(cc.p(0.5,0.5));outline(level)
    local nameWidth=text:getContentSize().width
    local levelWidth=level:getContentSize().width
    local left=65-(nameWidth+levelWidth+5)/2
    text:setPosition(cc.p(left+nameWidth/2,190))
    level:setPosition(cc.p(left+nameWidth+5+levelWidth/2,190))
    if badge then
        badge:setScale(.55)
        badge:setAnchorPoint(cc.p(0,0.5))
        badge:setPosition(cc.p(-16,190))
    end
    if stars then
        stars:setAnchorPoint(cc.p(0.5,0))
        stars:setPosition(cc.p(65,160))
        stars:removeAllChildren(true)
        -- Keep the game's original sprites, size and spacing.
        neWshowShipStar(stars,tonumber(ship.StarRating) or 0)
    end
end
function M.safeApply(...)
    local ok,err=pcall(M.apply,...)
    if not ok then print('HOME_HERO_CAPTION_ERROR '..tostring(err)) end
    return ok
end
return M
