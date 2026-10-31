--------------------------------------------------------------------------------------------------------------
--  说明：VIP特权等级信息
--------------------------------------------------------------------------------------------------------------
VipLevelInfo = class("VipLevelInfoClass", Window)

--打开界面
local vip_level_info_open_terminal = {
	_name = "vip_level_info_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("VipLevelInfoClass") == nil then
            local panel = VipLevelInfo:new():init(params)
    		fwin:open(panel)
            return panel
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local vip_level_info_close_terminal = {
	_name = "vip_level_info_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("VipLevelInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(vip_level_info_open_terminal)
state_machine.add(vip_level_info_close_terminal)
state_machine.init()

function VipLevelInfo:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._choose_index = -1

    local function init_vip_level_info_terminal()
        local vip_level_info_show_terminal = {
            _name = "vip_level_info_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                self._choose_index = -1
                instance:updateDraw(tonumber(_ED.vip_grade))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_level_info_hide_terminal = {
            _name = "vip_level_info_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_level_info_choose_vip_terminal = {
            _name = "vip_level_info_choose_vip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw(params._datas.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(vip_level_info_show_terminal)
        state_machine.add(vip_level_info_hide_terminal)
        state_machine.add(vip_level_info_choose_vip_terminal)
        state_machine.init()
    end
    
    init_vip_level_info_terminal()
end

function VipLevelInfo:updateDraw(chooseIndex)
    local root = self.roots[1]
    if self._choose_index == chooseIndex then
        ccui.Helper:seekWidgetByName(root, "Button_vip_"..self._choose_index):setHighlighted(true)
        return
    end
    self._choose_index = chooseIndex
    for i=0,10 do
        if self._choose_index == i then
            ccui.Helper:seekWidgetByName(root, "Button_vip_"..i):setHighlighted(true)
        else
            ccui.Helper:seekWidgetByName(root, "Button_vip_"..i):setHighlighted(false)
        end
    end
    local Text_vip_infor_title = ccui.Helper:seekWidgetByName(root, "Text_vip_infor_title")
    Text_vip_infor_title:removeAllChildren(true)

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, _string_piece_info[228]..self._choose_index, config_res.font.font_name, 23)
    _richText:pushBackElement(re1)
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[32], config_res.font.font_name, 23)
    _richText:pushBackElement(re2)
    _richText:setAnchorPoint(0.5,0)
    _richText:setContentSize(cc.size(Text_vip_infor_title:getContentSize().width, Text_vip_infor_title:getContentSize().height))
    _richText:setPosition(cc.p(Text_vip_infor_title:getContentSize().width/2 + 80, -12))
    Text_vip_infor_title:addChild(_richText)

    local ListView_vip_infor = ccui.Helper:seekWidgetByName(root, "ListView_vip_infor")
    ListView_vip_infor:removeAllChildren(true)
    
    local text_str = zstring.split(_vip_privilege_info[self._choose_index + 1], "|")
    for i,v in pairs(text_str) do
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        local text_str_color = zstring.split(v, ";")
        for j,k in pairs(text_str_color) do
            if tonumber(j) == 2 then 
                local re = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, k, config_res.font.font_name, 21)
                _richText:pushBackElement(re)
            else
                local re = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, k, config_res.font.font_name, 21)
                _richText:pushBackElement(re)
            end
        end
        _richText:setAnchorPoint(0.5,0.5)
        _richText:setContentSize(cc.size(ListView_vip_infor:getContentSize().width,50))
        ListView_vip_infor:addChild(_richText)
    end
    ListView_vip_infor:requestRefreshView()
end

--初始化
function VipLevelInfo:onInit()
    local csbItem = csb.createNode(config_csb.shop.vip_privilege_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    for i=0,10 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vip_"..i), nil, 
        {
            terminal_name = "vip_level_info_choose_vip", 
            terminal_state = 0, 
            index = i,
        }, nil, 1)
    end

    self:updateDraw(tonumber(_ED.vip_grade))
end

function VipLevelInfo:onEnterTransitionFinish()

end

function VipLevelInfo:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function VipLevelInfo:onExit()
    state_machine.remove("vip_level_info_show")
    state_machine.remove("vip_level_info_hide")
    state_machine.remove("vip_level_info_choose_vip")
end