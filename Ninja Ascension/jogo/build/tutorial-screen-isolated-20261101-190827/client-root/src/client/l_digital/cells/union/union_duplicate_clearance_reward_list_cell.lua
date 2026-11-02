--------------------------------------------------------------------------------------------------------------
--  说明：军团副本通关奖励列表

--------------------------------------------------------------------------------------------------------------
UnionDuplicateClearanceRewardListCell = class("UnionDuplicateClearanceRewardListCellClass", Window)
UnionDuplicateClearanceRewardListCell.__size = nil
app.load("client.cells.prop.prop_money_icon")
app.load("client.cells.prop.prop_icon_cell")
function UnionDuplicateClearanceRewardListCell:ctor()
	self.super:ctor()
	self.roots = {}

	self.rewardlist = nil --领取列表
    self.reward_index = nil --领取索引
	self.seatID = nil --控件章节
	 -- Initialize union duplicate clearance reward list cell state machine.
    local function init_union_duplicate_clearance_reward_list_cell_terminal()
		--领取奖励
        local union_duplicate_clearance_reward_list_cell_get_reward_terminal = {
            _name = "union_duplicate_clearance_reward_list_cell_get_reward",
            _init = function (terminal)
            app.load("client.reward.DrawRareReward") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local seatID = params._datas._seatID
                local reward_index = params._datas._reward_index + 1--领取索引
                if seatID ~= reward_index then
                     TipDlg.drawTextDailog("缺少字段")--没有字段，
                    return
                end
                state_machine.lock("union_duplicate_clearance_reward_list_cell_get_reward")
                local function responseUnionInitPveCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_duplicate_clearance_reward_close",0,"")
                        state_machine.excute("union_duplicate_clearance_reward_open",0,false)

                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(25)
                        fwin:open(getRewardWnd, fwin._ui)
                        --state_machine.unlock("union_duplicate_clearance_reward_list_cell_get_reward")
                    else
                        state_machine.unlock("union_duplicate_clearance_reward_list_cell_get_reward")
                        TipDlg.drawTextDailog(_string_piece_info[100])
                    end 
                end
                protocol_command.draw_union_scene_reward.param_list = seatID.."\r\n"
                NetworkManager:register(protocol_command.draw_union_scene_reward.code, nil, nil, nil, nil, responseUnionInitPveCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 刷新
		local union_duplicate_clearance_reward_list_cell_refresh_terminal = {
            _name = "union_duplicate_clearance_reward_list_cell_refresh",
            _init = function (terminal)
                
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
		state_machine.add(union_duplicate_clearance_reward_list_cell_get_reward_terminal)
		state_machine.add(union_duplicate_clearance_reward_list_cell_refresh_terminal)
        state_machine.init()
    end
    -- call func init union duplicate clearance reward list cell state machine.
    init_union_duplicate_clearance_reward_list_cell_terminal()

end

function UnionDuplicateClearanceRewardListCell:updateDraw()
    local root = self.roots[1]
    local open_scene_id = tonumber(_ED.union.union_current_scene_id) --当前
    local Image_weidacheng = ccui.Helper:seekWidgetByName(root,"Image_weidacheng")
    local Button_lingqu = ccui.Helper:seekWidgetByName(root,"Button_lingqu")
    local Image_yilingqu =  ccui.Helper:seekWidgetByName(root,"Image_yilingqu")
    Button_lingqu:setVisible(false)
    Image_weidacheng:setVisible(false)
    Image_yilingqu:setVisible(false)

    if self.seatID >= open_scene_id then
        Image_weidacheng:setVisible(true)
    end
    if self.seatID < open_scene_id and self.seatID > self.reward_index then
        Button_lingqu:setVisible(true)
    end
    if self.seatID <= self.reward_index then
        Image_yilingqu:setVisible(true)
    end


    
    local rewardStr = zstring.split(self.rewardlist,"|")
    local rewardTable = {}
    for i=1,3 do
        rewardTable[i] = zstring.split(rewardStr[i],",")
        local Panel_jiangli= ccui.Helper:seekWidgetByName(root,"Panel_jiangli_"..i)
        Panel_jiangli:removeAllChildren(true)

        if tonumber(rewardTable[i][1]) == 28 then
            local cell = propMoneyIcon:createCell()
            cell:init(rewardTable[i][1],rewardTable[i][3])
            Panel_jiangli:addChild(cell)
        elseif tonumber(rewardTable[i][1]) == 1 then
            local cell = propMoneyIcon:createCell()
            cell:init(rewardTable[i][1],rewardTable[i][3])
            Panel_jiangli:addChild(cell)
        elseif tonumber(rewardTable[i][1]) == 6 then
            local cell = PropIconCell:createCell()
            cell:init(34,rewardTable[i][2],rewardTable[i][3])
            Panel_jiangli:addChild(cell)
        end
        
    end
end

function UnionDuplicateClearanceRewardListCell:onInit()
    local root = cacher.createUIRef("legion/legion_pve_attack_list.csb","root")
    table.insert(self.roots, root)
    self:addChild(root)
    if UnionDuplicateClearanceRewardListCell.__size == nil then
        local Panel_203 = ccui.Helper:seekWidgetByName(root, "Panel_203")
        UnionDuplicateClearanceRewardListCell.__size = Panel_203:getContentSize()
    end
    local Button_lingqu = ccui.Helper:seekWidgetByName(root, "Button_lingqu")
    fwin:addTouchEventListener(Button_lingqu,  nil, 
    {
        terminal_name = "union_duplicate_clearance_reward_list_cell_get_reward",
        terminal_state = 0,
        _seatID = self.seatID,
        _reward_index = self.reward_index
    }, 
    nil, 0)
    
	self:updateDraw()
end

function UnionDuplicateClearanceRewardListCell:onEnterTransitionFinish()

end

function UnionDuplicateClearanceRewardListCell:init(rewardlist,reward_index,seatID,drawindex)
    self.rewardlist = rewardlist
    self.reward_index = reward_index
    self.seatID = seatID
    if drawindex ~= nil and drawindex < 6 then
	   self:onInit()
    end
    self:setContentSize(UnionDuplicateClearanceRewardListCell.__size)
	return self
end

function UnionDuplicateClearanceRewardListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionDuplicateClearanceRewardListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    cacher.freeRef("legion/legion_pve_attack_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end
function UnionDuplicateClearanceRewardListCell:onExit()
    cacher.freeRef("legion/legion_pve_attack_list.csb", self.roots[1])
end

function UnionDuplicateClearanceRewardListCell:createCell()
	local cell = UnionDuplicateClearanceRewardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
