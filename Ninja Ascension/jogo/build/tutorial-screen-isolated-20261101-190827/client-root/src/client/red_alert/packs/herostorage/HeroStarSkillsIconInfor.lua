-----------------------------
--星格 小详情界面
-----------------------------
HeroStarSkillsIconInfor = class("HeroStarSkillsIconInforClass", Window)
HeroStarSkillsIconInfor.__size = nil
local hero_star_skills_icon_infor_window_open_terminal = {
    _name = "hero_star_skills_icon_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("HeroStarSkillsIconInforClass") == nil then
            local star_mould_id = params[1]
            local pos = params[2]
            fwin:open(HeroStarSkillsIconInfor:new():init(star_mould_id,pos),fwin._ui)
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
local hero_star_skills_icon_infor_window_close_terminal = {
    _name = "hero_star_skills_icon_infor_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroStarSkillsIconInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_star_skills_icon_infor_window_open_terminal)
state_machine.add(hero_star_skills_icon_infor_window_close_terminal)
state_machine.init()

function HeroStarSkillsIconInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.star_mould_id = nil
end

function HeroStarSkillsIconInfor:onUpdateDraw()
    local root = self.roots[1]
    local Text_skills_icon_infor_types = ccui.Helper:seekWidgetByName(root,"Text_skills_icon_infor_types")
    Text_skills_icon_infor_types:setVisible(false)
    local Text_skills_icon_infor_2 = ccui.Helper:seekWidgetByName(root,"Text_skills_icon_infor_2")
    local star_name = dms.string(dms["star_mould"],self.star_mould_id,star_mould.star_name)             --名称
    local star_quality = dms.int(dms["star_mould"],self.star_mould_id,star_mould.star_quality)       --品质
    Text_skills_icon_infor_2:setString(star_name)
    Text_skills_icon_infor_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[star_quality+1][1],tipStringInfo_quality_color_Type[star_quality+1][2],tipStringInfo_quality_color_Type[star_quality+1][3]))
    local Panel_skills_icon_cell = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon_cell")
    state_machine.excute("hero_star_skills_icon_infor_property_window_open",0,{Panel_skills_icon_cell,self.star_mould_id})
    local property = dms.string(dms["star_mould"],self.star_mould_id,star_mould.property)
    property = zstring.split(property,"|")
    local add_numbers = #property
    local row = 0
    if add_numbers % 2 == 0 then
        row = add_numbers / 2 
    else
        row = add_numbers / 2 + 1
    end
    local Image_skills_icon_infor_1 = ccui.Helper:seekWidgetByName(root,"Image_skills_icon_infor_1")
    Image_skills_icon_infor_1:setContentSize(cc.size(Image_skills_icon_infor_1:getContentSize().width,Image_skills_icon_infor_1:getContentSize().height + (row -1)*24))
end

function HeroStarSkillsIconInfor:onEnterTransitionFinish()

end

function HeroStarSkillsIconInfor:onInit( )
    local csbItem = csb.createNode(config_csb.packs.herostorage.hero_star_skills_icon_infor)
    
	local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)

    if HeroStarSkillsIconInfor.__size == nil then
        HeroStarSkillsIconInfor.__size = root:getContentSize()
    end
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_props_infor"), nil, 
    {
        terminal_name = "hero_star_skills_icon_infor_window_close", 
        terminal_state = 0, 
    }, nil, 0)

	self:onUpdateDraw()	
end

function HeroStarSkillsIconInfor:init(star_mould_id,pos)
    self.star_mould_id = star_mould_id
	self:onInit()
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x - HeroStarSkillsIconInfor.__size.width ,(fwin._width - HeroStarSkillsIconInfor.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y - HeroStarSkillsIconInfor.__size.height/2,(fwin._height - HeroStarSkillsIconInfor.__size.height))
    self:setPosition(cc.p(x,y))
    return self
end

function HeroStarSkillsIconInfor:onExit()

end
