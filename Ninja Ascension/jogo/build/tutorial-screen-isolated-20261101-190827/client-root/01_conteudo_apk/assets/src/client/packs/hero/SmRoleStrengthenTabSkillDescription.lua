-- ----------------------------------------------------------------------------------------------------
-- 说明：技能详细信息
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabSkillDescription = class("SmRoleStrengthenTabSkillDescriptionClass", Window)

local sm_role_strengthen_tab_skill_description_open_terminal = {
    _name = "sm_role_strengthen_tab_skill_description_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSkillDescriptionClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabSkillDescription:new():init(params)
            fwin:open(panel,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_skill_description_close_terminal = {
    _name = "sm_role_strengthen_tab_skill_description_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSkillDescriptionClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabSkillDescriptionClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_skill_description_open_terminal)
state_machine.add(sm_role_strengthen_tab_skill_description_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabSkillDescription:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0

    local function init_sm_role_strengthen_tab_skill_description_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_skill_description_display_terminal = {
            _name = "sm_role_strengthen_tab_skill_description_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSkillDescriptionWindow = fwin:find("SmRoleStrengthenTabSkillDescriptionClass")
                if SmRoleStrengthenTabSkillDescriptionWindow ~= nil then
                    SmRoleStrengthenTabSkillDescriptionWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_skill_description_hide_terminal = {
            _name = "sm_role_strengthen_tab_skill_description_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSkillDescriptionWindow = fwin:find("SmRoleStrengthenTabSkillDescriptionClass")
                if SmRoleStrengthenTabSkillDescriptionWindow ~= nil then
                    SmRoleStrengthenTabSkillDescriptionWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_skill_description_display_terminal)
        state_machine.add(sm_role_strengthen_tab_skill_description_hide_terminal)

        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_skill_description_terminal()
end

function SmRoleStrengthenTabSkillDescription:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    --技能解锁的需求
    local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
    local demands = zstring.split(demandInfo, ",")

    --图标
    local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")
    Panel_skill_icon:removeBackGroundImage()
    local skill_icon = nil
    local pic_index = dms.int(dms["talent_mould"], self.skill_mould_id, talent_mould.new_skill_pic)
    skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
    --测试临时的图,正式的时候换成上面的代码
    --skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", self.m_index))
    if skill_icon ~= nil then
        skill_icon:setPosition(cc.p(Panel_skill_icon:getContentSize().width/2,Panel_skill_icon:getContentSize().height/2))
        Panel_skill_icon:addChild(skill_icon)
    end
    --名称
    local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")
    local skillNameId = dms.string(dms["talent_mould"], self.skill_mould_id, talent_mould.talent_name)
    local word_info = dms.element(dms["word_mould"], skillNameId)
    local skillName = word_info[3]
    --这里
    if not self.ismega then -- 超进化预览处传进
        skillName = skillDescriptionReplaceData(self.skill_mould_id,tonumber(self.ship.ship_template_id),self.m_index,1,false)
    end
  
    Text_skill_name:setString(skillName)

    --技能类型
    local Text_skill_type_n = ccui.Helper:seekWidgetByName(root, "Text_skill_type_n")
    local skill_quality = dms.int(dms["talent_mould"], self.skill_mould_id, talent_mould.skill_types)
    Text_skill_type_n:setString(skill_quality_text[skill_quality])

    --技能等级
    local Text_skill_lv_n = ccui.Helper:seekWidgetByName(root, "Text_skill_lv_n")
    local skillAllLevel = zstring.split(self.ship.skillLevel, ",")
    Text_skill_lv_n:setString(skillAllLevel[self.m_index])

    --技能锁
    local Image_locking_1 = ccui.Helper:seekWidgetByName(root, "Image_locking_1")
    if tonumber(self.ship.StarRating) >= tonumber(demands[self.m_index]) then
        -- display:ungray(skill_icon)
        Image_locking_1:setVisible(false)
    else
        -- display:gray(skill_icon)
        Image_locking_1:setVisible(true)
    end

    --描述
    local Text_skill_info_1 = ccui.Helper:seekWidgetByName(root, "Text_skill_info_1")
    local skill_describe_id = dms.string(dms["talent_mould"], self.skill_mould_id, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], skill_describe_id)
    local skill_describe = word_info[3]
          skill_describe = skillDescriptionReplaceData(self.skill_mould_id,tonumber(self.ship.ship_template_id),self.m_index,2,false,nil,self.ismega)
 
    Text_skill_info_1:setString(skill_describe)

    -- local Image_skill_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_skill_bg_2")
    -- local Image_skill_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_skill_bg_1")
    -- local textRenderSize = Text_skill_info_1:getAutoRenderSize() -- 未换行前尺寸
    -- local VirtualRendererSize = Text_skill_info_1:getVirtualRendererSize() -- 控件本身可渲染尺寸
    -- local needRowNumber = math.ceil(textRenderSize.width / VirtualRendererSize.width)
    -- local currRowNumber = math.floor(VirtualRendererSize.height / textRenderSize.height)
    -- local curHeight = 0
    -- -- if needRowNumber > currRowNumber then
    --     curHeight = (needRowNumber - currRowNumber) * textRenderSize.height + Text_skill_info_1:getFontSize() + 10
    --     Text_skill_info_1:setContentSize(cc.size(Text_skill_info_1:getContentSize().width , Text_skill_info_1:getContentSize().height + curHeight))
    --     Image_skill_bg_2:setContentSize(cc.size(Image_skill_bg_2:getContentSize().width , Image_skill_bg_2:getContentSize().height + curHeight))
    --     Image_skill_bg_1:setContentSize(cc.size(Image_skill_bg_1:getContentSize().width , Image_skill_bg_1:getContentSize().height + curHeight))
    --     root:setPosition(cc.p(root:getPositionX() , root:getPositionY() + curHeight/2))
    --     ccui.Helper:seekWidgetByName(root, "Image_5_bg"):setPositionY(ccui.Helper:seekWidgetByName(root, "Image_5_bg"):getPositionY()-curHeight/2)
    -- -- end

end

function SmRoleStrengthenTabSkillDescription:init(params)
    self.ship = params[1]
    self.skill_mould_id = params[2]
    self.m_index = tonumber(params[3])
    self.ismega = params[4]
    self:onInit()
    return self
end

function SmRoleStrengthenTabSkillDescription:onInit()
    local csbSmRoleStrengthenTabSkillDescription = csb.createNode("packs/HeroStorage/sm_skill_info.csb")
    local root = csbSmRoleStrengthenTabSkillDescription:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabSkillDescription)
	
    self:onUpdateDraw()

    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_closed"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_skill_description_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_bg"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_skill_description_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)
	
end

function SmRoleStrengthenTabSkillDescription:onExit()
    state_machine.remove("sm_role_strengthen_tab_skill_description_display")
    state_machine.remove("sm_role_strengthen_tab_skill_description_hide")
end