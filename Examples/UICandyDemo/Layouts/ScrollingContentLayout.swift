import Foundation
import UIKit
import UICandy


final class ScrollingContentLayout<Content: UIView>: LayoutView {

    // MARK: Types

    typealias Content = Content

    struct Configuration: Defaultable {
        var edgePadding: CGFloat = 20
        var paddingColor: UIColor? = nil
        var avoidsKeyboard: Bool = true
        var alignment: ZStack.Alignment = .fill
    }


    // MARK: Views

    private(set) lazy var body = ScrollView {
        ZStack(alignment: configuration.alignment) {
            content
                .backgroundColor(.white)
                .padding(configuration.edgePadding)
                .backgroundColor(configuration.paddingColor)
        }
    }
        .if(configuration.avoidsKeyboard) {
            $0.avoidKeyboard()
        }
}
