-- ----------------------------------------------------------------------------------------------------
-- 说明：招募活动
-------------------------------------------------------------------------------------------------------
SmActivityRecruitShip = class("SmActivityRecruitShipClass", Window)
    
function SmActivityRecruitShip:ctor()
    self.super:ctor()
	self.roots = {}
	self.activityType = 0
	self.__activityWindow = fwin:find("ActivityWindowClass")

    local function init_sm_activity_recruit_ship_terminal()
		--点击前往
		local sm_activity_recruit_ship_go_get_terminal = {
            _name = "sm_activity_recruit_ship_go_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local page = params._datas.page
				state_machine.excute("shortcut_function_trace", 0, {trace_function_id = page.shortCut, _datas = {}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_activity_recruit_ship_go_get_terminal)
        state_machine.init()
    end
    init_sm_activity_recruit_ship_terminal()
end

function SmActivityRecruitShip:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    local jsonFile = ""
    local atlasFile = ""
	local Panel_recruit_digimon_role = ccui.Helper:seekWidgetByName(root, "Panel_recruit_digimon_role")
	local Panel_btn_name = ccui.Helper:seekWidgetByName(root, "Panel_btn_name")
	local Text_orientation = ccui.Helper:seekWidgetByName(root, "Text_orientation") -- 定位
	local Text_fate = ccui.Helper:seekWidgetByName(root, "Text_fate") -- 缘分
	local Text_info = ccui.Helper:seekWidgetByName(root, "Text_info") -- 简介
	local Text_obtain = ccui.Helper:seekWidgetByName(root, "Text_obtain") -- 获取方式
	if tonumber(self.activityType) == 78 then
		Panel_recruit_digimon_role:setBackGroundImage("images/ui/activity/yy_bg_2.png")
		Panel_btn_name:setBackGroundImage("images/ui/activity/yy_word_2.png")
        jsonFile = "images/ui/effice/effect_huoyanshou/effect_huoyanshou.json"
        atlasFile = "images/ui/effice/effect_huoyanshou/effect_huoyanshou.atlas"
	elseif tonumber(self.activityType) == 79 then
		Panel_recruit_digimon_role:setBackGroundImage("images/ui/activity/yy_bg_3.png")
		Panel_btn_name:setBackGroundImage("images/ui/activity/yy_word_3.png")
        jsonFile = "images/ui/effice/effect_baduola/effect_baduola.json"
        atlasFile = "images/ui/effice/effect_baduola/effect_baduola.atlas"
	elseif tonumber(self.activityType) == 80 then
		Panel_recruit_digimon_role:setBackGroundImage("images/ui/activity/yy_bg_1.png")
		Panel_btn_name:setBackGroundImage("images/ui/activity/yy_word_1.png")
        jsonFile = "images/ui/effice/effect_jialulu/effect_jialulu.json"
        atlasFile = "images/ui/effice/effect_jialulu/effect_jialulu.atlas"
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
		if Panel_effect ~= nil then
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
		end
    end

	local activity = _ED.active_activity[tonumber(self.activityType)]
	local activityData = zstring.split( activity.activity_Info[1].activityInfo_need_day, ",")
	local ShipMouldId = tonumber(activityData[2])
	self.shortCut = tonumber(activityData[1])
	local str_array = activity_recruit_ship_str[tonumber(self.activityType) - 77] 
	Text_obtain:setString(str_array[4])
	Text_info:setString(str_array[3])
	Text_orientation:removeAllChildren(true)
	Text_fate:removeAllChildren(true)
	Text_fate:setString("")
	Text_orientation:setString("")

	local _richText1 = ccui.RichText:create()
    _richText1:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_orientation:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_orientation:getFontSize() * 6
    end

    _richText1:setContentSize(cc.size(richTextWidth, 0))
    _richText1:setAnchorPoint(cc.p(0, 0))
    local char_str = str_array[1]
    local rt, count, text = draw.richTextCollectionMethod(_richText1, 
    char_str, 
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    0, 
    0, 
    Text_orientation:getFontName(), 
    Text_orientation:getFontSize(),
    chat_rich_text_color)
    _richText1:setPositionX((_richText1:getPositionX() - _richText1:getContentSize().width / 2) + (Text_orientation:getContentSize().width-_richText1:getContentSize().width)/2)
    local rsize = _richText1:getContentSize()
    _richText1:setPositionY(Text_orientation:getContentSize().height)
    Text_orientation:addChild(_richText1)

    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth2 = Text_fate:getContentSize().width
    if richTextWidth2 == 0 then
        richTextWidth2 = Text_fate:getFontSize() * 6
    end

    _richText2:setContentSize(cc.size(richTextWidth2, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local char_str = str_array[2]
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    0, 
    0, 
    Text_fate:getFontName(), 
    Text_fate:getFontSize(),
    chat_rich_text_color)
    _richText2:setPositionX((_richText2:getPositionX() - _richText2:getContentSize().width / 2) + (Text_fate:getContentSize().width-_richText2:getContentSize().width)/2)
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_fate:getContentSize().height)
    Text_fate:addChild(_richText2)

end
	
function SmActivityRecruitShip:initDraw()
	local csbSmActivityRecruitShip = csb.createNode("activity/wonderful/sm_recruit_digimon.csb")
    local root = csbSmActivityRecruitShip:getChildByName("root")
    table.insert(self.roots, root)
    --root:removeFromParent(false)
	self:addChild(csbSmActivityRecruitShip)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_card"),nil, 
    {
        terminal_name = "sm_activity_recruit_ship_go_get",       
        terminal_state = 0, 
        isPressedActionEnabled = true,
        page = self,
    }, 
    nil, 0)    
	self:onUpdateDraw()
end

function SmActivityRecruitShip:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
end

function SmActivityRecruitShip:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function SmActivityRecruitShip:onEnterTransitionFinish()
	
end

function SmActivityRecruitShip:onExit()
end

function SmActivityRecruitShip:init(activityType)
	self.activityType = activityType
	-- self:initDraw()
end

function SmActivityRecruitShip:createCell()
	local cell = SmActivityRecruitShip:new()
	cell:registerOnNodeEvent(cell)
	return cell
end