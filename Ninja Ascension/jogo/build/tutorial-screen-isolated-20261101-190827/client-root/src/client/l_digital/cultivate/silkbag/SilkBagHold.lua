----------------------------------------------------------------------------------------------------
-- 锦囊道具类的提示信息
----------------------------------------------------------------------------------------------------
SilkBagHold = class("SilkBagHoldClass", Window)

function SilkBagHold:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.types = nil		-- 当前要绘制的道具实例数据对对象
    
    app.load("client.l_digital.cultivate.silkbag.SilkBagHandler")
    local function init_silk_bag_hold_terminal()
		local silk_bag_hold_close_terminal = {
            _name = "silk_bag_hold_close",
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
		
		state_machine.add(silk_bag_hold_close_terminal)
		
        state_machine.init()
	end
	init_silk_bag_hold_terminal()
end

function SilkBagHold:onUpdateDraw()
	local root = self.roots[1]
	local di_kuang = ccui.Helper:seekWidgetByName(root, "Panel_alloy_infor_hold_formation")
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_infor_hold_icon")
	local name = ccui.Helper:seekWidgetByName(root, "Text_alloy_infor_hold_name")
	local Text_infor_hold_lv_n = ccui.Helper:seekWidgetByName(root, "Text_infor_hold_lv_n")
    local Text_alloy_hold_atk_t_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_atk_t_0")
	local Text_alloy_hold_atk_n_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_atk_n_0")
	local Text_alloy_hold_hp_t_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_hp_t_0")
    local Text_alloy_hold_hp_n_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_hp_n_0")
    local Text_alloy_hold_sudu_t_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_sudu_t_0")
    local Text_alloy_hold_sudu_n_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_sudu_n_0")
    local Text_alloy_hold_jiac_t_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_jiac_t_0")
    local Text_alloy_hold_jiac_n_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_jiac_n_0")
    local Text_alloy_hold_baoji_t_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_baoji_t_0")
    local Text_alloy_hold_baoji_n_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_baoji_n_0")
    local Text_introduction = ccui.Helper:seekWidgetByName(root, "Text_introduction")

    Text_alloy_hold_atk_t_0:setVisible(false)
    Text_alloy_hold_atk_n_0:setVisible(false)
    Text_alloy_hold_hp_t_0:setVisible(false)
    Text_alloy_hold_hp_n_0:setVisible(false)
    Text_alloy_hold_sudu_t_0:setVisible(false)
    Text_alloy_hold_sudu_n_0:setVisible(false)
    Text_alloy_hold_jiac_t_0:setVisible(false)
    Text_alloy_hold_jiac_n_0:setVisible(false)
    Text_alloy_hold_baoji_t_0:setVisible(false)
    Text_alloy_hold_baoji_n_0:setVisible(false)
    Text_introduction:setVisible(false)

    

	local cell = ResourcesIconCell:createCell()
    cell:init(71, 0, self.mouldId,nil,nil,false,false,1)
    di_kuang:addChild(cell)

    if self.info and nil ~= self.info[1] and nil ~= self.info[2] then
        --获取装备名称索引
        local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"],self.mouldId,ship_silk_bag_mould.silkbag_name)
        local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
        local prop_name = silkbag_name_word[3]
        name:setString(prop_name)

        quality = dms.int(dms["ship_silk_bag_mould"], self.mouldId,ship_silk_bag_mould.quality_level)
        quality = quality + 1
        name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))

        local level = tonumber(self.info[2])
        if level == 0 then
            level = 1
        end
        Text_infor_hold_lv_n:setString(level)
        
        local showpropretyNum = table.nums(self.info[1]) 

        for i=1,showpropretyNum do
            if 1 == i then
                Text_alloy_hold_atk_t_0:setString(self.info[1][i].property_name)
                Text_alloy_hold_atk_n_0:setString(self.info[1][i].property_value)
                Text_alloy_hold_atk_t_0:setVisible(true)
                Text_alloy_hold_atk_n_0:setVisible(true)
            elseif(2 == i ) then 
                Text_alloy_hold_hp_t_0:setString(self.info[1][i].property_name)
                Text_alloy_hold_hp_n_0:setString(self.info[1][i].property_value)
                Text_alloy_hold_hp_t_0:setVisible(true)
                Text_alloy_hold_hp_n_0:setVisible(true)
            elseif(3 == i ) then 
                Text_alloy_hold_sudu_t_0:setString(self.info[1][i].property_name)
                Text_alloy_hold_sudu_n_0:setString(self.info[1][i].property_value)
                Text_alloy_hold_sudu_t_0:setVisible(true)
                Text_alloy_hold_sudu_n_0:setVisible(true)
            end
        end

        --额外属性
        local extraGroups = dms.string(dms["ship_silk_bag_mould"],self.mouldId,ship_silk_bag_mould.extra_property)
        local extra_property_info  = zstring.split(extraGroups,"|")
        if -1 ~= tonumber(extra_property_info[1]) then
            for i=1,table.nums(extra_property_info) do

				local extra_property_per = zstring.split(extra_property_info[i],",")
				if nil ~= extra_property_per then
                    local strData = tipStringInfo_rescue_silkbag_property[tostring(extra_property_per[1])]
                    local str = ""
                    local flag = string.find(strData,"%%d")
                    if nil ~= flag then
                        str = string.format(strData,tonumber(extra_property_per[2])).."%"
                    else
                        str = strData..extra_property_per[2]
                    end
                    local text_info = zstring.split(str,":")
                    if 1 == i then
                        Text_alloy_hold_jiac_t_0:setVisible(true)
                        Text_alloy_hold_jiac_n_0:setVisible(true)
                        Text_alloy_hold_jiac_t_0:setString(text_info[1]..":")
                        Text_alloy_hold_jiac_n_0:setString(text_info[2])
                    elseif 2 == i then
                        Text_alloy_hold_baoji_t_0:setVisible(true)
                        Text_alloy_hold_baoji_n_0:setVisible(true)
                        Text_alloy_hold_baoji_t_0:setString(text_info[1]..":")
                        Text_alloy_hold_baoji_n_0:setString(text_info[2])
                    end
				end
            end
        end
        local mouldType = dms.int(dms["ship_silk_bag_mould"],self.mouldId,ship_silk_bag_mould.mould_type)
        -- 专属道具
        if mouldType == 2 then
            local str = self:getExcluseSkill(self.mouldId)
            if str then
                Text_introduction:setVisible(true)
                Text_introduction:setString(str)
            end
        end
    else
        --获取装备名称索引
        local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"],self.mouldId,ship_silk_bag_mould.silkbag_name)
        local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
        local prop_name = silkbag_name_word[3]
        name:setString(prop_name)

        quality = dms.int(dms["ship_silk_bag_mould"], self.mouldId,ship_silk_bag_mould.quality_level)
        quality = quality + 1
        name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
        
        local level = 1
        Text_infor_hold_lv_n:setString(level)
        
        local labelArray = {
            { Text_alloy_hold_atk_t_0, Text_alloy_hold_atk_n_0 },
            { Text_alloy_hold_hp_t_0, Text_alloy_hold_hp_n_0 },
            { Text_alloy_hold_sudu_t_0, Text_alloy_hold_sudu_n_0 },
        }

        local property_info = dms.string(dms["ship_silk_bag_mould"],self.mouldId,ship_silk_bag_mould.base_property)
        if nil ~= property_info then
            local add_property_info = zstring.split(property_info,"|")
            for i = 1, table.nums(add_property_info) do
                local add_property_per = zstring.split(add_property_info[i],",")
                if nil ~= add_property_per then
                    local label = labelArray[i]
                    if label and label[1] and label[2] then

                        local prop_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                        local property_value = add_property_per[2]
                        label[1]:setVisible(true)
                        label[2]:setVisible(true)
                        label[1]:setString(prop_name)
                        label[2]:setString(property_value)
                    end
                end
            end
        end

        --额外属性
        local extraGroups = dms.string(dms["ship_silk_bag_mould"],self.mouldId,ship_silk_bag_mould.extra_property)
        local extra_property_info  = zstring.split(extraGroups,"|")
        if -1 ~= tonumber(extra_property_info[1]) then
            for i=1,table.nums(extra_property_info) do

				local extra_property_per = zstring.split(extra_property_info[i],",")
				if nil ~= extra_property_per then
                    local strData = tipStringInfo_rescue_silkbag_property[tostring(extra_property_per[1])]
                    local str = ""
                    local flag = string.find(strData,"%%d")
                    if nil ~= flag then
                        str = string.format(strData,tonumber(extra_property_per[2])).."%"
                    else
                        str = strData..extra_property_per[2]
                    end
                    local text_info = zstring.split(str,":")
                    if 1 == i then
                        Text_alloy_hold_jiac_t_0:setVisible(true)
                        Text_alloy_hold_jiac_n_0:setVisible(true)
                        Text_alloy_hold_jiac_t_0:setString(text_info[1]..":")
                        Text_alloy_hold_jiac_n_0:setString(text_info[2])
                    elseif 2 == i then
                        Text_alloy_hold_baoji_t_0:setVisible(true)
                        Text_alloy_hold_baoji_n_0:setVisible(true)
                        Text_alloy_hold_baoji_t_0:setString(text_info[1]..":")
                        Text_alloy_hold_baoji_n_0:setString(text_info[2])
                    end
				end
            end
        end
        local mouldType = dms.int(dms["ship_silk_bag_mould"],self.mouldId,ship_silk_bag_mould.mould_type)
        -- 专属道具
        if mouldType == 2 then
            local str = self:getExcluseSkill(self.mouldId)
            if str then
                Text_introduction:setVisible(true)
                Text_introduction:setString(str)
            end
        end
    end
    
    local Image_djxx = ccui.Helper:seekWidgetByName(root, "Image_matrix_infor_hold_attr_hp_bg")
    local Image_djxx_bg = ccui.Helper:seekWidgetByName(root, "Image_djxx_bg")

	local screenSize = cc.Director:getInstance():getWinSize() 
	local rootPos = fwin:convertToWorldSpace(root, cc.p(0, 0))
	if rootPos.y + Image_djxx_bg:getContentSize().height * app.scaleFactor > screenSize.height then
		root:setPositionY(root:getPositionY() - rootPos.y / app.scaleFactor - Image_djxx_bg:getContentSize().height + screenSize.height / app.scaleFactor - 10)
	end
	if rootPos.x + Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 > screenSize.width then
		root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor - Image_djxx_bg:getContentSize().width / 2 + screenSize.width / app.scaleFactor - 10 )
	end
	if rootPos.x - Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 < 0 then
		root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor + Image_djxx_bg:getContentSize().width / 2)
	end
	if nil == self.widget then
		root:setPosition(cc.p(screenSize.width / app.scaleFactor / 2, screenSize.height / app.scaleFactor / 2 - Image_djxx_bg:getContentSize().height / 2))
	end
