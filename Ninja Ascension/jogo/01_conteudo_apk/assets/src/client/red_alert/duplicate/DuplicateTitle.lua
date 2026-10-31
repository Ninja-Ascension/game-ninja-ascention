-----------------------------
--副本地图顶部信息栏
-----------------------------
DuplicateTitle = class("DuplicateTitleClass", Window)

--打开副本地图顶部信息
local duplicate_title_window_open_terminal = {
    _name = "duplicate_title_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _duplicateTitleWindow = fwin:find("DuplicateTitleClass")
        if nil == _duplicateTitleWindow then
            if type(params) == "table" then
                terminal._datas = params._datas -- 记录数据
            end
            local scenceID = terminal._datas._scenceID
            local from_type = terminal._datas._from_type

            fwin:open(DuplicateTitle:new():init(scenceID,from_type), fwin._ui)
        end
        state_machine.excute("player_resource_window_hide", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭副本地图顶部信息
local duplicate_title_window_close_terminal = {
    _name = "duplicate_title_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("DuplicateTitleClass")
        if win ~= nil then
            fwin:close(win)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_title_window_open_terminal)
state_machine.add(duplicate_title_window_close_terminal)
state_machine.init()

function DuplicateTitle:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --场景id
    self.scenceID = nil
    --副本类型
    self.from_type = nil  
	self.listview = nil
	self.listview_pox = nil
    --宝石数
    self.gold_text = nil
    --体力值
    self.food_text = nil
    -- Initialize DuplicateTitle state machine.
    local function init_duplicate_title_terminal()
	
		--显示界面
		local duplicate_title_window_show_terminal = {
            _name = "duplicate_title_window_show",
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
		--隐藏界面
		local duplicate_title_window_hide_terminal = {
            _name = "duplicate_title_window_hide",
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

        --返回上级界面
        local duplicate_title_back_up_floor_terminal = {
            _name = "duplicate_title_back_up_floor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("duplicate_title_window_close",0,"")
                state_machine.excute("duplicate_map_window_close",0,"")
                state_machine.excute("duplicate_manager_updatedraw_star_box",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --刷新剩下的挑战次数
        local duplicate_title_update_hard_times_terminal = {
            _name = "duplicate_title_update_hard_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:drawHardAttackTimes()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --刷新副本地图顶部信息
        local duplicate_title_update_information_terminal = {
            _name = "duplicate_title_update_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local scence_id = params[1]
                instance:onUpdateDraw(scence_id)
                local ter = state_machine.find("duplicate_title_window_open")
                if ter ~= nil then
                    ter._datas._scenceID = scence_id
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --任务完成元宝获得动画
        local duplicate_title_play_animation_terminal = {
            _name = "duplicate_title_play_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local value = params[1]
                instance:onPlayAnimation(value)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(duplicate_title_window_show_terminal)	
		state_machine.add(duplicate_title_window_hide_terminal)
        state_machine.add(duplicate_title_back_up_floor_terminal)
        state_machine.add(duplicate_title_update_hard_times_terminal)
        state_machine.add(duplicate_title_update_information_terminal)
        state_machine.add(duplicate_title_play_animation_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_duplicate_title_terminal()
end

--隐藏
function DuplicateTitle:onHide( ... )
    self:setVisible(false)
end

--显示
function DuplicateTitle:onShow( ... )
    self:setVisible(true)
end

--刷新副本地图顶部信息
function DuplicateTitle:onUpdateDraw(scence_id)
    if scence_id ~= nil then 
        self.scenceID = scence_id
    end
    local root = self.roots[1]
    local Panel_map_chapter_name = ccui.Helper:seekWidgetByName(root,"Panel_map_chapter_name")      --场景名
    Panel_map_chapter_name:removeBackGroundImage()
    Panel_map_chapter_name:setBackGroundImage("images/ui/pve_sn/pve_map_chapt/pve_map_chapter_name_"..self.scenceID..".png")

    local Text_pvemap_top_info_1 = ccui.Helper:seekWidgetByName(root,"Text_pvemap_top_info_1")      --宝石数
    local Text_pvemap_top_info_2 = ccui.Helper:seekWidgetByName(root,"Text_pvemap_top_info_2")      --体力值
    Text_pvemap_top_info_2:setString(_ED.user_info.user_food .. "/" .._ED.user_info.max_user_food)
    --钻石
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
        Text_pvemap_top_info_1:setString(string.format(red_alert_all_str[122],info))
    else
        Text_pvemap_top_info_1:setString(_ED.user_info.user_gold)
    end
    self.gold_text = Text_pvemap_top_info_1
    self.food_text = Text_pvemap_top_info_2

end

--刷新炼狱副本挑战次数
function DuplicateTitle:drawHardAttackTimes()
    local root = self.roots[1]
    local Panel_hard = ccui.Helper:seekWidgetByName(root,"Panel_hard")      --炼狱面板
    if self.from_type == 1 then
        Panel_hard:setVisible(false)
    elseif self.from_type == 2 then
        Panel_hard:setVisible(false)
    elseif self.from_type == 3 then
        Panel_hard:setVisible(true)
    end
    local Text_hard_dec_times = ccui.Helper:seekWidgetByName(root,"Text_hard_dec_times")    --炼狱挑战次数
    --todo 获取剩下的挑战次数    
    local max_attack_times = dms.int(dms["copy_config"],1,copy_config.param)        --最大挑战次数
    Text_hard_dec_times:setString(_ED.npc_hard_all_attack_times.."/"..max_attack_times)
end

--刷新宝石、体力
function DuplicateTitle:onUpdate(dt)
    if self.gold_text == nil or self.food_text == nil then
        return
    end
    --体力
    self.food_text:setString(_ED.user_info.user_food .. "/" .._ED.user_info.max_user_food)
    --钻石
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
        self.gold_text:setString(string.format(red_alert_all_str[122],info))
    else
        self.gold_text:setString(_ED.user_info.user_gold)
    end
end

function DuplicateTitle:onEnterTransitionFinish()

end

--任务完成元宝获得动画
function DuplicateTitle:onPlayAnimation(value)
    --删除
    local function removeDrawAntNumberFuncN(sender)
        sender:removeFromParent(true)
    end
    local root = self.roots[1]
    local Image_gold = ccui.Helper:seekWidgetByName(root,"Image_pve_map_icon_1")
    local Image_gold_x = Image_gold:getPositionX()
    local Image_gold_y = Image_gold:getPositionY()
    local Panel_gem_get = ccui.Helper:seekWidgetByName(root,"Panel_gem_get")
    local Panel_gem_get_x = Panel_gem_get:getPositionX()
    local Panel_gem_get_y = Panel_gem_get:getPositionY()
    for i = 1, 5 do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_gem_mt/effect_gem_mt.ExportJson")
        local effice = ccs.Armature:create("effect_gem_mt")
        effice:getAnimation():playWithIndex(0)
        if math.floor(i % 2) == 0 then
            effice:setPosition(cc.p(Panel_gem_get:getContentSize().width/2 + 10 * i, Panel_gem_get:getContentSize().height/2))
        else
            effice:setPosition(cc.p(Panel_gem_get:getContentSize().width/2 - 10 * i, Panel_gem_get:getContentSize().height/2))
        end
        Panel_gem_get:addChild(effice) 
        effice:runAction(cc.Sequence:create(
            cc.DelayTime:create(i/5),
            cc.MoveTo:create(0.7, cc.p(Image_gold_x-Panel_gem_get_x,Image_gold_y-Panel_gem_get_y)),
            cc.CallFunc:create(removeDrawAntNumberFuncN)
            ))
        local text_table = {"+"..value}
        state_machine.excute("add_number_window_open",0,{26,text_table})
    end
end

--初始化副本地图顶部信息
function DuplicateTitle:onInit( )
    local csbItem = csb.createNode(config_csb.duplicate.duplicate_title)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    --返回上级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_map_back"), nil, 
    {
        terminal_name = "duplicate_title_back_up_floor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pvemap_top_info_add_1"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_add_gem"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
    }, nil, 0)

    -- 购买体力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pvemap_top_info_add_2"), nil, 
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
    }, nil, 0) 

    
	self:onUpdateDraw()	
    self:addStarBox()
    self:drawHardAttackTimes()
end

--添加宝箱
function DuplicateTitle:addStarBox( ... )
    local root = self.roots[1]
    local Panel_star_box_pve_map = ccui.Helper:seekWidgetByName(root,"Panel_star_box_pve_map")
    Panel_star_box_pve_map:removeAllChildren(true)
    --参数1 代表副本，参数2 代表 副本宝箱类型
    local cell = state_machine.excute("star_box_duplicate_create_cell",0,{1,self.from_type})
    Panel_star_box_pve_map:addChild(cell)

end

function DuplicateTitle:init(scenceID,from_type)
    self.scenceID = scenceID
    self.from_type = from_type
	self:onInit()
    return self
end

--移除状态机
function DuplicateTitle:onExit()
    state_machine.remove("duplicate_title_window_show") 
    state_machine.remove("duplicate_title_window_hide")
    state_machine.remove("duplicate_title_back_up_floor")
    state_machine.remove("duplicate_title_update_hard_times")
    state_machine.remove("duplicate_title_update_information")
    state_machine.remove("duplicate_title_play_animation")
end
