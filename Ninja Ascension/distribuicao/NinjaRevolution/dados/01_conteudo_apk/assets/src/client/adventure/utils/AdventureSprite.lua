-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险与挖矿，精灵资源的管理
-------------------------------------------------------------------------------------------------------
AdventureSprite = {} or AdventureSprite
function AdventureSprite:create(spriteId, boneCount)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
	boneCount = boneCount or 9
	local armature = ccs.Armature:create("spirte")
	for i = 1, boneCount do
		local spriteIcon = string.format("images/face/big_head/big_head_%s_%s.png", spriteId, i)
        local skinIcon = ccs.Skin:create(spriteIcon)
        skinIcon:getTexture():setAliasTexParameters()
        armature:getBone("big_head_"..i):addDisplay(skinIcon, 0) 
	end
	return armature
end

--- 2015-11-6 lc 创建战斗任务动画,坐标系锚点调整
AdventureSpriteBattle = {} or AdventureSpriteBattle
function AdventureSpriteBattle:create(spriteId, boneCount)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
	boneCount = boneCount or 9
	local armature = ccs.Armature:create("spirte")
	for i = 1, boneCount do
		local spriteIcon = string.format("images/face/big_head/big_head_%s_%s.png", spriteId, i)
        local skinIcon = ccs.Skin:create(spriteIcon)
        skinIcon:getTexture():setAliasTexParameters()
        skinIcon:setAnchorPoint(cc.p(0.5,0)) -- 图片坐标系跟动画坐标系同步
        armature:getBone("big_head_"..i):addDisplay(skinIcon, 0)
	end
	return armature 
end

---创建静态人物图片
AdventureSpriteRole = {} or AdventureSpriteRole
function AdventureSpriteRole:create(spriteId)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
	
	local armature = ccs.Armature:create("spirte")
	local spriteIcon = string.format("images/face/big_head/big_head_%s.png", spriteId)
    local skinIcon = ccs.Skin:create(spriteIcon)
    skinIcon:getTexture():setAliasTexParameters()
    skinIcon:setAnchorPoint(cc.p(0.5,0)) -- 图片坐标系跟动画坐标系同步
    armature:getBone("big_head_1"):addDisplay(skinIcon, 0)
    armature:setAnchorPoint(cc.p(0.5,0)) -- 图片坐标系跟动画坐标系同步
    -- debug.print_r(skinIcon:getAnchorPoint())
    -- debug.print_r(armature:getAnchorPoint())
	return armature 
end