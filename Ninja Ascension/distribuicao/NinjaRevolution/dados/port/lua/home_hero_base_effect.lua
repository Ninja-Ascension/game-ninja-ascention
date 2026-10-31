-- Reuse the original formation-base animation below every home character.
local M={}
function M.add(panel)
    local name='__nr_home_hero_base'
    if panel:getChildByName(name) then return end
    local base=sp.spine('sprite/spirte_zhuchengkapaidi.json',
        'sprite/spirte_zhuchengkapaidi.atlas',1,0,'animation',true,nil)
    base:setName(name)
    base:setPosition(cc.p(panel:getContentSize().width/2,0))
    panel:addChild(base,-1)
end
return M
