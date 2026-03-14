import Foundation

/// 多语言文案（en / zh-Hans），通过 bundle 支持 App 内切换语言
struct L10n {
    
    let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func string(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: key, table: "Localizable")
    }
    
    // MARK: - 设置
    var settingsTitle: String { string("settings_title") }
    var settingsSectionGeneral: String { string("settings_section_general") }
    var settingsGeneral: String { string("settings_general") }
    var settingsLanguage: String { string("settings_language") }
    
    // MARK: - 语言页
    var languageTitle: String { string("language_title") }
    var languageEnglish: String { string("language_english") }
    var languageChinese: String { string("language_chinese") }
    
    // MARK: - 主页
    var mainAppName: String { string("main_app_name") }
    var mainStatusIdle: String { string("main_status_idle") }
    var mainStatusDialing: String { string("main_status_dialing") }
    var mainStatusOnline: String { string("main_status_online") }
    var mainStatusError: String { string("main_status_error") }
    var mainBtnConnect: String { string("main_btn_connect") }
    var mainBtnConnecting: String { string("main_btn_connecting") }
    var mainBtnDisconnect: String { string("main_btn_disconnect") }
    var mainCurrentLine: String { string("main_current_line") }
    var mainHintIdle: String { string("main_hint_idle") }
    var mainHintDialing: String { string("main_hint_dialing") }
    var mainHintOnline: String { string("main_hint_online") }
    var lineAuto: String { string("line_auto") }
    
    // MARK: - 隐私
    var privacyTitle: String { string("privacy_title") }
    var privacyBody: String { string("privacy_body") }
    var privacyAgree: String { string("privacy_agree") }
    var privacyDecline: String { string("privacy_decline") }
    
    // MARK: - 启动页
    var splashAppName: String { string("splash_app_name") }
    var splashTagline: String { string("splash_tagline") }
    
    // MARK: - 连接中
    var dialTitle: String { string("dial_title") }
    var dialSubtitle: String { string("dial_subtitle") }
    
    // MARK: - 结果页
    var outcomeBack: String { string("outcome_back") }
    var outcomeTitleSuccess: String { string("outcome_title_success") }
    var outcomeTitleDropped: String { string("outcome_title_dropped") }
    var outcomeTitleFailure: String { string("outcome_title_failure") }
    var outcomeDetailSuccess: String { string("outcome_detail_success") }
    var outcomeDetailDropped: String { string("outcome_detail_dropped") }
    var outcomeDetailFailure: String { string("outcome_detail_failure") }
    
    // MARK: - 断开确认
    var terminateTitle: String { string("terminate_title") }
    var terminateMessage: String { string("terminate_message") }
    var terminateCancel: String { string("terminate_cancel") }
    var terminateConfirm: String { string("terminate_confirm") }
    
    // MARK: - 无网络
    var nonetworkTitle: String { string("nonetwork_title") }
    var nonetworkMessage: String { string("nonetwork_message") }
    var commonOk: String { string("common_ok") }
    
    // MARK: - 节点
    var nodesTitle: String { string("nodes_title") }
}
