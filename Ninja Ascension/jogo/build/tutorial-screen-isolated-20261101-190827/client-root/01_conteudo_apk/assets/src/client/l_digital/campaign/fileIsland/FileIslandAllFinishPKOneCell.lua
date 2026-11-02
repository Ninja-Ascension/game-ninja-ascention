----------------------------------------------------------------------------------------------------
-- 说明:一键探索完成
----------------------------------------------------------------------------------------------------
FileIslandAllFinishPKOneCell = class("FileIslandAllFinishPKOneCellClass", Window)
FileIslandAllFinishPKOneCell.__size = nil

function FileIslandAllFinishPKOneCell:ctor()
    self.super:ctor()
	self.roots = {}

    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishPKOneListCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")
	local function init_fileIsland_all_finish_pk_one_cell_terminal()
		-- -- 点击cell
		local fileIsland_all_finish_window_goto_next_terminal = {
            _name = "fileIsland_all_finish_window_goto_next",
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
                                state_machine.excute("fileIsland_window_all_finish_update", 0, {0, 1})
                            end
                        end
        
                        local data = {}
                        for i,v in ipairs(_ED.eventIds[instance.id]) do
                            data[i] = {}
                            data[i].resultIndex = v.index
                        end
                        local req = json.encode(data)
                        protocol_command.file_island_single_challenge_cancel.param_list = req
                        NetworkManager:register(protocol_command.file_island_single_challenge_cancel.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip, tipStringInfo_file_island_tips[4])
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fileIsland_all_finish_window_goto_next_terminal)
        state_machine.init()
	end

	init_fileIsland_all_finish_pk_one_cell_terminal()
end

function FileIslandAllFinishPKOneCell:onUpdateDraw()
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

    local ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_3")
    ListView_3:removeAllItems()
    for i,v in ipairs(_ED.eventIds[self.id]) do
        local cell = state_machine.excute("fileIsland_one_pk_list_cell_create", 0, {i, v})
        ListView_3:addChild(cell)
    end

    ccui.Helper:seekWidgetByName(root, "Panel_explore_single_challenge_jl"):setVisible(self.is_all)
end

function FileIslandAllFinishPKOneCell:onInit()
    local csbNode = csb.createNode("campaign/explore/explore_single_challenge_cell.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    ccui.Helper:seekWidgetByName(root, "Button_sure"):setVisible(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function FileIslandAllFinishPKOneCell:clearUIInfo()
end

function FileIslandAllFinishPKOneCell:initData()
end

function FileIslandAllFinishPKOneCell:init(params)
    self.id= params[1]
    self.ids = params[2]
    self.is_all = params[3]
    self:onInit()
end

function FileIslandAllFinishPKOneCell:createCell()
	local cell = FileIslandAllFinishPKOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


