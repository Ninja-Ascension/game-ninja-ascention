--[[ ----------------------------------------------------------------------------
-- 超级扫荡一级cell
--]] ----------------------------------------------------------------------------
PveSuperMoppingCell = class("PveSuperMoppingCellClass", Window)
PveSuperMoppingCell.__size = nil

-- 创建Cell实例
local pve_super_mopping_cell_create_terminal = {
    _name = "pve_super_mopping_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if PveSuperMoppingCell then
            local cell = PveSuperMoppingCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_super_mopping_cell_create_terminal)
state_machine.init()

-- 构造器
function PveSuperMoppingCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------
    -- 当前章节ID
    self.current_chapter_id = 0

    -- 当前NPC数据
    -- {
    --   npc_star:numer[]  关卡通关星级
    --   npc_id:numer[]    关卡npcID
    -- }
    -- CON LAS DOS LISTAS PUESTAS, no vacio. La linea 114 hace
    -- `#self.npc_info.npc_ids` sin comprobar nil, y con un capitulo
    -- recien abierto la guarda de la linea 67 (`#npc_ids > 0`) es FALSA
    -- y deja aqui el `{}` del constructor: reventaba siempre al abrir
    -- Super Rush con 0, 1 o 2 etapas superadas en historia, o con 0 en
    -- elite. Asi la celda pinta el capitulo con la lista vacia, que es
    -- la verdad: ahi no hay nada que barrer.
    self.npc_info = {npc_stars = {}, npc_ids = {}}

    self.item_infos = {}

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------
    app.load("client.cells.duplicate.pve_super_mopping_info_cell")

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_pve_super_mopping_cell_terminal()
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_pve_super_mopping_cell_terminal()
end

-- 对象初始化
function PveSuperMoppingCell:init(current_chapter_id, npc_info)
    if current_chapter_id > 0 then
        self.current_chapter_id = current_chapter_id
    end

    if npc_info ~= nil and #(npc_info.npc_ids) > 0 then
        self.npc_info = npc_info
    end

    self:onInit()
    self:setContentSize(PveSuperMoppingCell.__size)

    return self
end

function PveSuperMoppingCell:onInit()
    -- 加载PveSuperMoppingCell界面资源.
    -- res.duplicate.pve_super_mopping_cell = duplicate/pve_super_mopping_cell.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("duplicate/pve_super_mopping_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("duplicate/pve_super_mopping_cell.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if PveSuperMoppingCell.__size == nil then
        PveSuperMoppingCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function PveSuperMoppingCell:createCell()
    local cell = PveSuperMoppingCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function PveSuperMoppingCell:onUpdateDraw()
    local root = self.roots[1]

    self.Text_chapter = ccui.Helper:seekWidgetByName(root, "Text_chapter")
    local pve_scene_info = dms.atos(dms["pve_scene"], self.current_chapter_id)
    self.Text_chapter:setString(pve_scene_info[pve_scene.scene_name])

    -- 创建列表
    self.item_infos = {}
    local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
    listView:removeAllItems()
    if self.npc_info ~= nil and #self.npc_info.npc_ids > 0 then
        for i = 1, #self.npc_info.npc_ids do
            table.insert(self.item_infos, {npc_star = self.npc_info.npc_stars[i], npc_id = self.npc_info.npc_ids[i]})
        end

        self:asyncCreateItem()
    end
end

function PveSuperMoppingCell:asyncCreateItem()
    local temp_info_items = self.item_infos
    local length = #self.item_infos
    self:stopAllActions()
    self:runAction(
        cc.Sequence:create(
            {
                cc.DelayTime:create(0.01),
                cc.CallFunc:create(
                    function(sender)
                        if (length > 0) then
                            local cell_info = temp_info_items[1]
                            length = length - 1
                            table.remove(self.item_infos, 1)
                            self:createItem(cell_info.npc_star, cell_info.npc_id)
                        end

                        if (length > 0) then
                            self:asyncCreateItem()
                        end
                    end
                )
            }
        )
    )
end

function PveSuperMoppingCell:createItem(npc_star, npc_id)
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
    local cell = PveSuperMoppingInfoCell:createCell()
    cell:init(npc_star, npc_id, self.current_chapter_id)
    listView:addChild(cell)
    listView:requestRefreshView()
end

function PveSuperMoppingCell:onEnterTransitionFinish()
end

function PveSuperMoppingCell:onExit()
    -- 释放PveSuperMoppingCell界面资源.
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("duplicate/pve_super_mopping_cell.csb", root)
    -- ]]
end

function PveSuperMoppingCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PveSuperMoppingCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("duplicate/pve_super_mopping_cell.csb", root)

    self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
