-----------------------------
-- 天赋 小详情界面
-----------------------------
HeroStarTalentInfor = class("HeroStarTalentInforClass", Window)

local hero_star_talent_infor_window_open_terminal = {
    _name = "hero_star_talent_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("HeroStarTalentInforClass") == nil then
            local talent_id = params[1]
            local pos = params[2]
            local ship_type = params[3]
            fwin:open(HeroStarTalentInfor:new():init(talent_id,pos,ship_type),fwin._ui)
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_star_talent_infor_window_close_terminal = {
    _name = "hero_star_talent_infor_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroStarTalentInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_star_talent_infor_window_open_terminal)
state_machine.add(hero_star_talent_infor_window_close_terminal)
state_machine.init()

function HeroStarTalentInfor:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --天赋ID
    self.talent_id = nil
    --英雄品质
    self._ship_type = nil
end

function HeroStarTalentInfor:onUpdateDraw()
    local root = self.roots[1]
    local data = dms.element(dms["talent_mould"],self.talent_id)
    local talent_name = dms.atos(data,talent_mould.talent_name)
    local talent_describe = dms.atos(data,talent_mould.talent_describe)
    local base_additional = dms.atos(data,talent_mould.base_additional)
    local talent_pic = dms.atoi(data,talent_mould.talent_pic)
    local talent_star_dec = dms.atos(data,talent_mould.talent_star_dec)
    local talent_star_quality = dms.atos(data,talent_mould.talent_star_quality)

    local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon")
    Panel_skills_icon:setBackGroundImage("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")

    local Text_skills_icon_infor_2 = ccui.Helper:seekWidgetByName(root,"Text_skills_icon_infor_2")
    Text_skills_icon_infor_2:setString(talent_star_dec)

    local Text_skills_icon_infor_types = ccui.Helper:seekWidgetByName(root,"Text_skills_icon_infor_types")
    Text_skills_icon_infor_types:setString(talent_name)
    Text_skills_icon_infor_types:setColor(cc.c3b(tipStringInfo_quality_color_Type[self._ship_type+1][1],tipStringInfo_quality_color_Type[self._ship_type+1][2],tipStringInfo_quality_color_Type[self._ship_type+1][3]))

    local Text_skills_icon_troops = ccui.Helper:seekWidgetByName(root,"Text_skills_icon_troops")
    Text_skills_icon_troops:setString(talent_describe)

    if self.pageindex == 2 then
        Text_skills_icon_infor_types:setColor(cc.c3b(tipStringInfo_quality_color_Type[talent_star_quality+1][1],tipStringInfo_quality_color_Type[talent_star_quality+1][2],tipStringInfo_quality_color_Type[talent_star_quality+1][3]))
        base_additional = zstring.split(base_additional,"|")
        for i,v in ipairs(base_additional) do
            local data = zstring.split(v,",")
            local types = tonumber(data[1]) + 1
            local adds = data[2]
            local Panel_skills_icon_infor_attributes = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon_infor_attributes_"..i)
            local text_dec = Panel_skills_icon_infor_attributes:getChildByName("Text_skills_icon_crit")
            local text_add_number = Panel_skills_icon_infor_attributes:getChildByName("Text_skills_icon_crit_v")
            text_dec:setString(red_alert_add[types])
            local is_handred = false
            for j,k in pairs(attribute_hundred) do
                if types - 1 == k then
                    is_handred = true
                end
            end
            if is_handred == true then
                text_add_number:setString(adds.."%")
            else
                text_add_number:setString(adds)
            end
        end
        -- if #base_additional < 5 then
        --     local Panel_skills_icon_infor_attributes_5 = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon_infor_attributes_5")
        --     Panel_skills_icon_infor_attributes_5:setVisible(false)
        -- end
        local Panel_skills_icon_infor_attributes_5 = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon_infor_attributes_5")
        local Panel_skills_icon_infor_attributes_6 = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon_infor_attributes_6")
        Panel_skills_icon_infor_attributes_5:setVisible(false)
        Panel_skills_icon_infor_attributes_6:setVisible(false)
    end
end

function HeroStarTalentInfor:onEnterTransitionFinish()

end

function HeroStarTalentInfor:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.packs.herostorage.hero_star_talent_infor,self.pageindex))
	local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
        -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_props_infor"), nil, 
    {
        terminal_name = "hero_star_talent_infor_window_close", 
        terminal_state = 0, 
    }, nil, 0)
	self:onUpdateDraw()	
end

function HeroStarTalentInfor:getPageIndex()
    local base_additional = dms.string(dms["talent_mould"],self.talent_id,talent_mould.base_additional)
    if base_additional == "-1" then
        self.pageindex = 1
    else
        self.pageindex = 2
    end
end

function HeroStarTalentInfor:init(talent_id,pos,ship_type)
    self.talent_id = talent_id
    self._ship_type = ship_type
    self:getPageIndex()
	self:onInit()
    local width = self.roots[1]:getContentSize().width
    local height = self.roots[1]:getContentSize().height/2
    local x = pos.x/ app.scaleFactor
    local y = pos.y/ app.scaleFactor
    self:setPosition(cc.p(x-width,y-height))
    return self
end

function HeroStarTalentInfor:onExit()

end
