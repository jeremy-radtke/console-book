//
//  collectionView.swift
//  ConsoleBook
//
//  Created by Cha Jung Tae on 1/8/22.
//

import SwiftUI

struct collectionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var name : String
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var edit = false
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("<- Back").font(.custom("PressStart2P-Regular", size: 20))
                }
                Spacer()
                Button(action: {
                    withAnimation{
                        edit.toggle()
                    }
                }){
                    Text((edit) ?"DONE" : "EDIT").font(.custom("PressStart2P-Regular", size: 20)).foregroundColor(.red)
                    
                }
            }.padding(.horizontal).padding(.bottom)
            Text("MY \(name) COLLECTIONS").font(.custom("PressStart2P-Regular", size: 40)).padding(.vertical).multilineTextAlignment(.center)
            ScrollView(.horizontal){
                HStack(spacing: 100){
                    VStack{
                        Text("")
                    }
                    ForEach(items , id: \.self){ item in
                        if(item.collection == name){
                            if(!(item.name?.isEmpty ?? [].isEmpty)){
                                ForEach(item.name?.indices ?? [].indices, id: \.self){ i in
                            VStack{
                        Spacer()
                        VStack{
                            Spacer().frame(height: UIScreen.main.bounds.height * 0.04)
                            Image(uiImage: item.image?[i].imageFromBase64 ?? UIImage(named: "example")!).resizable().scaledToFill().frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.2).background(Color.black).overlay(RoundedRectangle(cornerRadius: 20).stroke(style: StrokeStyle(lineWidth: 10, dash: [25]))).clipped().cornerRadius(20)
                            VStack(alignment: .leading){
                                HStack{
                                    Text("\(item.name?[i] ?? "")").font(.custom("PressStart2P-Regular", size: 40)).padding(.vertical)
                                    Spacer()
                                }
                                
                                Text("Description").font(.custom("PressStart2P-Regular", size: 20))
                                HStack{
                                    
                                    Text("\(item.information?[i] ?? "")").font(.custom("PressStart2P-Regular", size: 15)).padding(.vertical)
                                }
                            }.padding(.horizontal, 30)
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.6).overlay(RoundedRectangle(cornerRadius: 30).stroke(style: StrokeStyle(lineWidth: 10, dash: [30]))).overlay(VStack{
                            HStack{
                                Spacer()
                                if(edit){
                                Button(action: {
                                    for s in items{
                                        if(s.collection == name){
                                            for ii in item.name?.indices ?? [].indices{
                                                if(item.name![i] == s.name![ii]){
                                                    s.name?.remove(at: ii)
                                                    s.image?.remove(at: ii)
                                                    s.information?.remove(at: ii)
                                                }
                                            }
                                        }
                                    }
                                }){
                                Text("X").font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.width / 15)).shadow(color: .yellow, radius: 20).padding(.vertical).foregroundColor(.red)
                                }
                                }
                            }
                            Spacer()
                        })
                        Spacer()
                            }
                                }
                            }
                        }
                    }
                }
            }
            NavigationLink(destination: addGame(collection: name).navigationBarHidden(true)){
                Text("New Game").font(.custom("PressStart2P-Regular", size: 20)).foregroundColor(.green)
            }
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color.black).foregroundColor(.white)
    }
}

struct collectionView_Previews: PreviewProvider {
    static var previews: some View {
        collectionView(name: "")
    }
}
