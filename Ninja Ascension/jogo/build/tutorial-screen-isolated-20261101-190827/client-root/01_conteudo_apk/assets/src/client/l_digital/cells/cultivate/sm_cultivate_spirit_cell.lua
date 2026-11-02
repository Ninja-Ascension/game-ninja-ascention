--------------------------------------------------------------------------------------------------------------
--  说明：数码精神单个控件
--------------------------------------------------------------------------------------------------------------
SmCultivateSpiritCell = class("SmCultivateSpiritCellClass", Window)
SmCultivateSpiritCell.__size = nil

--创建cell
local sm_cultivate_spirit_cell_terminal = {
    _name = "sm_cultivate_spirit_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCultivateSpiritCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_cultivate_spirit_cell_terminal)
state_machine.init()

function SmCultivateSpiritCell:ctor()
	self.super:ctor()
	self.roots = {}

	 -- Initialize sm_cultivate_spirit_cell state machine.
    local function init_sm_cultivate_spirit_cell_terminal()
        
        local sm_cultivate_spirit_cell_check_terminal = {
            _name = "sm_cultivate_spirit_cell_check",
            _init = function (terminal)       
                app.load("client.l_digital.cultivate.SmCultivateSpiritAdd")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params._datas.cells
                local number = params._datas.number
                state_machine.excute("sm_cultivate_spirit_add_open",0,{cells,number})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_cell_update_terminal = {
            _name = "sm_cultivate_spirit_cell_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params[1]
                cells:unload()
                cells:reload()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_spirit_cell_check_terminal)
        state_machine.add(sm_cultivate_spirit_cell_update_terminal)
        state_machine.init()
    end 
    -- call func sm_cultivate_spirit_cell create state machine.
    init_sm_cultivate_spirit_cell_terminal()

end

function SmCultivateSpiritCell:updateDraw()
    local root = self.roots[1]
    --分组的图标
    local Panel_spirit_icon = ccui.Helper:seekWidgetByName(root, "Panel_spirit_icon")
    Panel_spirit_icon:removeBackGroundImage()

    local icon = dms.int(dms["ship_spirit_group"], self.index, ship_spirit_group.icon)
    Panel_spirit_icon:setBackGroundImage(string.format("images/ui/text/SMJS_res/smjs_s/smjs_s_icon_%d.png", icon))

    --分组的名称图
    local Panel_spirit_name = ccui.Helper:seekWidgetByName(root, "Panel_spirit_name")
    Panel_spirit_name:removeBackGroundImage()
    
    Panel_spirit_name:setBackGroundImage(string.format("images/ui/text/SMJS_res/smjs_s/smjs_s_text_%d.png", icon))

    local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], self.index, ship_spirit_group.ship_need_id),",")
    local need_prop = zstring.split(dms.string(dms["ship_spirit_group"], self.index, ship_spirit_group.need_props),"|")
    local Image_tuisong_4 = ccui.Helper:seekWidgetByName(root, "Image_tuisong_4")
    if Image_tuisong_4 ~= nil then
        Image_tuisong_4:setVisible(false)
    end
    for i=1,3 do
        --图片头像
        local Panel_digimon_head = ccui.Helper:seekWidgetByName(root, "Panel_digimon_head_"..i)
        Panel_digimon_head:removeAllChildren(true)

        local Image_tuisong = ccui.Helper:seekWidgetByName(root, "Image_tuisong_"..i)

        local icons = nil 
        local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_bg_"..i)
        Image_bg:loadTexture("images/ui/quality/icon_hero_1.png")

        local isShowHero = ship_need_id[i] ~= nil
        if isShowHero and tonumber(ship_need_id[i]) < 0 then 
            isShowHero = false
        end
        -- if __lua_project_id == __lua_project_l_digital then
        --     if isShowHero == true then
        --         isShowHero = isShowHeroCard(ship_need_id[i])
        --     end
        -- end

        if isShowHero == true then
            --进化形象
            local evo_image = dms.string(dms["ship_mould"], ship_need_id[i], ship_mould.fitSkillTwo)
            local evo_info = zstring.split(evo_image, ",")
            --进化模板id
            local evo_mould_id = 0
            local ship = fundShipWidthTemplateId(ship_need_id[i])
            if ship ~= nil then
                local ship_evo = zstring.split(ship.evolution_status, "|")
                evo_mould_id = smGetSkinEvoIdChange(ship)
            else
                local captain_name = dms.int(dms["ship_mould"], ship_need_id[i], ship_mould.captain_name)
                evo_mould_id = evo_info[captain_name]
            end
            local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
            icons = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
            icons:setPosition(cc.p(Panel_digimon_head:getContentSize().width/2,Panel_digimon_head:getContentSize().height/2))
            Panel_digimon_head:addChild(icons)
            if Image_tuisong ~= nil then
                Image_tuisong:setVisible(false)
            end
            if ship ~= nil then
                local isMax = false
                if ship.shipSpirit ~= nil and ship.shipSpirit ~= "" then
                    local info = zstring.split(ship.shipSpirit, ":")
                    local spirit = zstring.split(info[2],",")
                    local infos = dms.searchs(dms["ship_spirit_param"], ship_spirit_param.stalls, spirit[3])
                    if tonumber(spirit[1]) >= #infos then
                        infos = dms.searchs(dms["ship_spirit_param"], ship_spirit_param.stalls, tonumber(spirit[3] + 1))
                        if infos == nil then
                            isMax = true
                        end
                    end
                end
                if isMax == false then
                    if Image_tuisong ~= nil then
                        for j, v in pairs(need_prop) do
                            if Image_tuisong_4 ~= nil then
                                local needs = zstring.split(v,",")
                                if tonumber(getPropAllCountByMouldId(tonumber(needs[2]))) > 0 then
                                    if Image_tuisong_4:isVisible() == false then
                                        Image_tuisong_4:setVisible(true)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                Image_bg:loadTexture("images/ui/quality/icon_enemy_5.png")
                display:ungray(icons)
            else
                display:gray(icons)
            end
        else
            icons = cc.Sprite:create(string.format("images/ui/props/props_%d.png", 107401))
            icons:setPosition(cc.p(Panel_digimon_head:getContentSize().width/2,Panel_digimon_head:getContentSize().height/2))
            Panel_digimon_head:addChild(icons)
            display:gray(icons)
        end
    end
