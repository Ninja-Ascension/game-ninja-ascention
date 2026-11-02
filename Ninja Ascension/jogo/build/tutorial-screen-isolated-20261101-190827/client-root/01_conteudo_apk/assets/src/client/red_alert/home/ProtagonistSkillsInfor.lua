-----------------------------
--浮动详细信息
-----------------------------
ProtagonistSkillsInfor = class("ProtagonistSkillsInforClass", Window)
ProtagonistSkillsInfor.__size = nil
local protagonist_skills_infor_window_open_terminal = {
    _name = "protagonist_skills_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ProtagonistSkillsInforClass") then
            local majesty_id = params[1]
            local pos = params[2]
            if majesty_id == nil or majesty_id == 0 then
                return
            end
            fwin:open(ProtagonistSkillsInfor:new():init(majesty_id,pos), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local protagonist_skills_infor_window_close_terminal = {
    _name = "protagonist_skills_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ProtagonistSkillsInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(protagonist_skills_infor_window_open_terminal)
state_machine.add(protagonist_skills_infor_window_close_terminal)
state_machine.init()

function ProtagonistSkillsInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.majesty_id = nil
end

function ProtagonistSkillsInfor:onUpdateDraw()
    local root = self.roots[1]
    local Text_skills_infor_name = ccui.Helper:seekWidgetByName(root,"Text_skills_infor_name")
    local Text_skills_infor = ccui.Helper:seekWidgetByName(root,"Text_skills_infor")
    local Text_skills_infor_stye = ccui.Helper:seekWidgetByName(root,"Text_skills_infor_stye")
    local Text_skills_infor_lv = ccui.Helper:seekWidgetByName(root,"Text_skills_infor_lv")

    local skill_name = dms.string(dms["majesty_skill"],self.majesty_id,majesty_skill.skill_name)
    local skill_type = dms.int(dms["majesty_skill"],self.majesty_id,majesty_skill.skill_type)
    local open_level = dms.int(dms["majesty_skill"],self.majesty_id,majesty_skill.open_level)
    local dec = dms.string(dms["majesty_skill"],self.majesty_id,majesty_skill.dec)
    local quality = dms.int(dms["majesty_skill"],self.majesty_id,majesty_skill.quality)
    Text_skills_infor_name:setString(skill_name)
    Text_skills_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_skills_infor_stye:setString(majesty_type_info[skill_type])
    Text_skills_infor_lv:setString(string.format(red_alert_all_str[91],open_level - 1))
    Text_skills_infor:setString(dec)
end

function ProtagonistSkillsInfor:onEnterTransitionFinish()

end

function ProtagonistSkillsInfor:onInit( )
    local csbItem = csb.createNode(config_csb.home.protagonist_skills_infor)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    if ProtagonistSkillsInfor.__size == nil then
        ProtagonistSkillsInfor.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_skills_infor_bg"), nil, 
    {
        terminal_name = "protagonist_skills_infor_window_close", 
        terminal_state = 0,  
    }, nil, 0)

	self:onUpdateDraw()	

end

function ProtagonistSkillsInfor:init(majesty_id,pos)
    self.majesty_id = majesty_id
	self:onInit()
    self:setContentSize(ProtagonistSkillsInfor.__size)
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x,(fwin._width - ProtagonistSkillsInfor.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y,(fwin._height - ProtagonistSkillsInfor.__size.height))
    self:setPosition(cc.p(x,y))
    return self
end

function ProtagonistSkillsInfor:onExit()

end
