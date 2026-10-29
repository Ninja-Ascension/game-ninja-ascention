-- Keep the original Saga artwork proportional and its translated text in bounds.
local M={}
function M.fit(node,x)
    local frame=cc.Director:getInstance():getOpenGLView():getFrameSize()
    local aspect=frame.width>0 and frame.height>0 and (frame.height/640)/(frame.width/960) or 1
    -- Wide desktop windows need horizontal compensation; narrow windows retain
    -- the full original canvas so the close button stays reachable.
    aspect=math.min(1,aspect)
    node:setScaleX(aspect)
    local margin=480*(1-aspect)
    node:setPositionX((x or 0)+margin)
    node.__sagaAnchors=node.__sagaAnchors or {}
    local root=node:getChildByName('root')
    for _,name in ipairs({'Image_44_0','Image_3_0_0','Button_draw_back'}) do
        local child=root and ccui.Helper:seekWidgetByName(root,name)
        if child then
            node.__sagaAnchors[name]=node.__sagaAnchors[name] or child:getPositionX()
            -- Title/decoration stay on the left; the close button stays on
            -- the right. Cards and resource counters remain centered.
            child:setPositionX((node.__sagaAnchors[name]-margin)/aspect)
        end
    end
end
local function row(parent,names,center,y)
    local nodes={};local width=0;local gap=4
    for _,name in ipairs(names) do
        local node=assert(ccui.Helper:seekWidgetByName(parent,name),'Saga label missing: '..name)
        node.__sagaScaleX=node.__sagaScaleX or node:getScaleX()
        node.__sagaScaleY=node.__sagaScaleY or node:getScaleY()
        nodes[#nodes+1]=node;width=width+node:getContentSize().width*node.__sagaScaleX
    end
    width=width+gap*(#nodes-1)
    local factor=math.min(1,350/width)
    local x=center-width*factor/2
    for _,node in ipairs(nodes) do
        node:setAnchorPoint(cc.p(0,.5));node:setPosition(cc.p(x,y))
        x=x+(node:getContentSize().width*node.__sagaScaleX+gap)*factor
        node:setScaleX(node.__sagaScaleX*factor);node:setScaleY(node.__sagaScaleY*factor)
    end
end
function M.reflow(window)
    local root=window.roots[1]
    local parent=assert(ccui.Helper:seekWidgetByName(root,'Panel_sp'))
    row(parent,{'Text_alloy_draw_infor_t_1','Text_alloy_draw_infor_n_1','Text_alloy_draw_infor_t_1_0','Text_alloy_draw_infor_n_2','Text_alloy_draw_infor_t_1_0_0'},360,211)
    row(parent,{'Text_alloy_draw_infor_t_3','Text_alloy_draw_infor_n_4','Text_alloy_draw_infor_t_3_0','Text_alloy_draw_infor_n_5','Text_alloy_draw_infor_t_3_0_0'},788,211)
end
return M
