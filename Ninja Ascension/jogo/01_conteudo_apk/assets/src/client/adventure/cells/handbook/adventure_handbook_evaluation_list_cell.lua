----------------------------------------------------------------------------------------------------
-- 说明：评论列表
----------------------------------------------------------------------------------------------------
AdventureHandbookEvaluationListCell = class("AdventureHandbookEvaluationListCellClass", Window)
AdventureHandbookEvaluationListCell.__size = nil


function AdventureHandbookEvaluationListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.Text_PlayerName = nil
	self.Text_liuyan = nil
	self.detail_data = nil
	self.Text_favourCount = nil
	-- Initialize adventure equip list cell state machine.
	local function init_adventure_mercenary_evaluation_terminal()
       --点赞
        local adventure_mercenary_evaluation_favour_terminal = {
            _name = "adventure_mercenary_evaluation_favour",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	local function responseSwitchEquipmentCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
							state_machine.excute("adventure_mercenary_equipment_evaluation_update",0,0)
                        end
                    end
                end

                protocol_command.ship_comment_favour.param_list = "" .. cell.detail_data.id .. "\r\n"
                NetworkManager:register(protocol_command.ship_comment_favour.code, nil, nil, nil, cell, responseSwitchEquipmentCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_evaluation_favour_terminal)
        state_machine.init()
	end

	-- call func init adventure equip list cell state machine.
	init_adventure_mercenary_evaluation_terminal()
end

function AdventureHandbookEvaluationListCell:onEnterTransitionFinish()

end

function AdventureHandbookEvaluationListCell:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self.Text_liuyan:setString(zstring.exchangeFrom(self.detail_data.content))
	self.Text_PlayerName:setString(self.detail_data.nickname)
	self.Text_favourCount:setString(self.detail_data.favour)
   	
end

function AdventureHandbookEvaluationListCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_pinglun.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	if AdventureHandbookEvaluationListCell.__size == nil then
		AdventureHandbookEvaluationListCell.__size = root:getContentSize()
	end
	self.Text_liuyan = ccui.Helper:seekWidgetByName(root, "Text_liuyan")
	self.Text_PlayerName = ccui.Helper:seekWidgetByName(root, "Text_rolename_pl")
	self.Text_favourCount = ccui.Helper:seekWidgetByName(root, "Text_number_pl")

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_dianzan"),       nil, 
	{
		terminal_name = "adventure_mercenary_evaluation_favour",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
    self:updateDraw()
end

function AdventureHandbookEvaluationListCell:onExit()
	cacher.freeRef("list/list_pinglun.csb", self.roots[1])
	self.roots = {}
end

function AdventureHandbookEvaluationListCell:init(detail,drawIndex)
	self.detail_data = detail
	if drawIndex ~= nil and drawIndex < 10 then
		self:onInit()
	end

	self:setContentSize(AdventureHandbookEvaluationListCell.__size)
	return self
end

function AdventureHandbookEvaluationListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()

end

function AdventureHandbookEvaluationListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_pinglun.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureHandbookEvaluationListCell:createCell()
	local cell = AdventureHandbookEvaluationListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
