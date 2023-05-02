//
//  Student.swift
//  MyCreditManager
//
//  Created by 장석현 on 2023/05/02.
//

import Foundation

let GRADE_STANDARD:[String:Float] = ["A+":4.5,"A":4.0,"B+":3.5,"B":3.0,"C+":2.5,"C":2.0,"D+":1.5,"D":1.0,"F":0]

public struct Student{
    var name: String
    var gradeData: [GradeData]
    
    init(name: String) {
        self.name = name
        self.gradeData = []
    }
}

public struct GradeData:Equatable{
    let subject: String
    public var grade: [String:Float] = [:]
}
