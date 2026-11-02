----------------------------------------------------------------------------------------------------
-- 说明:一键探索完成
----------------------------------------------------------------------------------------------------
ExplorationAllFinishRegularCell = class("ExplorationAllFinishRegularCellClass", Window)
ExplorationAllFinishRegularCell.__size = nil

function ExplorationAllFinishRegularCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinish")

	local function init_exploration_all_finish_regular_cell_terminal()
		-- -- 点击cell
		local exploration_all_finish_window_goto_next_terminal = {
            _name = "exploration_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local id = instance.ids[1]
                state_machine.excute("exploration_window_all_finish_update", 0, {id or 0, 1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(exploration_all_finish_window_goto_next_terminal)
        state_machine.init()
	end

	init_exploration_all_finish_regular_cell_terminal()
end

function ExplorationAllFinishRegularCell:onUpdateDraw()
    local root = self.roots[1]
    local img_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0")
    local img_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0")
    local img_4 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_1_0")
    local img_5 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_1")
    local imgs = {img_2, img_3, img_4, img_5}
    
    -- local img_arrow_1 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1")
    -- local img_arrow_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0")
    -- local img_arrow_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0_0")
    -- local img_arrows = {img_arrow_1, img_arrow_2, img_arrow_3}

    local Text_explore_all_finish_num = ccui.Helper:seekWidgetByName(root, "Text_explore_all_finish_num")

    local paths = {
        [1] = {"images/ui/text/exploration/event_bar_4.png", "images/ui/text/exploration/event_bar_3.png"}, 
        [6] = {"images/ui/text/exploration/event_bar_10.png", "images/ui/text/exploration/event_bar_9.png"}, 
        [4] = {"images/ui/text/exploration/event_bar_6.png", "images/ui/text/exploration/event_bar_5.png"}, 
        [5] = {"images/ui/text/exploration/event_bar_8.png", "images/ui/text/exploration/event_bar_7.png"},  
    }
    
    for i = 1, 4 do
        local img = imgs[i]
        if self.ids[i] then
            local pic_index = 1 --(tonumber(self.id) == tonumber(self.ids[i - 1])) and 2 or 1
            img:loadTexture(paths[tonumber(self.ids[i])][pic_index])
            img:setVisible(true)
            -- img_arrows[i - 1]:setVisible(true)
        else
            img:setVisible(false)
            -- img_arrows[i - 1]:setVisible(false)
        end
    end

    Text_explore_all_finish_num:setString(string.format(tipStringInfo_file_island_tips[5], table.nums(_ED.pokemonExplore_search_result.resultArray)))
end

function ExplorationAllFinishRegularCell:onInit()
    local csbNode = csb.createNode("campaign/exploration/exploration_event_reward_tab.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"), nil, 
    {
        terminal_name = "exploration_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:drawUI()
    self:onUpdateDraw()
end

function ExplorationAllFinishRegularCell:drawUI()
    local root = self.roots[1]
    local index = 1
    for i=1,6 do
        if _ED.pokemonEventIds[i] then
            local Panel_random = ccui.Helper:seekWidgetByName(root, "Panel_random_" .. index)
            local Text_event_name = ccui.Helper:seekWidgetByName(root, "Text_event_name_" .. index)
            local Text_event_num = ccui.Helper:seekWidgetByName(root, "Text_event_num_" .. index)
            local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_" .. index)

            Text_event_name:setString(tipStringInfo_exploration_event_name_tips[i])
            Text_event_num:setString("x" .. table.nums(_ED.pokemonEventIds[i]))
            Panel_icon:setBackGroundImage(string.format("images/ui/text/TS/sj_regular_%d.png", i))
            Panel_random:setVisible(true)
            index = index + 1
        end
    end

    for i = index, 6 do
        local Panel_random = ccui.Helper:seekWidgetByName(root, "Panel_random_" .. i)
        Panel_random:setVisible(false)
    end

    local Text_regular_ex_n = ccui.Helper:seekWidgetByName(root, "Text_regular_ex_n")
    local Text_regular_jb_n = ccui.Helper:seekWidgetByName(root, "Text_regular_jb_n")
    local Text_regular_tsb_n = ccui.Helper:seekWidgetByName(root, "Text_regular_tsb_n")
    local rewordInfo = getSceneReward(73)
    for i,info in ipairs(rewordInfo.show_reward_list) do
        if tonumber(info.prop_type) == 8 then
            Text_regular_ex_n:setString("x " .. info.item_value)
        elseif tonumber(info.prop_type) == 1 then
            Text_regular_jb_n:setString("x " .. info.item_value)
        elseif tonumber(info.prop_type) == 70 then
            Text_regular_tsb_n:setString("x " .. info.item_value)
        end
    end
   
end

function ExplorationAllFinishRegularCell:init(params)
    self.ids = params
    self:onInit()
end

function ExplorationAllFinishRegularCell:createCell()
	local cell = ExplorationAllFinishRegularCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


