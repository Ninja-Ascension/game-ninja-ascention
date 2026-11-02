-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双属性界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AttributeAddition = class("AttributeAdditionClass", Window)
    
function AttributeAddition:ctor()
    self.super:ctor()
	self.roots = {}

	
    -- Initialize AttributeAddition page state machine.
    local function init_trial_tower_terminal()
		
		-- 点击屏幕继续按钮
		local attributeAddition_back_terminal = {
            _name = "attributeAddition_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print("++++++++++++++",instance)
				fwin:close(instance)
		
                return true
            end,
            _terminal = nil,
            _terminals = nil
		
		}
		state_machine.add(attributeAddition_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function AttributeAddition:onUpdateDraw()
	local root = self.roots[1]

	--对位
	function aligning(title, text)
		--调整字左对齐
		local x = title:getPositionX()
		local w = title:getContentSize().width
		text:setPositionX(x + w)
	end
	
	-- 当前的属性列表{属性名 - 属性值}
	local textQ = {
		{"Text_1",  "Text_1_0"},
		
		{"Text_2",  "Text_2_0"},
		
		{"Text_3",  "Text_3_0"},
		
		{"Text_4",  "Text_4_0"},
		
		{"Text_5",  "Text_5_0"},
		
		{"Text_6",  "Text_6_0"},
		
		{"Text_7",  "Text_7_0"},
		
		{"Text_8",  "Text_8_0"},
		
	}

	local atrribute = _ED.three_kingdoms_view.atrribute
	local drawpropertyCount = 0
	local buff = ""
	for i, v in ipairs(atrribute) do		
		if nil ~= tonumber(v[1]) and nil ~= tonumber(v[2]) then
			
			local title = ccui.Helper:seekWidgetByName(root, textQ[i][1])
			local text = ccui.Helper:seekWidgetByName(root, textQ[i][2])
		
			local value,name = getTrialtowerAdditionFormatValue(v[1], v[2]) 
			title:setString(name)
			text:setString(value)
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
			else
				aligning(title, text)
			end
		end
	end
	
	
end

function AttributeAddition:onEnterTransitionFinish()

    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_plus.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)
	
	local sprite_root=ccui.Helper:seekWidgetByName(root, "Panel_20")
	fwin:addTouchEventListener(sprite_root, nil, {func_string = [[state_machine.excute("attributeAddition_back", 0, "attributeAddition_back.'")]]}, nil, 0)
	
	self:onUpdateDraw()
end

function AttributeAddition:onExit()
	
	
	state_machine.remove("attributeAddition_back")
	-- state_machine.remove("trial_tower_init_treasure")
end


