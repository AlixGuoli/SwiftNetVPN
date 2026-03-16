import SwiftUI
import MessageUI

/// 用 UIViewControllerRepresentable 包装 MFMailComposeViewController，发邮件前需用 canSendMail() 判断，未配置邮箱时不要 present 以免崩溃
struct MailComposeView: UIViewControllerRepresentable {
    let to: String
    var subject: String = ""
    var body: String = ""
    var onDismiss: () -> Void = {}
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([to])
        if !subject.isEmpty { vc.setSubject(subject) }
        if !body.isEmpty { vc.setMessageBody(body, isHTML: false) }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }
    
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let onDismiss: () -> Void
        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            onDismiss()
        }
    }
}
