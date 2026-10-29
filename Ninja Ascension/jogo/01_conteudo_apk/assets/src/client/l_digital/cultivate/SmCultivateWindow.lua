-----------------------------
-- 养成主界面
-----------------------------
SmCultivateWindow = class("SmCultivateWindowClass", Window)

--打开界面
local sm_cultivate_window_open_terminal = {
	_name = "sm_cultivate_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateWindowClass") == nil then
			fwin:open(SmCultivateWindow:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_cultivate_window_close_terminal = {
	_name = "sm_cultivate_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("notification_center_update", 0, "push_notification_home_cultivate")
        fwin:close(fwin:find("UserTopInfoAClass"))
        state_machine.excute("menu_back_home_page", 0, "") 
		fwin:close(fwin:find("SmCultivateWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_window_open_terminal)
state_machine.add(sm_cultivate_window_close_terminal)

state_machine.init()

function SmCultivateWindow:ctor()
	self.super:ctor()
	self.roots = {}

    -- 开启条件id列表 对应 fun_open_condition
    -- 天赋 数码精神 神器 成就 星座守护 数码合金 援护小队 忍具 组合卡 卡册系统 忍列传 神兽养成
    self._fun_open_list = {121, 122, 123, 124, 125, 126, 191, 192, 193, 194, 199, 200}
    self.finishRunAction = false        -- 动画播放完成
    self.finishJumpScrollview = false   -- scrollview跳转完成
    self.percent = nil                  -- 需要跳转的进度

    app.load("client.l_digital.cultivate.SmCultivateSpiritWindow")
    app.load("client.l_digital.cultivate.talent.SmTalentMainWindow")
    app.load("client.l_digital.cultivate.artifact.SmCultivateArtifactWindow")
    app.load("client.l_digital.cultivate.achieve.SmCultivateAchieveWindow")
    app.load("client.l_digital.cultivate.constellation.SmCultivateConstellationWindow")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixWindow")
    app.load("client.l_digital.cultivate.soulward.SoulWardingWindow")
    app.load("client.l_digital.cultivate.silkbag.silk_bags")
    app.load("client.l_digital.cultivate.combinationCard.CombinationCardWindow")
    app.load("client.l_digital.cultivate.illustration.Illustration")
    app.load("client.l_digital.cultivate.roleBiography.RoleBiographyChapter")
    app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsMainUI")

    local function init_sm_cultivate_window_terminal()
        local sm_cultivate_window_open_features_terminal = {
            _name = "sm_cultivate_window_open_features",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_cultivate_window_open_features")
				local m_index = params._datas.m_index
                local fun_open_id = self._fun_open_list[m_index]

                if not fun_open_id then
                    -- print("没有配置对应的fun_open_condition配置")
                    return
                end

                if true == funOpenDrawTip(fun_open_id) then
                    state_machine.unlock("sm_cultivate_window_open_features")
                    return
                end
                if tonumber(m_index) == 1 then
                    state_machine.excute("sm_talent_main_window_open",0,"")
                elseif tonumber(m_index) == 2 then
                    state_machine.excute("sm_cultivate_spirit_window_open",0,"")
                elseif tonumber(m_index) == 3 then
                    state_machine.excute("sm_cultivate_artifact_window_open",0,"")
                elseif tonumber(m_index) == 4 then
                    state_machine.excute("sm_cultivate_achieve_window_open",0,"")
                elseif tonumber(m_index) == 5 then
                    if _ED.constellation_redot_data and _ED.constellation_info then
                        state_machine.excute("sm_cultivate_constellation_window_open",0,"")
                    else
                        TipDlg.drawTextDailog(_wait_open_tip)
                    end
                    -- TipDlg.drawTextDailog(_wait_open_tip)
                    -- state_machine.unlock("sm_cultivate_window_open_features")
                    -- return
                elseif tonumber(m_index) == 6 then
                    state_machine.excute("alloy_matrix_window_open",0,"")
                elseif tonumber(m_index) == 7 then
                    state_machine.excute("soul_warding_window_open",0,"")
                elseif tonumber(m_index) == 8 then
                    state_machine.excute("silk_bag_window_open",0,"")
                elseif tonumber(m_index) == 9 then
                    state_machine.excute("combination_card_window_open",0,"")
                elseif tonumber(m_index) == 10 then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("illustration_window_open",0,"")
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.user_card_info_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                elseif tonumber(m_index) == 11 then
                     local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("role_biography_chapter_window_open", 0, nil)
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.biographies_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                elseif tonumber(m_index) == 12 then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("mythical_animals_main_ui_window_open", 0, nil)
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.magical_animals_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                state_machine.unlock("sm_cultivate_window_open_features")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --星座红点显示
        local sm_cultivate_constellation_redot_update_terminal = {
            _name = "sm_cultivate_constellation_redot_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --星座守护红点
                local xz_redot = ccui.Helper:seekWidgetByName(instance.roots[1],"Image_red_cscf")
                local opend_constellation = {}
                if true == funOpenDrawTip(125, false) then
                    if xz_redot ~= nil then
                        xz_redot:setVisible(false)
                    end
                else
                    local is_show = false
                    for i,v in pairs(_ED.constellation_redot_data) do
                        for k,z in pairs(v) do
                            for j,n in pairs(z) do
                                if tonumber(n) == 0 then
                                    is_show = true
                                    break
                                else
                                    is_show = false
                                end
                            end
                        end
                    end
                    if xz_redot ~= nil then
                        xz_redot:setVisible(is_show)
                    end
                end
                state_machine.excute("notification_center_update", 0, "push_notification_home_cultivate")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        --自动跳转到特定位置
        local sm_cultivate_jump_to_position_terminal = {
            _name = "sm_cultivate_jump_to_position",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --自动跳转到特定位置
                if params ~= nil and instance ~= nil then
                    local progress = zstring.split(params, ",")
                    local cur = tonumber(progress[1])
                    local all = tonumber(progress[2])
                    -- 计算该功能占比多少
                    instance:jumpScrollView(cur / all)
                end
                return nil
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_constellation_redot_update_terminal)
        state_machine.add(sm_cultivate_window_open_features_terminal)
        state_machine.add(sm_cultivate_jump_to_position_terminal)
        state_machine.init()
    end
    init_sm_cultivate_window_terminal()
end

function SmCultivateWindow:jumpScrollView(percent)
    if percent ~= nil then
        self.percent = percent
    end
    if self.percent == nil or self.finishRunAction == false then
        return
    end
    
    if self.finishJumpScrollview == false then
        local root = self.roots[1]
        local ScrollView_yc = ccui.Helper:seekWidgetByName(root, "ScrollView_yc")
        
        if ScrollView_yc ~= nil then
            ScrollView_yc:scrollToPercentHorizontal (self.percent * 100 , 1 , false)
            self.finishJumpScrollview = true
        end
    end
end

function SmCultivateWindow:onUpdateDraw()
    local root = self.roots[1]

    for i = 1, #self._fun_open_list do
        local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock_"..i)
        local Text_open_lv_info = ccui.Helper:seekWidgetByName(root,"Text_open_lv_info_"..i)
        if nil ~= Image_lock and nil ~= Text_open_lv_info then
            local fun_open_id = self._fun_open_list[i]
            local openData = dms.int(dms["fun_open_condition"], fun_open_id, fun_open_condition.level)
            
            if Image_lock then
                if tonumber(_ED.user_info.user_grade) >= openData  then
                    Image_lock:setVisible(false)
                else
                    -- if i == 3 then
                    --     if funOpenDrawTip(178, false) == false then
                    --         ccui.Helper:seekWidgetByName(root,"Image_sq"):loadTexture("images/ui/text/TF_res/c3.png")
                    --     else
                    --         ccui.Helper:seekWidgetByName(root,"Image_sq"):loadTexture("images/ui/text/TF_res/c0.png")
                    --     end
                    -- end
                    Image_lock:setVisible(true)
                    Text_open_lv_info:setString(string.format(_new_interface_text[144],openData))
                end
            end
        end
    end

    
end

function SmCultivateWindow:init()
	self:onInit()
    return self
end

function SmCultivateWindow:onInit()
    local csbItem = csb.createNode("cultivate/cultivate.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_cultivate_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    
    --天赋
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_talent",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_tf"),
        _invoke = nil,
        _interval = 0.5,})
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_tf"), nil, 
    {
        terminal_name = "sm_cultivate_window_open_features", 
        m_index = 1,
        terminal_state = 0
    }, nil, 0)

    --数码精神
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_spirit",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_smjs"),
        _invoke = nil,
        _interval = 0.5,})
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_smjs"), nil, 
    {
        terminal_name = "sm_cultivate_window_open_features", 
        m_index = 2,
        terminal_state = 0
    }, nil, 0)

    --神器
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_sq"), nil, 
    {
        terminal_name = "sm_cultivate_window_open_features", 
        m_index = 3,
        terminal_state = 0
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_artifact",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_sq"),
        _invoke = nil,
        _interval = 0.5,})

    --成就
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_cj"), nil, 
    {
        terminal_name = "sm_cultivate_window_open_features", 
        m_index = 4,
        terminal_state = 0
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_achieve",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_cj"),
        _invoke = nil,
        _interval = 0.5,})

    if ccui.Helper:seekWidgetByName(root,"Image_smhj") then
        --诸神赐福
        ccui.Helper:seekWidgetByName(root,"Image_smhj"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_smhj"), nil, 
        {
            terminal_name = "sm_cultivate_window_open_features", 
            m_index = 5,
            terminal_state = 0
        }, nil, 0)
    end

    if _ED.constellation_redot_data and _ED.constellation_info then 
        state_machine.excute("sm_cultivate_constellation_redot_update", 0, self)
    end

     --数码合金
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_smhj_0"), nil, 
    {
        terminal_name = "sm_cultivate_window_open_features", 
        m_index = 6,
        terminal_state = 0
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_matrix",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_smhj_0"),
        _invoke = nil,
        _interval = 0.5,})
    
    if ccui.Helper:seekWidgetByName(root,"Image_lhsh") then
        --灵魂守卫
        ccui.Helper:seekWidgetByName(root,"Image_lhsh"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_lhsh"), nil, 
        {
            terminal_name = "sm_cultivate_window_open_features", 
            m_index = 7,
            terminal_state = 0
        }, nil, 0)
    end

    if ccui.Helper:seekWidgetByName(root,"Image_bs") then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_silkbag",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_bs"),
        _invoke = nil,
        _interval = 0.5,
        _type = 1,
        _shipId = 0,})
        --锦囊
        ccui.Helper:seekWidgetByName(root,"Image_bs"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_bs"), nil, 
        {
            terminal_name = "sm_cultivate_window_open_features", 
            m_index = 8,
            terminal_state = 0
        }, nil, 0)
    end

    --组合卡
    if ccui.Helper:seekWidgetByName(root,"Image_zhk") then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_combination_card",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_zhk"),
        _invoke = nil,
        _interval = 0.5,
    })

        ccui.Helper:seekWidgetByName(root,"Image_zhk"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_zhk"), nil, 
        {
            terminal_name = "sm_cultivate_window_open_features", 
            m_index = 9,
            terminal_state = 0
        }, nil, 0)
    end

    --卡册
    if ccui.Helper:seekWidgetByName(root,"Image_illustration") then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_card_book",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_illustration"),
        _invoke = nil,
        _interval = 0.5,
    })

        ccui.Helper:seekWidgetByName(root,"Image_illustration"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_illustration"), nil, 
        {
            terminal_name = "sm_cultivate_window_open_features", 
            m_index = 10,
            terminal_state = 0
        }, nil, 0)
    end

    --忍列传
    if ccui.Helper:seekWidgetByName(root,"Image_yj") then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_role_biography",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_yj"),
        _invoke = nil,
        _interval = 0.5,
    })

        ccui.Helper:seekWidgetByName(root,"Image_yj"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_yj"), nil, 
        {
            terminal_name = "sm_cultivate_window_open_features", 
            m_index = 11,
            terminal_state = 0
        }, nil, 0)
    end

    --神兽养成
    if ccui.Helper:seekWidgetByName(root,"Image_ss") then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mythical_animal",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_ss"),
        _invoke = nil,
        _interval = 0.5,
    })

        ccui.Helper:seekWidgetByName(root,"Image_ss"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_ss"), nil, 
        {
            terminal_name = "sm_cultivate_window_open_features", 
            m_index = 12,
            terminal_state = 0
        }, nil, 0)
    end

    -- Fury: la carta de las Cronicas (FuryChronicle.lua, 30-sep-2026).
    pcall(function() app.load("client.l_digital.activity.chronicle.FuryChronicle") FuryChronicle_addCultivateCard(root) end)
	local ScrollView_yc = ccui.Helper:seekWidgetByName(root, "ScrollView_yc")
    if ScrollView_yc ~= nil then
        local items = ScrollView_yc:getChildren()
        for i, v in pairs(items) do
            local basePositionX = v:getPositionX()
            v:setPositionX(2086)
            local moveTo = cc.MoveTo:create(0.12, cc.p(basePositionX, v:getPositionY()))
            local delay = cc.DelayTime:create((i - 1) * 0.12)
            local callback = cc.CallFunc:create(function ()
                    self.finishRunAction = true
                    self:jumpScrollView()
            end)
            if i ~= #items then
                v:runAction(cc.Sequence:create(delay, moveTo))
            else
                v:runAction(cc.Sequence:create(delay, moveTo,callback))
            end
            
        end
    end
    
	self:onUpdateDraw()
    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)
end

function SmCultivateWindow:onEnterTransitionFinish()
    
end


function SmCultivateWindow:onExit()
    
end

function SmCultivateWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end
