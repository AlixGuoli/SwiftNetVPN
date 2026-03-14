import Foundation
import SwiftUI
import Combine

/// App 内语言切换：持久化当前语言，提供对应 Bundle 供 L10n 使用
final class AppLanguageManager: ObservableObject {
    
    static let shared = AppLanguageManager()
    
    private let key = "sn_app_language"
    
    /// 当前语言代码（"en" / "zh-Hans"）
    @Published var currentLanguageCode: String {
        didSet {
            UserDefaults.standard.set(currentLanguageCode, forKey: key)
        }
    }
    
    /// 当前语言对应的 Localizable Bundle
    var currentBundle: Bundle {
        guard let path = Bundle.main.path(forResource: currentLanguageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main
        }
        return bundle
    }
    
    private init() {
        let saved = UserDefaults.standard.string(forKey: key)
        if let saved, (saved == "en" || saved == "zh-Hans") {
            currentLanguageCode = saved
        } else {
            let system = Locale.current.language.languageCode?.identifier ?? "en"
            currentLanguageCode = (system == "zh") ? "zh-Hans" : "en"
        }
    }
    
    func setLanguage(_ code: String) {
        guard code == "en" || code == "zh-Hans" else { return }
        currentLanguageCode = code
    }
}
