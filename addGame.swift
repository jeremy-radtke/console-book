//
//  addGame.swift
//  ConsoleBook
//
//  Created by Cha Jung Tae on 1/8/22.
//

import SwiftUI

struct addGame: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var collection : String
    @State var name = ""
    @State var error = ""
    @State var information = ""
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    @State var image = UIImage(named: "example")
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        VStack{
            Spacer()
            VStack(alignment: .leading,spacing: 30){
                Spacer()
                Text("ADD GAME").font(.custom("PressStart2P-Regular", size: 30)).padding(.bottom, 20)
                ScrollView{
                    VStack(alignment: .leading, spacing: 50){
                        Image(uiImage: image ?? UIImage(named: "example")!).resizable().scaledToFill().frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.3).overlay(RoundedRectangle(cornerRadius: 20).stroke()).onTapGesture { self.shouldPresentActionScheet = true }.cornerRadius(20).clipped()
                .sheet(isPresented: $shouldPresentImagePicker) {
                    SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your pet profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = true
                    }), ActionSheet.Button.default(Text("Photo Library"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = false
                    }), ActionSheet.Button.cancel()])
                }
                        VStack(alignment: .leading){
                Text("NAME").font(.custom("PressStart2P-Regular", size: 30))
                TextField("Enter name of Collection", text: $name).font(.custom("PressStart2P-Regular", size: 30)).placeholder(when: name.isEmpty) {
                    Text("GAME NAME").font(.custom("PressStart2P-Regular", size: 30)).foregroundColor(.gray)
                }.padding(.bottom).overlay(VStack{
                    Spacer()
                    Line().stroke(style: StrokeStyle(lineWidth: 7, dash: [20]))
                        .frame(height: 7)
                })
                        }
                VStack(alignment: .leading){
                    Text("DESCRIPTION").font(.custom("PressStart2P-Regular", size: 30))
                    TextEditor(text: $information).font(.custom("PressStart2P-Regular", size: 30)).foregroundColor(.white).onAppear{
                        UITextView.appearance().backgroundColor = .clear
                    }.padding().overlay(RoundedRectangle(cornerRadius: 30).stroke(style: StrokeStyle(lineWidth: 7, dash: [20]))).frame(height: UIScreen.main.bounds.height * 0.4).padding(.vertical)
                }
                    }
                
                    }
                
                Spacer()
                if(!error.isEmpty){
                    Text(error).font(.custom("PressStart2P-Regular", size: 20)).foregroundColor(.red).padding()
                }
                HStack{
                    Spacer()
                    VStack(spacing: 40){
                        Button(action: {
                            if(name.isEmpty){
                                withAnimation{
                                error = "Please enter a name"
                                }
                            }
                            else if(information.isEmpty){
                                error = "Please enter a description"
                            }
                            else{
                                for item in items{
                                    if(item.collection == collection){
                                    
                                        item.name?.append(name)
                                        item.information?.append(information)
                                        let imageData = image?.base64
                                        item.image?.append(imageData ?? "")
                                    do{
                                        try viewContext.save()
                                    }
                                    catch{
                                        print(error.localizedDescription)
                                    }
                                    }
                                }
                            presentationMode.wrappedValue.dismiss()
                            }
                        }){
                        Text("ADD").font(.custom("PressStart2P-Regular", size: 30)).foregroundColor(.mint)
                        }
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }){
                        Text("DISCARD").font(.custom("PressStart2P-Regular", size: 30)).foregroundColor(.red)
                        }
                }
                    Spacer()
                }
            }.frame(width: UIScreen.main.bounds.width * 0.7)
            
            
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color.black).foregroundColor(.white)
    }
}
struct addGame_Previews: PreviewProvider {
    static var previews: some View {
        addGame(collection: "")
    }
}
extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 0.8)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
