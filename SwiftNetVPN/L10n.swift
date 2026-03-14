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
    var settingsSectionInfo: String { string("settings_section_info") }
    var settingsAbout: String { string("settings_about") }
    var settingsGuide: String { string("settings_guide") }
    var settingsPrivacy: String { string("settings_privacy") }
    var settingsTerms: String { string("settings_terms") }
    var settingsContact: String { string("settings_contact") }
    var settingsSectionTools: String { string("settings_section_tools") }
    var settingsToolsEntry: String { string("settings_tools_entry") }
    
    // MARK: - 语言页
    var languageTitle: String { string("language_title") }
    var languageEnglish: String { string("language_english") }
    var languageChinese: String { string("language_chinese") }
    
    // MARK: - 主页
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
    
    // MARK: - 首次启动同意页
    var consentTitle: String { string("consent_title") }
    var consentIntro: String { string("consent_intro") }
    var consentSectionLabel: String { string("consent_section_label") }
    var consentCardIdHeading: String { string("consent_card_id_heading") }
    var consentCardIdBody: String { string("consent_card_id_body") }
    var consentCardNetworkHeading: String { string("consent_card_network_heading") }
    var consentCardNetworkBody: String { string("consent_card_network_body") }
    var consentCardUsageHeading: String { string("consent_card_usage_heading") }
    var consentCardUsageBody: String { string("consent_card_usage_body") }
    var consentCardExternalHeading: String { string("consent_card_external_heading") }
    var consentCardExternalBody: String { string("consent_card_external_body") }
    var consentMoreTerms: String { string("consent_more_terms") }
    var consentMoreLink: String { string("consent_more_link") }
    var consentConfirmHint: String { string("consent_confirm_hint") }
    var consentAcceptBtn: String { string("consent_accept_btn") }
    var consentRejectBtn: String { string("consent_reject_btn") }
    
    // MARK: - 启动页
    var splashTagline: String { string("splash_tagline") }
    func splashVersion(_ version: String) -> String { String(format: string("splash_version"), version) }
    
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
    
    // MARK: - 工具箱
    var toolsTitle: String { string("tools_title") }
    var toolIPTitle: String { string("tool_ip_title") }
    var toolIPLoading: String { string("tool_ip_loading") }
    var toolIPDesc: String { string("tool_ip_desc") }
    var toolIPCopy: String { string("tool_ip_copy") }
    var toolPingTitle: String { string("tool_ping_title") }
    var toolPingTesting: String { string("tool_ping_testing") }
    var toolPingStart: String { string("tool_ping_start") }
    var toolPingAgain: String { string("tool_ping_again") }
    var toolPingHint: String { string("tool_ping_hint") }
    var toolDNSTitle: String { string("tool_dns_title") }
    var toolDNSDesc: String { string("tool_dns_desc") }
    var toolDNSOpen: String { string("tool_dns_open") }
    var toolSpeedTitle: String { string("tool_speed_title") }
    var toolSpeedDesc: String { string("tool_speed_desc") }
    var toolSpeedStart: String { string("tool_speed_start") }
    var toolSpeedTesting: String { string("tool_speed_testing") }
    var toolSpeedDownload: String { string("tool_speed_download") }
    var toolSpeedUpload: String { string("tool_speed_upload") }
    var toolSpeedLatency: String { string("tool_speed_latency") }
    var toolSpeedAgain: String { string("tool_speed_again") }
    var toolSpeedComing: String { string("tool_speed_coming") }
    var toolTipsTitle: String { string("tool_tips_title") }
    var toolIPTips: String { string("tool_ip_tips") }
    var toolIPRetry: String { string("tool_ip_retry") }
    var toolPingTips: String { string("tool_ping_tips") }
    var toolDNSTips: String { string("tool_dns_tips") }
    var toolSpeedTips: String { string("tool_speed_tips") }
    var toolRandomTitle: String { string("tool_random_title") }
    var toolRandomDesc: String { string("tool_random_desc") }
    var toolRandomMin: String { string("tool_random_min") }
    var toolRandomMax: String { string("tool_random_max") }
    var toolRandomGenerate: String { string("tool_random_generate") }
    var toolRandomResult: String { string("tool_random_result") }
    var toolPasswordTitle: String { string("tool_password_title") }
    var toolPasswordDesc: String { string("tool_password_desc") }
    var toolPasswordLength: String { string("tool_password_length") }
    var toolPasswordSymbols: String { string("tool_password_symbols") }
    var toolPasswordGenerate: String { string("tool_password_generate") }
    var toolPasswordCopy: String { string("tool_password_copy") }
    var toolPasswordCopied: String { string("tool_password_copied") }
    var toolPasswordTips: String { string("tool_password_tips") }
    
    // MARK: - 信息页
    var aboutTitle: String { string("about_title") }
    var aboutVersion: String { string("about_version") }
    var aboutIntro: String { string("about_intro") }
    var aboutWebsite: String { string("about_website") }
    var guideTitle: String { string("guide_title") }
    var guideContent: String { string("guide_content") }
    var privacyPolicyTitle: String { string("privacy_policy_title") }
    var privacyPolicyContent: String { string("privacy_policy_content") }
    var privacyViewOnline: String { string("privacy_view_online") }
    var termsTitle: String { string("terms_title") }
    var termsContent: String { string("terms_content") }
    var termsViewOnline: String { string("terms_view_online") }
    var contactTitle: String { string("contact_title") }
    var contactContent: String { string("contact_content") }
    var contactSendEmail: String { string("contact_send_email") }
    var contactNoMailClient: String { string("contact_no_mail_client") }
    var contactEmailCopied: String { string("contact_email_copied") }
}
