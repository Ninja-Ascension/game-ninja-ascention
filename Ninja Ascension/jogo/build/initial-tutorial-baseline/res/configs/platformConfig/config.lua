-- 渠道
OperatorNameConfig = {
	["t4"] = "t4",			
}

-- 平台参数
OperatorPlatforNameConfig = {
	["com.hyqggw.kkk"] = "0127005012",				
}

-- 充值服务器地址（key为包名）
RechargeServerAddressList = {
	["com.hyqggw.kkk"] = "",
}
	
-- 充值档位信息（key为包名）
PackageRechargeDatas = {
	["com.hyqggw.kkk"] = {
		"com.qggw.hy7",
		"com.qggw.hy6",
		"com.qggw.hy5",
		"com.qggw.hy4",
		"com.qggw.hy3",
		"com.qggw.hy2",
		"com.qggw.hy1"
	},
}

-- 充值类型 官方=0 web=1
RechargeTypeConfig = {
	["com.hyqggw.kkk"] = 1,
}

-- 开启web充值的appid
WebRechangeAppIdConfig = {
	["com.hyqggw.kkk"] = "6532",
}

-- FB打点名
FBMissionNameConfig = {
	[1] = "werryrhdha",
	[2] = "gfhfgjb",
	[3] = "pyufghdfc",
	[4] = "erdfrhfdd",
	[5] = "qwtdtgrge",
}
-- AF打点名
AFMissionNameConfig = {
	[1] = "stuighxc1",
	[2] = "asdtaeryfy2",
	[3] = "xdsdfhftu3",
	[4] = "stserykgh4",
	[5] = "adtfuyui5",
}

-- 打点类型映射
JttdTypeNameConfig = {
	[1] = {eventID= "sweeping", randomStr= "courtyard", delimiter = "!"},
	[2] = {eventID= "another", randomStr= "profits", delimiter = "!"},
	[3] = {eventID= "salary", randomStr= "abandon", delimiter = "!"},
	[4] = {eventID= "barehanded", randomStr= "harboring", delimiter = "!"},
	[5] = {eventID= "circumstances", randomStr= "phasebomb", delimiter = "!"},
	[6] = {eventID= "duckweed", randomStr= "wandering", delimiter = "!"},
	[7] = {eventID= "swallow", randomStr= "singing", delimiter = "!"},
	[8] = {eventID= "against", randomStr= "countenance", delimiter = "!"},
	[9] = {eventID= "opinion", randomStr= "solitary", delimiter = "!"},
}

JttdPointConfig = {key = "YWFhczU0OTY4N2tqO2xmJzsnO3E=", delimiter = ","}

-- 底层通讯交互类型
LuaMessageTypeConfig = {
	messageType = 0
}

-- 底层通讯交互内容
LuaMessageContentConfig = {
	LuaJavaBridge = "com/cocos2dx/lua/LuaJavaBridge",
	registerScriptHandler = "registerScriptHandler",
	handlePlatformRequest = "handlePlatformRequest",
}

-- 底层接入SDK名称
SdkNameConfig = {
	["t4"] = "t4-quick"
}