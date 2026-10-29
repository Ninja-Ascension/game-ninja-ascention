--------------------------------------------------------------------------------------------------------------
--  说明：神器控件
--------------------------------------------------------------------------------------------------------------
SmCultivateArtifactCell = class("SmCultivateArtifactCellClass", Window)
SmCultivateArtifactCell.__size = nil

local sm_cultivate_artifact_cell_terminal = {
    _name = "sm_cultivate_artifact_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCultivateArtifactCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_artifact_cell_terminal)
state_machine.init()

function SmCultivateArtifactCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._isLockShow = false
    self._index = 0
    self._isChoose = false

    local function init_sm_cultivate_artifact_cell_terminal()
        local sm_cultivate_artifact_cell_choose_terminal = {
            _name = "sm_cultivate_artifact_cell_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(params._info.state) == 0 and params._isLockShow == false then
                    TipDlg.drawTextDailog(_new_interface_text[285])
                    return
                end
                state_machine.excute("sm_cultivate_artifact_update_choose_state", 0, params._index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_cultivate_artifact_cell_choose_terminal)
        state_machine.init()
    end 
    init_sm_cultivate_artifact_cell_terminal()
end

function SmCultivateArtifactCell:updateChooseState(isChoose)
    local root = self.roots[1]
    local Image_bg_3 = ccui.Helper:seekWidgetByName(root, "Image_bg_3")
    Image_bg_3:setVisible(isChoose)
end

function SmCultivateArtifactCell:updateDraw()
    local root = self.roots[1]
    local Image_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_bg_1")
    local Image_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_bg_2")
    local Image_bg_3 = ccui.Helper:seekWidgetByName(root, "Image_bg_3")
    local Panel_sq_icon = ccui.Helper:seekWidgetByName(root, "Panel_sq_icon")
    local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
    local pic = dms.int(dms["artifact_mould"], self._index, artifact_mould.pic)
    Panel_sq_icon:removeBackGroundImage()
    Image_bg_3:setVisible(isChoose)
    Image_bg_1:setVisible(false)
    Image_bg_2:setVisible(false)
    Image_lock:setVisible(false)
    if tonumber(self._info.state) == 0 then
        if self._isLockShow == true then
            Panel_sq_icon:setBackGroundImage(string.format("images/ui/text/SQ_res/sq_img/sq_icon_%d.png", pic))
            Image_bg_2:setVisible(true)
        else
            Image_bg_1:setVisible(true)
        end
        Image_lock:setVisible(true)
    else
        Panel_sq_icon:setBackGroundImage(string.format("images/ui/text/SQ_res/sq_img/sq_icon_%d.png", pic))
        Image_bg_2:setVisible(true)
    end
end

function SmCultivateArtifactCell:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_artifact_cell.csb")
    local root = csbItem:getChildByName("root")
    -- local root = cacher.createUIRef("cultivate/cultivate_artifact_tab_1_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    if SmCultivateArtifactCell.__size == nil then
        SmCultivateArtifactCell.__size = root:getContentSize()
    end

    local function touchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __epoint = sender:getTouchEndPosition()
        if ccui.TouchEventType.began == evenType then
        elseif ccui.TouchEventType.moved == evenType then
        elseif ccui.TouchEventType.canceled == evenType then
        elseif ccui.TouchEventType.ended == evenType then
            local cellWidth = sender._self:getContentSize().width
            local cellPos = sender._self:getPositionX()

            local listViewWidth = sender._self:getParent():getParent():getContentSize().width
            local listViewInnerPos = sender._self:getParent():getParent():getInnerContainer():getPositionX()

            local cond_1 = cellPos + cellWidth / 2 < listViewWidth + math.abs(listViewInnerPos)
            local cond_2 = cellPos + cellWidth / 2 > math.abs(listViewInnerPos)

            local isInView = cond_1 and cond_2
            if math.abs(__epoint.x - __spoint.x) <= 5 and isInView then
                state_machine.excute("sm_cultivate_artifact_cell_choose", 0, sender._self)
            end
        end
    end

    local Panel_sq_icon = ccui.Helper:seekWidgetByName(root, "Panel_sq_icon")
    Panel_sq_icon._self = self
    Panel_sq_icon:setSwallowTouches(false)
    Panel_sq_icon:addTouchEventListener(touchEvent)

	self:updateDraw()
end

function SmCultivateArtifactCell:onEnterTransitionFinish()
end

function SmCultivateArtifactCell:clearUIInfo( ... )
    local root = self.roots[1]
end

function SmCultivateArtifactCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmCultivateArtifactCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_artifact_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmCultivateArtifactCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._isLockShow = params[3]
    self:onInit()
    self:setContentSize(SmCultivateArtifactCell.__size)
    return self
end

function SmCultivateArtifactCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_artifact_cell.csb", self.roots[1])
end