-----------------------------
--宝物浮动详细信息
-----------------------------
PropsInformationHorse = class("PropsInformationHorseClass", Window)
PropsInformationHorse.__size = nil

--打开
local props_information_horse_window_open_terminal = {
    _name = "props_information_horse_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("PropsInformationHorseClass")
        if nil == _Window then
            local prop = params[1]
            local pos = params[2]
            fwin:open(PropsInformationHorse:new():init(prop,pos), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭
local props_information_horse_window_close_terminal = {
    _name = "props_information_horse_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsInformationHorseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_information_horse_window_open_terminal)
state_machine.add(props_information_horse_window_close_terminal)
state_machine.init()

function PropsInformationHorse:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize props_information_horse state machine.
    local function init_props_information_horse_terminal()

        state_machine.init()
    end
    
    -- call func init props_information_horse machine.
    init_props_information_horse_terminal()
end

--更新画面
function PropsInformationHorse:onUpdateDraw()
    local root = self.roots[1]
    local ListView_props_information = ccui.Helper:seekWidgetByName(root, "ListView_props_information")
    ListView_props_information:removeAllItems()
    local name = dms.string(dms["horse_mould"],self.prop.prop_item,horse_mould.horse_name)
    local quality  = dms.int(dms["horse_mould"],self.prop.prop_item,horse_mould.quality)
    local Text_props_infor_name = ccui.Helper:seekWidgetByName(root,"Text_props_infor_name")        --名称
    local Image_props_infor_bg = ccui.Helper:seekWidgetByName(root,"Image_props_infor_bg_"..quality)    --品质背景颜色
    Image_props_infor_bg:setVisible(true)
    Text_props_infor_name:setString(name)
    Text_props_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    --道具icon
    local Panel_props_infor_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_infor_icon")   
    local data = {
        item_value = 1,
        prop_type = 35,
        prop_item = self.prop.prop_item,
    }
    local cell = state_machine.excute("all_resource_create_cell",0,{6,data,data,8,0,false,false}) 
    Panel_props_infor_icon:addChild(cell)   
    --属性
    local horse = _ED.horses[""..self.prop_id]
    local infos = zstring.split(horse.attribute, "|")
    local info = ""
    local Text_infor_name_1 = nil
    local Text_infor_add_1  = nil
    local Text_infor_name_2 = nil
    local Text_infor_add_2  = nil
    for k,v in pairs(infos) do
        local spirit_info = zstring.split(v, ",")
        if (k % 2) ~= 0 then
            csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_6)
            root1 = csbItem:getChildByName("root")
            root1:removeFromParent(false)
            ListView_props_information:addChild(root1)
            Text_infor_name_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_1")
            Text_infor_add_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_1")
            Text_infor_name_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_2")
            Text_infor_add_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_2")
            Text_infor_name_1:setString(attribute[tonumber(spirit_info[1]) + 1])
            Text_infor_add_1:setString("+"..spirit_info[2].."%")
            Text_infor_name_2:setString("")
            Text_infor_add_2:setString("")
        else
            Text_infor_name_2:setString(attribute[tonumber(spirit_info[1]) + 1])
            Text_infor_add_2:setString("+"..spirit_info[2].."%")
        end
    end
    --星级
    local Panel_poros_star = ccui.Helper:seekWidgetByName(root, "Panel_poros_star")
    local star = dms.int(dms["horse_mould"], self.prop.prop_item, horse_mould.star)
    Panel_poros_star:removeAllChildren(true)
    draw.addHeroStar(Panel_poros_star, star, quality)
end

function PropsInformationHorse:onEnterTransitionFinish()

end

--初始化界面
function PropsInformationHorse:onInit( )
    local csbItem = csb.createNode(config_csb.utils.props_information_1)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    if PropsInformationHorse.__size == nil then
        PropsInformationHorse.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_infor"), nil, 
    {
        terminal_name = "props_information_horse_window_close", 
        terminal_state = 0, 
    }, nil, 0)

	self:onUpdateDraw()	

end

--初始化
function PropsInformationHorse:init(prop,pos)
    self.prop = prop
    self.prop_id = prop.prop_id
	self:onInit()
    self:setContentSize(PropsInformationHorse.__size)
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x,(fwin._width - PropsInformationHorse.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y,(fwin._height - PropsInformationHorse.__size.height))
    self:setPosition(cc.p(x,y))
    return self
end

function PropsInformationHorse:onExit()

end
