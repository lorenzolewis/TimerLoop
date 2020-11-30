//
//  ContentView.swift
//  Shared
//
//  Created by Lorenzo Lewis on 11/28/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var loops: FetchedResults<CoreDataLoop>
    
    @State private var selectedLoop: LoopViewModel?
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(loops) { loop in
                    ZStack(alignment: .leading) {
                        Color.clear // Allows content shape to fill space
                        LoopListCellView(loop: LoopViewModel(loop))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLoop = LoopViewModel(loop)
                    }
                }
                .onDelete(perform: deleteItems)
                if loops.count == 0 {
                    Button(action: {
                        selectedLoop = LoopViewModel(context: viewContext)
                    }, label: {
                        Text("Create a new loop")
                    })
                }
            }
            .sheet(item: $selectedLoop) { loop in
                EditLoopView(loop: loop)
            }
            .navigationTitle("TimerLoop")
            .toolbar {
                Button(action: {
                    selectedLoop = LoopViewModel(context: viewContext)
                }) {
                    Label("Add Loop", systemImage: "plus")
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { loops[$0] }.forEach(viewContext.delete)
            
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
