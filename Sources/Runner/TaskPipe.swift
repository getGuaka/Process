//
//  TaskPipe.swift
//  TaskPipe
//
//  Created by Omar Abdelhafith on 05/11/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//


protocol TaskIO {
    func read() throws -> String
}

struct DryIO: TaskIO {
    
    let stringToReturn: String
    
    func read() -> String {
        return stringToReturn
    }
}
