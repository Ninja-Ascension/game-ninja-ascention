-----------------------------
--副本界面管理
-----------------------------
DuplicateManager = class("DuplicateManagerClass", Window)

--打开副本管理界面
local duplicate_manager_window_open_terminal = {
    _name = "duplicate_manager_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(62) == true then
            return
        end      
    	local _duplicateManagerWindow = fwin:find("DuplicateManagerClass")
        if nil == _duplicateManagerWindow then
            local index = 0 
            if params == nil then
                index = 1
            else
                index = params[1]
            end
            fwin:open(DuplicateManager:new():init(index), fwin._view)
        end
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")
        state_machine.excute("seven_star_map_ui_window_close",0,"")
        state_machine.excute("home_button_for_action_window_show",0,"")
        if fwin:find("StrategyClass")  ~= nil then
            state_machine.excute("strategy_window_hide", 0, "")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭副本管理界面
local duplicate_manager_window_close_terminal = {
    _name = "duplicate_manager_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("DuplicateManagerClass")
        if win ~= nil then
            fwin:close(win)
        end
        
        if fwin:find("PacksClass")  ~= nil then
            state_machine.excute("packs_window_show",0,"")
            state_machine.excute("main_window_hide", 0, "")
            state_machine.excute("player_resource_window_show", 0, "")     
            state_machine.excute("home_button_for_action_window_hide",0,"")
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("duplicate_title_window_hide",0,"") 
        elseif fwin:find("HeroMainClass")  ~= nil then
            state_machine.excute("hero_main_window_show",0,"")
            state_machine.excute("main_window_hide", 0, "")
            state_machine.excute("home_button_for_action_window_hide",0,"")
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("duplicate_title_window_hide",0,"") 
        elseif fwin:find("HeroRecruitClass") ~= nil then
            state_machine.excute("hero_recruit_window_open",0,"")
            state_machine.excute("catalogue_storage_window_show",0,"")
        elseif fwin:find("TaskClass") ~= nil then
            state_machine.excute("home_button_for_action_window_hide",0,"")
            state_machine.excute("task_window_show",0,"")
        elseif fwin:find("SevenStarClass") ~= nil then
            state_machine.excute("player_resource_window_hide",0,"")
            state_machine.excute("home_button_for_action_window_hide",0,"")
            state_machine.excute("chat_view_window_hide",0,"")
        else
            state_machine.excute("main_window_open",0,"")  
            state_machine.excute("player_resource_window_show",0,"")
            state_machine.excute("star_box_duplicate_window_close",0,"")
            state_machine.excute("easy_duplicate_window_close",0,"")
            state_machine.excute("normal_duplicate_window_close",0,"")
            state_machine.excute("hard_duplicate_window_close",0,"")
        end
        if fwin:find("StrategyClass")  ~= nil then
            state_machine.excute("strategy_window_show", 0, "")
        end
        
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        -- cacher.clearWindowCacher()
        cacher.removeAllTextures()
        fwin:freeAllMemeryPool()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_manager_window_open_terminal)
state_machine.add(duplicate_manager_window_close_terminal)
state_machine.init()

function DuplicateManager:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file
    app.load("client.red_alert.duplicate.EasyDuplicate")
    app.load("client.red_alert.duplicate.NormalDuplicate")
    app.load("client.red_alert.duplicate.HardDuplicate")
    app.load("client.red_alert.duplicate.DuplicateTitle")
    app.load("client.red_alert.duplicate.DuplicateNpcWindow")
    app.load("client.red_alert.duplicate.DuplicateStarBoxWindow")
    app.load("client.red_alert.duplicate.DuplicateRaids")
    app.load("client.red_alert.cells.reward.star_box_duplicate_cell")
    app.load("client.red_alert.cells.duplicate.duplicate_list_cell")
    app.load("client.red_alert.cells.duplicate.duplicate_current_level_cell")
    app.load("client.red_alert.cells.duplicate.duplicate_raids_cell")
	app.load("client.red_alert.battle.battle_enum")

    --var
    --副本难度
    self.copy_type = nil
    --宝箱类型
    self.starboxcell = nil
    --体力值
    self.food_text = nil
    --关卡列表
    self.Panel_pve_listview = nil
    

    
    -- Initialize DuplicateManager state machine.
    local function init_DuplicateManager_terminal()
        --管理
        local duplicate_manager_all_page_terminal = {
        _name = "duplicate_manager_all_page",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)  
            if funOpenDrawTip(params._datas.fun_open_id) == true then
                return
            end  
            if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            end 
            -- set select ui button is highlighted
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        --显示
        local duplicate_manager_window_show_terminal = {
            _name = "duplicate_manager_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --隐藏
        local duplicate_manager_window_hide_terminal = {
            _name = "duplicate_manager_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		--简单副本
		local duplicate_manager_change_easy_terminal = {
            _name = "duplicate_manager_change_easy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)      
                state_machine.excute("easy_duplicate_window_open",0,{instance.Panel_pve_listview})
                state_machine.excute("easy_duplicate_window_show",0,"")
                state_machine.excute("normal_duplicate_window_hide",0,"")
                state_machine.excute("hard_duplicate_window_hide",0,"")

                instance.copy_type = 1
                instance:changePageState()
                state_machine.excute("star_box_duplicate_cell_change_type",0,{instance.starboxcell,instance.copy_type})
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--普通副本
		local duplicate_manager_change_normal_terminal = {
            _name = "duplicate_manager_change_normal",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("normal_duplicate_window_open",0,{instance.Panel_pve_listview})
                state_machine.excute("normal_duplicate_window_show",0,"")
                state_machine.excute("easy_duplicate_window_hide",0,"")
                state_machine.excute("hard_duplicate_window_hide",0,"")
                
                instance.copy_type = 2
                instance:changePageState()
                state_machine.excute("star_box_duplicate_cell_change_type",0,{instance.starboxcell,instance.copy_type})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

		--困难副本
		local duplicate_manager_change_hard_terminal = {
            _name = "duplicate_manager_change_hard",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("hard_duplicate_window_open",0,{instance.Panel_pve_listview})
                state_machine.excute("hard_duplicate_window_show",0,"")
                state_machine.excute("easy_duplicate_window_hide",0,"")
                state_machine.excute("normal_duplicate_window_hide",0,"")

                instance.copy_type = 3 
                instance:changePageState()
                state_machine.excute("star_box_duplicate_cell_change_type",0,{instance.starboxcell,instance.copy_type})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --返回主页
        local duplicate_manager_back_home_terminal = {
            _name = "duplicate_manager_back_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("duplicate_manager_window_close",0,"")
                state_machine.excute("hero_star_activation_window_show",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新宝箱状态
        local duplicate_manager_updatedraw_star_box_terminal = {
            _name = "duplicate_manager_updatedraw_star_box",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("star_box_duplicate_cell_updatedraw",0,{instance.starboxcell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(duplicate_manager_all_page_terminal)
        state_machine.add(duplicate_manager_window_show_terminal)
        state_machine.add(duplicate_manager_window_hide_terminal)
		state_machine.add(duplicate_manager_change_easy_terminal)	
		state_machine.add(duplicate_manager_change_normal_terminal)
		state_machine.add(duplicate_manager_change_hard_terminal)
        state_machine.add(duplicate_manager_back_home_terminal)
        state_machine.add(duplicate_manager_updatedraw_star_box_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_DuplicateManager_terminal()
end

--隐藏副本管理界面
function DuplicateManager:onHide( ... )
    self:setVisible(false)  
end

--显示副本管理界面
function DuplicateManager:onShow( ... )
    self:setVisible(true)
end

function DuplicateManager:changePageState( ... )
    local root = self.roots[1]
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	local Panel_pve_bg = ccui.Helper:seekWidgetByName(root,"Panel_pve_bg")
		if self.copy_type == 1 then
			Panel_pve_bg:setBackGroundImage("images/ui/bg/pve_bg.png")
		else
			Panel_pve_bg:setBackGroundImage(string.format("images/ui/bg/pve_bg%d.png", self.copy_type))
		end
    else
		for i=1,3 do
			if self.copy_type == i then
				ccui.Helper:seekWidgetByName(root,"Image_pve_bg"..i):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(root,"Image_pve_bg"..i):setVisible(false)
			end
		end
    end
end

--更新副本管理界面
function DuplicateManager:onUpdateDraw()
    local root = self.roots[1]
    local Text_pve_top_nub = ccui.Helper:seekWidgetByName(root,"Text_pve_top_nub")      --体力值
    Text_pve_top_nub:setString(_ED.user_info.user_food .. "/" .._ED.user_info.max_user_food)
    self.food_text = Text_pve_top_nub
    --打开副本列表
    if self.copy_type == 1 then 
        state_machine.excute("duplicate_manager_all_page",0,{
            _datas =
               {
                terminal_name = "duplicate_manager_all_page",     
                next_terminal_name = "duplicate_manager_change_easy", 
                current_button_name = "Button_pve_ordinary",   
                but_image = "",     
                terminal_state = 0, 
                isfirst_open = true,
                fun_open_id = 88,
                isPressedActionEnabled = false

                }
        })
    elseif self.copy_type == 2 then 
        state_machine.excute("duplicate_manager_all_page",0,{
            _datas =
               {
                terminal_name = "duplicate_manager_all_page",     
                next_terminal_name = "duplicate_manager_change_normal", 
                current_button_name = "Button_pve_elite",   
                but_image = "",     
                terminal_state = 0, 
                isfirst_open = true,
                fun_open_id = 89,
                isPressedActionEnabled = false

                }
        })
    else
        state_machine.excute("duplicate_manager_all_page",0,{
            _datas =
               {
                terminal_name = "duplicate_manager_all_page",     
                next_terminal_name = "duplicate_manager_change_hard", 
                current_button_name = "Button_pve_unlimited",  
                but_image = "",     
                terminal_state = 0, 
                isfirst_open = true,
                fun_open_id = 90,
                isPressedActionEnabled = false

                }
        })
    end
    --添加宝箱
    self:addStarBox()
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local function openMainWindow()
			state_machine.excute("main_window_open",0,"")
			state_machine.excute("main_window_hide", 0, "")
		end
		local action1 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(openMainWindow))
		self:runAction(action1)  
	end
end

--刷新体力值
function DuplicateManager:onUpdate(dt)
    if self.food_text == nil then
        return
    end
    self.food_text:setString(_ED.user_info.user_food .. "/" .._ED.user_info.max_user_food)
end

--添加宝箱
function DuplicateManager:addStarBox()
    local root = self.roots[1]
    local Panel_star_box_pve = ccui.Helper:seekWidgetByName(root,"Panel_star_box_pve")  --宝箱
    Panel_star_box_pve:removeAllChildren(true)
    local cell = state_machine.excute("star_box_duplicate_create_cell",0,{1,self.copy_type})
    -- --参数1 代表副本，参数2 代表 副本宝箱类型
    Panel_star_box_pve:addChild(cell)
    self.starboxcell = cell
    

end

function DuplicateManager:onInit()

end

--初始化副本管理界面
function DuplicateManager:onEnterTransitionFinish()
    local csbItem = csb.createNode(config_csb.duplicate.duplicate_manager)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    self.Panel_pve_listview = ccui.Helper:seekWidgetByName(root,"Panel_pve_listview")   --关卡列表

    local Panel_pve_bg = ccui.Helper:seekWidgetByName(root,"Panel_pve_bg")
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		Panel_pve_bg:setBackGroundImage("images/ui/bg/pve_bg.png")
    else
	    local jsonPath = "images/ui/effice/effice_pve_bg/effice_pve_bg.json"
	    local atlasPath = "images/ui/effice/effice_pve_bg/effice_pve_bg.atlas"
	    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", false, nil)
	    animation:setPosition(cc.p(Panel_pve_bg:getContentSize().width / 2, 0))
	    Panel_pve_bg:addChild(animation)
    end
    
    --跑马灯
    if funOpenDrawTip(55,false) == false then  
        app.load("client.home.WarshipGirlPushInfo")
        state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})
    end

    --跑马灯top
    -- if funOpenDrawTip(55,false) == false then  
    --     app.load("client.home.WarshipGirlPushInfoTop")
    --     state_machine.excute("warship_girl_push_info_top_open",0,{_datas={_openType=0}})
    -- end

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_back"), nil, 
    {
        terminal_name = "duplicate_manager_back_home", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --简单
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_ordinary"), nil, 
    {
        terminal_name = "duplicate_manager_all_page",     
        next_terminal_name = "duplicate_manager_change_easy", 
        current_button_name = "Button_pve_ordinary",   
        but_image = "",     
        terminal_state = 0, 
        fun_open_id = 88,
        isPressedActionEnabled = false
    }, nil, 3)

    --普通
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_elite"), nil, 
    {
        terminal_name = "duplicate_manager_all_page",     
        next_terminal_name = "duplicate_manager_change_normal", 
        current_button_name = "Button_pve_elite",   
        but_image = "",     
        terminal_state = 0,
        fun_open_id = 89, 
        isPressedActionEnabled = false
    }, nil, 3)

    --困难
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_unlimited"), nil, 
    {
        terminal_name = "duplicate_manager_all_page",     
        next_terminal_name = "duplicate_manager_change_hard", 
        current_button_name = "Button_pve_unlimited",   
        but_image = "",     
        terminal_state = 0,
        fun_open_id = 90, 
        isPressedActionEnabled = false
    }, nil, 3)

    -- 购买体力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_top_add"), nil, 
    {
        terminal_name = "buy_resource_window_open", 
        terminal_state = 0, 
        resource_type = 1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 购买体力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_add_power"), nil, 
    {
        terminal_name = "buy_resource_window_open", 
        terminal_state = 0, 
        resource_type = 1,
    }, nil, 0) 

    self:onUpdateDraw()
end

function DuplicateManager:init(index)
    self.copy_type = 1
    if index ~= nil then 
        self.copy_type = index
    end
	self:onInit()
    return self
end

--移除状态机
function DuplicateManager:onExit()
    state_machine.remove("duplicate_manager_all_page")
    state_machine.remove("duplicate_manager_window_show")
    state_machine.remove("duplicate_manager_window_hide")    
    state_machine.remove("duplicate_manager_change_easy")   
    state_machine.remove("duplicate_manager_change_normal")
    state_machine.remove("duplicate_manager_change_hard")
    state_machine.remove("duplicate_manager_back_home")
    state_machine.remove("duplicate_manager_updatedraw_star_box")
end
