-- ----------------------------------------------------------------------------------------------------
-- 说明：好友的属性查看界面
-------------------------------------------------------------------------------------------------------
RedAlertTimeFriendInfo = class("RedAlertTimeFriendInfoClass", Window)

local red_alert_time_friend_info_open_terminal = {
    _name = "red_alert_time_friend_info_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeFriendInfoClass"))
        if nil == fwin:find("RedAlertTimeFriendInfoClass") then
            local mobject = params
            local user_id = mobject.user_id
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(RedAlertTimeFriendInfo:new():init(), fwin._ui)
                end
            end
            protocol_command.get_other_user_info.param_list = params
            NetworkManager:register(protocol_command.get_other_user_info.code, server_link, nil, nil, nil, responseCallback, false, nil)
        end
        -- fwin:open(RedAlertTimeFriendInfo:new():init(params), fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_friend_info_close_terminal = {
    _name = "red_alert_time_friend_info_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("RedAlertTimeFriendInfoClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("RedAlertTimeFriendInfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_friend_info_open_terminal)
state_machine.add(red_alert_time_friend_info_close_terminal)
state_machine.init()
    
function RedAlertTimeFriendInfo:ctor()
    self.super:ctor()
    self.roots = {}
    -- self.m_object = nil
    self.is_friend = false
    self.is_blacklist = false
    app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    local function init_red_alert_time_friend_info_terminal()
        
        --删除好友
        local red_alert_time_friend_info_friend_remove_terminal = {
            _name = "red_alert_time_friend_info_friend_remove",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params._datas.cells
                
                if cells.is_friend == true then
                    local tip = ConfirmTip:new()
                    tip:init(cells, cells.sureDelete, friends_tip_string[14])
                    fwin:open(tip,fwin._windows) 
                else
                    local function recruitDelBackCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateDraw()
                                TipDlg.drawTextDailog(friends_tip_string[1])
                                state_machine.excute("red_alert_time_friend_info_close", 0, 0)
                            end
                        end
                    end
                    if _ED.other_user_info.user_name == _ED.user_info.user_name then
                        TipDlg.drawTextDailog(friends_tip_string[7])
                        state_machine.excute("red_alert_time_friend_info_close", 0, 0)
                        return
                    end
                    protocol_command.friend_request.param_list = _ED.other_user_info.user_name
                    NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, cells, recruitDelBackCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --写邮件
        local red_alert_time_friend_info_write_an_email_terminal = {
            _name = "red_alert_time_friend_info_write_an_email",
            _init = function (terminal)
                app.load("client.red_alert_time.mail.MailWriteAn")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.other_user_info.user_name == _ED.user_info.user_name then
                    TipDlg.drawTextDailog(friends_tip_string[16])
                    state_machine.excute("red_alert_time_friend_info_close", 0, 0)
                    return
                end
                state_machine.excute("write_an_email_window_open", 0, {_datas={name=_ED.other_user_info.user_name,title=""}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --私聊
        local red_alert_time_friend_info_private_chat_terminal = {
            _name = "red_alert_time_friend_info_private_chat",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.other_user_info.user_name == _ED.user_info.user_name then
                    TipDlg.drawTextDailog(friends_tip_string[17])
                    state_machine.excute("red_alert_time_friend_info_close", 0, 0)
                    return
                end
                local friend = params._datas.object
                if fwin:find("RedAlertTimeChatSentClass") ~= nil 
                    and fwin:find("RedAlertTimeChatSentClass"):isVisible() == false 
                    then
                    fwin:close(fwin:find("RedAlertTimeChatSentClass"))
                end
                if fwin:find("RedAlertTimeChatSentClass") == nil then
                    state_machine.excute("red_alert_time_chat_sent_window_open",0,4)
                end
                state_machine.excute("red_alert_time_friend_info_close",0,"")
                state_machine.excute("red_alert_time_chat_sent_change_to_person_chat", 0, {_datas = {user_data = {user_id = _ED.other_user_info.user_id,user_name = _ED.other_user_info.user_name }}})
                -- TipDlg.drawTextDailog("留下私聊的入口")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --屏蔽
        local red_alert_time_friend_info_shield_terminal = {
            _name = "red_alert_time_friend_info_shield",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params._datas.cells
                if _ED.other_user_info.user_name == _ED.user_info.user_name then
                    TipDlg.drawTextDailog(friends_tip_string[15])
                    state_machine.excute("red_alert_time_friend_info_close", 0, 0)
                    return
                end
                if cells.is_blacklist == true then
                    local function responseRemoveBlackManCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:onUpdateDraw()
                                state_machine.excute("game_social_friend_shield_tab_udapte_show",0,"")
                                state_machine.excute("red_alert_time_friend_info_close",0,"")
                            end
                            TipDlg.drawTextDailog(red_alert_time_str[210])
                        end
                    end
                    protocol_command.remove_black.param_list = "".._ED.other_user_info.user_id
                    NetworkManager:register(protocol_command.remove_black.code, nil, nil, nil, cells, responseRemoveBlackManCallback, false, nil)
                else
                    local tip = ConfirmTip:new()
                    tip:init(cells, cells.sureShield, red_alert_time_str[204])
                    fwin:open(tip,fwin._windows) 
                end
                
                -- TipDlg.drawTextDailog("留下屏蔽的入口")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_friend_info_friend_remove_terminal)
        state_machine.add(red_alert_time_friend_info_write_an_email_terminal)
        state_machine.add(red_alert_time_friend_info_private_chat_terminal)
        state_machine.add(red_alert_time_friend_info_shield_terminal)
        state_machine.init()
    end
    init_red_alert_time_friend_info_terminal()
end

function RedAlertTimeFriendInfo:sureDelete(sure_number)
    local function recruitDelBackCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
                state_machine.excute("game_social_friend_tag_delete_friend", 0, _ED.other_user_info.user_id)
                TipDlg.drawTextDailog(friends_tip_string[4])
                state_machine.excute("red_alert_time_friend_info_close", 0, 0)
            end
        end
    end
    if sure_number == 0 then
        protocol_command.friend_del.param_list = _ED.other_user_info.user_id
        NetworkManager:register(protocol_command.friend_del.code, nil, nil, nil, self, recruitDelBackCallBack, false, nil)
    end
end

function RedAlertTimeFriendInfo:sureShield(sure_number)
    local function responseRemoveBlackManCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:onUpdateDraw()
                state_machine.excute("game_social_friend_shield_tab_udapte_show",0,"")
                state_machine.excute("red_alert_time_friend_info_close",0,"")
            end
            TipDlg.drawTextDailog(red_alert_time_str[209])
        end
    end
    -- if _ED.other_user_info.user_name == _ED.user_info.user_name then
    --     TipDlg.drawTextDailog(friends_tip_string[15])
    --     return
    -- end
    if sure_number == 0 then
        protocol_command.pull_black.param_list = _ED.other_user_info.user_id
        NetworkManager:register(protocol_command.pull_black.code, nil, nil, nil, self, responseRemoveBlackManCallback, false, nil)
    end
end

function RedAlertTimeFriendInfo:init()
    -- self.m_object = info
    self:onInit()
    return self
end

function RedAlertTimeFriendInfo:onUpdateDraw()
    local root = self.roots[1]

    
    --玩家头像
    local Panel_friend_player_head = ccui.Helper:seekWidgetByName(root,"Panel_friend_player_head")
    Panel_friend_player_head:removeAllChildren(true)
    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object =_ED.other_user_info.user_head_id
    avatar_info.vip = _ED.other_user_info.vip_grade
    avatar_info._type = 0
    cell:init(avatar_info)
        
    -- cell:init(m_object)
    Panel_friend_player_head:addChild(cell)
    
    --玩家名称+登记
    local Text_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_player_name_lv")
    Text_player_name_lv:setString(_ED.other_user_info.user_name.." "..string.format(red_alert_all_str[13], "".._ED.other_user_info.user_level))
    
    --称号形象
    local Panel_friend_player_military = ccui.Helper:seekWidgetByName(root,"Panel_friend_player_military")
    Panel_friend_player_military:removeAllChildren(true)
    
    --称号名称
    local Text_player_military_n = ccui.Helper:seekWidgetByName(root,"Text_player_military_n")
    
    --战斗力
    local Text_player_fight_n = ccui.Helper:seekWidgetByName(root,"Text_player_fight_n")
    Text_player_fight_n:setString(exChangeNumToString(tonumber(_ED.other_user_info.user_fight)))
    
    --军团名称
    local Text_player_legion_n = ccui.Helper:seekWidgetByName(root,"Text_player_legion_n")
    if _ED.other_user_info.union_name ~= nil and _ED.other_user_info.union_name ~="" then
        Text_player_legion_n:setString(_ED.other_user_info.union_name)
    else
        Text_player_legion_n:setString(tipStringInfo_union_str[3])
    end
    
    --繁荣度
    local Text_player_boom_n = ccui.Helper:seekWidgetByName(root,"Text_player_boom_n")
    Text_player_boom_n:setString(_ED.other_user_info.booming.."/".._ED.other_user_info.forage)
    local boom_state = 0
    local boom_bar = zstring.tonumber(_ED.other_user_info.booming)/zstring.tonumber(_ED.other_user_info.forage)
    for i= 1, dms.count(dms["build_boom_lose"]) do
        local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
        if boom_bar >= tonumber(boom_proportion) then
            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
            break
        end
    end
    --繁荣度的进度条
    local LoadingBar_boom_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_bar")
    LoadingBar_boom_bar:setPercent(tonumber(_ED.other_user_info.booming)/tonumber(_ED.other_user_info.forage)*100)
    if boom_state == 0 then
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar.png")
    elseif boom_state == 1 then
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar_1.png")
    else
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar_2.png")
    end
    
    local percentage = tonumber(_ED.other_user_info.booming)/tonumber(_ED.other_user_info.forage)*100
    --基地形象
    local Panel_res_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_build_icon")
    Panel_res_build_icon:removeAllChildren(true)
    local sprite = nil
    --"天赋id,天赋类型,天赋起始时间,天赋结束时间|天赋id,天赋类型,天赋起始时间,天赋结束时间"

    -- if tonumber(_ED.other_user_info.base_image) <= 0 then
    if _ED.other_user_info.base_image == "" or _ED.other_user_info.base_image == nil then
        local fileName = "map/base_npc/spirte_beattacked.ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
        sprite = ccs.Armature:create("spirte_beattacked")
        local pic = zstring.split(dms.string(dms["user_experience_param"], _ED.other_user_info.user_level, user_experience_param.base_pic),",")
        sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))
    else
        local m_talent_data = zstring.split(_ED.other_user_info.base_image, "|")
        local _talent_id = {}
        local _talent_end_time = {}
        local _talent_sta_time = {}
        for i, v in pairs(m_talent_data) do
            local datas = zstring.split(v, ",")
            _talent_id[datas[2]] = datas[1]
            _talent_end_time[datas[2]] = datas[4]
            _talent_sta_time[datas[2]] = datas[3]
        end

        for i, v in pairs(_talent_sta_time) do
            if (new_sta_time == nil) and (i=="70" or i=="83") then
                new_sta_time = tonumber(v)
            elseif i=="70" or i=="83" then
                if tonumber(v) > new_sta_time then
                    new_sta_time = tonumber(v)
                end
            end
        end
        -- local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(_ED.other_user_info.base_image), talent_mould.base_additional), "|")
        -- local picData = zstring.split(build_ids[1], ",")
        if _talent_id["70"] ~= nil and new_sta_time == tonumber(_talent_sta_time["70"]) then
            local talentTime = tonumber(_talent_end_time["70"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
            if talentTime > 0 then
                local fileName = "map/base_npc/spirte_beattacked.ExportJson"
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
                sprite = ccs.Armature:create("spirte_beattacked")
                local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(_talent_id["70"]), talent_mould.base_additional), "|")
                local picData = zstring.split(build_ids[1], ",")
                sprite:getAnimation():playWithIndex(tonumber(picData[2]))
            end
        elseif _talent_id["83"] ~= nil and new_sta_time == tonumber(_talent_sta_time["83"]) then
            local talentTime = tonumber(_talent_end_time["83"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
            if talentTime > 0 then
                local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(_talent_id["83"]), talent_mould.base_additional), "|")
                local picData = zstring.split(build_ids[1], ",")
                local element = dms.element(dms["world_mine_mould"], tonumber(picData[2]))
                local pic = dms.atos(element, world_mine_mould.pic)
                local armature_index = dms.atoi(element, world_mine_mould.armature_index)
                local effect_paths = string.format(config_res.images.ui.home.home_build_effect, tonumber(pic))
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
                local armature = ccs.Armature:create("home_build_"..pic)
                draw.initArmature(armature, nil, -1, 0, 1)
                armature:getAnimation():playWithIndex(armature_index)
                -- armature:setPosition(0,tile:getContentSize().height/2)
                armature:setScale(0.75)
                sprite = armature
            end
        else
        end
        if sprite == nil then
            local fileName = "map/base_npc/spirte_beattacked.ExportJson"
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
            sprite = ccs.Armature:create("spirte_beattacked")
            local pic = zstring.split(dms.string(dms["user_experience_param"], _ED.other_user_info.user_level, user_experience_param.base_pic),",")
            sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))
        end
    end
    -- Panel_res_build_icon:setBackGroundImage(string.format("map/base_npc/map_%d.png", zstring.tonumber(_ED.other_user_info.base_image)+301))
    if sprite ~= nil then
        sprite:setAnchorPoint(cc.p(0.5, 0.5))
        Panel_res_build_icon:addChild(sprite)
        sprite:setPosition(cc.p(Panel_res_build_icon:getContentSize().width/2,Panel_res_build_icon:getContentSize().height/2))
    end
    
    --vip的等级
    local Text_vip_lv = ccui.Helper:seekWidgetByName(root,"Text_vip_lv")
    Text_vip_lv:setString(_ED.other_user_info.vip_grade)

    --军衔
    local rank_name = dms.string(dms["avatar_mould"], tonumber(_ED.other_user_info.rank_id), avatar_mould.name)
    local rank_pic = dms.string(dms["avatar_mould"], tonumber(_ED.other_user_info.rank_id), avatar_mould.pic)
    local Panel_friend_player_military = ccui.Helper:seekWidgetByName(root,"Panel_friend_player_military")
    Panel_friend_player_military:removeBackGroundImage()
    Panel_friend_player_military:setBackGroundImage(string.format("images/ui/props/props_%s.png", rank_pic))
    local Text_player_military_n = ccui.Helper:seekWidgetByName(root,"Text_player_military_n")
    Text_player_military_n:setString(rank_name)
    
    self.is_friend = false
    for i, v in pairs(_ED.friend_info) do
        if tonumber(v.user_id) == tonumber(_ED.other_user_info.user_id) then
            self.is_friend = true
        end
    end
    if self.is_friend == true then
        ccui.Helper:seekWidgetByName(root,"Button_player_delete_friend"):setTitleText(red_alert_time_str[208])
    else
        ccui.Helper:seekWidgetByName(root,"Button_player_delete_friend"):setTitleText(red_alert_time_str[207])
    end
    self.is_blacklist = false 
    for i, v in pairs(_ED.black_user) do
        if tonumber(v.shield_user_id) == tonumber(_ED.other_user_info.user_id) then
            self.is_blacklist = true
        end
    end
    if self.is_blacklist == true  then
        ccui.Helper:seekWidgetByName(root,"Button_player_shield"):setTitleText(red_alert_time_str[206])
    else
        ccui.Helper:seekWidgetByName(root,"Button_player_shield"):setTitleText(red_alert_time_str[205])
    end
end

function RedAlertTimeFriendInfo:onInit()
    local csbRedAlertTimeFriendInfo = csb.createNode(config_csb.friend.friend_player_infor)
    local root = csbRedAlertTimeFriendInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRedAlertTimeFriendInfo)
    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_friend_info_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_friend_info_close",
        terminal_state = 0,
    },
    nil,3)
    
    --删除好友
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_delete_friend"), nil, 
    {
        terminal_name = "red_alert_time_friend_info_friend_remove",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cells = self
    },
    nil,1)
    
    --写邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_mail"), nil, 
    {
        terminal_name = "red_alert_time_friend_info_write_an_email",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --私聊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_chat"), nil, 
    {
        terminal_name = "red_alert_time_friend_info_private_chat",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        -- object = self.m_object
    },
    nil,1)
    
    --屏蔽
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_shield"), nil, 
    {
        terminal_name = "red_alert_time_friend_info_shield",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cells = self
        -- object = self.m_object
    },
    nil,1)
    
    self:onUpdateDraw()
    
end

function RedAlertTimeFriendInfo:onExit()
    
end