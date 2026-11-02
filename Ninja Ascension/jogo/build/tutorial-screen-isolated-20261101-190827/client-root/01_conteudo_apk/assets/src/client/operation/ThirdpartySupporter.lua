CC_SUBMIT_CRASH_REPORT								= -1000
CC_APPLICTION_RESUME								= -311
CC_APPLICTION_PAUSE									= -310
CC_CALL_SYSTEM_GC_COLLECT							= -300
SYS_EXIT_APPLICATION								= -200	--退出系统应用
SHOW_EDITBOX		                                = -100	--显示编辑区域
SHOW_SYS_EXIT_DIALOG                                = -2	--显示系统退出对话
SHOW_EXIT_DIALOG                                    = -1	--显示退出对话
CHECK_CDN_DOWNLOAD_STATE	                        = -5	--下载完成或者缺失资源（1，2，文件名）1表示中断下载完成，2表示开始下载完成一个包
CHECK_CDN_SYNC_DOWNLOAD_RESOURCES					= -4	--请求中断下载
CHECK_CDN_DOWNLOAD_RESOURCES                        = -3	--请求开始下载
UPDATEVERSION                                       = 0		--版本更新
UPDATE_NO_NEW_VERSION                               = 1		--没有可以更新的版本
UPDATE_FORCE_UPDATE_CANCEL_BY_USER                  = 2		--用户取消强制更新
UPDATE_NORMAL_UPDATE_CANCEL_BY_USER                 = 3		--用户取消普通更新
UPDATE_NEW_VERSION_DOWNLOAD_FAIL                    = 4		--新版本更新失败
UPDATE_CHECK_NEW_VERSION_FAIL                       = 5		--新版本更新检查失败
LOGIN                                               = 10	--登录
LOGIN_SUCCESS                                       = 11	--登入成功
LOGIN_CANCEL                                        = 12	--登入取消
LOGIN_LOSE                                          = 13	--登入失败
LOGIN_AGAIN											= 14	--重新登录
LOGOUT                                              = 20	--注销，切换账号
LOGOUT_SUCCESS	                                    = 21	--注销成功
ENTERPLATFORM									    = 30	--登录平台
PLATFORMRECHARGE									= 40	--平台充值
RECHARGESUCCESS                                     = 41	--平台充值成功
RECHARGELOSE                                        = 42	--平台充值失败
CC_INITIALIZE_RECHARGE_PARAM                        = 43	--初始化App
RETURNLOGINFACE									 	= 50	--取消平台充值
REGISTER											= 60	--注册
REGISTER_USER_ALREADER_EXIST						= 61	--注册用户已经存在
REGISTER_SUCCESS									= 62	--注册成功
REGISTER_LOSE										= 63	--注册失败
CHECK_USER											= 70	--检查用户
CHECK_USER_ALREADER_EXIST							= 71	--检查用户已经存在
CHECK_USER_NONEXISTENT								= 72	--检查用户不存在
VERIFY_RECEIPT_SOUCCESS							 	= 80	--核实收据成功
SAVE_RECEIPT										= 81	--储存收据
CLEAR_RECEIPT										= 82	--清除收据
REGISTER_ONEREGISTER								= 90	--注册一个账号
REGISTER_ONEREGISTER_SUCCESS						= 91	--注册一个账号成功
REGISTER_ONEREGISTER_LOSE							= 92	--注册一个账号失败
BINDACCOUNT										 	= 100	--绑定账号
BINDACCOUNT_SUCCESS								 	= 101	--绑定账号成功
BINDACCOUNT_LOSE									= 102	--绑定账号失败
COLLECT_CRASH_REPORT								= 110	--收集崩溃信息
COLLECT_CRASH_REPORT_END							= 111	--收集崩溃信息结束
OURPALM_FINDONEUSER								 	= 120	--找到一个掌趣用户
OURPALM_JUDGEUSER									= 121	--发现掌趣用户
ENTERED_THE_GAME									= 130	--进入游戏
INIT_APP_NAME										= 140	--初始化应用名称
BUG_FEEDBACK										= 150	--BUG反馈
BUG_SUBMIT_TO_91PLATFORM							= 151	--BUG提交给19平台
INIT_PLATFORM_EXTRAS								= 160	--初始化平台附加信息
INIT_OPERATION_PARAMS								= 161
PLATFORM_ACCOUNT_MANAGER							= 170	--平台账号管理
CC_MARKETPLACE_REVIEW_TASK							= 180
CC_MEET_THE_OF_AGE_13_TASK							= 181
CC_OPEN_URL										 	= 190
FOUND_ROLE											= 191	--创建角色
CC_OPEN_URL_LAYOUT									= 192   --打开url布局
CC_PLATFORM_TYPE									= 193   --确定平台类型
CC_EXIT_PLATFORM							 	    = 200
CC_LOGOUTGAME							 			= 210
CC_INIT_PLATFORM_PARAM						 		= 220
CC_CLEAN_PLATFORM_PARAM						     	= 230
CC_PLATFORM_PAUSE								    = 240
CC_PLATFORM_RESUME								    = 250
CC_DESTORY_PLATFORM								 	= 260
CC_ENTER_PLATFORM_BBS								= 270
CC_MARKETPLACE_DETAIL_TASK							= 280
CC_SHOW_GAME_CENTER								 	= 290		
CC_SHOW_GLEADERBOARD								= 300		
CC_SHOWACHIEVEMENT									= 310
CC_ADD_DOWNLOAD_URL								 	= 320
CC_DELETE_DOWNLOAD_FOLDER							= 321
CC_TRANSFER_PROGRESS								= 322
CC_TRANSFER_ERROR									= 323
CC_TRANSFER_FILE_UNZIP								= 324
CC_SYSTEM_PAUSE										= 325
CC_EXIT_APPLICATION							 	 	= 326
CC_SYSTEM_SOFTKEYBOARD							 	= 327
CC_INIT_TALKINGDATA							 	    = 330
CC_RESUME_TALKINGDATA							 	= 331
CC_PAUSE_TALKINGDATA							 	= 332
CC_TALKINGDATA_SET_ACCOUNT						 	= 333
CC_TALKINGDATA_SET_ACCOUNT_TYPE				 	 	= 334
CC_TALKINGDATA_SET_ACCOUNT_NAME				 	 	= 335
CC_TALKINGDATA_SET_LEVEL						 	= 336
CC_TALKINGDATA_SET_GENDER						 	= 337
CC_TALKINGDATA_SET_AGE		  					 	= 338
CC_TALKINGDATA_SET_GAME_SERVER					 	= 339
CC_TALKINGDATA_RECHARGE_CHANGE_REQUEST			 	= 340
CC_TALKINGDATA_RECHARGE_CHANGE_SUCCESS			 	= 341
CC_TALKINGDATA_REWARD_GOLD						 	= 342
CC_TALKINGDATA_PURCHASE						 	 	= 343
CC_TALKINGDATA_USE								 	= 344
CC_TALKINGDATA_TASK_BEGIN						 	= 345
CC_TALKINGDATA_TASK_COMPLETED					 	= 346
CC_TALKINGDATA_TASK_FAILED						 	= 347
CC_TALKINGDATA_CUSTOM_EVENT					 	 	= 348
CC_FACEBOOK_CLOSE									= 400	--facebook退出
CC_GET_SERVERS_ID									= 401	--获取服务器id
CC_BUY_PROP											= 402	--购买道具
CC_IS_DISPLAY_PLATFORM								= 410--显示个人中心
CC_IS_DISPLAY_ACCOUNT								= 411--显示切换账号
COLLECT_CRASH_REPORT_TESTIN							= 500--testin的崩溃追踪
CC_GET_PAY_INFO										= 2500 --获取支付信息
CC_PAY_INFO_OVER									= 2501 --获取支付信息结束
CC_PLATFORM_SHOW_BUOY								= 2600 --显示平台的浮标
CC_PLATFORM_HIDE_BUOY								= 2601 --隐藏平台的浮标
CC_GAME_OPEN_EXIT									= 2602 --打开游戏退出界面
CC_GAME_EXIT_DETERMINE								= 2603 --游戏退出界面确定
CC_GAME_DAYA_TRACKING								= 3000 --登陆成功后的数据报送
CC_GAME_PAYSUCCESS_TRACKING							= 3001 --支付成功后的数据报送
CC_ROLE_CREATION									= 3002 --角色创建
CC_ROLE_UPGRADE										= 3003 --角色升级
CC_FORM_OFFSET_REDUCTION							= 3004 --界面偏移还原
CC_SHARE_REQUEST									= 3005 --请求分享
CC_SHARE_SUCCESS									= 3006 --分享成功
CC_SCORE_START										= 3007 --请求评分
CC_SCORE_SUCCESS									= 3008 --评分成功
CC_GET_CURRENT_LANGUAGE								= 4000 --获取当前系统语言环境
CC_GET_PUSH_NOTIFICATION							= 4001 --本地推送信息
CC_GET_EXTERNAL_PATH								= 4002 --获取
CC_OPEN_FANS_PAGE									= 4003 --进入粉丝页
CC_FACEBOOK_FRIENDS_REQUEST							= 4004 --facebook好友请求
CC_FACEBOOK_FRIENDS_RETURN							= 4005 --facebook好友返回
CC_FACEBOOK_FRIENDS_INVITE							= 4006 --facebook好友邀请
CC_FACEBOOK_FRIENDS_INVITE_SUCCESS					= 4007 --facebook好友邀请成功
CC_GET_PUSH_NOTIFICATION_REQUEST					= 4008 --本地推送信息请求
CC_VOICE_SEND_REQUEST								= 4009 --语音发送请求
CC_VOICE_SEND_OVER                                  = 4010 --语音发送结束
CC_VOICE_RECEIVE_SUCCESS							= 4011 --语音接收成功
CC_VOICE_URL_PLAY									= 4012 --网路语音播放
CC_PREVENT_DECOMPILE_ONE							= 4013 --防止反编译控制1
CC_PREVENT_DECOMPILE_TWO							= 4014 --防止反编译控制2
CC_COPY_PASTE_TEXT_START							= 4015 --COPY并粘贴text开始
CC_COPY_PASTE_TEXT_OVER								= 4016 --COPY并粘贴text结束
CC_FACEBOOK_ACTIVITY                                = 4017 --facebook按钮状态
CC_GOTO_EVALUATEGAME                                = 4018 --前往评价游戏
CC_FACEBOOK_LIKES							 	 	= 4019 --FaceBook点赞
CC_FACEBOOK_APPEVENTSLOGGER							= 4020 --FACEBOOK的事件埋点
CC_FACEBOOK_BE_INVITED                              = 4022 --facebook点击被邀请领奖如果未登陆则请求
CC_REMOVE_PUSH_NOTIFICATION							= 4023 --本地推送清除
CC_FACEBOOK_HOME                                    = 4024 --facebook客户端
CC_GET_SIGNAL_AND_NETWORK							= 4025 --信号强度网络延迟
CC_GET_RETURN_SIGNAL_AND_NETWORK					= 4026 --返回信号强度网络延迟
CC_SENT_INPUT_INFO									= 4027 --输入框确认按钮信息
CC_DATA_STATISTICS									= 4028 --数据信息统计
CC_USER_CENTER										= 4029 --T4SDK用户中心
CC_RECHAEGE_LIST 									= 4030 --T4SDK充值列表	
CHANGE_CLOAK_GAME 									= 6001 --伪装事件
SEND_PURCHASE_INFO 									= 6002 --向底层发送谷歌档位信息

platform_extras = ""
if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE 
or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD 
or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
	platform_extras = app.configJson.OperatorName
end

package_rc = "1.0"
m_sURL = ""
m_sURL_IP = ""
m_tOperateSystem = 3
m_tOperator = "jar-world"
m_tOperationPlatform = 1
m_tUserAccountPlatform = 1
m_tApplicationStore = 1
m_tReleaseLanguage = 1
m_tReleaseVersionStyle = 1
m_tReleaseProject = 5
m_sOperatorName = app.configJson.OperatorName
m_sOperationPlatformName = app.configJson.OperationPlatformName
m_sUserAccountPlatformName = app.configJson.UserAccountPlatformName
m_sUserAccountPlatformNameExt = ""
m_sUserAccountPlatformNameExtTwo = ""
m_sPayMould = ""
m_iStartLogCount = 1
m_sOperateSystemName = ""
m_tResourceMap = 0
m_tResourcePicture = 0
m_sVersion = app.configJson.version

m_sUin = ""
m_sSessionId = ""
m_platformTokenKey = ""
m_platformRefreshtokens = ""

m_interior_url=""

m_register_username=""
m_register_password=""

m_reqcharge_info = {}

