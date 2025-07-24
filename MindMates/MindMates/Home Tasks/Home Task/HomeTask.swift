//
//  HomeTask.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import Foundation
import FirebaseFirestore

struct HomeTask : Identifiable, Codable {
    @DocumentID var id: String?
    var subject : String
    var teacherId : String
    var studentId : String
    var description : String
    var deadline : Date
    var status : TaskStatus = .notStarted
    var files : [String]?
    var teachersComment : String?
    
    enum CodingKeys : String, CodingKey {
        case id
        case subject
        case teacherId
        case studentId
        case description
        case deadline
        case status
        case files
        case teachersComment
    }
}

enum TaskStatus : String, Codable {
    case notStarted = "Не начато"
    case onCheck = "На проверке"
    case checked = "Проверено"
}
