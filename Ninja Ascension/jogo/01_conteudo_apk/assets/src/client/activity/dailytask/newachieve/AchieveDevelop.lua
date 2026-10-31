-- ----------------------------------------------------------------------------------------------------
-- 说明：新版成就
-- 创建时间 2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
            -- self.group._achievement_page = AchieveListLevel:new()
            -- self.group._achievement_page:init(2)
            -- fwin:open(self.group._achievement_page,fwin._view)
AchieveDevelop = class("AchieveDevelopClass", Window)
app.load("client.activity.dailytask.newachieve.achievement_list_cell_new")
app.load("client.activity.dailytask.newachieve.achieve_button_list_cell")
app.load("client.activity.dailytask.newachieve.AchieveListLevel")
app.load("client.activity.dailytask.newachieve.AchieveListPassDuplicute")
app.load("client.activity.dailytask.newachieve.AchieveListFightUp")
app.load("client.activity.dailytask.newachieve.AchieveListFightTop")
app.load("client.activity.dailytask.newachieve.AchieveListVip")
app.load("client.activity.dailytask.newachieve.AchieveListEquip")
app.load("client.activity.dailytask.newachieve.AchieveListTreasure")
app.load("client.activity.dailytask.newachieve.AchieveListFormation")
app.load("client.activity.dailytask.newachieve.AchieveListTaialtower")
app.load("client.activity.dailytask.newachieve.AchieveListSkill")
app.load("client.activity.dailytask.newachieve.AchieveListMine")
app.load("client.activity.dailytask.newachieve.AchieveListWorldBoss")
app.load("client.activity.dailytask.newachieve.AchieveListStars")
app.load("client.activity.dailytask.newachieve.AchieveListAwaken")
app.load("client.activity.dailytask.newachieve.AchieveListAbility")

