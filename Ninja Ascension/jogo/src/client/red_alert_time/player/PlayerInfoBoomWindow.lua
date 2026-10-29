--------------------------------------------------------------------------------------------------------------
--  说明：繁荣度详情界面
--------------------------------------------------------------------------------------------------------------
PlayerInfoBoomWindow = class("PlayerInfoBoomWindowClass", Window)

--打开界面
local player_infor_boom_window_open_terminal = {
	_name = "player_infor_boom_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerInfoBoomWindowClass") == nil then
    		fwin:open(PlayerInfoBoomWindow:new():init(), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_infor_boom_window_close_terminal = {
	_name = "player_infor_boom_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfoBoomWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_infor_boom_window_open_terminal)
state_machine.add(player_infor_boom_window_close_terminal)
state_machine.init()

function PlayerInfoBoomWindow:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    local function init_play_info_build_upgrade_terminal()
        local player_infor_boom_window_show_terminal = {
            _name = "player_infor_boom_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_infor_boom_window_hide_terminal = {
            _name = "player_infor_boom_window_hide",
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

        -- 刷新界面
        local player_infor_boom_window_update_draw_terminal = {
            _name = "player_infor_boom_window_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_infor_boom_window_show_terminal)
        state_machine.add(player_infor_boom_window_hide_terminal)
        state_machine.add(player_infor_boom_window_update_draw_terminal)
        state_machine.init()
    end
    
    init_play_info_build_upgrade_terminal()
end

function PlayerInfoBoomWindow:updateDraw()
    local root = self.roots[1]
    -- 基地繁荣状态
    local boom_state = 0
    local boom_bar = zstring.tonumber(_ED.user_info.booming)/zstring.tonumber(_ED.user_info.forage)
    for i= 1, dms.count(dms["build_boom_lose"]) do
        local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
        if boom_bar >= tonumber(boom_proportion) then
            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
            break
        end
    end
    local Text_boom_state = ccui.Helper:seekWidgetByName(root,"Text_boom_state")  
    Text_boom_state:setString(tipStringInfo_boom_window[boom_state+4])
    Text_boom_state:setColor(cc.c3b(boom_window_color_Type[boom_state+1][1],boom_window_color_Type[boom_state+1][2],boom_window_color_Type[boom_state+1][3]))
    -- 基地icon
    local Panel_world_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_world_build_icon")        
    Panel_world_build_icon:removeBackGroundImage()
    Panel_world_build_icon:removeAllChildren(true)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("map/base_npc/spirte_beattacked.ExportJson")
    local sprite = ccs.Armature:create("spirte_beattacked")
    local pic = zstring.split(dms.string(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.base_pic),",")
    sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))

    sprite:setAnchorPoint(cc.p(0.5, 0.5))
    Panel_world_build_icon:addChild(sprite)
    sprite:setPosition(cc.p(Panel_world_build_icon:getContentSize().width/3,Panel_world_build_icon:getContentSize().height/2))

    -- 繁荣度
    local Text_boom_n = ccui.Helper:seekWidgetByName(root,"Text_boom_n")
    Text_boom_n:setString(_ED.user_info.booming.."/".._ED.user_info.forage)
    local LoadingBar_boom_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_bar")
    LoadingBar_boom_bar:setPercent(boom_bar * 100)

    if boom_state == 0 then
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar.png")
    elseif boom_state == 1 then
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar_1.png")
    else
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar_2.png")
    end
    
    local boom_index = 0
    local boom_level = 0
    for i= 1, dms.count(dms["build_boom_mould"]) do
        local now_need_boom = dms.int(dms["build_boom_mould"], i, build_boom_mould.need_boom)
        local last_need_boom = dms.int(dms["build_boom_mould"], i+1, build_boom_mould.need_boom)
        if tonumber(_ED.user_info.booming) >= now_need_boom 
            and (last_need_boom == nil or tonumber(_ED.user_info.booming) < last_need_boom) then
            boom_index = i
            boom_level = dms.int(dms["build_boom_mould"], i, build_boom_mould.boom_level)
        end
    end
    local now_need_boom = dms.int(dms["build_boom_mould"], boom_index, build_boom_mould.need_boom)  -- 繁荣要求
    -- 当前等级
    local Text_now_boom_1 = ccui.Helper:seekWidgetByName(root,"Text_now_boom_1")
    local Text_now_boom_2 = ccui.Helper:seekWidgetByName(root,"Text_now_boom_2")
    local Text_now_boom_3 = ccui.Helper:seekWidgetByName(root,"Text_now_boom_3")
    if Text_now_boom_1 ~= nil then
        Text_now_boom_1:removeAllChildren(true)
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, friends_tip_string[12], "fonts/simhei.ttf",22)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, boom_level, "fonts/simhei.ttf",22)
        _richText_1:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_boom_window[1],now_need_boom), "fonts/simhei.ttf",22)
        _richText_1:pushBackElement(re3)
        _richText_1:setPosition(cc.p(Text_now_boom_1:getContentSize().width/2,Text_now_boom_1:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_now_boom_1:getContentSize().width,22))
        Text_now_boom_1:addChild(_richText_1)
    end

    local now_boom_famtion = dms.int(dms["build_boom_mould"], boom_index, build_boom_mould.boom_famtion)    -- 带兵数量
    if Text_now_boom_2 ~= nil then
        Text_now_boom_2:removeAllChildren(true)
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,tipStringInfo_boom_window[2], "fonts/simhei.ttf",22)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, "+"..now_boom_famtion, "fonts/simhei.ttf",22)
        _richText_2:pushBackElement(re2)
        _richText_2:setPosition(cc.p(Text_now_boom_2:getContentSize().width/2,Text_now_boom_2:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_now_boom_2:getContentSize().width,22))
        Text_now_boom_2:addChild(_richText_2)
    end

    local now_add_resources = dms.int(dms["build_boom_mould"], boom_index, build_boom_mould.add_resources)  -- 基地资源产量
    if Text_now_boom_3 ~= nil then
        Text_now_boom_3:removeAllChildren(true)
        local _richText_3 = ccui.RichText:create()
        _richText_3:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,tipStringInfo_boom_window[3], "fonts/simhei.ttf",22)
        _richText_3:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, now_add_resources.."%", "fonts/simhei.ttf",22)
        _richText_3:pushBackElement(re2)
        _richText_3:setPosition(cc.p(Text_now_boom_3:getContentSize().width/2,Text_now_boom_3:getContentSize().height/2))
        _richText_3:setContentSize(cc.size(Text_now_boom_3:getContentSize().width,22))
        Text_now_boom_3:addChild(_richText_3)
    end
    -- 升级效果
    local Text_up_boom_effice = ccui.Helper:seekWidgetByName(root,"Text_up_boom_effice")     
    local Image_7_0 = ccui.Helper:seekWidgetByName(root,"Image_7_0")  
    if Text_up_boom_effice ~= nil then 
        Text_up_boom_effice:setVisible(true)
    end
    if Image_7_0 ~= nil then
        Image_7_0:setVisible(true)
    end
    local up_need_boom = dms.int(dms["build_boom_mould"], boom_index+1, build_boom_mould.need_boom)  -- 所需繁荣度
    local up_boom_famtion = 0
    local up_add_resources = 0
    if up_need_boom ~= nil then
        local Text_up_boom_1 = ccui.Helper:seekWidgetByName(root,"Text_up_boom_1")
        local Text_up_boom_2 = ccui.Helper:seekWidgetByName(root,"Text_up_boom_2")
        local Text_up_boom_3 = ccui.Helper:seekWidgetByName(root,"Text_up_boom_3")

        if Text_up_boom_1 ~= nil then
            Text_up_boom_1:removeAllChildren(true)
            local _richText_4 = ccui.RichText:create()
            _richText_4:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, friends_tip_string[12], "fonts/simhei.ttf",22)
            _richText_4:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, boom_level+1, "fonts/simhei.ttf",22)
            _richText_4:pushBackElement(re2)
            local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_boom_window[1],up_need_boom), "fonts/simhei.ttf",22)
            _richText_4:pushBackElement(re3)
            _richText_4:setPosition(cc.p(Text_up_boom_1:getContentSize().width/2,Text_up_boom_1:getContentSize().height/2))
            _richText_4:setContentSize(cc.size(Text_up_boom_1:getContentSize().width,22))
            Text_up_boom_1:addChild(_richText_4)
        end

        if Text_up_boom_2 ~= nil then
            Text_up_boom_2:removeAllChildren(true)
            up_boom_famtion = dms.int(dms["build_boom_mould"], boom_index+1, build_boom_mould.boom_famtion)   -- 带兵数量
            local _richText_5 = ccui.RichText:create()
            _richText_5:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,tipStringInfo_boom_window[2], "fonts/simhei.ttf",22)
            _richText_5:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[7][2],color_Type[2][3]),255, "+"..up_boom_famtion, "fonts/simhei.ttf",22)
            _richText_5:pushBackElement(re2)
            _richText_5:setPosition(cc.p(Text_up_boom_2:getContentSize().width/2,Text_up_boom_2:getContentSize().height/2))
            _richText_5:setContentSize(cc.size(Text_up_boom_2:getContentSize().width,22))
            Text_up_boom_2:addChild(_richText_5)
        end

        if Text_up_boom_3 ~= nil then
            Text_up_boom_3:removeAllChildren(true)
            up_add_resources = dms.int(dms["build_boom_mould"], boom_index+1, build_boom_mould.add_resources) -- 基地资源产量
            local _richText_6 = ccui.RichText:create()
            _richText_6:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,tipStringInfo_boom_window[3], "fonts/simhei.ttf",22)
            _richText_6:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, up_add_resources.."%", "fonts/simhei.ttf",22)
            _richText_6:pushBackElement(re2)
            _richText_6:setPosition(cc.p(Text_up_boom_3:getContentSize().width/2,Text_up_boom_3:getContentSize().height/2))
            _richText_6:setContentSize(cc.size(Text_up_boom_3:getContentSize().width,22))
            Text_up_boom_3:addChild(_richText_6)
        end
    else
        if Text_up_boom_effice ~= nil then
            Text_up_boom_effice:setVisible(false)
        end
        if Image_7_0 ~= nil then
            Image_7_0:setVisible(false)
        end
    end

    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    if Panel_1 ~= nil then
        -- 当前等级属性
        local Text_boom_now_lv_n = ccui.Helper:seekWidgetByName(root, "Text_boom_now_lv_n")
        local Text_boom_now_lv_effect_n = ccui.Helper:seekWidgetByName(root, "Text_boom_now_lv_effect_n")
        local Text_boom_now_lv_famtion_n = ccui.Helper:seekWidgetByName(root, "Text_boom_now_lv_famtion_n")
        local Text_boom_now_lv_res_n = ccui.Helper:seekWidgetByName(root, "Text_boom_now_lv_res_n")

        Text_boom_now_lv_n:setString(string.format(tipString_info_project_pacific_rim[11], boom_level))
        Text_boom_now_lv_effect_n:setString(now_need_boom)
        Text_boom_now_lv_famtion_n:setString("+"..now_boom_famtion)
        Text_boom_now_lv_res_n:setString(now_add_resources.."%")

        -- 下一级属性
        local Text_boom_next_lv_n = ccui.Helper:seekWidgetByName(root, "Text_boom_next_lv_n")
        local Text_boom_next_lv_effect_n = ccui.Helper:seekWidgetByName(root, "Text_boom_next_lv_effect_n")
        local Text_boom_next_lv_famtion_n = ccui.Helper:seekWidgetByName(root, "Text_boom_next_lv_famtion_n")
        local Text_boom_next_lv_res_n = ccui.Helper:seekWidgetByName(root, "Text_boom_next_lv_res_n")
        if up_need_boom ~= nil then
            Text_boom_next_lv_n:setString(string.format(tipString_info_project_pacific_rim[12], boom_level + 1))
            Text_boom_next_lv_effect_n:setString(up_need_boom)
            Text_boom_next_lv_famtion_n:setString("+"..up_boom_famtion)
            Text_boom_next_lv_res_n:setString(up_add_resources.."%")
        else
            Text_boom_next_lv_n:setString("")
            Text_boom_next_lv_effect_n:setString("")
            Text_boom_next_lv_famtion_n:setString("")
            Text_boom_next_lv_res_n:setString("")
        end
    end
end

function PlayerInfoBoomWindow:onUpdate(dt)

end

--初始化
function PlayerInfoBoomWindow:onInit()
    local csbItem = csb.createNode(config_csb.player.player_infor_boom_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_lv_close"), nil, 
    {
        terminal_name = "player_infor_boom_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_sure"), nil, 
    {
        terminal_name = "player_infor_boom_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "player_infor_boom_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_up_add"), nil, 
    {
        terminal_name = "player_info_boom_up_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self:updateDraw()
end

function PlayerInfoBoomWindow:onEnterTransitionFinish()

end

function PlayerInfoBoomWindow:init()
	self:onInit()
    return self
end

function PlayerInfoBoomWindow:onExit()
    state_machine.remove("player_infor_boom_window_show")
    state_machine.remove("player_infor_boom_window_hide")
    state_machine.remove("player_infor_boom_window_update_draw")
end