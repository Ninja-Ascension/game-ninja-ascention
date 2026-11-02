-- ----------------------------------------------------------------------------------------------------
-- 说明：潜能技能信息
-------------------------------------------------------------------------------------------------------
QianNengSkillDescription = class("QianNengSkillDescriptionClass", Window)

local qianNengSkillDescription_open_terminal = {
    _name = "qianNengSkillDescription_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("QianNengSkillDescriptionClass")
        if nil == _homeWindow then
            local panel = QianNengSkillDescription:new():init(params)
            fwin:open(panel, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local qianNengSkillDescription_close_terminal = {
    _name = "qianNengSkillDescription_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("QianNengSkillDescriptionClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("QianNengSkillDescriptionClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(qianNengSkillDescription_open_terminal)
state_machine.add(qianNengSkillDescription_close_terminal)
state_machine.init()
    
function QianNengSkillDescription:ctor()
    self.roots = {}
end

function QianNengSkillDescription:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local config = dms.element(dms["potential_attribute"], tonumber(self.index), true)
    local pic = config[2]
    local name = config[3]
    local content = config[4]
    local property = config[5]
    local propertyArr = zstring.split(property, "|")
    -- debug.print_r(config, "QianNengSkillDescription")

    local strContent = dms.string(dms["word_mould"], content, 3)
    local strName = dms.string(dms["word_mould"], name, 3)

    local Text_dh_lv_n = ccui.Helper:seekWidgetByName(root, "Text_dh_lv_n")
    Text_dh_lv_n:setString(self.skillGrade)
    local Text_up_star_add_info = ccui.Helper:seekWidgetByName(root, "Text_up_star_add_info")
    Text_up_star_add_info:setString(strContent)
    local Text_up_star_add_name = ccui.Helper:seekWidgetByName(root, "Text_up_star_add_name")
    Text_up_star_add_name:setString(strName)
    local Image_skill_icon_bg = ccui.Helper:seekWidgetByName(root, "Image_skill_icon_bg")
    local head = ccui.ImageView:create("images/ui/skills/skills_" .. pic .. ".png")
    head:setPosition(cc.p(Image_skill_icon_bg:getContentSize().width / 2, Image_skill_icon_bg:getContentSize().height / 2))
    Image_skill_icon_bg:addChild(head)

    for i = 1, #propertyArr do
        local Text_up_star_add_sx = ccui.Helper:seekWidgetByName(root, "Text_up_star_add_sx_" .. i)
        local property = propertyArr[i]
        local v = zstring.split(property, ",")

        local str = tipStringInfo_trialTower_attribute_info[v[1] + 1]
        local name = str[1]
        local per = ""
        if str[3] then
            per = "%"
        end
        Text_up_star_add_sx:setString(name .. "+" .. v[2] * self.skillGrade .. per)

    end

end

function QianNengSkillDescription:init(params)
    self.skillGrade = params[1]
    self.index = params[2]
    self:onInit()
    return self
end

function QianNengSkillDescription:onInit()
    local node = csb.createNode("packs/HeroStorage/sm_generals_up_star_add_infor.csb")
    local root = node:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(node)
	
    self:onUpdateDraw()

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_up_star_add_closed"), nil, 
    {
        terminal_name = "qianNengSkillDescription_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bg"), nil, 
    {
        terminal_name = "qianNengSkillDescription_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_5_bg"), nil, 
    {
        terminal_name = "qianNengSkillDescription_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)
	
end

function QianNengSkillDescription:onExit()
    
end