end

function SmCultivateSpiritCell:onInit()
    local root = cacher.createUIRef("cultivate/cultivate_spirit_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if SmCultivateSpiritCell.__size == nil then
        SmCultivateSpiritCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_spirit"):getContentSize()
    end

    if self.index > 0 then
    	self:updateDraw()
        -- self:registerOnNoteUpdate(self)

        local isCanTouch = true

        -- if __lua_project_id == __lua_project_l_digital then
        --     local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], self.index, ship_spirit_group.ship_need_id),",")
            
        --     isCanTouch = false

        --     for _, v in pairs(ship_need_id) do
        --         local shipMouldId = zstring.tonumber(v)
        --         if shipMouldId > 0 then
        --             if isShowHeroCard(shipMouldId) == true then
        --                 isCanTouch = true
        --                 break
        --             end
        --         end
        --     end
        -- end
        local ship_need_id = zstring.split(dms.string(dms["ship_spirit_group"], self.index, ship_spirit_group.ship_need_id),",")
        local curIdx = 1
        for i=1,#ship_need_id do
            if ship_need_id[i] ~= nil and tonumber(ship_need_id[i]) > 0 then 
                curIdx = i
                break
            end
        end
        ccui.Helper:seekWidgetByName(root, "Button_1"):setTouchEnabled(isCanTouch)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
        {
            terminal_name = "sm_cultivate_spirit_cell_check", 
            terminal_state = 0,
            number = curIdx,
            cells = self,
        }, nil, 0)
    end
end

function SmCultivateSpiritCell:onEnterTransitionFinish()

end

function SmCultivateSpiritCell:clearUIInfo( ... )
    local root = self.roots[1]
    for i=1,3 do
        local Panel_digimon_head = ccui.Helper:seekWidgetByName(root, "Panel_digimon_head_"..i)
        if Panel_digimon_head ~= nil then
            Panel_digimon_head:removeAllChildren(true)
        end
    end
    local Panel_spirit_icon = ccui.Helper:seekWidgetByName(root, "Panel_spirit_icon")
    local Panel_spirit_name = ccui.Helper:seekWidgetByName(root, "Panel_spirit_name")
    local Image_tuisong_4 = ccui.Helper:seekWidgetByName(root, "Image_tuisong_4")
    if Panel_spirit_icon ~= nil then
        Panel_spirit_icon:removeBackGroundImage()
    end
    if Panel_spirit_name ~= nil then
        Panel_spirit_name:removeBackGroundImage()
    end
    if Image_tuisong_4 ~= nil then
        Image_tuisong_4:setVisible(false)
    end
end

function SmCultivateSpiritCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmCultivateSpiritCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_spirit_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmCultivateSpiritCell:init(params)
    self.index = params[1]
    -- self.current_index = params[2]
	if self.index <= 8 then
        self:onInit()
    end
    self:setContentSize(SmCultivateSpiritCell.__size)
    return self
end

function SmCultivateSpiritCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_spirit_cell.csb", self.roots[1])
end