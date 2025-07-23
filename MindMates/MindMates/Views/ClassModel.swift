//
//  ClassModel.swift
//  MindMates
//
//  Created by BATIK on 23.07.2025.
//


import Foundation
//import FirebaseFirestoreSwift

struct ClassModel: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var teacherId: String
    var studentId: String?
    var description: String
    var date: Date
    var status: ClassStatus = .upcoming
    var materials: [String]?
    var teacherComment: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case teacherId
        case studentId
        case description
        case date
        case status
        case materials
        case teacherComment
    }
}

enum ClassStatus: String, Codable {
    case upcoming = "Предстоящее"
    case completed = "Завершено"
    case canceled = "Отменено"
}