end

--获得专属技能描述
function SilkBagHold:getExcluseSkill(silkMouldId)
    local totalScrip = nil
    local excluseInfos = dms.string(dms["ship_silk_bag_mould"],tonumber(silkMouldId),ship_silk_bag_mould.exclusive_skill)
    if "-1" == tostring(excluseInfos) then
        return nil
    end
    local protectLv = SilkBagHandler.getProtectLv(nil)
    local excluseGroups = nil
    local excluseList = zstring.split(excluseInfos,"|")
    for i,v in ipairs(excluseList) do 
        if "-1" ~= tostring(v) then
            if i == tonumber(protectLv) then 
                excluseGroups = v
                break
            end
        end
    end

    if excluseGroups == nil then 
        return nil
    end

    local str = "" 
    local excluseInfoGroups = zstring.split(excluseGroups,",")
    local describeCallback = function (word_id)
        if word_id ~= "-1" then 
            local word_info = dms.element(dms["word_mould"], tonumber(word_id))
            if word_info ~= nil then 
                local desName = word_info[3]
                str = str .. tostring(desName)
            end
        end
    end
    for k,v in pairs(excluseInfoGroups) do
        local skillNameId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_name)
        local skillDescribeId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_describe)
        describeCallback(skillNameId)
        describeCallback(skillDescribeId)
    end
    if "" == str then
        return nil
    end
    return str
end

function SilkBagHold:onEnterTransitionFinish()
	local csbItem = csb.createNode("cultivate/silk_bag_infor_hold_cell.csb")
	local root = csbItem:getChildByName("root")

	self:addChild(csbItem)
	table.insert(self.roots, root)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_matrix_infor_hold_box"), nil, {func_string = [[state_machine.excute("silk_bag_hold_close", 0, "click silk_bag_hold_close.'")]]}, nil, 0)
	self:onUpdateDraw()
	
end

function SilkBagHold:onExit()
    state_machine.remove("silk_bag_hold_close")
end

function SilkBagHold:init(types, mouldId ,info, widget)
    self.types = types
    self.mouldId = mouldId
	self.info = info
	self.widget = widget
	if nil ~= self.widget then
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

function SilkBagHold:createCell()
	local cell = SilkBagHold:new()
	cell:registerOnNodeEvent(cell)
	return cell
end