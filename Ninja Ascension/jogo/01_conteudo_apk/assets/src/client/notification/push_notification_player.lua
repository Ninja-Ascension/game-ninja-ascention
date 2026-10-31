-- Initialize push notification center state machine.
local function init_push_notification_center_player_terminal()
	
	
    
    state_machine.init()
end
init_push_notification_center_player_terminal()

-- 判断是否有新获得的头像/新解锁的头像印记
function getPlayerAllHeadFrameState()
	local playerHeadFrame = _ED.user_info.head_frame
	local info = nil
	if playerHeadFrame == nil then
		return false
	end
	info = playerHeadFrame.info
	for i, v in pairs(info) do
		if getPlayerHeadFrameStateByID(v.headFrameID) then
			return true
		end
	end
	return false
end

-- 判断该头像框当前是否展示红点
function getPlayerHeadFrameStateByID(headFrameID)
	if getPlayerNewHeadFrameStateByID(headFrameID) then
		return true
	end

	if getPlayerNewHeadFrameImprintStateByID(headFrameID) then
		return true
	end

	return false
end

-- 获得新头像时显示红点
function getPlayerNewHeadFrameStateByID(headFrameID)
    local headFrameString = readKey("player_head_frame")
    local info = _ED.user_info.head_frame.info
	if info[headFrameID] == nil then
		return false
	end
	
    if headFrameString == nil or headFrameString == "" then
        return true
    end

	local isNotExist = true
	local headFrameStorageInfo = zstring.splits(headFrameString, "|", ",", tonumber)
	for k, v in pairs(headFrameStorageInfo) do
		if v[1] ~= nil and v[1] == headFrameID then
			isNotExist = false
			break
		end
	end
	return isNotExist

end

-- 解锁新阶段时显示红点
function getPlayerNewHeadFrameImprintStateByID(headFrameID)
	local headFrameString = readKey("player_head_frame")
    local info = _ED.user_info.head_frame.info
	if info[headFrameID] == nil then
		return false
	end
	local curData = info[headFrameID]
    if headFrameString == nil or headFrameString == "" then
        return true
    end

	local preStage = -1
	local imprintNums = curData.imprintNums
	local curImprintStage = curData.curStage
	local headFrameStorageInfo = zstring.splits(headFrameString, "|", ",", tonumber)
	local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, headFrameID)[1]
	local costImprintNumsInfo = zstring.split(dms.atos(headFrameInfo, face_frame_mould.imprintStage), ",", tonumber)
	local maxStage = 0

	for i, v in ipairs(costImprintNumsInfo) do
		if imprintNums >= v then
			maxStage = i
		end
	end
	
	for k, v in pairs(headFrameStorageInfo) do
		if v[1] == headFrameID then
			preStage = v[2]
			break
		end
	end

	if preStage < maxStage then
		return true
	end

	return false
end