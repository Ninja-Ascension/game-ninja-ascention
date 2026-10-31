-- 兵符升星页面

WeaponBookUpSkill = class("WeaponBookUpSkillClass", Window)
--打开
local weapon_book_up_skill_window_open_terminal = {
    _name = "weapon_book_up_skill_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _WeaponBookUpSkillWindow = fwin:find("WeaponBookUpSkillClass")
        if nil == _WeaponBookUpSkillWindow then
            fwin:open(WeaponBookUpSkill:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local weapon_book_up_skill_window_close_terminal = {
    _name = "weapon_book_up_skill_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookUpSkillClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_up_skill_window_open_terminal)
state_machine.add(weapon_book_up_skill_window_close_terminal)
state_machine.init()

function WeaponBookUpSkill:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._ship = nil

    local function init_weapon_book_up_skill_terminal()
        -- 升星
        local weapon_book_up_skill_up_terminal = {
            _name = "weapon_book_up_skill_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("rising star up")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新属性
        local weapon_book_up_skill_update_draw_terminal = {
            _name = "weapon_book_up_skill_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭界面
        local weapon_book_up_skill_close_terminal = {
            _name = "weapon_book_up_skill_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(weapon_book_up_skill_up_terminal)
        state_machine.add(weapon_book_up_skill_update_draw_terminal)
        state_machine.add(weapon_book_up_skill_close_terminal)   
        state_machine.init()
    end
    init_weapon_book_up_skill_terminal()
end 

function WeaponBookUpSkill:onUpdateDraw( ... )
    local root = self.roots[1]
    local Panel_hero_star_activation_icon = ccui.Helper:seekWidgetByName(root, "Panel_hero_star_activation_icon")   --兵符图像
    local Text_hero_star_activation_name = ccui.Helper:seekWidgetByName(root, "Text_hero_star_activation_name")     --兵符名称
    local Text_hero_talent_activation = ccui.Helper:seekWidgetByName(root, "Text_hero_talent_activation")           --兵符升星属性加成说明
    local Panel_hero_star_material = ccui.Helper:seekWidgetByName(root, "Panel_hero_star_material")                 --升级需要材料图像
    local Text_hero_star_material_number = ccui.Helper:seekWidgetByName(root, "Text_hero_star_material_number")     --升级需要材料数量
    local Text_hero_star_gold_have = ccui.Helper:seekWidgetByName(root, "Text_hero_star_gold_have")                 --当前拥有的材料数量
    local Text_hero_star_activation_no = ccui.Helper:seekWidgetByName(root, "Text_hero_star_activation_no")         --升至当前星数满级
    local Button = ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_back")

    Panel_hero_star_activation_icon:removeBackGroundImage()
    Text_hero_star_activation_name:setString("")
    Text_hero_talent_activation:setString("")
    Panel_hero_star_material:removeBackGroundImage()
    Text_hero_star_material_number:setString("")
    Text_hero_star_gold_have:setString("")
    Text_hero_star_activation_no:setVisible(false)
    Button:setVisible(false)

    local weapon_data = dms.element(dms["equipment_mould"], self._weapon_book.user_equiment_template)
    local quality = self._weapon_book.quality
    local talent_mould_id = dms.atoi(weapon_data, equipment_mould.equipment_talent_ids)         -- 装备天赋id
    local awaken_equipment_id = dms.atoi(weapon_data, equipment_mould.equipment_talent_ids)     -- 升星后装备id
    local awaken_need_resource = dms.atoi(weapon_data, equipment_mould.equipment_talent_ids)    -- 升星消耗

    -- 兵符名称
    Text_hero_star_activation_name:setString(self._weapon_book.user_equiment_name)
    Text_hero_star_activation_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    -- 兵符图像
    Panel_hero_star_activation_icon:setBackGroundImage(string.format("images/ui/equip/equip_%d.png", self._weapon_book.icon))
    -- 兵符星数

    -- 兵符属性

    -- 消耗材料

    -- 判断升星条件
    local isCanUpgrade = true
    -- local att_info = zstring.split(dms.string(dms["equipment_mould"], 1, equipment_mould.weapon_book_attr_ids), ",")
    -- for k,v in pairs(att_info) do
    --     if dms.int(dms["lead_mould"], v, lead_mould.is_opend) == 1 then
    --         local current_level = 1
    --         if current_level < dms.int(dms["lead_mould"], lead_mould.mould_id, lead_mould.max_level)
    --             isCanUpgrade = false
    --         end
    --     end
    -- end
    if isCanUpgrade == true then
        Button:setVisible(true)
    else

    end
end

-- 关闭窗口动画
function WeaponBookUpSkill:onWindowClose( )
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("weapon_book_up_skill_window_close", 0, "")
        end
    end)
end

function WeaponBookUpSkill:onInit( )
    local csbItem = csb.createNode(config_csb.weapon_book.weapon_book_up_skill)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.weapon_book.weapon_book_up_skill)
    table.insert(self.actions, action)
    action:play("window_open", false)
    csbItem:runAction(action)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_close"), nil, 
    {
        terminal_name = "weapon_book_up_skill_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_back"), nil, 
    {
        terminal_name = "weapon_book_up_skill_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function WeaponBookUpSkill:init(weapon_book)
    self._weapon_book = weapon_book
    self:onInit()
    return self
end

function WeaponBookUpSkill:onExit()
    state_machine.remove("weapon_book_up_skill_up")
    state_machine.remove("wweapon_book_up_skill_update_draw")
    state_machine.remove("weapon_book_up_skill_close")
end