-- --------------------------------------------------------------------------------------------------
-- 说明：科研目标未解锁cell
-- -----------------------------------------------------------------------------------------------------
BuildUpScientificRockCell = class("BuildUpScientificRockCellClass", Window)
BuildUpScientificCellSize = BuildUpScientificCellSize or nil

local build_up_scientific_rock_cell_create_terminal = {
    _name = "build_up_scientific_rock_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local cell = BuildUpScientificRockCell:new()
        local index = params[1]
        local base_barracks_info = params[2]
        cell:init(index, base_barracks_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_scientific_rock_cell_create_terminal)
state_machine.init()

function BuildUpScientificRockCell:ctor()
    self.super:ctor()
    self.roots = {}     

    app.load("client.red_alert_time.cells.props.props_use_cell")
    local function init_build_up_scientific_rock_cell_terminal()
        
        local build_up_scientific_rock_cell_click_terminal = {
            _name = "build_up_scientific_rock_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(build_up_scientific_rock_cell_click_terminal)       
        state_machine.init()
    end
    init_build_up_scientific_rock_cell_terminal()           
end

function BuildUpScientificRockCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_res_infor = ccui.Helper:seekWidgetByName(root,"Text_res_infor")
    -- 科研目标icon
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon")
    Panel_props_icon:removeAllChildren(true)
    Panel_props_icon:removeBackGroundImage()
    if Panel_props_que_icon ~= nil and Panel_attribute_icon ~= nil then
        Panel_props_que_icon:removeBackGroundImage()
        Panel_attribute_icon:removeBackGroundImage()
        local pic_index = zstring.split(dms.string(dms["teach_escalate_param"], self._base_barracks_info.id, teach_escalate_param.pic_index), ",")
        Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
        Panel_props_que_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))
        Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[6]))
    else
        local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_barracks_info.id,4})
        Panel_props_icon:addChild(cell) 
    end
    
    -- 科研目标名字
    local Text_scientific_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_name")
    local Text_scientific_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_lv")
    if Text_scientific_lv ~= nil then
        Text_scientific_lv:setString("0")
        Text_scientific_name:setString(self._base_barracks_info.name)
    else
        local fontSize = Text_scientific_name:getFontSize()
        Text_scientific_name:setString("")
        Text_scientific_name:removeAllChildren(true)
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local color1 = cc.c3b(tipStringInfo_scientific_color_Type[1][1],tipStringInfo_scientific_color_Type[1][2],tipStringInfo_scientific_color_Type[1][3])
        local re1 = ccui.RichElementText:create(1, color1,255, self._base_barracks_info.name, "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re1)  
        -- local color2 = cc.c3b(tipStringInfo_scientific_color_Type[2][1],tipStringInfo_scientific_color_Type[2][2],tipStringInfo_scientific_color_Type[2][3])
        -- local re2 = ccui.RichElementText:create(1, color2,255, " "..string.format(red_alert_all_str[13], "0"), "fonts/simhei.ttf",20)
        -- _richText_2:pushBackElement(re2)
        _richText_2:setContentSize(cc.size(root:getContentSize().width,fontSize))
        _richText_2:setPosition(cc.p(_richText_2:getContentSize().width / 2,0))
        Text_scientific_name:addChild(_richText_2)
    end
    -- 科研目标描述
    if Text_res_infor ~= nil then
        Text_res_infor:setString("")
        Text_res_infor:removeAllChildren(true)
        local fontName = Text_res_infor:getFontName()
        local fontSize = Text_res_infor:getFontSize()
        local dec_info = zstring.split(self._base_barracks_info.dec, "!x@")
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)    
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,dec_info[1], fontName,fontSize)
        _richText_1:pushBackElement(re3)
        local re4 = nil 
        if #dec_info > 1 then
            local talent_info = zstring.split(dms.string(dms["talent_mould"], self._base_barracks_info.gift, talent_mould.base_additional), ",")
            local add_attr = 0
            for k, v in pairs(attribute_hundred) do
                if v == tonumber(talent_info[1]) then
                    add_attr = ""..add_attr.."%"
                    break
                end
            end
            re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[8][1],color_Type[8][2],color_Type[8][3]),255,"+"..add_attr, fontName,fontSize)
            _richText_1:pushBackElement(re4)
        end
        _richText_1:setPosition(cc.p(Text_res_infor:getContentSize().width/2,Text_res_infor:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_res_infor:getContentSize().width,fontSize))
        Text_res_infor:addChild(_richText_1)
    end
    -- 科研目标解锁等级
    local Text_scientific_roke_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_roke_lv")
    Text_scientific_roke_lv:setString(string.format(red_alert_all_str[277], self._base_barracks_info.open_level))
end

function BuildUpScientificRockCell:setSelected()

end

function BuildUpScientificRockCell:onEnterTransitionFinish()

end

function BuildUpScientificRockCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_scientific_rock_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BuildUpScientificCellSize == nil then
        BuildUpScientificCellSize = size
    end

    -- 查看详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_infor"), nil, 
    {
        -- terminal_name = "ranking_left_big_cell_click", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BuildUpScientificRockCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_scientific_rock_cell, self.roots[1])

end

function BuildUpScientificRockCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpScientificRockCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_scientific_rock_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpScientificRockCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_scientific_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_name")
    local Text_res_infor = ccui.Helper:seekWidgetByName(root,"Text_res_infor")
    local Text_scientific_roke_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_roke_lv")
    local Text_scientific_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_lv")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon")

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Panel_props_icon:removeBackGroundImage()
        Text_scientific_name:setString("")
        Text_scientific_name:removeAllChildren(true)
        Text_scientific_roke_lv:setString("")
    end
    if Text_res_infor ~= nil then
        Text_res_infor:setString("")
        Text_res_infor:removeAllChildren(true)
    end
    if Text_scientific_lv ~= nil then
        Text_scientific_lv:setString("")
    end
    if Panel_props_que_icon ~= nil then
        Panel_props_que_icon:removeBackGroundImage()
    end
    if Panel_attribute_icon ~= nil then
        Panel_attribute_icon:removeBackGroundImage()
    end
end

function BuildUpScientificRockCell:init(index, base_barracks_info) 
    self._index = index
    self._base_barracks_info = base_barracks_info

    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(BuildUpScientificCellSize)
end

