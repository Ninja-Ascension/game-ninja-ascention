----------------------------------------------------------------------------------------------------
-- 说明：数码兽信息查看
----------------------------------------------------------------------------------------------------
smHeroInformation = class("smHeroInformationClass", Window)

function smHeroInformation:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.cells.ship.ship_head_new_cell")
	self.ship = nil
	self.ship_mould = 0
	local function init_sm_hero_information_terminal()
		local sm_hero_information_close_terminal = {
            _name = "sm_hero_information_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(sm_hero_information_close_terminal)
		
        state_machine.init()
	end
	init_sm_hero_information_terminal()
end

function smHeroInformation:onUpdateDraw()
	local root = self.roots[1]

	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_djxx_tx")
	local name = ccui.Helper:seekWidgetByName(root, "Text_djxx_name")
	local describe = ccui.Helper:seekWidgetByName(root, "Text_djxx_ms")
	local Text_zizhi_n = ccui.Helper:seekWidgetByName(root, "Text_zizhi_n")
	local Text_dingwei_n = ccui.Helper:seekWidgetByName(root, "Text_dingwei_n")
	local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")
	local hero_head = ShipHeadNewCell:createCell()
	local evo_mould_id = nil
	if self.ship ~= nil then
		hero_head:init(self.ship,hero_head.enum_type._SHOW_SHIP_NOT_CHOOSE,self.ship.ship_template_id)
		headPanel:addChild(hero_head)

		name:setString(smHeroWorldFundByShip(self.ship , 1))
		Text_dingwei_n:setString(smHeroWorldFundByShip(self.ship , 3))
		-- Text_zizhi_n:setString(dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.ability))
		Text_zizhi_n:setString(getAbilityFromBaMen(self.ship,dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.ability)))
		--进化形象
	    local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
	    local evo_info = zstring.split(evo_image, ",")
	    --进化模板id
	    local ship_evo = zstring.split(self.ship.evolution_status, "|")
	    evo_mould_id = evo_info[tonumber(ship_evo[1])]
	else
		hero_head:init(nil, hero_head.enum_type._SHOW_SHIP_NOT_CHOOSE, self.ship_mould , self.table)
		headPanel:addChild(hero_head)

		name:setString(smHeroWorldFundByMouldId(self.ship_mould , 1))
		Text_dingwei_n:setString(smHeroWorldFundByMouldId(self.ship_mould , 3))
		Text_zizhi_n:setString(dms.string(dms["ship_mould"], self.ship_mould, ship_mould.ability))
		--进化形象
	    local evo_image = dms.string(dms["ship_mould"], self.ship_mould, ship_mould.fitSkillTwo)
	    local evo_info = zstring.split(evo_image, ",")
	    --进化模板id
	    local intEvo = dms.int(dms["ship_mould"], self.ship_mould, ship_mould.captain_name)
		evo_mould_id = evo_info[intEvo]
	end

    local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
    local talentData = zstring.split(talent, "|")
    local skillData = zstring.split(talentData[2], ",") 
    --天赋模板id
    local talentMouldid = skillData[3]
    local pic_index = dms.int(dms["talent_mould"], talentMouldid, talent_mould.new_skill_pic)
    local skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
    if skill_icon ~= nil then
        skill_icon:setPosition(cc.p(Panel_skill_icon:getContentSize().width/2,Panel_skill_icon:getContentSize().height/2))
        Panel_skill_icon:addChild(skill_icon)
    end
    -- describe:setString(smTalentWordlFundByIndex( talentMouldid , 2))
    describe:setString(skillDescriptionReplaceData( talentMouldid,self.ship_mould,2,2,false))

    local Image_djxx = ccui.Helper:seekWidgetByName(root, "Image_djxx")
    local Image_djxx_bg = ccui.Helper:seekWidgetByName(root, "Image_djxx_bg")
	
    local textWidth = describe:getContentSize().width
    describe:setUnifySizeEnabled(true) --使用归一化尺寸, 不使用自定义尺寸
    describe:setTextAreaSize(cc.size(textWidth, 0))	
    describe:ignoreContentAdaptWithSize(false) --不使用自定义尺寸
    local VirtualRendererSize = describe:getContentSize() -- 控件本身可渲染尺寸
    local curHeight = 0
	if Image_djxx:getContentSize().height < VirtualRendererSize.height then
		curHeight = VirtualRendererSize.height - Image_djxx:getContentSize().height + describe:getFontSize()
		Image_djxx:setContentSize(cc.size(Image_djxx:getContentSize().width , Image_djxx:getContentSize().height + curHeight))
		Image_djxx_bg:setContentSize(cc.size(Image_djxx_bg:getContentSize().width , Image_djxx_bg:getContentSize().height + curHeight))
		root:setPosition(cc.p(root:getPositionX() , root:getPositionY() + curHeight))
	end
    -- if needRowNumber > currRowNumber then
    	-- if verifySupportLanguage(_lua_release_language_en) == true then
	-- 		curHeight = (needRowNumber - currRowNumber) * textRenderSize.height+textRenderSize.height*3
	-- 	else
	-- 		curHeight = (needRowNumber - currRowNumber) * textRenderSize.height
	-- 	end
	-- 	describe:setContentSize(cc.size(describe:getContentSize().width , describe:getContentSize().height + curHeight))
	-- 	Image_djxx:setContentSize(cc.size(Image_djxx:getContentSize().width , Image_djxx:getContentSize().height + curHeight))
	-- 	Image_djxx_bg:setContentSize(cc.size(Image_djxx_bg:getContentSize().width , Image_djxx_bg:getContentSize().height + curHeight))
	-- 	root:setPosition(cc.p(root:getPositionX() , root:getPositionY() + curHeight))
	-- end

	-- local screenSize = cc.Director:getInstance():getWinSize() 
	-- local rootPos = fwin:convertToWorldSpace(root, cc.p(0, 0))
	-- if rootPos.y + Image_djxx_bg:getContentSize().height * app.scaleFactor > screenSize.height then
	-- 	root:setPositionY(root:getPositionY() - rootPos.y / app.scaleFactor - Image_djxx_bg:getContentSize().height + screenSize.height / app.scaleFactor - 10)
	-- end
	-- if rootPos.x + Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 > screenSize.width then
	-- 	root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor - Image_djxx_bg:getContentSize().width / 2 + screenSize.width / app.scaleFactor - 10 )
	-- end
	-- if rootPos.x - Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 < 0 then
	-- 	root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor + Image_djxx_bg:getContentSize().width / 2)
	-- end
	-- if nil == self.widget then
	-- 	root:setPosition(cc.p(screenSize.width / app.scaleFactor / 2, screenSize.height / app.scaleFactor / 2 - Image_djxx_bg:getContentSize().height / 2))
	-- end
	local Panel_dj_xx = ccui.Helper:seekWidgetByName(root, "Panel_dj_xx")
	local screenSize = cc.Director:getInstance():getWinSize() 
	Panel_dj_xx:setAnchorPoint(cc.p(0.5,0.5))
	Panel_dj_xx:setPosition(cc.p(screenSize.width / 2 / app.scaleFactor,screenSize.height / 2 / app.scaleFactor - curHeight))
