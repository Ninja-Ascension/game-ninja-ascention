--------------------------------------------------------------------------------------------------------------
--  角色
--------------------------------------------------------------------------------------------------------------
TourneyfieldOfficerCell = class("TourneyfieldOfficerCellClass", Window)
TourneyfieldOfficerCell.__size = nil

--创建cell
local tourneyfield_officer_create_cell_terminal = {
    _name = "tourneyfield_officer_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = TourneyfieldOfficerCell:new()
        local user_data = params[1]
        cell:init(user_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(tourneyfield_officer_create_cell_terminal)
state_machine.init()

function TourneyfieldOfficerCell:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {}

    --var 
    self._user_data = nil
    self._pk_action = false
        -- Initialize tourneyfield_officer_cell state machine.
    local function init_tourneyfield_officer_cell_terminal()
        --选择npc播放光效
        local tourneyfield_officer_cell_play_npc_action_terminal = {
            _name = "tourneyfield_officer_cell_play_npc_action",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                cell:playNPCAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        state_machine.add(tourneyfield_officer_cell_play_npc_action_terminal)
        state_machine.init()
    end

    -- call func init hom state machine.
    init_tourneyfield_officer_cell_terminal()
end

function TourneyfieldOfficerCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")
    Panel_role:removeAllChildren(true)
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local Text_combat_number = ccui.Helper:seekWidgetByName(root,"Text_combat_number")
    Text_name:setString(self._user_data.user_name)
    Text_combat_number:setString(self._user_data.user_fight)

    if self._user_data.user_sex == 1 then
        local jsonPath = "sprite/spirte_nanzhu.json"
        local atlasPath = "sprite/spirte_nanzhu.atlas"
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_role:getContentSize().width/2,0))
        Panel_role:addChild(animation)
    else
        local jsonPath = "sprite/spirte_nvzhu.json"
        local atlasPath = "sprite/spirte_nvzhu.atlas"
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_role:getContentSize().width/2,0))
        Panel_role:addChild(animation)
    end

    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    Text_lv:setString(self._user_data.user_level)
    self:playAction()
end

--进入界面播放光效
function TourneyfieldOfficerCell:playAction()
    local root = self.roots[1]
    local Panel_in = ccui.Helper:seekWidgetByName(root, "Panel_in")
    local ArmatureNode_in = Panel_in:getChildByName("ArmatureNode_in")
    Panel_in:setVisible(true)
    local animation = ArmatureNode_in:getAnimation()
    animation:playWithIndex(0, 0, 0)
end

--选择npc光效
function TourneyfieldOfficerCell:playNPCAction()
    local root = self.roots[1]
    local Panel_in_pk = ccui.Helper:seekWidgetByName(root, "Panel_in_pk")
    local ArmatureNode_pk = Panel_in_pk:getChildByName("ArmatureNode_pk")
    Panel_in_pk:setVisible(self._pk_action)
    local animation = ArmatureNode_pk:getAnimation()
    animation:playWithIndex(0, 0, -1)
end

function TourneyfieldOfficerCell:onInit()
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.campaign.tourneyfield.tourneyfield_officer_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if TourneyfieldOfficerCell.__size == nil then
        TourneyfieldOfficerCell.__size = root:getContentSize()
    end

    self:setContentSize(TourneyfieldOfficerCell.__size)
    self:onUpdateDraw(params)
end

function TourneyfieldOfficerCell:init(user_data)
    self._user_data = user_data
    -- debug.print_r(user_data)
    self:onInit()
    return self
end

function TourneyfieldOfficerCell:onExit()

end