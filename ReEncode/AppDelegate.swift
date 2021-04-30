//
//  AppDelegate.swift
//  ReEncode
//
//  Created on 27.04.2021.
//

import Cocoa

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}


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
    
    @IBAction func itemAboutOnClick(_ sender: Any) {
        showAlert(messageText: "ReEncode v\(Bundle.main.releaseVersionNumber)", informativeText: "This application is distributed for free use.\nReEncode uses container mode (sandboxing), so some functionality such as manual path entry is not available.\nThe author of the application is not responsible for anything.\nIf you find bugs - feel free to report me.\n\nSource Code: github.com/TechUnRestricted/ReEncode")
    }
    
    @IBOutlet weak var textFieldOutputPath: NSTextField!
    @IBOutlet weak var viewProgressContent: NSView!
    @IBOutlet weak var viewMainContent: NSView!
    @IBOutlet weak var textFieldInputPath: NSTextField!
    @IBOutlet weak var popUpInputEncoding: NSPopUpButton!
    @IBOutlet weak var popUpOutputEncoding: NSPopUpButton!
    @IBOutlet weak var buttonFileChooser: NSButton!
  
    var workItem : DispatchWorkItem!
    
    @IBOutlet weak var window: NSWindow!
    func showAlert(messageText : String, informativeText : String = "") {
        let alert = NSAlert.init()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButton(withTitle: "Close")
        alert.beginSheetModal(for: window)
    }
    
    func showProgressView(_ show : Bool){
        
        DispatchQueue.main.async { [self] in
            if (show){
                viewMainContent.isHidden = true
                viewProgressContent.isHidden = false
            }
            else{
                viewMainContent.isHidden = false
                viewProgressContent.isHidden = true
            }
        }
    }
    
    func convertFileRam(inputpath : URL, inputEncoding : Int, outputpath : URL, outputEncoding : Int){
        func encodeType(_ id : UInt8) -> String.Encoding?{
            switch (id == 0 ? inputEncoding : outputEncoding) {
            case 0:
                return String.Encoding.utf8
            case 1:
                return String.Encoding.utf16
            case 2:
                return String.Encoding.utf32
            case 3:
                return String.Encoding.windowsCP1250
            case 4:
                return String.Encoding.windowsCP1251
            case 5:
                return String.Encoding.windowsCP1252
            case 6:
                return String.Encoding.windowsCP1253
            case 7:
                return String.Encoding.windowsCP1254
            case 8:
                return String.Encoding.iso2022JP
            case 9:
                return String.Encoding.isoLatin1
            case 10:
                return String.Encoding.isoLatin2
            case 11:
                return String.Encoding.japaneseEUC
            case 13:
                return String.Encoding.ascii
            case 14:
                return String.Encoding.nonLossyASCII
            case 15:
                return String.Encoding.macOSRoman
            case 16:
                return String.Encoding.nextstep
            case 17:
                return String.Encoding.shiftJIS
            case 18:
                return String.Encoding.symbol
            case 19:
                return String.Encoding.unicode
            case 20:
                return String.Encoding.utf16BigEndian
            case 21:
                return String.Encoding.utf16LittleEndian
            case 22:
                return String.Encoding.utf32BigEndian
            case 23:
                return String.Encoding.utf32LittleEndian
            default:
                return nil
            }
        }
        workItem = DispatchWorkItem { [self] in
            do {
                showProgressView(true)
                let original = try String(contentsOf: inputpath, encoding: encodeType(0)!)
                try original.write(to: outputpath, atomically: true, encoding: encodeType(1)!)
            }
            
            catch let error as NSError{
                DispatchQueue.main.async {
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
                    }
                    
                }
                print("[ERROR: Encoding] \(error)")
            }
            showProgressView(false)
        }
        DispatchQueue.global().async(execute: workItem)
        
    }
    
    
    func getFromPicker() -> URL?{
        let picker = NSOpenPanel()
        picker.showsHiddenFiles        = false
        picker.allowsMultipleSelection = false
        picker.canChooseDirectories    = false
        picker.canChooseFiles          = true
        picker.allowedFileTypes        = ["txt"]
        picker.runModal()
        
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
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
         return true
    }
    
    
}

