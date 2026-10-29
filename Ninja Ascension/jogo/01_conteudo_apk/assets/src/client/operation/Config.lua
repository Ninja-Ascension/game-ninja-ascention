app.load("configs.platformConfig.config")
-- 当前开发的版本号，由此值来控制客户端及客户端的逻辑
-- dev_version 1000 : 
--		1、限时神将
--		2、月卡
-- dev_version 2001 : 
--		1、添加新的new_get_server_list协议
-- dev_version 2002 : 
--		1、新少三的章节副本
-- dev_version 2003 : 
--		1、原版的章节副本
-- dev_version 2004 : 
--		1、龙虎门战斗节奏调整
-- dev_version 2005 : 
--		1、舰娘去掉战斗前的划水
-- dev_version 2006 : 
--		1、舰娘,继续划水,将第一场战斗请求和资源光效加载移入到关门
-- dev_version 2007 : 
--		1、舰娘,新增叛军分享状态及提示
dev_version=2007

-- 项目的宏定义
__lua_project_id					= zstring.tonumber(app.configJson.ReleaseProject)
__lua_project_pirates	 			= 0		-- 海贼王
__lua_project_sanguo	 			= 1		-- 三国无双
__lua_project_transformers 			= 2		-- 变形金刚
__lua_project_kofmusou 				= 3		-- 拳皇无双
__lua_project_bleach 				= 4		-- 死神
__lua_project_superhero 			= 5		-- 超级英雄
__lua_project_all_star	 			= 6		-- 放开那童年
__lua_king_of_adventure	 			= 7		-- 冒险王
__lua_project_koone					= 8		-- 终级一班
__lua_project_warship_girl_a		= 9		-- 靓娘-原生
__lua_project_warship_girl_b		= 10	-- 靓娘-中国化 
__lua_project_gragon_tiger_gate		= 11	-- 龙虎门
__lua_project_legendary_game		= 12	-- 超神游戏
__lua_project_adventure				= 13	-- 冒险与挖矿
__lua_project_digimon_adventure  	= 14	-- 数码暴龙大冒险
__lua_project_red_alert				= 15	-- Red Alert
__lua_project_yugioh				= 16	-- 游戏王
__lua_project_pokemon				= 17	-- 口袋妖怪
__lua_project_rouge					= 18	-- 胭脂
__lua_project_ashes_of_time			= 19	-- 东邪西毒
__lua_project_digital_monster		= 20	-- 数码世界
__lua_project_naruto				= 21	-- 火影忍者
__lua_project_22					= 22	-- 空
__lua_project_red_alert_time		= 23	-- 红擎复刻
__lua_project_l_digital				= 50	-- 数码-(来源龙虎门)
__lua_project_pacific_rim			= 25	-- 机甲-(来源红擎复刻)
__lua_project_l_naruto				= 27	-- 火影忍者-(来源龙虎门)
__lua_project_underworld_empire		= 28	-- 黑道王朝
__lua_project_koihime_musou			= 29	-- 恋姬无双-(来源横版数码)
__lua_project_l_pokemon				= 53	-- 口袋-(来源龙虎门)
__lua_project_l_dragonball			= 24	-- 龙珠-未创建项目目录
__lua_project_emperor_auspicious	= 32	-- 逍遥大官人-(来源黑道王朝 H5)
__lua_project_idle_world			= 33	-- 放置世界
__lua_project_onepiece			    = 34	-- 海贼王
__lua_project_game_of_thrones		= 35	-- 权利的游戏

