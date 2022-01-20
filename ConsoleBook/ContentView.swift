//
//  ContentView.swift
//  ConsoleBook
//
//  Created by Cha Jung Tae on 1/8/22.
//

import SwiftUI
import CoreData
class collectionList : Identifiable{
    
    let name : String
    let color : Color
    init(name: String, color : Color){
        self.name = name
        self.color = color
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var edit = false
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Item>
    var background: some View{
        VStack{
            Image("loading").resizable().scaledToFill()
        }.ignoresSafeArea(.all).frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 1).background(Color.black.opacity(0.3)).overlay(VStack{}.ignoresSafeArea(.all).frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 1).background(Color.black.opacity(0.5)))
    }
    @State var collection : [collectionList] = [collectionList(name: "NINTENDO", color: .red), collectionList(name: "MAGNAVOX", color: .gray)]
    let colorList : [Color] = [.red,.blue, .yellow, .gray, .mint]
    func getColor(colorName : String) -> Color{
        for i in colorList{
            if(i.description.capitalized == colorName.capitalized){
                return i
            }
        }
        return .red
    }
    var list : some View{
        VStack{
            if(!items.isEmpty){
                ForEach(items.indices, id: \.self){ i in
                    VStack{
                            HStack{
                                Spacer()
                                NavigationLink(destination: collectionView(name: items[i].collection ?? "").navigationBarHidden(true)){
                                HStack{
                                    Image(systemName: "gamecontroller").resizable().scaledToFit().frame(width: UIScreen.main.bounds.width / 12).font(.title.bold()).padding(.trailing)
                                    Text("\(items[i].collection ?? "no name")".capitalized).font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.width / 30)).shadow(color: .white, radius: 20)
                                }.padding(.vertical).foregroundColor(getColor(colorName: items[i].collectionColor ?? "red")).frame(width: UIScreen.main.bounds.width * 0.6).overlay(RoundedRectangle(cornerRadius: 30).stroke(style: StrokeStyle(lineWidth: 7, dash: [15])).foregroundColor(getColor(colorName: items[i].collectionColor ?? "red"))
                                )
                            }.padding(.vertical)
                                if(edit){
                                Button(action: {
                                    withAnimation{
                                        viewContext.delete(items[i])
                                        do {
                                            try viewContext.save()
                                        } catch {
                                            // Replace this implementation with code to handle the error appropriately.
                                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                            let nsError = error as NSError
                                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                        }
                                    }
                                }){
                                    Image(systemName: "xmark.circle").font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.height / 20).bold()).foregroundColor(.red)
                                }
                                }
                                Spacer()
                            }
                        
                    
                    }
                }
            }
            
            
            NavigationLink(destination : addCollection(collection: $collection).navigationBarHidden(true)){
                HStack{
                    Image(systemName: "plus").resizable().scaledToFit().frame(width: UIScreen.main.bounds.width / 30).font(.title.bold()).padding(.trailing)
                    Text("ADD CONSOLE").font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.width / 30)).shadow(color: .white, radius: 20)
                }.padding(.vertical).foregroundColor(.white.opacity(0.8)).frame(width: UIScreen.main.bounds.width * 0.6).padding(.vertical)
            }
            Button(action: {
                withAnimation{
                    edit.toggle()
                }
            }){
                HStack{
                    
                    Text((edit) ? "Done" : "EDIT COLLECTION").font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.width / 30)).shadow(color: .white, radius: 20)
                }.padding(.vertical).foregroundColor(.white.opacity(0.8)).frame(width: UIScreen.main.bounds.width * 0.6).padding(.vertical)
            }
            Button(action: {
                withAnimation{
                    page = 0
                }
            }){
                HStack{
                    Text("BACK").font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.width / 30)).shadow(color: .white, radius: 20)
                }.padding(.vertical).foregroundColor(.white.opacity(0.8)).frame(width: UIScreen.main.bounds.width * 0.6).padding(.vertical)
            }
        }
    }
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var x : CGFloat = 1
    @State var page = 0
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    var body: some View {
        NavigationView{
            ZStack{
                
                if(page == 0){
                    background
                }
                
                VStack{
                    Spacer()
                    Text("INGOS VIDEO GAME").font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.width / 20)).shadow(color: .yellow, radius: 20).padding(.vertical)
                    Text((page == 0) ? "COLLECTION" : "CONSOLES").font(.custom("PressStart2P-Regular", size: UIScreen.main.bounds.width / 20)).shadow(color: .yellow, radius: 20).padding(.vertical).padding(.bottom)
                    Spacer()
                    HStack{
                        Spacer()
                    }
                    
                    if(page == 0){
                        Button(action:{
                            withAnimation{
                                page = 1
                            }
                        }){
                            Text("PRESS HERE TO START").font(.custom("PressStart2P-Regular", size: (UIScreen.main.bounds.width / 40))).tracking(5).shadow(color: .yellow, radius: 20).padding(.vertical).foregroundColor(.red).padding(.bottom).scaleEffect(x)
                        }
                    }
                    else{
                        ScrollView{
                            list
                        }
                    }
                    Spacer()
                    
                }.foregroundColor(.white).onReceive(timer){ input in
                    withAnimation(.easeInOut(duration: 1)){
                        if(x == 1){
                            x = 1.05
                        }
                        else{
                            x = 1
                        }
                        
                    }
                }.background((page != 0) ? .black: .clear)
                
            }
        }.navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
