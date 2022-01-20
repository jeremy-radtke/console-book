//
//  addCollection.swift
//  ConsoleBook
//
//  Created by Cha Jung Tae on 1/8/22.
//

import SwiftUI
import CoreData
struct addCollection: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var collection : [collectionList]
    @State var name = ""
    @State var colorNumber = 0
    @State var colorList : [Color] = [.red,.blue, .yellow, .gray, .mint]
    @State var error = ""
    
    
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
                Text("ADD COLLECTION").font(.custom("PressStart2P-Regular", size: 30)).padding(.bottom, 50)
                Text("NAME").font(.custom("PressStart2P-Regular", size: 30))
                TextField("Enter name of Collection", text: $name).font(.custom("PressStart2P-Regular", size: 30)).placeholder(when: name.isEmpty) {
                    Text("COLLECTION NAME").font(.custom("PressStart2P-Regular", size: 30)).foregroundColor(.gray)
                }.padding(.bottom).overlay(VStack{
                    Spacer()
                    Line().stroke(style: StrokeStyle(lineWidth: 7, dash: [20]))
                        .frame(height: 7)
                })
                HStack{
                Text("COLOR : ").font(.custom("PressStart2P-Regular", size: 30))
                    Text("\(colorList[colorNumber].description)".capitalized).font(.custom("PressStart2P-Regular", size: 30)).foregroundColor(colorList[colorNumber])
                    Spacer()
                }
                HStack(alignment: .top,spacing: 30){
                    ForEach(colorList.indices, id: \.self){ i in
                        VStack{
                            Button(action: {
                                colorNumber = i
                            }){
                        Circle().frame(width: 70, height: 70).foregroundColor(colorList[i])
                            }
                        if(i == colorNumber){
                            Image(systemName: "arrow.up").font(.largeTitle.bold())
                        }
                        }
                    }
                }
                if(!error.isEmpty){
                    Text(error).font(.custom("PressStart2P-Regular", size: 20)).foregroundColor(.red).padding()
                }
                Spacer()
                HStack{
                    Spacer()
                    VStack(spacing: 40){
                        Button(action: {
                            if(name.isEmpty){
                                withAnimation{
                                error = "Please enter a name"
                                }
                            }
                            else{
                                    let newItem = Item(context: viewContext)
                                    newItem.name = []
                                    newItem.information = []
                                    newItem.image = []
                                    newItem.collection = name
                                    newItem.collectionColor = colorList[colorNumber].description
                                    do{
                                        try viewContext.save()
                                    }
                                    catch{
                                        print(error.localizedDescription)
                                    }
                            collection.append(collectionList(name: name, color: colorList[colorNumber]))
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

struct addCollection_Previews: PreviewProvider {
    static var previews: some View {
        addCollection(collection: .constant([collectionList(name: "", color: .clear)]))
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
