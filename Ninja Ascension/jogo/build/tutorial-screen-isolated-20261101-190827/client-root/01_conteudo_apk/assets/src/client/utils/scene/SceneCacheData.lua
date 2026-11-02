------------------------------------------------------------------------------
-- 场景缓存数据,用于场景切换后回到原场景时需要处理的数据.
-- 例如,在竞技场->战斗场景->胜利界面->回到竞技场. 这一过程中各个场景都比较独立,数据传递比较不容易串联.
-- 所以,在竞技场离开时,记录下当前数据,当回来时再读取显示变化

-- 备注:后续可能再添加切换场景时,是否刷新缓存数据.
-- 在切换场景时,发出通知消息,各场景处理决定是否刷新自己的场景缓存.
------------------------------------------------------------------------------
-- 请在这里注册场景名及数据格式,再调用.不要在外面动态添加场景名.便于统一管理.
------------------------------------------------------------------------------
-- to:李彪
------------------------------------------------------------------------------

-- app.load("client.utils.scene.SceneCacheData")

-- 数据存储对象
SceneCacheData = SceneCacheData or {}

-- 数据初始化实例(私有)
local SceneCacheDataInit = {}

-- 数据名枚举
SceneCacheNameEnum = {
	ARENA = "Arena",
	PLUNDER = "Plunder",
}

local function debugCacheData(typeName, key, value, logString)

	--> print(string.format("SceneCacheData----[key: %s]--[name: %s]----[log: %s]",key,typeName,logString),logString)
	--> print("------------------[value]---->",value)
end

-- 检查是否存在数据 (key就是枚举,不允许外部定义)
SceneCacheData.has = function(key)
	if nil == SceneCacheData[key] then
		return	false
	end
	return true
end

-- logString : 是用于 数据操作追踪时填入输出标记,以确认操作位置

-- 写入数据 (key就是枚举,不允许外部定义)
SceneCacheData.write = function(key, value, logString)
	--> print("-----------------------------------------",logString)
	debugCacheData("write",key, value, logString)
	SceneCacheData[key] = value
end

-- 删除数据 (key就是枚举,不允许外部定义)
SceneCacheData.delete = function(key, logString)
	debugCacheData("delete", key, value,logString)
	SceneCacheData.write(key, nil)
end

-- 读取数据 (key就是枚举,不允许外部定义)
SceneCacheData.read = function(key, logString)
	debugCacheData("read", key,logString)
	local data = SceneCacheData[key]
	
	-- 出于数据操作安全考虑,暂不开放该参数的操作处理
	-- 注意.读取之后时候是否删除调用者自己决定
	-- if true == isDetele then
		-- SceneCacheData.delete(key)
	-- end
	return data
end

SceneCacheData.deleteAll = function(logString)
	debugCacheData("deleteAll", "", "",logString)
	--SceneCacheData = {}
	for k,v in pairs(SceneCacheNameEnum) do
		SceneCacheData.delete(v, logString)
	end
end

-- 获取数据定义的新实例 (key就是枚举,不允许外部定义)
SceneCacheData.getInitExample = function(key)
	return SceneCacheDataInit[key]()
end 

------------------------------------------------
-- 数据格式定义
------------------------------------------------

-- 竞技场
SceneCacheDataInit[SceneCacheNameEnum.ARENA] = function()
	return{
			lastX = 0,	--最后离开时的坐标X
			lastY = 0,	--最后离开时的坐标Y
			lastQueue = {}, --最后离开时的队列数据
			targetIndex = targetIndex,--战斗当前的目标
	}
end

-- 抢夺
SceneCacheDataInit[SceneCacheNameEnum.PLUNDER] = function()
	return{
			lastIndex = 0,	--最后离开时的页面索引位置
			isWin = nil,	--是否抢夺成功 nil未设置,true/false是设置值
			rewardMouldId = nil, --成功时获得的碎片模板id
			propMouldId = nil,--抢夺时的碎片信息
			-- isShow = nil,	--标记回到抢夺时,时候检查
	}
end
