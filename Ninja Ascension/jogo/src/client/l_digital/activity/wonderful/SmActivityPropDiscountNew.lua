-- ----------------------------------------------------------------------------------------------------

SmActivityPropDiscountNew = class("SmActivityPropDiscountNewClass", Window)
    
function SmActivityPropDiscountNew:ctor()
    self.super:ctor()
	self.roots = {}

	self._acitvity_type = 0
	self.loaded = false
	self._tick_time = 0
	self._endtime = nil

    app.load("client.l_digital.activity.wonderful.SmActivityPropDiscountNewList")

    local function init_SmActivityPropDiscountNew_terminal()
		local sm_activity_prop_discount_update_terminal = {
            _name = "sm_activity_prop_discount_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDrawData()
	            	instance:onUpdateDraw()
	            end
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_activity_prop_discount_update_terminal)
        state_machine.init()
    end
    init_SmActivityPropDiscountNew_terminal()
end

function SmActivityPropDiscountNew:onUpdateDrawData( ... )
    if SmActivityPropDiscountNew.cacheListView == nil then
        return
    end
    for i,v in pairs(SmActivityPropDiscountNew.cacheListView:getItems()) do
        if v ~= nil then
            v:onUpdateDraw()
        end
    end
end

function SmActivityPropDiscountNew:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	local activity = _ED.active_activity[112]
	local endtime = ccui.Helper:seekWidgetByName(root, "Text_32")

	self._endtime = endtime
	self._tick_time = zstring.tonumber(activity.end_time)/1000 - (os.time() + _ED.time_add_or_sub)
	endtime:setString(getRedAlertTimeActivityFormat(self._tick_time).._new_interface_text[245])
    local currentTimess = zstring.split(activity.activity_params, ",")
    local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_ltem_discount") 
    rewardListView:jumpToTop()
    rewardListView:removeAllItems()

    cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    SmActivityPropDiscountNew.asyncIndex = 1
    SmActivityPropDiscountNew.cacheListView = rewardListView
    SmActivityPropDiscountNew.result = nil

    local result = {}
    for k, v in pairs(activity.activity_Info) do
        v._index = k
        table.insert(result, v)
    end

    SmActivityPropDiscountNew.result = result
  
    for i, v in pairs(result) do
        cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
    end

    SmActivityPropDiscountNew.cacheListView:requestRefreshView()
end

function SmActivityPropDiscountNew:loading_cell()
    if SmActivityPropDiscountNew.cacheListView == nil or #SmActivityPropDiscountNew.result<SmActivityPropDiscountNew.asyncIndex then
        return 
    end
    local activity = _ED.active_activity[112]
    local cell = SmActivityPropDiscountNewList:createCell()
    cell:init(activity, SmActivityPropDiscountNew.result[SmActivityPropDiscountNew.asyncIndex]._index, SmActivityPropDiscountNew.cacheListView)
    SmActivityPropDiscountNew.cacheListView:addChild(cell)
    SmActivityPropDiscountNew.cacheListView:requestRefreshView()
    SmActivityPropDiscountNew.asyncIndex = SmActivityPropDiscountNew.asyncIndex + 1
end

function SmActivityPropDiscountNew:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:onInit()
	self:registerOnNoteUpdate(self, 1)
end

function SmActivityPropDiscountNew:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self._tick_time = 0
	self._endtime = nil
    SmActivityPropDiscountNew.cacheListView = nil
	self:unregisterOnNoteUpdate(self)
end

function SmActivityPropDiscountNew:onEnterTransitionFinish()
end

function SmActivityPropDiscountNew:onLoad()

end

function SmActivityPropDiscountNew:onUpdate( dt )
    if self._endtime == nil then
        return
    end
    self._tick_time = self._tick_time - dt
    if self._tick_time <= 0 then
    	self._tick_time = 0
    end
	self._endtime:setString(getRedAlertTimeActivityFormat(self._tick_time).._new_interface_text[245])
end

function SmActivityPropDiscountNew:onInit()
    local csbActivityDoubleDiscount = csb.createNode("activity/wonderful/ltem_discount_live.csb")
    local root = csbActivityDoubleDiscount:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityDoubleDiscount)

	self:onUpdateDraw()
end

function SmActivityPropDiscountNew:init()
	
end

function SmActivityPropDiscountNew:createCell()
	local cell = SmActivityPropDiscountNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function SmActivityPropDiscountNew:onExit()
    SmActivityPropDiscountNew.cacheListView = nil
	state_machine.remove("sm_activity_prop_discount_update")
end