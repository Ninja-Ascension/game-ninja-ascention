local AssetsManagerEx = class("AssetsManagerExClass", Window)

function AssetsManagerEx:ctor()
    self.super:ctor()

    -- Add 'AssetsManagerEx' class variables
    self.storagePath = ""
    -- Initialize manifest file
    self.manifest = "configs/assets.manifest"
    self.manifestFilePath = cc.FileUtils:getInstance():fullPathForFilename(self.manifest)
    self.storagePath = app.storagePath
    -- Initialize c object AssetsManagerEx am.
    self.am =cc.AssetsManagerEx:create(self.manifest, self.storagePath)
    self.am:retain() 
    
    -- Initialize logo page state machine.
    local function init_assetsmanagerex_terminal()
        local assetsmanagerex_goto_login_page_terminal = {
            _name = "assetsmanagerex_goto_login_page",
            _init = function (terminal)
                -- Test machine
                -- local terminal = state_machine.find("logo_goto_login_page")
                -- terminal._instance:scheduler("1", terminal._instance.inLoginPage, 1, false)
                -- terminal._instance:addTimer(terminal._instance.inLoginPage, 0, 2, true, nil)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal._state ~= 0 then return end
                terminal._state = 1 -- To login
                -- show game login page view.
                -- fwin:addBorder(nil) -- add frame window border.
                cacher.destoryRefPools()
                cacher.cleanSystemCacher()
                cacher.cleanActionTimeline()
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_red_alert 
                    or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                    then
                    checkTipBeLeave()
                end                 
                cacher.remvoeUnusedArmatureFileInfoes()
                fwin:reset()
				app.load("client.login.login")
                fwin:open(Login:new(), fwin._screen)
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(assetsmanagerex_goto_login_page_terminal)
        state_machine.init()
    end
    init_assetsmanagerex_terminal()
end

function AssetsManagerEx:onEnter()
    -- Begin check resources update.
    if not self.am:getLocalManifest():isLoaded() then
        --> print("Fail to update assets, step skipped.")
        -- local background = cc.Sprite:create(backgroundPaths[1])
        -- layer:addChild(background, 1)
        -- background:setPosition( cc.p(VisibleRect:center().x, VisibleRect:center().y ))

        self:inLoginPage()
    else
        -- -----------------------------------------------------------------------
        -- //! Update events code
        -- enum class EventCode
        -- {
        --     ERROR_NO_LOCAL_MANIFEST,
        --     ERROR_DOWNLOAD_MANIFEST,
        --     ERROR_PARSE_MANIFEST,
        --     NEW_VERSION_FOUND,
        --     ALREADY_UP_TO_DATE,
        --     UPDATE_PROGRESSION,
        --     ASSET_UPDATED,
        --     ERROR_UPDATING,
        --     UPDATE_FINISHED,
        --     UPDATE_FAILED,
        --     ERROR_DECOMPRESS
        -- };
        -- -----------------------------------------------------------------------
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
			self.eventCode = eventCode
            --> print("evnetCode:", eventCode)
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                --> print("No local manifest file found, skip assets update.")
                -- local background = cc.Sprite:create(backgroundPaths[1])
                -- layer:addChild(background, 1)
                -- background:setPosition( cc.p(VisibleRect:center().x, VisibleRect:center().y ))
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                local assetId = event:getAssetId()
                local percent = event:getPercent()
                local strInfo = ""

                if assetId == cc.AssetsManagerExStatic.VERSION_ID then
                    strInfo = string.format("Version file: %d%%", percent)
                elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                    strInfo = string.format("Manifest file: %d%%", percent)
                else
                    strInfo = string.format("%d%%", percent)
                end
                --> print("----------:", strInfo)
                -- progress:setString(strInfo)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                   eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                --> print("Fail to download manifest file, update skipped.")
                -- local background = cc.Sprite:create(backgroundPaths[1])
                -- layer:addChild(background, 1)
                -- background:setPosition( cc.p(VisibleRect:center().x, VisibleRect:center().y ))
				
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
                eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                --> print("Update finished.")
                -- local background = cc.Sprite:create(backgroundPaths[1])
                -- layer:addChild(background, 1)
                -- background:setPosition( cc.p(VisibleRect:center().x, VisibleRect:center().y ))
				self.eventCode = eventCode
                self:inLoginPage()
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                --> print("Asset ", event:getAssetId(), ", ", event:getMessage())
                -- local background = cc.Sprite:create(backgroundPaths[1])
                -- layer:addChild(background, 1)
                -- background:setPosition( cc.p(VisibleRect:center().x, VisibleRect:center().y ))
            end
        end
        local listener = cc.EventListenerAssetsManagerEx:create(self.am, onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
        
        self.am:update()
    end
end

function AssetsManagerEx:onEnterTransitionFinish()
    local csbAssets = csb.createNode("login/update.csb")
    self:addChild(csbAssets)
	
end 

function AssetsManagerEx:onUpdate(dt)
	eventCode = self.eventCode
	if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
		   eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
		self:inLoginPage()   
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
		eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
		self:inLoginPage()
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
	end
end

function AssetsManagerEx:onCleanup()
    self.am:release()
end

function AssetsManagerEx:inLoginPage()
    state_machine.excute("assetsmanagerex_goto_login_page", 0, "change to 'Login'")
end

function AssetsManagerEx:onExit()
	state_machine.remove("assetsmanagerex_goto_login_page")
end

return AssetsManagerEx:new()