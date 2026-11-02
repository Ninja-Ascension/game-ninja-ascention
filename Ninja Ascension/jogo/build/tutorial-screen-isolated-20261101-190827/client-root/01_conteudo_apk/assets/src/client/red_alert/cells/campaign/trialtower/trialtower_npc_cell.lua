--------------------------------------------------------------------------------------------------------------
--  说明：地图单个npc形象控件
--------------------------------------------------------------------------------------------------------------
TrialtowerNpcCell = class("TrialtowerNpcCellClass", Window)

--创建cell
local trialtower_npc_create_cell_terminal = {
    _name = "trialtower_npc_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local npc_id = params[1]
        local cell = TrialtowerNpcCell:new()
        cell:init(npc_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_npc_create_cell_terminal)
state_machine.init()

function TrialtowerNpcCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.npc_id = nil
     -- Initialize trialtower_npc_cell state machine.
    local function init_trialtower_npc_cell_terminal()
        -- npc 点击打开npc界面
        local trialtower_npc_cell_select_partner_terminal = {
            _name = "trialtower_npc_cell_select_partner",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local partner_npc_id = dms.string(dms["three_kingdoms_config"],_ED.three_kings_now_floor,three_kingdoms_config.partner_npc_id)
                partner_npc_id = zstring.split(partner_npc_id,",")
                state_machine.excute("trialtower_reinforcements_window_open",0,{partner_npc_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
    
        state_machine.add(trialtower_npc_cell_select_partner_terminal)
        state_machine.init()
    end
    
    -- call func trialtower_npc_cell create state machine.
    init_trialtower_npc_cell_terminal()
end

function TrialtowerNpcCell:updateDraw()
    local root = self.roots[1]
    local Text_npc_name = ccui.Helper:seekWidgetByName(root,"Text_npc_name")
    local Panel_npc_infor = ccui.Helper:seekWidgetByName(root,"Panel_npc_infor")
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    local Panel_npc_now = ccui.Helper:seekWidgetByName(root,"Panel_npc_now")
    local npc_name = dms.string(dms["npc"],self.npc_id,npc.npc_name)
    Text_npc_name:setString(npc_name)

    self:setVisible(true)
    Panel_npc_now:setVisible(true)
    Text_npc_name:setVisible(true)
    Panel_npc_infor:setVisible(true)

    local star = 0
    if zstring.tonumber(_ED.npc_state[tonumber(""..self.npc_id)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npc_id)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npc_id)]) ~= 0 then
        star = tonumber(_ED.npc_max_state[tonumber(""..self.npc_id)])
    else
        star = tonumber(_ED.npc_state[tonumber(""..self.npc_id)])
    end
    for i = 1 , star do
        local Image_npc_star = ccui.Helper:seekWidgetByName(root,"Image_npc_star_"..i)
        Image_npc_star:setVisible(true)
    end
    self:createNpcAnimation()
end

function TrialtowerNpcCell:addCurrentLevel(panle)
    local root = self.roots[1]
    self.actions[1]:play("pve_npc_in", false)
    local cell = state_machine.excute("duplicate_current_level_create_cell",0,"")
    local pos_y = cell:getPositionY()
    local height = panle:getContentSize().height
    cell:setPositionY(pos_y + height)
    panle:addChild(cell)
    if missionIsOver() == false then
        cell:setVisible(false)
    else
        cell:setVisible(true)
    end


    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    Panel_npc_role.show_cut_cell = cell
end

function TrialtowerNpcCell:showCurrentLevelSign()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    if Panel_npc_role.show_cut_cell ~= nil then
        Panel_npc_role.show_cut_cell:setVisible(true)
    end
end

function TrialtowerNpcCell:removeShortCutNpc()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    if Panel_npc_role.show_cut_cell ~= nil then
        Panel_npc_role.show_cut_cell:removeFromParent()
        Panel_npc_role.show_cut_cell = nil
    end
end

function TrialtowerNpcCell:showShortCutNpc()
    local root = self.roots[1]
    self.actions[1]:play("pve_npc_in", false)

    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    local cell = state_machine.excute("duplicate_current_level_create_cell",0,"")
    local pos_y = cell:getPositionY()
    local height = Panel_npc_role:getContentSize().height
    cell:setPositionY(pos_y + height)

    if missionIsOver() == false then
        cell:setVisible(false)
    else
        cell:setVisible(true)
    end

    Panel_npc_role:addChild(cell)
    Panel_npc_role.show_cut_cell = cell
end

function TrialtowerNpcCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.duplicate.duplicate_npc_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root) 

    local action = csb.createTimeline(config_csb.cells.duplicate.duplicate_npc_cell)
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("pve_npc_in_0", false)

    self:addNpcTouchEvent()
    self:updateDraw()
end

--创建npc形象
function TrialtowerNpcCell:createNpcAnimation()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")

    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["npc"], self.npc_id, npc.head_pic)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_npc_role, temp_bust_index,_spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_11+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_npc_role:getContentSize().width/2, 0))
    -- armature:setScaleX(-1)
    self:addCurrentLevel(Panel_npc_role)
end

--添加npc点击事件
function TrialtowerNpcCell:addNpcTouchEvent()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    fwin:addTouchEventListener(Panel_npc_role, nil, 
    {
        terminal_name = "trialtower_npc_cell_select_partner", 
        terminal_state = 0,
        cell = self,
    }, nil, 0)

end

--清除缓存
function TrialtowerNpcCell:close()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    Panel_npc_role:removeAllChildren(true)
end

function TrialtowerNpcCell:onEnterTransitionFinish()

end

function TrialtowerNpcCell:init(npc_id)
    self.npc_id = npc_id

    self:onInit()
end

function TrialtowerNpcCell:onExit()

end