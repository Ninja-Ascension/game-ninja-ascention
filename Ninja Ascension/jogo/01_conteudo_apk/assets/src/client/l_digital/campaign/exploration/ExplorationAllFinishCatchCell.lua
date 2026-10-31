----------------------------------------------------------------------------------------------------
-- 说明:一键探索完成
----------------------------------------------------------------------------------------------------
ExplorationAllFinishCatchCell = class("ExplorationAllFinishCatchCellClass", Window)
ExplorationAllFinishCatchCell.__size = nil

function ExplorationAllFinishCatchCell:ctor()
    self.super:ctor()
	self.roots = {}

    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchListCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinish")
	local function init_exploration_all_finish_catch_cell_terminal()
		-- -- 点击cell
		local exploration_all_finish_window_goto_next_terminal = {
            _name = "exploration_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                function showConfirmTip(instance,n)
                    if n == 0 then
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local cur_index = tonumber(table.getKeyByValue(instance.ids, instance.id))
                                local id = instance.ids[cur_index + 1]
                                state_machine.excute("exploration_window_all_finish_update", 0, {(id or 0), 1})
                            end
                        end
        
                        local data = {}
                        for i,v in ipairs(_ED.pokemonEventIds[instance.id]) do
                            data[i] = {}
                            data[i].resultIndex = v.index
                        end
                        local req = json.encode(data)
                        protocol_command.pokemon_explore_map_catch_cancel.param_list = req
                        NetworkManager:register(protocol_command.pokemon_explore_map_catch_cancel.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip, tipStringInfo_exploration_tips[5])
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local exploration_all_finish_catch_cell_update_terminal = {
            _name = "exploration_all_finish_catch_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.pokemonEventIds[instance.id] and table.nums(_ED.pokemonEventIds[instance.id]) > 0 then
                    -- state_machine.excute("exploration_window_all_finish_catch_update", 0, {instance.id, 1})
                    print("11111111111111")
                    instance:onUpdateDraw()
                else
                    local cur_index = tonumber(table.getKeyByValue(instance.ids, instance.id))
                    local id = instance.ids[cur_index + 1]
                    state_machine.excute("exploration_window_all_finish_update", 0, {(id or 0), 1})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_all_finish_window_goto_next_terminal)
		state_machine.add(exploration_all_finish_catch_cell_update_terminal)
        state_machine.init()
	end

	init_exploration_all_finish_catch_cell_terminal()
end

function ExplorationAllFinishCatchCell:onUpdateDraw()
    local root = self.roots[1]
    local img_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0")
    local img_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0")
    local img_4 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_2")
    local img_5 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_1")
    local imgs = {img_2, img_3, img_4, img_5}
    
    -- local img_arrow_1 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1")
    -- local img_arrow_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0")
    -- local img_arrow_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0_0")
    -- local img_arrows = {img_arrow_1, img_arrow_2, img_arrow_3}

    local paths = {
        [1] = {"images/ui/text/exploration/event_bar_4.png", "images/ui/text/exploration/event_bar_3.png"}, 
        [6] = {"images/ui/text/exploration/event_bar_10.png", "images/ui/text/exploration/event_bar_9.png"}, 
        [4] = {"images/ui/text/exploration/event_bar_6.png", "images/ui/text/exploration/event_bar_5.png"}, 
        [5] = {"images/ui/text/exploration/event_bar_8.png", "images/ui/text/exploration/event_bar_7.png"}, 
    }
    
    for i = 1, 4 do
        local img = imgs[i]
        if self.ids[i] then
            local pic_index = (tonumber(self.id) == tonumber(self.ids[i])) and 2 or 1
            img:loadTexture(paths[tonumber(self.ids[i])][pic_index])
            img:setVisible(true)
            -- img_arrows[i - 1]:setVisible(true)
        else
            img:setVisible(false)
            -- img_arrows[i - 1]:setVisible(false)
        end
    end

    local ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_free_box")
    ListView_3:removeAllItems()
    for i,v in ipairs(_ED.pokemonEventIds[self.id]) do
        if v then
            local cell = state_machine.excute("exploration_all_finish_catch_list_cell_create", 0, {i, v})
            cell.index = i
            ListView_3:addChild(cell)
        end
    end
    ListView_3:requestRefreshView()

    -- ccui.Helper:seekWidgetByName(root, "Panel_explore_single_challenge_jl"):setVisible(self.is_all)
end

function ExplorationAllFinishCatchCell:onInit()
    local csbNode = csb.createNode("campaign/exploration/exploration_event_catch_tab.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    ccui.Helper:seekWidgetByName(root, "Button_next"):setVisible(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"), nil, 
    {
        terminal_name = "exploration_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function ExplorationAllFinishCatchCell:clearUIInfo()
end

function ExplorationAllFinishCatchCell:initData()
end

function ExplorationAllFinishCatchCell:init(params)
    self.id= params[1]
    self.ids = params[2]
    self.is_all = params[3]
    self:onInit()
end

function ExplorationAllFinishCatchCell:createCell()
	local cell = ExplorationAllFinishCatchCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


