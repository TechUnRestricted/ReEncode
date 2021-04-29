//
//  AppDelegate.swift
//  ReEncode
//
//  Created  on 27.04.2021.
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
    
    @IBOutlet weak var window: NSWindow!
    func showAlert(messageText : String, informativeText : String = "") {
        let alert = NSAlert.init()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButton(withTitle: "Close")
        alert.beginSheetModal(for: window)

        
    }
    
    func convertFileRam(inputpath : URL, inputEncoding : Int, outputpath : URL, outputEncoding : Int){
        func encodeType(_ id : UInt8) -> String.Encoding?{
        switch (id == 0 ? inputEncoding : outputEncoding) {
        case 0:
            return String.Encoding.utf8
        case 1:
            return String.Encoding.windowsCP1251
        case 2:
            return String.Encoding.windowsCP1253
        default:
            return nil
        }
        }
        
        do {
            let original = try String(contentsOf: inputpath, encoding: encodeType(0)!)
            try original.write(to: outputpath, atomically: true, encoding: encodeType(1)!)
            print(original)
            print("Converted from: \(encodeType(0)) to \(encodeType(1)) [Input: \(inputpath)] [Output: \(outputpath))")
        }
       
        catch let error as NSError{
            switch error.code {
            case 4:
                showAlert(messageText: error.localizedDescription, informativeText: "Try to select the folder again. Perhaps, it was moved / deleted / renamed.")
            case 260:
                showAlert(messageText: error.localizedDescription, informativeText: "Try to select the file again. Perhaps, it was moved / deleted / renamed.")
            case 261, 517:
                showAlert(messageText: error.localizedDescription, informativeText: "Change the Encoding Settings.")

            case 642:
                showAlert(messageText: error.localizedDescription, informativeText: "Change the Output Directory.")
            default:
                showAlert(messageText: error.localizedDescription, informativeText: "Warning: This error is unknown.\nPlease report it to the developer.\n[ERR:CODE] > \(error.code)")

                break
            }
            print("[ERROR: Encoding] \(error)")
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
            showAlert(messageText: "The Input File was not selected.", informativeText: "Press the «Choose» button and select the Original File.")
            print("No Data in Input TextEdit")
        case 2:
            showAlert(messageText: "The Output Directory was not selected.", informativeText: "Press the «Choose» button and change the Output Directory.")
            print("No Data in Output TextEdit")
        case 3:
            showAlert(messageText: "Nothing is chosen.", informativeText: "Press the «Choose» buttons and select the Original File and the Output Directory.")
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
        window?.isMovableByWindowBackground = true

   }

    func applicationWillTerminate(_ aNotification: Notification) {
       
    }


}

