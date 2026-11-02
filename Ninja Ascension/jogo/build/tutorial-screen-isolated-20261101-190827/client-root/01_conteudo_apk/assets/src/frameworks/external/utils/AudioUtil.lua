local m_isBgmOpen
local m_currentBgm
local m_isSoundEffectOpen
local m_last_currentBgm
local m_targetPlatform = cc.Application:getInstance():getTargetPlatform()
local m_old_playEffectId = -1
local m_audio_old_playEffectId = -1
-- NARUTO 3-oct-2026: el motor solo admite 24 sonidos a la vez (AudioEngine::_maxInstances,
-- igual en los dos libjts.so). En combate cada numero de dano pide el MISMO golpe en el mismo
-- instante (3 o 4 copias en 30 ms): llenaban el cupo y los golpes siguientes no sonaban
-- ("Fail to play ... limited max instance"). Un mismo efecto pedido otra vez en menos de
-- PUSH_DEDUP_SEG suena una sola vez (docs/progress.md, 3-oct).
PUSH_DEDUP_SEG = 0.05
local m_push_ultimo = {}
local m_socket
local function ahora_seg()
    if m_socket == nil then
        local ok, s = pcall(require, "socket")
        m_socket = (ok and type(s) == "table" and s.gettime) and s or false
    end
    if m_socket then return m_socket.gettime() end
    return os.clock()
end

function initAudioInfo()
	local opened = cc.UserDefault:getInstance():getStringForKey("initmusic")
	if opened == "" then
		cc.UserDefault:getInstance():setStringForKey("m_isBgmOpen","1")
		cc.UserDefault:getInstance():setStringForKey("m_isSoundEffectOpen","1")
		cc.UserDefault:getInstance():setStringForKey("initmusic", "1")
	end
	
	local result = cc.UserDefault:getInstance():getStringForKey("m_isBgmOpen")
    m_isBgmOpen = tonumber(result) == 1
	result = cc.UserDefault:getInstance():getStringForKey("m_isSoundEffectOpen")
    m_isSoundEffectOpen = tonumber(result) == 1
    cc.UserDefault:getInstance():flush()
end

function isBgmOpen()
	return m_isBgmOpen
end

function iscurrentBgm()
	return m_isSoundEffectOpen
end

function setVolume()
	if(m_isBgmOpen==true)then
		cc.SimpleAudioEngine:getInstance():setMusicVolume(1)
	else
		cc.SimpleAudioEngine:getInstance():setMusicVolume(0)
	end
	if(m_isSoundEffectOpen==true)then
		cc.SimpleAudioEngine:getInstance():setEffectsVolume(1)
	else
		cc.SimpleAudioEngine:getInstance():setEffectsVolume(0)
	end
end

--播放背景音乐
function playBgm(bgm,isLoop)
    if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
    if(bgm~=m_currentBgm)then
        isLoop = isLoop==nil and true or isLoop
        m_currentBgm = bgm
        cc.SimpleAudioEngine:getInstance():stopMusic(true)
		m_last_currentBgm = m_currentBgm
        if(m_isBgmOpen==true and m_currentBgm ~=nil and m_currentBgm ~= "")then
            cc.SimpleAudioEngine:getInstance():playMusic(m_currentBgm,isLoop)
        	cc.SimpleAudioEngine:getInstance():setMusicVolume(1)
        end
    end
end

function stopAllEffects()
	if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
	if cc.SimpleAudioEngine ~= nil and cc.SimpleAudioEngine:getInstance() ~= nil then
		cc.SimpleAudioEngine:getInstance():stopAllEffects()
	end
end

function pauseAllEffects()
	if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
	if cc.SimpleAudioEngine ~= nil and cc.SimpleAudioEngine:getInstance() ~= nil then
		cc.SimpleAudioEngine:getInstance():pauseAllEffects()
	end
end

-- 游戏暂停后回来再次播放音效
function againPlayBgm()
    if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
	stopBgm()
	playBgm(m_last_currentBgm,true)
end

--停止背景音乐
function stopBgm()
    
    if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
    m_currentBgm = nil
	if cc.SimpleAudioEngine ~= nil and cc.SimpleAudioEngine:getInstance() ~= nil then
		cc.SimpleAudioEngine:getInstance():stopMusic()
	end
end

