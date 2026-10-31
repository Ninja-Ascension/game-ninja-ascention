-- ----------------------------------------------------------------------------------------------------
-- 说明：选择语言弹窗里的控件 --
-- 创建时间：
-- 作者：
-- 修改记录：
-- -----------------------------------------------------------------------------------------------------

ChooseLanguageCell = class("ChooseLanguageCellClass", Window)
ChooseLanguageCell.__size = nil
function ChooseLanguageCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.language_text = nil
	self.defer = nil
	self._undef = nil
end

function ChooseLanguageCell:onEnterTransitionFinish()

end

function ChooseLanguageCell:onInit()
	local root = cacher.createUIRef("login/change_language_cell.csb", "root")
	if root == nil then
		return
	end
	table.insert(self.roots, root)
	self:addChild(root)

	if ChooseLanguageCell.__size == nil then
		ChooseLanguageCell.__size = root:getContentSize()
	end
	local Button_language_n = ccui.Helper:seekWidgetByName(root, "Button_language_n")
	local showLanguage = ""
	local sysLanguage = m_system_default_language
	--debug.print_r(config_res.chooseLanguage,"config_res.chooseLanguage=============")
	for k, v in pairs(config_res.chooseLanguage) do
		if v.languageText == self.language_text then
			showLanguage = v.name
			break
		end
	end
	--print("self.language_text=",self.language_text)
	--print("showLanguaget=",showLanguage)
	--print("sysLanguage=",sysLanguage)
	Button_language_n:setHighlighted(false)
	if showLanguage == sysLanguage then
		--print("高亮=")
		Button_language_n:setHighlighted(true)
	end
	fwin:addTouchEventListener(Button_language_n,nil,
		{
			_sel = self.defer,
			_undef = self._undef,
			terminal_name = "choose_language_popup_ok",
			terminal_state = 0
		}
		,nil, 0)
	self:initDraw()
end

--添加按钮 点击事件
function ChooseLanguageCell:initDraw()
	local root = self.roots[1]
	local languageName = ccui.Helper:seekWidgetByName(root,"Text_language_n")
	languageName:setString("")
	languageName:setString(self.language_text)
end

function ChooseLanguageCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ChooseLanguageCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("login/change_language_cell.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function ChooseLanguageCell:init(defer,_undef)
	self.defer = defer
	self.language_text = defer.languageText
	self._undef = _undef
	self:onInit()
	self:setContentSize(ChooseLanguageCell.__size)
	return self
end

function ChooseLanguageCell:createCell()
	local cell = ChooseLanguageCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ChooseLanguageCell:onExit()
	cacher.freeRef("login/change_language_cell.csb", self.roots[1])
end