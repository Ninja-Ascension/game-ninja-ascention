----------------------------------------------------------------------------------------------------
-- 说明:一键探索完成
----------------------------------------------------------------------------------------------------
FileIslandAllFinishRegularCell = class("FileIslandAllFinishRegularCellClass", Window)
FileIslandAllFinishRegularCell.__size = nil

function FileIslandAllFinishRegularCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")

	local function init_fileIsland_all_finish_regular_cell_terminal()
		-- -- 点击cell
		local fileIsland_all_finish_window_goto_next_terminal = {
            _name = "fileIsland_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local id = instance.ids[1]
                state_machine.excute("fileIsland_window_all_finish_update", 0, {id or 0, 1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fileIsland_all_finish_window_goto_next_terminal)
        state_machine.init()
	end

	init_fileIsland_all_finish_regular_cell_terminal()
end

function FileIslandAllFinishRegularCell:onUpdateDraw()
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

    local Text_explore_all_finish_num = ccui.Helper:seekWidgetByName(root, "Text_explore_all_finish_num")

    local paths = {
        {"images/ui/text/TS/sj_gdjl_text_1.png", "images/ui/text/TS/sj_gdjl_text.png"}, 
        [3] = {"images/ui/text/TS/sj_bx_1_1.png", "images/ui/text/TS/sj_bx_1_1_1.png"}, 
        [4] = {"images/ui/text/TS/sj_wh_5_1.png", "images/ui/text/TS/sj_wh_5_1_2.png"}, 
        [5] = {"images/ui/text/TS/sj_gw_2_1.png", "images/ui/text/TS/sj_gw_2_1_1.png"}, 
    }
    
    for i = 1, 4 do
        local img = imgs[i]
        if i == 1 then
            img:loadTexture(paths[i][2])
        else
            if self.ids[i - 1] then
                local pic_index = 1 --(tonumber(self.id) == tonumber(self.ids[i - 1])) and 2 or 1
                img:loadTexture(paths[tonumber(self.ids[i - 1])][pic_index])
                img:setVisible(true)
                img_arrows[i - 1]:setVisible(true)
            else
                img:setVisible(false)
                img_arrows[i - 1]:setVisible(false)
            end
        end
    end

    Text_explore_all_finish_num:setString(string.format(tipStringInfo_file_island_tips[5], table.nums(_ED.fileIsland_search_result.resultArray)))
end

function FileIslandAllFinishRegularCell:onInit()
    local csbNode = csb.createNode("campaign/explore/explore_all_finish_regular_cell.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:drawUI()
    self:onUpdateDraw()
end

function FileIslandAllFinishRegularCell:drawUI()
    local root = self.roots[1]
    local index = 1
    for i=1,5 do
        if _ED.eventIds[i] then
            local Panel_random = ccui.Helper:seekWidgetByName(root, "Panel_random_" .. index)
            local Text_event_name = ccui.Helper:seekWidgetByName(root, "Text_event_name_" .. index)
            local Text_event_num = ccui.Helper:seekWidgetByName(root, "Text_event_num_" .. index)
            local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_" .. index)

            Text_event_name:setString(tipStringInfo_file_island_event_name_tips[i])
            Text_event_num:setString("x" .. table.nums(_ED.eventIds[i]))
            Panel_icon:setBackGroundImage(string.format("images/ui/text/TS/sj_regular_%d.png", i))
            Panel_random:setVisible(true)
            index = index + 1
        end
    end

    for i = index, 5 do
        local Panel_random = ccui.Helper:seekWidgetByName(root, "Panel_random_" .. i)
        Panel_random:setVisible(false)
    end

    local Text_regular_ex_n = ccui.Helper:seekWidgetByName(root, "Text_regular_ex_n")
    local Text_regular_jb_n = ccui.Helper:seekWidgetByName(root, "Text_regular_jb_n")
    local Text_regular_tsb_n = ccui.Helper:seekWidgetByName(root, "Text_regular_tsb_n")
    local rewordInfo = getSceneReward(71) -- 探索就是74

    for i,info in ipairs(rewordInfo.show_reward_list) do
        if tonumber(info.prop_type) == 8 then
            Text_regular_ex_n:setString("x " .. info.item_value)
        elseif tonumber(info.prop_type) == 1 then
            Text_regular_jb_n:setString("x " .. info.item_value)
        elseif tonumber(info.prop_type) == 68 then
            Text_regular_tsb_n:setString("x " .. info.item_value)
        end
    end
   
end

function FileIslandAllFinishRegularCell:init(params)
    self.ids = params
    self:onInit()
end

function FileIslandAllFinishRegularCell:createCell()
	local cell = FileIslandAllFinishRegularCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