--播放音效
function playEffectOld(effect,isLoop)
    
    if(nil==m_isSoundEffectOpen)then
        initAudioInfo()
    end
    
    isLoop = isLoop==nil and false or isLoop
    
    if(m_isSoundEffectOpen==true) and cc.FileUtils:getInstance():isFileExist(effect) == true then
        -- cc.SimpleAudioEngine:getInstance():stopAllEffects()
        if nil ~= m_audio_old_playEffectId and m_audio_old_playEffectId > 0 then
            cc.SimpleAudioEngine:getInstance():stopEffect(m_audio_old_playEffectId)
            m_audio_old_playEffectId = -1;
        end
        m_audio_old_playEffectId = cc.SimpleAudioEngine:getInstance():playEffect(effect,isLoop)
    end
end

--播放音效
function playEffect(effect,isLoop)
    
    if(nil==m_isSoundEffectOpen)then
        initAudioInfo()
    end
    
    isLoop = isLoop==nil and false or isLoop
    
    if(m_isSoundEffectOpen==true) and cc.FileUtils:getInstance():isFileExist(effect) == true then
        if m_targetPlatform == cc.PLATFORM_OS_MAC 
            or m_targetPlatform == cc.PLATFORM_OS_IPHONE
            or m_targetPlatform == cc.PLATFORM_OS_IPAD
            -- or m_targetPlatform == cc.PLATFORM_OS_WINDOWS 
            then
            -- cc.SimpleAudioEngine:getInstance():stopAllEffects()
            if nil ~= m_audio_old_playEffectId and m_audio_old_playEffectId > 0 then
                cc.SimpleAudioEngine:getInstance():stopEffect(m_audio_old_playEffectId)
                m_audio_old_playEffectId = -1;
            end
            m_audio_old_playEffectId = cc.SimpleAudioEngine:getInstance():playEffect(effect,isLoop)
        else
    		-- cc.SimpleAudioEngine:getInstance():stopAllEffects()
            -- cc.SimpleAudioEngine:getInstance():playEffect(effect,isLoop)
            -- cc.SimpleAudioEngine:getInstance():setEffectsVolume(1)
            -- ccexp.AudioEngine:stopAll()
            m_old_playEffectId = ccexp.AudioEngine:play2d(effect, isLoop, 1)
        end
    end
end

playEffectExt = playEffect

function stopEffect()
    if nil ~= m_old_playEffectId and m_old_playEffectId > 0 then
        ccexp.AudioEngine:stop(m_old_playEffectId)
        m_old_playEffectId = -1
    end
    if nil ~= m_audio_old_playEffectId and m_audio_old_playEffectId > 0 then
        cc.SimpleAudioEngine:getInstance():stopEffect(m_audio_old_playEffectId)
        m_audio_old_playEffectId = -1;
    end
end

function stopEffectEx(effectId)
    if nil ~= effectId and effectId > 0 then
        ccexp.AudioEngine:stop(effectId)
        effectId = -1
    end
end

function play2dPause()
    if m_old_playEffectId > 0 then
        ccexp.AudioEngine:pause(m_old_playEffectId)
    end
end

function play2dResume()
    if m_old_playEffectId > 0 then
        ccexp.AudioEngine:resume(m_old_playEffectId)
    end
end

--播放音效(声音可重叠，战斗中使用)
function pushEffect(effect,isLoop)
    
    if(nil==m_isSoundEffectOpen)then
        initAudioInfo()
    end
    
    isLoop = isLoop==nil and false or isLoop
    
    if(m_isSoundEffectOpen==true) and cc.FileUtils:getInstance():isFileExist(effect) == true then
        if m_targetPlatform == cc.PLATFORM_OS_MAC 
            or m_targetPlatform == cc.PLATFORM_OS_IPHONE
            or m_targetPlatform == cc.PLATFORM_OS_IPAD
            -- or m_targetPlatform == cc.PLATFORM_OS_WINDOWS 
            then
            return cc.SimpleAudioEngine:getInstance():playEffect(effect,isLoop)
        else
         --    cc.SimpleAudioEngine:getInstance():playEffect(effect,isLoop)
        	-- cc.SimpleAudioEngine:getInstance():setEffectsVolume(1)
            if isLoop then
                return ccexp.AudioEngine:play2d(effect, isLoop, 1)
            end
            local t = ahora_seg()
            local ultimo = m_push_ultimo[effect]
            if ultimo ~= nil and t - ultimo[1] >= 0 and t - ultimo[1] < PUSH_DEDUP_SEG then
                return ultimo[2]
            end
            local id = ccexp.AudioEngine:play2d(effect, isLoop, 1)
            if id ~= nil and id >= 0 then
                m_push_ultimo[effect] = {t, id}
            end
            return id
        end
    end
