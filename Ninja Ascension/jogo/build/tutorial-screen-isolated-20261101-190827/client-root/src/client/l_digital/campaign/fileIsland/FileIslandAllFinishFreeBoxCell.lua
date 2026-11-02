----------------------------------------------------------------------------------------------------
-- 说明:一键探索完成
----------------------------------------------------------------------------------------------------
FileIslandAllFinishFreeBoxCell = class("FileIslandAllFinishFreeBoxCellClass", Window)
FileIslandAllFinishFreeBoxCell.__size = nil

function FileIslandAllFinishFreeBoxCell:ctor()
    self.super:ctor()
	self.roots = {}

	local function init_fileIsland_all_finish_free_box_cell_terminal()
		-- -- 点击cell
		local fileIsland_all_finish_window_goto_next_terminal = {
            _name = "fileIsland_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fileIsland_window_all_finish_update", 0, {instance.id, 2})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fileIsland_all_finish_window_goto_next_terminal)
        state_machine.init()
	end

	init_fileIsland_all_finish_free_box_cell_terminal()
end

function FileIslandAllFinishFreeBoxCell:onUpdateDraw()
    local root = self.roots[1]
    local img_1 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_0")
    local img_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0")
    local img_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0")
    local img_4 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_1")
    local imgs = {img_1, img_2, img_3, img_4}
    
    local img_arrow_1 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1")
    local img_arrow_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0")
    local img_arrow_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0_0")
    local img_arrows = {img_arrow_1, img_arrow_2, img_arrow_3}
    local Text_explore_all_finish_num_0 = ccui.Helper:seekWidgetByName(root, "Text_explore_all_finish_num_0")

    local paths = {
        {"images/ui/text/TS/sj_gdjl_text_1.png", "images/ui/text/TS/sj_gdjl_text.png"}, 
        [3] = {"images/ui/text/TS/sj_bx_1_1.png", "images/ui/text/TS/sj_bx_1_1_1.png"}, 
        [4] = {"images/ui/text/TS/sj_wh_5_1.png", "images/ui/text/TS/sj_wh_5_1_2.png"}, 
        [5] = {"images/ui/text/TS/sj_gw_2_1.png", "images/ui/text/TS/sj_gw_2_1_1.png"}, 
    }

    for i = 1, 4 do
        local img = imgs[i]
        if i == 1 then
            img:loadTexture(paths[i][1])
        else
            if self.ids[i - 1] then
                local pic_index = (tonumber(self.id) == tonumber(self.ids[i - 1])) and 2 or 1
                img:loadTexture(paths[tonumber(self.ids[i - 1])][pic_index])
                img:setVisible(true)
                img_arrows[i - 1]:setVisible(true)
            else
                img:setVisible(false)
                img_arrows[i - 1]:setVisible(false)
            end
        end
    end
    ccui.Helper:seekWidgetByName(root, "Panel_explore_all_finish_jl"):setVisible(self.is_all)
    Text_explore_all_finish_num_0:setString(table.nums(_ED.eventIds[self.id]))
    self:drawReword()
end

function FileIslandAllFinishFreeBoxCell:drawReword()
    local root = self.roots[1]
    local rewardInfo = getSceneReward(72).show_reward_list
    local max_num = table.nums(rewardInfo)
    local ScrollView_41 = ccui.Helper:seekWidgetByName(root, "ScrollView_free_box")
    local panel = ScrollView_41:getInnerContainer()
    panel:setContentSize(ScrollView_41:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local tHeight = 0
    local tWidth = 0
    local wPosition = sSize.width/5
    local Hlindex = 0
    local m_number = max_num
    local cellHeight = 0
    local cellWidth = 0
    index = 0
    cellHeight = m_number/5*(ScrollView_41:getContentSize().height/2)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_41:getContentSize().width, sHeight)
    ScrollView_41:jumpToTop()
    local function addReward( sender )
        if index >= max_num then
            -- ccui.Helper:seekWidgetByName(root, "Panel_15"):setVisible(true)
            return
        end
        playEffect(formatMusicFile("effect", 9988))
        index = index + 1
        local info = rewardInfo[index]
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info.prop_type, info.prop_item, info.item_value},true,true,false,true})

        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (index - 1)%5 == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - wPosition * Hlindex
            if Hlindex >= 20 then
                ScrollView_41:scrollToPercentVertical(100, 0, false)
            elseif Hlindex >= 18 then
                ScrollView_41:scrollToPercentVertical((Hlindex - 5/Hlindex)*100/m_number, 0, false)
            elseif Hlindex >= 3 then
                ScrollView_41:scrollToPercentVertical((Hlindex - 8/Hlindex)*100/m_number, 0, false)
            end
        end
        if index <= 5 then
            tHeight = sHeight - wPosition
        end

        cell:setPosition(cc.p(tWidth, tHeight + 10))
        cell:setScale(0.1)
        local seq = cc.Sequence:create(
            cc.ScaleTo:create(0.12, 1.2),
            cc.ScaleTo:create(0.02, 1),
            cc.CallFunc:create(addReward)
         )
        cell:runAction(seq)
    end
    addReward(self)
end

function FileIslandAllFinishFreeBoxCell:onInit()
    local csbNode = csb.createNode("campaign/explore/explore_all_finish_free_box_cell.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function FileIslandAllFinishFreeBoxCell:clearUIInfo()
end

function FileIslandAllFinishFreeBoxCell:init(params)
    self.id = params[1]
    self.ids = params[2]
    self.is_all = params[3]
    self:onInit()
end

function FileIslandAllFinishFreeBoxCell:createCell()
	local cell = FileIslandAllFinishFreeBoxCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


