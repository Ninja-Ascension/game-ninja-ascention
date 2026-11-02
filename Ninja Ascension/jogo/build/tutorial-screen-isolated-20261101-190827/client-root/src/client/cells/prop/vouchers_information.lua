----------------------------------------------------------------------------------------------------
-- 说明：代金券信息查看
----------------------------------------------------------------------------------------------------
vouchersInformation = class("vouchersInformationClass", Window)

function vouchersInformation:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
    self.roots = {} -- 界面中的UI根节点，供模块获取界面中的UI元素实例
    self.prop = nil -- 当前要绘制的道具实例数据对对象
    self.type = nil
    -- 初始化道具小图标事件响应需要使用的状态机
    local function init_vouchers_info_cell_terminal()
        local vouchers_info_cell_close_terminal = {
            _name = "vouchers_info_cell_close",
            _init = function(terminal)
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

        state_machine.add(vouchers_info_cell_close_terminal)

        state_machine.init()
    end
    init_vouchers_info_cell_terminal()
end

function vouchersInformation:onUpdateDraw()
    local root = self.roots[1]

    local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_djxx_tx")
    local name = ccui.Helper:seekWidgetByName(root, "Text_djxx_name")
    local describe = ccui.Helper:seekWidgetByName(root, "Text_djxx_ms")
    local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")

    local mouldId = self.prop
   

	local rsize = nil
	local cell = ResourcesIconCell:createCell()
    cell:init(74, 0, mouldId,nil,nil,false,false,1)
    headPanel:addChild(cell)

    --获取代金券名称索引
    local nameindex = dms.int(dms["vouchers_mould"], mouldId, warehouse_vouchers_mould.name_id)
    --通过代金券索引找到word_mould
    local word_info = dms.element(dms["word_mould"], nameindex)
    local names = word_info[3]
    name:setString(names)

    local colortype = dms.int(dms["vouchers_mould"], mouldId, warehouse_vouchers_mould.quality_level)

    if colortype == 7 then
        name:setColor(cc.c3b(_quality_color[colortype + 1][1], _quality_color[colortype + 1][2], _quality_color[colortype + 1][3]))
    else
        name:setColor(cc.c3b(color_Type[colortype + 1][1], color_Type[colortype + 1][2], color_Type[colortype + 1][3]))
    end
    local describeId = dms.int(dms["vouchers_mould"], mouldId, warehouse_vouchers_mould.describe_id)
    local describe_info = dms.element(dms["word_mould"], describeId)
    local propremark = describe_info[3]
    
    describe:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = describe:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = describe:getFontSize() * 6
    end

    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(71, 71, 71)
        color_Type_2 = cc.c3b(71, 71, 71)
    else
        color_Type_1 = cc.c3b(255, 255, 255)
        color_Type_2 = cc.c3b(255, 255, 255)
    end

    local rt, count, text = draw.richTextCollectionMethod(_richText2, propremark, color_Type_1, color_Type_2, 0, 0, describe:getFontName(), describe:getFontSize(), chat_rich_text_color)

    _richText2:formatTextExt()
    rsize = _richText2:getContentSize()
    _richText2:setPositionY(describe:getContentSize().height)
    _richText2:setPositionX(0)
    describe:addChild(_richText2)

    if Text_have_n ~= nil then
        Text_have_n:setString(getVouchersAllCountByMouldId(mouldId))
    end

    if
        __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or
            __lua_project_id == __lua_project_l_naruto
     then
        local Image_djxx = ccui.Helper:seekWidgetByName(root, "Image_djxx")
        local Image_djxx_bg = ccui.Helper:seekWidgetByName(root, "Image_djxx_bg")
        local textRenderSize = describe:getAutoRenderSize() -- 未换行前尺寸
        -- local VirtualRendererSize = describe:getContentSize() -- 控件本身可渲染尺寸
        local VirtualRendererSize = rsize
        local needRowNumber = math.ceil(textRenderSize.width / VirtualRendererSize.width)
        local currRowNumber = VirtualRendererSize.height / textRenderSize.height
        local curHeight = 0
        if Image_djxx:getContentSize().height < VirtualRendererSize.height then
            curHeight = VirtualRendererSize.height - Image_djxx:getContentSize().height + describe:getFontSize()
            Image_djxx:setContentSize(cc.size(Image_djxx:getContentSize().width, Image_djxx:getContentSize().height + curHeight))
            Image_djxx_bg:setContentSize(cc.size(Image_djxx_bg:getContentSize().width, Image_djxx_bg:getContentSize().height + curHeight))
            root:setPosition(cc.p(root:getPositionX(), root:getPositionY() + curHeight))
        end
        --    if needRowNumber > currRowNumber then
        --    	if verifySupportLanguage(_lua_release_language_en) == true then
        -- 		curHeight = (needRowNumber - currRowNumber) * textRenderSize.height+textRenderSize.height*3
        -- 	else
        -- 		curHeight = (needRowNumber - currRowNumber) * textRenderSize.height
        -- 	end
        -- 	describe:setContentSize(cc.size(describe:getContentSize().width , describe:getContentSize().height + curHeight))
        -- 	Image_djxx:setContentSize(cc.size(Image_djxx:getContentSize().width , Image_djxx:getContentSize().height + curHeight))
        -- 	Image_djxx_bg:setContentSize(cc.size(Image_djxx_bg:getContentSize().width , Image_djxx_bg:getContentSize().height + curHeight))
        -- 	root:setPosition(cc.p(root:getPositionX() , root:getPositionY() + curHeight))
        -- end
        local screenSize = cc.Director:getInstance():getWinSize()
        local rootPos = fwin:convertToWorldSpace(root, cc.p(0, 0))
        if rootPos.y + Image_djxx_bg:getContentSize().height * app.scaleFactor > screenSize.height then
            root:setPositionY(root:getPositionY() - rootPos.y / app.scaleFactor - Image_djxx_bg:getContentSize().height + screenSize.height / app.scaleFactor - 10)
        end
        if rootPos.x + Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 > screenSize.width then
            root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor - Image_djxx_bg:getContentSize().width / 2 + screenSize.width / app.scaleFactor - 10)
        end
        if rootPos.x - Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 < 0 then
            root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor + Image_djxx_bg:getContentSize().width / 2)
        end
        if nil == self.widget then
            root:setPosition(cc.p(screenSize.width / app.scaleFactor / 2, screenSize.height / app.scaleFactor / 2 - Image_djxx_bg:getContentSize().height / 2))
        end
    end
