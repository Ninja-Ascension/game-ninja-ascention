LimSummonCellPreview = class("LimSummonCellPreviewClass", Window)
LimSummonCellPreview.__size = nil
LimSummonCellPreview.__num_show = 12

function LimSummonCellPreview:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self.index = 0
    self.params = nil

    local function init_lim_summon_cell_preview_terminal()

    end

    init_lim_summon_cell_preview_terminal()
end

function LimSummonCellPreview:init(params, index)
    self.path_csb = "activity/lim_summon/lim_summon_reward_cell.csb"
    self.index = index
    self.params = params

    self:initData()

    if nil ~= self.onInit then
        if self.index < LimSummonCellPreview.__num_show then
            self:onInit(params)
        end
        self:setContentSize(LimSummonCellPreview.__size)
    end

    self:registerOnNodeEvent(self)
    return self
end

function LimSummonCellPreview:onInit(params)
    local root = cacher.createUIRef(self.path_csb, "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if LimSummonCellPreview.__size == nil then
        LimSummonCellPreview.__size = root:getContentSize()
    end

    -- ==========此处定义界面中的按钮点击事件==========

    -- 定义按钮控件

    self:onUpdateDraw()
    self:showData()
end

function LimSummonCellPreview:onEnterTransitionFinish()

end

function LimSummonCellPreview:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    -- 角色
    self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    -- 星星
    self.Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
    -- 概率
    self.Text_8 = ccui.Helper:seekWidgetByName(root, "Text_8")
    -- 名字
    self.Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
end

function LimSummonCellPreview:initData()
    local infoPreview = self.params
    self.weight = infoPreview.weight
    self.prop = zstring.split(infoPreview.prop, ",", zstring.tonumber)
    self.allWeight = infoPreview.allWeight
end

function LimSummonCellPreview:showData()
    -- 名字
    local propInfo = getItemNameAndQuality(self.prop)
    local text_name = propInfo[1]
    self.Text_11:setString(text_name)

    -- Icon
    local type = tonumber(self.prop[1])
    local mouldID = tonumber(self.prop[2])
    self.Panel_role:removeAllChildren(true)

    if type == 13 then
        local evo_mould_info = zstring.split(dms.string(dms["ship_mould"], mouldID, ship_mould.fitSkillTwo), ",")
        local evo_index = dms.int(dms["ship_mould"], mouldID, ship_mould.captain_name)
        local evo_mould_id = evo_mould_info[evo_index]
        local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

        local armature_hero = sp.spine_sprite(self.Panel_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature_hero:setScaleX(-1)
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(armature_hero, true)

        -- 星星
        local initStar = self.prop[4]
        if initStar ~= nil and initStar > 0 then
            neWshowShipStar(self.Panel_star , initStar)
        end
    else
        local cell = DrawHandle.drawIcon(self.prop)
        self.Panel_role:addChild(cell)
    end

    -- 概率
    local num = self.weight/self.allWeight * 100
    local probability = string.format("%.2f", num)
    self.Text_8:setString(probability.."%")
end

function LimSummonCellPreview:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(self.path_csb, root)
end

function LimSummonCellPreview:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimSummonCellPreview:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef(self.path_csb, root)
    
    self.roots = {}
end

function LimSummonCellPreview:clearUIInfo()
    if self.Panel_role then
        self.Panel_role:removeAllChildren(true)
    end

    if self.Panel_star then
        self.Panel_star:removeAllChildren(true)
    end
end