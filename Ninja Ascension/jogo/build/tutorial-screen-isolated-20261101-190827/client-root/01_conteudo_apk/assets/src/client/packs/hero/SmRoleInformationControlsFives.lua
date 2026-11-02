-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面控件5
-------------------------------------------------------------------------------------------------------
SmRoleInformationControlsFives = class("SmRoleInformationControlsFivesClass", Window)
SmRoleInformationControlsFives.__size = nil

local sm_role_information_controls_fives_open_terminal = {
    _name = "sm_role_information_controls_fives_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local cell = SmRoleInformationControlsFives:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_controls_fives_close_terminal = {
    _name = "sm_role_information_controls_fives_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationControlsFivesClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationControlsFivesClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_controls_fives_open_terminal)
state_machine.add(sm_role_information_controls_fives_close_terminal)
state_machine.init()
    
function SmRoleInformationControlsFives:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    app.load("client.shop.recruit.SmGeneralsCard")
    local function init_sm_role_information_controls_fives_terminal()
        -- 显示界面
        local sm_role_information_controls_fives_display_terminal = {
            _name = "sm_role_information_controls_fives_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsFivesWindow = fwin:find("SmRoleInformationControlsFivesClass")
                if SmRoleInformationControlsFivesWindow ~= nil then
                    SmRoleInformationControlsFivesWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_controls_fives_hide_terminal = {
            _name = "sm_role_information_controls_fives_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsFivesWindow = fwin:find("SmRoleInformationControlsFivesClass")
                if SmRoleInformationControlsFivesWindow ~= nil then
                    SmRoleInformationControlsFivesWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_information_controls_fives_display_terminal)
        state_machine.add(sm_role_information_controls_fives_hide_terminal)
        state_machine.init()
    end
    init_sm_role_information_controls_fives_terminal()
end

function SmRoleInformationControlsFives:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local shipData = nil
    local ship_id = self.ship_id
    if zstring.tonumber(self.m_type) == -1 then
        shipData = _ED.other_user_ship
        ship_id = shipData.ship_template_id
    else
        if self.isMould == true then
            ship_id = self.ship_id
        else
            for i, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_template_id) == tonumber(self.ship_id) then
                    shipData = v
                    ship_id = shipData.ship_template_id
                    break
                end
            end
        end
    end

    local Text_fighting_0 = ccui.Helper:seekWidgetByName(root, "Text_fighting_0")
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], ship_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = nil
    if shipData == nil then
        evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_id, ship_mould.captain_name)]
    else
        local ship_evo = zstring.split(shipData.evolution_status, "|")
        evo_mould_id = evo_info[tonumber(ship_evo[1])]
    end
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.describe_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local location = word_info[3]
     local _richText1 = ccui.RichText:create()
    _richText1:ignoreContentAdaptWithSize(false)
    -- local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, location,Text_fighting_0:getFontName(), Text_fighting_0:getFontSize())
    -- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    --     re1 =ccui.RichElementText:create(1, cc.c3b(71, 71, 71),255, location,Text_fighting_0:getFontName(), Text_fighting_0:getFontSize())
    -- end
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(71,71,71)
    elseif __lua_project_id == __lua_project_l_digital then
        color_Type_1 = cc.c3b(45,53,88)
    else
        color_Type_1 = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    end
    -- _richText1:pushBackElement(re1)
    _richText1:setContentSize(cc.size(Text_fighting_0:getContentSize().width,Text_fighting_0:getFontSize()))
    _richText1:setAnchorPoint(0,0)
    local rt, count, text = draw.richTextCollectionMethod(_richText1, 
            location, 
            color_Type_1,
            cc.c3b(255,255,255),
            0, 
            0, 
            Text_fighting_0:getFontName(), 
            Text_fighting_0:getFontSize(),
            the_color_of_the_fetters)

    _richText1:formatTextExt()
    local rsize = _richText1:getContentSize()
    _richText1:setPosition(cc.p(0,-Text_fighting_0:getFontSize()*3/2))

    Text_fighting_0:addChild(_richText1)
    -- _richText1:setPosition(cc.p(0-Text_fighting_0:getContentSize().width/2,-Text_fighting_0:getFontSize()*3/2))

    local newHeight = 0
    newHeight = _richText1:getContentSize().height+Text_fighting_0:getFontSize()*3/2
    if newHeight > Text_fighting_0:getContentSize().height then
        newHeight = _richText1:getContentSize().height+Text_fighting_0:getFontSize()*3/2
    else
        newHeight = Text_fighting_0:getContentSize().height
    end
    local m_height = 0 + newHeight

    local up = m_height - Text_fighting_0:getContentSize().height   
    root:setContentSize(cc.size(root:getContentSize().width,root:getContentSize().height + up))
    local Panel_jichuxinxi = ccui.Helper:seekWidgetByName(root, "Panel_jichuxinxi")
    Panel_jichuxinxi:setPositionY(Panel_jichuxinxi:getPositionY()+up)
end

function SmRoleInformationControlsFives:init(params)
    --模板id
    self.ship_id = params[1]
    self.isMould = params[2]
    self.m_type = params[3] or nil
    self:onInit()
    return self
end

function SmRoleInformationControlsFives:onInit()
    local csbSmRoleInformationControlsFives = csb.createNode("packs/HeroStorage/sm_generals_information_5.csb")
    local root = csbSmRoleInformationControlsFives:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformationControlsFives)
	if SmRoleInformationControlsFives.__size == nil then
        SmRoleInformationControlsFives.__size = root:getContentSize()
    end
    self:onUpdateDraw()
end

function SmRoleInformationControlsFives:onExit()
    state_machine.remove("sm_role_information_controls_fives_display")
    state_machine.remove("sm_role_information_controls_fives_hide")
end