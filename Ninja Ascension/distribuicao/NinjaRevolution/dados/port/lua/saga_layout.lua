-- Keep the original Saga artwork proportional and its translated text in bounds.
local M={}
function M.fit(node,x)
    -- Uniform global scaling keeps the original Saga positions and artwork.
    -- No per-screen horizontal correction is needed.
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