end
--关闭背景音乐
function muteBgm()
    m_isBgmOpen = false
	local bgm = m_currentBgm
	stopBgm()
	m_currentBgm = bgm
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0)
    cc.SimpleAudioEngine:getInstance():stopMusic()
    cc.UserDefault:getInstance():setStringForKey("m_isBgmOpen","0")
    cc.UserDefault:getInstance():flush()
end
--开启背景音乐
function openBgm()
    cc.SimpleAudioEngine:getInstance():setMusicVolume(1)
	local bgm = m_currentBgm
	m_currentBgm = nil
	m_isBgmOpen = true
	playBgm(bgm, true)
    cc.UserDefault:getInstance():setStringForKey("m_isBgmOpen","1")
    cc.UserDefault:getInstance():flush()
end
--关闭音效
function muteSoundEffect()
    m_isSoundEffectOpen = false
    cc.SimpleAudioEngine:getInstance():setEffectsVolume(0)
    cc.UserDefault:getInstance():setStringForKey("m_isSoundEffectOpen","0")
    cc.UserDefault:getInstance():flush()
end

function muteSoundEffect_pause()
    if m_isSoundEffectOpen == true then
		cc.SimpleAudioEngine:getInstance():setEffectsVolume(0)
	end
end
function muteSoundEffect_resume()
	if m_isSoundEffectOpen == true then
		cc.SimpleAudioEngine:getInstance():setEffectsVolume(1)
	end
end
--开启音效
function openSoundEffect()
    m_isSoundEffectOpen = true
    cc.SimpleAudioEngine:getInstance():setEffectsVolume(1)
    cc.UserDefault:getInstance():setStringForKey("m_isSoundEffectOpen","1")
    cc.UserDefault:getInstance():flush()
end

--播放背景音乐
function playMainBgm()
    playBgm("music/background/background_1.mp3")
end
-- 退出场景，释放不必要资源
function release (...) 
    AudioUtil = nil
    package.loaded["AudioUtil"] = nil
    for k, v in pairs(package.loaded) do
        local s, e = string.find(k, "/AudioUtil")
        if s and e == string.len(k) then
            package.loaded[k] = nil
        end
    end
end

function audioUtilUncacheAll( ... )
    -- -- cc.SimpleAudioEngine:getInstance():uncacheAll()
    -- ccexp.AudioEngine:uncacheAll()
end

function audioUtilUncacheAllEx( ... )
    stopAllEffects()
    stopBgm()
    stopEffect()
    stopEffectEx()
    -- cc.SimpleAudioEngine:getInstance():uncacheAll()
    ccexp.AudioEngine:uncacheAll()
end

-- 播放音效
function playEffectMusic(musicIndex)
    -- -- 播放音效
    -- if m_targetPlatform == cc.PLATFORM_OS_MAC1 
    --     or m_targetPlatform == cc.PLATFORM_OS_IPHONE1
    --     or m_targetPlatform == cc.PLATFORM_OS_IPAD1
    --     -- or m_targetPlatform == cc.PLATFORM_OS_WINDOWS
    --     then
    --     playEffectOld(formatMusicFile("effect", musicIndex))
    -- else
    --     return pushEffect(formatMusicFile("effect", musicIndex))
    -- end
    return pushEffect(formatMusicFile("effect", musicIndex))
end

function formatMusicFile(musicType, musicIndex)
	local dif = ".mp3"
	if m_sOperateSystemName == "WP8" then
		dif = ".wav"
	end
    local result = nil
	if musicType == "background" then
		--if musicIndex == 98 or musicIndex == 99 then
			result = string.format("music/background/background_%d"..dif, musicIndex)
			-- result = string.format("music/effect/effect_%d"..dif, musicIndex)
		--else
		--	result = string.format("music/background/music%02d"..dif, musicIndex)
		--end
	elseif musicType == "button" then
		result = string.format("music/button/button_%02d"..dif, musicIndex)
	elseif musicType == "effect" then
		result = string.format("music/effect/effect_%d"..dif, musicIndex)
	end
    if m_targetPlatform == cc.PLATFORM_OS_WINDOWS
        then
        print(result)
    end
    return result
end
