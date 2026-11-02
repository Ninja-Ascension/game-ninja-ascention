--[[ ----------------------------------------------------------------------------
-- 印记详情
--]] ----------------------------------------------------------------------------
RoleBiographyIconCell = class("RoleBiographyIconCellClass", Window)
RoleBiographyIconCell.__size = nil

-- 创建Cell实例
local role_biography_icon_cell_create_terminal = {
	_name = "role_biography_icon_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyIconCell then
			local cell = RoleBiographyIconCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_icon_cell_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_role_biography_icon_cell_terminal()
		-- 查看印记详情
		local role_biography_icon_cell_look_description_terminal = {
			_name = "role_biography_icon_cell_look_description",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local propId = params._datas._propId
				state_machine.excute("role_biography_description_window_open", 0, propId)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(role_biography_icon_cell_look_description_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_role_biography_icon_cell_terminal()
end

-- 对象初始化
function RoleBiographyIconCell:init(params)
	self._propId = params.propId
	self._canTouch = params.canTouch
	self._isShowHave = params.isShowHave
		
	self:onInit(params)
	self:setContentSize(RoleBiographyIconCell.__size)
	return self
end

function RoleBiographyIconCell:updateUI()
	local Panel_box = self.Panel_box
	Panel_box:removeAllChildren(true)

	local quality = dms.int(dms["prop_mould"], self._propId, prop_mould.prop_quality)

	-- print("self._propId = ", self._propId, "quality = ", quality)

	local bgSprite = cc.Sprite:create(string.format("images/ui/text/TF_res/ninja_biographies/imprint/ninja_biographies_icon_%d.png", quality + 1))
	if bgSprite ~= nil then
		bgSprite:setPosition(cc.p(Panel_box:getContentSize().width/2, Panel_box:getContentSize().height/2))
		Panel_box:addChild(bgSprite)
	end

	local Panel_charactor = self.Panel_charactor
	Panel_charactor:removeAllChildren(true)

	local pic_index = dms.int(dms["prop_mould"], self._propId, prop_mould.pic_index)
	local picSprite = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic_index))
	if picSprite ~= nil then
		picSprite:setPosition(cc.p(Panel_charactor:getContentSize().width/2, Panel_charactor:getContentSize().height/2))
		Panel_charactor:addChild(picSprite)
	end

	self.Image_1:setVisible(self._isShowHave == 1 or self._isShowHave == true)
	if self.Image_2 then
		self.Image_2:setVisible(self._isShowHave == 2)
	end
	

	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.ColorfulImprint)
	if fun_is_open == true then
		self.Panel_flash:removeAllChildren(true)
		local isColorful = RoleBiographyHandle.judgeImprintIsColorful(self._propId)
		if isColorful == true then
			local jsonFile = "images/ui/effice/effect_colorprint/effect_colorprint.json"
			local atlasFile = "images/ui/effice/effect_colorprint/effect_colorprint.atlas"

			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "colorprint", true, nil)

			animation:setPosition(cc.p(self.Panel_flash:getContentSize().width/2, self.Panel_flash:getContentSize().height/2))

			self.Panel_flash:addChild(animation)
		end
	end
end

function RoleBiographyIconCell:onUpdateDraw()
	local root = self.roots[1]

	if __lua_project_id == __lua_project_l_pokemon then
        self.Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_charactor")

        self.Panel_charactor = ccui.Helper:seekWidgetByName(root, "Panel_box")
    else
        self.Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box")

        self.Panel_charactor = ccui.Helper:seekWidgetByName(root, "Panel_charactor")
    end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	fwin:removeTouchEventListener(self.Panel_charactor)
	-- print("self._canTouch = ", self._canTouch)
	if self._canTouch then
		self.Panel_charactor = fwin:addTouchEventListener(self.Panel_charactor, nil,
		{
			terminal_name = "role_biography_icon_cell_look_description",
			terminal_state = 0,
			isPressedActionEnabled = true,
			_propId = self._propId,
		}, nil, 0)	
	end

	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")

	-- 可合成标签
	self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")

	self.Panel_flash = ccui.Helper:seekWidgetByName(root, "Panel_flash")
	
	self:updateUI()
end

function RoleBiographyIconCell:onEnterTransitionFinish()
	
end

function RoleBiographyIconCell:onInit(params)
	-- 加载RoleBiographyIconCellWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_0_box = res/cultivate/ninja_biographies/ninja_biographies_0_box.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_0_box.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_0_box.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyIconCell.__size == nil then
		RoleBiographyIconCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function RoleBiographyIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box")
	self.Panel_box:removeAllChildren(true)

	self.Panel_charactor = ccui.Helper:seekWidgetByName(root, "Panel_charactor")
	self.Panel_charactor:removeAllChildren(true)

	self.Panel_flash = ccui.Helper:seekWidgetByName(root, "Panel_flash")
	if self.Panel_flash ~= nil then
		self.Panel_flash:removeAllChildren(true)
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")
end

function RoleBiographyIconCell:onExit()
	-- 释放RoleBiographyIconCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_0_box.csb", root)
	-- ]]
end

function RoleBiographyIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_0_box.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
