--------------------------------------------------------------------------------------------------------------
--  说明：副本地图界面
--------------------------------------------------------------------------------------------------------------
PveMap = class("PveMapClass", Window)

app.load("client.red_alert_time.cells.pve.pve_chapter_cell")
app.load("client.red_alert_time.cells.pve.pve_gain_cell")
app.load("client.red_alert_time.cells.pve.pve_npc_cell")
app.load("client.red_alert_time.cells.pve.pve_star_box_cell")
app.load("client.red_alert_time.cells.pve.pve_troops_attribute_cell")
app.load("client.red_alert_time.cells.pve.pve_parts_supply_lock_cell")
app.load("client.red_alert_time.cells.pve.pve_parts_supply_unlock_cell")

--打开界面
local pve_map_open_terminal = {
	_name = "pve_map_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PveMapClass") == nil then
    		fwin:open(PveMap:new():init(params), fwin._ui)
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_map_close_terminal = {
	_name = "pve_map_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("pve_chapter_update_draw",0,"")
        fwin:close(fwin:find("PveMapClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_map_open_terminal)
state_machine.add(pve_map_close_terminal)
state_machine.init()

function PveMap:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- 场景id
    self._scene_id = 0
    -- 开启npc数量
    self._npc_index = 0
    -- 场景地图id
    self._scene_map_id = 0 
    -- 场景类型
    self._scene_type = 0
	
	self.old_npc_index = 0
	
    self.offset_x = 0
	self.offset_y = 0
	self.armature = nil

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")

    local function init_pve_map_terminal()
        local pve_map_show_terminal = {
            _name = "pve_map_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                iii = iii + 1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_map_hide_terminal = {
            _name = "pve_map_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                iii = iii + 1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local pve_map_update_draw_terminal = {
            _name = "pve_map_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                instance:updateDrawNpcInfo()
                -- instance:updateDrawNpcPath(true)
                instance:startSceneEvent(instance._scene_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开宝箱
        local pve_map_open_star_box_terminal = {
            _name = "pve_map_open_star_box",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index
                state_machine.excute("pve_star_reward_open",0,{index, instance._scene_id})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 刷新界面2
        local pve_map_update2_draw_terminal = {
            _name = "pve_map_update2_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- state_machine.excute("main_window_update_userinfo", 0, 0) 
                if instance ~= nil 
                    and instance.roots ~= nil
                    and instance.roots[1] ~= nil then
                    instance:updateDraw()
                    instance:updateDrawNpcInfo()
                    instance:updateDrawNpcPath(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新能量值
        local pve_map_update_energy_terminal = {
            _name = "pve_map_update_energy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateEnergy()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 全名狂欢活动规则
        local pve_map_look_activity_rule_terminal = {
            _name = "pve_map_look_activity_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_map_show_terminal)
        state_machine.add(pve_map_hide_terminal)
        state_machine.add(pve_map_update_draw_terminal)
        state_machine.add(pve_map_update2_draw_terminal)
        state_machine.add(pve_map_open_star_box_terminal)
        state_machine.add(pve_map_update_energy_terminal)
        state_machine.add(pve_map_look_activity_rule_terminal)
        state_machine.init()
    end
    
    init_pve_map_terminal()
end

function PveMap:updateEnergy()
    local root = self.roots[1]
    -- 能量
    local Text_energe_n = ccui.Helper:seekWidgetByName(root, "Text_energe_n")
    Text_energe_n:removeAllChildren(true)
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)  
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, zstring.tonumber(_ED.user_info.user_food), "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re1)
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/".._ED.user_info.max_user_food, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re2)
    _richText_1:setPosition(cc.p(Text_energe_n:getContentSize().width/2,Text_energe_n:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_energe_n:getContentSize().width,22))
    Text_energe_n:addChild(_richText_1)
end

function PveMap:updateDraw()
    local root = self.roots[1]
    local Panel_11 = ccui.Helper:seekWidgetByName(root, "Panel_11")
    local Panel_12 = ccui.Helper:seekWidgetByName(root, "Panel_12")
    local Button_pve_act_p = ccui.Helper:seekWidgetByName(root, "Button_pve_act_p")
    Panel_11:setVisible(false)
    Panel_12:setVisible(false)
    Button_pve_act_p:setVisible(false)

    local pve_scene_mould = dms.element(dms["pve_scene"], self._scene_id)
    local Text_pve_map_title = ccui.Helper:seekWidgetByName(root, "Text_pve_map_title")
    local scene_name = dms.atos(pve_scene_mould, pve_scene.scene_name)
    Text_pve_map_title:setString("")

    if self._scene_type == battle_enum._fight_type._fight_type_107 then
        Panel_12:setVisible(true)
        Text_pve_map_title:setString(scene_name)
        local Text_attack_n = ccui.Helper:seekWidgetByName(root, "Text_attack_n")
        local attack_times = dms.int(dms["base_consume"], 95, base_consume.vip_0_value + tonumber(_ED.vip_grade))   -- 总攻击次数
        local leave_times = attack_times - _ED.union_pve_attack_times  -- 剩余攻击次数
        Text_attack_n:setString(leave_times.."/"..attack_times)
    else
        Panel_11:setVisible(true)
        -- 章节名
        Text_pve_map_title:setString(self._scene_id.."."..scene_name)

        -- 能量
        local Text_energe_n = ccui.Helper:seekWidgetByName(root, "Text_energe_n")
        Text_energe_n:removeAllChildren(true)
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)  
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, zstring.tonumber(_ED.user_info.user_food), "fonts/simhei.ttf",22)
        _richText_1:pushBackElement(re1)
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/".._ED.user_info.max_user_food, "fonts/simhei.ttf",22)
        _richText_1:pushBackElement(re2)
        _richText_1:setPosition(cc.p(Text_energe_n:getContentSize().width/2,Text_energe_n:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_energe_n:getContentSize().width,22))
        Text_energe_n:addChild(_richText_1)

        -- 得星
        local Text_star_n = ccui.Helper:seekWidgetByName(root, "Text_star_n")
        Text_star_n:removeAllChildren(true)
        local current_star = tonumber(_ED.get_star_count[self._scene_id])
        local max_star = dms.atoi(pve_scene_mould, pve_scene.total_star)
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, current_star, "fonts/simhei.ttf",22)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..max_star , "fonts/simhei.ttf",22)
        _richText_2:pushBackElement(re2)
        _richText_2:setPosition(cc.p(Text_star_n:getContentSize().width/2,Text_star_n:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_star_n:getContentSize().width,22))
        Text_star_n:addChild(_richText_2)

    	local openBox = {
    		{1,3,5,7},
    		{2,3,6,7},
    		{4,5,6,7},
    	}
        -- 宝箱
        local reward_need_star = zstring.split(dms.atos(pve_scene_mould, pve_scene.reward_need_star), ",")
        for i=1, 3 do
            local Panel_star_box = ccui.Helper:seekWidgetByName(root, "Panel_star_box_"..i)
            Panel_star_box:removeAllChildren(true)
            
			local quality_icon = cc.Sprite:create(string.format(config_res.images.ui.pve.treasure_box,1))
			quality_icon:setPosition(cc.p(Panel_star_box:getContentSize().width/2,Panel_star_box:getContentSize().height/2))
			quality_icon:setTag(1000)
			Panel_star_box:addChild(quality_icon)
	
    		-- Panel_star_box:setBackGroundImage(string.format(config_res.images.ui.pve.treasure_box,1))
			if current_star >= tonumber(reward_need_star[i]) then
				if Panel_star_box:getChildByTag(1000) ~= nil then
					Panel_star_box:removeChildByTag(1000)
				end
				local armature = ccs.Armature:create("effect_box_get")
				armature:getAnimation():playWithIndex(0)
				armature:setPosition(cc.p(Panel_star_box:getContentSize().width/2,Panel_star_box:getContentSize().height/2))
				armature:setTag(500)
				Panel_star_box:addChild(armature)
			end
			
    		for j=1, 4 do
    			if openBox[i][j] == tonumber(_ED.star_reward_state[self._scene_id]) then
    				-- Panel_star_box:setBackGroundImage(string.format(config_res.images.ui.pve.treasure_box,2))
					local quality_icon2 = cc.Sprite:create(string.format(config_res.images.ui.pve.treasure_box,2))
					quality_icon2:setPosition(cc.p(Panel_star_box:getContentSize().width/2,Panel_star_box:getContentSize().height/2))
					quality_icon2:setTag(1000)
					Panel_star_box:addChild(quality_icon2)
					if Panel_star_box:getChildByTag(500) ~= nil then
						Panel_star_box:removeChildByTag(500)
					end
    			end
    		end
			local cell = state_machine.excute("pve_star_box_create_cell",0, {i,reward_need_star[i],self._scene_id})
            Panel_star_box:addChild(cell)
        end

        -- 全名狂欢活动标志
        if _ED.activity_info ~= nil and _ED.activity_info["84"] ~= nil then
            local timesData = zstring.split(_ED.activity_info["84"].activity_add_state, ",")
            local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
            if leave_times > 0 then
                Button_pve_act_p:setVisible(true)
            end
            self._activity_type = 84
        end

        -- 狂欢时刻活动标志
        if _ED.activity_info ~= nil and _ED.activity_info["130"] ~= nil then
            local timesData = zstring.split(_ED.activity_info["130"].activity_add_state, ",")
            local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
            if leave_times > 0 then
                Button_pve_act_p:setVisible(true)
            end
            self._activity_type = 130
        end
    end
end

function PveMap:updateDrawNpcInfo()
    local root = self.roots[2]
    local Panel_pve_map_box = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pve_map_box")
    local ScrollView_pve_map = ccui.Helper:seekWidgetByName(root,"ScrollView_pve_map")
    ScrollView_pve_map:jumpToBottom()

    local pve_scene_mould = dms.element(dms["pve_scene"], self._scene_id)
    local npcs = zstring.split(dms.atos(pve_scene_mould, pve_scene.npcs), ",")
    local ty = nil
    local ly = nil
    local tx = nil
    local lx = nil
    for i=1,16 do
        local Panel_js = ccui.Helper:seekWidgetByName(root, "Panel_js_"..i)
        if Panel_js ~= nil then
            Panel_js:removeAllChildren(true)
            if npcs[i] ~= nil and tonumber(npcs[i]) > 0 then
                local npc = tonumber(npcs[i])
                if tonumber(_ED.npc_state[npc]) >= 0 then
                    self._npc_index = i
                    local cell = state_machine.excute("pve_npc_create_cell", 0, {i, npcs[i],self._scene_id})
					cell:setTag(self._npc_index)
                    Panel_js:addChild(cell)
                    -- local x = Panel_js:getPositionX()
                    local y = Panel_js:getPositionY()
                    local x = Panel_js:getPositionX()
                    if tonumber(_ED.npc_state[npc]) == 0 then
                        -- local move_x = x/size.width*100
                        -- local move_y = 100 - y/size.height*100
                        -- if move_x > 70 then
                        --     move_x = 100 
                        -- elseif move_x < 30 then
                        --     move_x = 0
                        -- end
                        -- if move_y < 200 then
                        --     move_y = 0
                        -- end
                        -- ScrollView_pve_map:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
                        ty = y
                        tx = x
                    else
                        ly = y
                        lx = x
                    end
                end
            end
        end
    end

    local size = ScrollView_pve_map:getInnerContainer():getContentSize()
    local viewSize = ScrollView_pve_map:getContentSize()
    local centerPosition = cc.p(viewSize.width / 2, viewSize.height / 2)
    if __lua_project_id == __lua_project_pacific_rim then
        if tx == nil then
            tx = lx
        end
        if tx > centerPosition.x then
            local mx = tx - centerPosition.x
            local mmx = viewSize.width - size.width
            mx = -1 * mx
            if mx < mmx then
                mx = mmx
            end
            if self._scene_type ~= battle_enum._fight_type._fight_type_107 then
                ScrollView_pve_map:getInnerContainer():setPositionX(mx)
            end
            self.offset_x = mx
        end
    else
        if ty == nil then
            ty = ly
        end
        if ty > centerPosition.y then
            local my = ty - centerPosition.y
            local mmy = viewSize.height - size.height
            my = -1 * my
            if my < mmy then
                my = mmy
            end
            if self._scene_type ~= battle_enum._fight_type._fight_type_107 then
                ScrollView_pve_map:getInnerContainer():setPositionY(my)
            end
    		self.offset_y = my
        end
    end
end

function PveMap:updateDrawNpcPathThree()
	local root1 = self.roots[2]
	local root = self.roots[1]
	local Panel_jsNew = ccui.Helper:seekWidgetByName(root, "Panel_js_"..self._npc_index)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effcet_npc_open_light/effcet_npc_open_light.ExportJson")
	local armature2 = ccs.Armature:create("effcet_npc_open_light")
	armature2:getAnimation():playWithIndex(0)
	armature2:setPosition(Panel_jsNew:getContentSize().width/2,Panel_jsNew:getContentSize().height/2)
	Panel_jsNew:addChild(armature2,-1)

end

function PveMap:updateDrawNpcPathTwo(isShow)
	local root1 = self.roots[2]
	local root = self.roots[1]
	local Panel_line_effect = ccui.Helper:seekWidgetByName(root1, "Panel_line_effect")
	-- Panel_line_effect:removeAllChildren(true)
    local effect_paths = nil 
    if self._scene_type == battle_enum._fight_type._fight_type_107 then
    	effect_paths = config_res.images.ui.effice.effect_legion_pve_map_line
    	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    	
    	if self.armature == nil then
    		self.armature = ccs.Armature:create("effect_legion_pve_map_line")
    	end
    else
        effect_paths = config_res.images.ui.effice.effect_pve_map_line
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        
        if self.armature == nil then
            self.armature = ccs.Armature:create("effect_pve_map_line")
        end
    end
    self.armature:setPosition(cc.p(Panel_line_effect:getContentSize().width/2, Panel_line_effect:getContentSize().height/2))
	-- local armature = ccs.Armature:create("effect_pve_map_line")
	if isShow == false then
		-- if self._scene_type == battle_enum._fight_type._fight_type_107 then
  --           draw.initArmatureTwo(self.armature, nil, -1, 0, 1, 0)
  --           self.armature:getAnimation():gotoAndPause((self._npc_index - 1)*30)
  --           self.armature:setPosition(cc.p(Panel_line_effect:getContentSize().width/2, Panel_line_effect:getContentSize().height/2 - 1290))
  --       else
    		draw.initArmatureTwo(self.armature, nil, -1, 0, 1, 0)
    		self.armature:getAnimation():gotoAndPause((self._npc_index - 1)*30)
        -- end
		-- for i=0, self._npc_index - 2 do 
			-- draw.initArmatureTwo(armature, nil, -1, 0, 1, i)
		-- end
	else
		-- draw.initArmatureTwo(armature, nil, -1, 0, 1, self._npc_index - 2)
		-- draw.initArmatureTwo(armature, nil, -1, 0, 1, 0)
		self.armature:getAnimation():gotoAndPlay((self._npc_index - 2)*30)
		-- armature:getAnimation():gotoAndPause(20)
	end

	local isover = false
	local index = 0 
	-- local function deleteEffectFile(armatureBack)
		-- if armatureBack.removeFromParent ~= nil then
				
		-- end
	-- end
	-- self.armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	-- self.armature._invoke = deleteEffectFile
	
	-- self._armature = armature
	if isShow == false then
		Panel_line_effect:addChild(self.armature)
	end
	
	if isShow == false then
		return
	end
	local Panel_jsNew = ccui.Helper:seekWidgetByName(root, "Panel_js_"..self._npc_index):setVisible(true)
    if __lua_project_id == __lua_project_pacific_rim then
        self:updateDrawNpcPathThree()
        self.armature:getAnimation():gotoAndPause((self._npc_index - 1)*30)
    else
    	if Panel_jsNew._y == nil then
    		Panel_jsNew._y = Panel_jsNew:getPositionY()
    	end
    	Panel_jsNew:setPositionY(Panel_jsNew:getPositionY()+100)
    	function blinkOutCallback1(sender)
    		self:updateDrawNpcPathThree()
    		self.armature:getAnimation():gotoAndPause((self._npc_index - 1)*30)
    	end
    	Panel_jsNew:runAction(cc.Sequence:create(
				cc.MoveTo:create(0.3, cc.p(Panel_jsNew:getPositionX(), Panel_jsNew:getPositionY()-50)),
				cc.MoveTo:create(0.1, cc.p(Panel_jsNew:getPositionX(), Panel_jsNew._y)),
				cc.CallFunc:create(blinkOutCallback1)
				))	
    end
end

function PveMap:updateDrawNpcPath(isShow)
	if isShow == false then
		self.old_npc_index = self._npc_index
		self:updateDrawNpcPathTwo(isShow)
		isShow = true
		return
	end
	local root1 = self.roots[2]
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root1, "Panel_js_"..self._npc_index):setVisible(false)
	if self.old_npc_index == self._npc_index then
		ccui.Helper:seekWidgetByName(root1, "Panel_js_"..self._npc_index):setVisible(true)
		return
	end
	
	local Panel_js = ccui.Helper:seekWidgetByName(root1, "Panel_js_"..self._npc_index-1)
    ccui.Helper:seekWidgetByName(root1, "Panel_js_"..self.old_npc_index):setVisible(true)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_boom/effect_boom.ExportJson")
    local armature5 = ccs.Armature:create("effect_boom")
    draw.initArmatureTwo(armature5, nil, -1, 1000, 1, 0)
    armature5:setAnchorPoint(0.5,0.5)
    armature5:setPosition(Panel_js:getPositionX()+Panel_js:getContentSize().width/2+self.offset_x,Panel_js:getPositionY()+Panel_js:getContentSize().height/2+self.offset_y)
    root1:addChild(armature5,100)
    checkPlayEffect(48,1)
    -- local cell = Panel_js:getChildByTag(self._npc_index-1)
    -- state_machine.excute("pve_npc_cell_play_boom_effect", 0, {cell,self._npc_index-1})

	function blinkOutCallback1(sender)
		self:updateDrawNpcPathTwo()
	end
	local by_open = dms.string(dms["pve_scene"], self._scene_id, pve_scene.npcs)
	local by_info = zstring.split(by_open, ",")
	if self._npc_index <= #by_info then
		self.old_npc_index = self._npc_index
		Panel_js:runAction(cc.Sequence:create(
						cc.DelayTime:create(1),
						cc.CallFunc:create(blinkOutCallback1)
						))
	end				
	
end

function PveMap:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_map_ui)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    local time = nil
    if false == missionIsOver() then
        time = 0
        self._view = fwin._ui
        self:onCheckCovers(self)
    else
        Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN, time)
    end
    
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_box_get)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_map_close"), nil, 
    {
        terminal_name = "pve_map_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil, 
    {
        terminal_name = "legion_pve_help_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_star_box_"..i), nil, 
        {
            terminal_name = "pve_map_open_star_box",
            terminal_state = 0,
            touch_black = true,
            index = i ,
        },
        nil,1)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_act_p"), nil, 
    {
        terminal_name = "pve_map_look_activity_rule",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    local Panel_pve_map_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_map_box")
    Panel_pve_map_box:removeAllChildren(true)

    local csbItem1 = csb.createNode(string.format(config_csb.pve.pve_map, self._scene_map_id))
    local root1 = csbItem1:getChildByName("root")
    root1:removeFromParent(false)
    table.insert(self.roots, root1)

    local ScrollView_pve_map = ccui.Helper:seekWidgetByName(root1, "ScrollView_pve_map")
    if nil ~= ScrollView_pve_map then
        local Panel_pve_map = ccui.Helper:seekWidgetByName(root1, "Panel_pve_map")
        if nil ~= Panel_pve_map then
            local ssize = Panel_pve_map:getContentSize()
            ScrollView_pve_map:setInnerContainerSize(ssize)
        end
    end

    Panel_pve_map_box:addChild(root1)

    self:updateDraw()
    self:updateDrawNpcInfo()
    self:updateDrawNpcPath(false)
    
end

function PveMap:startSceneEventEx(pveSceneID)
    if missionIsOver() == true then
        -- if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, true, "0", false) == false then
            --if fwin:find("PVESecondarySceneInfoClass") == nil then
                local currentPveSceneID = zstring.tonumber(pveSceneID)
                local sceneParam = "sc".._ED.scene_current_state[zstring.tonumber(""..currentPveSceneID)]..
                    "m".._ED.scene_max_state[zstring.tonumber(""..currentPveSceneID)]
                    
                local pve_scene_event_mark_str = readKey("pve_scene_event_mark_"..currentPveSceneID..sceneParam)
                
                if pve_scene_event_mark_str == "1" or 
                  executeMissionExt(mission_mould_plot, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneParam, true) == false then
                    if executeMissionExt(mission_mould_tuition, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneParam, true) == false then
                        local sceneData = dms.element(dms["pve_scene"], currentPveSceneID)
                        local placeView = zstring.split(dms.atos(sceneData,pve_scene.star_reward_id),",")
                        local rewardView = zstring.split(dms.atos(sceneData, pve_scene.reward_need_star),",")
                        local sceneDrawParam = "s"..currentPveSceneID
                        if zstring.tonumber(_ED.get_star_count[currentPveSceneID]) >= zstring.tonumber(rewardView[1]) then
                            local vr = zstring.tonumber(_ED.star_reward_state[currentPveSceneID])
                            if vr == 0 then
                                sceneDrawParam = sceneDrawParam.."".."d"..0
                            end
                        end
                        if executeMissionExt(mission_mould_tuition, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneDrawParam, true) == false then
                            executeNextEvent(nil, true)
                        end
                    end
                else
                    writeKey("pve_scene_event_mark_"..currentPveSceneID..sceneParam, "1")
                end
            --end
        --end
    end
    if missionIsOver() == false then
        local windowLock = fwin:find("WindowLockClass")
        if windowLock == nil then
            fwin:open(WindowLock:new():init(), fwin._windows)
        end
    else
        fwin:close(fwin:find("WindowLockClass"))
    end
end

function PveMap:startSceneEvent()
    fwin:addService({
        callback = function ( params )
            if nil ~= params and nil ~= params.roots then
                params:startSceneEventEx(params._scene_id)
            end
        end,
        params = self
    })
end

function PveMap:onEnterTransitionFinish()
    checkEffectLevelUp()
end

function PveMap:init(param)
    self._scene_id = param[1]
    self._scene_map_id = dms.int(dms["pve_scene"],self._scene_id,pve_scene.scene_map_id)
    self._scene_type = dms.int(dms["pve_scene"], self._scene_id, pve_scene.scene_type) 
    self:setTouchEnabled(true)
	self:onInit()
    self:startSceneEvent(self._scene_id)
    return self
end

function PveMap:onExit()
    state_machine.remove("pve_map_show")
    state_machine.remove("pve_map_hide")
    state_machine.remove("pve_map_update_draw")
    state_machine.remove("pve_map_open_star_box")
    state_machine.remove("pve_map_update_energy")
    state_machine.remove("pve_map_look_activity_rule")
end

function PveMap:onResume()
	self.old_npc_index = self._npc_index
	-- state_machine.excute("pve_map_update2_draw", 0, 0) 
end