--------------------------------------------------------------------------------------------------------------
--  招募奖励预览列表cell
--------------------------------------------------------------------------------------------------------------
NewRecruitPreviewWindowTabCell = class("NewRecruitPreviewWindowTabCellClass", Window)
NewRecruitPreviewWindowTabCell.__size = nil

-- 创建cell
local new_recruit_preview_window_tab_cell_create_terminal = {
    _name = "new_recruit_preview_window_tab_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = NewRecruitPreviewWindowTabCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(new_recruit_preview_window_tab_cell_create_terminal)
state_machine.init()

function NewRecruitPreviewWindowTabCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self.allWidget = 0
    self.contentInfo = {}        -- 当前内容
    self.rewardInfo = {}            -- 奖励内容
    -- 初始化状态机
    local function init_new_recruit_preview_window_tab_cell_terminal()

    end 
    init_new_recruit_preview_window_tab_cell_terminal()

end

function NewRecruitPreviewWindowTabCell:updateHeroAnimation()
    local root = self.roots[1]
    local type = tonumber(self.rewardInfo[1])
    local mouldID = tonumber(self.rewardInfo[2])
    local Panel_digimon_dh = ccui.Helper:seekWidgetByName(root,"Panel_role")
    Panel_digimon_dh:removeAllChildren(true)
    --Panel_digimon_dh:removeAllItems()

    -- local Panel_top = ccui.Helper:seekWidgetByName(root,"Panel_top")
    -- Panel_top:removeAllChildren(true)
    -- local cell = nil
    -- cell = state_machine.excute("sm_recruit_preview_window_ship_one_cell_create",0,{self._index,self._info,self._prop_type})
    -- Panel_top:addChild(cell)

    local evo_mould_info = zstring.split(dms.string(dms["ship_mould"], tonumber(self.rewardInfo[2]), ship_mould.fitSkillTwo), ",")
    local evo_index = dms.int(dms["ship_mould"], tonumber(self.rewardInfo[2]), ship_mould.captain_name)
    local evo_mould_id = evo_mould_info[evo_index]

    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    if type == 13 then
        local armature_hero = sp.spine_sprite(Panel_digimon_dh, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature_hero:setScaleX(-1)
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(armature_hero, true)
        
    else
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{type,mouldID,1},false,false,false,true})
        Panel_digimon_dh:addChild(cell)
    end
end

-- 保留小数位
function NewRecruitPreviewWindowTabCell:GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal);
    local nRet = nTemp / nDecimal;
    return nRet;
end

-- 刷新
function NewRecruitPreviewWindowTabCell:updateDraw()
    local root = self.roots[1]
    local Text_8 = ccui.Helper:seekWidgetByName(root,"Text_8")          -- 概率文本
    local Text_11 = ccui.Helper:seekWidgetByName(root,"Text_11")      -- 奖励文本
    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")      -- 星级数量

    local initStar = tonumber(self.rewardInfo[4])
    if initStar ~= nil then
        neWshowShipStar(Panel_star , initStar)
    end
    local num = tonumber(self.contentInfo.weight) / tonumber(self.allWidget)
    local probability = self:GetPreciseDecimal(num, 4)
    local proString = ""
    if (probability * 100) % 100 == 0 then
        proString = probability..".00"
    else
        proString = (probability * 100)..""
    end
    Text_8:setString(proString.."%")

    local propInfo = getItemNameAndQuality(self.rewardInfo)
    local text_name = propInfo[1]
    Text_11:setString(text_name)
    self:updateHeroAnimation()
end 

function NewRecruitPreviewWindowTabCell:onInit()
    local root = cacher.createUIRef("shop/new_recruit_preview_tab_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if NewRecruitPreviewWindowTabCell.__size == nil then
        NewRecruitPreviewWindowTabCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function NewRecruitPreviewWindowTabCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function NewRecruitPreviewWindowTabCell:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Text_digimon_name = ccui.Helper:seekWidgetByName(root,"Text_digimon_name")
    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
    local Panel_digimon_dh = ccui.Helper:seekWidgetByName(root,"Panel_role")

    if Text_digimon_name ~= nil then
        Text_digimon_name:setString("")
    end
    if Panel_star ~= nil then
        Panel_star:removeAllChildren(true)
    end
    if Panel_digimon_dh then
        Panel_digimon_dh:removeAllChildren(true)
    end
    --state_machine.remove("new_recruit_preview_window_tab_cell_create")
end

function NewRecruitPreviewWindowTabCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function NewRecruitPreviewWindowTabCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:removeAllChildren(true)
    self:clearUIInfo()
    cacher.freeRef("shop/new_recruit_preview_tab_cell.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function NewRecruitPreviewWindowTabCell:init(params)
    self._index = params[1]
    self.contentInfo = params[2]
    self.allWidget = params[3]
    self.rewardInfo = zstring.split(self.contentInfo.rewardInfo, ",")
    if self._index ~= nil and self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(NewRecruitPreviewWindowTabCell.__size)
    return self
end

function NewRecruitPreviewWindowTabCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("shop/new_recruit_preview_tab_cell.csb", self.roots[1])
end