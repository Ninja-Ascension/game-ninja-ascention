-- ----------------------------------------------------------------------------------------------------
-- 说明：公会公用提示界面
-------------------------------------------------------------------------------------------------------
SmUnionTipsWindow = class("SmUnionTipsWindowClass", Window)

local sm_union_tips_window_open_terminal = {
    _name = "sm_union_tips_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionTipsWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionTipsWindow:new():init(params)
            fwin:open(panel,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_tips_window_close_terminal = {
    _name = "sm_union_tips_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionTipsWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionTipsWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_tips_window_open_terminal)
state_machine.add(sm_union_tips_window_close_terminal)
state_machine.init()
    
function SmUnionTipsWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_sm_union_tips_window_terminal()
        -- 显示界面
        local sm_union_tips_window_display_terminal = {
            _name = "sm_union_tips_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionTipsWindowWindow = fwin:find("SmUnionTipsWindowClass")
                if SmUnionTipsWindowWindow ~= nil then
                    SmUnionTipsWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_tips_window_hide_terminal = {
            _name = "sm_union_tips_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionTipsWindowWindow = fwin:find("SmUnionTipsWindowClass")
                if SmUnionTipsWindowWindow ~= nil then
                    SmUnionTipsWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 确认
        local sm_union_tips_window_confirm_terminal = {
            _name = "sm_union_tips_window_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance.m_type) == 1 then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon 
                        or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                        if funOpenDrawTip(181) == true then
                            return
                        end
                    end
                    app.load("client.shop.recharge.RechargeDialog")
                    local Recharge = RechargeDialog:new()
                    Recharge:init(4)
                    fwin:open(Recharge , fwin._windows)
                    state_machine.excute("sm_union_tips_window_close", 0, "")
                elseif tonumber(instance.m_type) == 3 then
                    local function responseGetServerListCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("trial_tower_insert_new_cell_data",0,"0")
                            state_machine.excute("sm_trial_tower_update_buff_info",0,"")
                            state_machine.excute("sm_union_tips_window_close", 0, "")
                            fwin:close(fwin:find("AdditionSelectClass"))
                        end
                    end

                    local buffData = zstring.split(dms.string(dms["three_kingdoms_config"], tonumber(_ED.integral_current_index), three_kingdoms_config.attribute_add_id), "|")
                    local buff_need = zstring.split(buffData[2],",")
                    local buff_data = zstring.split(buffData[1],",")
                    instance.selectIndex = instance.datas  
                    for j,w in pairs(buff_data) do
                        local isOver = false
                        for i,v in pairs(instance.selectIndex) do
                            if tonumber(w) == tonumber(v.store_id) then
                                isOver = true
                            end
                        end
                        if isOver == false then
                            local store = {}
                            store.store_id = w
                            store.shipid = -1
                            store.id = -1
                            table.insert(instance.selectIndex, store)
                        end
                    end

                    local buff_info = ""
                    table.sort(instance.selectIndex, function(c1, c2)
                        if c1 ~= nil 
                            and c2 ~= nil 
                            and zstring.tonumber(c1.store_id) < zstring.tonumber(c2.store_id) then
                            return true
                        end
                        return false
                    end)
                    local index = 0
                    for i,v in pairs(instance.selectIndex) do
                        if tonumber(v.id) > 0 then
                            local list = zstring.split( dms.string(dms["three_kingdoms_attribute"], v.id, three_kingdoms_attribute.attribute_value),",")
                            --战前处理的血量和怒气的加成
                            if tonumber(list[1]) == 4 or tonumber(list[1]) == 41 or tonumber(list[1]) == 999 then
                                if tonumber(list[1]) == 4 then
                                    --加血
                                    if tonumber(v.shipid) == -1 then
                                        for j,w in pairs(_ED.user_try_ship_infos) do
                                            --满血的就不管了
                                            if tonumber(w.maxHp) < 100 then
                                                --计算出加成后的血量百分比
                                                w.maxHp = tonumber(w.maxHp) + tonumber(list[2])
                                                if tonumber(w.maxHp) > 100 then
                                                    w.maxHp = 100
                                                end
                                                _ED.user_try_ship_infos[""..w.id].newHp = tonumber(_ED.user_ship[""..w.id].ship_health)*(tonumber(w.maxHp)/100)
                                            end
                                        end
                                    else
                                        _ED.user_try_ship_infos[""..v.shipid].maxHp = tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) + tonumber(list[2])
                                        if tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) > 100 then
                                            _ED.user_try_ship_infos[""..v.shipid].maxHp = 100
                                        end
                                        _ED.user_try_ship_infos[""..v.shipid].newHp = tonumber(_ED.user_ship[""..v.shipid].ship_health)*(tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp)/100)
                                    end
                                elseif tonumber(list[1]) == 41 then 
                                    --加怒
                                    local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
                                    if tonumber(v.shipid) == -1 then
                                        for j,w in pairs(_ED.user_try_ship_infos) do
                                            if tonumber(w.newanger) < tonumber(fightParams[4]) then
                                                w.newanger = tonumber(w.newanger) + tonumber(list[2])
                                                if tonumber(w.newanger) > tonumber(fightParams[4]) then
                                                    w.newanger = tonumber(fightParams[4])
                                                end 
                                                _ED.user_try_ship_infos[""..w.id].newanger = tonumber(w.newanger)
                                            end
                                        end
                                    else
                                        _ED.user_try_ship_infos[""..v.shipid].newanger = tonumber(_ED.user_try_ship_infos[""..v.shipid].newanger) + tonumber(list[2])
                                        if tonumber(_ED.user_try_ship_infos[""..v.shipid].newanger) > tonumber(fightParams[4]) then
                                            _ED.user_try_ship_infos[""..v.shipid].newanger = tonumber(fightParams[4])
                                        end
                                    end
                                elseif tonumber(list[1]) == 999 then
                                    --复活
                                    _ED.user_try_ship_infos[""..v.shipid].maxHp = tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) + tonumber(list[2])
                                    _ED.user_try_ship_infos[""..v.shipid].newHp = tonumber(_ED.user_ship[""..v.shipid].ship_health)*(tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp)/100)
                                end
                            end
                        end
                        if tonumber(v.shipid) < 0 then
                            index = index + 1
                            if index == 1 then
                                buff_info = tonumber(v.id)..":"..tonumber(v.shipid)
                            else
                                buff_info = buff_info .."|"..tonumber(v.id)..":"..tonumber(v.shipid)
                            end
                        end
                    end

                    local strs = ""
                    for j, w in pairs(_ED.user_try_ship_infos) do
                        if strs ~= "" then
                            strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                        else
                            strs = w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                        end
                    end

                    protocol_command.three_kingdoms_launch.param_list = "54".."\r\n"..dms.string(dms["play_config"], 26, play_config.param).."\r\n".."0".."\r\n".."0".."\r\n".."0".."\r\n"..
                    _ED.integral_current_index.."\r\n"..strs.."\r\n"..buff_info.."\r\n".."".."\r\n".."0"
                    NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                else
                    state_machine.excute("sm_union_tips_window_close", 0, "")    
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_tips_window_display_terminal)
        state_machine.add(sm_union_tips_window_hide_terminal)
        state_machine.add(sm_union_tips_window_confirm_terminal)
        state_machine.init()
    end
    init_sm_union_tips_window_terminal()
