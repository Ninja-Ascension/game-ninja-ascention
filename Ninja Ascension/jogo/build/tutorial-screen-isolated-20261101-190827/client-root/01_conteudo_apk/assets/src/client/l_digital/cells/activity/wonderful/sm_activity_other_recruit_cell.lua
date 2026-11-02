
SmActivityOtherRecruitCell = class("SmActivityOtherRecruitCellClass", Window)
SmActivityOtherRecruitCell.__size = nil

local sm_activity_other_recruit_cell_create_terminal = {
    _name = "sm_activity_other_recruit_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityOtherRecruitCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_other_recruit_cell_create_terminal)
state_machine.init()

function SmActivityOtherRecruitCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._mould_id = 0

    local function init_sm_activity_other_recruit_cell_terminal()
        local sm_activity_other_recruit_cell_choose_terminal = {
            _name = "sm_activity_other_recruit_cell_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.packs.hero.SmRoleInformation")
                state_machine.excute("sm_role_information_open", 0, {params._datas.cell._mould_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_other_recruit_cell_choose_terminal)
        state_machine.init()
    end
    init_sm_activity_other_recruit_cell_terminal()
end

function SmActivityOtherRecruitCell:updateDraw()
    local root = self.roots[1]
    local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")
    local Text_player_zizhi = ccui.Helper:seekWidgetByName(root, "Text_player_zizhi")
    local Panel_type = ccui.Helper:seekWidgetByName(root, "Panel_type")
    local Text_player_dingwei = ccui.Helper:seekWidgetByName(root, "Text_player_dingwei")

    Panel_prop:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    cell:init(13, 1, self._mould_id, nil, nil, false, false, 0, {shipStar = self._ship_star})
    Panel_prop:addChild(cell)

    local camp_preference = dms.string(dms["ship_mould"], self._mould_id, ship_mould.camp_preference)
    Panel_type:removeBackGroundImage()
    Panel_type:setBackGroundImage(string.format("images/ui/icon/sm_type_bar_%d.png", camp_preference))

    local ability = dms.string(dms["ship_mould"], self._mould_id, ship_mould.ability)
     --进化形象
    local evo_image = dms.string(dms["ship_mould"], self._mould_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mould_id, ship_mould.captain_name)]
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local ship_name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    Text_player_name:setString(ship_name)
    Text_player_zizhi:setString(ability)

    name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.position_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local location = word_info[3]
    Text_player_dingwei:setString(location)

    name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.describe_index)
    word_info = dms.element(dms["word_mould"], name_mould_id)
    location = word_info[3]
    Text_shuoming:setString(location)
end

function SmActivityOtherRecruitCell:onInit()
    local csbActivity = csb.createNode("activity/wonderful/sm_vip_chouka_list.csb")
    local root = csbActivity:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)

    if SmActivityOtherRecruitCell.__size == nil then
        SmActivityOtherRecruitCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_2"):getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
    {
        terminal_name = "sm_activity_other_recruit_cell_choose", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self,
    },
    nil,0)

	self:updateDraw()
end

function SmActivityOtherRecruitCell:onEnterTransitionFinish()
end

function SmActivityOtherRecruitCell:init(params)
    self._mould_id = params[1]
    self._ship_star = params[2]
	self:onInit()
    self:setContentSize(SmActivityOtherRecruitCell.__size)
    return self
end

function SmActivityOtherRecruitCell:onExit()
end