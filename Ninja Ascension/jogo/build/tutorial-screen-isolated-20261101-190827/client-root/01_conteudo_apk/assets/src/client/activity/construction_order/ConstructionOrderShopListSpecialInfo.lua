--[[ ----------------------------------------------------------------------------
-- 特殊商品详细界面
--]] ----------------------------------------------------------------------------
ConstructionOrderShopListSpecialInfo = class("ConstructionOrderShopListSpecialInfoClass", Window)

-- 打开窗口
local construction_order_shop_list_special_info_window_open_terminal = {
    _name = "construction_order_shop_list_special_info_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ConstructionOrderShopListSpecialInfoClass") then
            fwin:open(ConstructionOrderShopListSpecialInfo:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local construction_order_shop_list_special_info_window_close_terminal = {
    _name = "construction_order_shop_list_special_info_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ConstructionOrderShopListSpecialInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_shop_list_special_info_window_open_terminal)
state_machine.add(construction_order_shop_list_special_info_window_close_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderShopListSpecialInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.allShopInfo = {}
    self.itemInfo = {}

    self.index = 0          -- 当前下标
    self.productID = 0
    self.productType = 0
    self.enum_type = {
		PROP_INFORMATION = 6,						--	6:道具 
		EQUIPMENT_INFORMATION = 7,					--	7:装备 
        HERO_SKIN = 64,                             -- 64:皮肤
		SILKBAG_INFORMATION=71,						-- 71:锦囊(圣器)
		HEAD_FRAME = 76,							-- 76:头像框
    }
    app.load("client.packs.prop.ComExchange")
    -- Initialize construction_order_shop_list_special_info page state machine.
    local function init_construction_order_shop_list_special_info_terminal()
        -- 打开角色创建窗口
        local construction_order_shop_list_special_info_open_terminal = {
            _name = "construction_order_shop_list_special_info_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭角色创建窗口
        local construction_order_shop_list_special_info_close_terminal = {
            _name = "construction_order_shop_list_special_info_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local construction_order_shop_list_special_info_show_terminal = {
            _name = "construction_order_shop_list_special_info_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local construction_order_shop_list_special_info_hide_terminal = {
            _name = "construction_order_shop_list_special_info_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买商品
        local construction_order_shop_list_special_info_buy_terminal = {
            _name = "construction_order_shop_list_special_info_buy",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 购买商品
                if nil ~= instance then
                    local cell = params._datas.cell
                    local prop = cell.prop
                    -- print(prop.prop_number, "=====prop.prop_number", prop.remainCounts)
                    if prop.remainCounts <= 0 then
                        TipDlg.drawTextDailog(war_order_str[19])
                        return false
                    end
                    if prop.prop_number <= 0 then
                        TipDlg.drawTextDailog(war_order_str[13])
                        return false
                    end
                    cell.shopType = 2
                    cell.form_cell = "construction_order_shop"
					state_machine.excute("com_exchange_use_open",0,cell)
                    -- state_machine.excute("construction_order_shop_list_special_info_window_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --  左滑右滑切换内容按钮
        local construction_order_shop_list_special_info_change_page_terminal = {
            _name = "construction_order_shop_list_special_info_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 左滑右滑切换内容按钮
                if nil ~= instance then
                    local addIdx = params._datas.index
                    self:updateIndex(addIdx)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 浏览皮肤属性面板
        local construction_order_shop_list_special_info_show_skin_properties_terminal = {
            _name = "construction_order_shop_list_special_info_show_skin_properties",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and params ~= nil then
                    instance:controlShowPropertiyPanel(params._datas.isShow)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_shop_list_special_info_open_terminal)
        state_machine.add(construction_order_shop_list_special_info_close_terminal)
        state_machine.add(construction_order_shop_list_special_info_show_terminal)
        state_machine.add(construction_order_shop_list_special_info_hide_terminal)
        state_machine.add(construction_order_shop_list_special_info_buy_terminal)
        state_machine.add(construction_order_shop_list_special_info_change_page_terminal)
        state_machine.add(construction_order_shop_list_special_info_show_skin_properties_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_construction_order_shop_list_special_info_terminal()
end

function ConstructionOrderShopListSpecialInfo:updateDrawContent()
    
    self.Panel_effect_role:removeAllChildren(true)
    self.Panel_effect_props:removeAllChildren(true)
    self.Panel_effect_props:removeBackGroundImage()

    local isSkinType = self.productType == self.enum_type.HERO_SKIN
    self.Button_5:setVisible(isSkinType)
    self.Image_4:setVisible(isSkinType)
    self.Image_5:setVisible(not isSkinType)
    self.Text_name:setString(self.prop.mould_name)

    local descText = self:getDescByTypeAndID()
    self.Text_role:setString(descText)

    -- 绘制右侧皮肤动画/道具图片
    self:updateDrawRightContent()
    -- 绘制消耗道具内容
    self:updateDrawCostContent()
end

-- 获取描述
function ConstructionOrderShopListSpecialInfo:getDescByTypeAndID()
    local mouldID = self.prop.mould_id
    local desc = ""
    local descIdx = 0
    if self.productType == self.enum_type.HERO_SKIN then
        local mouldID = self.prop.mould_id
        local descInfoString = dms.string(dms["ship_skin_mould"], mouldID, ship_skin_mould.word_idx)
        local descInfo = zstring.split(descInfoString, ',', function ( value ) return tonumber(value) end)
        descIdx = descInfo[2]
        desc = self:getWordByIndex(descIdx)
    elseif self.productType == self.enum_type.HEAD_FRAME then
        local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, mouldID)[1]
        descIdx = dms.atoi(headFrameInfo, face_frame_mould.descID)
        desc = self:getWordByIndex(descIdx)
    elseif self.productType == self.enum_type.PROP_INFORMATION then
        desc = drawPropsDescription(mouldID)
    elseif self.productType == self.enum_type.EQUIPMENT_INFORMATION then
        desc = smEquipWordlFundByIndex(mouldID, 2)
    elseif self.productType == self.enum_type.SILKBAG_INFORMATION then
        descIdx = dms.int(dms["ship_silk_bag_mould"], mouldID, ship_silk_bag_mould.mould_describe)
        desc = self:getWordByIndex(descIdx)
    end

    return desc
end

function ConstructionOrderShopListSpecialInfo:getWordByIndex(descIdx)
    local desc = ""
    if descIdx ~= -1 then
        local wordInfo = dms.element(dms["word_mould"], descIdx)
        desc = dms.atos(wordInfo, word_mould.text_info)
    end

    return desc
end

-- 绘制右侧内容
function ConstructionOrderShopListSpecialInfo:updateDrawRightContent()
    if self.productType == self.enum_type.HERO_SKIN then
        self:initDrawAniamtion()
    else
        local picPath, effectIcon = self:getPropDrawInfo()
        local isPlayEffect = false
        if effectIcon ~= nil then
            isPlayEffect = true
            effectIcon:setPosition(cc.p(self.Panel_effect_props:getContentSize().width / 2, self.Panel_effect_props:getContentSize().height / 2))
            self.Panel_effect_props:addChild(effectIcon)
        end

        if true == cc.FileUtils:getInstance():isFileExist(picPath) and isPlayEffect == false then
            self.Panel_effect_props:setBackGroundImage(picPath)
        end
    end
end

-- 获取右侧道具绘制的内容
function ConstructionOrderShopListSpecialInfo:getPropDrawInfo()
    local mouldID = self.prop.mould_id
    local picIndex = -1
    local iconResPath = ""
    local jsonFile = ""
    local atlasFile = ""
    local effectIcon = nil

    if self.productType  == self.enum_type.HEAD_FRAME then
        local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, mouldID)[1]
        picIndex = dms.atoi(headFrameInfo, face_frame_mould.resID)
        iconResPath = string.format("image/cut/frame/cut_frame_%d.png", picIndex)
        local effectIndex = zstring.split(dms.atos(headFrameInfo, face_frame_mould.effectIDInfo), ",", tonumber)[1]
        jsonFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.json", effectIndex, effectIndex)
        atlasFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.atlas", effectIndex, effectIndex)
    elseif self.productType  == self.enum_type.PROP_INFORMATION then
        picIndex = setThePropsIcon(mouldID)[1]
        iconResPath = string.format("images/ui/props/props_%d.png", picIndex)
    elseif self.productType  == self.enum_type.EQUIPMENT_INFORMATION then
        picIndex = dms.int(dms["equipment_mould"], mouldID, equipment_mould.pic_index)
        iconResPath = string.format("images/ui/props/props_%d.png", picIndex)
    elseif self.productType  == self.enum_type.SILKBAG_INFORMATION then
        picIndex = dms.int(dms["ship_silk_bag_mould"], mouldID, ship_silk_bag_mould.pic_index)
        iconResPath = string.format("images/ui/props/props_%d.png", picIndex)
    end

    if jsonFile ~= "" and true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
        effectIcon = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    end
    
    return iconResPath, effectIcon
end

function ConstructionOrderShopListSpecialInfo:updateUI()
    self.Button_left:setVisible(false)
    self.Button_right:setVisible(false)

    if self.index == #self.allShopInfo then
        self.Button_left:setVisible(true)
    elseif self.index == 1 then
        self.Button_right:setVisible(true)
    else
        self.Button_right:setVisible(true)
        self.Button_left:setVisible(true)
    end
    -- debug.print_r(self.allShopInfo, "=====self.allShopInfo")
    -- print(self.index, "====index1111")
    self.itemInfo = self.allShopInfo[self.index]
    self.productID = self.itemInfo.productID
end

-- 有多个商品时
function ConstructionOrderShopListSpecialInfo:updateIndex(addIdx)
    if addIdx ~= nil then
        self.index = self.index + addIdx
        self.productID = self.index
    end
    self:updateUI()
    self:initPropData()
   
    self:updateDrawContent()
end

-- 只有一个商品时
function ConstructionOrderShopListSpecialInfo:initDrawOnePage()
    self:initPropData()
    
    self:updateDrawContent()
end

function ConstructionOrderShopListSpecialInfo:initPropData()
    local info = self.itemInfo
    -- debug.print_r(info.propInfo, "===============info")
	local prop_param = zstring.split(info.propInfo, ",", tonumber)
    local prop = {}
    local evo_mould_id = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.ship_evo_id)
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    local ship_mould_id = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.ship_mould_id)
    -- 商品类型
    prop.type = tonumber(prop_param[1])
    -- 类型对应的模板id
    prop.mould_id = tonumber(prop_param[2])
    -- 商品数量
    prop.number = tonumber(prop_param[3])

    self.productType = prop.type
    
    local nameInfo = getItemNameAndQuality(prop_param)
    prop.mould_name = nameInfo[1]
    prop.prop_quality = nameInfo[2]

	local costInfo = zstring.split(info.consumeProp, ",", function ( value ) return tonumber(value) end)
    prop.costInfo = costInfo
    -- 价格
    prop.sale_percentage = costInfo[3]
    -- 最大可购买次数
    self._maxTimes = self.exchangeCount
    --当前积分可以购买的次数
    local havePropNum = tonumber(getPropAllCountByMouldId(costInfo[2]))
    local may_num = math.floor(havePropNum / costInfo[3])
    prop.prop_number = may_num
    prop.remainCounts = info.remainCounts
    if may_num > info.remainCounts then
        prop.prop_number = info.remainCounts
    end
    prop.id = costInfo[2]
    self.prop = prop
end

function ConstructionOrderShopListSpecialInfo:updateDrawCostContent()
    
    local icon_index = dms.int(dms["prop_mould"], self.prop.id, prop_mould.pic_index)
	local resPath = string.format("image/common/currency/common_currency_%d.png", icon_index)
    self.Panel_cost:removeBackGroundImage()
	self.Panel_cost:setBackGroundImage(resPath)

    self.Text_price:setString(self.prop.sale_percentage)
end

function ConstructionOrderShopListSpecialInfo:onUpdateDraw()
    local root = self.roots[1]
    -- 角色内容文本
    self.Text_role = ccui.Helper:seekWidgetByName(root, "Text_2")
    -- 消耗道具内容
    self.Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
    -- 消耗道具价格
    self.Text_price = ccui.Helper:seekWidgetByName(root, "Text_3")
    -- 道具名称
    self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 属性列表
    self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
    self.ListView_2:removeAllItems()

    -- 皮肤动画容器
    self.Panel_effect_role =  ccui.Helper:seekWidgetByName(root, "Panel_effect_role")
    -- 皮肤容器底图
    self.Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
    -- 道具图片容器
    self.Panel_effect_props = ccui.Helper:seekWidgetByName(root, "Panel_effect_props")
    -- 道具容器底图
    self.Image_5 = ccui.Helper:seekWidgetByName(root, "Image_5")
    
    self.Button_5:setVisible(true)
    self.Button_hide_property:setVisible(false)
    
    -- debug.print_r(self.allShopInfo, "====self.allShopInfo")
    if #self.allShopInfo == 1 then
        self.Button_left:setVisible(false)
        self.Button_right:setVisible(false)
        self:initDrawOnePage()
    else
        self:updateIndex()
    end
end

-- 控制属性界面的显隐
function ConstructionOrderShopListSpecialInfo:controlShowPropertiyPanel(isShow)
    if isShow == true then
        if #self.ListView_2:getItems() == 0 then
            self:showSkinProperties()
        end
        self.ListView_2:setVisible(true)
        self.Button_hide_property:setVisible(true)
    else
        self.ListView_2:setVisible(false)
        self.Button_hide_property:setVisible(false)
    end
end

-- 绘制属性界面
function ConstructionOrderShopListSpecialInfo:showSkinProperties()
    local skinID = self.prop.mould_id
    local propertiesAllInfoString = dms.string(dms["ship_skin_mould"], skinID, ship_skin_mould.additional)
    local isAddPercentInfo = zstring.split(dms.string(dms["ship_skin_mould"], skinID, ship_skin_mould.add_percent), "|", tonumber)
    local propertiesInfoString = zstring.split(propertiesAllInfoString, "|")

    local listViewHeight = 0
    for i, v in ipairs(propertiesInfoString) do
        local propertiesInfo = zstring.split(v, ',', function ( value ) return tonumber(value) end)
        local cell = state_machine.excute("construction_order_property_list_create", 0, {propertyInfo = propertiesInfo, isAddPercent = isAddPercentInfo[i]})
        listViewHeight = listViewHeight + cell.roots[1]:getContentSize().height
        self.ListView_2:addChild(cell)
    end
    self.ListView_2:setContentSize(cc.size(self.ListView_2:getContentSize().width, listViewHeight))
    self.ListView_2:requestRefreshView()
    self.ListView_2:jumpToTop()
end

function ConstructionOrderShopListSpecialInfo:initDrawAniamtion()
    local root = self.roots[1]
    local mouldID = self.prop.mould_id
    local ship_evo_id = dms.int(dms["ship_skin_mould"], mouldID, ship_skin_mould.ship_evo_id)
    -- local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    -- local ship_mould_id = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.ship_mould_id)
    -- -- print(self.itemInfo.mould_id, "====self.itemInfo.mould_id")
    -- local skin_mould_rows = dms.searchs(dms["ship_skin_mould"], ship_skin_mould.ship_mould_id, self.itemInfo.mould_id)
    -- local ship_evo_id = skin_mould_rows[1][ship_skin_mould.ship_evo_id]
    local picIndex_pic = dms.int(dms["ship_evo_mould"], ship_evo_id, ship_evo_mould.form_id)
    local shipSpine = sp.spine_sprite(self.Panel_effect_role, picIndex_pic, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
end

-- 对象初始化
function ConstructionOrderShopListSpecialInfo:init(params)
    self.allShopInfo = params.shopInfo
    self.itemInfo = params.propInfo
    self.index = params.curIndex
    self.productID = params.productID
    -- print(self.index, "==========init")
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end


function ConstructionOrderShopListSpecialInfo:onEnterTransitionFinish()
   
    local csbNode = csb.createNode("shop/new_shop_role_details.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)


    -- 关闭规则界面
    self.Button_rule =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_1"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_info_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    -- 左滑按钮
    self.Button_left = 
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_3"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_info_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            index = -1,
            curIndex = self.index
        },
        nil,
        0
    )

    -- 右滑按钮
    self.Button_right = 
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_4"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_info_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            index = 1,
            curIndex = self.index
        },
        nil,
        0
    )

    -- 购买按钮
    self.Button_buy = 
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_2"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_info_buy",
            terminal_state = 0,
            isPressedActionEnabled = true,
            cell = self,
        },
        nil,
        0
    )

    
    -- 浏览皮肤属性
    self.Button_5 =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_5"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_info_show_skin_properties",
            terminal_state = 0,
            isPressedActionEnabled = true,
            isShow = true,
        },
        nil,
        0
    )


    -- 隐藏皮肤属性界面
    self.Button_hide_property =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Image_dianjifanwei"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_info_show_skin_properties",
            terminal_state = 0,
            isPressedActionEnabled = true,
            isShow = false,
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function ConstructionOrderShopListSpecialInfo:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("construction_order_shop_list_special_info_open")
    state_machine.remove("construction_order_shop_list_special_info_close")
    state_machine.remove("construction_order_shop_list_special_info_show")
    state_machine.remove("construction_order_shop_list_special_info_hide")
    state_machine.remove("construction_order_shop_list_special_info_buy")
    state_machine.remove("construction_order_shop_list_special_info_change_page")
    state_machine.remove("construction_order_shop_list_special_info_show_skin_properties")
    
end

function ConstructionOrderShopListSpecialInfo:close()
    -- window event : close.
end

function ConstructionOrderShopListSpecialInfo:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
