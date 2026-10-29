-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场角色信息界面
-------------------------------------------------------------------------------------------------------
ArenaPlayerInfoWindow = class("ArenaPlayerInfoWindowClass", Window)

local sm_arena_player_info_window_open_terminal = {
    _name = "sm_arena_player_info_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaPlayerInfoWindowClass")
        if nil == _homeWindow then
            local panel = ArenaPlayerInfoWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_arena_player_info_window_close_terminal = {
    _name = "sm_arena_player_info_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaPlayerInfoWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaPlayerInfoWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_arena_player_info_window_open_terminal)
state_machine.add(sm_arena_player_info_window_close_terminal)
state_machine.init()
    
function ArenaPlayerInfoWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.campaign.icon.arena_role_icon_cell")
    local function init_sm_arena_player_info_window_terminal()
        -- 显示界面
        local sm_arena_player_info_window_display_terminal = {
            _name = "sm_arena_player_info_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ArenaPlayerInfoWindowWindow = fwin:find("ArenaPlayerInfoWindowClass")
                if ArenaPlayerInfoWindowWindow ~= nil then
                    ArenaPlayerInfoWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_arena_player_info_window_hide_terminal = {
            _name = "sm_arena_player_info_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ArenaPlayerInfoWindowWindow = fwin:find("ArenaPlayerInfoWindowClass")
                if ArenaPlayerInfoWindowWindow ~= nil then
                    ArenaPlayerInfoWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_arena_player_info_add_friend_terminal = {
            _name = "sm_arena_player_info_add_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- if true then
                --     return -- 竞技场过来的玩家id有问题 暂时屏蔽
                -- end
                local role = instance.roleInstance
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- local str = fwin:find("FriendManagerThreeClass")
                        -- if str ~= nil then
                        --     state_machine.excute("friend_manager_three_add", 0, role.id)
                        -- end
                        -- if response.node.types == 1 then
                        --     if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        --         state_machine.excute("friend_manager_recommend_cell_update", 0, response.node.cell)
                        --     end
                        -- end
                        -- local str2 = fwin:find("FriendManagerRecommendClass")
                        -- if str2 ~= nil then
                        --     state_machine.excute("friend_manager_recommend_del", 0, role.id)
                        -- end
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            TipDlg.drawTextDailog(_string_piece_info[259] .. role.name .._string_piece_info[260])
                        end
                        state_machine.excute("sm_arena_player_info_window_close", 0, nil)
                    end
                end
                local id = zstring.tonumber(role.id)
                if id == 0 then
                    id = role.user_id
                end
                protocol_command.friend_request.param_list = id .."\r\n".._string_piece_info[368]
                NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_arena_player_info_one_by_one_chat_terminal = {
            _name = "sm_arena_player_info_one_by_one_chat",
            _init = function (terminal) 
                 app.load("client.chat.ChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local str = fwin:find("ChatStorageClass")
                if str ~= nil then
                    state_machine.excute("chat_whisper_page_other", 0, instance.roleInstance.name)
                else
                    local cell = ChatStorage:new()
                    cell:init(1)
                    fwin:open(cell, fwin._ui)
                    state_machine.excute("chat_whisper_page_other", 0, instance.roleInstance.name)
                end
                local str2 = fwin:find("FriendManagerRecommendClass")
                if str2 ~= nil then
                    fwin:close(str2)
                end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_arena_player_info_window_display_terminal)
        state_machine.add(sm_arena_player_info_window_hide_terminal)
        state_machine.add(sm_arena_player_info_one_by_one_chat_terminal)
        state_machine.add(sm_arena_player_info_add_friend_terminal)
        state_machine.init()
    end
    init_sm_arena_player_info_window_terminal()
end

function ArenaPlayerInfoWindow:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.roleInstance.headFrameID,
        headFrameStage = self.roleInstance.headFrameStage,
        headID = self.roleInstance.icon,
        vipLevel = self.roleInstance.vip,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function ArenaPlayerInfoWindow:onHeadDraw(headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
    self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end

    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
    if Image_double ~= nil then
        Image_double:setVisible(false)
    end
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    local quality_path = 0
    local quality_kuang = 1
    if tonumber(vipLevel) > 0 then
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)
    else
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 1)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 1)
    end
    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    return roots
end

function ArenaPlayerInfoWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    
    -- 头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_icon")
    Panel_player_icon:removeAllChildren(true)
    
    local headIcon = nil
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
    if fun_is_open == true then
        -- 新增头像框
        local Panel_vip = ccui.Helper:seekWidgetByName(root,"Panel_vip")
        if Panel_vip ~= nil then
            Panel_vip:setVisible(false)
        end
		headIcon = self:getNewHeadIcon()
    else
        -- local icon = ArenaRoleIconCell:createCell()
        -- icon:init(tonumber(self.roleInstance.icon), 1)
        headIcon = self:onHeadDraw(self.roleInstance.icon, self.roleInstance.vip)
        -- Panel_player_icon:addChild(icon)
    end
    if headIcon ~= nil then
        Panel_player_icon:addChild(headIcon)
    end

    --玩家名称
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(self.roleInstance.name)
    --玩家等级
    local Text_lv_n = ccui.Helper:seekWidgetByName(root,"Text_lv_n")
    Text_lv_n:setString(self.roleInstance.level)
    --玩家排名
    local Text_rank = ccui.Helper:seekWidgetByName(root,"Text_rank")
    local Text_rank_n = ccui.Helper:seekWidgetByName(root,"Text_rank_n")
    if nil ~= self.roleInstance.rank and tonumber(self.roleInstance.rank) > 0 then
        Text_rank:setVisible(true)
        Text_rank_n:setString(self.roleInstance.rank)
    else
        Text_rank:setVisible(false)
        Text_rank_n:setString("")
    end

    --玩家战斗力
    local Text_fighting = ccui.Helper:seekWidgetByName(root,"Text_fighting")
    local Text_fighting_n = ccui.Helper:seekWidgetByName(root,"Text_fighting_n")
    Text_fighting_n:setString(self.roleInstance.force)
    if nil == self.roleInstance.rank then
        Text_fighting:setPositionY(Text_rank:getPositionY())
        Text_fighting_n:setPositionY(Text_rank_n:getPositionY())
    end

    --玩家速度
    local Text_speed_n = ccui.Helper:seekWidgetByName(root,"Text_speed_n")
    
    --玩家公会
    local Text_to_guild = ccui.Helper:seekWidgetByName(root,"Text_to_guild")
    Text_to_guild:setString("")
    if self.roleInstance.arame == "?" then
    	-- Text_to_guild:setString(_new_interface_text[38])
	else
		Text_to_guild:setString(_new_interface_text[38] .. self.roleInstance.arame)
	end
    --武将列表
   	local ListView_player_zr = ccui.Helper:seekWidgetByName(root,"ListView_player_zr")
   	ListView_player_zr:removeAllItems()
   	local shipAllData = zstring.split(self.roleInstance.template[1], "!")
   	for i, v in pairs(shipAllData) do
   		--模板id:等级:进阶数据:星级:品阶:战力:皮肤ID
   		local shipData = zstring.split(v, ":")
   		local cell = HeroIconListCell:createCell()
   		local ship = {}
   		ship.ship_template_id = shipData[1]
   		ship.evolution_status = shipData[3]
   		ship.Order = shipData[5]
   		ship.StarRating = shipData[4]
   		ship.ship_grade = shipData[2]
   		ship.ship_id = -1
        ship.skin_id = zstring.tonumber(shipData[7])
   		cell:init(ship, i,true)
   		ListView_player_zr:addChild(cell)
   	end
   	ListView_player_zr:requestRefreshView()
    local Text_speed = ccui.Helper:seekWidgetByName(root,"Text_speed")
    if self.roleInstance.speed ~= nil then
        Text_speed:setVisible(true)
        Text_speed_n:setVisible(true)
        Text_speed_n:setString(self.roleInstance.speed)
    else
        Text_speed:setVisible(false)
        Text_speed_n:setVisible(false)
    end

    local Image_vip_icon = ccui.Helper:seekWidgetByName(root,"Image_vip_icon")
    Image_vip_icon:setVisible(true)
    local Text_vip_n = ccui.Helper:seekWidgetByName(root,"Text_vip_n")
    Text_vip_n:setVisible(true)
    Text_vip_n:setString(self.roleInstance.vip)

    local id = zstring.tonumber(self.roleInstance.id)
    if id == 0 then
        id = self.roleInstance.user_id
    end

    local curRank = zstring.tonumber(self.roleInstance.rank)
    local myRank = _ED.arena_user_rank ~= nil and tonumber(_ED.arena_user_rank) or nil
    if zstring.tonumber(id) <= 0 or zstring.tonumber(id) == tonumber(_ED.user_info.user_id) or curRank == myRank then
        local Button_add_friend = ccui.Helper:seekWidgetByName(root,"Button_add_friend")
        if Button_add_friend ~= nil then
            Button_add_friend:setVisible(false)
        end
        local Button_call = ccui.Helper:seekWidgetByName(root,"Button_call")
        if Button_call ~= nil then
            Button_call:setVisible(false)
        end
    end
end

function ArenaPlayerInfoWindow:init(params)
    self.roleInstance = params
    self:onInit()
    return self
end

function ArenaPlayerInfoWindow:onInit()
    local csbArenaPlayerInfoWindow = csb.createNode("campaign/ArenaStorage/ArenaStorage_player_info_window.csb")
    local root = csbArenaPlayerInfoWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaPlayerInfoWindow)
    local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_player_info_window.csb")
    table.insert(self.actions, action)
    csbArenaPlayerInfoWindow:runAction(action)
	action:play("window_open", false)

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_arena_player_info_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    --私聊
    local Button_call = ccui.Helper:seekWidgetByName(root,"Button_call")
    if Button_call ~= nil then
       fwin:addTouchEventListener(Button_call, nil, 
        {
            terminal_name = "sm_arena_player_info_one_by_one_chat",
            terminal_state = 0,
            touch_black = true,
        },
        nil,3) 
        Button_call:setVisible(true)
    end
    --加好友
    local Button_add_friend = ccui.Helper:seekWidgetByName(root,"Button_add_friend")
    if Button_add_friend ~= nil then
       fwin:addTouchEventListener(Button_add_friend, nil, 
        {
            terminal_name = "sm_arena_player_info_add_friend",
            terminal_state = 0,
            touch_black = true,
        },
        nil,3)
        Button_add_friend:setVisible(true) 
    end
    self:onUpdateDraw()
end

function ArenaPlayerInfoWindow:clearUIInfo( ... )
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        local root = self.roots[2]
        local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
        local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
        local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
        local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
        local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
        local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
        local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
        local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
        local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
        local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
        local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
        local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
        local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
        local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
        local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
        local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
        local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
        local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
        local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
        local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
        if Image_double ~= nil then
            Image_double:setVisible(false)
        end
        if Image_xuanzhong ~= nil then
            Image_xuanzhong:setVisible(false)
        end
        if Image_3 ~= nil then
            Image_3:setVisible(false)
        end
        if Label_l_order_level ~= nil then 
            Label_l_order_level:setVisible(true)
            if Label_l_order_level._x then
                Label_l_order_level:setPositionX(Label_l_order_level._x)
            end
            Label_l_order_level:setString("")
        end
        if Label_name ~= nil then
            Label_name:setString("")
            Label_name:setVisible(true)
        end
        if Label_quantity ~= nil then
            Label_quantity:setString("")
        end
        if Label_shuxin ~= nil then
            Label_shuxin:setString("")
        end
        if Panel_prop ~= nil then
            Panel_prop:removeAllChildren(true)
            Panel_prop:removeBackGroundImage()
        end
        if Panel_kuang ~= nil then
            Panel_kuang:removeAllChildren(true)
            Panel_kuang:removeBackGroundImage()
        end
        if Panel_ditu ~= nil then
            Panel_ditu:removeAllChildren(true)
            Panel_ditu:removeBackGroundImage()
        end
        if Panel_star ~= nil then
            Panel_star:removeAllChildren(true)
            Panel_star:removeBackGroundImage()
        end
        if Panel_props_right_icon ~= nil then
            Panel_props_right_icon:removeAllChildren(true)
            Panel_props_right_icon:removeBackGroundImage()
        end
        if Panel_props_left_icon ~= nil then
            Panel_props_left_icon:removeAllChildren(true)
            Panel_props_left_icon:removeBackGroundImage()
        end
        if Panel_num ~= nil then
            Panel_num:removeAllChildren(true)
            Panel_num:removeBackGroundImage()
        end
        if Panel_4 ~= nil then
            Panel_4:removeAllChildren(true)
            Panel_4:removeBackGroundImage()
        end
        if Text_1 ~= nil then
            Text_1:setString("")
        end
    end
    local root = self.roots[1]
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    if Panel_player_icon ~= nil then
        Panel_player_icon:removeAllChildren(true)
    end
end

function ArenaPlayerInfoWindow:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    state_machine.remove("sm_arena_player_info_window_display")
    state_machine.remove("sm_arena_player_info_window_hide")
    state_machine.remove("sm_arena_player_info_one_by_one_chat")
    state_machine.remove("sm_arena_player_info_add_friend")
end