-- 导入平台相关的配置参数
-- require script/transformers/config/*

-- 语种的宏定义
-- 各国语言缩写-各国语言简称 
_lua_release_language_param 		= zstring.split(app.configJson.ReleaseLanguage, ",")
_lua_release_language_en 			= "en"		-- 英文  
_lua_release_language_en_US 		= "en_US"		--  英文 (美国)  
_lua_release_language_ar 			= "ar"		--  阿拉伯文  
_lua_release_language_ar_AE 		= "ar_AE"		--  阿拉伯文 (阿拉伯联合酋长国)  
_lua_release_language_ar_BH 		= "ar_BH"		--  阿拉伯文 (巴林)  
_lua_release_language_ar_DZ 		= "ar_DZ"		--  阿拉伯文 (阿尔及利亚)  
_lua_release_language_ar_EG	 		= "ar_EG"		--  阿拉伯文 (埃及)  
_lua_release_language_ar_IQ 		= "ar_IQ"		--  阿拉伯文 (伊拉克)  
_lua_release_language_ar_JO 		= "ar_JO"		--  阿拉伯文 (约旦)  
_lua_release_language_ar_KW 		= "ar_KW"		--  阿拉伯文 (科威特)  
_lua_release_language_ar_LB 		= "ar_LB"		--  阿拉伯文 (黎巴嫩)  
_lua_release_language_ar_LY 		= "ar_LY"		--  阿拉伯文 (利比亚)  
_lua_release_language_ar_MA 		= "ar_MA"		--  阿拉伯文 (摩洛哥)  
_lua_release_language_ar_OM 		= "ar_OM"		--  阿拉伯文 (阿曼)  
_lua_release_language_ar_QA 		= "ar_QA"		--  阿拉伯文 (卡塔尔)  
_lua_release_language_ar_SA 		= "ar_SA"		--  阿拉伯文 (沙特阿拉伯)  
_lua_release_language_ar_SD 		= "ar_SD"		--  阿拉伯文 (苏丹)  
_lua_release_language_ar_SY 		= "ar_SY"		--  阿拉伯文 (叙利亚)  
_lua_release_language_ar_TN 		= "ar_TN"		--  阿拉伯文 (突尼斯)  
_lua_release_language_ar_YE 		= "ar_YE"		--  阿拉伯文 (也门)  
_lua_release_language_be 			= "be"		--  白俄罗斯文  
_lua_release_language_be_BY 		= "be_BY"		--  白俄罗斯文 (白俄罗斯)  
_lua_release_language_bg 			= "bg"		--  保加利亚文  
_lua_release_language_bg_BG 		= "bg_BG"		--  保加利亚文 (保加利亚)  
_lua_release_language_ca 			= "ca"		--  加泰罗尼亚文  
_lua_release_language_ca_ES 		= "ca_ES"		--  加泰罗尼亚文 (西班牙)  
_lua_release_language_ca_ES_EURO 	= "ca_ES_EURO"		--  加泰罗尼亚文 (西班牙,Euro)  
_lua_release_language_cs 			= "cs"		--  捷克文  
_lua_release_language_cs_CZ 		= "cs_CZ"		--  捷克文 (捷克共和国)  
_lua_release_language_da 			= "da"		--  丹麦文  
_lua_release_language_da_DK 		= "da_DK"		--  丹麦文 (丹麦)  
_lua_release_language_de 			= "de"		--  德文  
_lua_release_language_de_AT 		= "de_AT"		--  德文 (奥地利)  
_lua_release_language_de_AT_EURO 	= "de_AT_EURO"		--  德文 (奥地利,Euro)  
_lua_release_language_de_CH 		= "de_CH"		--  德文 (瑞士)  
_lua_release_language_de_DE 		= "de_DE"		--  德文 (德国)  
_lua_release_language_de_DE_EURO 	= "de_DE_EURO"		--  德文 (德国,Euro)  
_lua_release_language_e_LU 			= "e_LU"		--  德文 (卢森堡)  
_lua_release_language_de_LU_EURO 	= "de_LU_EURO"		--  德文 (卢森堡,Euro)  
_lua_release_language_el 			= "el"		--  希腊文  
_lua_release_language_el_GR 		= "el_GR"		--  希腊文 (希腊)  
_lua_release_language_en_AU 		= "en_AU"		--  英文 (澳大利亚) 
_lua_release_language_en_CA 		= "en_CA"		--  英文 (加拿大)  
_lua_release_language_en_GB 		= "en_GB"		--  英文 (英国)  
_lua_release_language_en_IE 		= "en_IE"		--  英文 (爱尔兰)  
_lua_release_language_en_IE 		= "en_IE"		-- _EURO 英文 (爱尔兰,Euro)  
_lua_release_language_en_NZ 		= "en_NZ"		--  英文 (新西兰)  
_lua_release_language_en_ZA 		= "en_ZA"		--  英文 (南非)  
_lua_release_language_es 			= "es"		--  西班牙文  
_lua_release_language_es_BO 		= "es_BO"		--  西班牙文 (玻利维亚)  
_lua_release_language_es_AR 		= "es_AR"		--  西班牙文 (阿根廷)  
_lua_release_language_es_CL 		= "es_CL"		--  西班牙文 (智利)  
_lua_release_language_es_CO 		= "es_CO"		--  西班牙文 (哥伦比亚)  
_lua_release_language_es_CR 		= "es_CR"		--  西班牙文 (哥斯达黎加)  
_lua_release_language_es_DO 		= "es_DO"		--  西班牙文 (多米尼加共和国)  
_lua_release_language_es_EC 		= "es_EC"		--  西班牙文 (厄瓜多尔)  
_lua_release_language_es_ES 		= "es_ES"		--  西班牙文 (西班牙)  
_lua_release_language_es_ES_EURO 	= "es_ES_EURO"		--  西班牙文 (西班牙,Euro)  
_lua_release_language_es_GT 		= "es_GT"		--  西班牙文 (危地马拉)  
_lua_release_language_es_HN 		= "es_HN"		--  西班牙文 (洪都拉斯)  
_lua_release_language_es_MX 		= "es_MX"		--  西班牙文 (墨西哥)  
_lua_release_language_es_NI 		= "es_NI"		--  西班牙文 (尼加拉瓜)  
_lua_release_language_et 			= "et"		--  爱沙尼亚文  
_lua_release_language_es_PA 		= "es_PA"		--  西班牙文 (巴拿马)  
_lua_release_language_es_PE 		= "es_PE"		--  西班牙文 (秘鲁)  
_lua_release_language_es_PR 		= "es_PR"		--  西班牙文 (波多黎哥)  
_lua_release_language_es_PY 		= "es_PY"		--  西班牙文 (巴拉圭)  
_lua_release_language_es_SV 		= "es_SV"		--  西班牙文 (萨尔瓦多)  
_lua_release_language_es_UY 		= "es_UY"		--  西班牙文 (乌拉圭)  
_lua_release_language_es_VE 		= "es_VE"		--  西班牙文 (委内瑞拉)  
_lua_release_language_et_EE 		= "et_EE"		--  爱沙尼亚文 (爱沙尼亚)  
_lua_release_language_fi 			= "fi"		--  芬兰文  
_lua_release_language_fi_FI 		= "fi_FI"		--  芬兰文 (芬兰)  
_lua_release_language_fi_FI_EURO 	= "fi_FI_EURO"		--  芬兰文 (芬兰,Euro)  
_lua_release_language_fr 			= "fr"		--  法文  
_lua_release_language_fr_BE 		= "fr_BE"		--  法文 (比利时)  
_lua_release_language_fr_BE_EURO 	= "fr_BE_EURO"		--  法文 (比利时,Euro)  
_lua_release_language_fr_CA 		= "fr_CA"		--  法文 (加拿大)  
_lua_release_language_fr_CH 		= "fr_CH"		--  法文 (瑞士)  
_lua_release_language_fr_FR 		= "fr_FR"		--  法文 (法国)  
_lua_release_language_fr_FR_EURO 	= "fr_FR_EURO"		--  法文 (法国,Euro)  
_lua_release_language_fr_LU 		= "fr_LU"		--  法文 (卢森堡)  
_lua_release_language_fr_LU_EURO 	= "fr_LU_EURO"		--  法文 (卢森堡,Euro)  
_lua_release_language_hr 			= "hr"		--  克罗地亚文  
_lua_release_language_hr_HR 		= "hr_HR"		--  克罗地亚文 (克罗地亚)  
_lua_release_language_hu 			= "hu"		--  匈牙利文  
_lua_release_language_hu_HU 		= "hu_HU"		--  匈牙利文 (匈牙利)  
_lua_release_language_is 			= "is"		--  冰岛文   
_lua_release_language_is_IS 		= "is_IS"		--  冰岛文 (冰岛)  
_lua_release_language_it 			= "it"		--  意大利文   
_lua_release_language_it_CH 		= "it_CH"		--  意大利文 (瑞士)  
_lua_release_language_it_IT 		= "it_IT"		--  意大利文 (意大利)   
_lua_release_language_it_IT_EURO 	= "it_IT_EURO"		--  意大利文 (意大利,Euro)  
_lua_release_language_iw 			= "iw"		--  希伯来文   
_lua_release_language_iw_IL 		= "iw_IL"		--  希伯来文 (以色列)  
_lua_release_language_ja 			= "ja"		--  日文   
_lua_release_language_ja_JP 		= "ja_JP"		--  日文 (日本)  
_lua_release_language_ko 			= "ko"		--  朝鲜文   
_lua_release_language_ko_KR 		= "ko_KR"		--  朝鲜文 (南朝鲜)  
_lua_release_language_lt 			= "lt"		--  立陶宛文   
_lua_release_language_lt_LT 		= "lt_LT"		--  立陶宛文 (立陶宛)  
_lua_release_language_lv 			= "lv"		--  拉托维亚文(列托)   
_lua_release_language_lv_LV 		= "lv_LV"		--  拉托维亚文(列托) (拉脱维亚)  
_lua_release_language_mk 			= "mk"		--  马其顿文   
_lua_release_language_mk_MK 		= "mk_MK"		--  马其顿文 (马其顿王国)  
_lua_release_language_nl			= "nl"		--  荷兰文   
_lua_release_language_nl_BE 		= "nl_BE"		--  荷兰文 (比利时)   
_lua_release_language_nl_BE_EURO 	= "nl_BE_EURO"		--  荷兰文 (比利时,Euro)  
_lua_release_language_nl_NL 		= "nl_NL"		--  荷兰文 (荷兰)   
_lua_release_language_nl_NL_EURO 	= "nl_NL_EURO"		--  荷兰文 (荷兰,Euro)  
_lua_release_language_no 			= "no"		--  挪威文   
_lua_release_language_no_NO 		= "no_NO"		--  挪威文 (挪威)   
_lua_release_language_no_NO_NY 		= "no_NO_NY"		--  挪威文 (挪威,Nynorsk)  
_lua_release_language_pl 			= "pl"		--  波兰文   
_lua_release_language_pl_PL 		= "pl_PL"		--  波兰文 (波兰)  
_lua_release_language_pt 			= "pt"		--  葡萄牙文   
_lua_release_language_pt_BR 		= "pt_BR"		--  葡萄牙文 (巴西)  
_lua_release_language_pt_PT 		= "pt_PT"		--  葡萄牙文 (葡萄牙)   
_lua_release_language_pt_PT_EURO 	= "pt_PT_EURO"		--  葡萄牙文 (葡萄牙,Euro)  
_lua_release_language_ro 			= "ro"		--  罗马尼亚文   
_lua_release_language_ro_RO 		= "ro_RO"		--  罗马尼亚文 (罗马尼亚)  
_lua_release_language_ru 			= "ru"		--  俄文   
_lua_release_language_ru_RU			= "ru_RU"		--  俄文 (俄罗斯)  
_lua_release_language_sh 			= "sh"		--  塞波尼斯-克罗地亚文   
_lua_release_language_sh_YU 		= "sh_YU"		-- 塞波尼斯-克罗地亚文 (南斯拉夫)  
_lua_release_language_sk 			= "sk"		--  斯洛伐克文   
_lua_release_language_sk_SK 		= "sk_SK"		--  斯洛伐克文 (斯洛伐克)  
_lua_release_language_sl 			= "sl"		--  斯洛文尼亚文   
_lua_release_language_sl_SI 		= "sl_SI"		--  斯洛文尼亚文 (斯洛文尼亚)  
_lua_release_language_sq 			= "sq"		--  阿尔巴尼亚文
_lua_release_language_sq_AL 		= "sq_AL"		--  阿尔巴尼亚文 (阿尔巴尼亚)  
_lua_release_language_sr 			= "sr"		--  塞尔维亚文   
_lua_release_language_sr_YU 		= "sr_YU"		--  塞尔维亚文 (南斯拉夫)  
_lua_release_language_sv 			= "sv"		--  瑞典文   
_lua_release_language_sv_SE			= "sv_SE"		--  瑞典文 (瑞典)  
_lua_release_language_th 			= "th"		--  泰文   
_lua_release_language_th_TH 		= "th_TH"		--  泰文 (泰国)  
_lua_release_language_tr			= "tr"		--  土耳其文   
_lua_release_language_tr_TR 		= "tr_TR"		--  土耳其文 (土耳其)  
_lua_release_language_uk 			= "uk"		--  乌克兰文   
_lua_release_language_uk_UA 		= "uk_UA"		--  乌克兰文 (乌克兰)  
_lua_release_language_vi 			= "vi"		--  越南文 (Tiếng Việt)
_lua_release_language_vi_VN 		= "vi_VN"		--  越南文 (越南)
_lua_release_language_zh 			= "zh"		--  中文   
_lua_release_language_zh_CN 		= "zh_CN"		--  中文 (中国)  
_lua_release_language_zh_HK 		= "zh_HK"		--  中文 (香港)  
_lua_release_language_zh_TW 		= "zh_TW"		--  中文 (台湾) 

function verifySupportLanguage(language)
	-- Naruto (punto 6, 27-sep): las traducciones salieron del INGLES, asi que las ramas «si es ingles» (159 en el
	-- Lua: «Nv.15» delante y no «15NV», textos que no se trocean por bytes chinos en PVESecondarySceneInfo, etc.)
	-- son las que les tocan a todos los idiomas que no son chino. Visto en LDPlayer: «Alcanza 15NV para obtener».
	if language == _lua_release_language_en and m_curr_choose_language ~= nil and m_curr_choose_language ~= ""
		and m_curr_choose_language ~= _lua_release_language_zh_CN and m_curr_choose_language ~= _lua_release_language_zh_TW then
		return true
	end
	--多语言的时候
	if m_curr_choose_language == nil or m_curr_choose_language == "" then
		for i, v in pairs(_lua_release_language_param) do
			if v == language then
				return true
			end
		end
	else
		if m_curr_choose_language == language then
			return true
		end
	end
	return false
end

--Devuelve true si el paquete de ese idioma YA ESTA EN DISCO.
--Los once res/language/<idioma> viajan dentro del juego y todos traen
--data/TipStringInfo.lua, asi que ese fichero es la marca. Se prueban las
--dos formas de la ruta porque "res" es a la vez carpeta del paquete y ruta
--de busqueda (el mismo truco que logo.lua con "language/ps/data/...").
function languagePackIsOnDisk(language)
	if language == nil or language == "" then
		return false
	end
	local rutas = {}
	local languageConfig = nil
	if config_res ~= nil and config_res.multiLanguage ~= nil then
		languageConfig = config_res.multiLanguage[language]
	end
	if languageConfig ~= nil and languageConfig.searchPaths ~= nil then
		for i, v in pairs(languageConfig.searchPaths) do
			table.insert(rutas, v)
			table.insert(rutas, (string.gsub(v, "^res/", "")))
		end
	end
	table.insert(rutas, "res/language/" .. language)
	table.insert(rutas, "language/" .. language)
	local fileUtils = cc.FileUtils:getInstance()
	for i, v in pairs(rutas) do
		if fileUtils:isFileExist(v .. "/data/TipStringInfo.lua") == true then
			return true
		end
	end
	return false
end

--Un idioma se puede aplicar SIN descargar nada si ya se bajo alguna vez
--(assets_download_url_<idioma>), si viene dentro de esta compilacion
--(ReleaseLanguage) o si su carpeta esta en disco. El tercer caso es el que
--faltaba: elegir un idioma que no estuviera en ReleaseLanguage mandaba al
--descargador nativo contra un CDN de terceros ya muerto, y ahi se quedaba
--el juego reintentando sin fin.
function languageIsReady(language)
	local bajado = cc.UserDefault:getInstance():getStringForKey("assets_download_url_" .. language, "0")
	if bajado ~= "0" then
		return true
	end
	if verifySupportLanguage(language) == true then
		return true
	end
	return languagePackIsOnDisk(language)
end
--包含繁体字的多语言要去字体
function isContentZh_TW()
	for i, v in pairs(_lua_release_language_param) do
		if v == _lua_release_language_zh_TW then
			return true
		end
	end
	return false
end

function getDefaultLanguage()
	return _lua_release_language_param[1]
end

function getVersion()
	return m_sVersion
end

function getPlatformParam()
	local str = nil
	if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
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
				
				str =app.configJson.OperatorName.."\r\n"..app.configJson.OperationPlatformName.."\r\nios\r\n"..mUidRecode.."\r\niphone11\r\n1024X768\r\n5.1.1\r\n00-10-1-12\r\n"
			else
				str = platform_extras
			end
	else
		if app.configJson.UserAccountPlatformName ~= "jar-world" 
			and app.configJson.UserAccountPlatformName ~= "jar-world-ios" 
			and app.configJson.UserAccountPlatformName ~= "jar-world-android" 
			and app.configJson.UserAccountPlatformName ~= "jar-world-wp8" 
			then
				if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then

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
					
					str =app.configJson.OperatorName.."\r\n"..app.configJson.OperationPlatformName.."\r\nios\r\n"..mUidRecode.."\r\niphone11\r\n1024X768\r\n5.1.1\r\n00-10-1-12\r\n"
				else
					str = platform_extras
				end
		else
			str="jar-world\r\njar-world\r\nWin32\r\nWin32IMEI\r\niPhone 4s\r\n1024X768\r\nWindows8\r\n00-10-1-12\r\n"
		end
	end
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
		then
		local platform_extras_arr = zstring.split(str, "\r\n")
		platform_extras_arr[1] = app.configJson.UserAccountPlatformName
		platform_extras_arr[2] = app.configJson.OperationPlatformName
		str = zstring.concat(platform_extras_arr, "\r\n")
	else
		local platform_extras_arr = zstring.split(str, "\r\n")
		if platform_extras_arr[4] == "000000000000000" or platform_extras_arr[4] == "null" or platform_extras_arr[4] == "imei" then
			platform_extras_arr[4] = platform_extras_arr[8]
		end
		str = zstring.concat(platform_extras_arr, "\r\n")
	end

	return str
end

function getURL()
	return m_sURL
end

function getPackageParam()
	package_rc = cc.UserDefault:getInstance():getStringForKey("package")
	cc.UserDefault:getInstance():flush()
	if #package_rc <= 0 then
		package_rc = "0.0"
	end
	return package_rc
end

function getPackageMd5Param()
	local package_md5 = cc.UserDefault:getInstance():getStringForKey("package_md5")
	cc.UserDefault:getInstance():flush()
	if #package_md5 <= 0 then
		package_md5 = "0.0"
	end
	return package_md5
end

--获取平台参数
function getPlatform()
	return m_sOperationPlatformName
end

--获得硬件类型
function getHardwareType()
	return "1"
end

--获得应用名称
function getApplicationName()
	return "Transformers"
end 

--获得账号来源
function getUserAccountPlatform()
	return m_sUserAccountPlatformName
end

--获得渠道来源
function getChannelSource()
	return "jar-world"
end

--获得手机操作系统
function getOperatingSystem()
	return "IOS"
end

--手机识别码
function getIMEI()
	return "IMEI"
end
--手机机型
function getModel()
	return "iPhone 4S"
end

--手机分辨率
function getDisplayMetrics()
	return "320x480"
end

--手机操作系统版本
function getOperatingSystemVersion()
	return "7.0.6"
end

--手机MAC地址
function getMAC()
	return "3141592678"
end
app.load("client/operation/ThirdpartySupporter")
app.load("client/operation/jttd")