function AchieveDevelop:ctor()
    self.super:ctor()
    self.roots = {}
    self.listviews = {
        level = nil,                --冲级达人
        pass_duplicute = nil,       --完美通关
        fight_up = nil,             --战力提升
        fight_top = nil,            --战力爆表
        vip = nil,            --战力爆表
        equip = nil,            --战力爆表
        treasure = nil,            --战力爆表
        formation = nil,            --战力爆表
        trialtower = nil,            --战力爆表
        skill = nil,            --战力爆表
        mine = nil,            --战力爆表
        worldboss = nil,            --战力爆表
        stars = nil,            --战力爆表
        awaken = nil,            --战力爆表
        ability = nil,            --战力爆表
        }


    --  achieveName = {
--     "冲级达人",----------------1
--     "完美通关",----------------2
--     "战力提升",----------------3
--     "战力爆表",----------------4
--     "特权在手",----------------5
--     "神兵利器",----------------6
--     "心法秘籍",----------------7
--     "最强阵容",----------------8
--     "荡平罗刹",----------------9
--     "无之境地",----------------10
--     "拔刀相助",----------------11
--     "惩恶扬善",----------------12
--     "攒星达人",----------------13
--     "觉醒之力",----------------14
--     "精英通关",----------------15
-- }
    self.buttons = {}
    self.lastbutton = nil
    self.achieve_type = nil

    self.button_list_view = nil
    self.button_list_view_posY =nil
    -- Initialize EmailManager page state machine.
    local function init_achieve_develop_terminal()

        --manager
        local achieve_develop_manager_terminal = {
            _name = "achieve_develop_manager",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.lastbutton ~= params._datas.current_button and params._datas.current_button ~= nil then
                    if instance.lastbutton ~= nil then
                         instance.lastbutton:setHighlighted(false)
                         instance.lastbutton:setTouchEnabled(true)
                    end

                    params._datas.current_button:setHighlighted(true)
                    params._datas.current_button:setTouchEnabled(false)
                    instance.lastbutton = params._datas.current_button
                    for i, v in pairs(instance.listviews) do
                        if v ~= nil then
                            v:setVisible(false)
                        end
                    end
                    state_machine.excute(params._datas.next_terminal_name,0,params._datas.achieve_type)
                    instance.achieve_type = params._datas.achieve_type
                end

            return true
        end,
        _terminal = nil,
        _terminals = nil
        }
        --关闭界面
        local achieve_develop_close_terminal = {
            _name = "achieve_develop_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i , v in pairs(instance.listviews) do
                    if v ~= nil then
                        fwin:close(v)
                    end
                end
                fwin:close(instance)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         --冲级达人
        local achieve_develop_open_level_terminal = {
            _name = "achieve_develop_open_level",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListLevel:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --完美通关
        local achieve_develop_open_pass_duplicute_terminal = {
            _name = "achieve_develop_open_pass_duplicute",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListPassDuplicute:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --战力提升
        local achieve_develop_open_fight_up_terminal = {
            _name = "achieve_develop_open_fight_up",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListFightUp:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)     
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --战力爆表
        local achieve_develop_open_fight_top_terminal = {
            _name = "achieve_develop_open_fight_top",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListFightTop:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --特权在手
        local achieve_develop_open_vip_terminal = {
            _name = "achieve_develop_open_vip",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListVip:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --神兵利器
        local achieve_develop_open_equip_terminal = {
            _name = "achieve_develop_open_equip",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListEquip:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --心法秘籍
        local achieve_develop_open_treasure_terminal = {
            _name = "achieve_develop_open_treasure",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListTreasure:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --最强阵容
        local achieve_develop_open_formation_terminal = {
            _name = "achieve_develop_open_formation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListFormation:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --荡平罗刹
        local achieve_develop_open_trialtower_terminal = {
            _name = "achieve_develop_open_trialtower",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListTaialtower:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --无之境地
        local achieve_develop_open_skill_terminal = {
            _name = "achieve_develop_open_skill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListSkill:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --拔刀相助
        local achieve_develop_open_mine_terminal = {
            _name = "achieve_develop_open_mine",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListMine:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --惩恶扬善
        local achieve_develop_open_worldboss_terminal = {
            _name = "achieve_develop_open_worldboss",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListWorldBoss:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --攒星达人
        local achieve_develop_open_stars_terminal = {
            _name = "achieve_develop_open_stars",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListStars:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --觉醒之力
        local achieve_develop_open_awaken_terminal = {
            _name = "achieve_develop_open_awaken",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListAwaken:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --精英通关
        local achieve_develop_open_ability_terminal = {
            _name = "achieve_develop_open_ability",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.listviews[params] == nil then
                    instance.listviews[params] = AchieveListAbility:new()
                    instance.listviews[params]:init(params)
                    fwin:open(instance.listviews[params],fwin._view)
                end
                instance.listviews[params]:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --隐藏所有或显示所有
        local achieve_develop_hidden_show_terminal = {
            _name = "achieve_develop_hidden_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    if params == false then
                        for i,v in pairs(instance.listviews) do
                            if v ~= ni then
                                v:setVisible(params)
                            end
                        end
                    else
                        -- print("==========",instance.achieve_type)
                        if instance.achieve_type == nil then
                            instance.achieve_type = 1 
                        end
                        instance.listviews[instance.achieve_type]:setVisible(true)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(achieve_develop_manager_terminal)
        state_machine.add(achieve_develop_close_terminal)                                                       
        state_machine.add(achieve_develop_open_level_terminal)
        state_machine.add(achieve_develop_open_pass_duplicute_terminal)
        state_machine.add(achieve_develop_open_fight_up_terminal)
        state_machine.add(achieve_develop_open_fight_top_terminal)
        state_machine.add(achieve_develop_open_vip_terminal)
        state_machine.add(achieve_develop_open_equip_terminal)
        state_machine.add(achieve_develop_open_treasure_terminal)
        state_machine.add(achieve_develop_open_formation_terminal)
        state_machine.add(achieve_develop_open_trialtower_terminal)
        state_machine.add(achieve_develop_open_skill_terminal)
        state_machine.add(achieve_develop_open_mine_terminal)
        state_machine.add(achieve_develop_open_worldboss_terminal)
        state_machine.add(achieve_develop_open_stars_terminal)
        state_machine.add(achieve_develop_open_awaken_terminal)
        state_machine.add(achieve_develop_open_ability_terminal)
        state_machine.add(achieve_develop_hidden_show_terminal)

        state_machine.init()
    end
    -- call func init hom state machine.
    init_achieve_develop_terminal()
end

function AchieveDevelop:onEnterTransitionFinish()

end

function AchieveDevelop:createButton(achieve_type , name , pic_index)
    -- local csbItem = csb.createNode("activity/DailyTasks/achieve_button_cell.csb")
    -- local root = csbItem:getChildByName("root")
    -- root:removeFromParent()
    -- local Text_tab_name = ccui.Helper:seekWidgetByName(root, "Text_tab_name")
    -- Text_tab_name:setString(name)
    -- local Panel_tab_icon = ccui.Helper:seekWidgetByName(root, "Panel_tab_icon")
    -- Panel_tab_icon:removeBackGroundImage()
    -- Panel_tab_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))

    -- local Button_cj_tab = ccui.Helper:seekWidgetByName(root, "Button_cj_tab")
    -- table.insert(self.buttons,Button_cj_tab)
    
    -- local function addButtonTouchEvent(button , _terminal_name , _next_terminal_name , _achieve_type)
    --     fwin:addTouchEventListener(button, nil, 
    --     {
    --         terminal_name = _terminal_name,     
    --         next_terminal_name = _next_terminal_name, 
    --         current_button =  button , 
    --         achieve_type = _achieve_type,
    --         terminal_state = 0, 
    --         isPressedActionEnabled = true
    --     }, 
    --     nil, 0) 
    -- end

    -- if achieve_type == 1 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_level",achieve_type)
    -- elseif achieve_type == 2 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_pass_duplicute",achieve_type)
    -- elseif achieve_type == 3 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_fight_up",achieve_type)
    -- elseif achieve_type == 4 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_fight_top",achieve_type)
    -- elseif achieve_type == 5 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_vip",achieve_type)
    -- elseif achieve_type == 6 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_equip",achieve_type)
    -- elseif achieve_type == 7 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_treasure",achieve_type)
    -- elseif achieve_type == 8 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_formation",achieve_type)
    -- elseif achieve_type == 9 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_trialtower",achieve_type)
    -- elseif achieve_type == 10 then    
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_skill",achieve_type)
    -- elseif achieve_type == 11 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_mine",achieve_type)
    -- elseif achieve_type == 12 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_worldboss",achieve_type)
    -- elseif achieve_type == 13 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_stars",achieve_type)
    -- elseif achieve_type == 14 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_awaken",achieve_type)
    -- elseif achieve_type == 15 then
    --     addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_ability",achieve_type)
    -- end        
    -- return root
end
function AchieveDevelop:onInit()
    local csbItem = csb.createNode("activity/DailyTasks/achieve_develop.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots,root)
    self:addChild(csbItem)
    self:onUpdateDraw()
    for i,v in ipairs(self.buttons) do
        if v ~= nil then
            fwin.touch(v, ccui.TouchEventType.ended)
            break
        end
    end      
end
function AchieveDevelop:onUpdate()
    -- if self.button_list_view ~= nil then
    --     local size = self.button_list_view:getContentSize()
    --     local posY = self.button_list_view:getInnerContainer():getPositionY()
    --     if self.button_list_view_posY == posY then
    --         return
    --     end
    --     self.button_list_view_posY = posY
    --     local items = self.button_list_view:getItems()
    --     if items[1] == nil then
    --         return
    --     end
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         local tempY = v:getPositionY() + posY
    --         if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
    --             v:unload()
    --         else
    --             v:reload()
    --         end
    --     end
    -- end
end

function AchieveDevelop:onUpdateDraw()

    local push_states = {}
    -- print("=====",os.clock())
    for j,k in pairs(achieveName) do
        local state = 0
        for i, v in pairs(_ED.all_achieve) do
            local ty_id = tonumber(dms.string(dms["achieve"],i,achieve.open_level))
            if ty_id == j and ty_id ~= -1  then
                local param2 = dms.int(dms["achieve"],i,achieve.param2) 
                local param3 = dms.int(dms["achieve"],i,achieve.param3) 
                local nowpersent = tonumber(v)
                if param3 ~= -1 then
                    maxpersent = param3
                else 
                    maxpersent = param2
                end      
                if nowpersent >= maxpersent then
                    state = 1 
                    break 
                end

                if ty_id == 10 then
                    maxpersent = param2
                    if nowpersent >= maxpersent then
                        state = 1 
                    end
                    break 
                end
            end
        end
        push_states[j] = state
    end
    -- print("=====",os.clock())

    -- debug.print_r(push_states)
    local root = self.roots[1]
    local ListView_tab = ccui.Helper:seekWidgetByName(root,"ListView_tab")
    ListView_tab:removeAllItems()
    local index = 1
    local no_push_cells = {}
    for i,v in pairs(achieveName) do
        if v[3] ~= -1 and push_states[i] == 1 then

            local button_cell = AchievementButtonListCell:createCell()
            button_cell:init(v[4],v[1],v[2],index)
            ListView_tab:addChild(button_cell)
            index = index + 1

            table.insert(self.buttons,button_cell._button)
        elseif v[3] ~= -1 and push_states[i] == 0 then       
            table.insert(no_push_cells,v)
        end
    end

    for i,v in pairs(no_push_cells) do
        local button_cell = AchievementButtonListCell:createCell()  
        button_cell:init(v[4],v[1],v[2],index)
        ListView_tab:addChild(button_cell)
        index = index + 1
        table.insert(self.buttons,button_cell._button)
    end
    ListView_tab:requestRefreshView()
    self.button_list_view = ListView_tab
    self.button_list_view_posY = self.button_list_view:getInnerContainer():getPositionY()
end

function AchieveDevelop:init()
    self:onInit()
end

function AchieveDevelop:onExit()
    state_machine.remove("achieve_develop_manager")
    state_machine.remove("achieve_develop_close")                                                       
    state_machine.remove("achieve_develop_open_level")
    state_machine.remove("achieve_develop_open_pass_duplicute")
    state_machine.remove("achieve_develop_open_fight_up")
    state_machine.remove("achieve_develop_open_fight_top")
    state_machine.remove("achieve_develop_open_vip")
    state_machine.remove("achieve_develop_open_equip")
    state_machine.remove("achieve_develop_open_treasure")
    state_machine.remove("achieve_develop_open_formation")
    state_machine.remove("achieve_develop_open_trialtower")
    state_machine.remove("achieve_develop_open_skill")
    state_machine.remove("achieve_develop_open_mine")
    state_machine.remove("achieve_develop_open_worldboss")
    state_machine.remove("achieve_develop_open_stars")
    state_machine.remove("achieve_develop_open_awaken")
    state_machine.remove("achieve_develop_open_ability")
    state_machine.remove("achieve_develop_hidden_show")
end