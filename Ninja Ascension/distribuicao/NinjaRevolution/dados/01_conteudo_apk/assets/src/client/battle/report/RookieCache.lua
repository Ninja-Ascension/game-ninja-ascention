
-- 教学缓存
-- @author xiaofeng
RookieCache = class("RookieCache")

function RookieCache:ctor()
    --战斗类型(0:pve 1:eve 2:虚拟战斗)
    self.fightType =  0

    --战斗npc类型
    self.fightTypeNpc =  0

    --战斗场景解锁npc
    self.fightTypeUnlockNpc =  0

    --战斗场景编号
    self.fightTypeSceneNumber =  0

    --战斗npc性别
    self.fightTypeGender =  0

    --战斗当前场次
    self.fightTypeCurrentCount =  0

    --战斗最大场次
    self.fightTypeMaxCount =  0

end

local obj = RookieCache:new()