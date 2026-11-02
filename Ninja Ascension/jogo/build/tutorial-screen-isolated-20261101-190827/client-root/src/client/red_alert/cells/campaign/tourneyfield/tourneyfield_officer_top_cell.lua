--------------------------------------------------------------------------------------------------------------
--  角色
--------------------------------------------------------------------------------------------------------------
TourneyfieldOfficerTopCell = class("TourneyfieldOfficerTopCellClass", Window)
TourneyfieldOfficerTopCell.__size = nil

--创建cell
local tourneyfield_officer_top_create_cell_terminal = {
    _name = "tourneyfield_officer_top_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = TourneyfieldOfficerTopCell:new()
        local user_data = params[1]
        cell:init(user_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(tourneyfield_officer_top_create_cell_terminal)
state_machine.init()

function TourneyfieldOfficerTopCell:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {}

    --var 
    self._user_data = nil
    self._pk_action = false
        -- Initialize tourneyfield_officer_top_cell state machine.
    local function init_tourneyfield_officer_top_cell_terminal()

        state_machine.init()
    end

    -- call func init hom state machine.
    init_tourneyfield_officer_top_cell_terminal()
end

function TourneyfieldOfficerTopCell:onUpdateDraw()
    local root = self.roots[1]
    local user_name = nil
    local user_sex = nil
    local user_fight = nil
    local Text_combat_number = ccui.Helper:seekWidgetByName(root,"Text_combat_number")
    local Text_combat = ccui.Helper:seekWidgetByName(root,"Text_combat")
    if tonumber(_ED.arena_info.arena_id) == tonumber(self._user_data.user_arena_id) then
        user_name = _ED.user_info.user_name
        user_sex = _ED.user_info.user_gender
        user_fight = _ED.user_info.fighter_capacity
        Text_combat_number:setVisible(true)
        Text_combat:setVisible(true)
    else
        user_name = self._user_data.user_name
        user_sex = self._user_data.user_sex
        user_fight = self._user_data.user_fight
        Text_combat_number:setVisible(false)
        Text_combat:setVisible(false)
    end
    -- 玩家名 - 官阶
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local arena_name = dms.string(dms["arena_reward_param"],self._user_data.user_arena_id,arena_reward_param.arena_name)
    arena_name = zstring.split(arena_name,",")
    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
    Text_name:setString(user_name.."【"..arena_name.."】")
    
    -- 战力
    Text_combat_number:setString(user_fight)

    -- 角色动画
    local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")
    Panel_role:removeAllChildren(true)
    if tonumber(user_sex) == 1 then     --男角色
    	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			Panel_role:setBackGroundImage("images/ui/bg/nanzhujuesl1.png")
			Panel_role:setPosition(cc.p(Panel_role:getPositionX()-Panel_role:getContentSize().width/4,Panel_role:getPositionY()+Panel_role:getContentSize().height/6))
		else
			local jsonPath = "sprite/nanz_h.json"
			local atlasPath = "sprite/nanz_h.atlas"
			local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
			animation:setPosition(cc.p(Panel_role:getContentSize().width/2,0))
			Panel_role:addChild(animation)
		end
    else  --女角色
    	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			Panel_role:setBackGroundImage("images/ui/bg/nvzhudj9_1.png")
		else
			local jsonPath = "sprite/nvz_h.json"
	        local atlasPath = "sprite/nvz_h.atlas"
	        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
	        animation:setPosition(cc.p(Panel_role:getContentSize().width/2,0))
	        Panel_role:addChild(animation)
		end
    end
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		Panel_role:setScale(0.35)
	end
end


function TourneyfieldOfficerTopCell:onInit()
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.campaign.tourneyfield.tourneyfield_officer_top_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if TourneyfieldOfficerTopCell.__size == nil then
        TourneyfieldOfficerTopCell.__size = root:getContentSize()
    end

    self:setContentSize(TourneyfieldOfficerTopCell.__size)
    self:onUpdateDraw(params)
end

function TourneyfieldOfficerTopCell:init(user_data)
    self._user_data = user_data
    -- debug.print_r(user_data)
    self:onInit()
    return self
end

function TourneyfieldOfficerTopCell:onExit()

end