m_platform_tx_login_info = ""

m_platform_app_value = ""
m_platform_app_ptext = ""

m_tx_pay_start = false
m_tx_pay_over = false

m_tx_pay_index = 0

m_get_pay_info = 0

m_roleName_info = ""

m_current_language = "zh-cn"

m_videoPlayer = nil

m_show_data_aid = nil

--facebook进入游戏的好友
m_aladion_facebook_friends = ""
--facebook未进入游戏的好友
m_aladion_facebook_graph_path = ""
--邀请了的facebook好友
m_aladion_facebook_invite = ""

m_push_platform_id = ""

m_tencent_pay_number = 1
m_play_pay_type = ""

m_loading_start = true

m_channel_confirm = false

m_copy_paste_text_info = nil

m_fb_button_show = 1

m_my_fb_id = nil --当前登陆的facebook id

m_curr_choose_language = ""

m_system_default_language = ""	--当前系统默认语言

m_recharge_protocol_is_ok = false
m_recharge_thirdparty_is_ok = false

m_account_sys_floating_switch = false

m_account_sys_user_name = ""
m_account_sys_user_password = ""

m_first_role = false

m_login_search_user = false
--t4的渠道接入对应的参数-------
T4_App_package_name = "com.gftun.d11supp.us"
T4_App_account_mark = "5"

m_sdk_init_success = false
m_sdk_login_success = false
------------------------------

if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE 
or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD 
or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
	m_sOperateSystemName = cc.Application:getInstance():getTargetPlatform()						--操作系统名称
	m_tOperateSystem = app.configJson.OperateSystem--操作系统
	m_tReleaseLanguage = app.configJson.ReleaseLanguage--发布语言
	m_tReleaseProject = app.configJson.ReleaseProject--发布项目
	__lua_project_id = zstring.tonumber(m_tReleaseProject)
	m_sOperatorName = app.configJson.OperatorName	--运营商名称
	local sliptPlatformName = zstring.split(app.configJson.OperationPlatformName,"|")
	m_sOperationPlatformName = sliptPlatformName[1] == nil and app.configJson.OperationPlatformName or sliptPlatformName[1] --操作平台的名字
	m_sUserAccountPlatformNameExt = sliptPlatformName[2]	--操作平台的名字1
	m_sUserAccountPlatformNameExtTwo = sliptPlatformName[3] --操作平台的名字2
	m_sUserAccountPlatformName = app.configJson.UserAccountPlatformName	--用户账户来源
	m_sPayMould = app.configJson.PayMould					--支付类型
	m_sVersion = app.configJson.version						--资源版本号
	
	package_rc = cc.UserDefault:getInstance():getStringForKey("package")
	cc.UserDefault:getInstance():flush()
	if #package_rc <= 0 then
		package_rc = "0.0"
	end
end

function Sleep(n)
   os.execute("sleep " .. n)
end

local function submitCrashReport(pText)
	--push_method("::submitCrashReport")
	--local ss = print_crash_reoprt_log()
	--pop_method()
	
	local errorFunc = "LUA Func\r\n"
	local errorLine = "0\r\n"
	local errorName = "LUA ERROR\r\n"
	local errorMsg = "LUA ERROR: " .. debug.traceback() .. "\r\n"
	local traceback = pText
	local tbString = errorFunc..errorLine..errorName..errorMsg .. traceback
	if protocol_command.record_crash.param_list ~= tbString then
		protocol_command.record_crash.param_list = tbString
        	local request = NetworkManager:register(protocol_command.record_crash.code, nil, nil, nil, nil, nil, false, nil)
		NetworkAdaptor.send(request)
	end
	
	Sleep(2)
end
local function responseSearchUserPlatform(_cObj, _tJsd)
	local pNode = tolua.cast(_cObj, "CCNode")
	local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
	if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
	end
	local user_info = _ED.user_platform[_ED.default_user]
		-- if table.getn(_ED.user_platform) > 0 then
	if m_sUserAccountPlatformNameExt == "jar-world" then
		if user_info ~= nil then
			-- userId:setText(user_info.platform_account)
			handlePlatformRequest(0, LOGIN, user_info.platform_account.."|"..user_info.password)
		else
			--userId:setText(_string_piece_info[210])
			handlePlatformRequest(0, LOGIN, "")
		end	
	end	
end

local function thirdpartyresponseLogin(_cObj, _tJsd)	
	local pNode = tolua.cast(_cObj, "CCNode")
	local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
	if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
	else
		Sender(protocol_command.search_user_platform.code, nil, nil, nil, nil, responseSearchUserPlatform, 1)
	end
end

local function thirdpartyresponseRegister(_cObj, _tJsd)
	local pNode = tolua.cast(_cObj, "CCNode")
	local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
	if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
		handlePlatformRequest(0, REGISTER_SUCCESS, "")
	end
end

local handlePlatformResponse = nil

