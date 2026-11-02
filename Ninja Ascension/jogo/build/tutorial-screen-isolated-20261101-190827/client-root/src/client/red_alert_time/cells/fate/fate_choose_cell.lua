--------------------------------------------------------------------------------------------------------------
--  说明：祭祀宝石选择cell
--------------------------------------------------------------------------------------------------------------
FateChooseCell = class("FateChooseCellClass", Window)
FateChooseCell.__size = nil

--创建cell
local fate_choose_create_cell_terminal = {
    _name = "fate_choose_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local magic_beg_id = params[1]
        local index = params[2]
        local select_page_index = params[3]
        local cell = FateChooseCell:new()
        cell:init(magic_beg_id ,index ,select_page_index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fate_choose_create_cell_terminal)
state_machine.init()

function FateChooseCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.magic_beg_id = nil
    self.index = nil
    self.select_page_index = nil 

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")

   -- Initialize Fate machine.
    local function init_fate_choose_cell_terminal()
        --确认选择
        local fate_choose_cell_sure_terminal = {
            _name = "fate_choose_cell_sure",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("fate_choose_change_select_page",0,cell.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
   
        state_machine.add(fate_choose_cell_sure_terminal)
        state_machine.init()
    end

    -- call func init fate machine.
    init_fate_choose_cell_terminal()    
end

function FateChooseCell:updateDraw()
    local root = self.roots[1]
    self:drawGems()
end

function FateChooseCell:setSelect()
    local root = self.roots[1]
    local Image_choose_frame = ccui.Helper:seekWidgetByName(root,"Image_choose_frame")
    -- print("==============",self.select_page_index,self.index)
    if self.select_page_index == self.index then
        Image_choose_frame:setVisible(true)
    else
        Image_choose_frame:setVisible(false)
    end
end

function FateChooseCell:drawGems()
    local root = self.roots[1]
    local magic_beg_id = self.magic_beg_id
    local drop_show = dms.string(dms["magic_beg"],magic_beg_id,magic_beg.drop_show)
    local ship_mould_id = dms.string(dms["magic_beg"],magic_beg_id,magic_beg.ship_mould_id)
    local Panel_genral_picture = ccui.Helper:seekWidgetByName(root,"Panel_genral_picture")

    -- print("==========",ship_mould_id)
    local name = dms.string(dms["ship_mould"],ship_mould_id,ship_mould.captain_name)
    local hero_data = {
        item_value = 1,
        prop_type = 13,
        prop_item = ship_mould_id,
    }
    local herocell = state_machine.excute("hero_icon_create_cell",0,{ship_mould_id,4,0})
    Panel_genral_picture:addChild(herocell)
    -- print("============",drop_show)
    local drop_show_table = zstring.split(drop_show,"|")
    -- debug.print_r(drop_show_table)
    for i,v in pairs(drop_show_table) do
        local temp = zstring.split(v,",")
        local gem_mould_id = temp[1]
        local gem_prop_type = temp[2]
        local gem_dec = temp[3]
        local data = {
            item_value = 1,
            prop_type = gem_prop_type,
            prop_item = gem_mould_id
        }
        local data_dec = {
            item_value = 1,
            prop_type = gem_prop_type,
            prop_item = gem_mould_id,
            dec = gem_dec,
            name = gems_type_name[dms.int(dms["gems_mould"],gem_mould_id,gems_mould.gem_type)]
        }

        -- print("============",i)
        local Panel_gem = ccui.Helper:seekWidgetByName(root,"Panel_gem_"..i)
        Panel_gem:removeAllChildren(true)
        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data_dec,12,0,false,false})
        Panel_gem:addChild(cell)
    end

    self:setSelect()
end

function FateChooseCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.fate.fate_choose_cell)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    if FateChooseCell.__size == nil then
        FateChooseCell.__size = root:getContentSize()
    end
    --换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_fate_choose_cell"), nil, 
    {
        terminal_name = "fate_choose_cell_sure", 
        terminal_state = 0,
        cell = self,
    },
    nil,0)


    self:updateDraw()
end

function FateChooseCell:onEnterTransitionFinish()

end

--清除缓存
function FateChooseCell:close()
    
end

function FateChooseCell:init( magic_beg_id ,index ,select_page_index)
    self.magic_beg_id = magic_beg_id
    self.index = index
    self.select_page_index = select_page_index
	self:onInit()
    self:setContentSize(FateChooseCell.__size)
end

function FateChooseCell:onExit()
    local Panel_genral_picture = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_genral_picture")
    if Panel_genral_picture ~= nil then
        Panel_genral_picture:removeAllChildren(true)
    end
end