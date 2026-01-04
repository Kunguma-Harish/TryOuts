//
//  ViewController.swift
//  CoreDataAbstractEntity
//
//  Created by kunguma-14252 on 08/03/24.
//

import Cocoa

class ViewController: NSViewController {

    private var moc: NSManagedObjectContext! {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        let moc = appDelegate!.persistentContainer.viewContext
        return moc
    }

    @IBOutlet weak var collectionView: NSCollectionView!
    
    @IBAction func reload(_ sender: NSButton) {
    }
    @IBAction func sort1(_ sender: NSButton) {
    }
    @IBAction func sort2(_ sender: NSButton) {
    }
    @IBAction func sort3(_ sender: NSButton) {
        Student.updateINbaseClass(context: self.moc)
    }
    @IBAction func update(_ sender: NSButton) {
        Mark.changeMark(context: self.moc)
    }
    @IBAction func update2(_ sender: NSButton) {
        Student.create(context: self.moc)
    }

    let minimumItemSpacing = 24.0
    let edgeInset =  NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

    private var fetchedResultControllerUpdates: [FetchedResultControllerUpdate] = []
    private(set) lazy var fetchedResultsController: NSFetchedResultsController<Student> = {
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(
                key: #keyPath(Student.name),
                ascending: false,
                selector: nil
            )
        ]
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(CollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.fetchedResultsController.delegate = self
        try? self.fetchedResultsController.performFetch()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

class CollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var label1: NSTextField!
    @IBOutlet weak var label2: NSTextField!
    @IBOutlet weak var label3: NSTextField!
    
    func configure(label1: String, label2: String, label3: Int) {
        self.label1.stringValue = label1
        self.label2.stringValue = label2
        self.label3.stringValue = label3.description
    }
}



extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let indexPath else {
                return
            }
            self.fetchedResultControllerUpdates.append(.update(at: indexPath))

        case .insert:
            guard let newIndexPath else {
                return
            }
            self.fetchedResultControllerUpdates.append(.insert(at: newIndexPath))

        case .delete:
            guard let indexPath else {
                return
            }
            self.fetchedResultControllerUpdates.append(.delete(at: indexPath))

        case .move:
            guard let indexPath,
                  let newIndexPath
            else {
                return
            }
            self.fetchedResultControllerUpdates.append(.delete(at: indexPath))
            self.fetchedResultControllerUpdates.append(.insert(at: newIndexPath))

        @unknown default:
            break
        }
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.performBatchUpdates {
            self.fetchedResultControllerUpdates.forEach { update in
                switch update {
                case let .insert(indexPath):
                    self.collectionView.insertItems(at: [indexPath])
                case let .delete(indexPath):
                    self.collectionView.deleteItems(at: [indexPath])
                case let .update(indexPath):
                    self.collectionView.reloadItems(at: [indexPath])
                case let .move(at, to):
                    self.collectionView.moveItem(at: at, to: to)
                }
            }
            self.fetchedResultControllerUpdates.removeAll()
        } completionHandler: { _ in
        }
    }
}


extension ViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: NSCollectionView,
        layout _: NSCollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> NSSize {
        self.getSize()
    }

    func collectionView(
        _: NSCollectionView,
        layout _: NSCollectionViewLayout,
        minimumLineSpacingForSectionAt _: Int
    ) -> CGFloat {
        self.minimumItemSpacing
    }

    func collectionView(
        _: NSCollectionView,
        layout _: NSCollectionViewLayout,
        minimumInteritemSpacingForSectionAt _: Int
    ) -> CGFloat {
        self.minimumItemSpacing
    }

    func collectionView(
        _: NSCollectionView,
        layout _: NSCollectionViewLayout,
        insetForSectionAt _: Int
    ) -> NSEdgeInsets {
        self.edgeInset
    }
}
extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        self.fetchedResultsController.fetchedObjects!.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"), for: indexPath) as? CollectionViewItem else {
            return NSCollectionViewItem()
        }
        let fetchedObject = self.fetchedResultsController.object(at: indexPath)
        item.configure(
            label1: fetchedObject.name!,
            label2: fetchedObject.sec!,
            label3: Int(fetchedObject.mark!.tamil)
        )
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let selectedIndex = indexPaths.first,
              let _ = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"), for: selectedIndex) as? CollectionViewItem else {
            return
        }
        print("Kungu : Collection Did select \(selectedIndex)")
    }
}
extension ViewController {
    func getSize(isNumberOfItemReduced: Bool = false, isNumberOfItemIncreased: Bool = false) -> NSSize {
        let collectionViewWidth = self.collectionView.frame.width
        let interItemSpace = self.minimumItemSpacing
        let insets = self.edgeInset.left * 2
        let minWidth = 120.0
        let maxWidth = 306.0
        
        var numberOfItemPerRow: Int = max(Int(collectionViewWidth / maxWidth), 1)
        if isNumberOfItemReduced {
            numberOfItemPerRow = max((numberOfItemPerRow - 1), 1)
        }else if isNumberOfItemIncreased {
            numberOfItemPerRow += 1
        }
        
        let availableWidth = collectionViewWidth - insets - (Double((numberOfItemPerRow - 1)) * interItemSpace)
        let widthPerItem = floor(availableWidth / Double(numberOfItemPerRow))
        let height = widthPerItem * (9/16)
        
        if widthPerItem < minWidth {
            return self.getSize(isNumberOfItemReduced: true)
        }else if widthPerItem > maxWidth {
            return self.getSize(isNumberOfItemIncreased: true)
        }
        return NSSize(width: widthPerItem, height: height)
    }
}

enum FetchedResultControllerUpdate {
    case insert(at: IndexPath)
    case delete(at: IndexPath)
    // swiftlint:disable:next enum_case_associated_values_count
    case move(at: IndexPath, to: IndexPath)
    case update(at: IndexPath)
}

enum FetchedResultControllerSectionsUpdate {
    case insert(at: Int)
    case delete(at: Int)
    case update(at: Int)
}
