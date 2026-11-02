-- ----------------------------------------------------------------------------------------------------
-- 说明：绘制游戏中用到的提示界面
-- -----------------------------------------------------------------------------------------------------

GameTipDialog = class("GameTipDialogClass" , Window, true)

function GameTipDialog:ctor()
    self.super:ctor()
	self.text = ""
end
function GameTipDialog:onEnterTransitionFinish()
	local size = cc.Director:getInstance():getWinSize()
	
	local tipWidget = csb.createNode("utils/congratulations_to_btain.csb")
	local root = tipWidget:getChildByName("root")
	
	local action = csb.createTimeline("utils/congratulations_to_btain.csb")
	self:addChild(tipWidget)
	
	tipWidget:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	local panel = ccui.Helper:seekWidgetByName(root, "ImageView_bg")
	local tipInformation = ccui.Helper:seekWidgetByName(root, "Label_970")
	local tipImage = ccui.Helper:seekWidgetByName(root, "ImageView_bg")
	tipInformation:setString(self.text)
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        local mid_pos_bg = tipImage:getPositionY() + tipImage:getContentSize().height/2
        local mid_pos_bg_after_change = tipImage:getPositionY() + tipImage:getContentSize().height/2
        local offset_y = mid_pos_bg_after_change - mid_pos_bg
        tipInformation:setPositionY(tipInformation:getPositionY() + offset_y)
	elseif __lua_project_id ~= __lua_project_adventure then
		local mid_pos_bg = tipImage:getPositionY() + tipImage:getContentSize().height/2
		tipImage:setContentSize(cc.size(tipImage:getContentSize().width,tipImage:getContentSize().height+tipInformation:getContentSize().height))
		local mid_pos_bg_after_change = tipImage:getPositionY() + tipImage:getContentSize().height/2
		local offset_y = mid_pos_bg_after_change - mid_pos_bg
		tipInformation:setPositionY(tipInformation:getPositionY() + offset_y)
	end
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "over" then 
	--		print("over----------------111-------", self)
			fwin:close(self)
        end
    end)
end

function GameTipDialog:onExit()
	
			--> print("on exit")
end

function GameTipDialog:init(text)
	self.text = text
end
-- END
-- ----------------------------------------------------------------------------------------------------