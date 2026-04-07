import UIKit
import UICandy
import Combine


class CollectionViewController: ViewController {
    
    // MARK: Types
    
    struct Item: Hashable {
        let section: String
        let value: Int
    }
    
    private final class DemoCell<Value>: CollectionViewCell, ReusableViewConfigurable {
        
        let body = UILabel()
            .textColor(.green)
        
        func configure(using value: Value) {
            body.text = "\(value)"
        }
    }
    
    
    // MARK: Properties
    
    @CollectionViewDataSource var items: NSDiffableDataSourceSnapshot<String, Item>
    
    lazy var rootView = UICollectionView(dataSource: $items, delegate: self) {
        ListLayout(
            appearance: .grouped,
            sectionsWithCollapsableHeader: {
                Section(
                    header: Cell<Item> { cell, item in
                        var configuration = cell.defaultContentConfiguration()
                        configuration.text = "\(item.value)"
                        cell.contentConfiguration = configuration
                        let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .automatic)
                        cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
                    },
                    cell: Cell<Item> { cell, item in
                        var configuration = cell.defaultContentConfiguration()
                        configuration.text = "\(item.value)"
                        cell.contentConfiguration = configuration
                    }
                )
            }
        )
    }
    
    //    lazy var rootView = UICollectionView(dataSource: $items, delegate: self) {
    //        CompositeLayout {
    //            LayoutHeader { _ in
    //                UILabel()
    //                    .font(.largeTitle)
    //                    .text("Hiya!")
    //            }
    //            LayoutFooter { _ in
    //                UILabel()
    //                    .font(.largeTitle)
    //                    .text("Bye-ya!")
    //            }
    //            LayoutBackground {
    //                UIView()
    //                    .backgroundColor(.systemMint)
    //            }
    //            // Section Foo has a different background
    //            Section {
    //                Header<String> { cell, value in
    //                    var config = cell.defaultContentConfiguration()
    //                    config.text = "Header: " + value
    //                    cell.contentConfiguration = config
    //                }
    //                Footer<String> { cell, value in
    //                    var config = cell.defaultContentConfiguration()
    //                    config.text = "Footer: " + value
    //                    cell.contentConfiguration = config
    //                }
    //                Background {
    //                    UIView()
    //                        .backgroundColor(.brown)
    //                }
    //
    //                HGroup<Item> {
    //                    Cell<Item> { cell, value in
    //                        var config = UIListContentConfiguration.subtitleCell()
    //                        config.text = "A: \(value)"
    //                        cell.contentConfiguration = config
    //                    }
    //                    .supplementaries {
    //                        Supplement<Item>(
    //                            size: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3)),
    //                            containerAnchor: .init(edges: [.top, .trailing]),
    //                            itemAnchor: .init(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.5, y: -0.5)),
    //                            body: { publisher in
    //                                UILabel()
    //                                    .textAlignment(.center)
    //                                    .assign(to: \.text, from: publisher.map { "\($0.value)" })
    //                                    .backgroundColor(.systemPink)
    //                            })
    //                    }
    //
    //                    CustomGroup<Item>(
    //                        cell: Cell<Item> { cell, value in
    //                        var config = UIListContentConfiguration.subtitleCell()
    //                        config.text = "B: \(value)"
    //                        cell.contentConfiguration = config
    //                    },
    //                        itemProvider: { environment in
    //                            let width = environment.container.contentSize.width * 0.6
    //                            let height = environment.container.contentSize.height * 0.6
    //                            let rect1 = CGRect(x: 0, y: 0, width: width, height: height)
    //                            let rect2 = CGRect(
    //                                x: environment.container.contentSize.width - width,
    //                                y: environment.container.contentSize.height - height,
    //                                width: width,
    //                                height: height)
    //                            return [
    //                                NSCollectionLayoutGroupCustomItem(frame: rect1),
    //                                NSCollectionLayoutGroupCustomItem(frame: rect2)
    //                            ]
    //                        }
    //                    )
    //
    //                    Cell<Item> { cell, value in
    //                        var config = cell.defaultContentConfiguration()
    //                        config.text = "C: \(value)"
    //                        cell.contentConfiguration = config
    //                    }
    //                }
    //            }
    //        }
    //    }
}


// MARK: - View life cycle

extension CollectionViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // beginGrowingSnapshot()
        createExpandableSnapshot()
        //         createMultiSectionSnapshot()
    }
}


// MARK: - Actions

private extension CollectionViewController {
    
    func createMultiSectionSnapshot() {
        var fresh = items
        let sections = ["Foo", "Bar", "Arf"]
        fresh.appendSections(sections)
        for section in sections {
            let items = (0..<10)
                .map { Item(section: section, value: $0) }
            fresh.appendItems(items, toSection: section)
        }
        items = fresh
    }
    
    func createExpandableSnapshot() {
        for sectionIndex in 1..<10 {
            let sectionIdentifier = "\(sectionIndex)"
            // 1
            // Create a section snapshot
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            // 2
            // Create a header ListItem & append as parent
            let rootItem = Item(section: sectionIdentifier, value: sectionIndex)
            sectionSnapshot.append([rootItem])
            
            // 3
            // Create an array of symbol ListItem & append as child of headerListItem
            let items = Array(0..<10)
                .map {  $0 + (sectionIndex * 10) }
                .map { Item(section: sectionIdentifier, value: $0) }
            sectionSnapshot.append(items, to: rootItem)
            
            // 4
            // Expand this section by default
            sectionSnapshot.collapse([rootItem])
            
            // 5
            $items.dataSource?.apply(sectionSnapshot, to: sectionIdentifier, animatingDifferences: false)
        }
    }
    
    func beginGrowingSnapshot() {
        var fresh = items
        fresh.appendSections(["Foo"])
        items = fresh
        
        Timer.publish(every: 2, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink {
                var fresh = self.items
                let value = Item(section: "Foo", value: Int($0.timeIntervalSince1970))
                if fresh.itemIdentifiers.contains(value) {
                    print("🤪 Skipping duplicate item.")
                    return
                }
                if let other = fresh.itemIdentifiers.randomElement() {
                    fresh.insertItems([value], afterItem: other)
                }else {
                    fresh.appendItems([value], toSection: "Foo")
                }
                self.items = fresh
            }
            .store(in: self)
    }
}


// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
}