end

function SmUnionTipsWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    
    local Image_15_0 = ccui.Helper:seekWidgetByName(root, "Image_15_0")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    if tonumber(self.m_type) == 1 then
        local m_str = zstring.split(self.m_str ,"!")
        for i, v in pairs(m_str) do
            local char_str = v
            if i==2 then
                local strData = zstring.split(v ,"|")
                strData[2] = "%|1|".."VIP"..self.datas.activity.activityInfo_need_vip.."%"
                char_str = strData[1]..strData[2]..strData[3]
            end
            Text_name:setString(char_str)
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)

            local richTextWidth = Text_name:getContentSize().width
            if richTextWidth == 0 then
                richTextWidth = Text_name:getFontSize() * 6
            end
                
            _richText2:setContentSize(cc.size(richTextWidth, 0))
           -- _richText2:setAnchorPoint(cc.p(0.5, 0))
            _richText2:setAnchorPoint(cc.p(0.5, 0.5))
            if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                color_Type_1 = cc.c3b(71, 71, 71)
                color_Type_2 = cc.c3b(71, 71, 71)
            else
                color_Type_1 = cc.c3b(189, 206, 224)
                color_Type_2 = cc.c3b(189, 206, 224)
            end
            
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            color_Type_1,
            color_Type_2,
            0, 
            0, 
            Text_name:getFontName(), 
            Text_name:getFontSize(),
            chat_rich_text_color)
            -- if _ED.is_can_use_formatTextExt == false then
           --     _richText2:setPositionX((_richText2:getPositionX() - _richText2:getContentSize().width / 2) + _richText2:getContentSize().width / 2)
            _richText2:setPositionX(Image_15_0:getContentSize().width/2)
             -- else
            --     _richText2:formatTextExt()
            -- end
            local rsize = _richText2:getContentSize()
            if i==1 then
                _richText2:setPositionY(Text_name:getContentSize().height/2+12)
            else
                _richText2:setPositionY(Text_name:getContentSize().height/2-12)
            end
            Text_name:addChild(_richText2)
            Text_name:setString("")
        end
    elseif tonumber(self.m_type) == 2 then
        Text_name:setString(self.m_str)
    else
        Text_name:setString(self.m_str)
    end
end

function SmUnionTipsWindow:init(params)
    self.m_str = params[1]          --内容
    self.m_type = params[2]         --类型  1 签到提示 2 正常文字提示,无富文本，点击确认关闭
    self.datas = params[3] or nil          --数据
    self:onInit()
    return self
end

function SmUnionTipsWindow:onInit()
    local csbSmUnionTipsWindow = csb.createNode("utils/sm_tips_window.csb")
    local root = csbSmUnionTipsWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionTipsWindow)
    local action = csb.createTimeline("utils/sm_tips_window.csb")
    table.insert(self.actions, action)
    csbSmUnionTipsWindow:runAction(action)
    action:play("window_open", false)

    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_union_tips_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    --确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_union_tips_window_confirm",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
end

function SmUnionTipsWindow:onExit()
    state_machine.remove("sm_union_tips_window_display")
    state_machine.remove("sm_union_tips_window_hide")
end