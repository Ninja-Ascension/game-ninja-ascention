-----------------------------
--浮动详细信息
-----------------------------
PropsInformation = class("PropsInformationClass", Window)
PropsInformation.__size = nil

--打开
local props_information_window_open_terminal = {
    _name = "props_information_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("PropsInformationClass")
        if nil == _Window then
            local prop_show_type = params[1]
            local prop_data = params[2]
            local prop = params[3]
            local prop_from_type = params[4]
            local index = params[5]
            local show_name = params[6]
            local show_numbers = params[7]
            local pos = params[8]
            fwin:open(PropsInformation:new():init(prop_show_type,prop_data,prop,prop_from_type,index,show_name,show_numbers,pos), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭
local props_information_window_close_terminal = {
    _name = "props_information_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsInformationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_information_window_open_terminal)
state_machine.add(props_information_window_close_terminal)
state_machine.init()

function PropsInformation:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file

    
    --var
    --
    self.prop_show_type = nil
    --
    self.prop_data = nil
    --
    self.prop = nil
    --
    self.prop_from_type = nil
    --道具类型
    self.prop_type = nil
    --道具数量
    self.prop_numbers = nil
    --道具ID
    self.prop_id = nil
    --道具名字
    self.prop_name = ""

    -- Initialize props_information state machine.
    local function init_props_information_terminal()

        state_machine.init()
    end
    
    -- call func init props_information machine.
    init_props_information_terminal()
end

--更新画面
function PropsInformation:onUpdateDraw()
    local root = self.roots[1]

    local Panel_props_infor_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_infor_icon")      --道具icon
    local Text_props_infor_name = ccui.Helper:seekWidgetByName(root,"Text_props_infor_name")        --名称
    local Text_props_infor_number = ccui.Helper:seekWidgetByName(root,"Text_props_infor_number")    --数量
    local Text_props_information = ccui.Helper:seekWidgetByName(root,"Text_props_information")      --道具功能备注
    
    -- debug.print_r(self.prop_data)
    -- debug.print_r(self.prop)
    local cell = state_machine.excute("all_resource_create_cell",0,{self.prop_show_type,self.prop_data,self.prop,9,0,false,false})
    Panel_props_infor_icon:addChild(cell)
    local prop_type = self.prop_data.prop_type
    local dec = ""
    local prop_id = self.prop_id
    --判断类型
    local quality = 4
    if tonumber(prop_type) == 6 then        --道具
        name = self.prop.prop_name or dms.string(dms["prop_mould"],prop_id,prop_mould.prop_name)
        quality = dms.int(dms["prop_mould"],prop_id,prop_mould.prop_quality)   
        dec = self.prop.prop_function_remark or dms.string(dms["prop_mould"],prop_id,prop_mould.remarks)
    elseif tonumber(prop_type) == 7 then    --装备
        name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
        dec = self.prop.equiment_track_remark or dms.string(dms["equipment_mould"],prop_id,equipment_mould.trace_remarks)
    elseif tonumber(prop_type) == 13 then   --英雄
        name = dms.string(dms["ship_mould"],prop_id,ship_mould.captain_name)
        quality  = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)  
        dec = dms.string(dms["ship_mould"],prop_id,ship_mould.introduce)  
    elseif tonumber(prop_type) == 34 then   --宝石
        name = dms.string(dms["gems_mould"],prop_id,gems_mould.name)
        quality  = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
        local add_attribute  = dms.string(dms["gems_mould"],prop_id,gems_mould.add_attribute)
        add_attribute = zstring.split(add_attribute,",")
        local text_title = tonumber(add_attribute[1])
        text_title = attribute[text_title+1]
        local text_str = tonumber(add_attribute[2])
        text_str = "  +" .. text_str
        dec = ""

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
         local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, text_title, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
         local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, text_str, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_props_information:getContentSize().width/2,Text_props_information:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_props_information:getContentSize().width,18))
        Text_props_information:addChild(_richText)
    elseif tonumber(prop_type) == 1 then    --金币
        name = _my_gane_name[1]     
        dec = _All_tip_string_info_description._fundNameDescription
    elseif tonumber(prop_type) == 2 then    --钻石
        name = _my_gane_name[2]
        dec = _All_tip_string_info_description._crystalNameDescription  
    elseif tonumber(prop_type) == 3 then
        name = _my_gane_name[3]
        dec = _All_tip_string_info_description._reputationDescription    
    elseif tonumber(prop_type) == 5 then    --英魂
        name = _my_gane_name[5]
        dec = _All_tip_string_info_description._soulJadeNameDescription  
    elseif tonumber(prop_type) == 12 then   --体力
        name = _my_gane_name[9]
        dec = _All_tip_string_info_description._physicalStrengthDescription  
    elseif tonumber(prop_type) == 28 then   --军团贡献
        name = _my_gane_name[16]
        dec = _All_tip_string_info_description._unionContributionDescription  
    elseif tonumber(prop_type) == 31 then   --军功
        name = red_alert_resouce_tip[1][1]
        dec = red_alert_resouce_tip[1][2]
    elseif tonumber(prop_type) == 32 then   --粮草
        name = red_alert_resouce_tip[2][1]
        dec = red_alert_resouce_tip[2][2]
    elseif tonumber(prop_type) == 33 then   --木材
        name = _my_gane_name[13]
        dec = red_alert_all_str[143]       
    elseif tonumber(prop_type) == 35 then   --马
        name = dms.string(dms["horse_mould"],prop_id,horse_mould.horse_name)
        quality  = dms.int(dms["horse_mould"],prop_id,horse_mould.quality)
    elseif tonumber(prop_type) == 36 then   --马魂
        name = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.horse_spirit_name)
        quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
        local level = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.level)
        if level == -1 then 
            dec = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.desc)
        else
            local attributes  = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.attributes)
            attributes = zstring.split(attributes,",")
            local text_title = tonumber(attributes[1])
            text_title = attribute[text_title+1]
            local text_str = tonumber(attributes[2])
            local is_handred = false
            for i,v in pairs(attribute_hundred) do
                if tonumber(attributes[1]) == v then
                    is_handred = true
                end
            end
            if is_handred == true then
                text_str = "  +" .. text_str.."%"
            else
                text_str = "  +" .. text_str
            end
            dec = ""

            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
             local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, text_title, "fonts/simhei.ttf",18)
            _richText:pushBackElement(re1)  
             local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, text_str, "fonts/simhei.ttf",18)
            _richText:pushBackElement(re2)
            _richText:setPosition(cc.p(Text_props_information:getContentSize().width/2,Text_props_information:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_props_information:getContentSize().width,18))
            Text_props_information:addChild(_richText)
        end
    elseif tonumber(prop_type) == 37 then   --龙马碎片
        name = red_alert_resouce_tip[3]
        dec = red_alert_resouce_tip[3]
    elseif tonumber(prop_type) == 38 then   --马魂碎片
        name = red_alert_resouce_tip[4]
        dec = red_alert_resouce_tip[4]
    elseif tonumber(prop_type) == 39 then   --vip经验
        name = _All_tip_string_info._vipExp
        dec = red_alert_resouce_tip[5]
    elseif tonumber(prop_type) == 40 then   --个人站积分
        name = red_alert_resouce_tip[6][1]
        dec = red_alert_resouce_tip[6][2]
    elseif tonumber(prop_type) == 41 then   --兵符
        name = "1111111111111111"
        quality  = 4
    end
    -- print("=====prop_id=========",prop_id)
    -- print("=====name=========",name)
    -- print("=====prop_type=========",prop_type)
    -- print("=====dec=========",dec)
    local Image_props_infor_bg = ccui.Helper:seekWidgetByName(root,"Image_props_infor_bg_"..quality)    --品质背景颜色
    Image_props_infor_bg:setVisible(true)
    Text_props_infor_name:setString(name)
    Text_props_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    if self.prop_data.pack_nums ~= nil then
        Text_props_infor_number:setString(self.prop_data.pack_nums)
    else
        Text_props_infor_number:setString(self.prop_data.item_value)
    end
    Text_props_information:setString(dec)
end

function PropsInformation:onEnterTransitionFinish()

end

--初始化界面
function PropsInformation:onInit( )
    local csbItem = csb.createNode(config_csb.utils.props_information)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    if PropsInformation.__size == nil then
        PropsInformation.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_infor"), nil, 
    {
        terminal_name = "props_information_window_close", 
        terminal_state = 0, 
    }, nil, 0)

	self:onUpdateDraw()	

end

--初始化
function PropsInformation:init(prop_show_type,prop_data,prop,prop_from_type,index,show_name,show_numbers,pos)
    self.prop_show_type = prop_show_type
    self.prop_data = prop_data
    self.prop = prop
    self.prop_from_type = prop_from_type

    self.prop_type = prop_data.prop_type
    self.prop_numbers = prop_data.item_value
    self.prop_id = prop_data.prop_item
    self.prop_name = ""
	self:onInit()
    self:setContentSize(PropsInformation.__size)
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x,(fwin._width - PropsInformation.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y,(fwin._height - PropsInformation.__size.height))
    self:setPosition(cc.p(x,y))
    return self
end

function PropsInformation:onExit()

end