end

function smHeroInformation:onEnterTransitionFinish()
	local csbItem = csb.createNode(config_csb.packs.warehouse_information_2)
	local root = csbItem:getChildByName("root")

	self:addChild(csbItem)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_dj_xx"), nil, {func_string = [[state_machine.excute("sm_hero_information_close", 0, "click sm_hero_information_close.'")]]}, nil, 0)
	self:onUpdateDraw()
end

function smHeroInformation:onExit()
	state_machine.remove("sm_hero_information_close")
end
--table解析
--table.shipStar --战船星级
function smHeroInformation:init(ship, widget , table)
	if type(ship) ~= "table" then
		self.ship_mould = tonumber(ship)
	else
		self.ship = ship
		self.ship_mould = tonumber(self.ship.ship_template_id)
	end
	self.widget = widget
	
	if nil ~= widget then
		--local pos = fwin:convertToWorldSpace(widget, cc.p(0, 0))
		-- local anchor = widget:getAnchorPoint()
		-- local size = widget:getContentSize()
		-- pos.x = pos.x / app.scaleFactor + size.width / 2 -- (size.width * anchor.x)
		-- -- pos.y = pos.y + (size.height * anchor.y) + 50
		-- pos.y = pos.y / app.scaleFactor + size.height - 25 * app.scaleFactor
		-- self:setPosition(pos)
	else
		--self:setPosition(cc.p(fwin._width / 2, fwin._height / 2))
	end
	self.table = table or {}
end

function smHeroInformation:createCell()
	local cell = smHeroInformation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

