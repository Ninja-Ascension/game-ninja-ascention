----------------------------------------------------------------------------------------------------
-- 说明：商店道具cell
-------------------------------------------------------------------------------------------------------
PropsShopPacksShopCell = class("PropsShopPacksShopCellClass", Window)
PropsShopPacksShopCell.__size = nil

local props_shop_packs_shop_cell_create_terminal = {
    _name = "props_shop_packs_shop_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PropsShopPacksShopCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_shop_packs_shop_cell_create_terminal)
state_machine.init()

function PropsShopPacksShopCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._base_avatar_shop_info = nil
    self._index = 0
    self._prop_id = 0

    app.load("client.red_alert_time.props.PropsBatchBuy")
    app.load("client.red_alert_time.props.PropsInforPrompt")
    local function init_props_shop_packs_shop_cell_terminal()
        -- 使用
        local props_shop_packs_shop_cell_props_use_terminal = {
            _name = "props_shop_packs_shop_cell_props_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("props_batch_buy_window_open", 0, {cell._prop_id, cell._base_avatar_shop_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 道具详情
        local props_shop_packs_shop_cell_props_info_terminal = {
            _name = "props_shop_packs_shop_cell_props_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("props_infor_prompt_window_open", 0, {cell._prop_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local props_shop_packs_shop_cell_update_info_terminal = {
            _name = "props_shop_packs_shop_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell._base_avatar_shop_info = params.info
                cell._pack_type = params.pack_type
                cell._index = params.index
                if cell._base_avatar_shop_info ~= nil then
                    cell._prop_id = cell._base_avatar_shop_info.prop[1]
                    if tonumber(cell._prop_id) < 0 then
                        cell._prop_id = resource_prop_id[tonumber(cell._base_avatar_shop_info.prop[2])]
                    end
                    if cell._index <= 7 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_shop_packs_shop_cell_props_use_terminal)
        state_machine.add(props_shop_packs_shop_cell_props_info_terminal)
        state_machine.add(props_shop_packs_shop_cell_update_info_terminal)
        state_machine.init()
    end
    init_props_shop_packs_shop_cell_terminal()          
end

function PropsShopPacksShopCell:onUpdateDraw()
    local root = self.roots[1]
    -- 道具icon
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,1,self._prop_id,1})
    Panel_props_icon:addChild(cell) 
    -- 道具名字
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    Text_props_name:setString(prop_name)
    if __lua_project_id == __lua_project_pacific_rim then
        local prop_quality = dms.int(dms["prop_mould"], self._prop_id, prop_mould.prop_quality)
        Text_props_name:setColor(cc.c3b(color_Type[prop_quality + 1][1], color_Type[prop_quality + 1][2], color_Type[prop_quality + 1][3]))
    end
    -- 道具描述
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local remarks = dms.string(dms["prop_mould"], self._prop_id, prop_mould.remarks)
    Text_props_infor:setString(remarks)
    
    -- 花费金币
    local Text_consume_gold_n = ccui.Helper:seekWidgetByName(root,"Text_consume_gold_n") 
    local shop_of_gold = self._base_avatar_shop_info.cost_gold
    local sell_tag = dms.int(dms["prop_mould"], self._prop_id, prop_mould.sell_tag)
    if sell_tag > 0 then
        if _ED.world_map ~= nil then
            local store_addition = dms.string(dms["world_level_addition_param"], zstring.tonumber(_ED.world_level), world_level_addition_param.store_addition)
            shop_of_gold = math.ceil(tonumber(shop_of_gold)*(1-tonumber(store_addition)))
        end
    end
    
    Text_consume_gold_n:setString(""..shop_of_gold)
end

function PropsShopPacksShopCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.props.props_shop_packs_shop_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if PropsShopPacksShopCell.__size == nil then
        PropsShopPacksShopCell.__size = root:getContentSize()
    end

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_use"), nil, 
    {
        terminal_name = "props_shop_packs_shop_cell_props_use",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    -- 道具详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_icon"), nil, 
    {
        terminal_name = "props_shop_packs_shop_cell_props_info",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    self:onUpdateDraw()
end

function PropsShopPacksShopCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.props_shop_packs_shop_cell,  self.roots[1])
end

function PropsShopPacksShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PropsShopPacksShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.props_shop_packs_shop_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function PropsShopPacksShopCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local Text_consume_gold_n = ccui.Helper:seekWidgetByName(root,"Text_consume_gold_n")

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Text_props_name:setString("")
        Text_props_infor:setString("")
        Text_consume_gold_n:setString("")
    end
end

function PropsShopPacksShopCell:init(params)
    self._index = params[1]
    self._base_avatar_shop_info = params[2]
    self._pack_type = params[3]
    self._prop_id = self._base_avatar_shop_info.prop[1]
    if tonumber(self._prop_id) < 0 then
        self._prop_id = resource_prop_id[tonumber(self._base_avatar_shop_info.prop[2])]
    end
    if self._index <= 7 then
        self:onInit()
    end
    self:setContentSize(PropsShopPacksShopCell.__size)
end

