//
//  Student.swift
//  CoreDataAbstractEntity
//
//  Created by kunguma-14252 on 08/03/24.
//

import CoreData
import Foundation

class Student: BaseDoc {
    static func create(context: NSManagedObjectContext) {
        for id in 1...10 {
            let student: Student = {
                if let student = Student.get(context: context, rId: "\(id)") {
                    return student
                }
                return Student(context: context)
            }()
            student.rId = "\(id)"
            student.author = "You"
            student.grade = "\(id)-Grade"
            student.name = "Kungu_\(id)"
            student.sec = id % 2 == 0 ? "A" : "B"
            student.remoteMode = Bool.random()
            let mark = Mark(context: context)
            mark.rId = "\(id)"
            mark.english = Int32.random(in: (1...100))
            mark.tamil = Int32.random(in: (1...100))
            mark.student = student
            student.mark = mark
        }
        try? context.save()
    }

    static func get(context: NSManagedObjectContext, rId: String) -> Student? {
        let fetch: NSFetchRequest<Student> = Student.fetchRequest()
        fetch.predicate = NSPredicate(format: "rId == %@", rId)
        let student = try? context.fetch(fetch).first
        return student
    }

    static func updateINbaseClass(context: NSManagedObjectContext) {
        let fetch: NSFetchRequest<Student> = Student.fetchRequest()
        let student = try? context.fetch(fetch).first
        student?.name = Student.randomAlphanumericString(5)
        try? context.save()
    }
}

extension Student {
    static func randomAlphanumericString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var random = SystemRandomNumberGenerator()
        var randomString = ""
        for _ in 0..<length {
            let randomIndex = Int(random.next(upperBound: len))
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
}
