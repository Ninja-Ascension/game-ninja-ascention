
-- 播放导航动画
-- param 播放列表， 起点X，起点Y， 间距， 是否垂直(true 垂直，false 水平，默认垂直true),动画方向(垂直时，true 从上往下，false 从下往上；水平时，true 从左往右，false 从右往左), 
-- 是否起始点为同一点(默认不在同一点false),回调函数
function Animation_PlayNavigation(playList, posX, posY, spacing, isVertical, isDirection, isSamePoiont, callback)
	local total = table.getn(playList)
	if total == 0 or spacing == 0 then
		return
	end
	if isVertical == nil then
	   isVertical = true
    end
	if isSamePoiont == nil then
	   isSamePoiont = false
	end
	if isDirection == nil then
	   isDirection = true
	end
    
	local actionNode = nil
	local moveStartX = 0
	local moveStartY = 0
	local moveTargetX = 0
	local moveTargetY = 0
	local actionEndCallBack = nil
	
    local function moveNode(action)
        if actionNode then
            actionNode:setPosition(cc.p(moveStartX, moveStartY))
            actionNode:setVisible(true)
            actionNode:runAction(action)
        end
    end
    
    -- 垂直
    if isVertical == true then
        -- 从上往下
        if isDirection == true then
            local index = 1
            
            local function updateMoveInfo()
                actionNode = playList[index]
                if isSamePoiont then
                   moveStartX = posX
                   moveStartY = posY
                else
                   moveStartX = actionNode:getPositionX()
                   moveStartY = posY - (index-1) * spacing
                end
                
                moveTargetY = moveStartY - spacing
                local moveTo = cc.MoveTo:create(0.15, cc.p(moveStartX, moveTargetY))
                local action = cc.EaseBackInOut:create(moveTo)
                local callfunc = cc.CallFunc:create(function()
                    index = index + 1
                    if index > total then
                        if callback ~= nil then
                            callback()
                        end
                        return
                    end
                    updateMoveInfo()
                end)
                
                moveNode(cc.Sequence:create(action,callfunc))
            end
    
            updateMoveInfo()
        -- 从下往上
        else
            local index = total
            
            local function updateMoveInfo()
                actionNode = playList[index]
                if isSamePoiont then
                   moveStartX = posX
                   moveStartY = posY
                else
                   moveStartX = actionNode:getPositionX()
                   moveStartY = posY + (total-index) * spacing
                end
                
                moveTargetY = moveStartY + spacing
                local moveTo = cc.MoveTo:create(0.15, cc.p(moveStartX, moveTargetY))
                local action = cc.EaseBackInOut:create(moveTo)
                local callfunc = cc.CallFunc:create(function()
                    index = index - 1
                    if index <= 0 then
                        if callback ~= nil then
                            callback()
                        end
                        return
                    end
                    updateMoveInfo()
                end)
                
                moveNode(cc.Sequence:create(action,callfunc))
            end
    
            updateMoveInfo()
        end
    -- 水平
    else
        -- 从右往左
        if isDirection == true then
            local index = 1

            local function updateMoveInfo()
                actionNode = playList[index]
                if isSamePoiont then
                    moveStartX = posX
                    moveStartY = posY
                else
                    moveStartY = actionNode:getPositionY()
                    moveStartX = posX - (index-1) * spacing
                end

                moveTargetX = moveStartX - spacing
                local moveTo = cc.MoveTo:create(0.2, cc.p(moveTargetX, moveStartY))
                local action = cc.EaseBackInOut:create(moveTo)
                local callfunc = cc.CallFunc:create(function()
                    index = index + 1
                    if index > total then
                        if callback ~= nil then
                            callback()
                        end
                        return
                    end
                    updateMoveInfo()
                end)

                moveNode(cc.Sequence:create(action,callfunc))
            end

            updateMoveInfo()
        -- 从左往右
        else
            local index = total

            local function updateMoveInfo()
                actionNode = playList[index]
                if isSamePoiont then
                    moveStartX = posX
                    moveStartY = posY
                else
                    moveStartY = actionNode:getPositionY()
                    moveStartX = posX + (total-index) * spacing
                end

                moveTargetX = moveStartX + spacing
                local moveTo = cc.MoveTo:create(0.2, cc.p(moveTargetX, moveStartY))
                local action = cc.EaseBackInOut:create(moveTo)
                local callfunc = cc.CallFunc:create(function()
                    index = index - 1
                    if index <= 0 then
                        if callback ~= nil then
                            callback()
                        end
                        return
                    end
                    updateMoveInfo()
                end)

                moveNode(cc.Sequence:create(action,callfunc))
            end

            updateMoveInfo()
        end
    end
end

