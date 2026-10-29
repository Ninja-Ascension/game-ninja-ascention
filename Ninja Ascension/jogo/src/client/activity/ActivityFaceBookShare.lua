-- ----------------------------------------------------------------------------------------------------
-- 说明：facebook分享
-------------------------------------------------------------------------------------------------------
ActivityFaceBookShare = class("ActivityFaceBookShareClass", Window)
    
function ActivityFaceBookShare:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	
    -- Initialize ActivityFaceBookShare state machine.
    local function init_activity_facebook_share_terminal()
		--分享
        local activity_facebook_share_to_share_terminal = {
            _name = "activity_facebook_share_to_share",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("platform_the_request_share", 0, "platform_the_request_share.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --分享成功后得到奖励
        local activity_facebook_share_to_get_reward_terminal = {
            _name = "activity_facebook_share_to_get_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseBoxRewardCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd,fwin._ui)
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                NetworkManager:register(protocol_command.draw_share_reward.code, nil, nil, nil, instance, responseBoxRewardCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_facebook_share_to_share_terminal)
        state_machine.add(activity_facebook_share_to_get_reward_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityFaceBookShare state machine.
    init_activity_facebook_share_terminal()
    
    self._load_over = false
	self:onLoad()
end
function ActivityFaceBookShare:onUpdateDrawData( ... )
	self.loaded = true
	self:onUpdateDraw()
end
function ActivityFaceBookShare:onUpdateDraw()
	if self.loaded == false then
		return
	end
    if _ED._share_reward_info == nil then 
        return
    end
	local root = self.roots[1]

    local shareButton = ccui.Helper:seekWidgetByName(root, "Button_01")
    if _ED._share_reward_info.share_states == 1 then 
        --已经领取过了
        shareButton:setTouchEnabled(false)
        shareButton:setColor(cc.c3b(150, 150, 150))
    else
        shareButton:setTouchEnabled(true)
        shareButton:setColor(cc.c3b(255, 255, 255))
    end
end

function ActivityFaceBookShare:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:onInit()
end

function ActivityFaceBookShare:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function ActivityFaceBookShare:onEnterTransitionFinish()

end

function ActivityFaceBookShare.onImageLoaded(texture)
	
end

function ActivityFaceBookShare:onArmatureDataLoad(percent)
	
end

function ActivityFaceBookShare:onArmatureDataLoadEx(percent)
	
end

function ActivityFaceBookShare:onLoad()
	
end

function ActivityFaceBookShare:onInit()
	local csbMonthCard = csb.createNode("activity/wonderful/facebook_share.csb")
    local root = csbMonthCard:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbMonthCard)
	
	--cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
   -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self, false)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    local terminalName = ""
    if targetPlatform == cc.PLATFORM_OS_MAC or targetPlatform ==  cc.PLATFORM_OS_WINDOWS then
        --便于本地测试
        terminalName = "activity_facebook_share_to_get_reward" 
    else
        terminalName = "activity_facebook_share_to_share" 
    end
    
	--分享
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01"), nil, 
	{
		terminal_name = terminalName, 
		terminal_state = 0,
		isPressedActionEnabled = true,
        _self = self
	},
	nil,0)

	local function responseInitCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    NetworkManager:register(protocol_command.new_share_reward_init.code, nil, nil, nil, target, responseInitCallBack, false, nil)
end

function ActivityFaceBookShare:onExit()
	
end

function ActivityFaceBookShare:init()

end


function ActivityFaceBookShare:createCell()
	local cell = ActivityFaceBookShare:new()
	cell:registerOnNodeEvent(cell)
	-- cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end