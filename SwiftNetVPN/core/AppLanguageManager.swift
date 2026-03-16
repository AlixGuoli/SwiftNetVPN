import Foundation
import SwiftUI
import Combine

/// App 内语言切换：持久化当前语言，提供对应 Bundle 供 L10n 使用
final class AppLanguageManager: ObservableObject {
    
    static let shared = AppLanguageManager()
    
    private let key = "sn_app_language"
    
    /// 当前语言代码（en / ru / es / de / fr）
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
        let supported = ["en", "ru", "es", "de", "fr"]
        
        if let saved, supported.contains(saved) {
            currentLanguageCode = saved
        } else {
            let system = Locale.current.language.languageCode?.identifier ?? "en"
            if supported.contains(system) {
                currentLanguageCode = system
            } else {
                currentLanguageCode = "en"
            }
        }
    }
    
    func setLanguage(_ code: String) {
        let supported = ["en", "ru", "es", "de", "fr"]
        guard supported.contains(code) else { return }
        currentLanguageCode = code
    }
}
