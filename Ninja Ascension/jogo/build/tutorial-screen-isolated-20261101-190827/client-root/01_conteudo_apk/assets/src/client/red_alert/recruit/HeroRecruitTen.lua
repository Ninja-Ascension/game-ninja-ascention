--------------------------------------------------------------------------------------------------------------
--  说明：招募十次动画
--------------------------------------------------------------------------------------------------------------
HeroRecruitTen = class("HeroRecruitTenClass", Window)

--打开界面
local hero_recruit_ten_window_open_terminal = {
	_name = "hero_recruit_ten_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local _wind = fwin:find("HeroRecruitTenClass")
        if _wind == nil then
            fwin:open(HeroRecruitTen:new():init(),fwin._viewdialog)
        end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local hero_recruit_ten_window_close_terminal = {
	_name = "hero_recruit_ten_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitTenClass"))
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			cacher.clearWindowCacher()
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(hero_recruit_ten_window_open_terminal)
state_machine.add(hero_recruit_ten_window_close_terminal)
state_machine.init()

function HeroRecruitTen:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self.ship_types = {}
	 -- Initialize alert_home state machine.
    local function init_hero_recruit_ten_terminal()
	
		-- 再次十连抽
        local hero_recruit_ten_re_recruit_terminal = {
            _name = "hero_recruit_ten_re_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function recruitCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("hero_recruit_ten_window_close",0,"")
                        state_machine.excute("hero_recruit_ten_window_open",0,"")
                        state_machine.excute("hero_recruit_update_hero_come_times",0,"")
                    end
                end 

                local propRecruitCount_ten = 0 
                if fundPropWidthId(258) ~= nil then 
                    local token = fundPropWidthId(258)
                    propRecruitCount_ten = token.prop_number
                end
                if propRecruitCount_ten == 0 then
                    local price = countActivityHeroDiscount()
                    if tonumber(_ED.user_info.user_gold) < tonumber(price.ten) then
                        TipDlg.drawTextDailog(red_alert_all_str[79])
                        return
                    end
                end
                protocol_command.ship_batch_bounty.param_list = ""..2
                NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, nil, recruitCallBack, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        -- 再次十连抽
        local hero_recruit_ten_back_terminal = {
            _name = "hero_recruit_ten_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("hero_recruit_action_back",0,"")
                state_machine.excute("hero_recruit_ten_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 继续播放
        local hero_recruit_ten_cotinue_terminal = {
            _name = "hero_recruit_ten_cotinue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas._index
                local Panel_recruit_show_ten = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_recruit_show_ten") 
                fwin:removeTouchEventListener(Panel_recruit_show_ten)
                local Panel_card_show_e = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_card_show_e_"..index)
                local Panel_card_show_bg = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_card_show_bg_"..index)
                Panel_card_show_e:removeAllChildren(true)
                Panel_card_show_e:setVisible(false)
                Panel_card_show_bg:setVisible(false) 
                instance.actions[1]:play("recruit_show_specil_back_"..index,false)
                local Button_look_infor = ccui.Helper:seekWidgetByName(self.roots[1],"Button_look_infor")
                Button_look_infor:setVisible(false)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看角色信息
        local hero_recruit_ten_look_infor_terminal = {
            _name = "hero_recruit_ten_look_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.red_alert.recruit.CatalogueStorage")
                state_machine.excute("catalogue_storage_window_open",0,"")
                local random_patch_id = params._datas.random_patch_id
                state_machine.excute("catalogue_storage_choose_on_ship",0,random_patch_id)
                state_machine.excute("catalogue_storage_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_recruit_ten_re_recruit_terminal)  
        state_machine.add(hero_recruit_ten_back_terminal)  
        state_machine.add(hero_recruit_ten_cotinue_terminal)     
        state_machine.add(hero_recruit_ten_look_infor_terminal)   
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_hero_recruit_ten_terminal()
end

function HeroRecruitTen:updateDraw()
    local root = self.roots[1]
    local Panel_recruit_show_ten = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_ten")
    local ArmatureNode_recruit_ten = Panel_recruit_show_ten:getChildByName("ArmatureNode_recruit_ten")
    ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_infor"):setVisible(false)
    
    local Panel_songsuipian = ccui.Helper:seekWidgetByName(root,"Panel_songsuipian")
    Panel_songsuipian:setVisible(false)
    local function changeActionCallback( armatureBack )
        armatureBack._self:playTurnActions()
        -- 送碎片
        local Panel_props = ccui.Helper:seekWidgetByName(root,"Panel_props")
        local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
        Panel_props:removeAllChildren(true)
        if _ED.activity_info ~= nil then
            if _ED.activity_info["38"] ~= nil then
                Panel_songsuipian:setVisible(true)
                -- 碎片显示
                for i,data in pairs(_ED.show_reward_list_group[1].show_reward_list) do
                    local cell = nil
                    if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
                        or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
                        cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
                        if tonumber(data.prop_type) == 7 then 
                            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
                        end
                    else
                        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
                    end  
                    Panel_props:addChild(cell)
                    -- 碎片名字
                    local prop_name = dms.string(dms["prop_mould"], data.prop_item, prop_mould.prop_name)
                    Text_props_name:setString(prop_name.." X"..data.item_value)
                end
                _ED.show_reward_list_group = {}
            end
        end
    end

    draw.initArmature(armature, nil, -1, 0, 1)
    ArmatureNode_recruit_ten._self = self
    ArmatureNode_recruit_ten._invoke = changeActionCallback
    ArmatureNode_recruit_ten:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(ArmatureNode_recruit_ten, 0, 0, false)
end

function HeroRecruitTen:showButton()
    local root = self.roots[1]
    local Panel_recruit_show_infor = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_infor")
    Panel_recruit_show_infor:setVisible(true)
    local BitmapFontLabel_recruit_show_time = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_recruit_show_time") 
    local Panel_recruit_show_time = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_time")
    local Panel_recruit_this_time = ccui.Helper:seekWidgetByName(root,"Panel_recruit_this_time")
    Panel_recruit_this_time:setVisible(false)
    Panel_recruit_show_time:setVisible(false)
    
    local Panel_choushici_free = ccui.Helper:seekWidgetByName(root,"Panel_choushici_free")
    Panel_choushici_free:setVisible(false)
    local Text_free_count_ten = ccui.Helper:seekWidgetByName(root,"Text_free_count_ten")
    local Text_chou_free = ccui.Helper:seekWidgetByName(root,"Text_chou_free")
    local Panel_choushici = ccui.Helper:seekWidgetByName(root,"Panel_choushici")
    --十连书
    local propRecruitCount_ten = 0 
    if fundPropWidthId(258) ~= nil then 
        local token = fundPropWidthId(258)
        propRecruitCount_ten = token.prop_number
    end

    local accumulateBuyGod = 0
    if tonumber(_ED.user_accumulate_buy_god) > 9 then
        accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)-10
    else
        accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)
    end
    
    local getGodShipCont = 9 - accumulateBuyGod --再抽几次就抽5星神将
    if getGodShipCont > 0 then
        Panel_recruit_show_time:setVisible(true)
        BitmapFontLabel_recruit_show_time:setString(getGodShipCont)   
    elseif getGodShipCont == 0 then
        Panel_recruit_this_time:setVisible(true)
    end

    if tonumber(propRecruitCount_ten) > 0 then
        Panel_choushici:setVisible(false)
        Panel_choushici_free:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_recruit_ten_again"):setVisible(false)
        Text_free_count_ten:setString(propRecruitCount_ten)
        Text_chou_free:setString(string.format(red_alert_all_str[174], propRecruitCount_ten))
    else
        ccui.Helper:seekWidgetByName(root,"Text_recruit_ten_again"):setVisible(true)
        Panel_choushici:setVisible(true)
    end

    local Text_recruit_ten_gem_nub = ccui.Helper:seekWidgetByName(root,"Text_recruit_ten_gem_nub")
    local price = countActivityHeroDiscount()
    Text_recruit_ten_gem_nub:setString(price.ten)
end

function HeroRecruitTen:playTurnActions(index,_ship_type)
    local root = self.roots[1]
    if index == nil then
        index = 1
        _ship_type = self.ship_types[1]
    end
    
    if index > 10 then
        self:showButton()
        return
    end

    local Panel_recruit_show = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_"..index)
    local ArmatureNode = Panel_recruit_show:getChildByName("ArmatureNode_"..index)
    ArmatureNode:setVisible(true)
    local animation = ArmatureNode:getAnimation()
    animation:setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
    animation:playWithIndex(0,0,0)
    animation._invoke = function(armatureBack)
        ArmatureNode:setVisible(false)
    end

    local action = self.actions[1]
    action:stop()
    if _ship_type >= 4 then
        -- print("====3====播放爆炸光效",index,"recruit_show_specil_"..index)
        action:play("recruit_show_specil_"..index,false)  
        playEffect(formatMusicFile("effect", 10003)) 
    else
        -- print("====1===播放爆炸光效",index,"recruit_show_specil_"..index)
        action:play("recruit_show_normal_"..index,false)
        playEffect(formatMusicFile("effect", 10002)) 
    end
    
    local root = self.roots[1]
    local Panel_recruit_show_ten = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_ten")
    local ArmatureNode_recruit_ten = Panel_recruit_show_ten:getChildByName("ArmatureNode_recruit_ten")
    local skin_path = "images/ui/slots/jiugongge_kong.png"
    local event_bg = ccs.Skin:create(skin_path)
    ArmatureNode_recruit_ten:getBone("Layer_card_"..index):addDisplay(event_bg, 0)
     --设置武将背景   
end

function HeroRecruitTen:initHeroData( ... )
    local root = self.roots[1]
    local Panel_recruit_show_ten = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_ten")
    local ArmatureNode_recruit_ten = Panel_recruit_show_ten:getChildByName("ArmatureNode_recruit_ten")

    for i = 1,10 do
        local Panel_recruit_show_card_bg = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_card_bg_"..i)
        local Panel_recruit_show_card_role = ccui.Helper:seekWidgetByName(root,"Panel_recruit_show_card_role_"..i)

        local _name = dms.string(dms["ship_mould"], tonumber(_ED.random_Patch[i].random_patch_id), ship_mould.captain_name)
        local _ship_type = dms.int(dms["ship_mould"], tonumber(_ED.random_Patch[i].random_patch_id), ship_mould.ship_type)
        local temp_bust_index = dms.int(dms["ship_mould"], tonumber(_ED.random_Patch[i].random_patch_id), ship_mould.bust_index)
        table.insert(self.ship_types,_ship_type)
        -- print("=============",_name,_ship_type)
        --设置武将icon
        Panel_recruit_show_card_role:removeBackGroundImage()
        Panel_recruit_show_card_role:setBackGroundImage("images/face/card_hero/card_hero_"..temp_bust_index..".png")  
        
        local Panel_hero_spine_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_spine_role_"..i)
        if Panel_hero_spine_role ~= nil then
            Panel_hero_spine_role:removeAllChildren(true)
            local jsonPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".json"
            local atlasPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".atlas"
            if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
                local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
                animation:setPosition(cc.p(Panel_hero_spine_role:getContentSize().width/2,Panel_hero_spine_role:getContentSize().height/2))
                Panel_hero_spine_role:addChild(animation)
            end
        end

        if _ship_type >= 3 then --紫色
            local skin_path = ""
            if _ship_type == 3 then
                skin_path = "images/ui/quality/card_bg_1.png"
            else
                skin_path = "images/ui/quality/card_bg_3.png"
            end
            local event_bg = ccs.Skin:create(skin_path)
            ArmatureNode_recruit_ten:getBone("Layer_card_"..i):addDisplay(event_bg, 0)
             --设置武将背景
            Panel_recruit_show_card_bg:removeBackGroundImage()
            Panel_recruit_show_card_bg:setBackGroundImage(skin_path)
        else
            local skin_path = "images/ui/quality/card_bg_2.png"
            local event_bg = ccs.Skin:create(skin_path)
            ArmatureNode_recruit_ten:getBone("Layer_card_"..i):addDisplay(event_bg, 0)
             --设置武将背景
            Panel_recruit_show_card_bg:removeBackGroundImage()
            Panel_recruit_show_card_bg:setBackGroundImage(skin_path)
        end
    end
end

function HeroRecruitTen:onInit()
    local csbItem = csb.createNode(config_csb.recruit.hero_recruit_ten)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    local action = csb.createTimeline(config_csb.recruit.hero_recruit_ten) 
    table.insert(self.actions, action)
    -- action:setTimeSpeed(app.getTimeSpeed())
    csbItem:runAction(action)
    self.numbers = 0
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        
        local str = frame:getEvent()

        for i = 1 ,10 do
            if str == "recruit_show_normal_"..i.."_over" then
                self:playTurnActions(i+1,self.ship_types[i+1])
            elseif str == "purple_hero_get_"..i.."_over" then
                self:addAnimation(i)
                playEffect(formatMusicFile("effect", 10018)) 
            elseif str == "recruit_show_specil_back_"..i.."_over" then
                self:playTurnActions(i+1,self.ship_types[i+1])
            end
        end
            -- if str == "recruit_show_normal_1_over" then
            --     self:playTurnActions(2,self.ship_types[2])
            -- elseif str == "recruit_show_specil_1_over" then
            --     self:addAnimation(1)
            -- elseif str == "recruit_show_specil_back_1_over" then
            --     self:playTurnActions(2,self.ship_types[2])
            -- end
    end)
    local Button_recruit_back = ccui.Helper:seekWidgetByName(root,"Button_recruit_back")
    local Button_recruit_ten_again = ccui.Helper:seekWidgetByName(root,"Button_recruit_ten_again")
    --关闭 -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_back"), nil, 
    {
        terminal_name = "hero_recruit_ten_back", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    -- 再次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_ten_again"), nil, 
    {
        terminal_name = "hero_recruit_ten_re_recruit", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    for i = 1,10 do
        local Panel_card_show_e = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_card_show_e_"..i)
        Panel_card_show_e:setVisible(false)
    end
    self:initHeroData()  
	self:updateDraw()
end

function HeroRecruitTen:addAnimation(index)
    local root = self.roots[1]
    local Panel_recruit_show_ten = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_recruit_show_ten")
    fwin:addTouchEventListener(Panel_recruit_show_ten, nil, 
    {
        terminal_name = "hero_recruit_ten_cotinue", 
        terminal_state = 0,
        _index = index,
    },
    nil,0)
    -- 查看角色信息
    local Button_look_infor = ccui.Helper:seekWidgetByName(self.roots[1],"Button_look_infor")
    Button_look_infor:setVisible(true)
    fwin:addTouchEventListener(Button_look_infor, nil, 
    {
        terminal_name = "hero_recruit_ten_look_infor", 
        terminal_state = 0,
        random_patch_id = _ED.random_Patch[index].random_patch_id,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)


    -- print("====显示背景光效",index)
    local Panel_card_show_e = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_card_show_e_"..index)
    Panel_card_show_e:removeAllChildren(true)
    Panel_card_show_e:setVisible(true)
    local Panel_card_show_bg = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_card_show_bg_"..index)
    Panel_card_show_bg:setVisible(true)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_card_show/effice_card_show.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_card_wai/effice_card_wai.ExportJson")

    local armature = ccs.Armature:create("effice_card_show")
    armature:setPosition(cc.p(Panel_card_show_e:getContentSize().width/2, Panel_card_show_e:getContentSize().height/2)) 
    Panel_card_show_e:addChild(armature)
    armature:getAnimation():playWithIndex(0,0,-1)
    
    local armature_2 = ccs.Armature:create("effice_card_wai")
    armature_2:setPosition(cc.p(Panel_card_show_e:getContentSize().width/2, Panel_card_show_e:getContentSize().height/2))
    Panel_card_show_e:addChild(armature_2)
    armature_2:getAnimation():playWithIndex(0,0,-1)
end

function HeroRecruitTen:onEnterTransitionFinish()

end

function HeroRecruitTen:init()
	self:onInit()
    return self
end

function PlayerInfo:onExit()
    state_machine.remove("hero_recruit_ten_re_recruit")
    state_machine.remove("hero_recruit_ten_back")      
    state_machine.remove("hero_recruit_ten_cotinue")   
    state_machine.remove("hero_recruit_ten_look_infor")  
end