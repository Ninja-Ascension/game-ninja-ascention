-----------------------------------------------------------------------------------------------------------
-- 说明：觉醒道具浏览
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroAwakenPropBrowse = class("HeroAwakenPropBrowseClass", Window)
    
function HeroAwakenPropBrowse:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.tableId = 0 --库组ID
	self.startCount = 0 --星级数
	app.load("client.cells.prop.awaken_compose_browse_list_cell")
    -- Initialize HeroShop page state machine.
    local function init_hero_awaken_prop_browse_terminal()
    	--刷新
		local hero_awaken_prop_browse_update_terminal = {
            _name = "hero_awaken_prop_browse_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    instance:onUpdateDraw()
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(hero_awaken_prop_browse_update_terminal)
		state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_awaken_prop_browse_terminal()
end

function HeroAwakenPropBrowse:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllItems()

	local requirement = dms.int(dms["ship_mould"], self.shipId, ship_mould.base_mould2)
	local grouds = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, requirement)
	local startId = math.floor(zstring.tonumber(self.awakenLevel)/10)
	for i=startId*10 + 1,startId*10 + 10 do
		if grouds[i] == nil then 
			break
		end
		local cell = AwakenComposeBrowseListCell:createCell()
		cell:init(grouds[i])
		listView:addChild(cell)
	end
	listView:refreshView()
end

function HeroAwakenPropBrowse:onEnterTransitionFinish()		
    local csbHeroShop = csb.createNode("packs/HeroStorage/generals_juexing_daojuyulan.csb")
  	local root = csbHeroShop:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("HeroAwakenPropBrowseClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guanbi"), nil, 
	{
		func_string = [[fwin:close(fwin:find("HeroAwakenPropBrowseClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)
	self:onUpdateDraw()
end

function HeroAwakenPropBrowse:init(shipId,awakenLevel)
	self.shipId = shipId 
	self.awakenLevel = awakenLevel 
end

function HeroAwakenPropBrowse:close()

end

function HeroAwakenPropBrowse:onExit()
	

end


