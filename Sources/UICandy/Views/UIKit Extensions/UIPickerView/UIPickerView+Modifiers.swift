import UIKit


public extension SomeView where Self: UIPickerView {

    func delegate(_ value: UIPickerViewDelegate) -> Self {
        self.delegate = value
        return self
    }

    func dataSource(_ value: UIPickerViewDataSource) -> Self {
        self.dataSource = value
        return self
    }

}
