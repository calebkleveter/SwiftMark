//
//  PythonToSwift.swift
//  SwiftMark
//
//  Created by Caleb Kleveter on 3/29/17.
//
//

import Foundation

func runScript(fromUser user: String, withPath path: String) -> String? {
    
    let scriptPath: String = "/Users/\(user)/\(path)"
    
    let arguments = [scriptPath]
    
    let outPipe = Pipe()
    let errPipe = Pipe();
    
    let task = Process()
    task.launchPath = "/usr/bin/python"
    task.arguments = arguments
    task.standardInput = Pipe()
    task.standardOutput = outPipe
    task.standardError = errPipe
    task.launch()
    
    let data = outPipe.fileHandleForReading.readDataToEndOfFile()
    task.waitUntilExit()
    
    let exitCode = task.terminationStatus
    if (exitCode != 0) {
        print("ERROR: \(exitCode)")
        return nil
    }
    
    return String(data: data, encoding: String.Encoding.ascii)
}
