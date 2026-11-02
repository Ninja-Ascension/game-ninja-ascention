--------------------------------------------------------------------------------------------------------------
--  说明：军团捐献的内容
--------------------------------------------------------------------------------------------------------------
unionInstituteDonateListCell = class("unionInstituteDonateListCellClass", Window)
unionInstituteDonateListCell.__size = nil
function unionInstituteDonateListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	 -- Initialize union rank list cell state machine.
    local function init_union_institute_donate_list_cell_terminal()
        local union_institute_donate_list_cell_open_donation_terminal = {
            _name = "union_institute_donate_list_cell_open_donation",
            _init = function (terminal)
               app.load("client.l_digital.union.heaven.UnionHeaven")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		local cell = params._datas.cell
           		local science_info = zstring.split(_ED.union_science_info,"|")
           		local all = zstring.split(science_info[1],",")
    			local maxNumber = dms.int(dms["union_config"], 18, union_config.param)
    			if (maxNumber - tonumber(all[4])) <= 0 then
    				TipDlg.drawTextDailog(_new_interface_text[63])
    				return
    			end

				state_machine.excute("union_heaven_open", 0, tonumber(cell.index))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_institute_donate_list_cell_update_draw_terminal = {
            _name = "union_institute_donate_list_cell_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_institute_donate_list_cell_open_donation_terminal)
		state_machine.add(union_institute_donate_list_cell_update_draw_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_institute_donate_list_cell_terminal()

end

function unionInstituteDonateListCell:updateDraw()
	local root = self.roots[1]
	if self.index == 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_open"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_open_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_lock"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_closed"):setVisible(true)
		return
	else
		ccui.Helper:seekWidgetByName(root, "Panel_open"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_open_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_lock"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_closed"):setVisible(false)
	end
	local science_info = zstring.split(_ED.union_science_info,"|")
    local hall_technology = zstring.split(science_info[tonumber(self.index)],",")
    -- 当前等级，当前经验，今天获得的总经验，（第一个科技表示全部科技使用次数）已经使用的次数，改变次数|
	--科技名称
	local Text_kj_name = ccui.Helper:seekWidgetByName(root, "Text_kj_name")
	local name = dms.string(dms["union_science_mould"], self.index, union_science_mould.name)
	Text_kj_name:setString(name)
	--科技等级
	local Text_kj_lv = ccui.Helper:seekWidgetByName(root, "Text_kj_lv")
	Text_kj_lv:setString("Lv."..hall_technology[1])
	--科技经验
	local LoadingBar_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp")
	local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")
	--通过科技类型找到科技模板的库组
    local parameter_group = dms.int(dms["union_science_mould"], tonumber(self.index), union_science_mould.parameter_group)
    --通过参数库组找到对应de经验参数表数据
    local expMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
    local expData = nil
    for i, v in pairs(expMould) do
        if tonumber(hall_technology[1]) == tonumber(v[3]) then
            expData = v
            break
        end
    end
    local expDataNext = nil
    for i, v in pairs(expMould) do
        if tonumber(hall_technology[1])+1 == tonumber(v[3]) then
            expDataNext = v
            break
        end
    end
    maxMember = tonumber(expData[4])
    Text_exp:setString(hall_technology[2].."/"..maxMember)
    local persent = math.floor(tonumber(hall_technology[2])/maxMember*100)
    LoadingBar_exp:setPercent(persent)
    if maxMember == -1 then
    	Text_exp:setString("")
    	LoadingBar_exp:setPercent(100)
    end

	--科技图片
	for i=1, 5 do
		ccui.Helper:seekWidgetByName(root, "Image_kj_icon_"..i):setVisible(false)
	end
	local number = 0
	if self.m_type == 1 then
		number = self.index - 1
	elseif self.m_type == 2 then
		number = self.index - 3
	elseif self.m_type == 3 then
		number = self.index - 5 + 2
	elseif self.m_type == 4 then
		number = self.index - 8
	end
	ccui.Helper:seekWidgetByName(root, "Image_kj_icon_"..number):setVisible(true)

	local openLevel = dms.int(dms["union_science_mould"], self.index, union_science_mould.open_level)
	if openLevel > tonumber(_ED.union.union_info.union_grade) then
		ccui.Helper:seekWidgetByName(root, "Panel_open_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_lock"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_open_lv_info"):setString(string.format(_new_interface_text[62],openLevel))
	else
		ccui.Helper:seekWidgetByName(root, "Panel_open_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_lock"):setVisible(false)
	end
	--当前等级说明
	local Text_bj_info = ccui.Helper:seekWidgetByName(root, "Text_bj_info")
	--下一等级说明
	local Text_xj_info = ccui.Helper:seekWidgetByName(root, "Text_xj_info")
	local max_level = dms.int(dms["union_science_mould"], self.index, union_science_mould.max_level)
	local data = zstring.split(expData[5], ",") 
	local newStr = ""
	if #data > 1 then
		newStr = string.format(expData[7],zstring.tonumber(data[1]),zstring.tonumber(data[2]))
	else
		newStr = string.format(expData[7],zstring.tonumber(data[1]))
	end
	newStr = string.gsub(newStr, "|", "\r\n")
	Text_bj_info:setString(newStr)
	if tonumber(hall_technology[1]) < max_level and aaaaa ~= nil then
		ccui.Helper:seekWidgetByName(root, "Text_xj_info"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_3_0_0"):setVisible(true)

		local nextData = zstring.split(expDataNext[5], ",") 
		local nextStr = ""
		if #nextData > 1 then
			nextStr = string.format(expData[7],zstring.tonumber(nextData[1]),zstring.tonumber(nextData[2]))
		else
			nextStr = string.format(expData[7],zstring.tonumber(nextData[1]))
		end
		nextStr = string.gsub(nextStr, "|", "\r\n")
		Text_xj_info:setString(nextStr)

	else
		ccui.Helper:seekWidgetByName(root, "Text_xj_info"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_3_0_0"):setVisible(false)
	end
	local science_info = zstring.split(_ED.union_science_info,"|")
	local all = zstring.split(science_info[1],",")
	local maxNumber = dms.int(dms["union_config"], 18, union_config.param)
	if (maxNumber - tonumber(all[4])) <= 0 then
		ccui.Helper:seekWidgetByName(root,"Button_juanxian_2"):setBright(false)
	else
		ccui.Helper:seekWidgetByName(root,"Button_juanxian_2"):setBright(true)
	end
end

function unionInstituteDonateListCell:onInit()

	local csbunionInstituteDonateListCell= csb.createNode("legion/sm_legion_research_institute_donate_list.csb")
    local root = csbunionInstituteDonateListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	 
    self:addChild(csbunionInstituteDonateListCell)
	if unionInstituteDonateListCell.__size == nil then
		unionInstituteDonateListCell.__size = root:getChildByName("Panel_bg"):getContentSize()
	end	
	
	--进入捐赠
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juanxian_2"), nil, 
    {
        terminal_name = "union_institute_donate_list_cell_open_donation", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:updateDraw()
end

function unionInstituteDonateListCell:onEnterTransitionFinish()

end

function unionInstituteDonateListCell:init(index,m_type)
	self.index = tonumber(index)
	self.m_type = tonumber(m_type)
	self:onInit()
	self:setContentSize(unionInstituteDonateListCell.__size)
	-- self:onInit()
	return self
end

function unionInstituteDonateListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionInstituteDonateListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_research_institute_donate_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function unionInstituteDonateListCell:onExit()
	cacher.freeRef("legion/sm_legion_research_institute_donate_list.csb", self.roots[1])
end

function unionInstituteDonateListCell:createCell()
	local cell = unionInstituteDonateListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
