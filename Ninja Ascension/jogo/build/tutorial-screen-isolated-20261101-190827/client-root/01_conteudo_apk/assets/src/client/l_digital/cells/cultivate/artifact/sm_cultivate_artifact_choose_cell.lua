--------------------------------------------------------------------------------------------------------------
--  说明：神器单个控件
--------------------------------------------------------------------------------------------------------------
SmCultivateArtifactChooseCell = class("SmCultivateArtifactChooseCellClass", Window)
SmCultivateArtifactChooseCell.__size = nil

local sm_cultivate_artifact_choose_cell_terminal = {
    _name = "sm_cultivate_artifact_choose_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCultivateArtifactChooseCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_artifact_choose_cell_terminal)
state_machine.init()

function SmCultivateArtifactChooseCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._artifact_id = 0
    self._isChoose = false
    self._index = 0
    self._info = ""

    local function init_sm_cultivate_artifact_choose_cell_terminal()
        local sm_cultivate_artifact_choose_cell_choose_terminal = {
            _name = "sm_cultivate_artifact_choose_cell_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local root = cell.roots[1]
                cell._isChoose = not cell._isChoose
                local Image_hook_di = ccui.Helper:seekWidgetByName(root, "Image_hook_di")
                Image_hook_di:setVisible(cell._isChoose)
                state_machine.excute("sm_cultivate_artifact_info_update_add_attr_info", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_cultivate_artifact_choose_cell_choose_terminal)
        state_machine.init()
    end 
    init_sm_cultivate_artifact_choose_cell_terminal()
end

function SmCultivateArtifactChooseCell:updateChooseState( isChoose )
    local root = self.roots[1]
    if root == nil then
        self._isChoose = isChoose
        return
    end

    if isChoose == true then
        local info = zstring.split(dms.string(dms["play_config"], 77, play_config.param), ",")
        local upper_limit_library = zstring.split(dms.string(dms["artifact_mould"], self._artifact_id, artifact_mould.upper_limit_library), "|")
        local result = 0
        for k,v in pairs(self._info) do
            local group_id = 0
            for k1,v1 in pairs(upper_limit_library) do
                v1 = zstring.split(v1, ",")
                if tonumber(v1[1]) == tonumber(v.key) then
                    group_id = tonumber(v1[2])
                    break
                end
            end
            result = result + tonumber(v.value)/tonumber(info[group_id])
        end
        if result < 0 then
            isChoose = false
        end
    end
    self._isChoose = isChoose
    local CheckBox_sxtj = ccui.Helper:seekWidgetByName(root, "CheckBox_sxtj")
    local Image_hook_di = ccui.Helper:seekWidgetByName(root, "Image_hook_di")
    CheckBox_sxtj:setSelected(self._isChoose)
    Image_hook_di:setVisible(self._isChoose)
end

function SmCultivateArtifactChooseCell:updateDraw()
    local root = self.roots[1]
    local function sortFunc(a, b)
        return (tonumber(a.key)) < tonumber(b.key)
    end
    table.sort(self._info, sortFunc)
    for k,v in pairs(self._info) do
        local Text_change_sx = ccui.Helper:seekWidgetByName(root, "Text_change_sx_"..k)
        local Text_change_sx_n = ccui.Helper:seekWidgetByName(root, "Text_change_sx_n_"..k)
        Text_change_sx:setString(skill_attributes_text_tips[tonumber(v.key) + 1])
        if tonumber(v.value) >= 0 then
            if tonumber(v.value) == 0 then
                Text_change_sx_n:setString("--")
            else
                if tonumber(v.key) + 1 >= 5 and tonumber(v.key) + 1 <= 18 then
                    Text_change_sx_n:setString("+"..v.value.."%")
                else
                    Text_change_sx_n:setString("+"..v.value)
                end
            end
            Text_change_sx_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1],tipStringInfo_quality_color_Type[2][2],tipStringInfo_quality_color_Type[2][3]))
        else
            if tonumber(v.key) + 1 >= 5 and tonumber(v.key) + 1 <= 18 then
                Text_change_sx_n:setString(v.value.."%")
            else
                Text_change_sx_n:setString(v.value)
            end
            Text_change_sx_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
        end
    end
    self:updateChooseState(false)
end

function SmCultivateArtifactChooseCell:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_artifact_tab_1_list.csb")
    local root = csbItem:getChildByName("root")
    -- local root = cacher.createUIRef("cultivate/cultivate_artifact_tab_1_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    if SmCultivateArtifactChooseCell.__size == nil then
        SmCultivateArtifactChooseCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_sxtj"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_choose_cell_choose", 
        terminal_state = 0,
        cells = self,
    }, nil, 0)

	self:updateDraw()
end

function SmCultivateArtifactChooseCell:onEnterTransitionFinish()
end

function SmCultivateArtifactChooseCell:clearUIInfo( ... )
    local root = self.roots[1]
end

function SmCultivateArtifactChooseCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    local bChoose = self._isChoose

    self:onInit()

    self._isChoose = bChoose

    local root = self.roots[1]
    if root ~= nil then
        local CheckBox_sxtj = ccui.Helper:seekWidgetByName(root, "CheckBox_sxtj")
        local Image_hook_di = ccui.Helper:seekWidgetByName(root, "Image_hook_di")

        CheckBox_sxtj:setSelected(self._isChoose)
        Image_hook_di:setVisible(self._isChoose)
    end
end

function SmCultivateArtifactChooseCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_artifact_tab_1_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmCultivateArtifactChooseCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._artifact_id = params[3]
    self:onInit()
    self:setContentSize(SmCultivateArtifactChooseCell.__size)
    return self
end

function SmCultivateArtifactChooseCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_artifact_tab_1_list.csb", self.roots[1])
end