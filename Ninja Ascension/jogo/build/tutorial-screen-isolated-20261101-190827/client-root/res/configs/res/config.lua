config_res = config_res or {}

--登陆弹窗
config_res._sync_draw_open = true

---- campaign.nationalwar.music.background
config_res.campaign = config_res.campaign or {}
config_res.campaign.nationalwar = config_res.campaign.nationalwar or {}
config_res.campaign.nationalwar.music = config_res.campaign.nationalwar.music or {}
config_res.campaign.nationalwar.music.background = config_res.campaign.nationalwar.music.background or {}

--国战大地图
config_res.campaign.nationalwar.music.background.warMap											= "1"
--城池内战斗
config_res.campaign.nationalwar.music.background.warCityWarMap									= "2"

config_res.campaign.nationalwar.music.background.card = config_res.campaign.nationalwar.music.background.card or {}

--灭火
config_res.campaign.nationalwar.music.background.card.miehuo								= "23"
--纵火
config_res.campaign.nationalwar.music.background.card.fanghuo								= "10"
--俱焚
config_res.campaign.nationalwar.music.background.card.jufen									= "10027"
--鼓舞
config_res.campaign.nationalwar.music.background.card.guwu									= "9997"
--疗伤
config_res.campaign.nationalwar.music.background.card.liaoshang								= "13"

