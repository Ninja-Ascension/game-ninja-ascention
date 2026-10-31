LimSummonCellRecord = class("LimSummonCellRecordClass", Window)
LimSummonCellRecord.__size = nil
LimSummonCellRecord.__num_show = 10

function LimSummonCellRecord:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self.index = 0
    self.params = nil

    local function init_lim_summon_cell_record_terminal()

    end

    init_lim_summon_cell_record_terminal()
end

function LimSummonCellRecord:init(params, index)
    self.path_csb = "activity/lim_summon/lim_summon_record_cell.csb"
    self.index = index
    if self.index == nil then
        self.index = 0
    end
    self.params = params

    self:initData()

    if nil ~= self.onInit then
        if self.index < LimSummonCellRecord.__num_show then
            self:onInit(params)
        end
        self:setContentSize(LimSummonCellRecord.__size)
    end

    self:registerOnNodeEvent(self)
    return self
end

function LimSummonCellRecord:onInit(params)
    local root = cacher.createUIRef(self.path_csb, "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if LimSummonCellRecord.__size == nil then
        LimSummonCellRecord.__size = root:getContentSize()
    end

    -- ==========此处定义界面中的按钮点击事件==========

    -- 定义按钮控件

    self:onUpdateDraw()
    self:showData()
end

function LimSummonCellRecord:onEnterTransitionFinish()

end

function LimSummonCellRecord:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    -- 时间
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    -- 头框
    self.Panel_role_item = ccui.Helper:seekWidgetByName(root, "Panel_role_item")
    -- 隐藏
    self.icon_double = ccui.Helper:seekWidgetByName(root, "icon_double")
    self.icon_double:setVisible(false)
    -- 名字
    self.Text_7 = ccui.Helper:seekWidgetByName(root, "Text_7")
    -- 积分Icon
    self.Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    -- 图片条纹
    self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
end

function LimSummonCellRecord:initData()
    local info = self.params
    self.sPropData = info.sPropData
    self.sTime = info.sTime
    self.sPropDataJifen = LimSummonMgr:GetInstance().sPropDataJifen
end

function LimSummonCellRecord:showData()
    -- 购买时间显示
    self.Text_time:setString(self.sTime)

    -- 购买道具显示
    self.Panel_role_item:removeAllChildren(true)
    local iconItem = DrawHandle.drawIcon(self.sPropData)
    self.Panel_role_item:addChild(iconItem)

    -- 道具的名称
    local sName = getItemNameAndQuality(zstring.split(self.sPropData, ","))[1]
    self.Text_7:setString(sName)

    -- 积分Icon
    self.Panel_2:removeAllChildren(true)
    local iconJifen = DrawHandle.drawIcon(self.sPropDataJifen)
    self.Panel_2:addChild(iconJifen)
end

function LimSummonCellRecord:showImg(bVisible)
    if self.Image_1 then
        self.Image_1:setVisible(bVisible)
    end
end

function LimSummonCellRecord:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(self.path_csb, root)
end

function LimSummonCellRecord:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimSummonCellRecord:unload()
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

function LimSummonCellRecord:clearUIInfo()
    if self.Text_time then
        self.Text_time:setString("")
    end
    if self.Panel_role_item then
        self.Panel_role_item:removeAllChildren(true)
    end
    if self.Text_7 then
        self.Text_7:setString("")
    end
    if self.Panel_2 then
        self.Panel_2:removeAllChildren(true)
    end
end