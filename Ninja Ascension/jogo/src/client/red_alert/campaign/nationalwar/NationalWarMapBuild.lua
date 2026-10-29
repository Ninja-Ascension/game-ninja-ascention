-----------------------------
--单个城池
-----------------------------
NationalWarMapBuild = class("NationalWarMapBuildClass", Window)

local national_war_map_build_create_terminal = {
    _name = "national_war_map_build_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local city_data = params[1]
        local city = NationalWarMapBuild:new()
        city:init(city_data)
        city:registerOnNodeEvent(city)
        return city
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_map_build_create_terminal)
state_machine.init()

function NationalWarMapBuild:ctor()
    self.super:ctor()
    self.roots = {}
    self.city_data = nil
    self.city_pic =  nil
    self.city_name = nil
    self.city_camp = nil
    self.state = nil -- 城池状态0,0,0,0,0(0:正常,1:可突进,2:包围,3:进攻任务,4:防守任务,5:交战状态)
    self.city_id = nil 
    -- Initialize national_war_map_build state machine.
    local function init_national_war_map_build_terminal()

        -- 
        local national_war_map_build_click_city_terminal = {
            _name = "national_war_map_build_click_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local city = params._datas.cell
                local city_id = city.city_id          
                state_machine.excute("national_war_map_open_build_button",0,{city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(national_war_map_build_click_city_terminal)    
        state_machine.init()
    end
    
    -- call func init national_war_map_build state machine.
    init_national_war_map_build_terminal()
end


function NationalWarMapBuild:onUpdateDraw()
    local root = self.roots[1]
    local Text_nationalwar_map_build_name = ccui.Helper:seekWidgetByName(root,"Text_nationalwar_map_build_name") -- 建筑名
    local Panel_nationalwar_map_build_prompt = ccui.Helper:seekWidgetByName(root,"Panel_nationalwar_map_build_prompt") -- 集结 集团军
    local Image_nationalwar_map_set = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_set") -- 集结 
    local Image_nationalwar_map_set_army = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_set_army")--集团军
    local Panel_nationalwar_map_build_status = ccui.Helper:seekWidgetByName(root,"Panel_nationalwar_map_build_status")--防御 战斗中
    local Image_nationalwar_map_build_icon_1 = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_build_icon_1") -- 防御
    local Image_nationalwar_map_build_icon_2 = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_build_icon_2") -- 防御
    Text_nationalwar_map_build_name:setString(self.city_name)
    local Panel_nationalwar_map_build_camp = ccui.Helper:seekWidgetByName(root,"Panel_nationalwar_map_build_camp") -- 所属阵营
    if tonumber(self.city_camp) ~= 0 then
        Panel_nationalwar_map_build_camp:setBackGroundImage("images/ui/play/nationalwar/camp_text_"..self.city_camp..".png")
    end
    local Panel_build = ccui.Helper:seekWidgetByName(root,"Panel_build") -- 城池

    local pic_index = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.city_pic)
    Panel_build:setBackGroundImage("images/ui/play/nationalwar/build/nationalwar_building_".. pic_index ..".png")
    
end

function NationalWarMapBuild:onUpdateDrawOtherState()
    local root = self.roots[1]
    local Panel_surround = ccui.Helper:seekWidgetByName(root,"Panel_surround")
    Panel_surround:removeAllChildren(true)
    Panel_surround:setVisible(true)
    local state_table = zstring.split(_ED.warfareCityInfo[self.city_id].state,",")
    -- 城池状态0,0,0,0,0,0(1:正常没用,2:可突进没用,3:包围没用,4:进攻任务,5:防守任务,6:交战状态)
    local Panel_nationalwar_map_build_camp = ccui.Helper:seekWidgetByName(root,"Panel_nationalwar_map_build_camp") -- 所属阵营
    if tonumber(_ED.warfareCityInfo[self.city_id].camp) ~= 0 then
        Panel_nationalwar_map_build_camp:setBackGroundImage("images/ui/play/nationalwar/camp_text_".._ED.warfareCityInfo[self.city_id].camp..".png")
    end
    local Panel_nationalwar_map_build_prompt = ccui.Helper:seekWidgetByName(root,"Panel_nationalwar_map_build_prompt")
    local Image_nationalwar_map_set = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_set")
    local Image_nationalwar_map_set_army = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_set_army")
    Panel_nationalwar_map_build_prompt:setVisible(false)
    Image_nationalwar_map_set:setVisible(false)
    Image_nationalwar_map_set_army:setVisible(false)  

    -- debug.print_r(_ED.war_task_info.country)
    ---是否防守任务
    local is_defense = false
     ---是否攻击任务
    local is_attack = false
    for i,v in pairs(_ED.war_task_info.country) do
        local task_id = tonumber(v.task_id)
        local task_type = dms.int(dms["warfare_task"],task_id,warfare_task.task_type)
        if task_type == 1 then
            local task_city_id = dms.int(dms["warfare_task"],task_id,warfare_task.task_param)
            if task_city_id == self.city_id then
                if tonumber(v.task_state) == 0 then
                    if tonumber(_ED.user_info.user_force) == tonumber(_ED.warfareCityInfo[self.city_id].camp) then
                        is_defense = true
                    else
                        is_attack = true
                    end
                end
            end
        end
    end

    if _ED.war_decree_time[self.city_id] ~= nil and  zstring.tonumber(_ED.war_decree_time[self.city_id].country_leave_time) > 0  then
        Panel_nationalwar_map_build_prompt:setVisible(true)
        Image_nationalwar_map_set:setVisible(true)

    elseif _ED.war_decree_time[self.city_id] ~= nil and  zstring.tonumber(_ED.war_decree_time[self.city_id].family_leave_time) > 0 then
        Panel_nationalwar_map_build_prompt:setVisible(true)
        Image_nationalwar_map_set_army:setVisible(true)

    elseif is_defense == true then -- 防守任务 
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_fangshou/effect_fangshou.ExportJson")
        local effice = ccs.Armature:create("effect_fangshou")
        effice:setPosition(cc.p(Panel_surround:getContentSize().width/2, Panel_surround:getContentSize().height/2))
        effice:getAnimation():playWithIndex(0)
        Panel_surround:addChild(effice)        
    elseif is_attack == true then -- 进攻任务
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_gongzhan/effect_gongzhan.ExportJson")
        local effice = ccs.Armature:create("effect_gongzhan")
        effice:getAnimation():playWithIndex(0)
        effice:setPosition(cc.p(Panel_surround:getContentSize().width/2, Panel_surround:getContentSize().height/2))
        Panel_surround:addChild(effice)         
    end
    ----突进
    local can_shoot = false
    local border_city = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.border_city)
    border_city = zstring.split(border_city,",")    
    for i,v in pairs(border_city) do
        if zstring.tonumber(_ED.war_user_at_city_id) == tonumber(v) then -- 如果相邻城池中 有玩家所在的城池
            if tonumber(_ED.war_in_city_info.now_city_camp) ~= tonumber(_ED.user_info.user_force) 
            and tonumber(_ED.warfareCityInfo[tonumber(self.city_id)].camp) ~= tonumber(_ED.user_info.user_force) then -- 玩家所在城池阵营不属于玩家 并且 选中当前查看城池不属于玩家
                -- 玩家所在的城池 没有敌对玩家，并且人数大于敌方守卫两倍
                if tonumber(_ED.war_in_city_info.now_city_camp) == 1 then
                    if zstring.tonumber(_ED.war_in_city_info.union_people_number) == 0 then
                        if tonumber(_ED.user_info.user_force) == 2 then
                            if tonumber(_ED.war_in_city_info.act_of_god_numbers) >= tonumber(_ED.war_in_city_info.defense_people_number)*2 then
                                can_shoot = true
                                break
                            end
                        elseif tonumber(_ED.user_info.user_force) == 3 then
                            if tonumber(_ED.war_in_city_info.natural_numbers) >= tonumber(_ED.war_in_city_info.defense_people_number)*2 then
                                can_shoot = true
                                break
                            end                            
                        end
                    end
                elseif tonumber(_ED.war_in_city_info.now_city_camp) == 2 then
                    if zstring.tonumber(_ED.war_in_city_info.act_of_god_numbers) == 0 then
                        if tonumber(_ED.user_info.user_force) == 1 then
                            if tonumber(_ED.war_in_city_info.union_people_number) >= tonumber(_ED.war_in_city_info.defense_people_number)*2 then
                                can_shoot = true
                                break
                            end
                        elseif tonumber(_ED.user_info.user_force) == 3 then
                            if tonumber(_ED.war_in_city_info.natural_numbers) >= tonumber(_ED.war_in_city_info.defense_people_number)*2 then
                                can_shoot = true
                                break
                            end                            
                        end
                    end                    
                elseif tonumber(_ED.war_in_city_info.now_city_camp) == 3 then
                    if tonumber(_ED.user_info.user_force) == 1 then
                        if tonumber(_ED.war_in_city_info.union_people_number) >= tonumber(_ED.war_in_city_info.defense_people_number)*2 then
                            can_shoot = true
                            break
                        end
                    elseif tonumber(_ED.user_info.user_force) == 2 then
                        if tonumber(_ED.war_in_city_info.act_of_god_numbers) >= tonumber(_ED.war_in_city_info.defense_people_number)*2 then
                            can_shoot = true
                            break
                        end                            
                    end                    
                end
            end
        end
    end

    if can_shoot == true then -- 可突进
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_tujin/effect_tujin.ExportJson")
        local effice = ccs.Armature:create("effect_tujin")
        effice:getAnimation():playWithIndex(0)
        effice:setPosition(cc.p(Panel_surround:getContentSize().width/2, Panel_surround:getContentSize().height/2))
        Panel_surround:addChild(effice) 
    end

    if tonumber(state_table[6]) == 1 then -- 交战状态
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_jiaozhanzhong/effect_jiaozhanzhong.ExportJson")
        local effice = ccs.Armature:create("effect_jiaozhanzhong")
        effice:getAnimation():playWithIndex(0)
        effice:setPosition(cc.p(Panel_surround:getContentSize().width/2, Panel_surround:getContentSize().height/2))
        Panel_surround:addChild(effice) 
    end

    local baowei = true
    for i,v in pairs(border_city) do
        if _ED.warfareCityInfo[tonumber(v)].camp == _ED.warfareCityInfo[tonumber(self.city_id)].camp then
            baowei = false
        end
    end
    if baowei == true then -- 包围
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_baoweizhong/effect_baoweizhong.ExportJson")
        local effice = ccs.Armature:create("effect_baoweizhong")
        effice:getAnimation():playWithIndex(0)
        effice:setPosition(cc.p(Panel_surround:getContentSize().width/2, Panel_surround:getContentSize().height/2))
        Panel_surround:addChild(effice) 
        
    end
end

function NationalWarMapBuild:onUpdateDecreeState()
    local root = self.roots[1]
    local Panel_nationalwar_map_build_prompt = ccui.Helper:seekWidgetByName(root,"Panel_nationalwar_map_build_prompt")
    local Image_nationalwar_map_set = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_set")
    local Image_nationalwar_map_set_army = ccui.Helper:seekWidgetByName(root,"Image_nationalwar_map_set_army")
    Panel_nationalwar_map_build_prompt:setVisible(false)
    Image_nationalwar_map_set:setVisible(false)
    Image_nationalwar_map_set_army:setVisible(false)
    if _ED.war_decree_time[self.city_id] ~= nil and  zstring.tonumber(_ED.war_decree_time[self.city_id].country_leave_time) > 0  then
        Panel_nationalwar_map_build_prompt:setVisible(true)
        Image_nationalwar_map_set:setVisible(true)

    elseif _ED.war_decree_time[self.city_id] ~= nil and  zstring.tonumber(_ED.war_decree_time[self.city_id].family_leave_time) > 0 then
        Panel_nationalwar_map_build_prompt:setVisible(true)
        Image_nationalwar_map_set_army:setVisible(true)
    end
end

function NationalWarMapBuild:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_map_build)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_build"), nil, 
    {
        terminal_name = "national_war_map_build_click_city",
        terminal_state = 0,
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    
    self:onUpdateDraw() 
    self:onUpdateDrawOtherState()
end

function NationalWarMapBuild:init(city_data)
    self.city_data = city_data
    self.city_id = tonumber(city_data.city_id)
    local city_pic = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.city_pic)
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.city_name)
    self.city_pic =  city_pic
    self.city_name = city_name
    self.city_camp = city_data.camp
    self.state = city_data.state -- 1 正常状态 2 被围攻 3燃烧
    self:onInit()
    return self
end

function NationalWarMapBuild:close()
    local root = self.roots[1]
    local Panel_surround = ccui.Helper:seekWidgetByName(root,"Panel_surround")
    Panel_surround:removeAllChildren(true)
end

function NationalWarMapBuild:onExit()

end
