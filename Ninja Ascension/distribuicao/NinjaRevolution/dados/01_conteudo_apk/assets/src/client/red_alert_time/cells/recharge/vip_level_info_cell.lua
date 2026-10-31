----------------------------------------------------------------------------------------------------
-- 说明：vip等级信息cell
-------------------------------------------------------------------------------------------------------
VipLevelInfoCell = class("VipLevelInfoCellClass", Window)
VipLevelInfoCell.__size = nil

local vip_level_info_cell_create_terminal = {
    _name = "vip_level_info_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = VipLevelInfoCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(vip_level_info_cell_create_terminal)
state_machine.init()

function VipLevelInfoCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0

 	local function init_vip_level_info_cell_terminal()
        local vip_level_info_cell_look_info_terminal = {
            _name = "vip_level_info_cell_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("leader_info_window_open", 0, {})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(vip_level_info_cell_look_info_terminal)
        state_machine.init()
    end
	-- init_vip_level_info_cell_terminal()        	
end

function VipLevelInfoCell:onUpdateDraw()
	local root = self.roots[1]
    local ListView_vip_infor = ccui.Helper:seekWidgetByName(root, "ListView_vip_infor")

    local text_str = zstring.split(_vip_privilege_info[self._index], "|")
    for i,v in pairs(text_str) do
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        local text_str_color = zstring.split(v,";")
        for j,k in pairs(text_str_color) do
            if tonumber(j) == 2 then 
                local re = ccui.RichElementText:create(1, cc.c3b(color_Type[26][1],color_Type[26][2],color_Type[26][3]),255, k, config_res.font.font_name, 20)
                _richText:pushBackElement(re)
            else
                local re = ccui.RichElementText:create(1, cc.c3b(color_Type[25][1],color_Type[25][2],color_Type[25][3]),255, k, config_res.font.font_name, 20)
                _richText:pushBackElement(re)
            end
        end
        _richText:setAnchorPoint(0.5,0.5)
        _richText:setContentSize(cc.size(ListView_vip_infor:getContentSize().width,20))
        ListView_vip_infor:addChild(_richText)
    end
    ListView_vip_infor:requestRefreshView()
end

function VipLevelInfoCell:onEnterTransitionFinish()

end

function VipLevelInfoCell:onInit()
	local csbItem = csb.createNode(config_csb.shop.vip_privilege_tab_1_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)   
    
	if VipLevelInfoCell.__size == nil then
		VipLevelInfoCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function VipLevelInfoCell:onExit()
    cacher.freeRef(config_csb.shop.vip_privilege_tab_1_listview, self.roots[1])
end

function VipLevelInfoCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function VipLevelInfoCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.shop.vip_privilege_tab_1_listview, root)
    root:removeFromParent(false)
    self.roots = {}
end

function VipLevelInfoCell:init(params)
    self._index = params[1]
    -- if self._index < 6 then
    	self:onInit()
    -- end
	self:setContentSize(VipLevelInfoCell.__size)
end

