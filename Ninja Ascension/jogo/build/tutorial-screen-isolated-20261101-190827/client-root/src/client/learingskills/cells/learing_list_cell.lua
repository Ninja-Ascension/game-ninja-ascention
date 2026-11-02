-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间 2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
LearingListCell = class("LearingListCellClass", Window)
LearingListCell.__size = nil
function LearingListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.data = {}

    self.ship_data = nil
    self.skill_data = nil
    self.state = nil
    self.favor = nil
    local function init_learing_list_cell_terminal() 
        state_machine.init()
    end
    
   -- call func init hom state machine.
   init_learing_list_cell_terminal()
end



function LearingListCell:onEnterTransitionFinish()

end

function LearingListCell:onInit()
    local root = cacher.createUIRef("skills/skills_list_xx_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LearingListCell.__size == nil then
        LearingListCell.__size = root:getContentSize()
    end
    local Button_tishengqinmidu = ccui.Helper:seekWidgetByName(root,"Button_tishengqinmidu") --按钮 提升亲密度
    fwin:addTouchEventListener(Button_tishengqinmidu,nil, 
    {
        terminal_name = "learing_skills_favor_open", 
        terminal_state = 0,
        data = self.data,
        isPressedActionEnabled = true
    }
    ,nil, 0)
    self:initDraw()
end


function LearingListCell:initDraw()
    local root = self.roots[1]
    local ship_data = self.ship_data
    local skill_data = self.skill_data
    local state = self.state
    local favor = self.favor
    local skill_id = dms.atoi(skill_data,skill_equipment_mould.skill_equipment_base_mould)
    local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)
    local Panel_2 = ccui.Helper:seekWidgetByName(root,"Panel_2") --头像
    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") --头像品质框 
    local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon") --头像品质框 
    local Text_skills_name_1 = ccui.Helper:seekWidgetByName(root,"Text_skills_name_1")--技能名字
    local Text_skills_ms = ccui.Helper:seekWidgetByName(root,"Text_skills_ms")--技能描述
    local Text_qinmidu_nub = ccui.Helper:seekWidgetByName(root,"Text_qinmidu_nub") --亲密度值
    local Text_qinmidu = ccui.Helper:seekWidgetByName(root,"Text_qinmidu") --亲密度前缀
    local Text_teacher_name = ccui.Helper:seekWidgetByName(root,"Text_teacher_name") --导师名

    local picIndex = dms.atoi(ship_data, ship_mould.head_icon) --头像索引
    local quality = dms.atoi(ship_data, ship_mould.ship_type) + 1 --品质索引
    local skills_picIndex = dms.atoi(skill_data, skill_equipment_mould.pic) --技能图片索引
    local skill_name_str = dms.string(dms["skill_mould"],skill_id,skill_mould.skill_name) --技能名
    local skill_describe = dms.string(dms["skill_mould"],skill_id,skill_mould.skill_describe) --技能描述
    local skill_name = zstring.split(skill_name_str,"L")
    local hero_name = dms.atos(ship_data, ship_mould.captain_name) --英雄名字
    Text_skills_name_1:setString("")
    Text_skills_name_1:setString(skill_name[1])
    Text_skills_ms:setString("")
    Text_skills_ms:setString(skill_describe)
    Text_qinmidu_nub:setString("0%")
    local per = math.floor(favor/favor_top*100)
    if per > 100 then
        per = 100
    end
    Text_qinmidu_nub:setString(per.. "%")
    Text_teacher_name:setString("")
    Text_teacher_name:setString(hero_name)
    Text_teacher_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
    
    Panel_2:removeBackGroundImage()
    Panel_2:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    Panel_kuang:removeBackGroundImage()
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
        Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
    else
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
        else
            Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
        end
    end

    Panel_skills_icon:removeBackGroundImage()
    Panel_skills_icon:setBackGroundImage(string.format("images/ui/skills_props/skills_props_%s.png", skills_picIndex)) 

    local Button_tishengqinmidu = ccui.Helper:seekWidgetByName(root,"Button_tishengqinmidu") --按钮 提升亲密度
    local Image_shiyong_skills = ccui.Helper:seekWidgetByName(root,"Image_shiyong_skills") --已学习显示
    local Text_no_get = ccui.Helper:seekWidgetByName(root,"Text_no_get") --英雄未获得
    Button_tishengqinmidu:setVisible(false)
    Image_shiyong_skills:setVisible(false)
    Text_no_get:setVisible(false)
    Text_qinmidu_nub:setVisible(false)
    Text_qinmidu:setVisible(false)
    --0 可学习、1未获得 2已习得
    if state == 1 then
        Text_no_get:setVisible(true)
    elseif state == 2 then
        Button_tishengqinmidu:setVisible(true)
        Text_qinmidu_nub:setVisible(true)
        Text_qinmidu:setVisible(true)
    end
    if state == 0 or per == 100 then
        Image_shiyong_skills:setVisible(true)
        Text_qinmidu_nub:setVisible(false)
        Text_qinmidu:setVisible(false)
        Button_tishengqinmidu:setVisible(false)
    end
end

function LearingListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LearingListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef("skills/skills_list_xx_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function LearingListCell:init(data,index)
    self.data = data
    self.ship_data = data.ship_data
    self.skill_data = data.skill_data
    self.state = data.state
    self.favor = data.favor
    if index ~= nil and index < 3 then
        self:onInit()
    end
    self:setContentSize(LearingListCell.__size)
    return self
end

function LearingListCell:createCell()
    local cell = LearingListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end


function LearingListCell:onExit()
    cacher.freeRef("skills/skills_list_xx_list.csb", self.roots[1])
end

