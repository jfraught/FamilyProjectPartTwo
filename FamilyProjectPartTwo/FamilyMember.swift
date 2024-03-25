//
//  FamilyMember.swift
//  FamilyProjectPartTwo
//
//  Created by Jordan Fraughton on 3/24/24.
//

import Foundation
import UIKit

struct FamilyMember: Equatable {
    var name: String
    var birthday: Date?
    var bio: String?
    var photo: UIImage?

    static var myFamily: [FamilyMember] {
        return [
            FamilyMember(name: "Jordan", birthday: getDate(from: "11-26-1994"), bio: "I'm the dad", photo: .jordan),
            FamilyMember(name: "Julianna", birthday: getDate(from: "10-06-1997"), bio: "I'm the mom", photo: .julianna),
            FamilyMember(name: "Allie", birthday: getDate(from: "06-06-2019"), bio: "I'm the daughter", photo: .allie),
            FamilyMember(name: "William", birthday: getDate(from: "10-16-2023"), bio: "I'm the son", photo: .will)
        ]
    }

    private static func getDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"

        return formatter.date(from: dateString)
    }

    static func ==(rhs: FamilyMember, lhs: FamilyMember) -> Bool {
        rhs.name == lhs.name
    }
}
