-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏英雄副本界面
-------------------------------------------------------------------------------------------------------
LgeneralCopyListCell = class("LgeneralCopyListCellClass", Window)
LgeneralCopyListCell.__size = nil
LgeneralCopyListCell.length = 0
LgeneralCopyListCell.textPositionY = 0
function LgeneralCopyListCell:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.getStarCount = 0
	self.types = nil
	self.mySceneID = nil
	self.currentSceneType = nil 
	self.nowAttackSceneId = nil
    local function init_generalcopy_cell_terminal()
		-- 预留	
		local generalcopy_cell_click_terminal = {
            _name = "generalcopy_cell_click",
            _init = function (terminal) 
				app.load("client.landscape.duplicate.pve.LPVEScene")
				app.load("client.landscape.duplicate.pve.LPVEMap")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("lduplicate_window_visible",0, false)
				state_machine.excute("lgeneral_copy_window_visible",0,false)
				state_machine.excute("lduplicate_window_pve_quick_entrance", 0, {_type = 3, _sceneId = params._datas.sceneID})			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(generalcopy_cell_click_terminal)
        state_machine.init()
    end   
    init_generalcopy_cell_terminal()
end



function LgeneralCopyListCell:init(sceneID,nowAttackSceneId,drawIndex)
	self.mySceneID = sceneID
	self.nowAttackSceneId = nowAttackSceneId
	self.currentSceneType = dms.int(dms["pve_scene"], self.mySceneID, pve_scene.scene_type)
	
	self.drawIndex = drawIndex

	if drawIndex ~= nil then --and drawIndex < 7 then
		self:onInit()
	end
	self:setContentSize(LgeneralCopyListCell.__size)
	return self
end

function LgeneralCopyListCell:onInit()
	local root = cacher.createUIRef("duplicate/pve_yingxing_k.csb", "root")
 	table.insert(self.roots, root)
	root:removeFromParent(false)
 	self:addChild(root)

	if LgeneralCopyListCell.__size == nil then
		local Panel_generals_copy_icon = ccui.Helper:seekWidgetByName(root, "Panel_zhangjie_3")
		local Panel_generals_copy_icon_size = Panel_generals_copy_icon:getContentSize()
		LgeneralCopyListCell.__size = Panel_generals_copy_icon_size
	end
	self:updateDraw()


	
end
function LgeneralCopyListCell:updateDraw()
	local root = self.roots[1]
	--背景图
	local Panel_zhangjie_3 =  ccui.Helper:seekWidgetByName(root, "Panel_zhangjie_3")
	local Sprite_zhangjie = Panel_zhangjie_3:getChildByName("Sprite_zhangjie")
	local picindex = dms.int(dms["pve_scene"], self.mySceneID, pve_scene.scene_entry_pic)
	--print("picindex",picindex) 
	Sprite_zhangjie:setTexture("images/ui/pve_sn/gameElite/gameElite_" .. picindex ..".png")
	--点击响应
	local panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
	panel_4:setTouchEnabled(true)
	
	local Text_gk_kaiqi_1 = ccui.Helper:seekWidgetByName(root, "Text_gk_kaiqi_1") 
	Text_gk_kaiqi_1:setVisible(false)
	
	--createSprite
	local posx=Sprite_zhangjie:getPositionX()-32
	local posy=Sprite_zhangjie:getPositionY()-32
	Sprite_zhangjie:setVisible(false)
	local sp_zhangjie = cc.Sprite:create()
	panel_4:removeAllChildren(true)
	sp_zhangjie:setPosition(cc.p(posx,posy))
	panel_4:addChild(sp_zhangjie)
	sp_zhangjie:setTexture("images/ui/pve_sn/gameElite/gameElite_" .. picindex ..".png")
	--
	local Panel_zhangjie_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhangjie_dh")
	Panel_zhangjie_dh:setVisible(false)
	--未开启
	if self.mySceneID > self.nowAttackSceneId then
		display:gray(sp_zhangjie)--Sprite_zhangjie)
		local describe=dms.string(dms["pve_scene"], self.mySceneID, pve_scene.open_condition_describe)
		--print("describe",describe)
		Text_gk_kaiqi_1:setString(describe)
		Text_gk_kaiqi_1:setVisible(true)
		panel_4:setTouchEnabled(false)
		Panel_zhangjie_dh:setVisible(false)
	elseif  self.mySceneID == self.nowAttackSceneId  then
		Panel_zhangjie_dh:setVisible(true)
	end
	
	--星星
	local star1 = ccui.Helper:seekWidgetByName(root, "Image_yx_star_1")
	local star2 = ccui.Helper:seekWidgetByName(root, "Image_yx_star_2")
	local star3 = ccui.Helper:seekWidgetByName(root, "Image_yx_star_3")
	local star4 = ccui.Helper:seekWidgetByName(root, "Image_yx_star_4")
	self.getStarCount = tonumber(_ED.get_star_count[self.mySceneID])
	--print("...........：",self.getStarCount)
	if self.getStarCount == 1 then
		star1:setVisible(true)
		star2:setVisible(false)
		star3:setVisible(false)
		star4:setVisible(false)
	elseif self.getStarCount == 2 then
		star1:setVisible(true)
		star2:setVisible(true)
		star3:setVisible(false)
		star4:setVisible(false)
	elseif self.getStarCount == 3 then
		star1:setVisible(true)
		star2:setVisible(true)
		star3:setVisible(true)
		star4:setVisible(false)
	elseif self.getStarCount == 4 then
		star1:setVisible(true)
		star2:setVisible(true)
		star3:setVisible(true)
		star4:setVisible(true)
	end
	-- 是否通关
	local Image_tongguan = ccui.Helper:seekWidgetByName(root, "Image_tongguan")
	if self.getStarCount == 4 then
		Image_tongguan:setVisible(true)
	else
		Image_tongguan:setVisible(false)	
	end

	
	--章节文字
	local Text_zhangjie = ccui.Helper:seekWidgetByName(root, "Text_zhangjie")
	Text_zhangjie:setString("")
	Text_zhangjie:setVisible(false)
	local text = dms.string(dms["pve_scene"], self.mySceneID, pve_scene.scene_name)
	if Text_zhangjie.initY == nil then
		Text_zhangjie.initY = Text_zhangjie:getPositionY()
	end
	--Text_zhangjie:setPositionY(Text_zhangjie.initY)
	-- print("zhangjie:",text)
	--文字高对齐 有问题
	--print("------",Text_zhangjie.initY)
	local length = 0
	Text_zhangjie:setString(text)	
	length = zstring.utfstrlenServer(text) -- 文字个数
	Text_zhangjie:setPositionY(Text_zhangjie.initY - length*22)
	--print("------",text,length,Text_zhangjie.initY - length*22)
	Text_zhangjie:setMaxLineWidth(36)
	--createFont
		local Panel_1454 = ccui.Helper:seekWidgetByName(root, "Panel_1454")
		local Panel_1454_0 = ccui.Helper:seekWidgetByName(root, "Panel_1454_0")
		
		local textposx = Text_zhangjie:getPositionX()
		local textposy = Text_zhangjie:getPositionY()
		
		local textfont = cc.LabelBMFont:create(text,"fonts/zhangjiename.fnt")
		textfont:setPosition(cc.p(textposx,textposy))
		textfont:setWidth(36)
		Panel_1454_0:removeAllChildren(true)
		Panel_1454_0:addChild(textfont)
		if text == _string_piece_info[199] then
			textfont:setPosition(cc.p(textposx+20,textposy))
		end
		
	--

	
	--英雄秘史
	local Panel_zhuming = ccui.Helper:seekWidgetByName(root, "Panel_zhuming")
	Panel_zhuming:setVisible(false)
	local scene_type = dms.int(dms["pve_scene"], self.mySceneID, pve_scene.scene_type)
	if scene_type == 10 then
		Panel_zhuming:setVisible(true)
	end
	
	

	panel_4:setSwallowTouches(false)
	fwin:addTouchEventListener(panel_4, nil, 
	{
		terminal_name = "generalcopy_cell_click", 
		terminal_state = 0, 
		sceneID = self.mySceneID,
		currentPageType = 3
	},
	nil, 0)
end
function LgeneralCopyListCell:onEnterTransitionFinish()

end
function LgeneralCopyListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LgeneralCopyListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("duplicate/pve_yingxing_k.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function LgeneralCopyListCell:createCell()
	local cell = LgeneralCopyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function LgeneralCopyListCell:onExit()
	cacher.freeRef("duplicate/pve_yingxing_k.csb", self.roots[1])
	state_machine.remove("generalcopy_cell_click")
end
