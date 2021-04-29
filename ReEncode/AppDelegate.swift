//
//  AppDelegate.swift
//  ReEncode
//
//  Created by WinterBoard on 27.04.2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBAction func buttonFileChooserOnClick(_ sender: Any) {
        let inputPath = getFromPicker()
        textFieldInputPath.stringValue = inputPath?.path ?? ""
        
    }
    
    @IBAction func buttonOutputChooserOnClick(_ sender: Any) {
        let outputPath = saveFromPicker()
        textFieldOutputPath.stringValue = outputPath?.path ?? ""
    }
    
    @IBOutlet weak var textFieldOutputPath: NSTextField!
    @IBOutlet weak var textFieldInputPath: NSTextField!
    @IBOutlet weak var popUpInputEncoding: NSPopUpButton!
    @IBOutlet weak var popUpOutputEncoding: NSPopUpButton!
    @IBOutlet weak var buttonFileChooser: NSButton!
    
    
    func convertFileRam(inputpath : URL, inputEncoding : Int, outputpath : URL, outputEncoding : Int){
        func inputEncodeType() -> String.Encoding?{
        switch inputEncoding {
        case 0:
            return String.Encoding.utf8
        case 1:
            return String.Encoding.windowsCP1253
        case 2:
            return String.Encoding.windowsCP1251
        default:
            return nil
        }
        }
        func outputEncodeType() -> String.Encoding?{
        switch outputEncoding {
        case 0:
            return String.Encoding.windowsCP1253
        case 1:
            return String.Encoding.utf8
        case 2:
            return String.Encoding.windowsCP1251
        default:
            return nil
        }
        }
        do {
            let original = try String(contentsOf: inputpath, encoding: inputEncodeType()!)
            try original.write(to: outputpath, atomically: true, encoding: outputEncodeType()!)
            print(original)
            print("Converted from: \(inputEncodeType()) to \(outputEncodeType()) [Input: \(inputpath)] [Output: \(outputpath))")
        }
        catch {
           print(error)
        }
        

    }
    
    
    func getFromPicker() -> URL?{
                    let picker = NSOpenPanel()
                    picker.showsHiddenFiles        = false
                    picker.allowsMultipleSelection = false
                    picker.canChooseDirectories    = false
                    picker.canChooseFiles          = true
                    picker.allowedFileTypes        = ["txt"]
                    picker.runModal()
                   /* if (filePicker.runModal() ==  NSApplication.ModalResponse.OK) {
                        let result = filePicker.url
                        
                        if (result != nil) {
                            
                        }
                        
                    } else {
                        // User clicked on "Close" button.
                        return
                    }
 */
        
        return picker.url
    }
    
    func saveFromPicker() -> URL?{
        let picker = NSSavePanel()
            picker.level = .modalPanel
            picker.title                    = "Choose a destination"
            picker.showsHiddenFiles         = false
            picker.canCreateDirectories     = true
        picker.allowedFileTypes        = ["txt"]

            picker.runModal()

        return picker.url

    }
    
    func everythingIsFilled() -> Bool {
        var errorLookup : UInt8 = 0
        if (textFieldInputPath.stringValue.isEmpty){
            errorLookup+=1
        }
        if (textFieldOutputPath.stringValue.isEmpty) {
            errorLookup+=2
        }
        switch errorLookup {
        case 1:
            print("No Data in Input TextEdit")
        case 2:
            print("No Data in Output TextEdit")
        case 3:
            print("No Data in all TextFields")
        default:
            print("Everything is fine")
            return true
        }
        return false
    }
    
    @IBAction func buttonStartConversion(_ sender: Any) {
        if(everythingIsFilled()){
            let input = URL(fileURLWithPath: textFieldInputPath.stringValue)
            let output = URL(fileURLWithPath: textFieldOutputPath.stringValue)
            convertFileRam(inputpath: input, inputEncoding: popUpInputEncoding.indexOfSelectedItem, outputpath: output, outputEncoding: popUpOutputEncoding.indexOfSelectedItem)
            print(input,output)
        }

    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
      print(URL(fileURLWithPath: "/Users/winterboard/Desktop/realcorussian.txt"))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        //  let str = String(UTF8String: strToDecode.cStringUsingEncoding(NSUTF8StringEncoding))
          
         // let myStringText = try! String(contentsOfFile: "/Applications/russian.txt", encoding: String.Encoding.windowsCP1251)
          
          
         // let fileUrl = URL(fileURLWithPath: "/Users/winterboard/Desktop/realcorussian.txt")

          
           
          
         // print(myStringText)
    }


}

