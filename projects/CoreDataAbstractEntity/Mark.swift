//
//  Mark.swift
//  CoreDataAbstractEntity
//
//  Created by kunguma-14252 on 08/03/24.
//

import CoreData

class Mark: BaseDoc {
    static func changeMark(context: NSManagedObjectContext) {
        let fetch: NSFetchRequest<Mark> = Mark.fetchRequest()
        fetch.predicate = NSPredicate(format: "rId == %@","\(2)")
        let mark = try? context.fetch(fetch).first
        mark?.english = Int32.random(in: 1...1000)
        mark?.tamil = Int32.random(in: 1...1000)
        try? context.save()
    }
}
