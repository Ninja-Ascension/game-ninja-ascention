-- ----------------------------------------------------------------------------------------------------
-- 说明：数码玩家信息页
-------------------------------------------------------------------------------------------------------
SmPlayerInfomationPage = class("SmPlayerInfomationPageClass", Window)
local sm_player_infomation_page_open_terminal = {
    _name = "sm_player_infomation_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local page = SmPlayerInfomationPage:createCell():init()
    	return page
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_player_infomation_page_open_terminal)
state_machine.init()
    
function SmPlayerInfomationPage:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    self.times = 0
    self.text_time = nil
	
    local function init_sm_player_infomation_page_terminal()
        --显示
        local sm_player_infomation_page_show_terminal = {
            _name = "sm_player_infomation_page_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                	instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏
        local sm_player_infomation_page_hide_terminal = {
            _name = "sm_player_infomation_page_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --修改头像
        local sm_player_infomation_page_change_head_terminal = {
            _name = "sm_player_infomation_page_change_head",
            _init = function (terminal) 
                app.load("client.l_digital.player.SmPlayerSystemSetChangeHead")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- DSC进入个性设置界面
                local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
                if fun_is_open == true then
                    app.load("client.l_digital.player.PersonalitySettingMain")
                    
                    state_machine.excute("personality_setting_main_window_open", 0, nil)
                else
                    state_machine.excute("sm_player_system_set_change_head_open",0,"sm_player_system_set_change_head_open.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --修改昵称
        local sm_player_infomation_page_change_nickName_terminal = {
            _name = "sm_player_infomation_page_change_nickName",
            _init = function (terminal) 
                app.load("client.l_digital.player.SmPlayerChangeNickName")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_player_change_nick_name_open",0,"sm_player_change_nick_name_open.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --修改签名
        local sm_player_infomation_page_change_signature_terminal = {
            _name = "sm_player_infomation_page_change_signature",
            _init = function (terminal) 
                app.load("client.l_digital.player.SmPlayerChangeSignature")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_player_change_signature_open",0,"sm_player_change_signature_open.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新名称
        local sm_player_infomation_page_updata_nickName_terminal = {
            _name = "sm_player_infomation_page_updata_nickName",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawNickName()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新头像
        local sm_player_infomation_page_updata_head_terminal = {
            _name = "sm_player_infomation_page_updata_head",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawHead()
                state_machine.excute("user_information_update_role_head_info", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新个性签名
        local sm_player_infomation_page_updata_signature_terminal = {
            _name = "sm_player_infomation_page_updata_signature",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawSignature()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_player_infomation_page_designation_open_terminal = {
            _name = "sm_player_infomation_page_designation_open",
            _init = function (terminal)
                app.load("client.l_digital.player.SmTitleInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_title_info_window_open", 0, "sm_title_info_window_open")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新红点显示
        local sm_player_infomation_page_update_red_dot_terminal = {
            _name = "sm_player_infomation_page_update_red_dot",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:updateDrawRedDot()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_player_infomation_page_show_terminal)
		state_machine.add(sm_player_infomation_page_hide_terminal)
        state_machine.add(sm_player_infomation_page_change_head_terminal)
        state_machine.add(sm_player_infomation_page_change_nickName_terminal)
        state_machine.add(sm_player_infomation_page_change_signature_terminal)
        state_machine.add(sm_player_infomation_page_updata_nickName_terminal)
        state_machine.add(sm_player_infomation_page_updata_head_terminal)
        state_machine.add(sm_player_infomation_page_updata_signature_terminal)
        state_machine.add(sm_player_infomation_page_designation_open_terminal)
        state_machine.add(sm_player_infomation_page_update_red_dot_terminal)
        state_machine.init()
    end
    
    init_sm_player_infomation_page_terminal()
end

function SmPlayerInfomationPage:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = _ED.user_info.head_frame.curHeadFrameID,
        headFrameStage = _ED.user_info.head_frame.curHeadFrameStage,
        headID = _ED.user_info.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function SmPlayerInfomationPage:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		local headIcon = self:getNewHeadIcon()
        Panel_player_icon:addChild(headIcon)
	else
        local quality_path = ""
        if tonumber(_ED.vip_grade) > 0 then
            quality_path = "images/ui/quality/player_1.png"
        else
            quality_path = "images/ui/quality/player_2.png"
        end
        local SpritKuang = cc.Sprite:create(quality_path)
        SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
        SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
        Panel_player_icon:addChild(SpritKuang,0)
    
        local big_icon_path = ""
        local pic = tonumber(_ED.user_info.user_head)
        if pic >= 9 then
            big_icon_path = string.format("images/ui/props/props_%d.png", pic)
        else
            big_icon_path = string.format("images/ui/home/head_%d.png", pic)
        end
        local sprit = cc.Sprite:create(big_icon_path)
        sprit:setAnchorPoint(cc.p(0.5,0.5))
        sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
        Panel_player_icon:addChild(sprit,0)
    end
end

function SmPlayerInfomationPage:drawNickName()
    local root = self.roots[1]
    --昵称
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    Text_player_name:setString(_ED.user_info.user_name)
end

function SmPlayerInfomationPage:drawSignature()
    local root = self.roots[1]
    --个性签名
    local Text_qianming = ccui.Helper:seekWidgetByName(root, "Text_qianming")
    if _ED.user_info.user_signature == nil or _ED.user_info.user_signature == "" then -- 个性签名
        Text_qianming:setString(_new_interface_text[105])
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            Text_qianming:setColor(cc.c3b(190,190,190))
        else
            Text_qianming:setColor(cc.c3b(71,51,15))
        end
    else
        Text_qianming:setString(_ED.user_info.user_signature)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            Text_qianming:setColor(cc.c3b(255,255,255))
        else
            Text_qianming:setColor(cc.c3b(86,34,13))
        end
    end
end

-- 更新红点绘制
function SmPlayerInfomationPage:updateDrawRedDot()
    self.Image_red:setVisible(getPlayerAllHeadFrameState())
end

function SmPlayerInfomationPage:onUpdate(dt)
    if self.text_time ~= nil and self.times > 0 then
        self.times = self.times + dt
        self.text_time:setString(os.date("%H"..":".."%M"..":%S" ,getBaseGTM8Time(self.times)))
    end
end

function SmPlayerInfomationPage:onUpdataDraw()
	local root = self.roots[1]
    --vip
    local Text_vip = ccui.Helper:seekWidgetByName(root, "Text_vip")
    Text_vip:setString(_ED.vip_grade)
    --等级
    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    Text_lv:setString(_ED.user_info.user_grade)
    --经验
    local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")
    local cur_exp = tonumber(_ED.user_info.user_experience)
    local total_exp = tonumber(_ED.user_info.user_grade_need_experience)
    local exp_percent = cur_exp / total_exp * 100
    Text_exp:setString(cur_exp.."/"..total_exp)
    local LoadingBar_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp")
    LoadingBar_exp:setPercent(exp_percent)

    -- 根据QA报错，重新提交（如果满级了就显示max）
    local configMax = zstring.tonumber(dms.int(dms["user_config"], 5, user_config.param))
    if tonumber(_ED.user_info.user_grade) == configMax then
        Text_exp:setString("MAX")
        LoadingBar_exp:setPercent(100)
    end

    --id
    local Text_id_n = ccui.Helper:seekWidgetByName(root, "Text_id_n")
    Text_id_n:setString(_ED.user_info.user_id)
    --公会名
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    --公会id
    local Text_legion_id_n = ccui.Helper:seekWidgetByName(root, "Text_legion_id_n")
    if _ED.union.union_info == nil or _ED.union.union_info == {}  
        or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
        Text_legion_name:setString(_string_piece_info[310])
        Text_legion_id_n:setString(_string_piece_info[310])
    else
        Text_legion_name:setString(_ED.union.union_info.union_name)
        Text_legion_id_n:setString(_ED.union.union_info.union_id)
    end
    --战力
    local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
    local fight_number = tonumber(_ED.user_info.fight_capacity)
    -- if fight_number > 100000000 then
    --     Text_fighting_n:setString(math.floor(fight_number/100000000) .. string_equiprety_name[39])
    -- else
    if fight_number > 10000 then
        Text_fighting_n:setString(math.floor(fight_number/1000) .. string_equiprety_name[40])
    else
        Text_fighting_n:setString(fight_number)
    end
    --数码兽等级上限
    local Text_max_lv_n = ccui.Helper:seekWidgetByName(root, "Text_max_lv_n")
    Text_max_lv_n:setString(_ED.user_info.user_grade)
    --版本号
    local Text_ver_n = ccui.Helper:seekWidgetByName(root, "Text_ver_n")
    Text_ver_n:setString(m_sVersion)
    --服务器时间
    local Text_time_n = ccui.Helper:seekWidgetByName(root, "Text_time_n")
    self.text_time = Text_time_n
    self.times = os.time() - _ED.native_time + _ED.system_time

    -- 头像红点图片
    self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")

    self:drawHead()
    self:drawNickName()
    self:drawSignature()
    if self.Image_red ~= nil then
        self:updateDrawRedDot()
    end
end

function SmPlayerInfomationPage:onInit()
	local csbUserInfo = csb.createNode("player/role_information_tab_1.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)
    --修改头像
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_tx"),nil, 
    {
        terminal_name = "sm_player_infomation_page_change_head",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --修改昵称
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_name"),nil, 
    {
        terminal_name = "sm_player_infomation_page_change_nickName",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --修改签名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_qm"),nil, 
    {
        terminal_name = "sm_player_infomation_page_change_signature",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- dsc称号从系统设置移到玩家信息面板
    if __lua_project_id == __lua_project_l_digital then
        local Button_tittle = ccui.Helper:seekWidgetByName(root, "Button_tittle")
        if Button_tittle ~= nil then
            fwin:addTouchEventListener(Button_tittle,nil, 
            {
                terminal_name = "sm_player_infomation_page_designation_open",     
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
        end
    end

	self:onUpdataDraw()
end

function SmPlayerInfomationPage:init(params)
    -- local _windows = params
    -- self._rootWindows = _windows
    self:onInit()
    return self
end

function SmPlayerInfomationPage:clearUIInfo( ... )
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
        local Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
        if Image_red ~= nil then
            Image_red:setVisible(false)
        end
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
            Panel_prop:setTouchEnabled(true)
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
    Panel_player_icon:removeAllChildren(true)
end

function SmPlayerInfomationPage:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	state_machine.remove("sm_player_infomation_page_show")
    state_machine.remove("sm_player_infomation_page_hide")
    state_machine.remove("sm_player_infomation_page_change_head")
    state_machine.remove("sm_player_infomation_page_change_nickName")
    state_machine.remove("sm_player_infomation_page_change_signature")
    state_machine.remove("sm_player_infomation_page_updata_nickName")
    state_machine.remove("sm_player_infomation_page_updata_head")
    state_machine.remove("sm_player_infomation_page_updata_signature")
    state_machine.remove("sm_player_infomation_page_designation_open")
    state_machine.remove("sm_player_infomation_page_update_red_dot")
    
end

function SmPlayerInfomationPage:createCell()
    local cell = SmPlayerInfomationPage:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 1)
    return cell
end