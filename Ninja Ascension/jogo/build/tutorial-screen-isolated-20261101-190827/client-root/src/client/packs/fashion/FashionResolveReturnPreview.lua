-- ----------------------------------------------------------------------------------------------------
-- 说明：时装重生预览
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
FashionResolveReturnPreview = class("FashionResolveReturnPreviewClass", Window)


--打开界面
local fashion_resolve_return_preview_open_terminal = {
    _name = "fashion_resolve_return_preview_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionResolveReturnPreviewWindow = fwin:find("FashionResolveReturnPreviewClass")
        if FashionResolveReturnPreviewWindow ~= nil and FashionResolveReturnPreviewWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_resolve_return_preview_open", 0, "")

        local cell = FashionResolveReturnPreview:createCell(params)
        fwin:open(cell, fwin._ui)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_resolve_return_preview_close_terminal = {
    _name = "fashion_resolve_return_preview_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        FashionResolveReturnPreview:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fashion_resolve_return_preview_open_terminal)
state_machine.add(fashion_resolve_return_preview_close_terminal)
state_machine.init()

function FashionResolveReturnPreview:ctor()
	closeLastWindow("FashionResolveReturnPreviewClass")
	
    self.super:ctor()
    
	self.roots = {}
	
	self.enum_type = {
		_HeroResolve = 1,		-- 武将分解
		_EquipResolve = 2,		-- 装备分解
		_HeroReborn = 3,		-- 武将重生
		_EquipReborn = 4,       -- 装备重生
	}	
	
	self._relove_type = 1
	self._need_res = nil
	self.type_change_array = {1,5,18,6,7,13}
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize FashionResolveReturnPreview page state machine.
    local function init_fashion_resolve_return_preview_terminal()
     
		
		local fashion_resolve_return_preview_request_terminal = {
            _name = "fashion_resolve_return_preview_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("fashion_recast_page_sender_recast", 0, "")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fashion_resolve_return_preview_request_terminal)
        state_machine.init()
    end
    
    init_fashion_resolve_return_preview_terminal()
end
function FashionResolveReturnPreview:updateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local ListView_223 = ccui.Helper:seekWidgetByName(root, "ListView_223")
	-- ListView_223:removeAllChildren(true)
	ListView_223:removeAllItems()
	self.type_change_array = {1,5,18,6,7,13}
	for i, v in ipairs(_ED.resolve_preview_info.res_info) do
		local tempCell = ResourcesIconCell:createCell()
		tempCell:init(self.type_change_array[v.mould_type], v.value, v.mould_id)
		ListView_223:addChild(tempCell)
		tempCell:showName(v.mould_id,self.type_change_array[v.mould_type])
	end
end

function FashionResolveReturnPreview:onEnterTransitionFinish()
	local csbfenjiefanhuan = csb.createNode("fashionable_dress/fashionable_chongzhu_yulan.csb")
	self:addChild(csbfenjiefanhuan)
	local root = csbfenjiefanhuan:getChildByName("root")
	table.insert(self.roots, root)
	self:updateDraw()
	-- 取消
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16"), nil, 
	{
		terminal_name = "fashion_resolve_return_preview_close", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	-- 确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16_0"), nil, 
	{
		terminal_name = "fashion_resolve_return_preview_request", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	state_machine.unlock("fashion_resolve_return_preview_open", 0, "")
end

function FashionResolveReturnPreview:onExit()
	state_machine.remove("fashion_resolve_return_preview_request")
end

function FashionResolveReturnPreview:init(_relove_type, _need_res)
	self._relove_type = _relove_type
	self._need_res = _need_res
end

function FashionResolveReturnPreview:createCell( ... )
    local cell = FashionResolveReturnPreview:new()
     cell:registerOnNodeEvent(cell)
    return cell
end

function FashionResolveReturnPreview:closeCell( ... )
    local FashionResolveReturnPreviewWindow = fwin:find("FashionResolveReturnPreviewClass")
    if FashionResolveReturnPreviewWindow == nil then
        return
    end
    fwin:close(FashionResolveReturnPreviewWindow)
end
