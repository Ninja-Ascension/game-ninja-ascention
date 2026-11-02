
-- 天赋免疫
-- @author xiaofeng
TalentImmunity = class("TalentImmunity")

function TalentImmunity:ctor()
    --免疫状态
    self.immunityStatus =  -1

    --免疫天赋
    self.immunityTalent =  -1

end

local obj = TalentImmunity:new()