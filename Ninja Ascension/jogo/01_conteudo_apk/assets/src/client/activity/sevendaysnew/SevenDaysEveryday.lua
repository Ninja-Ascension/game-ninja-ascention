----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日成就列表
-------------------------------------------------------------------------------------------------------
SevenDaysEveryday = class("SevenDaysEverydayClass", Window)
app.load("client.cells.prop.prop_money_icon")
app.load("client.activity.sevendaysnew.SevenDaysBoxDialog")
function SevenDaysEveryday:ctor()
    self.super:ctor()
    self.roots = {}

    self.activity = _ED.active_activity[42]

    self.dayIndex = 0
    self.list_view = nil
    
    -- Initialize seven days activity for every day achievement page state machine.
    local function init_seven_days_everyday_terminal()
        --关闭
        local seven_days_every_day_update_state_terminal = {
            _name = "seven_days_every_day_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               instance:drawPanelState()
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_every_day_selected_terminal = {
            _name = "seven_days_every_day_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("seven_days_box_hero_open", 0, {_seven_day_activity_reward_hero_ids, 7, 0, nil})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(seven_days_every_day_update_state_terminal)
        state_machine.add(seven_days_every_day_selected_terminal)
        state_machine.init()
    end
    
    -- call func init_seven_days_teasure_terminal.
    init_seven_days_everyday_terminal()
end

function SevenDaysEveryday:onUpdateDraw()
    local root = self.roots[1]
    for i=1 , 7 do
        -- local daily_welfare_ids = zstring.split(dms.string(dms["carnival_mould"],i,carnival_mould.welfare),",")
        -- local daily_welfare_id = daily_welfare_ids[1]
        self:drawPanel(i)
    end
end
function SevenDaysEveryday:drawPanel(index)
    local root = self.roots[1]
    local panel = ccui.Helper:seekWidgetByName(root, "Panel_day_icon_"..index)
    if index == 7 then
        app.load("client.activity.sevendaysnew.SevenDaysOrangeHeroGet")
        fwin:addTouchEventListener(panel,nil, 
        {
            terminal_name = "seven_days_every_day_selected",   
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 0)
    else 
        fwin:addTouchEventListener(panel,nil, 
        {
            terminal_name = "seven_days_box_open",     
            terminal_state = 0, 
            -- welfare_id = daily_welfare_id,
            day_index = index ,
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end
end
function SevenDaysEveryday:drawPanelState()
    local root = self.roots[1]
    local dCount = 7
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        dCount = 5
    end
    for day = 1 , dCount do
      local Image_gouhao = ccui.Helper:seekWidgetByName(root,"Image_gouhao_"..day)
      local Image_hui = ccui.Helper:seekWidgetByName(root,"Image_hui_"..day)
      local rewards_str_table = dms.searchs(dms["daily_welfare"],daily_welfare.reward_need_gold,0)

      local reward_id = 0

      local id = dms.atoi(rewards_str_table[day],daily_welfare.id)
      local rewards_str = dms.string(dms["daily_welfare"],id,daily_welfare.reward_value)
      local rewards_table = zstring.split(rewards_str,"|")
      reward_id = id

      for i,v in ipairs(_ED.active_activity[42].seven_days_rewards[day].welfare) do
          if reward_id == tonumber(v.id) then
              if tonumber(v.state) == 1 then
                Image_gouhao:setVisible(true)
                Image_hui:setVisible(true)
              else
                Image_gouhao:setVisible(false)
                Image_hui:setVisible(false)
              end
          end
      end
    end
end
function SevenDaysEveryday:onEnterTransitionFinish()
end
function SevenDaysEveryday:onInit()
    local csbSevenDaysTower = csb.createNode("activity/7days/week_Activities_page_1.csb")
    self:addChild(csbSevenDaysTower)

    local root = csbSevenDaysTower:getChildByName("root")
    table.insert(self.roots, root)
    self:onUpdateDraw()
    self:drawPanelState()
end

function SevenDaysEveryday:onExit()
    state_machine.remove("seven_days_every_day_update_state")
    state_machine.remove("seven_days_every_day_selected")
end

function SevenDaysEveryday:init(dayIndex)
    self.dayIndex = dayIndex
    self:onInit()
end
