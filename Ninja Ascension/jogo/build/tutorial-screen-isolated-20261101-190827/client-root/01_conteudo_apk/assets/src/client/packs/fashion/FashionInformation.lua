----------------------------------------------------------------------------------------------------
-- 说明：时装信息界面
-------------------------------------------------------------------------------------------------------

FashionInformation = class("FashionInformationClass",Window)

--打开界面
local fashion_information_open_terminal = {
    _name = "fashion_information_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionInformationWindow = fwin:find("FashionInformationClass")
        if FashionInformationWindow ~= nil and FashionInformationWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_information_open", 0, "")
        fwin:open(FashionInformation:createCell():init(params), fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_information_close_terminal = {
    _name = "fashion_information_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        FashionInformation:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fashion_information_open_terminal)
state_machine.add(fashion_information_close_terminal)
state_machine.init()

function FashionInformation:ctor()
    self.super:ctor()
    self.roots = {}
    self.group = {}
    self.equip_mouldId = nil       --  装备模板
    self.equip = nil    -- 装备实例

    -- fashion_info_basics_list_cell
    app.load("client.cells.fashion.fashion_info_basics_list_cell")
    app.load("client.cells.fashion.fashion_info_strengthen_list_cell")
    app.load("client.cells.fashion.fashion_info_luck_talent_explain_cell")
    app.load("client.cells.fashion.fashion_info_describe_list_cell")
    app.load("client.cells.fashion.fashion_info_combination_list_cell")

    app.load("client.cells.fashion.fashion_info_skill_cell")


    app.load("client.cells.equip.equip_info_strengthen_list_cell")
    

     -- Initialize fashion information machine.
    local function init_fashion_information_terminal()
    	-- 隐藏界面
        local fashion_information_hide_event_terminal = {
            _name = "fashion_information_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local fashion_information_event_terminal = {
            _name = "fashion_information_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(fashion_information_hide_event_terminal)
        state_machine.add(fashion_information_event_terminal)
        state_machine.init()
    end

     -- call func fashion information machine.
    init_fashion_information_terminal()
end

function FashionInformation:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local equipMouldId = nil
	local equip = self.equip
    local equipGrade =nil
    if equip == nil then
        equipGrade = 1
        equipMouldId = self.equip_mouldId
    else
        equipGrade = tonumber(equip.user_equiment_grade)
        equipMouldId = equip.user_equiment_template
    end
	-- equip.user_equiment_id
	local equipData =  dms.element(dms["equipment_mould"], equipMouldId)

	local quality = dms.atoi(equipData,equipment_mould.grow_level) +1 
	local picIndex = dms.atoi(equipData,equipment_mould.All_icon)

	local ship = fundShipWidthId(_ED.user_formetion_status[1])
	local ptype = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.capacity)--角色头像类型

	shipImage = ccui.Helper:seekWidgetByName(root, "Panel_shizhuang_role")
	shipImage:removeBackGroundImage()
	shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex + ptype - 1))

	-- ccui.Helper:seekWidgetByName(root, "Text_zizhi"):setString("潜力:")
	ccui.Helper:seekWidgetByName(root, "Text_2"):setString(dms.atoi(equipData,equipment_mould.rank_level))
	ccui.Helper:seekWidgetByName(root, "Text_3"):setString(dms.atos(equipData,equipment_mould.equipment_name))
    ccui.Helper:seekWidgetByName(root, "Text_3"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
    ccui.Helper:seekWidgetByName(root, "Text_2"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	ccui.Helper:seekWidgetByName(root, "Text_1"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	-- ccui.Helper:seekWidgetByName(root, "Text_lv"):setString(equip.user_equiment_grade)
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	Panel_3:setBackGroundImage("images/ui/quality/zb_leixing_6.png")
	local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
	if quality == 1 then							--白色
		Panel_5:setBackGroundImage("images/ui/quality/zb_grow_0.png")
	elseif quality == 2 then
		Panel_5:setBackGroundImage("images/ui/quality/zb_grow_1.png")
	elseif quality == 3 then
		Panel_5:setBackGroundImage("images/ui/quality/zb_grow_2.png")
	elseif quality == 4 then
		Panel_5:setBackGroundImage("images/ui/quality/zb_grow_3.png")
	elseif quality == 5 then
		Panel_5:setBackGroundImage("images/ui/quality/zb_grow_4.png")
	elseif quality == 6 then
		Panel_5:setBackGroundImage("images/ui/quality/zb_grow_5.png")
	end

	--天赋
	local drawTalent = {}

	
	local skills = dms.int(dms["equipment_mould"], equipMouldId, equipment_mould.skill_equipment_adron_mould)
    local talentDatas = dms.searchs(dms["equipment_fashion_talent"], equipment_fashion_talent.group_id, skills)
    -- local open  = nil 
    -- local willopen = nil
    local count = 1
    if table.getn(talentDatas) ~= 0 then
        for i,v in ipairs(talentDatas) do
        	local talentid = dms.atoi(v,equipment_fashion_talent.talent_id)
        	if talentid > 0 then
        		local talent_status = 0		--是否激活
        		if dms.atoi(v,equipment_fashion_talent.need_lv) <= tonumber(equipGrade) then
        			talent_status = 1
        		end
				local talent_name = dms.string(dms["talent_mould"], talentid, talent_mould.talent_name)
				local talent_describe = dms.string(dms["talent_mould"], talentid, talent_mould.talent_describe)
                -- print("drawTalent-------------",drawTalent)
                drawTalent[count] = {}
				drawTalent[count][1] = talent_status
				drawTalent[count][2] = talent_name
				drawTalent[count][3] = talent_describe
				count = count + 1
        	end
        end
    end



	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListView_1:removeAllChildren(true)

	local cell = FashionInfoBasicsListCell:createCell()
	cell:init(equipMouldId)
	ListView_1:addChild(cell)

	local cellstr = FashionInfoStrengthenListCell:createCell()
	cellstr:init(equip,equipMouldId)
	ListView_1:addChild(cellstr)

    local cellskill = FashionInfoHeroSkill:createCell()
    cellskill:init(equip,equipMouldId)
    ListView_1:addChild(cellskill)

    

	local celltalent = FashionInfoTalentExplain:createCell()
	celltalent:init(equip,equipMouldId,2,drawTalent)
	ListView_1:addChild(celltalent)


    local suit_id = dms.int(dms["equipment_mould"], equipMouldId, equipment_mould.suit_id)
    if suit_id > 0 then
        local suitData = dms.searchs(dms["equipment_fashion_pokedex"], equipment_fashion_pokedex.suit_id, suit_id)
        if suitData ~= nil and table.getn(suitData) ~= 0 then
            
            local cellCombination = FashionInfoCombinationListCell:createCell()
            cellCombination:init(equip,equipMouldId)
            ListView_1:addChild(cellCombination)
        end
    end
    
    local cellDescribe = FashionInfoDescribeListCell:createCell()
    cellDescribe:init(equip,equipMouldId)
    ListView_1:addChild(cellDescribe)

end

function FashionInformation:onInit()
	self:updateDraw()
end

function FashionInformation:onEnterTransitionFinish()
	local csbFashionInformationCell = csb.createNode("packs/EquipStorage/equipment_information.csb")
    local root = csbFashionInformationCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFashionInformationCell)
    self:onInit()
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_warship_girl_b 
        then
    else
        ccui.Helper:seekWidgetByName(root, "Image_20"):setVisible(false)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
	    terminal_name = "fashion_information_close", 
	    terminal_state = 0,
	    _cell = self,
	    _equip = self._equip,
	    isPressedActionEnabled = false
	}, 
	nil, 0)

    state_machine.unlock("fashion_information_open", 0, "")
end

function FashionInformation:init(params)
	self.equip = params._datas._equip
    self.equip_mouldId =  params._datas._equip_mould
	return self
end

function FashionInformation:createCell()
    local cell = FashionInformation:new()

    return cell
end

function FashionInformation:closeCell( ... )
    local FashionInformationWindow = fwin:find("FashionInformationClass")
    if FashionInformationWindow == nil then
        return
    end
    fwin:close(FashionInformationWindow)
end