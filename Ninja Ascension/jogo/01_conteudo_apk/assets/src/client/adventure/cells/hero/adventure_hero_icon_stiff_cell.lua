----------------------------------------------------------------------------------------------------
-- 说明：武将图标绘制
----------------------------------------------------------------------------------------------------
AdventureHeroIconStiffCell = class("AdventureHeroIconStiffCellClass", Window)
AdventureHeroIconStiffCell.__size = cc.size(120, 120)

function AdventureHeroIconStiffCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.current_type = 0
	self.enum_type = {
		_TYPE_NORMAL = 0,					-- 静态的UI显示
	}

	-- Initialize adventure hero icon stiff cell state machine.
	local function init_adventure_hero_icon_stiff_cell_terminal()
        -- 显示武将信息
        local adventure_hero_icon_stiff_cell_show_hero_information_terminal = {
            _name = "adventure_hero_icon_stiff_cell_show_hero_information",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                app.load("client.adventure.packs.hero.AdventureHeroInformation")
                fwin:open(AdventureHeroInformation:new():init(cell.hero, cell), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(adventure_hero_icon_stiff_cell_show_hero_information_terminal)
        state_machine.init()
	end

	-- call func init adventure hero icon stiff cell state machine.
	init_adventure_hero_icon_stiff_cell_terminal()
end

function AdventureHeroIconStiffCell:updateDraw()
	-- 绘制品质框
	-- local quality = self.drawIndex % 5 + 1 -- dms.atoi(self.mould_data, ship_mould.ship_type)
	-- local qualityImage = string.format("images/ui/quality/icon_hero_%d.png", quality+1)
	-- self:setBackGroundImage(qualityImage)

	local picIndex = self.drawIndex -- dms.atos(self.mould_data, ship_mould.head_icon)
	local sprite = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
	self:addChild(sprite)

	if self.ifdim == nil or self.ifdim =="" then
		self:setColor(cc.c3b(150, 150, 150))
	else
		self:setColor(cc.c3b(255, 255, 255))
	end
end

function AdventureHeroIconStiffCell:onInit()
 	-- -- 显示武将信息
  --   fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role_bg"),       nil, 
  --   {
  --       terminal_name = "adventure_hero_icon_cell_show_hero_information",
  --       cell = self,        
  --       terminal_state = 0, 
  --       isPressedActionEnabled = false
  --   }, 
  --   nil, 0)

	self:updateDraw()
end

function AdventureHeroIconStiffCell:onExit()
	cacher.freeRef("icon/item_role_stiff.csb", self.roots[1])
end

-- /**
-- * interfaceType	逻辑类型
-- * hero			实例对象
-- * drawHeadType	绘制类型
-- * ifdim			阴影显示逻辑
-- * number			数量
-- * capadility		战力显示数
-- * level			等级显示数
-- * awaken			觉醒等级显示数
-- * drawIndex		一个屏幕内显示最多的数量,也是当前在阵容中的位置
-- */
function AdventureHeroIconStiffCell:init(interfaceType, hero, drawHeadType, ifdim, number, capadility, level, awaken, drawIndex)
	self.current_type = interfaceType
	self.hero = hero
	self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)

	self.drawHeadType = drawHeadType
	self.ifdim = ifdim
	self.numbers = number
	self.capadility = capadility --战力
	self.level = level	--等级
	self.awaken = awaken	--觉醒
	self.drawIndex = drawIndex
	if drawIndex ~= nil and drawIndex < 45 then
		self:onInit()
	end
	self:setContentSize(AdventureHeroIconStiffCell.__size)
	return self
end

function AdventureHeroIconStiffCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureHeroIconStiffCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("icon/item_role_stiff.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureHeroIconStiffCell:createCell()
	local cell = AdventureHeroIconStiffCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

