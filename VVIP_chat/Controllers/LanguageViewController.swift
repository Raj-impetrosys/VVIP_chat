//
//  LanguageViewController.swift
//  VVIP_chat
//
//  Created by mac on 19/08/21.
//

import UIKit

class LanguageViewController: UIViewController {
    @IBOutlet weak var chinese: UILabel!
    @IBOutlet weak var english: UILabel!
    
    let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chinese.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chineseTapped)))
        english.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(englishTapped)))
    }
    
    @objc func chineseTapped(){
        print("chinese")
        //        UserDefaults.standard.set(["zh"], forKey: "AppleLanguages")
        //        UserDefaults.standard.synchronize()
        Bundle.set(language: .chinese(.simplified))
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if #available(iOS 13, *) {
            keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        } else {
            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
    
    @objc func englishTapped(){
        print("english")
        //        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        //        UserDefaults.standard.synchronize()
        Bundle.set(language: .english(.us))
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if #available(iOS 13, *) {
            keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        } else {
            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

import UIKit

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()
    
    static func set(language: Language) {
        Bundle.once
        
        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight
        
        UserDefaults.standard.set(isLanguageRTL,   forKey: "AppleTe  zxtDirection")
        UserDefaults.standard.set(isLanguageRTL,   forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            print("Failed to get a bundle path.")
            return
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

enum Language: Equatable {
    case english(English)
    case chinese(Chinese)
    case korean
    case japanese
    
    enum English {
        case us
        case uk
        case australian
        case canadian
        case indian
    }
    
    enum Chinese {
        case simplified
        case traditional
        case hongKong
    }
}

extension Language {
    
    var code: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "en"
            case .uk:                return "en-GB"
            case .australian:        return "en-AU"
            case .canadian:          return "en-CA"
            case .indian:            return "en-IN"
            }
            
        case .chinese(let chinese):
            switch chinese {
            case .simplified:       return "zh-Hans"
            case .traditional:      return "zh-Hant"
            case .hongKong:         return "zh-HK"
            }
            
        case .korean:               return "ko"
        case .japanese:             return "ja"
        }
    }
    
    var name: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "English"
            case .uk:                return "English (UK)"
            case .australian:        return "English (Australia)"
            case .canadian:          return "English (Canada)"
            case .indian:            return "English (India)"
            }
            
        case .chinese(let chinese):
            switch chinese {
            case .simplified:       return "简体中文"
            case .traditional:      return "繁體中文"
            case .hongKong:         return "繁體中文 (香港)"
            }
            
        case .korean:               return "한국어"
        case .japanese:             return "日本語"
        }
    }
}

extension Language {
    
    init?(languageCode: String?) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
        case "en", "en-US":     self = .english(.us)
        case "en-GB":           self = .english(.uk)
        case "en-AU":           self = .english(.australian)
        case "en-CA":           self = .english(.canadian)
        case "en-IN":           self = .english(.indian)
            
        case "zh-Hans":         self = .chinese(.simplified)
        case "zh-Hant":         self = .chinese(.traditional)
        case "zh-HK":           self = .chinese(.hongKong)
            
        case "ko":              self = .korean
        case "ja":              self = .japanese
        default:                return nil
        }
    }
}
