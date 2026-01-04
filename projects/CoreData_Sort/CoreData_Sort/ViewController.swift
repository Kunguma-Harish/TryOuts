//
//  ViewController.swift
//  CoreData_Sort
//
//  Created by kunguma-14252 on 07/03/24.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBAction func actionOne(_ sender: NSButton) {
        try? self.fetchedResultsController.performFetch()
        self.collectionView.reloadData()
    }
    @IBAction func actionTwo(_ sender: NSButton) {
        self.updateId()
    }
    @IBAction func actionThree(_ sender: NSButton) {
        self.update()
    }
    @IBAction func actionFour(_ sender: NSButton) {
        self.updateProgress()
    }

    let minimumItemSpacing = 24.0
    let edgeInset =  NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

    private var fetchedResultControllerUpdates: [FetchedResultControllerUpdate] = []
    private(set) lazy var fetchedResultsController: NSFetchedResultsController<First> = {
        let fetchRequest = First.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(
                key: "id",
                ascending: true,
                selector: nil
            )
        ]
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        let moc = appDelegate!.persistentContainer.viewContext
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? self.fetchedResultsController.performFetch()
        self.collectionView.register(CollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.fetchedResultsController.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.addData()
        }
        // Do any additional setup after loading the view.
    }

    func addData() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let moc = appDelegate.persistentContainer.viewContext
        moc.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        for i in 1...10 {
            let first: First = { 
                if let doc =  self.getFirst(id: i.description) {
                    return doc
                }
                return First(context: moc)
            }()
            first.id = i.description
            if let sec = self.getSec(id: i.description) {
                sec.id = i.description
                sec.name = "Kungu_\(i)"
                first.second = sec
                sec.first = first
            } else {
                let sec = Second(context: moc)
                sec.id = i.description
                sec.name = "Kungu_\(i)"
                if let third = self.getThird(id: i.description) {
                    third.id = i.description
                    third.progress = 100
                    sec.third = third
                    third.second = sec
                } else {
                    let thir = Third(context: moc)
                    thir.id = i.description
                    thir.progress = 100
                    thir.second = sec
                    sec.third = thir
                }
            }
        }
        do {
            try moc.save()
        } catch let error  {
            print("Kungu Error ",error)
        }
    }

    func update() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let moc = appDelegate.persistentContainer.viewContext
        moc.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        let first = self.getFirst(id: 3.description)
        first?.second?.name = "ab"
        do {
            try moc.save()
        } catch let error  {
            print("Kungu Error ",error)
        }
    }

    func updateId() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let moc = appDelegate.persistentContainer.viewContext
        moc.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        let first = self.getFirst(id: 3.description)
        first?.id = "67"
        do {
            try moc.save()
        } catch let error  {
            print("Kungu Error ",error)
        }
    }

    func updateProgress() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let moc = appDelegate.persistentContainer.viewContext
        moc.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        let first = self.getFirst(id: 4.description)
        first?.second?.third?.progress = 54
        do {
            try moc.save()
        } catch let error  {
            print("Kungu Error ",error)
        }
    }

    func getFirst(id: String) -> First? {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return nil }
        let moc = appDelegate.persistentContainer.viewContext
        
        let req = First.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id)
        return try? moc.fetch(req).first
    }

    func getSec(id: String) -> Second? {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return nil }
        let moc = appDelegate.persistentContainer.viewContext
        
        let req = Second.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id)
        return try? moc.fetch(req).first
    }

    func getThird(id: String) -> Third? {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return nil }
        let moc = appDelegate.persistentContainer.viewContext
        
        let req = Third.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id)
        return try? moc.fetch(req).first
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
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
        var la1 = "unknown"
        var la2 = "unknown"
        var la3 = 0
        if let id = fetchedObject.id {
            la1 = id
        }
        if let sec = fetchedObject.second {
            if let name = sec.name {
                la2 = name
            }
            if let thir = sec.third {
               let prog = thir.progress
                la3 = Int(prog)
            }
        }
        item.configure(
            label1: la1,
            label2: la2,
            label3: la3
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