config_res.images = config_res.images or {}
config_res.images.ui = config_res.images.ui or {}
config_res.images.ui.effice = config_res.images.ui.effice or {}
config_res.images.ui.effice.effect_quality_box = "images/ui/effice/effect_quality_box_%d/effect_quality_box_%d.ExportJson"
--多语言配置
config_res.multiLanguage = {
    ["pt_BR"] = {
        ["name"] = "pt_BR",
        ["searchPaths"] = { "res/language/comun", "res/language/pt_BR"},
        ["currentLanguage"] = "Idioma atual:",
        ["languageText"] = "Português (BR)",
        ["changeLanguage"] = "Mudar idioma",
        ["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
        ["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
        ["packageSize"] = 74448896,
        ["cancelDownWord"] = "Cancel",
        ["sureDownWord"] = "Download",
        ["sureUpdateWord"] = "Atualizar o pacote de idioma %s?",
        ["chooseWord"] = "Escolher",
        ["downLanguageWord"] = "Escolha o idioma",
        ["firstCheckLanguageHint"] = "A dismatch has been detected between the current game language and your cell phone system language.",
        ["firstPhoneLanguage"] = "Phone Language:",
        ["firstGameLanguage"] = "Game Language:",
        ["firstChangeLanguage"] = "Switch Language",
        ["firstNoChangeLanguage"] = "No Switching",
        ["updateErrorHint"] = "Failed to access to update list! Please exit and check network if the failure repeats",
        ["updateErrorExit"] = "Exit",
        ["updateErrorRenew"] = "Re-update",
        ["updateText"] = "Updating  %s ",
        ["updateSuccessText"] = "Update Success!",
        ["updateDetectText"] = "Detecting resource update..."
    }
    ,
    ["id"] = {
        ["name"] = "id",
        ["searchPaths"] = { "res/language/comun", "res/language/id"},
        ["currentLanguage"] = "Bahasa saat ini:",
        ["languageText"] = "Indonesia",
        ["changeLanguage"] = "Ganti Bahasa",
        ["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
        ["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
        ["packageSize"] = 74448896,
        ["cancelDownWord"] = "Cancel",
        ["sureDownWord"] = "Download",
        ["sureUpdateWord"] = "Perbarui paket bahasa %s?",
        ["chooseWord"] = "Pilih",
        ["downLanguageWord"] = "Pilih Bahasa",
        ["firstCheckLanguageHint"] = "A dismatch has been detected between the current game language and your cell phone system language.",
        ["firstPhoneLanguage"] = "Phone Language:",
        ["firstGameLanguage"] = "Game Language:",
        ["firstChangeLanguage"] = "Switch Language",
        ["firstNoChangeLanguage"] = "No Switching",
        ["updateErrorHint"] = "Failed to access to update list! Please exit and check network if the failure repeats",
        ["updateErrorExit"] = "Exit",
        ["updateErrorRenew"] = "Re-update",
        ["updateText"] = "Updating  %s ",
        ["updateSuccessText"] = "Update Success!",
        ["updateDetectText"] = "Detecting resource update..."
    }
    ,
    ["tr"] = {
        ["name"] = "tr",
        ["searchPaths"] = { "res/language/comun", "res/language/tr"},
        ["currentLanguage"] = "Geçerli dil:",
        ["languageText"] = "Türkçe",
        ["changeLanguage"] = "Dili Değiştir",
        ["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
        ["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
        ["packageSize"] = 74448896,
        ["cancelDownWord"] = "Cancel",
        ["sureDownWord"] = "Download",
        ["sureUpdateWord"] = "%s dil paketi güncellensin mi?",
        ["chooseWord"] = "Seç",
        ["downLanguageWord"] = "Dil Seçin",
        ["firstCheckLanguageHint"] = "A dismatch has been detected between the current game language and your cell phone system language.",
        ["firstPhoneLanguage"] = "Phone Language:",
        ["firstGameLanguage"] = "Game Language:",
        ["firstChangeLanguage"] = "Switch Language",
        ["firstNoChangeLanguage"] = "No Switching",
        ["updateErrorHint"] = "Failed to access to update list! Please exit and check network if the failure repeats",
        ["updateErrorExit"] = "Exit",
        ["updateErrorRenew"] = "Re-update",
        ["updateText"] = "Updating  %s ",
        ["updateSuccessText"] = "Update Success!",
        ["updateDetectText"] = "Detecting resource update..."
    }
    ,
    ["ru"] = {
        ["name"] = "ru",
        ["searchPaths"] = { "res/language/comun", "res/language/ru"},
        ["currentLanguage"] = "Текущий язык:",
        ["languageText"] = "Русский",
        ["changeLanguage"] = "Сменить язык",
        ["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
        ["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
        ["packageSize"] = 74448896,
        ["cancelDownWord"] = "Cancel",
        ["sureDownWord"] = "Download",
        ["sureUpdateWord"] = "Обновить языковой пакет %s?",
        ["chooseWord"] = "Выбрать",
        ["downLanguageWord"] = "Выберите язык",
        ["firstCheckLanguageHint"] = "A dismatch has been detected between the current game language and your cell phone system language.",
        ["firstPhoneLanguage"] = "Phone Language:",
        ["firstGameLanguage"] = "Game Language:",
        ["firstChangeLanguage"] = "Switch Language",
        ["firstNoChangeLanguage"] = "No Switching",
        ["updateErrorHint"] = "Failed to access to update list! Please exit and check network if the failure repeats",
        ["updateErrorExit"] = "Exit",
        ["updateErrorRenew"] = "Re-update",
        ["updateText"] = "Updating  %s ",
        ["updateSuccessText"] = "Update Success!",
        ["updateDetectText"] = "Detecting resource update..."
    }
    ,
    ["fil"] = {
        ["name"] = "fil",
        ["searchPaths"] = { "res/language/comun", "res/language/fil"},
        ["currentLanguage"] = "Current Language:",
        ["languageText"] = "Filipino",
        ["changeLanguage"] = "Change Language",
        ["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
        ["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
        ["packageSize"] = 74448896,
        ["cancelDownWord"] = "Cancel",
        ["sureDownWord"] = "Download",
        ["sureUpdateWord"] = "I-update ang %s language pack?",
        ["chooseWord"] = "Pumili",
        ["downLanguageWord"] = "Choose Language",
        ["firstCheckLanguageHint"] = "A dismatch has been detected between the current game language and your cell phone system language.",
        ["firstPhoneLanguage"] = "Phone Language:",
        ["firstGameLanguage"] = "Game Language:",
        ["firstChangeLanguage"] = "Switch Language",
        ["firstNoChangeLanguage"] = "No Switching",
        ["updateErrorHint"] = "Failed to access to update list! Please exit and check network if the failure repeats",
        ["updateErrorExit"] = "Exit",
        ["updateErrorRenew"] = "Re-update",
        ["updateText"] = "Updating  %s ",
        ["updateSuccessText"] = "Update Success!",
        ["updateDetectText"] = "Detecting resource update..."
    }
    ,
	 ["zh_CN"] = {
        ["name"] = "zh_CN",
        ["searchPaths"] = { "res/language/comun", "res/language/zh_TW", "res/language/zh_CN"},
		["currentLanguage"] = "当前语言:",
		["languageText"] = "简体中文",
		["changeLanguage"] = "切换语言",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "取消下载",
		["sureDownWord"] = "确认下载",	
		["sureUpdateWord"] = "确认更新%s语言包吗？",
		["chooseWord"] = "选择",
		["downLanguageWord"] = "选择语言包",	
		["firstCheckLanguageHint"] = "检测到当前游戏语言和您的手机系统语言不匹配",		
		["firstPhoneLanguage"] = "手机语言:",		
		["firstGameLanguage"] = "游戏语言:",
		["firstChangeLanguage"] = "切换语言",
		["firstNoChangeLanguage"] = "不切换",
		["updateText"] = "正在玩命更新%s数据",
		["updateErrorHint"] = "无法访问更新列表! 如果故障再次出现，请检查网络!",
		["updateErrorExit"] = "退出",
		["updateErrorRenew"] = "重新更新",
		["updateSuccessText"] = "更新成功!",
		["updateDetectText"] = "检测资源更新中..."		
    }
    ,
	 ["zh_TW"] = {
        ["name"] = "zh_TW",
        ["searchPaths"] = { "res/language/zh_TW"},
		["currentLanguage"] = "當前語言:",
		["languageText"] = "繁體中文",
		["changeLanguage"] = "切換語言",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "取消下載",
		["sureDownWord"] = "確認下載",	
		["sureUpdateWord"] = "确认更新%s语言包吗？",
		["chooseWord"] = "選擇"	,
		["downLanguageWord"] = "選擇語言包",	
		["firstCheckLanguageHint"] = "檢測到當前遊戲語言和您的手機系統語言不匹配",		
		["firstPhoneLanguage"] = "手機語言:",		
		["firstGameLanguage"] = "遊戲語言:",
		["firstChangeLanguage"] = "切換語言",
		["firstNoChangeLanguage"] = "不切換",
		["updateErrorHint"] = "無法訪問更新列表! 如果故障再次出現,請檢查網絡!",
		["updateErrorExit"] = "退出",
		["updateErrorRenew"] = "重新更新",
		["updateText"] = "正在玩命更新%s數據",
		["updateSuccessText"] = "更新成功!",
		["updateDetectText"] = "檢測資源更新中..."				
		
    }
    ,
    ["en"] = {
        ["name"] = "en",
        ["searchPaths"] = { "res/language/en"},
		["currentLanguage"] = "Current Language:",
		["languageText"] = "English",
		["changeLanguage"] = "Change Language",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "cancel down",
		["sureDownWord"] = "sure down",	
		["sureUpdateWord"] = "Update the %s language pack?",
		["chooseWord"] = "Select"	,
		["downLanguageWord"] = "Choose Language",
		["firstCheckLanguageHint"] = "A dismatch has been detected between the current game language and your cell phone system language.",		
		["firstPhoneLanguage"] = "Phone Language:",		
		["firstGameLanguage"] = "Game Language:",
		["firstChangeLanguage"] = "Switch Language",
		["firstNoChangeLanguage"] = "No Switching",
		["updateErrorHint"] = "Failed to access to update list! Please exit and check network if the failure repeats",
		["updateErrorExit"] = "Exit",
		["updateErrorRenew"] = "Re-update",
		["updateText"] = "Updating  %s ",
		["updateSuccessText"] = "Update Success!",
		["updateDetectText"] = "Detecting resource update..."					
		
    }
    ,
    ["ko"] =  {
        [ "name" ]= "ko",
        ["searchPaths"] = { "res/language/comun", "res/language/ko"},
		["currentLanguage"] = "현재 언어:",
		["languageText"] = "한국어",
		["changeLanguage"] = "언어 전환",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "다운로드 취소",
		["sureDownWord"] = "다운로드 확인",	
		["sureUpdateWord"] = "언어 팩을 업데이트 하시겠습니까?"	,
		["chooseWord"] = "선택"  	,
		["downLanguageWord"] = "언어 팩 선택"	,	
		["firstCheckLanguageHint"] = "현재 게임 언어와 전화 시스템 언어가 일치하지 않습니다",		
		["firstPhoneLanguage"] = "전화 언어:",		
		["firstGameLanguage"] = "게임 언어:",
		["firstChangeLanguage"] = "언어 전환",
		["firstNoChangeLanguage"] = "전환하지 마십시오",
		["updateErrorHint"] = "업데이트 목록에 액세스 할 수 없습니다문제가 다시 발생하면 네트워크를 확인하십시오!",
		["updateErrorExit"] = "출구",
		["updateErrorRenew"] = "다시 업데이트",
		["updateText"] = "%s 데이터를 업데이트하려는 노력",
		["updateSuccessText"] = "업데이트 성공!",
		["updateDetectText"] = "리소스 업데이트 감지..."	
    }
    ,
    ["th"] = {
        ["name"] = "th",
        ["searchPaths"] = {"res/language/th"},
		["currentLanguage"] = "当前语言:",
		["languageText"] = "泰文",
		["changeLanguage"] = "切换语言",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "取消下载",
		["sureDownWord"] = "确认下载",	
		["sureUpdateWord"] = "确认更新%s语言包吗？"	 ,
		["chooseWord"] = "选择" 	,
		["downLanguageWord"] = "選擇語言包"	,	
		["firstCheckLanguageHint"] = "檢測到當前遊戲語言和您的手機系統語言不匹配",		
		["firstPhoneLanguage"] = "手機語言:",		
		["firstGameLanguage"] = "遊戲語言:",
		["firstChangeLanguage"] = "切換語言",
		["firstNoChangeLanguage"] = "不切換",
		["updateErrorHint"] = "无法访问更新列表! 如果故障再次出现，请检查网络!",
		["updateErrorExit"] = "退出",
		["updateErrorRenew"] = "重新更新",
		["updateText"] = "正在玩命更新%s數據",
		["updateSuccessText"] = "更新成功!",
		["updateDetectText"] = "檢測資源更新中..."		
    }
	,
    ["de"] = {
        ["name"] = "de",
        ["searchPaths"] = { "res/language/comun", "res/language/de"},
		["currentLanguage"] = "Aktuelle Sprache:",
		["languageText"] = "Deutsch",
		["changeLanguage"] = "Sprache wechseln",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "Download abbrechen",
		["sureDownWord"] = "Download bestätigen",	
		["sureUpdateWord"] = "Möchtest du wirklich das Sprachpaket %s updaten?",
		["chooseWord"] = "Wählen"	 	,
		["downLanguageWord"] = "Sprachpaket wählen"	 ,	
		["firstCheckLanguageHint"] = "Das System hat festgestellt, dass die aktuelle Spielsprache nicht mit ihrer Smartphone-Sprache übereinstimmt",		
		["firstPhoneLanguage"] = "Smartphone-Sprache:",		
		["firstGameLanguage"] = "Spielsprache:",
		["firstChangeLanguage"] = "Sprache wechseln",
		["firstNoChangeLanguage"] = "Nicht wechseln",
		["updateErrorHint"] = "Zugriff auf die Update-Liste ist nicht möglichBitte überprüfen Sie Ihr Netzwerk, wenn der Fehler erneut auftritt",
		["updateErrorExit"] = "Verlassen",
		["updateErrorRenew"] = "Erneut updaten",
		["updateText"] = "%s Daten werden upgedatet",
		["updateSuccessText"] = "Update erfolgreich!",
		["updateDetectText"] = "Überprüfungsressourcen werden geupdatet..."	
    }
	,
    ["fr"] = {
        ["name"] = "fr",
        ["searchPaths"] = { "res/language/comun", "res/language/fr"},
		["currentLanguage"] = "Langue actuelle:",
		["languageText"] = "Français",
		["changeLanguage"] = "Changer de langue",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "Annuler le téléchargement",
		["sureDownWord"] = "Confirmer le téléchargement",	
		["sureUpdateWord"] = "Confirmez-vous la mise à jour du pack de langue %s ?",
		["chooseWord"] = "Choisir"	 	,
		["downLanguageWord"] = "Sélectionnez le pack de langue",	
		["firstCheckLanguageHint"] = "Nous avons détecté que la langue de jeu actuelle ne correspond pas à celle de votre téléphone",		
		["firstPhoneLanguage"] = "Langue de téléphone:",		
		["firstGameLanguage"] = "Langue de jeu:",
		["firstChangeLanguage"] = "Changer de langue",
		["firstNoChangeLanguage"] = "Non changer",
		["updateErrorHint"] = "Impossible d'accéder à la liste de mise à jour! Si l'erreur se reproduit, vérifiez le réseau!!",
		["updateErrorExit"] = "Quitter",
		["updateErrorRenew"] = "MAJ à nouveau",
		["updateText"] = " en train de mettre à jour les données %s ",
		["updateSuccessText"] = "MAJ réussi!",
		["updateDetectText"] = "MAJ de la Détection  des ressources..."	 
    }
	,
	["es"] = {
        ["name"] = "es",
        ["searchPaths"] = { "res/language/comun", "res/language/es"},
		["currentLanguage"] = "Idioma actual:",
		["languageText"] = "Español",
		["changeLanguage"] = "Cambiar idiomas",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "Cancelar descarga",
		["sureDownWord"] = "Confirme la descarga",	
		["sureUpdateWord"] = "¿Está seguro de actualizar el paquete de idioma %s?",
		["chooseWord"] = "Elegir",
		["downLanguageWord"] = "Elija un paquete de idiomas",	
		["firstCheckLanguageHint"] = "Un desajuste entre el idioma actual del juego y el idioma de su sistema telefónico",		
		["firstPhoneLanguage"] = "Lenguaje telefónico:",		
		["firstGameLanguage"] = "Lenguaje del juego:",
		["firstChangeLanguage"] = "Cambiar idiomas",
		["firstNoChangeLanguage"] = "No cambies",
		["updateText"] = "Está intentando actualizar los datos de %s",
		["updateErrorHint"] = "¡No se puede acceder a la lista de actualizaciones! Si la falla se repite, verifique la red.",
		["updateErrorExit"] = "Salir",
		["updateErrorRenew"] = "Actualizar de nuevo",
		["updateSuccessText"] = "Actualización exitosa!",
		["updateDetectText"] = "Detectando actualización de recursos..."		
    }
    ,
	["vi"] = {
        ["name"] = "vi",
        ["searchPaths"] = { "res/language/comun", "res/language/vi"},
		["currentLanguage"] = "Ngôn ngữ:",
		["languageText"] = "Tiếng Việt",
		["changeLanguage"] = "Đổi ngôn ngữ",
		["checkVersionUrl"] = "http://181.215.236.218:18080/language/resourceVersion",
		["assetsDownloadUrl"] = "http://181.215.236.218:18080/language/%s.zip",
		["packageSize"] = 74448896,
		["cancelDownWord"] = "Hủy tải xuống",
		["sureDownWord"] = "Xác nhận tải xuống",
		["sureUpdateWord"] = "Bạn có chắc muốn cập nhật gói ngôn ngữ %s?",
		["chooseWord"] = "Chọn",
		["downLanguageWord"] = "Chọn gói ngôn ngữ",
		["firstCheckLanguageHint"] = "Ngôn ngữ của trò chơi không khớp với ngôn ngữ hệ thống của điện thoại.",
		["firstPhoneLanguage"] = "Ngôn ngữ điện thoại:",
		["firstGameLanguage"] = "Ngôn ngữ trò chơi:",
		["firstChangeLanguage"] = "Đổi ngôn ngữ",
		["firstNoChangeLanguage"] = "Không đổi",
		["updateText"] = "Đang cập nhật dữ liệu %s",
		["updateErrorHint"] = "Không thể truy cập danh sách cập nhật! Nếu lỗi lặp lại, hãy kiểm tra kết nối mạng.",
		["updateErrorExit"] = "Thoát",
		["updateErrorRenew"] = "Cập nhật lại",
		["updateSuccessText"] = "Cập nhật thành công!",
		["updateDetectText"] = "Đang kiểm tra cập nhật tài nguyên..."
    }
}
config_res.chooseLanguage = {
	{
		["name"] = "en",
		["languageText"] = "English"
	},
	{
		["name"] = "es",
		["languageText"] = "Español"
	},
	{
		["name"] = "pt_BR",
		["languageText"] = "Português (BR)"
	},
	{
		["name"] = "id",
		["languageText"] = "Bahasa Indonesia"
	},
	{
		["name"] = "fr",
		["languageText"] = "Français"
	},
	{
		["name"] = "tr",
		["languageText"] = "Türkçe"
	},
	{
		["name"] = "ru",
		["languageText"] = "Русский"
	},
	{
		["name"] = "fil",
		["languageText"] = "Filipino"
	},
	{
		["name"] = "zh_CN",
		["languageText"] = "简体中文"
	},
	{
		["name"] = "zh_TW",
		["languageText"] = "繁體中文"
	},
	{
		["name"] = "ko",
		["languageText"] = "한국어"
	},
	{
		["name"] = "de",
		["languageText"] = "Deutsch"
	},
	{
		["name"] = "vi",
		["languageText"] = "Tiếng Việt"
	},
}

config_res.silkbag_bag_offset ={
	["x"] = "-18",
	["y"] = "-18",
}