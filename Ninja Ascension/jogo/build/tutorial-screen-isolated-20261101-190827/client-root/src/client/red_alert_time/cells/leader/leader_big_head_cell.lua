----------------------------------------------------------------------------------------------------
-- 说明：十连抽将领头像
-------------------------------------------------------------------------------------------------------
LeaderBigHeadCell = class("LeaderBigHeadCellClass", Window)
LeaderBigHeadCell.__size = nil

local leader_big_head_create_cell_terminal = {
    _name = "leader_big_head_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LeaderBigHeadCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_big_head_create_cell_terminal)
state_machine.init()

function LeaderBigHeadCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._ship_mould_id = nil

    self._get_prop_num = 0
    self._get_prop_type = 0

    app.load("client.utils.DrawHelper")
    local function init_leader_big_head_cell_terminal()

    end
    init_leader_big_head_cell_terminal()         
end


function LeaderBigHeadCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_big_head = ccui.Helper:seekWidgetByName(root, "Panel_big_head")     -- icon
    local Panel_leader_star = ccui.Helper:seekWidgetByName(root, "Panel_leader_star")         -- star
    local Text_leader_name = ccui.Helper:seekWidgetByName(root,"Text_leader_name")  -- name   
    Panel_big_head:removeBackGroundImage()
    Panel_leader_star:removeBackGroundImage()
    Panel_leader_star:removeAllChildren(true)
    Panel_big_head:removeAllChildren(true)

    if self._get_prop_num ~= nil and self._get_prop_type == 2 then
        self._ship_mould_id = dms.int(dms["prop_mould"], self._ship_mould_id, prop_mould.use_of_ship)
    end
    
    local pic_all_icon = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.All_icon)
    local pic_index = zstring.split(dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.head_icon), ",")
    local name = dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.captain_name)
    local ship_type = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.ship_type)
    local star_pic = tonumber(pic_index[5])

    Text_leader_name:setString(name)
    Panel_big_head:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic_all_icon))
    if self._get_prop_type ~= 10 then
        draw.addHeroStar(Panel_leader_star,ship_type)
    end

    root:removeBackGroundImage()
    root:setBackGroundImage(string.format(config_res.images.ui.icon.icon, ship_type + 100))
end

function LeaderBigHeadCell:onEnterTransitionFinish()

end

function LeaderBigHeadCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.leader.leader_big_head_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LeaderBigHeadCell.__size == nil then
        LeaderBigHeadCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function LeaderBigHeadCell:onExit()
    self:clearUIInfo()
    self:stopAllActions()
    cacher.freeRef(config_csb.cells.leader.leader_big_head_cell, self.roots[1])
end

function LeaderBigHeadCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function LeaderBigHeadCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.leader.leader_big_head_cell, root)
    self:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function LeaderBigHeadCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_big_head = ccui.Helper:seekWidgetByName(root, "Panel_big_head")
    local Panel_leader_star = ccui.Helper:seekWidgetByName(root, "Panel_leader_star")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root,"Text_leader_name")

    if Panel_big_head ~= nil then
        root:removeBackGroundImage()
        Panel_big_head:removeBackGroundImage()
        Panel_big_head:removeAllChildren(true)
        Panel_leader_star:removeBackGroundImage()
        Panel_leader_star:removeAllChildren(true)
        Text_leader_name:setString("")
    end
end

function LeaderBigHeadCell:init(params) 
    self._ship_mould_id = params[1]
    self._get_prop_num = params[2]
    self._get_prop_type = params[3]
    -- if index ~= nil and index < max_cout then
        self:onInit()
    -- end

    self:setContentSize(LeaderBigHeadCell.__size)

end

