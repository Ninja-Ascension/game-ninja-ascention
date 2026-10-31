--------------------------------------------------------------------------------------------------------------
--  说明：阵营招募帮助界面
--------------------------------------------------------------------------------------------------------------
HeroRecruitOfCamphelp = class("HeroRecruitOfCamphelpClass", Window)


local hero_recruit_of_camphelp_open_terminal = {
    _name = "hero_recruit_of_camphelp_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("hero_recruit_of_camphelp_open")
        local help_window = HeroRecruitOfCamphelp:new()
        help_window:init()
        fwin:open(help_window,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local hero_recruit_of_camphelp_close_terminal = {
    _name = "hero_recruit_of_camphelp_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitOfCamphelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_recruit_of_camphelp_open_terminal)
state_machine.add(hero_recruit_of_camphelp_close_terminal)
state_machine.init()
function HeroRecruitOfCamphelp:ctor()
	self.super:ctor()
	self.roots = {}
	
    self.camptexttimes = nil
	self.update_type = false
	 -- Initialize union duplicate seat machine.
    local function init_hero_recruit_of_camphelp_terminal()
		--阵营招募时间到了刷新充值  
        local hero_recruit_shop_updatecamphelp_terminal = {
            _name = "hero_recruit_shop_updatecamphelp",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("hero_recruit_shop_updatecamphelp")
                local function responseBountyInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil then
                            response.node:updateDraw(true)
                        end
                    else
                        state_machine.unlock("hero_recruit_shop_updatecamphelp")
                    end
                end
                    NetworkManager:register(protocol_command.partner_bounty_init.code, nil, nil, nil, instance, responseBountyInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_recruit_shop_updatecamphelp_terminal)
        state_machine.init()
    end
    -- call func init union duplicate seat machine.
    init_hero_recruit_of_camphelp_terminal()

end
function HeroRecruitOfCamphelp:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end
function HeroRecruitOfCamphelp:onUpdate()
    local camptime =tonumber(_ED.user_bounty_update_times)/1000 - os.time() - (tonumber(_ED.system_time)- tonumber(_ED.native_time))--神将刷新时间
    if self.lastupdatetime == camptime or self.camptexttimes == nil then--时间变化没有1秒，并且页面未加载完 也不进入刷新
        return
    end
    self.lastupdatetime = camptime
    if camptime <= 0 then
        --如果时间小于等于0刷新
        state_machine.excute("hero_recruit_shop_updatecamphelp",0,"")
        return
    end
    local strtime = HeroRecruitOfCamphelp:formatTimeString(camptime)
    self.camptexttimes:setString(strtime)
    if self.update_type == true then
        state_machine.unlock("hero_recruit_shop_updatecamphelp")
        self.update_type = false
    end
end
function HeroRecruitOfCamphelp:updateDraw(update_type)
    local root = self.roots[1]
    local typeID = tonumber(_ED.user_bounty_typeid)
	local Panel_2 = ccui.Helper:seekWidgetByName(root,"Panel_2")
    local Panel_3 = ccui.Helper:seekWidgetByName(root,"Panel_3")
    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4")
    local Panel_5 = ccui.Helper:seekWidgetByName(root,"Panel_5")
    local Panel_6 = ccui.Helper:seekWidgetByName(root,"Panel_6")

    local Text_3007 = ccui.Helper:seekWidgetByName(root,"Text_3007")
    local Text_3001 = ccui.Helper:seekWidgetByName(root,"Text_3001")
    local Text_3003 = ccui.Helper:seekWidgetByName(root,"Text_3003")
    local Text_3005 = ccui.Helper:seekWidgetByName(root,"Text_3005")
	
	local zhenying_wei = Panel_2:getChildByName("zhenying_wei")
	local zhenying_shu = Panel_2:getChildByName("zhenying_shu")
	local zhenying_wu = Panel_2:getChildByName("zhenying_wu")
	local zhenying_qun = Panel_2:getChildByName("zhenying_qun")
    Panel_3:setVisible(false)
    Panel_4:setVisible(false)
    Panel_5:setVisible(false)
    Panel_6:setVisible(false)
	zhenying_wei:setVisible(true)
	zhenying_shu:setVisible(true)
	zhenying_wu:setVisible(true)
	zhenying_qun:setVisible(true)
    if typeID == 1 then
        Panel_3:setVisible(true)
		zhenying_wei:setVisible(false)
        self.camptexttimes = Text_3007
    elseif typeID == 2 then
        Panel_4:setVisible(true)
		zhenying_shu:setVisible(false)
        self.camptexttimes = Text_3001
    elseif typeID == 3 then 
        Panel_5:setVisible(true)
		zhenying_wu:setVisible(false)
        self.camptexttimes = Text_3003
    elseif typeID == 4 then   
        Panel_6:setVisible(true)
		zhenying_qun:setVisible(false)		
        self.camptexttimes = Text_3005
    end
    if update_type == true then
        self.update_type = true
    end
    
end

function HeroRecruitOfCamphelp:onInit()
    
    local csbHeroRecruitOfCamphelp = csb.createNode("shop/zhaojiangpaiqi.csb") 
    local root = csbHeroRecruitOfCamphelp:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbHeroRecruitOfCamphelp)

    local action = csb.createTimeline("shop/zhaojiangpaiqi.csb")
    action:play("window_open", false)
    csbHeroRecruitOfCamphelp:runAction(action)

    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    fwin:addTouchEventListener(Panel_2, nil, 
    {
        terminal_name = "hero_recruit_of_camphelp_close", 
        terminal_state = 0,
    }, 
    nil, 0)
	self:updateDraw()
    state_machine.unlock("hero_recruit_of_camphelp_open")
end

function HeroRecruitOfCamphelp:onEnterTransitionFinish()

end

function HeroRecruitOfCamphelp:init()
	self:onInit()
	return self
end

function HeroRecruitOfCamphelp:onExit()
    state_machine.remove("hero_recruit_shop_updatecamphelp")
end