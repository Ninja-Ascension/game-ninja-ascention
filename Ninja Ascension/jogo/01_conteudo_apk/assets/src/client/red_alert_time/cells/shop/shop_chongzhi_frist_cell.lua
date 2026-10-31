--------------------------------------------------------------------------------------------------------------
--  说明：充值首冲shop的cell
--------------------------------------------------------------------------------------------------------------
ShopChongzhiFristCell = class("ShopChongzhiFristCellClass", Window)
ShopChongzhiFristCell.__size = nil
--创建cell
local shop_chongzhi_frist_cell_terminal = {
    _name = "shop_chongzhi_frist_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ShopChongzhiFristCell:new()
        cell:init()
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(shop_chongzhi_frist_cell_terminal)
state_machine.init()

function ShopChongzhiFristCell:ctor()
	self.super:ctor()
	self.roots = {}

	 -- Initialize mystery_shop_cell state machine.
    local function init_mystery_shop_cell_terminal()
        state_machine.init()
    end
    
    init_mystery_shop_cell_terminal()
end

function ShopChongzhiFristCell:updateDraw()
    local root = self.roots[1]
    local ListView_rebel_reward = ccui.Helper:seekWidgetByName(root,"ListView_rebel_reward")
    ListView_rebel_reward:removeAllItems()
    if _ED.activity_info["2"] == nil then
        return
    end
    for i, v in pairs(_ED.activity_info["2"].activity_data[1]) do
        local reward_items = v.achieve_reward
        reward_items = zstring.split(reward_items,"|")
        for i,reward in ipairs(reward_items) do
            -- local reward_tab = zstring.split(reward,",")
            local datas = zstring.split(reward, ",")
            if tonumber(datas[1]) == -1 then
                datas[1] = resource_prop_id[tonumber(datas[2])]
                datas[2] = 1
            end
            local prop_type = tonumber(datas[2])
            local show_type = 9
            local prop_from_type = 3
            if tonumber(datas[2]) == 13 then --坦克
                prop_type = 3
                prop_from_type = 10
            elseif tonumber(datas[2]) == 6 then --道具    
                prop_type = 1
                prop_from_type = 1
            elseif tonumber(datas[2]) == 7 then --配件    
                prop_type = 7
                prop_from_type = 3
            else
                prop_type = 1
                prop_from_type = 1
            end
            -- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
            local cell = nil
            if prop_type == 7 then
                local equip_datas = {}
                equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
                equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
                cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
            else
                cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
                if tonumber(datas[1]) == 2 then
                    ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString(activity_str_tip[47])
                end    
            end
            if tonumber(datas[3]) <= 0 then
                ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
                ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
            else
                ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(true)
                ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(true)
            end
            -- ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
            -- ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
            cell.roots[1]:setPositionX(10)
            ListView_rebel_reward:addChild(cell)
        end
    end
    ListView_rebel_reward:requestRefreshView()
   
end

function ShopChongzhiFristCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.shop.shop_chongzhi_frist_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    if ShopChongzhiFristCell.__size == nil then
        ShopChongzhiFristCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function ShopChongzhiFristCell:onEnterTransitionFinish()

end

function ShopChongzhiFristCell:init()
	self:onInit()
    self:setContentSize(ShopChongzhiFristCell.__size)
end

function ShopChongzhiFristCell:clearUIInfo( ... )
    local root = self.roots[1]
    
end

function ShopChongzhiFristCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.shop.shop_chongzhi_frist_cell)
end

function ShopChongzhiFristCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ShopChongzhiFristCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.shop.shop_chongzhi_frist_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end