--------------------------------------------------------------------------------------------------------------
--  说明：主公科技控件
--------------------------------------------------------------------------------------------------------------
ProtagonistSkillsCell = class("ProtagonistSkillsCellClass", Window)
ProtagonistSkillsCell.__size = nil
--创建cell
local protagonist_skills_create_cell_terminal = {
    _name = "protagonist_skills_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local majesty_skill_id = params[1]
        local cell = ProtagonistSkillsCell:new()
        cell:init(majesty_skill_id)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(protagonist_skills_create_cell_terminal)
state_machine.init()

function ProtagonistSkillsCell:ctor()
	self.super:ctor()
	self.roots = {}
	
  --var
	 -- Initialize protagonist_skills_cell state machine.
    local function init_protagonist_skills_cell_terminal()
		
  --       -- 刷新等级
  --       local home_build_cell_update_level_terminal = {
  --           _name = "home_build_cell_update_level",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params) 
  --               local cell = params
  --               if cell ~= nil and cell.updateDrawLevel ~= nil then
  --                   cell:updateDrawLevel()
  --               end
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       } 
        
		-- state_machine.add(home_build_cell_open_window_terminal)
  --       state_machine.init()
    end
    
    -- call func home_build_cell create state machine.
    init_protagonist_skills_cell_terminal()

end

function ProtagonistSkillsCell:updateDraw()
    local root = self.roots[1]
    local Panel_protagonist_skills_cell_icon = ccui.Helper:seekWidgetByName(root,"Panel_protagonist_skills_cell_icon")--技能图片
    local Image_protagonist_skills_on = ccui.Helper:seekWidgetByName(root,"Image_protagonist_skills_on")--出战
    local Image_protagonist_skills_hook = ccui.Helper:seekWidgetByName(root,"Image_protagonist_skills_hook")--出战 
    local Text_protagonist_skills_name = ccui.Helper:seekWidgetByName(root,"Text_protagonist_skills_name") -- 技能名
    local Tex_protagonist_skills_open_lv = ccui.Helper:seekWidgetByName(root,"Tex_protagonist_skills_open_lv") -- 主公殿等级
    local Text_protagonist_skills_types = ccui.Helper:seekWidgetByName(root,"Text_protagonist_skills_types") -- 类型
-- -- 主公技  
-- majesty_skill = {
--     id = 1,                 --int(11)   Notnull 主键，自增长
--     skill_name = 2 ,        --String        技能名称
--     skill_type = 3 ,        --int(11)       技能类型
--     skill_pic = 4,          --int(11)       图片id
--     open_level = 5,         --int --开启等级（主公殿）
--     to_Skill_id = 6,        -- int 索引到技能表
--     quality = 7,            -- int 品质
-- }   
    if self:isWear() == true then
        Image_protagonist_skills_on:setVisible(true)
        Image_protagonist_skills_hook:setVisible(true)
    else
        Image_protagonist_skills_on:setVisible(false)
        Image_protagonist_skills_hook:setVisible(false)
    end
    
    local home_city_level = tonumber(_ED.home_build["1"].level)

    local skill_name = dms.string(dms["majesty_skill"],self.majesty_skill_id,majesty_skill.skill_name)
    Text_protagonist_skills_name:setString(skill_name)
    local skill_type = dms.int(dms["majesty_skill"],self.majesty_skill_id,majesty_skill.skill_type)
    Text_protagonist_skills_types:setString(majesty_type_info[skill_type])
    local skill_pic = dms.int(dms["majesty_skill"],self.majesty_skill_id,majesty_skill.skill_pic)
    
    local Sprite_skill_icon = Panel_protagonist_skills_cell_icon:getChildByName("Sprite_skill_icon")
    Sprite_skill_icon:setTexture("images/ui/role_skills/protagonist_skills/protagonist_skills_".. skill_pic .. ".png")
    local open_level = dms.int(dms["majesty_skill"],self.majesty_skill_id,majesty_skill.open_level)
    if home_city_level < open_level then
        Tex_protagonist_skills_open_lv:setVisible(true)
        Tex_protagonist_skills_open_lv:setString(string.format(red_alert_all_str[91],open_level - 1))   
        display:gray(Sprite_skill_icon)
    else
        Tex_protagonist_skills_open_lv:setVisible(false)
        display:ungray(Sprite_skill_icon)
    end
    
    local quality = dms.int(dms["majesty_skill"],self.majesty_skill_id,majesty_skill.quality)
    Text_protagonist_skills_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    local Image_new = ccui.Helper:seekWidgetByName(root,"Image_new")--新技能
    Image_new:setVisible(false)
    if home_city_level == open_level and _ED.majesty_push_state == true then
        Image_new:setVisible(true)
        _ED.majesty_push_state =false
    end
    
end

function ProtagonistSkillsCell:isWear()
    for i,v in pairs(_ED.majesty_info) do
        if self.majesty_skill_id == tonumber(v) then
            return true
        end
    end
    return false
end

function ProtagonistSkillsCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.home.protagonist_skills_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root) 
    table.insert(self.roots, root) 

    if ProtagonistSkillsCell.__size == nil then
       ProtagonistSkillsCell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_home_build"), nil, 
    {
        terminal_name = "home_build_cell_open_window", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95,        
    }, nil, 0) 
	self:updateDraw()

end

function ProtagonistSkillsCell:onEnterTransitionFinish()

end

function ProtagonistSkillsCell:init(majesty_skill_id)
    self.majesty_skill_id = majesty_skill_id
	  self:onInit()
    self:setContentSize(ProtagonistSkillsCell.__size)
end

function ProtagonistSkillsCell:onExit()

end