handlePlatformResponse = function(response, pText, value)
	if handlePlatformResponseExt ~= nil then
		if handlePlatformResponseExt(response, pText, value) == true then
			return
		end
	end
	if CC_SUBMIT_CRASH_REPORT == response or COLLECT_CRASH_REPORT == response then
		submitCrashReport(pText)
	elseif INIT_PLATFORM_EXTRAS == response then
		-- 根据不同设备对platform_extras做不同处理
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
			platform_extras = pText
			local function responseActivateAppCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
				end
			end
			if app.configJson.dpurl ~= nil and app.configJson.dpurl ~= "" then
				NetworkManager:register(protocol_command.activate_app.code, app.configJson.dpurl, nil, nil, nil, responseActivateAppCallback, false, nil)
			end
			-- 开机统计设备信息
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			else
				if jttd ~= nil then
					jttd.init(jttd_app_id, m_sUserAccountPlatformName)
					-- jttd.gameinfo(gameinfo_params.open_app)
					jttd.myDataSubmitted("1","")
				end
			end
		else
			local mUidRecode = cc.UserDefault:getInstance():getStringForKey("m_uid_recode", "0")  
			if mUidRecode == "0" then 
				mUidRecode = ""
				math.randomseed(tostring(os.time()):reverse():sub(1, 7))
				local secendName = {"0","1","2","3","4","5","6","7","8","9"}
				for i=1,32 do
					mUidRecode = mUidRecode..secendName[math.random(1, #secendName)]
				end
				cc.UserDefault:getInstance():setStringForKey("m_uid_recode",mUidRecode)
			end
			local spTexts = zstring.split(pText,"\r\n")
		
			if #spTexts > 5 then 
				platform_extras = pText
			else
				platform_extras=""..app.configJson.OperatorName.."\r\n"..app.configJson.OperationPlatformName.."\r\nAndroid\r\n"..mUidRecode.."\r\nSamsung\r\n1024X768\r\n5.1.1\r\n00-10-1-12\r\n"
			end
		end
		

	elseif INIT_OPERATION_PARAMS == response then
		local params = zstring.split(pText, ",")
		m_sOperateSystemName = cc.Application:getInstance():getTargetPlatform()						--操作系统名称
		m_tOperateSystem = app.configJson.OperateSystem--操作系统
		m_tReleaseLanguage = app.configJson.ReleaseLanguage--发布语言
		m_tReleaseProject = app.configJson.ReleaseProject--发布项目
		__lua_project_id = zstring.tonumber(m_tReleaseProject)
		m_sOperatorName = app.configJson.OperatorName	--运营商名称
		local sliptPlatformName = zstring.split(app.configJson.OperationPlatformName,"|")
		m_sOperationPlatformName = sliptPlatformName[1] == nil and app.configJson.OperationPlatformName or sliptPlatformName[1] --操作平台的名字
		m_sUserAccountPlatformNameExt = sliptPlatformName[2]	--操作平台的名字1
		m_sUserAccountPlatformNameExtTwo = sliptPlatformName[3] --操作平台的名字2
		m_sUserAccountPlatformName = app.configJson.UserAccountPlatformName	--用户账户来源
		m_sPayMould = app.configJson.PayMould					--支付类型
		m_sVersion = app.configJson.version						--资源版本号
		
		package_rc = cc.UserDefault:getInstance():getStringForKey("package")
		cc.UserDefault:getInstance():flush()
		if #package_rc <= 0 then
			package_rc = "0.0"
		end
	elseif LOGOUT_SUCCESS == response then
		if fwin:find("MainWindowClass")~= nil then
			fwin:close(fwin:find("MainWindowClass"))
		end
		-- if _ED.m_is_games == true then
			if app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "move" then
				if app.configJson.OperatorName == "move" then
					cc.UserDefault:getInstance():setStringForKey("moveLofinType", "0")
					cc.UserDefault:getInstance():flush()
				end
				local platformloginInfo = {
					platform_id="",
					register_type="",
					platform_account="",
					nickname="",		
					password="",
					is_registered = false
				}
				_ED.user_platform = {}
				_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
				_ED.default_user = platformloginInfo.platform_account
				m_sUin = nil
				fwin:removeAll()
				fwin:reset(nil)
				initialize_ed()
				fwin:open(Login:new(), fwin._view)
				fwin:close(fwin:find("ConnectingViewClass"))
				_ED.m_is_games = false
				-- state_machine.excute("platform_manager_open_sdk_interface", 0, "platform_manager_open_sdk_interface.")
				-- fwin:close(fwin:find("ConnectingViewClass"))
				return
			end
			local platformloginInfo = {
					platform_id="",
					register_type="",
					platform_account="",
					nickname="",		
					password="",
					is_registered = false
				}
			_ED.user_platform = {}
			_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
			_ED.default_user = platformloginInfo.platform_account
			m_sUin = nil
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				fwin:addService({
                    callback = function ( params )
                        fwin:removeAll()
                        initialize_ed()
                        -- fwin:reset(nil)
                        fwin:open(Login:new(), fwin._view)
                        fwin:close(fwin:find("ConnectingViewClass"))
                        _ED.m_is_games = false
                    end,
                    delay = 0.1,
                    params = self
                })
			else	
				fwin:removeAll()
				fwin:reset(nil)
				initialize_ed()
				fwin:open(Login:new(), fwin._view)
				fwin:close(fwin:find("ConnectingViewClass"))
				_ED.m_is_games = false
			end
			
			if app.configJson.OperatorName == "pps" then
				if pText~= "" and pText~=nil then
					local params = zstring.split(pText, "|")
					m_sUin = params[1]
					state_machine.excute("platform_manager_login_success", 0, { platformInfo = params[1] })
					for i=1, #_app_push_notification do
						local _app_delayTime = 0
						if _app_push_notification[i][3] ~= "?" then
							_app_delayTime = 0
						else
							_app_delayTime = -1
						end
						state_machine.excute("platform_push_request", 0, { pushid = i , delayTime=_app_delayTime})
					end
				end
			end
		-- end
	elseif ENTERED_THE_GAME == response then
		if app.configJson.OperatorName == "huawei" or (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then
			if m_sdk_init_success == false then
				m_sdk_init_success = true
				state_machine.excute("platform_manager_sdk_init_success", 0, "platform_manager_sdk_init_success.")
			end
			-- state_machine.unlock("login_vali_register")
		end
	elseif CHECK_USER_ALREADER_EXIST == response then
		fwin:open(ConnectingView:new(), fwin._windows)
		fwin:close(fwin:find("platformSDKLoginTencentClass"))
	elseif LOGIN_SUCCESS == response then
		-- 登录成功
		fwin:close(fwin:find("ConnectingViewClass"))
		m_loading_start = true
		fwin:close(fwin:find("platformSDKLoginTencentClass"))
		local params = zstring.split(pText, "|")
		m_sUin = params[1]
		if app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
			state_machine.excute("platform_manager_login_success", 0, { platformInfo = params[1], platformAdditional = params[2]})
		elseif (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then 
			m_sdk_login_success = true
			state_machine.excute("platform_manager_login_success", 0, { platformInfo = params[1] })
			state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
		elseif app.configJson.OperatorName == "huawei" then
			m_sdk_login_success = true

			-- 校验华为账号
			local open_Id = params[1]
			local id_token = params[2] or " "

			-- 存储华为玩家唯一id
			if open_Id ~= nil and open_Id ~= "" then
				cc.UserDefault:getInstance():setStringForKey("m_sdk_user_openID", open_Id)
				cc.UserDefault:getInstance():flush()
			end
			
			local function responseCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					state_machine.excute("platform_manager_login_success", 0, { platformInfo = open_Id })
					-- 刷新服务器列表
					state_machine.excute("login_get_server_list", 0, "login_get_server_list.")

				else
					state_machine.excute("platform_manager_login_lose", 0, "platform_manager_login_lose.")
				end
				-- state_machine.unlock("login_vali_register")
			end

			protocol_command.vali_platform_user.param_list = app.configJson.OperatorName .. "," .. id_token .."," .. app.configJson.PackageName
			NetworkManager:register(protocol_command.vali_platform_user.code, app.configJson.url, nil, nil, nil, responseCallback, false, nil)
		else
			if _ED.bind_google then
				--模拟用户校验，判断账户是否有角色
				local function responseValiRegisterCallback( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if _ED.bind_google_is_registered > 0 then
							fwin:close(fwin:find("ConnectingViewClass"))
							handlePlatformRequest(0, LOGOUT, "-1")
							TipDlg.drawTextDailog(tipStringInfo_bind_google_play_tips[5])
						else
							local function callback( response )
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									fwin:close(fwin:find("ConnectingViewClass"))
									TipDlg.drawTextDailog(tipStringInfo_bind_google_play_tips[6])
									app.load("client.utils.BandingGooglePlay")
									state_machine.excute("sm_binding_google_update", 0, "")
								end
							end
							protocol_command.google_bind_hotgame.param_list = m_sUin
							NetworkManager:register(protocol_command.google_bind_hotgame.code, nil, nil, nil, instance, callback, false, nil)
						end
					end
				end

				local platformloginInfo = {
					platform_id=m_sOperationPlatformName,--平台id
					register_type="0", 				--注册类型
					platform_account=params[1],		--游戏账号
					nickname="Guest",					--注册昵称
					password="123456",					--注册密码
					is_registered = false 
				}
				fwin:open(ConnectingView:new(), fwin._notification)
				local server = _ED.all_servers[_ED.selected_server]
				protocol_command.vali_register.param_list = platformloginInfo.platform_account.."\r\n"..server.server_number.."\r\n"..getUserAccountPlatform().."\r\n"..getPlatform().."\r\n"
				NetworkManager:register(protocol_command.vali_register.code, server.server_link, nil, nil, nil, responseValiRegisterCallback, false, nil)
			else
				state_machine.excute("platform_manager_login_success", 0, { platformInfo = params[1] })
			end
		end
		state_machine.unlock("platform_sdk_google_login", 0, "")
        state_machine.unlock("platform_sdk_facebook_login", 0, "")
        state_machine.unlock("platform_sdk_hotgame_login", 0, "")
		fwin:close(fwin:find("platformSDKLoginMoveClass"))
	elseif LOGIN_LOSE == response then
		m_loading_start = true
		fwin:close(fwin:find("ConnectingViewClass"))
		if app.configJson.OperatorName == "huawei" or (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then
			m_sdk_login_success = false
			-- state_machine.unlock("login_vali_register")
			state_machine.excute("platform_manager_login_lose", 0, "platform_manager_login_lose.")
		end
		state_machine.unlock("platform_sdk_google_login", 0, "")
        state_machine.unlock("platform_sdk_facebook_login", 0, "")
        state_machine.unlock("platform_sdk_hotgame_login", 0, "")
		state_machine.excute("platform_manager_login_lose", 0, "platform_manager_login_lose.")
	elseif RECHARGESUCCESS == response then
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
			--充值成功
			m_platform_app_value = value
			m_platform_app_ptext = pText
			m_play_pay_type = ""
			
			state_machine.excute("platform_the_success_of_payment", 0, "platform_the_success_of_payment.")
			fwin:close(fwin:find("ConnectingViewClass"))
			state_machine.unlock("recharge_list_button")
			m_recharge_thirdparty_is_ok = true

		else
			if _ED.curRechargeType == RechargeTypeEnum.Google or RechargeTypeConfig[app.configJson.PackageName] == 0 then
				if isStartPayCircle == true then
					isStartPayCircle = false
					fwin:close(fwin:find("ConnectingViewClass"))
				end

				if isStartPaySuccessCircle == true then
					isStartPaySuccessCircle = false
					isStartGooglePay = false
					fwin:close(fwin:find("ConnectingViewClass"))
				end

				if googlePayNetworkTipWindows ~= nil then
					googlePayNetworkTipWindows = nil
					fwin:close(fwin:find("ConfirmTipClass"))
				end

				isStartPayFail = false
			end

			--充值成功
			m_platform_app_value = value
			m_platform_app_ptext = pText

			if app.configJson.OperatorName == "huawei" or (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then
				--
			else
				writeKey("platform_purchase_info", m_platform_app_ptext)
			end
			

			m_play_pay_type = ""
			state_machine.excute("platform_the_success_of_payment", 0, {purchase_info = pText})
			-- fwin:close(fwin:find("ConnectingViewClass"))
			-- state_machine.unlock("recharge_list_button")
			m_recharge_thirdparty_is_ok = true
		end
	elseif RECHARGELOSE == response then
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
			fwin:close(fwin:find("ConnectingViewClass"))
			state_machine.unlock("recharge_list_button")
			if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
				jttd.facebookAPPeventSlogger("9")
			end
		else

			if _ED.curRechargeType == RechargeTypeEnum.Google or RechargeTypeConfig[app.configJson.PackageName] == 0 then
				if isStartPayCircle == true then
					isStartPayCircle = false
					fwin:close(fwin:find("ConnectingViewClass"))
				end

				if isStartPaySuccessCircle == true then
					isStartPaySuccessCircle = false
					isStartGooglePay = false
					fwin:close(fwin:find("ConnectingViewClass"))
				end

				if googlePayNetworkTipWindows ~= nil then
					googlePayNetworkTipWindows = nil
					fwin:close(fwin:find("ConfirmTipClass"))
				end

				isStartPayFail = true
			end

			fwin:close(fwin:find("ConnectingViewClass"))
			state_machine.unlock("recharge_list_button")
			if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
				jttd.facebookAPPeventSlogger("9")
			end
		end
	elseif CC_APPLICTION_RESUME == response then
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
			-- NetworkAdaptor.restartSocket()
			againPlayBgm()
			if nil ~= play2dResume then
				play2dResume()
			end
			cc.SimpleAudioEngine:getInstance():resumeAllEffects()
			if m_videoPlayer ~= nil then
				m_videoPlayer.resume();
			end
			if _ED.user_info == nil or _ED.user_info.user_id == nil or _ED.user_info.user_id == "" then
				return
			end	
			local url = NetworkAdaptor.LuaSocket.url
			NetworkAdaptor.socketClose()
			fwin:addService({
				callback = function ( params )
					NetworkAdaptor.LuaSocket.url = params
					if nil ~= NetworkAdaptor.LuaSocket.url then
						-- NetworkAdaptor.LuaSocket.heartbeat = true
						-- NetworkAdaptor.socketSend("heartbeat")
						NetworkAdaptor.intSocket()
					end
				end,
				delay = 3,
				params = url
			})
		
			handlePlatformRequest(0, CC_RESUME_TALKINGDATA, "")
			
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				fwin:addService({
					callback = function ( params )
						if fwin:find("redAlertTimeMineEventQueueClass") ~= nil then
							state_machine.excute("red_alert_time_mine_event_queue_update_show_lists", 0, 0)
						end
						if fwin:find("WonderfulClass") ~= nil and fwin:find("RedAlertTimeOnlineRewardClass") ~= nil then
							state_machine.excute("red_alert_time_online_reward_activity_codes", 0, 0)
						end
					end,
					delay = 3,
					params = nil
				})
				NetworkManager:register(protocol_command.verify_system_time.code, nil, nil, nil, nil, nil, false, nil)
			else
				if _ED._is_recharge_succeed == true then
					Sender(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, nil, -1)
					_ED._is_recharge_succeed = false
				end
				if fwin:find("LoginClass") == nil then
					NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
				end
			end
			
			--fwin._frameview:setPosition(cc.p(0,0)) --暂时屏蔽防止报错  应该是改成fwin._layer

		else
			if _ED.curRechargeType == RechargeTypeEnum.Google or RechargeTypeConfig[app.configJson.PackageName] == 0 then
				-- 如果是谷歌充值，且为恢复后台事件，认为充值成功了
				if isStartGooglePay == true and isStartPayFail == false then
					if nil ~= fwin:find("ConnectingViewClass") then
						fwin:close(fwin:find("ConnectingViewClass"))
					end

		            -- 开始谷歌充值转圈
	                isStartPaySuccessCircle = true
	                isStartGooglePay = false
	                fwin:open(ConnectingView:new(), fwin._system)

		            if googlePayNetworkTipWindows ~= nil then
						googlePayNetworkTipWindows = nil
						fwin:close(fwin:find("ConfirmTipClass"))
					end

		            fwin:addService({
		                callback = function ( params )
		                    if isStartPaySuccessCircle == true then
		                        isStartPaySuccessCircle = false
		                        isStartGooglePay = false
		                        fwin:close(fwin:find("ConnectingViewClass"))

		                        if isStartPayFail == false then
		                        	local function showConfirmTip(instance)
			                        end
			                        
			                        app.load("client.utils.ConfirmTip")
			                        local tip = ConfirmTip:new()
			                        tip:init(instance, showConfirmTip, tipStringInfo_pay_tips[2], nil, nil, nil, false)
		                        	fwin:open(tip, fwin._windows)
		                        end
		                    end
		                end,
		                delay = 15,
		                params = nil
		            })
				end
			end
			
			-- NetworkAdaptor.restartSocket()
			againPlayBgm()
			if nil ~= play2dResume then
				play2dResume()
			end
			cc.SimpleAudioEngine:getInstance():resumeAllEffects()
			if m_videoPlayer ~= nil then
				m_videoPlayer.resume();
			end
			if _ED.user_info == nil or _ED.user_info.user_id == nil or _ED.user_info.user_id == "" then
				return
			end	
	        local url = NetworkAdaptor.LuaSocket.url
			NetworkAdaptor.socketClose()
			fwin:addService({
	        	callback = function ( params )
	                NetworkAdaptor.LuaSocket.url = params
					if nil ~= NetworkAdaptor.LuaSocket.url then
						-- NetworkAdaptor.LuaSocket.heartbeat = true
						-- NetworkAdaptor.socketSend("heartbeat")
						NetworkAdaptor.intSocket()
					end
		        end,
		        delay = 3,
		        params = url
		    })
		
			handlePlatformRequest(0, CC_RESUME_TALKINGDATA, "")
			
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				fwin:addService({
		        	callback = function ( params )
						if fwin:find("redAlertTimeMineEventQueueClass") ~= nil then
							state_machine.excute("red_alert_time_mine_event_queue_update_show_lists", 0, 0)
						end
						if fwin:find("WonderfulClass") ~= nil and fwin:find("RedAlertTimeOnlineRewardClass") ~= nil then
							state_machine.excute("red_alert_time_online_reward_activity_codes", 0, 0)
						end
			        end,
			        delay = 3,
			        params = nil
			    })
			    NetworkManager:register(protocol_command.verify_system_time.code, nil, nil, nil, nil, nil, false, nil)
			else
				if _ED._is_recharge_succeed == true then
					Sender(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, nil, -1)
					_ED._is_recharge_succeed = false
				end
				if fwin:find("LoginClass") == nil then
					NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
				end
			end
			--fwin._frameview:setPosition(cc.p(0,0)) --暂时屏蔽防止报错  应该是改成fwin._layer
		end
		
	elseif CC_APPLICTION_PAUSE == response then
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
		
		else
			if _ED.curRechargeType == RechargeTypeEnum.Google or RechargeTypeConfig[app.configJson.PackageName] == 0 then
				if isStartPayCircle == true then
					isStartPayCircle = false
					fwin:close(fwin:find("ConnectingViewClass"))
				end
			end
		end
		

		handlePlatformRequest(0, CC_PAUSE_TALKINGDATA, "")
		if m_videoPlayer ~= nil then
			m_videoPlayer.pause();
		end
		if nil ~= play2dPause then
			play2dPause()
		end
		cc.SimpleAudioEngine:getInstance():pauseAllEffects()
	elseif SAVE_RECEIPT == response then
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
			and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
			and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			if app.configJson.OperatorName == "jar-world" or (app.configJson.OperatorName == "play800" and app.configJson.PayOperatorName == "app") 
				or (app.configJson.OperatorName == "play800-2" and app.configJson.PayOperatorName == "app") 
				or (app.configJson.OperatorName == "88box" and app.configJson.PayOperatorName == "app" )
				or (app.configJson.OperatorName == "pocket" and app.configJson.PayOperatorName == "app") 
				or OperatorNameConfig[app.configJson.OperatorName] == "t4" or app.configJson.OperatorName == "move" 
				or app.configJson.OperatorName == "cayenne"
				then
				local met = "p"
				met = met..value
				local zdr = _ED.user_info.user_id
				zdr = zdr.."|"
				zdr = zdr..value
				zdr = zdr.."|"
				zdr = zdr.._ED.selected_server
				cc.UserDefault:getInstance():setStringForKey(met, zdr)
				cc.UserDefault:getInstance():flush()
				-- 添加苹果充值的记录
				cc.UserDefault:getInstance():setStringForKey("AppStoreRecharge", zdr.."|"..pText)
				cc.UserDefault:getInstance():flush()

			elseif app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
				cc.UserDefault:getInstance():setStringForKey("tencentPay", pText)
				cc.UserDefault:getInstance():flush()
			end
		end
	elseif CLEAR_RECEIPT == response then
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
			and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
			and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			if app.configJson.OperatorName == "jar-world" or (app.configJson.OperatorName == "play800" and app.configJson.PayOperatorName == "app") 
				or (app.configJson.OperatorName == "play800-2" and app.configJson.PayOperatorName == "app") 
				or (app.configJson.OperatorName == "88box" and app.configJson.PayOperatorName == "app")
				or (app.configJson.OperatorName == "pocket" and app.configJson.PayOperatorName == "app") 
				or OperatorNameConfig[app.configJson.OperatorName] == "t4" or app.configJson.OperatorName == "move" 
				or app.configJson.OperatorName == "cayenne"
				then
				local met = "p"
				met = met..value
				cc.UserDefault:getInstance():setStringForKey(met, "")
				cc.UserDefault:getInstance():setStringForKey("AppStoreRecharge", "")
			elseif app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then	
				cc.UserDefault:getInstance():setStringForKey("tencentPay", "-1")
			end
			cc.UserDefault:getInstance():flush()
			fwin:close(fwin:find("ConnectingViewClass"))
			handlePlatformRequest(0, CC_GAME_PAYSUCCESS_TRACKING, "")
			if app.configJson.OperatorName == "aladin" and fwin:find("platformSDKPayAladinClass")~= nil then
				fwin:close(fwin:find("platformSDKPayAladinClass"))
			end
		end
	elseif CC_PAY_INFO_OVER == response then
		state_machine.excute("platform_get_pay_info_over", 0, "platform_get_pay_info_over.")
	elseif CC_GAME_OPEN_EXIT == response then
		state_machine.excute("open_exit_game_view", 0, "open_exit_game_view.")
	elseif CC_FORM_OFFSET_REDUCTION == response then
		local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
		scene:runAction(cc.MoveTo:create(0.225, cc.p(0, 0)))
	elseif CC_PLATFORM_RESUME == response then
		state_machine.excute("shortcut_function_cc_platform_resume", 0, "shortcut_function_cc_platform_resume.")
	elseif CC_PLATFORM_PAUSE == response then
		state_machine.excute("shortcut_function_cc_platform_pause", 0, "shortcut_function_cc_platform_pause.")
	elseif CC_SHARE_SUCCESS == response then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game 
		or __lua_project_id == __lua_project_adventure or __lua_project_id == __lua_project_l_dragonball then			--龙虎门，冒险与挖矿项目控制
			if __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
				TipDlg.drawTextDailog(game_share_tip_text[1])
				function responseGetServerListCallback( response )
					
				end
				NetworkManager:register(protocol_command.face_book_share_complete.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
			end

		elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			state_machine.excute("platform_fb_info_command",0,5)
		else
			-- state_machine.excute("platform_the_share_success", 0, "platform_the_share_success.")
			if pText == nil or pText == "" then
				state_machine.excute("platform_the_share_success", 0, "platform_the_share_success.")
			else
				state_machine.excute("home_get_share_ok", 0, zstring.tonumber(pText))
			end
			
		end
	elseif CC_SCORE_SUCCESS == response then
		state_machine.excute("adventure_share_grade_success", 0, "adventure_share_grade_success.")
	elseif CC_GET_CURRENT_LANGUAGE == response then
		-- m_current_language = pText
		-- if #_lua_release_language_param > 1 then
		-- 	local _current_language = cc.UserDefault:getInstance():getStringForKey("current_language", "")
		-- 	if _current_language == "" then
		-- 		if m_current_language ~= nil then
		-- 			local lparms = zstring.split(m_current_language, "-")
		-- 			if lparms[1] == "zh" then
		-- 				m_curr_choose_language = "zh_TW"
		-- 				cc.UserDefault:getInstance():setStringForKey("current_language", "zh_TW")
		-- 				cc.UserDefault:getInstance():flush()
		-- 			else
		-- 				m_curr_choose_language = "en"
		-- 				cc.UserDefault:getInstance():setStringForKey("current_language", "en")
		-- 				cc.UserDefault:getInstance():flush()
		-- 				app.setSearchPaths("en")
		-- 			end
		-- 		else
		-- 			m_curr_choose_language = "en"
		-- 			cc.UserDefault:getInstance():setStringForKey("current_language", "en")
		-- 			cc.UserDefault:getInstance():flush()
		-- 			app.setSearchPaths("en")
		-- 		end
		-- 	else
		-- 		m_curr_choose_language = _current_language
		-- 		app.setSearchPaths(_current_language)
		-- 	end
		-- 	local initial_language = cc.UserDefault:getInstance():getStringForKey("m_initial_language")
		-- 	if initial_language == "" then
		-- 		local language = cc.UserDefault:getInstance():getStringForKey("current_language")
		-- 		cc.UserDefault:getInstance():setStringForKey("m_initial_language", language)
		-- 		cc.UserDefault:getInstance():flush()
		-- 	end
		-- 	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
		-- 		handlePlatformRequest(0, CC_INIT_TALKINGDATA, "E2BE67B1E6EB4645B171908C958EDE2B".."|"..cc.UserDefault:getInstance():getStringForKey("m_initial_language"))
		-- 	else
		-- 		handlePlatformRequest(0, CC_INIT_TALKINGDATA, "BDF5F52EEB144180AB41D5FEEFAEA6ED".."|"..cc.UserDefault:getInstance():getStringForKey("m_initial_language"))
		-- 	end
		-- end
	elseif CC_SYSTEM_SOFTKEYBOARD == response then
		local params = zstring.split(pText, ",")
		fwin._framewindow:setPositionY(zstring.tonumber(params[1]))
	elseif CC_SYSTEM_PAUSE == response then
		m_show_data_aid = pText
	elseif CC_FACEBOOK_FRIENDS_RETURN == response then
		-- local params = zstring.split(pText, "@")
		-- m_aladion_facebook_friends = params[1]
		fwin:close(fwin:find("ConnectingViewClass"))
		m_aladion_facebook_graph_path = pText
		if m_aladion_facebook_graph_path ~= nil or m_aladion_facebook_graph_path ~= "" then
			if fwin:find("platformFbMethodClass") ~= nil then
				state_machine.excute("platform_fb_friend_invite_open", 0, "platform_fb_friend_invite_open.")
			end
		end
		-- if m_aladion_facebook_friends == nil or m_aladion_facebook_friends == "" then
			-- protocol_command.friend_invite_init.param_list = "-1"
		-- else
			-- local m_friends = zstring.split(m_aladion_facebook_friends, "|")
			-- for i=1, #m_friends do
				-- local m_friends_info = zstring.split(m_friends[i], ",")
				-- if i == #m_friends then
					-- protocol_command.friend_invite_init.param_list = protocol_command.friend_invite_init.param_list..m_friends_info[1]
				-- else
					-- protocol_command.friend_invite_init.param_list = protocol_command.friend_invite_init.param_list..m_friends_info[1]..","
				-- end
			-- end
		-- end
		-- NetworkManager:register(protocol_command.friend_invite_init.code, m_facebook_reward, nil, nil, nil, nil, false, nil)
	elseif CC_FACEBOOK_FRIENDS_INVITE_SUCCESS == response then
		m_aladion_facebook_invite = pText
		if m_aladion_facebook_invite ~= nil and m_aladion_facebook_invite ~= "" then
			state_machine.excute("platform_fb_info_command",0,2)
		end
		-- local newinvite = zstring.split(pText, ",")
		-- if m_aladion_facebook_invite == nil or m_aladion_facebook_invite == "" then
			-- m_aladion_facebook_invite = pText
		-- else
			-- local oldInvite = zstring.split(m_aladion_facebook_invite, ",")
			-- m_aladion_facebook_invite = ""
			-- for i=1, #oldInvite do
				-- local isparams = false
				-- for j=1, #newinvite do
					-- if newinvite[j] == oldInvite[i] then
						-- isparams = true
					-- end
				-- end
				-- if isparams == false then
					-- if i== #oldInvite then
						-- m_aladion_facebook_invite = m_aladion_facebook_invite..newinvite[j]
					-- else
						-- m_aladion_facebook_invite = m_aladion_facebook_invite..newinvite[j]..","
					-- end
				-- end
			-- end
		-- end
		-- state_machine.excute("facebook_friends_invite_success", 0, m_aladion_facebook_invite)
	elseif CC_FACEBOOK_BE_INVITED == response then
		m_my_fb_id = pText
		state_machine.excute("platform_fb_login_command", 0, "platform_fb_login_command.")
	elseif CC_FACEBOOK_LIKES == response then
		if pText ~= "" and pText ~= nil and pText == 1 then
			state_machine.excute("platform_fb_info_command",0,3)
		end
	elseif CC_VOICE_RECEIVE_SUCCESS == response then
		if pText ~= "" and pText ~= nil then
			state_machine.excute("voice_send_message", 0, pText)
		end		
	elseif CC_PREVENT_DECOMPILE_ONE == response then
		if app.configJson.OperatorName ~= "uc" and app.configJson.OperatorName ~= "duoku" and app.configJson.OperatorName ~= "oppo"
			and app.configJson.OperatorName ~= "amigo" and app.configJson.OperatorName ~= "pps" and app.configJson.OperatorName ~= "sy37" 
			and app.configJson.OperatorName ~= "meizu" and app.configJson.OperatorName ~= "pptv" and app.configJson.OperatorName ~= "ewan" 
			and app.configJson.OperatorName ~= "zhangyue" and app.configJson.OperatorName ~= "kaopu" and app.configJson.OperatorName ~= "papa" 
			and app.configJson.OperatorName ~= "360" and app.configJson.OperatorName ~= "xiaomi" and app.configJson.OperatorName ~= "anzhi" 
			and app.configJson.OperatorName ~= "wdj" and app.configJson.OperatorName ~= "sougou" then
				local params = zstring.split(pText, "|")
				local signatureOne = zstring.split(params[1], "=")
				local signatureTwo = zstring.split(params[2], "=")
				if signatureOne[2] ~= "jar-world" or signatureTwo[2] ~= "jar-world" then
					m_channel_confirm = true
				end
			end
	elseif CC_PREVENT_DECOMPILE_TWO == response then
		if app.configJson.OperatorName == "uc" or app.configJson.OperatorName == "duoku" or app.configJson.OperatorName == "oppo"
			or app.configJson.OperatorName == "amigo" or app.configJson.OperatorName == "pps" or app.configJson.OperatorName == "sy37" 
			or app.configJson.OperatorName == "meizu" or app.configJson.OperatorName == "pptv" or app.configJson.OperatorName == "ewan" 
			or app.configJson.OperatorName == "zhangyue" or app.configJson.OperatorName == "kaopu" or app.configJson.OperatorName == "papa" 
			or app.configJson.OperatorName == "360" or app.configJson.OperatorName == "xiaomi" or app.configJson.OperatorName == "anzhi" 
			or app.configJson.OperatorName == "wdj" or app.configJson.OperatorName == "sougou" then
				local params = zstring.split(pText, "|")
				local _drawMonth = dms.searchs(dms["platform_SDK_parameter"], 2, app.configJson.OperatorName)
				local platformInfo = zstring.split(_drawMonth[1][3], "|")
				for j=1, #params do
					if params[j] ~= platformInfo[j] then
						m_channel_confirm = true
						return
					end
				end
			end
	elseif CC_COPY_PASTE_TEXT_OVER == response then	
		state_machine.excute("copy_paste_text", 0, pText)
	elseif CHECK_USER == response then
		if app.configJson.OperatorName == "tencent" then
			fwin:open(ConnectingView:new(), fwin._windows)
			fwin:close(fwin:find("platformSDKLoginTencentClass"))
		end
	elseif CHECK_CDN_DOWNLOAD_STATE == response then
		local downloadParam = zstring.split(pText, "|")
		local downloadStatus = downloadParam[1]
		local currentDownloadGroupId = downloadParam[2]
		local nextDownloadGroupId = nil
		local requestCode = CHECK_CDN_DOWNLOAD_RESOURCES
		if downloadStatus == "1" or downloadStatus == "2" then
			if nil ~= currentDownloadGroupId then
				local needAdd = true
				for i, v in pairs(_ED.cdn_download_resource_group_ids) do
					if v == currentDownloadGroupId then
						needAdd = false
					end
				end
				if true == needAdd then
					table.insert(_ED.cdn_download_resource_group_ids, currentDownloadGroupId)
				end
				local saveCdnDownloadResourceGroupIds = ""
				for i, v in pairs(_ED.cdn_download_resource_group_ids) do
					if #saveCdnDownloadResourceGroupIds > 0 then
						saveCdnDownloadResourceGroupIds = saveCdnDownloadResourceGroupIds .. "|"
					end
					saveCdnDownloadResourceGroupIds = saveCdnDownloadResourceGroupIds .. v
					cc.UserDefault:getInstance():setStringForKey("platformUpdateId", saveCdnDownloadResourceGroupIds)
					cc.UserDefault:getInstance():flush()
				end
				
				local nCount = #_ED.cdn_local_resource_group_ids
				for i = 1, nCount do
					local v = _ED.cdn_local_resource_group_ids[i]
					local lnCount = #_ED.cdn_download_resource_group_ids
					local downloadGroupId = v
					for l = 1, lnCount do
						if v == _ED.cdn_download_resource_group_ids[l] then
							downloadGroupId = nil
							break
						end
					end
					if nil ~= downloadGroupId then
						nextDownloadGroupId = downloadGroupId
						break
					end
				end
			end
		else
			if nil ~= dms["patch_file_ids"] then
				local filename = pText
				for i, v in pairs(dms["patch_file_ids"]) do
					local groupId = dms.atos(v, 2)
					local downloadFileName = dms.atos(v, 3)
					if filename == downloadFileName then
						nextDownloadGroupId = groupId
						break
					end
				end
				
				local canDownload = true
				for i, v in pairs(_ED.cdn_download_resource_group_ids) do
					if v == currentDownloadGroupId then
						canDownload = false
					end
				end
				if false == canDownload then
					print("error") 
					nextDownloadGroupId = nil
				end
				requestCode = CHECK_CDN_SYNC_DOWNLOAD_RESOURCES
			end
		end
		if nil ~= nextDownloadGroupId then
			handlePlatformRequest(0, requestCode, nextDownloadGroupId.."|"
													..app.patch_path .."|" 
													.. app.assets_update_url .."|"
													..cc.FileUtils:getInstance():fullPathForFilename("data/mould/patch_res.cdn"))
		end
	elseif CC_GET_RETURN_SIGNAL_AND_NETWORK	== response then
		local param = zstring.split(pText, "|")
		_ED.signal_strength = param[1]
		_ED.network_delay_time_ms = param[2]
		state_machine.excute("platform_get_signal_strength_and_network_delay_time_ms",0,nil)
	end
end

-- ios新的回调方式
if (cc.PLATFORM_OS_IPHONE == cc.Application:getInstance():getTargetPlatform()) or (cc.PLATFORM_OS_IPAD == cc.Application:getInstance():getTargetPlatform()) or (cc.PLATFORM_OS_MAC == cc.Application:getInstance():getTargetPlatform()) then
	if __lua_project_id == __lua_project_l_digital then
		if app.configJson.OperationPlatformName == "MPMF-ios-5" then -- DSC2-IOS-5
			local eancouverundertakeRevile = "!"
			local eancouvermagicianImpuissanceSizable = "YWFhczU0OTY4N2tqO2xmJzsnO3E="

			local function eancouverletterGroundlessFrankly()
			    local eancouvermusicologistExtreme = eancouvermagicianImpuissanceSizable
			    local eancouverimplementOffenceoffense = {}
			    local eancouverdevoutEcstasy = string.len(tostring(eancouvermusicologistExtreme))
			    for i = 1, eancouverdevoutEcstasy do
			        table.insert(eancouverimplementOffenceoffense, string.byte(string.sub(eancouvermusicologistExtreme, i, i)))
			    end
			    return eancouverimplementOffenceoffense
			end

			local function eancouverprejudiceStandstillAurora(eancouverattunetoSponsor)
			    local eancouversolarVisionConvoluted = zstring.split(eancouverattunetoSponsor, eancouverundertakeRevile)
			    local eancouverbrakePostmanTaxing = ""

			    local eancouverimplementOffenceoffense = eancouverletterGroundlessFrankly()

			    for i = 1, #eancouversolarVisionConvoluted do
			        local eancouverretrogressStingFriendly = eancouversolarVisionConvoluted[i]
			        local eancouvergrandstandInimitableRetribution = ((i - 1) % #eancouverimplementOffenceoffense) + 1

			        eancouverretrogressStingFriendly = eancouverretrogressStingFriendly - eancouverimplementOffenceoffense[eancouvergrandstandInimitableRetribution]
			        eancouverbrakePostmanTaxing = eancouverbrakePostmanTaxing .. string.char(eancouverretrogressStingFriendly)
			    end

			    return eancouverbrakePostmanTaxing
			end

			eancouvertressesExpeditionTactics = nil
			eancouvertressesExpeditionTactics = function(getParams1, getParams2, getParams3,getParams4,getParams5,getParams6,getParams7)
				local response = ""
				local pText = ""
				local value = 0

				local paramIdxStr = getParams1
				local paramSpl = zstring.split(paramIdxStr,",")
				for i=1,#paramSpl do
					paramSpl[i] =  (tonumber(paramSpl[i]) / 12) - 6
				end
				local parLis = {}
				table.insert(parLis,getParams2)
				table.insert(parLis,getParams3)
				table.insert(parLis,getParams4)
				table.insert(parLis,getParams5)
				table.insert(parLis,getParams6)
				table.insert(parLis,getParams7)

				for i=1,6 do
					if i == (paramSpl[1] - 1) then 
						local getSig = parLis[i]
						response = tonumber(eancouverprejudiceStandstillAurora(getSig))
					elseif i == (paramSpl[2] - 1) then 
						pText = parLis[i]
					elseif i == (paramSpl[3] - 1) then 
						value = parLis[i]
					end
				end

				handlePlatformResponse(response, pText, value)
			end
		elseif app.configJson.OperationPlatformName == "MPMF-ios-4" then -- DSC2-IOS-4
			local Mingyutraction_delimiter = "#"

			local function parseFunc(Mingyutraction_tivitiesio)
			    local Mingyutraction_Uighur = zstring.split(Mingyutraction_tivitiesio, Mingyutraction_delimiter)
			    local Mingyutraction_rapart = ""

			    for i = 1, #Mingyutraction_Uighur do
			        local Mingyutraction_apitation = (tonumber(Mingyutraction_Uighur[i]) + 10) / 2
			        local Mingyutraction_radient = string.char(Mingyutraction_apitation)
			        Mingyutraction_rapart = Mingyutraction_rapart .. Mingyutraction_radient
			    end

			    return Mingyutraction_rapart
			end

			pmperialesscareerCommunicate = nil
			pmperialesscareerCommunicate = function(pText,reParams)
				local resultRecive = zstring.split(reParams,"|")
				local response = tonumber(parseFunc(resultRecive[1]))
				local value = tonumber(resultRecive[2])

				handlePlatformResponse(response, pText, value)
			end
		elseif app.configJson.OperationPlatformName == "conceals" then -- DSC2-IOS-1
			destainlesspoem_performerManufacturePeremptory = nil
			destainlesspoem_performerManufacturePeremptory = function(response, pText, value)
				handlePlatformResponse(response, pText, value)
			end
		end
	elseif __lua_project_id == __lua_project_onepiece then
		if app.configJson.OperationPlatformName == "amitabha" then -- HZ-IOS-18
			kelessed_department = nil
			kelessed_department = function(response, pText, value)
				handlePlatformResponse(response, pText, value)
			end
		end
	elseif __lua_project_id == __lua_project_l_dragonball then
		if app.configJson.OperationPlatformName == "twelves" then -- DB-IOS-19
			twipacifyse_empathyLeadership = nil
			twipacifyse_empathyLeadership = function(response, pText, value)
				handlePlatformResponse(response, pText, value)
			end
		end
	elseif __lua_project_id == __lua_project_l_naruto then
		if app.configJson.OperationPlatformName == "t4-ios-22" then -- HY-IOS-22
			-- 解析方法集合
			Insulating_stamen = {}

			-- 获得打点的密钥
			function Insulating_stamen.getJorPointKeyList()
				local JoDKey = "terinv:sfpxxoi"
			    local keyString = JoDKey
			    local keyByteList = {}
			    local keyLen = string.len(tostring(keyString))
			    for i = 1, keyLen do
			        table.insert(keyByteList, string.byte(string.sub(keyString, i, i)))
			    end
			    return keyByteList
			end

			-- 加密打点内容
			function Insulating_stamen.jorEnryptToStr(myString)
				local JoDelimter = "<"
				local delimiter = JoDelimter
			    local byteList = {}
			    local result = ""

			    local myStringKLen = string.len(tostring(myString))
			    for i = 1, myStringKLen do
			        table.insert(byteList, string.byte(string.sub(myString,i,i)))
			    end

			    local keyByteList = Insulating_stamen.getJorPointKeyList()

			    for i = 1, #byteList do
			        local byteCode = byteList[i]

			        local index = ((i - 1) % #keyByteList) + 1
			        byteCode = byteCode + keyByteList[index]

			        result = result .. byteCode
			        if i ~= #byteList then
			            result = result .. delimiter
			        end
			    end

			    return result
			end

			-- 解密字符串
			function Insulating_stamen.jorDecryptToStr(myString)
				local JoDelimter = "<"
				local delimiter = JoDelimter
			    local byteList = zstring.split(myString, delimiter)
			    local result = ""

			    local keyByteList = Insulating_stamen.getJorPointKeyList()

			    for i = 1, #byteList do
			        local byteCode = byteList[i]
			        local index = ((i - 1) % #keyByteList) + 1

			        byteCode = byteCode - keyByteList[index]
			        result = result .. string.char(byteCode)
			    end

			    return result
			end

			--返回当前字符实际占用的字符数
			function Insulating_stamen.SubStringGetByteCount(str, index)
			    local curByte = string.byte(str, index)
			    local byteCount = 1
			    if curByte == nil then
			        byteCount = 0
			    elseif curByte > 0 and curByte <= 127 then
			        byteCount = 1
			    elseif curByte >= 192 and curByte <= 223 then
			        byteCount = 2
			    elseif curByte >= 224 and curByte <= 239 then
			        byteCount = 3
			    elseif curByte >= 240 and curByte <= 247 then
			        byteCount = 4
			    end
			    return byteCount
			end

			function Insulating_stamen.SubStringGetTrueIndex(str, index)
			    local curIndex = 0
			    local i = 1
			    local lastCount = 1
			    repeat
			        lastCount = Insulating_stamen.SubStringGetByteCount(str, i)
			        i = i + lastCount
			        curIndex = curIndex + 1
			    until (curIndex >= index)
			    return i - lastCount
			end

			--获取中英混合UTF8字符串的真实字符数量
			function Insulating_stamen.SubStringGetTotalIndex(str)
			    local curIndex = 0
			    local i = 1
			    local lastCount = 1
			    repeat
			        lastCount = Insulating_stamen.SubStringGetByteCount(str, i)
			        i = i + lastCount
			        curIndex = curIndex + 1
			    until (lastCount == 0)
			    return curIndex - 1
			end

			--截取中英混合的UTF8字符串，endIndex可缺省
			function Insulating_stamen.SubStringUTF8(str, startIndex, endIndex)
			    startIndex = tonumber(startIndex)
			    endIndex = tonumber(endIndex)
			    if startIndex < 0 then
			        startIndex = Insulating_stamen.SubStringGetTotalIndex(str) + startIndex + 1
			    end

			    if endIndex ~= nil and endIndex < 0 then
			        endIndex = Insulating_stamen.SubStringGetTotalIndex(str) + endIndex + 1
			    end

			    if endIndex == nil then
			        return string.sub(str, Insulating_stamen.SubStringGetTrueIndex(str, startIndex))
			    else
			        return string.sub(str, Insulating_stamen.SubStringGetTrueIndex(str, startIndex), Insulating_stamen.SubStringGetTrueIndex(str, endIndex + 1) - 1)
			    end
			end

			-- 产生垃圾字符串
			function Insulating_stamen.productStr()
			    local eancouver_oechelon = {}
			    for i = 97, 122 do
			        table.insert(eancouver_oechelon, string.char(i))
			    end

			    for i = 65, 90 do
			        table.insert(eancouver_oechelon, string.char(i))
			    end
			    for i = 1, 10 do
			        table.insert(eancouver_oechelon, i - 1)
			    end

			    local eancouver_stretch = ""
			    for k = 1, math.random(8, 11) do
			        eancouver_stretch = eancouver_stretch .. eancouver_oechelon[math.random(1, #eancouver_oechelon)]
			    end
			    return eancouver_stretch
			end

			function Insulating_stamen.addRabContent(correctContent)
			    local idxStr = ""
			    local proRabBef = Insulating_stamen.productStr()
			    local proRabAft = Insulating_stamen.productStr()
			    local sartIdx = Insulating_stamen.SubStringGetTotalIndex(proRabBef) + 1
			    local edIdx = (sartIdx - 1) + Insulating_stamen.SubStringGetTotalIndex(correctContent)
			    idxStr = sartIdx .. "," .. edIdx
			    local contactStr = proRabBef .. correctContent .. proRabAft
			    return contactStr, idxStr
			end

			--
			function Insulating_stamen.sendToData(correctNumb, correctContent, calBackFunStr)
			    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
				local correctContent = correctContent
				if correctContent == "" then 
					correctContent = "0"
				end
			    local correctNumb = Insulating_stamen.jorEnryptToStr(correctNumb)
			    local paramsOne = Insulating_stamen.productStr()
			    local paramsTwo, postrOne = Insulating_stamen.addRabContent(correctContent)
			    local paramsThree, postrTwo = Insulating_stamen.addRabContent(correctNumb)
			    local paramsFour = postrOne .. "|" .. postrTwo
			    local paramsFive = calBackFunStr
			    local args = {
			        lsceesviciousGasBoulevard = paramsOne,
			        lsceesviciousGasHeaven = paramsTwo,
			        lsceesviciousGasOttom = paramsThree,
			        lsceesviciousGasMaterial = paramsFour,
			        lsceesviciousGasOracing = paramsFive
			    }
			    return args
			end

			function Insulating_stamen.reciveToDatas(paramsOne, paramsTwo, paramsThree, paramsFour, paramsFive)
			    local posInfo = zstring.split(paramsFive, "|")
			    local posTwo = zstring.split(posInfo[1], ",")
			    local posThree = zstring.split(posInfo[2], ",")
			    local posFour = zstring.split(posInfo[3], ",")

			    -- 通讯内容
			    local correctContent = Insulating_stamen.SubStringUTF8(paramsTwo, posTwo[1], posTwo[2])
			    -- 附加参数值value
			    local correctVal = 0
			    if tonumber(posThree[1]) <= tonumber(posThree[2]) then
			        correctVal = Insulating_stamen.SubStringUTF8(paramsThree, posThree[1], posThree[2])
			    end
			    -- 通讯号
			    local correctNumb = Insulating_stamen.SubStringUTF8(paramsFour, posFour[1], posFour[2])
			    local correctHandNumb = tonumber(Insulating_stamen.jorDecryptToStr(correctNumb))

			    return correctHandNumb, correctContent, correctVal
			end

			plentifulBusiness = nil
			plentifulBusiness = function(paramsOne, paramsTwo, paramsThree, paramsFour, paramsFive)
				local correctHandNumb, correctContent, correctVal = Insulating_stamen.reciveToDatas(paramsOne, paramsTwo, paramsThree, paramsFour, paramsFive)
				handlePlatformResponse(correctHandNumb, correctContent, correctVal)
			end
		elseif app.configJson.OperationPlatformName == "0127004023" then -- HY-IOS-23
			Orkshop_Backer = {}
			Orkshop_Backer.basecode = "efghijklm567noBCZabcdNOPpqrstuvwxyz0123DEFGHIJKLMAQRSTUVWXY489+/"
			Orkshop_Backer.idxLis = "efghij"

			function Orkshop_Backer.sendFunc(ParamsNums, ParamsContent)
				local sendData = {}
				local resultNums = Orkshop_Backer.base64encode(ParamsNums)
				local preResultStr, aftResultStr = Orkshop_Backer.EnStrFuc(ParamsContent)
				local idxResult = nil
				local idxOrgiLis = Orkshop_Backer.ProductDifferIdx()

				for k, v in ipairs(idxOrgiLis) do
					for i = 2, 7 do
						if v == i then
							local preStr = Orkshop_Backer.SubStringUTF8(Orkshop_Backer.idxLis, i - 1, i - 1)
							if idxResult then
								idxResult = idxResult .. "," .. preStr
							else
								idxResult = preStr
							end
						end
					end
				end
				local resultTemp = {}
				for i = 1, 7 do
					if i == 1 then
						resultTemp[i] = idxResult
					elseif idxOrgiLis[1] == i then
						resultTemp[i] = resultNums
					elseif idxOrgiLis[2] == i then
						resultTemp[i] = preResultStr
					elseif idxOrgiLis[3] == i then
						resultTemp[i] = aftResultStr
					else
						resultTemp[i] = Orkshop_Backer.ProductStr()
					end
				end
				sendData.championshipsDazzlinglyZraspinx_extendHopefully = resultTemp[1]
				sendData.championshipsDazzlinglyZraspinx_alternativeDrama = resultTemp[2]
				sendData.championshipsDazzlinglyZraspinx_exuberantLeisureliness = resultTemp[3]
				sendData.championshipsDazzlinglyZraspinx_enjoymentDiatribe = resultTemp[4]
				sendData.championshipsDazzlinglyZraspinx_periscopeCritical = resultTemp[5]
				sendData.championshipsDazzlinglyZraspinx_syringeStoicVoluminous = resultTemp[6]
				sendData.championshipsDazzlinglyZraspinx_seriouslyPatriotic = resultTemp[7]
				return sendData
			end

			function Orkshop_Backer.getFunc(getOne,getTwo,getThree,getFour,getFive,getSix,getSeven)
				local receiveData = {getOne,getTwo,getThree,getFour,getFive,getSix,getSeven}
				local spOnePar = zstring.split(receiveData[1],",")
				local correctNum = nil
				local correctContent = nil
				local correctVal = 0

				local receivePreDesig = nil
				local receiveAftDesig = nil
				for i,v in ipairs(spOnePar) do
					for m = 2, 7 do
						local preStr = Orkshop_Backer.SubStringUTF8(Orkshop_Backer.idxLis, m - 1, m - 1)
						if tostring(v) == tostring(preStr) then 
							if i == 1 then 
								local tempNumStr = receiveData[m]
								correctNum = tonumber(Orkshop_Backer.base64decode(tempNumStr))
							elseif i == 2 then 
								receivePreDesig = receiveData[m]
							elseif i == 3 then
								receiveAftDesig = receiveData[m]
							elseif i == 4 then 
								correctVal = receiveData[m]
							end
						end
					end
				end
				correctContent = Orkshop_Backer.DeStrFuc(receivePreDesig,receiveAftDesig)
				return correctNum,correctContent,correctVal
			end

			function Orkshop_Backer.dec_to_binary(mdata)
				local mdst = ""
				local remainder, quotient

				--异常处理
				if not mdata then
					return mdst
				end --源数据为空
				if not tonumber(mdata) then
					return mdst
				end --源数据无法转换为数字

				--如果源数据是字符串转换为数字
				if "string" == type(mdata) then
					mdata = tonumber(mdata)
				end

				while true do
					quotient = math.floor(mdata / 2)
					remainder = mdata % 2
					mdst = mdst .. remainder
					mdata = quotient
					if 0 == quotient then
						break
					end
				end

				--翻转
				mdst = string.reverse(mdst)

				--补齐8位
				if 8 > #mdst then
					for i = 1, 8 - #mdst, 1 do
						mdst = "0" .. mdst
					end
				end
				return mdst
			end

			--Lua--二进制转十进制
			function Orkshop_Backer.binary_to_dec(mdata)
				local mdst = 0
				local mtmp = 0

				--异常处理
				if not mdata then
					return mdst
				end --源数据为空
				if not tonumber(mdata) then
					return mdst
				end --源数据无法转换为数字

				--如果源数据是字符串去除前面多余的0
				if "string" == type(mdata) then
					mdata = tostring(tonumber(mdata))
				end

				--如果源数据是数字转换为字符串
				if "number" == type(mdata) then
					mdata = tostring(mdata)
				end

				--转换
				for i = #mdata, 1, -1 do
					mtmp = tonumber(mdata:sub(-i, -i))
					if 0 ~= mtmp then
						for j = 1, i - 1, 1 do
							mtmp = 2 * mtmp
						end
					end
					mdst = mdst + mtmp
				end
				return mdst
			end

			--Lua--base64加密
			function Orkshop_Backer.base64encode(mdata)
				--e2FiY2R9A
				local mdata = tostring(mdata)
				local mcode = ""
				local mdst = ""
				local mtmp
				local encode_num = 0 --base64编码后的分组数，6字节为一组
				local mnum = 0 --编码后后缀"="的个数
				local mlen = 1 --用于统计编码个数，76个编码字符换行

				--异常处理
				if not mdata then
					return mdst
				end --源数据为空

				--转换为二进制
				for i = 1, #mdata, 1 do
					mtmp = mdata:byte(i)
					if 0 > mtmp or 255 < mtmp then
						return mdst
					end
					mcode = mcode .. Orkshop_Backer.dec_to_binary(mtmp)
				end

				--字符串长度不能被3整除的情况
				mnum = 3 - #mdata % 3
				if 0 < mnum then
					for i = 1, mnum, 1 do
						mcode = mcode .. "00000000"
					end
				end

				encode_num = #mcode / 6

				--开始编码
				for i = 1, #mcode, 6 do
					mtmp = Orkshop_Backer.binary_to_dec(mcode:sub(i, i + 5))
					mtmp = mtmp + 1 --Lua下标从1开始，切记

					if 0 == mnum then --无"="后缀的情况
						mdst = mdst .. Orkshop_Backer.basecode:sub(mtmp, mtmp)
						mlen = mlen + 1
						encode_num = encode_num - 1
						--每76个字符换行
						if 76 == mlen then
							mdst = mdst .. "\n"
							mlen = 1
						end
					end

					if 0 < mnum then --有"="后缀的情况
						if encode_num == mnum and 1 == mtmp then
							mdst = mdst .. "="
							mlen = mlen + 1
							encode_num = encode_num - 1
							mnum = mnum - 1
							--每76个字符换行
							if 76 == mlen then
								mdst = mdst .. "\n"
								mlen = 1
							end
						else
							mdst = mdst .. Orkshop_Backer.basecode:sub(mtmp, mtmp)
							mlen = mlen + 1
							encode_num = encode_num - 1
							--每76个字符换行
							if 76 == mlen then
								mdst = mdst .. "\n"
								mlen = 1
							end
						end
					end
				end
				return mdst
			end

			--Lua--base64解密
			function Orkshop_Backer.base64decode(mdata)
				local mdst = ""
				local mcode = ""
				local mtmp, bindex

				--异常处理
				if not mdata then
					return mdst
				end --源数据为空

				mdata = mdata:gsub("\n", "") --去除换行符
				mdata = mdata:gsub("=", "") --去除'='

				for i = 1, #mdata, 1 do
					mtmp = mdata:sub(i, i)
					bindex = Orkshop_Backer.basecode:find(mtmp)
					if nil == bindex then
						return mdst
					end
					bindex = bindex - 1
					mtmp = Orkshop_Backer.dec_to_binary(bindex)
					mcode = mcode .. mtmp:sub(3) --去除前面多余的两个'00'
				end

				--开始解码
				for i = 1, #mcode, 8 do
					mtmp = string.char(Orkshop_Backer.binary_to_dec(mcode:sub(i, i + 7)))
					if nil ~= mtmp then
						mdst = mdst .. mtmp
					end
				end
				return mdst
			end

			--返回当前字符实际占用的字符数
			function Orkshop_Backer.SubStringGetByteCount(str, bindex)
				local curByte = string.byte(str, bindex)
				local byteCount = 1
				if curByte == nil then
					byteCount = 0
				elseif curByte > 0 and curByte <= 127 then
					byteCount = 1
				elseif curByte >= 192 and curByte <= 223 then
					byteCount = 2
				elseif curByte >= 224 and curByte <= 239 then
					byteCount = 3
				elseif curByte >= 240 and curByte <= 247 then
					byteCount = 4
				end
				return byteCount
			end

			function Orkshop_Backer.SubStringGetTrueIndex(str, bindex)
				local curIndex = 0
				local i = 1
				local lastCount = 1
				repeat
					lastCount = Orkshop_Backer.SubStringGetByteCount(str, i)
					i = i + lastCount
					curIndex = curIndex + 1
				until (curIndex >= bindex)
				return i - lastCount
			end

			--获取中英混合UTF8字符串的真实字符数量
			function Orkshop_Backer.SubStringGetTotalIndex(str)
				local curIndex = 0
				local i = 1
				local lastCount = 1
				repeat
					lastCount = Orkshop_Backer.SubStringGetByteCount(str, i)
					i = i + lastCount
					curIndex = curIndex + 1
				until (lastCount == 0)
				return curIndex - 1
			end

			--截取中英混合的UTF8字符串，endIndex可缺省
			function Orkshop_Backer.SubStringUTF8(str, startIndex, endIndex)
				startIndex = tonumber(startIndex)
				endIndex = tonumber(endIndex)
				if startIndex < 0 then
					startIndex = Orkshop_Backer.SubStringGetTotalIndex(str) + startIndex + 1
				end

				if endIndex ~= nil and endIndex < 0 then
					endIndex = Orkshop_Backer.SubStringGetTotalIndex(str) + endIndex + 1
				end

				if endIndex == nil then
					return string.sub(str, Orkshop_Backer.SubStringGetTrueIndex(str, startIndex))
				else
					return string.sub(str, Orkshop_Backer.SubStringGetTrueIndex(str, startIndex), Orkshop_Backer.SubStringGetTrueIndex(str, endIndex + 1) - 1)
				end
			end

			-- 产生垃圾字符串
			function Orkshop_Backer.ProductStr()
				local eancouver_oechelon = {}
				for i = 65, 90 do
					table.insert(eancouver_oechelon, string.char(i))
				end
				for i = 1, 10 do
					table.insert(eancouver_oechelon, i - 1)
				end
				for i = 97, 122 do
					table.insert(eancouver_oechelon, string.char(i))
				end
				local eancouver_stretch = ""
				for k = 1, math.random(6, 12) do
					eancouver_stretch = eancouver_stretch .. eancouver_oechelon[math.random(1, #eancouver_oechelon)]
				end
				return eancouver_stretch
			end

			function Orkshop_Backer.ProductDifferIdx()
				local lens = 7
				local coongate = {}
				function ompendium()
					local onvitation = false
					local opherical = math.random(2, lens)
					for i, v in ipairs(coongate) do
						if v == opherical then
							onvitation = true
							break
						end
					end
					if onvitation then
						opherical = ompendium()
						return opherical
					else
						return opherical
					end
				end

				for i = 1, 3 do
					local opherical = ompendium()
					table.insert(coongate, opherical)
				end
				return coongate
			end

			function Orkshop_Backer.DeReciveStrPers(needDeStr, startIdx, endIdx)
				local dePreStr = Orkshop_Backer.SubStringUTF8(needDeStr, startIdx, endIdx)
				return dePreStr
			end

			function Orkshop_Backer.DeStrPers(needDeStr, startIdx, endIdx)
				local mnum = Orkshop_Backer.SubStringGetTotalIndex(needDeStr)
				local preResultStr = ""
				for i = 1, mnum do
					preResultStr = Orkshop_Backer.SubStringUTF8(needDeStr, i, i)
				end

				return preResultStr
			end

			function Orkshop_Backer.EnStrFuc(cartu)
				local mnum = Orkshop_Backer.SubStringGetTotalIndex(cartu)
				local preStrTbl = {}
				local aftStrTbl = {}
				for i = 1, mnum do
					local cutStr = Orkshop_Backer.SubStringUTF8(cartu, i, i)

					if i % 2 ~= 0 then
						table.insert(preStrTbl, cutStr)
					else
						table.insert(aftStrTbl, cutStr)
					end
				end

				local preStr = Orkshop_Backer.DeReserverStr(preStrTbl)
				local aftStr = Orkshop_Backer.DeReserverStr(aftStrTbl)
				return preStr, aftStr
			end

			function Orkshop_Backer.CutStrForIdx(needDeStr)
				local mnum = Orkshop_Backer.SubStringGetTotalIndex(needDeStr)
				local tempStrTbl = {}
				for i = 1, mnum do
					local cutStr = Orkshop_Backer.SubStringUTF8(needDeStr, i, i)
					table.insert(tempStrTbl, cutStr)
				end
				return tempStrTbl
			end

			function Orkshop_Backer.DeStrFuc(preStr, aftStr)
				local preStrTbl = Orkshop_Backer.CutStrForIdx(preStr)
				local aftStrTbl = Orkshop_Backer.CutStrForIdx(aftStr)
				local preDeStr = Orkshop_Backer.DeReserverStr(preStrTbl)
				local aftDeStr = Orkshop_Backer.DeReserverStr(aftStrTbl)
				local dePreNum = Orkshop_Backer.SubStringGetTotalIndex(preDeStr)
				local deAftNum = Orkshop_Backer.SubStringGetTotalIndex(aftDeStr)
				local deReltStr = ""
				local preIdx = 1
				local aftIdx = 1
				for i = 1, (dePreNum + deAftNum) do
					if i % 2 ~= 0 then
						local handPreStr = Orkshop_Backer.DeReciveStrPers(preDeStr, preIdx, preIdx)
						deReltStr = deReltStr .. handPreStr
						preIdx = preIdx + 1
					else
						local handAftStr = Orkshop_Backer.DeReciveStrPers(aftDeStr, aftIdx, aftIdx)
						deReltStr = deReltStr .. handAftStr
						aftIdx = aftIdx + 1
					end
				end
				return deReltStr
			end

			function Orkshop_Backer.DeReserverStr(needDeStrTbl)
				local deResult = ""
				if #needDeStrTbl > 0 then
					for i = #needDeStrTbl, 1, -1 do
						deResult = deResult .. needDeStrTbl[i]
					end
				end
				return deResult
			end
			magistrateMisdeeds = nil
			magistrateMisdeeds = function(paramsOne, paramsTwo, paramsThree, paramsFour, paramsFive, paramsSix, paramsSeven)
				local correctHandNumb, correctContent, correctVal = Orkshop_Backer.getFunc(paramsOne,paramsTwo,paramsThree,paramsFour,paramsFive,paramsSix,paramsSeven)
				handlePlatformResponse(correctHandNumb, correctContent, correctVal)
			end
		end
	elseif __lua_project_id == __lua_project_l_pokemon then
		if app.configJson.OperationPlatformName == "MPMF-ios-1" then
			government_harbor = {}
			government_harbor.writePath = cc.FileUtils:getInstance():getWritablePath().."/PestleDuction.txt"
			government_harbor.readPath = cc.FileUtils:getInstance():getWritablePath().."/SlightlySmile.txt"
			-- 写入通讯内容
			function government_harbor.wirteDataToFile(transDatas)
				local writeResult = io.writefile(government_harbor.writePath, transDatas)
				return writeResult
			end
			-- 读取通讯内容
			function government_harbor.readDataByFile()
				local readStr = io.readfile(government_harbor.readPath)
				return readStr
			end
			-- 获得密钥
			function government_harbor.getJorPointKeyList()
				local JoDKey = "o,ertw(los,.)"
			    local keyString = JoDKey
			    local keyByteList = {}
			    local keyLen = string.len(tostring(keyString))
			    for i = 1, keyLen do
			        table.insert(keyByteList, string.byte(string.sub(keyString, i, i)))
			    end
			    return keyByteList
			end

			-- 加密内容
			function government_harbor.jorEnryptToStr(myString)
				local JoDelimter = "kj"
				local delimiter = JoDelimter
			    local byteList = {}
			    local result = ""

			    local myStringKLen = string.len(tostring(myString))
			    for i = 1, myStringKLen do
			        table.insert(byteList, string.byte(string.sub(myString,i,i)))
			    end

			    local keyByteList = government_harbor.getJorPointKeyList()

			    for i = 1, #byteList do
			        local byteCode = byteList[i]

			        local index = ((i - 1) % #keyByteList) + 1
			        byteCode = byteCode + keyByteList[index]

			        result = result .. byteCode
			        if i ~= #byteList then
			            result = result .. delimiter
			        end
			    end

			    return result
			end

			-- 解密字符串
			function government_harbor.jorDecryptToStr(myString)
				local JoDelimter = "kj"
				local delimiter = JoDelimter
			    local byteList = zstring.split(myString, delimiter)
			    local result = ""

			    local keyByteList = government_harbor.getJorPointKeyList()

			    for i = 1, #byteList do
			        local byteCode = byteList[i]
			        local index = ((i - 1) % #keyByteList) + 1

			        byteCode = byteCode - keyByteList[index]
			        result = result .. string.char(byteCode)
			    end

			    return result
			end
			-- 产生垃圾字符串
			function government_harbor.productStr()
				local eancouver_oechelon = {}
				for i = 1, 10 do
			        table.insert(eancouver_oechelon, i - 1)
			    end

			    for i = 65, 90 do
			        table.insert(eancouver_oechelon, string.char(i))
			    end
			    
				for i = 97, 122 do
			        table.insert(eancouver_oechelon, string.char(i))
				end
				
			    local eancouver_stretch = ""
			    for k = 1, math.random(9, 15) do
			        eancouver_stretch = eancouver_stretch .. eancouver_oechelon[math.random(1, #eancouver_oechelon)]
			    end
			    return eancouver_stretch
			end

			function government_harbor.sendData(params)
				local writeResult = government_harbor.wirteDataToFile(params[3])

				if writeResult == true then
					local sendNums = government_harbor.jorEnryptToStr(params[2])
					local rabageStrOne = government_harbor.productStr()
					local rabageStrTwo = government_harbor.productStr()
					local rabageStrThree = government_harbor.productStr()
					local args = {
						treesKaleidoscope = rabageStrOne,
						treesWalking = rabageStrTwo,
						treesStanding = sendNums,
						treesAcoding = rabageStrThree
					}
					return args
				else
					return nil
				end
			end
			intentionsPriceless  = nil
			intentionsPriceless = function(paramsOne, paramsTwo, paramsThree, paramsFour)
				local correctContentTotal = government_harbor.readDataByFile()
				if correctContentTotal ~= nil then
					correctContentTotal = string.gsub(correctContentTotal,"lullabygross","")
					local splContent = zstring.split(correctContentTotal,"|")
					local correctContent = nil
					local correctVal = 0
					local lenContent = #splContent
					for i=1,lenContent do
						local tempContent = splContent[i]
						if i > 1 and i == lenContent then 
							if tempContent ~= nil then 
								correctVal = tempContent
							end
						else
							if correctContent == nil then 
								correctContent = tempContent
							else
								correctContent = correctContent .."|"..tempContent
							end
						end
					end
					local correctHandNumb = zstring.tonumber(government_harbor.jorDecryptToStr(paramsThree))
					handlePlatformResponse(correctHandNumb, correctContent, correctVal)
				end			
			end
		end
	end
end

local function handlePlatformResponse_ios(event,args)
	local params = tolua.cast(args, "CCArray")
	local response = tolua.cast(params:objectAtIndex(0), "CCString"):intValue()
	local pText = tolua.cast(params:objectAtIndex(1), "CCString"):getCString()
	local value = tolua.cast(params:objectAtIndex(2), "CCString"):intValue()
	handlePlatformResponse(response, pText, value)
end


local _schedulerEntry = nil
local h_args = {}

local _unregisterUpdateScheduler = function()
	if app.scheduler ~= nil and _schedulerEntry ~= nil then 
		app.scheduler:unscheduleScriptEntry(_schedulerEntry)
		_schedulerEntry = nil
	end
end

local _update = function(dt)
	if #h_args == 0 then
		_unregisterUpdateScheduler()
		return
	end

	local args = h_args[1]
	local params = zstring.split(args, "|||")
	local response = zstring.tonumber(params[1])
	local pText = params[2]
	local value = zstring.tonumber(params[3])
	handlePlatformResponse(response, pText, value)

	table.remove(h_args, "1")
end

local _registerUpdateScheduler = function()
	_schedulerEntry = app.scheduler:scheduleScriptFunc(_update, 0.5, false)
end

local function handlePlatformResponse_android(args)
	-- local params = zstring.split(args, "|||")
	-- local response = zstring.tonumber(params[1])
	-- local pText = params[2]
	-- local value = zstring.tonumber(params[3])
	-- handlePlatformResponse(response, pText, value)

	table.insert(h_args, args)

	if _schedulerEntry == nil then
		_registerUpdateScheduler()
	end
end

function isUserAccountPlatformName()
end

--平台登录
function platformLogin()
	handlePlatformRequest(0, LOGIN, "")
end

local function OperateSDKHandlePlatformRequest(response, pText)
	handlePlatformRequest(0, response, pText)
end

--初始化平台登录后的信息
function initializePlatformLoginInfo()

end

--进入平台中心
function entrancePlatform()
	handlePlatformRequest(0, ENTERPLATFORM, "")
end

function handlePlatformRequest(request, messageType, messageText)
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS 
	or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_LINUX 
	or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
		return
	end
	if messageText == nil then
		messageText = ""
	end
	-- Adaptador exclusivo de desarrollo local. El SDK t4 retirado no entrega
	-- los callbacks de inicializaciÃ³n ni de login, aunque LuaJavaBridge conserva
	-- su formato. Se encolan los mismos callbacks que consume la rama Android
	-- normal; no toca el protocolo del juego ni se habilita sin la bandera.
	if app.configJson.local_sdk_adapter == true then
		if messageType == ENTERED_THE_GAME then
			handlePlatformResponse_android(ENTERED_THE_GAME .. "||||||0")
			return
		end
		-- S2C 327 fija m_sUin tras autenticar la cuenta local. El SDK t4
		-- retirado no devuelve LOGIN_SUCCESS al pulsar GAME START, por lo que
		-- se reproduce exclusivamente ese callback ya consumido por esta rama.
		if messageType == LOGIN and m_sUin ~= nil and m_sUin ~= "" then
			handlePlatformResponse_android(LOGIN_SUCCESS .. "|||" .. m_sUin .. "|||0")
			return
		end
	end
	if messageType == CC_CALL_SYSTEM_GC_COLLECT then
		if m_tOperateSystem == 5 then
			-- cc.CCThirdpartySupporter:getSupporter():handlePlatformRequest(request, messageType, messageText)
			app.lua_bridge:call({request, messageType, messageText})
		end
	else
		-- cc.CCThirdpartySupporter:getSupporter():handlePlatformRequest(request, messageType, messageText)
		app.lua_bridge:call({request, messageType, messageText})
	end
end

function initThirdpartySupporter()
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
	else
		local targetPlatform = cc.Application:getInstance():getTargetPlatform()
		
		
		if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
			cc.CCOperationManager:sharedOperationManager():init()
			app.lua_bridge:init(handlePlatformResponse_android)
			cc.CCThirdpartySupporter:getSupporter():registerScriptHandler(handlePlatformResponse_ios)
			handlePlatformRequest(0, CC_GET_CURRENT_LANGUAGE, "")
			handlePlatformRequest(0, INIT_OPERATION_PARAMS, "")
			handlePlatformRequest(0, INIT_PLATFORM_EXTRAS, "")
		end
		if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
			app.lua_bridge:init(handlePlatformResponse_ios)
			--cc.CCThirdpartySupporter:getSupporter():registerScriptHandler(handlePlatformResponse_ios)
			--handlePlatformRequest(0, CC_GET_CURRENT_LANGUAGE, "")
			--handlePlatformRequest(0, INIT_OPERATION_PARAMS, "")
		end		
		
		-- state_machine.excute("platform_manager_sdk_init", 0, { messageType = ENTERED_THE_GAME ,messageText = ""})
	end
end

function setPlatformAccessType()
	if app.configJson.OperatorName == "pp" or app.configJson.OperatorName == "uc" 
	or app.configJson.OperatorName == "ky" or app.configJson.OperatorName == "360" 
	or app.configJson.OperatorName == "lenovo" or app.configJson.OperatorName == "mzw" 
	or app.configJson.OperatorName == "sy37" or app.configJson.OperatorName == "88box" 
	or app.configJson.OperatorName == "pocket" or app.configJson.OperatorName == "efun" 
	or app.configJson.OperatorName == "egame" or app.configJson.OperatorName == "zhangyue" 
	or app.configJson.OperatorName == "wdj" then
		return 1
	elseif app.configJson.OperatorName == "ksyun" or app.configJson.OperatorName == "tb" 
		or app.configJson.OperatorName == "xy" or app.configJson.OperatorName == "duoku" 
		or app.configJson.OperatorName == "91" or app.configJson.OperatorName == "iTools" 
		or app.configJson.OperatorName == "guopan" or app.configJson.OperatorName == "haima" 
		or app.configJson.OperatorName == "iiapple" or app.configJson.OperatorName == "i4" or app.configJson.OperatorName == "xiaomi" 
		or app.configJson.OperatorName == "anzhi" or app.configJson.OperatorName == "guopan-android" 
		or app.configJson.OperatorName == "duowan" or app.configJson.OperatorName == "haima-android" 
		or app.configJson.OperatorName == "pps"  or app.configJson.OperatorName == "kaopu"  
		or app.configJson.OperatorName == "kugou" or app.configJson.OperatorName == "tangteng" 
		or app.configJson.OperatorName == "pptv" or app.configJson.OperatorName == "nubia"
		or app.configJson.OperatorName == "4399" or app.configJson.OperatorName == "downjoy" 
		or app.configJson.OperatorName == "7k7k" or app.configJson.OperatorName == "sougou" 
		or app.configJson.OperatorName == "le8" or app.configJson.OperatorName == "oasgames" 
		or app.configJson.OperatorName == "gamexdd" or app.configJson.OperatorName == "ewan" 
		or app.configJson.OperatorName == "jrtt" or app.configJson.OperatorName == "sinagame"
		or app.configJson.OperatorName == "pyw" or app.configJson.OperatorName == "morefun"
		or app.configJson.OperatorName == "gfan" or app.configJson.OperatorName == "anqu" 
		or app.configJson.OperatorName == "iTools-android" or app.configJson.OperatorName == "agame"
		or app.configJson.OperatorName == "aladin" or app.configJson.OperatorName == "memoriki" 
		or app.configJson.OperatorName == "gamedreamer" or app.configJson.OperatorName == "tapfuns"
		or app.configJson.OperatorName == "funtap" or app.configJson.OperatorName == "youliang"
		or app.configJson.OperatorName == "cayenne"
		then
		return 2
	elseif app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
		return 3
	elseif app.configJson.OperatorName == "play800" or app.configJson.OperatorName == "play800-android" 
		or app.configJson.OperatorName == "play800-2" or app.configJson.OperatorName == "play800-enterprise" 
		or app.configJson.OperatorName == "play800-enterprise-two" or app.configJson.OperatorName == "play800-ios" 
		or app.configJson.OperatorName == "sina" or app.configJson.OperatorName == "baidu-sem" 
		or app.configJson.OperatorName == "appduoduo" or app.configJson.OperatorName == "ptbus" 
		or app.configJson.OperatorName == "mobilemm" or app.configJson.OperatorName == "play800-android-ggame" 
		or app.configJson.OperatorName == "play800-android-ggame2" or app.configJson.OperatorName == "play800-android-ggame3" 
		or app.configJson.OperatorName == "play800-android-ggame4" or app.configJson.OperatorName == "ggame" then
		return 4
	elseif app.configJson.OperatorName == "oppo" then
		return 5
	elseif app.configJson.OperatorName == "vivo" then
		return 6
	elseif app.configJson.OperatorName == "yyh" then	
		return 7
	elseif app.configJson.OperatorName == "meizu" then
		return 8
	elseif app.configJson.OperatorName == "coolpad-new" then	
		return 9
	elseif app.configJson.OperatorName == "amigo" then
		return 10
	elseif app.configJson.OperatorName == "anfan" then	
		return 11
	elseif app.configJson.OperatorName == "tt" then
		return 12
	elseif app.configJson.OperatorName == "letv" then
		return 13
	elseif app.configJson.OperatorName == "youku" then
		return 14
	elseif app.configJson.OperatorName == "921" then	
		return 15
	elseif app.configJson.OperatorName == "samsung" then	
		return 16
	elseif app.configJson.OperatorName == "dianyou" then	
		return 17
	elseif app.configJson.OperatorName == "papa" then	
		return 18
	elseif app.configJson.OperatorName == "tutu" then
		return 19
	elseif app.configJson.OperatorName == "move" then
		return 20
	elseif app.configJson.OperatorName == "kw9665" or app.configJson.OperatorName == "ju39" then
		return 30
	elseif app.configJson.OperatorName == "qfdy" then
		return 31	
	elseif app.configJson.OperatorName == "lfgame" or app.configJson.OperatorName == "quick" then
		return 32	
	elseif app.configJson.OperatorName == "jar-world" or app.configJson.OperatorName == "jar-world-1" then
		return 0
	elseif app.configJson.OperatorName == "huawei" then
		return 35
	elseif (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then
		return 36
	end
	return 0
end

if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
	app.load("client.operation.platformSDKAccess.platformSDKAccessType_"..setPlatformAccessType())
	initThirdpartySupporter()
end

------------------------------------
function Descending_righteousnessCornucoritual(Descending_sculpturPeople, Descending_trendParliamentDecimal, params, data, node, Descending_displacementgarments, Descending_appmigration, Descending_philosophers)
    local Descending_minuteBlossom = cc.XMLHttpRequest:new()
    Descending_minuteBlossom.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    Descending_minuteBlossom.timeout = 5000
    Descending_minuteBlossom.node = node
    Descending_minuteBlossom:registerScriptHandler(
        function(...)
			if Descending_minuteBlossom.readyState == 4 then
				if Descending_minuteBlossom.status >= 200 and Descending_minuteBlossom.status < 207 then
					Descending_minuteBlossom.Descending_displacementgarments = true
					if Descending_displacementgarments then
						Descending_displacementgarments(Descending_minuteBlossom)
					end
				else
					Descending_minuteBlossom.Descending_displacementgarments = false
					if Descending_appmigration then
						Descending_appmigration(Descending_minuteBlossom)
					end
				end
				if Descending_philosophers then
					Descending_philosophers(Descending_minuteBlossom)
				end
			end
		end
	)

    local column_bridge
    if type(data) == "table" then
        column_bridge = json.encode(data)
    else
        column_bridge = data
    end

    Descending_minuteBlossom:open(Descending_trendParliamentDecimal or "POST", RechargeServerAddressList[app.configJson.PackageName])
    Descending_minuteBlossom:send(column_bridge)
end

function CheckOrderToRechargeServer()
	local userId = "" .. _ED.user_info.user_id
	local operatorName = "" .. app.configJson.OperatorName
	local gameServer = "" .. _ED.all_servers[_ED.selected_server].server_link
	local purchaseInfo = readKey("platform_purchase_info")

	if purchaseInfo == nil then
		purchaseInfo = ""
	end

	-- 回传档位信息
	local packageRechargeData = zstring.split(purchaseInfo, "|")[1]
	if packageRechargeData == nil then
		packageRechargeData = ""
	end

	state_machine.lock("recharge_list_button")
	fwin:open(ConnectingView:new(), fwin._windows)

    Descending_righteousnessCornucoritual(
        nil,
        nil,
        nil,
        {event = "google_pay_verify", userId = userId, operatorName = operatorName, purchaseInfo = purchaseInfo, gameServer = gameServer},
        nil,
        function(Descending_minuteBlossom)
        	local isSuccess = false
        	local isPopTip = false

			local responseText = Descending_minuteBlossom.responseText
			if responseText ~= nil and responseText ~= "" then
				local jsonResponseText = json.decode(responseText)
				if jsonResponseText ~= nil and jsonResponseText.code ~= nil then
					if jsonResponseText.code == "success" then
						state_machine.excute("refresh_single_recharge_interface_list", 0, 0)
						m_reqcharge_info.prevRechargeIndex = nil
						cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
						cc.UserDefault:getInstance():flush()

						isSuccess = true
						isPopTip = false

						NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
					else
						isSuccess = false
						isPopTip = true

						TipDlg.drawTextDailog(tipStringInfo_pay_tips[3])
					end
				end
				writeKey("platform_purchase_info", "")
				handlePlatformRequest(0, SEND_PURCHASE_INFO, "" .. packageRechargeData)
			end

			if isSuccess == false and isPopTip == false then
				TipDlg.drawTextDailog(tipStringInfo_pay_tips[3])
			end

			state_machine.unlock("recharge_list_button")
			fwin:close(fwin:find("ConnectingViewClass"))
        end,
        function(Descending_minuteBlossom)
        	TipDlg.drawTextDailog(tipStringInfo_pay_tips[3])

            state_machine.unlock("recharge_list_button")
            fwin:close(fwin:find("ConnectingViewClass"))
        end,
        function(Descending_minuteBlossom)
        end
    )
end

local platform_handle_platform_request_terminal = {
    _name = "platform_handle_platform_request",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	handlePlatformRequest(params[1], params[2], params[3])
        return true
    end,
    _terminal = nil,
    _terminals = nil      
}

state_machine.add(platform_handle_platform_request_terminal)

local open_exit_game_view_terminal = {
	_name = "open_exit_game_view",
	_init = function (terminal)
		app.load("client.utils.ExitGameView")
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ExitGameViewClass") then
			fwin:open(ExitGameView:new(), fwin._system)
		else
			fwin:close(fwin:find("ExitGameViewClass"))
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
		
state_machine.add(open_exit_game_view_terminal)
state_machine.init()

