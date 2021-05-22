//
//  ContentView.swift
//  ReEncode
//
//  Created on 02.05.2021.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

struct ContentView: View {
    
    @State var inputFilePath: String = ""
    @State var outputFilePath: String = ""
    @State var contentBlurRadius: CGFloat = 0
    @State var inputEncodingIndex: String.Encoding = String.Encoding.utf8
    @State var outputEncodingIndex: String.Encoding = String.Encoding.windowsCP1251
    @State var loadScreenState: Bool = false
    @State var mainScreenState: Bool = true
    
    
    struct VisualEffectView: NSViewRepresentable {
        func makeNSView(context: Context) -> NSVisualEffectView {
            let view = NSVisualEffectView()
            
            view.blendingMode = .behindWindow
            view.isEmphasized = true
            
            return view
        }
        
        func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        }
    }
    
    struct listEncodings: View  {
        
        var body: some View {
            Group {
                Text("UTF-8").tag(String.Encoding.utf8)
                Text("UTF-16").tag(String.Encoding.utf16)
                Text("UTF-32").tag(String.Encoding.utf32)
                Text("Windows CP1250").tag(String.Encoding.windowsCP1250)
                Text("Windows CP1251").tag(String.Encoding.windowsCP1251)
                Text("Windows CP1252").tag(String.Encoding.windowsCP1252)
                Text("Windows CP1253").tag(String.Encoding.windowsCP1253)
                Text("Windows CP1254").tag(String.Encoding.windowsCP1254)
            }
            Group {
                Text("ISO-2022JP").tag(String.Encoding.iso2022JP)
                Text("ISO-Latin 1").tag(String.Encoding.isoLatin1)
                Text("ISO-Latin 2").tag(String.Encoding.isoLatin2)
                Text("Japanese EUC").tag(String.Encoding.japaneseEUC)
                Divider()
                Text("UTF-16 Big Endian").tag(String.Encoding.utf16BigEndian)
                Text("UTF-16 Little Endian").tag(String.Encoding.utf16LittleEndian)
                Text("UTF-32 Big Endian").tag(String.Encoding.utf32BigEndian)
                Text("UTF-32 Little Endian").tag(String.Encoding.utf32LittleEndian)
            }
            Group{
                Text("ASCII").tag(String.Encoding.ascii)
                Text("ASCII (Non-Lossy)").tag(String.Encoding.nonLossyASCII)
                Text("macOS Roman").tag(String.Encoding.macOSRoman)
                Text("NextStep").tag(String.Encoding.nextstep)
                Text("ShiftJIS").tag(String.Encoding.shiftJIS)
                Text("Symbol").tag(String.Encoding.symbol)
                Text("Unicode").tag(String.Encoding.unicode)
            }
        }
    }
    
    func convertFileRam(){
        showLoadScreen(true)
        DispatchQueue.global(qos: .background).async {
            do {
                let original = try String(contentsOf: URL(fileURLWithPath: inputFilePath), encoding: inputEncodingIndex)
                try original.write(to: URL(fileURLWithPath: outputFilePath), atomically: true, encoding: outputEncodingIndex)
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
            showLoadScreen(false)
            
        }
    }
    
    func showLoadScreen(_ show : Bool){
        if (show){
            contentBlurRadius = 100
            loadScreenState = true
            mainScreenState = false
        }
        else{
            contentBlurRadius = 0
            loadScreenState = false
            mainScreenState = true
        }
    }
    
    func showAlert(messageText : String, informativeText : String = "") {
        let alert = NSAlert.init()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButton(withTitle: "Close")
        alert.beginSheetModal(for: NSApp.keyWindow!, completionHandler: nil)
        
    }
    
    func getFromPicker(){
        let picker = NSOpenPanel()
        picker.showsHiddenFiles        = false
        picker.allowsMultipleSelection = false
        picker.canChooseDirectories    = false
        picker.canChooseFiles          = true
        picker.allowedFileTypes        = ["txt"]
        if picker.runModal() == .OK {
            inputFilePath = picker.url!.path
        }
    }
    
    func saveFromPicker(){
        let picker = NSSavePanel()
        picker.level = .modalPanel
        picker.title                    = "Choose a destination"
        picker.showsHiddenFiles         = false
        picker.canCreateDirectories     = true
        picker.allowedFileTypes        = ["txt"]
        if picker.runModal() == .OK {
            outputFilePath = picker.url!.path
        }
    }
    
    func everythingIsFilled() -> Bool{
        var errorLookup : UInt8 = 0
        if (inputFilePath.isEmpty){
            errorLookup+=1
        }
        if (outputFilePath.isEmpty) {
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
    
    var body: some View {
        
        ZStack {
            VStack{
                Spacer()
                
                VStack{
                    HStack{
                        TextField("Input File Path:", text: $inputFilePath).disabled(true)
                        Button("Choose") {
                            getFromPicker()
                        }
                    }
                    Picker(selection: $inputEncodingIndex, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        listEncodings()
                    }
                    .labelsHidden()
                    
                }.padding()
                
                VStack{
                    HStack{
                        TextField("Output File Path:", text: $outputFilePath).disabled(true)
                        Button("Choose") {
                            saveFromPicker()
                        }
                        
                    }
                    
                    Picker(selection: $outputEncodingIndex, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        listEncodings()
                    }
                    .labelsHidden()
                    
                    Button("Start Conversion") {
                        if (everythingIsFilled()){
                            convertFileRam()
                        }
                    }.padding()
                    
                }.padding()
            }.background(VisualEffectView()).blur(radius: contentBlurRadius).disabled(!mainScreenState)
            
            VStack{
                Text("Please wait…")
                    .font(.largeTitle)
                    .fontWeight(.light)
                if #available(OSX 11.0, *) {
                    Text("Conversion in Progress")
                        .font(.title3)
                        .fontWeight(.ultraLight)
                } else {
                    Text("Conversion in Progress")
                        .font(.headline)
                        .fontWeight(.ultraLight)
                }
            }.hidden(!loadScreenState)
            
        }
        
        .edgesIgnoringSafeArea([.top])
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

