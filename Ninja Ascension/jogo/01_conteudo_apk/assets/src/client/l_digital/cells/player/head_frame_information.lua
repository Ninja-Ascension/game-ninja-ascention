--[[ ----------------------------------------------------------------------------
-- 头像框提示界面
--]] ----------------------------------------------------------------------------
HeadFrameInformation = class("HeadFrameInformationClass", Window)
HeadFrameInformation.__size = nil

-- 构造器
function HeadFrameInformation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize head frame information page state machine.
	local function init_head_frame_information_terminal()
		

        state_machine.init()
	end
	-- call func init head frame information state machine.
	init_head_frame_information_terminal()
end

-- 对象初始化
-- 需要数据
-- headFrameID  nameIndex toGeiIndex
function HeadFrameInformation:init(headFrameID, widget)
	self.headFrameID = headFrameID
	
	self.widget = widget
    if nil ~= widget then
        local pos = fwin:convertToWorldSpace(widget, cc.p(0, 0))
        local anchor = widget:getAnchorPoint()
        local size = widget:getContentSize()
        pos.x = pos.x / app.scaleFactor + size.width / 2 
        
        pos.y = pos.y / app.scaleFactor + size.height - 25 * app.scaleFactor
        self:setPosition(pos)
    else
        
    end

	return self
end

function HeadFrameInformation:onUpdateDraw()
	local root = self.roots[1]

	-- 头像框图片容器
	self.Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")

	-- 头像框名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 头像框数量
	self.Text_nums = ccui.Helper:seekWidgetByName(root, "Text_nums")

	-- 获取途径文本
	self.Text_get = ccui.Helper:seekWidgetByName(root, "Text_get")

	-- 顶部背景图片
	self.Image_deco = ccui.Helper:seekWidgetByName(root, "Image_deco")

	self:initDrawUI()
	self:updatePosition()
end

function HeadFrameInformation:initDrawUI()
	local root = self.roots[1]
	local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, self.headFrameID)[1]
	local toGetIdx = dms.atoi(headFrameInfo, face_frame_mould.toGetID)
	local nameIdx = dms.atoi(headFrameInfo, face_frame_mould.nameID)
	local picIdx = dms.atoi(headFrameInfo, face_frame_mould.resID)

	local imprintNums = 0
	local headFrameInfo = _ED.user_info.head_frame
	if headFrameInfo ~= nil and headFrameInfo.info ~= nil then
		for i, v in ipairs(headFrameInfo.info) do
			if v.headFrameID == self.headFrameID then
				imprintNums = v.imprintNums
				break
			end
		end
	end

	local picPath = string.format("image/cut/frame/cut_frame_%d.png", picIdx)
	local getText = dms.string(dms["word_mould"], toGetIdx, word_mould.text_info)
	local nameText = dms.string(dms["word_mould"], nameIdx, word_mould.text_info)

	self.Panel_image:removeBackGroundImage()
	if true == cc.FileUtils:getInstance():isFileExist(picPath) then
		self.Panel_image:setBackGroundImage(picPath)
	end
	self.Text_name:setString(nameText)
	self.Text_get:setString(getText)

	self.Text_nums:setString(imprintNums)

    local textWidth = self.Text_nums:getContentSize().width
    self.Text_nums:setUnifySizeEnabled(true) --使用归一化尺寸, 不使用自定义尺寸
    self.Text_nums:setTextAreaSize(cc.size(textWidth, 0))	
    self.Text_nums:ignoreContentAdaptWithSize(false) --不使用自定义尺寸
	
end

-- 设置坐标
function HeadFrameInformation:updatePosition()
	local root = self.roots[1]
	

	local screenSize = cc.Director:getInstance():getWinSize()

	local rootPos = fwin:convertToWorldSpace(root, cc.p(0, 0))
	if rootPos.y + self.Image_deco:getContentSize().height * app.scaleFactor > screenSize.height then
		root:setPositionY(root:getPositionY() - rootPos.y / app.scaleFactor - self.Image_deco:getContentSize().height + screenSize.height / app.scaleFactor - 10)
	end
	if rootPos.x + self.Image_deco:getContentSize().width * app.scaleFactor / 2 > screenSize.width then
		root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor - self.Image_deco:getContentSize().width / 2 + screenSize.width / app.scaleFactor - 10 )
	end
	if rootPos.x - self.Image_deco:getContentSize().width * app.scaleFactor / 2 < 0 then
		root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor + self.Image_deco:getContentSize().width / 2)
	end
	if nil == self.widget then
		root:setPosition(cc.p(screenSize.width / app.scaleFactor / 2, screenSize.height / app.scaleFactor / 2 - self.Image_deco:getContentSize().height / 2))
	end
end

function HeadFrameInformation:onEnterTransitionFinish()
	local csbNode = csb.createNode("player/head_details.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	
	self:onUpdateDraw()
end

function HeadFrameInformation:onExit()
	-- 释放HeadFrameInformationWindow界面资源.

end

function HeadFrameInformation:createCell()
    local cell = HeadFrameInformation:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

-- ~END
-- ----------------------------------------------------------------------------