end

function vouchersInformation:onEnterTransitionFinish()
    local csbItem = csb.createNode("packs/warehouse_information_1.csb")
    local root = csbItem:getChildByName("root")

    if
        __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or
            __lua_project_id == __lua_project_l_naruto
     then
    else
        local action = csb.createTimeline("packs/warehouse_information.csb")
        action:gotoFrameAndPlay(0, action:getDuration(), false)
        csbItem:runAction(action)
    end

    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Panel_dj_xx"),
        nil,
        {func_string = [[state_machine.excute("vouchers_info_cell_close", 0, "click vouchers_info_cell_close.'")]]},
        nil,
        0
    )
    self:onUpdateDraw()
end

function vouchersInformation:onExit()
    state_machine.remove("vouchers_info_cell_close")
end

function vouchersInformation:init(prop, types, widget)
    self.prop = prop
    self.type = types -- 1 代金券

    self.widget = widget
    if nil ~= widget then
        local pos = fwin:convertToWorldSpace(widget, cc.p(0, 0))
        local anchor = widget:getAnchorPoint()
        local size = widget:getContentSize()
        pos.x = pos.x / app.scaleFactor + size.width / 2 -- (size.width * anchor.x)
        -- pos.y = pos.y + (size.height * anchor.y) + 50
        pos.y = pos.y / app.scaleFactor + size.height - 25 * app.scaleFactor
        self:setPosition(pos)
    else
        --self:setPosition(cc.p(fwin._width / 2, fwin._height / 2))
    end
end

function vouchersInformation:createCell()
    local cell = vouchersInformation:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
