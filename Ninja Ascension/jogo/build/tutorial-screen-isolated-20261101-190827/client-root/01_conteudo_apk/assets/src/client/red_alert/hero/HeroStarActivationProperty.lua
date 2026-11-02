-----------------------------
--星格属性
-----------------------------
HeroStarActivationProperty = class("HeroStarActivationPropertyClass", Window)
local hero_star_activation_property_window_open_terminal = {
    _name = "hero_star_activation_property_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("HeroStarActivationPropertyClass") == nil then
            fwin:open(HeroStarActivationProperty:new():init(params),fwin._ui)
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_star_activation_property_window_open_terminal)
state_machine.init()

function HeroStarActivationProperty:ctor()
    self.super:ctor()
    self.roots = {}
    self.star_mould_id = nil
	self.is_talent = false
end

function HeroStarActivationProperty:onUpdateDraw()
    local root = self.roots[1]
    local property = nil
	if self.is_talent == true then
		property = dms.string(dms["talent_mould"],self.star_mould_id,talent_mould.base_additional)
	else
		property = dms.string(dms["star_mould"],self.star_mould_id,star_mould.property)
	end
    if property == "-1" then
        return
    end
    property = zstring.split(property,"|")
    local Panel_property = ccui.Helper:seekWidgetByName(root,"Panel_property")
    -- debug.print_r(property)
    Panel_property:removeAllChildren(true)
    local add_numbers = #property
    local row = 0
    if add_numbers % 2 == 0 then
        row = math.floor(add_numbers / 2 )
    else
        row = math.floor(add_numbers / 2 + 1)
    end
    Panel_property:setContentSize(cc.size(Panel_property:getContentSize().width,row*24))

    local width = Panel_property:getContentSize().width
    local height = Panel_property:getContentSize().height   
    for i,v in ipairs(property) do
        local data = zstring.split(v,",")
        local types = tonumber(data[1]) +1
        local adds = data[2]

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
         local re1 = ccui.RichElementText:create(1,cc.c3b(hero_star_color_Type[1][1],hero_star_color_Type[1][2],hero_star_color_Type[1][3]),255, red_alert_add[types].."    ", "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
         local re2 = ccui.RichElementText:create(1,cc.c3b(hero_star_color_Type[2][1],hero_star_color_Type[2][2],hero_star_color_Type[2][3]) ,255, "+"..adds ,"fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
            
        _richText:setContentSize(cc.size(Panel_property:getContentSize().width/2,24))
        local rows = 0
        if i % 2 == 0 then
            rows = math.floor(i / 2 )
        else
            rows = math.floor(i / 2 + 1)
        end 
        if i % 2 == 0  then
            _richText:setPosition(cc.p(width/2,height - 24*(rows-1)))
        else
            _richText:setPosition(cc.p(0,height - 24*(rows-1)))
        end
        _richText:setAnchorPoint(cc.p(0, 0))

        Panel_property:addChild(_richText)
    end
    Panel_property:setPosition(cc.p(0 - Panel_property:getContentSize().width/4,self.parent_height - 24))
end

function HeroStarActivationProperty:onEnterTransitionFinish()

end

function HeroStarActivationProperty:onInit( )
    local csbItem = csb.createNode(config_csb.packs.herostorage.hero_star_skills_infor_property)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    self:onUpdateDraw() 
end

function HeroStarActivationProperty:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.star_mould_id = params[2]  
	if params[3] == nil or params[3] == "" then
		self.is_talent = false
	else
		self.is_talent = params[3] 
	end
	
    self.parent_height  = rootWindow:getContentSize().height
    self:onInit()
    return self
end

function HeroStarActivationProperty:onExit()

end
