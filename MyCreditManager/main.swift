//
//  main.swift
//  MyCreditManager
//
//  Created by 장석현 on 2023/04/26.
//

import Foundation

let INPUT_ADD_STUDENT = "1"
let INPUT_DELETE_STUDENT = "2"
let INPUT_ADD_GRADE = "3"
let INPUT_DELETE_GRADE = "4"
let INPUT_VIEW_RATINGS = "5"
let INPUT_EXIT = "X"

var students: [Student] = []

main();

func main(){
    //var inputValue : String? = nil
    
    repeat {
        
        print("원하는 기능을 입력해주세요");
        print("\(INPUT_ADD_STUDENT): 학생추가, \(INPUT_DELETE_STUDENT): 학생삭제, \(INPUT_ADD_GRADE): 성적추가(변경), \(INPUT_DELETE_GRADE): 성적삭제, \(INPUT_VIEW_RATINGS): 평점보기, \(INPUT_EXIT): 종료");
        //기능 선택 입력 값 받기
        let input = readLine()
        //기능 선택 및 실행
        SelectMenu(to: input)
        
    } while true
}

func SelectMenu(to input: String?){
    switch input{
    case INPUT_ADD_STUDENT:
        TryAddStudent()
        break
    case INPUT_DELETE_STUDENT:
        TryDeleteStudent()
        break
    case INPUT_ADD_GRADE:
        TryAddGrade()
        break
    case INPUT_DELETE_GRADE:
        TryDeleteGrade()
        break
    case INPUT_VIEW_RATINGS:
        TryViewRatings()
        break
    case INPUT_EXIT:
        exit(0)
        break
    default:
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
        break
    }
}

func GetStudentIndexWithName(to name: String)->Int?{
    return students.firstIndex(where: {$0.name == name})
}

func GetSubjectWithName(to index: Int,to subject: String)->Int?{
    return students[index].gradeData.firstIndex(where: {$0.subject == subject})
}

func CheckInputValue() -> String?{
    let inputValue = readLine();
    
    if(inputValue == ""){
        print("입력이 잘못되었습니다. 다시 확인해주세요")
        return nil
    }
    
    return inputValue
}

func TryAddStudent(){
    
    print("추가할 학생의 이름을 입력해주세요")
    
    let inputValue = CheckInputValue()
    if let index = GetStudentIndexWithName(to: inputValue!){
        print("\(students[index].name)은 이미 존재하는 학생입니다. 추가하지 않습니다.");
    }else{AddStudent(to: inputValue!)}
}

func AddStudent(to input: String){
    students.append(Student(name: input))
    print("\(input) 학생을 추가했습니다.")
}


func TryDeleteStudent(){
    print("삭제할 학생의 이름을 입력해주세요")
    
    let inputValue = CheckInputValue()
    if let index = GetStudentIndexWithName(to: inputValue!){
        DeleteStudent(to: index)
    }else{print("\(inputValue!) 학생을 찾지 못했습니다.")}
}

func DeleteStudent(to index: Int){
    print("\(students[index].name) 학생을 삭제하였습니다.");
    students.remove(at: index)
}

func TryAddGrade(){
    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    print("입력예) Mickey Swift A+")
    print("만약에 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        
    let inputValue = CheckInputValue()
    let components = inputValue!.split(separator: " ").map{return String($0)}
    
    let name = components[0]
    let subject = components[1]
    let grade = components[2]
    
    let newGradeData = GradeData(subject: subject, grade: [grade:GRADE_STANDARD[grade]!])
        
    if components.count > 2 && components.count < 4{
        if let index = GetStudentIndexWithName(to: name){
            if let subIndex = GetSubjectWithName(to: index, to: subject){
                ModifyGradeData(to: index, to:subIndex, to: newGradeData)}
            else{AddGradeData(to: index, to: newGradeData)}
            print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
        }else{print("\(inputValue!) 학생을 찾지 못했습니다.")}
    }else{print("입력이 잘못되었습니다. 다시 확인해주세요")}
    
}

func ModifyGradeData(to studentIndex:Int,to gradeDataIndex:Int, to new:GradeData){
    students[studentIndex].gradeData[gradeDataIndex] = new
}
func AddGradeData(to studentIndex:Int,to gradeData:GradeData){
    students[studentIndex].gradeData.append(gradeData)
}


func TryDeleteGrade(){
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    print("입력예) Mickey Swift")
    
    let inputValue = CheckInputValue()
    let components = inputValue!.split(separator: " ").map{return String($0)}
        
    let name = components[0]
    let subject = components[1]
    
    if components.count > 1 && components.count < 3{
        if let index = students.firstIndex(where: {$0.name == components[0]}){
            if let subIndex = students[index].gradeData.firstIndex(where: {$0.subject == components[1]}){
                students[index].gradeData.remove(at: subIndex)
                print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
            }else{print("\(name) 학생의 \(subject) 과목이 존재하지 않습니다.")}
        }else{print("\(inputValue!) 학생을 찾지 못했습니다.")}
    }
}


func TryViewRatings(){
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    
    let inputValue = CheckInputValue()
    
    if let index = GetStudentIndexWithName(to: inputValue!){
        let grades = students[index].gradeData
        ViewRatings(to: grades)
    }else{print("\(inputValue!) 학생을 찾지 못했습니다.")}
}

func ViewRatings(to grades:[GradeData]){
    var sum: Float = 0
    for grade in grades{
        print("\(grade.subject): \(grade.grade.first!.key)")
        sum = sum + grade.grade.first!.value
    }
    
    let avg = sum/Float(grades.count)
    let result = String(format: "%.2f", avg)
    print("평점 : \(result)")
}

