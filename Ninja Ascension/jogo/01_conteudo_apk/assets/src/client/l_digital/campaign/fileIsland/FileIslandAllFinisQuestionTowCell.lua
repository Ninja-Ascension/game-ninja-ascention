----------------------------------------------------------------------------------------------------
-- 说明:探索完成
----------------------------------------------------------------------------------------------------
FileIslandAllFinisQuestionTowCell = class("FileIslandAllFinisQuestionTowCellClass", Window)
FileIslandAllFinisQuestionTowCell.__size = nil

function FileIslandAllFinisQuestionTowCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionResult")

	local function init_fileIsland_all_finish_question_two_cell_terminal()
		-- -- 点击cell
		local fileIsland_all_finish_tow_goto_next_terminal = {
            _name = "fileIsland_all_finish_tow_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = instance.index + 1
                if not instance.isReview then
                    local result = FileIslandAllFinisQuestionResult:new()
                    result:init(instance.index)
                    fwin:open(result, fwin._ui)
                else
                    state_machine.excute("fileIsland_window_all_finish_update", 0, index)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fileIsland_all_finish_tow_goto_next_terminal)
        state_machine.init()
	end

	init_fileIsland_all_finish_question_two_cell_terminal()
end

function FileIslandAllFinisQuestionTowCell:onUpdateDraw()
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
            img:loadTexture(paths[i][2])
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
    
    for i=1,4 do
        local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_" .. i)
        Panel_role:setBackGroundImage("images/face/big_head/big_head_103003.png")
        if not self.isReview then
            Panel_role:setColor(cc.c3b(0,0,0))
            Panel_role:setTouchEnabled(true)
            Panel_role.idnex = i
        else
            Panel_role:setColor(cc.c3b(255,255,255))
            Panel_role:setTouchEnabled(false)
            self:selectEvet( Panel_role, ccui.TouchEventType.ended )
            ccui.Helper:seekWidgetByName(root, "Button_sure"):setVisible(true)
        end
        Panel_role:addTouchEventListener(handler(self, self.selectEvet))
    end
end

function FileIslandAllFinisQuestionTowCell:selectEvet( sender, eventType )
    local root = self.roots[1]
    if eventType == ccui.TouchEventType.ended then
        if not self.isReview then
            local action1 = cc.TintTo:create(1, 255, 255, 255)
            sender:runAction(action1)
            self.correctAnwser = sender.index
            ccui.Helper:seekWidgetByName(root, "Button_sure"):setVisible(true)
        end
        for i=1,4 do
            local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_" .. i)
            Panel_role:setTouchEnabled(false)
        end
    end
end

function FileIslandAllFinisQuestionTowCell:onInit()
    local csbNode = csb.createNode("campaign/explore/explore_question_2_cell.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "fileIsland_all_finish_tow_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function FileIslandAllFinisQuestionTowCell:clearUIInfo()
end

function FileIslandAllFinisQuestionTowCell:initData()
end

function FileIslandAllFinisQuestionTowCell:init(params)
    self.index = params[1]
    self.isReview = params[2]

    self.correctAnwser = 2
    self:onInit()
end

function FileIslandAllFinisQuestionTowCell:createCell()
	local cell = FileIslandAllFinisQuestionTowCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


