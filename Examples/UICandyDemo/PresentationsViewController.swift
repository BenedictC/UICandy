import UIKit
import UICandy
import Combine


final class PresentationsViewController: ViewController, Presentable {
    
    // MARK: - State
    
    @Binding var message = ""
    
    
    // MARK: - View
    
    lazy var rootView = ZStack(alignment: .center) {
        VStack {
            UILabel(text: "Hiya!")
                .font(.preferredFont(forTextStyle: .headline))
            UILabel(text: $message)
        }
        .configure {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endModal)))
        }
    }
    
    
    // MARK: - Life cycle
    
    override init() {
        super.init()
        title = "\(Date())"
        
        Timer.publish(every: 0.5, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] in
                self?.message = "\($0)"
            }
            .store(in: self)
    }
    
    static var modalCount = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Self.modalCount < 2 {
            //            presentModal()
        }
        if self.presentingViewController == nil {
            // presentPopover()
            presentModal()
            //            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            //                let vc = self.presentedViewController as! PresentationsViewController
            //                vc.endPresentation(with: .success("BOOM!"), animated: true)
            //            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc
    func endModal() {
        endPresentation(with: .success("Hiya!"), animated: true)
    }
    
    func presentModal() {
        Self.modalCount += 1
        Task {
            let modal = UINavigationController(rootViewController: PresentationsViewController())
            do {
                try await self.presentModal(modal, animated: true)
                //try await self.present(modal, animated: true)
                // print("Modal completed with value: \(value)")
            } catch {
                print("Failed to retrieve value from modal")
            }
            Self.modalCount -= 1
        }
    }
    
    func presentSheet() {
        Task {
            do {
                let modal = PresentationsViewController()
                modal.view.backgroundColor = .yellow
                let value = try await self.presentSheet(modal, animated: true)
                print("Sheet completed with value: \(value)")
            } catch {
                print("Failed to retrieve value from sheet")
            }
        }
    }
    
    func presentPopover() {
        Task {
            do {
                let modal = PresentationsViewController()
                modal.view.backgroundColor = .yellow
                let value = try await self.presentPopover(modal, animated: true) { popover in
                    popover.sourceView = rootView
                }
                print("Sheet completed with value: \(value)")
            } catch {
                print("Failed to retrieve value from sheet")
            }
        }
    }
    
    func presentAlert() {
        // Configure the Alert
        @AlertText(placeholder: "Username") var username = ""
        @AlertText(placeholder: "Password") var password = ""
        let alert = AlertController(title: "Title", components: [
            .text($username),
            .text($password),
            .destructiveAction("Boom!", value: false),
            .preferred(
                .standardAction("Hiya!", value: true)
            ),
            .cancelAction("Cancel"),
        ])
        
        Task {
            do {
                let result = try await presentModal(alert, animated: true)
                print("Username: \(username ?? "")")
                switch result {
                case true:
                    print("True!")
                case false:
                    print("fALSE!")
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    
    func resultForCancelledPresentation() -> Result<String, Error> {
        return .success("Why you no love me 😭!")
    }
}
