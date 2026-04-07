import Foundation
import UIKit
import UICandy
import Combine


class DemoFlowController: FlowController {

    lazy var containerViewController = UITabBarController {
        UINavigationController {
            FormViewController()
        }.configure { $0.tabBarItem.title = "Form" }
        UINavigationController {
            PresentationsViewController()
        }.configure { $0.tabBarItem.title = "Modal" }
        UINavigationController {
            CollectionViewController()
        }.configure { $0.tabBarItem.title = "Collection" }
//        UINavigationController {
//            StorageCaptureViewController()
//        }.configure { $0.tabBarItem.title = "Storage" }
    }
}


class StorageCaptureViewController: ViewController {

    let publisher = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .map { Int($0.timeIntervalSince1970) }

    private var block: (() -> Void)?

    private(set) lazy var rootView = withStorage { label1, label2 in
        HStack {
            UILabel(text: "Foo")
                .store(in: label1)
            UILabel(text: "Arf")
            UILabel(text: "Bar")
                .store(in: label2)
        }.configure { _ in
            self.block = {
                print(label1.boxed.text ?? "")
                print(label2.boxed.text ?? "")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        block?()
    }
}



class OneOfViewController: ViewController {

    let publisher = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .map { Int($0.timeIntervalSince1970) }

    private(set) lazy var rootView = OneOf(for: publisher) {
        Component(for: { $0 % 5 == 0 }) {
            UILabel(text: "By 5")
                .backgroundColor(.purple)
        }
        Component(for: { $0 % 4 == 0 }) {
            UILabel(text: "By 4")
                .backgroundColor(.green)
        }
        Component(for: { $0 % 3 == 0 }) {
            UILabel(text: "By 3")
                .backgroundColor(.brown)
        }
        Component<Int>.default {
            UILabel(text: $0.map { "\($0)" })
                .backgroundColor(.lightGray)
        }
    }
}
