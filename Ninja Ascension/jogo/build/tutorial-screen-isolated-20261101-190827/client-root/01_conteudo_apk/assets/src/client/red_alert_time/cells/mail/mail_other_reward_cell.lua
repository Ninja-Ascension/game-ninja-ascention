--------------------------------------------------------------------------------------------------------------
--  邮件奖励cell
--------------------------------------------------------------------------------------------------------------
MailOtherRewardCell = class("MailOtherRewardCellClass", Window)
MailOtherRewardCell.__size = nil
--创建cell
local mail_other_reward_cell_terminal = {
    _name = "mail_other_reward_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MailOtherRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(mail_other_reward_cell_terminal)
state_machine.init()

function MailOtherRewardCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._datas = nil
    self._mail_type = 0
    self._mail_dec = ""
	app.load("client.red_alert_time.cells.props.props_icon_cell")
end

function MailOtherRewardCell:updateDraw()
    local root = self.roots[1]

    local reward = self._datas
    if tonumber(self._mail_type) == 55 then         -- 红包特殊处理
        local contentInfo = zstring.split(self._mail_dec, ",")
        reward = {}
        info = {
            prop_item = tonumber(contentInfo[1]),
            prop_type = 6,
            item_value = tonumber(contentInfo[2]),
        }
        table.insert(reward, info)
    end

	local ListView_rewad = ccui.Helper:seekWidgetByName(root,"ListView_rewad")
	ListView_rewad:removeAllItems()
	local listViewSize = ListView_rewad:getContentSize()
	local nCoount = 0
	local tWidth = 0
	local iemsMargin = ListView_rewad:getItemsMargin()
	for i, v in pairs(reward) do
        local cell = createPropIconCell(v, true, true, true)
		ListView_rewad:addChild(cell)
		if nCoount > 0 then
			tWidth = tWidth + iemsMargin
		end
		nCoount = nCoount + 1
	end
	tWidth = tWidth + PropsIconCell.__size.width * nCoount
	local viewWidth = listViewSize.width * ListView_rewad:getScaleX()
	if nCoount == 1 then
		ListView_rewad:setPositionX(ListView_rewad._x + viewWidth / 2 - tWidth / 2+30)
    elseif nCoount == 2 then
        ListView_rewad:setPositionX(ListView_rewad._x + viewWidth / 2 - 80)
    elseif nCoount == 3 then
        ListView_rewad:setPositionX(tWidth/4-20)
    else
        ListView_rewad:setPositionX(ListView_rewad._x + 30)
    end
    ListView_rewad:setTouchEnabled(false)
	ListView_rewad:requestRefreshView()
end

function MailOtherRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.mail.mail_reward, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    table.insert(self.roots, root) 

    if MailOtherRewardCell.__size == nil then
        MailOtherRewardCell.__size = root:getContentSize()
    end
	if ccui.Helper:seekWidgetByName(root,"ListView_rewad")._x == nil then
		ccui.Helper:seekWidgetByName(root,"ListView_rewad")._x = ccui.Helper:seekWidgetByName(root,"ListView_rewad"):getPositionX()
	end
	ccui.Helper:seekWidgetByName(root,"ListView_rewad"):setPositionX(ccui.Helper:seekWidgetByName(root,"ListView_rewad")._x)

	self:updateDraw()
end

function MailOtherRewardCell:onEnterTransitionFinish()

end

function MailOtherRewardCell:init(params)
    self._datas = params[1]
    self._mail_type = params[2]
    self._mail_dec = params[3]
	self:onInit()
    self:setContentSize(MailOtherRewardCell.__size)
    return self
end

function MailOtherRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_rewad = ccui.Helper:seekWidgetByName(root,"ListView_rewad")
	if ListView_rewad~= nil then
		ListView_rewad:removeAllItems()
	end
end

function MailOtherRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function MailOtherRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.mail.mail_reward, root)
    root:removeFromParent(false)
    self.roots = {}
end

function MailOtherRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.mail.mail_reward, self.roots[1])
end