SHOW_UI_ACTION_TYPR = 
{
    TYPE_ACTION_CENTER_IN = 1,  -- 从中间弹出
    TYPE_ACTION_CENTER_OUT = 2, -- 从中间收回
    TYPE_ACTION_UP_IN = 3,      -- 从上方进入
    TYPE_ACTION_UP_OUT = 4,     -- 从上方移出
    TYPE_ACTION_DOWN_IN = 5,    -- 从下方进入
    TYPE_ACTION_DOWN_OUT = 6,   -- 从下方移出
    TYPE_ACTION_LEFT_IN = 7,    -- 从左边进入
    TYPE_ACTION_LEFT_OUT = 8,   -- 从左边移出
    TYPE_ACTION_RIGHT_IN = 9,   -- 从右边进入
    TYPE_ACTION_RIGHT_OUT = 10, -- 从右边移出
    TYPE_ACTION_LEFT_IN_Ease = 11, -- 从左边进入(回弹)
    TYPE_ACTION_RIGHT_IN_Ease = 12, -- 从右边进入(回弹)
    TYPE_ACTION_SLIDE_DOWN = 13, -- 向下滑出
    TYPE_ACTION_SLIDE_UP = 14, -- 向上滑出
}
---------------------------
-- UI打开或者节点移动动画
--@param 动画节点列表，移动类型，移动时间（默认0.2S），回调函数
function Animations_PlayOpenMainUI(actionNodeList, actionType, time, callFunc)
    if not actionNodeList then
        return
    end
    local total = table.getn(actionNodeList)
    if total == 0 then
        return
    end
    if not time then
        time = 0.15
    end
    local actionNode = nil
    local index = 1
    local nodeSize = nil
    local playOnceEndCallBack = nil
    
    local function actionFunc(action)
        if actionNode then
            actionNode:runAction(action)
        end
    end
    
    local function updateMoveActionInfo()
        actionNode = actionNodeList[index]
        nodeSize = actionNode:getContentSize()
        local uiAct = {}
        if (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN) then
            actionNode:setAnchorPoint(cc.p(0.5, 0.5))
            actionNode:setPosition(actionNode:getContentSize().width/2, actionNode:getContentSize().height/2)
            actionNode:setScale(0.8)
            actionNode:setOpacity(10)
            uiAct = cc.Spawn:create(cc.ScaleTo:create(0.3, 1.0), cc.FadeIn:create(0.2))
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_OUT) then
            actionNode:setAnchorPoint(cc.p(0.5, 0.5))
            actionNode:setPosition(actionNode:getContentSize().width/2, actionNode:getContentSize().height/2)
            uiAct = cc.Spawn:create(cc.ScaleTo:create(0.3, 0.7), cc.FadeOut:create(0.3))
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_UP_IN) then
            local posEnd = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            actionNode:setPosition(actionNode:getPositionX(), cc.Director:getInstance():getVisibleSize().height)
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = cc.EaseBackOut:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_UP_OUT) then
            local posStart = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            local posEnd = cc.p(posStart.x, cc.Director:getInstance():getVisibleSize().height)   
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = cc.EaseBackIn:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_DOWN_IN) then
            local posEnd = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            actionNode:setPosition(posEnd.x, -nodeSize.height - actionNode:getPositionY())
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = cc.EaseBackOut:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_DOWN_OUT) then
            local posStart = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            local posEnd = cc.p(posStart.x, -nodeSize.height - actionNode:getPositionY())
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = cc.EaseBackIn:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN) then
            local posEnd = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            actionNode:setPosition(-nodeSize.width - actionNode:getPositionX(), posEnd.y)
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = moveAct--cc.EaseBackOut:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_OUT) then
            local posStart = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            local posEnd = cc.p(-nodeSize.width - actionNode:getPositionX(), posStart.y)
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = moveAct--cc.EaseBackIn:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_RIGHT_IN) then
            local posEnd = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            actionNode:setPosition(cc.Director:getInstance():getVisibleSize().width, posEnd.y)
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = moveAct--moveActcc.EaseBackOut:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_RIGHT_OUT) then
            local posStart = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            local posEnd = cc.p(cc.Director:getInstance():getVisibleSize().width, posStart.y)
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = moveAct--cc.EaseBackIn:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN_Ease) then
            local posEnd = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            actionNode:setPosition(-nodeSize.width - actionNode:getPositionX(), posEnd.y)
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = cc.EaseBackOut:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_RIGHT_IN_Ease) then
            local posEnd = cc.p(actionNode:getPositionX(), actionNode:getPositionY())
            actionNode:setPosition(cc.Director:getInstance():getVisibleSize().width, posEnd.y)
            local moveAct = cc.MoveTo:create(time, posEnd)
            uiAct = cc.EaseBackOut:create(moveAct)
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN) then
            actionNode:setAnchorPoint(0, 1)
            actionNode:setScaleY(0)
            local moveAct = cc.ScaleTo:create(0.1, 1.0)
            uiAct = moveAct
        elseif (actionType == SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_UP) then
            actionNode:setAnchorPoint(0, 0)
            actionNode:setScaleY(0)
            local moveAct = cc.ScaleTo:create(0.1, 1.0)
            uiAct = moveAct
        end
        local action = cc.Sequence:create(uiAct, playOnceEndCallBack)
        actionFunc(action)
    end

    playOnceEndCallBack = cc.CallFunc:create(function(sender)
        local window = sender.__cwindow
        if nil ~= window and nil ~= window.onCheckCovers and window.__check_covers then
            window:onCheckCovers(window)
        end
        index = index + 1
        if index > total then
            if callFunc ~= nil then
                callFunc()
            end
            return
        end
        updateMoveActionInfo()
    end)

    updateMoveActionInfo()
end

--正反面旋转动画
--@param 界面对象,背面，正面
function Animations_openCard(m_object,cardBg,cardFg)
    local aniTime = 0.25
    m_object:runAction( cc.Repeat:create( cc.Sequence:create(   
    cc.CallFunc:create(  
        function ( sender )  
            cardFg:setVisible(true)  
            cardBg:setVisible(false)  
            cardFg:runAction( cc.OrbitCamera:create(aniTime/2, 1, 0, 0, 80, 0, 0) )  
        end),  
    cc.DelayTime:create(aniTime/2),  
    cc.CallFunc:create(  
        function ( sender )  
            cardFg:setVisible(false)  
            cardBg:setVisible(true)  
            cardBg:runAction( cc.OrbitCamera:create(aniTime, 1, 0, 270, 90, 0, 0) )  
        end)
    ),
     1) )  
end