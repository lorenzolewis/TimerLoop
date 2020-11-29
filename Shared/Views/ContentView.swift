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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CoreDataLoop.id, ascending: true)],
        animation: .default)
    private var loops: FetchedResults<CoreDataLoop>
    
    @State private var selectedLoop: LoopViewModel?
    
    var body: some View {
            List {
                ForEach(loops) { loop in
                    Button(action: {
                        selectedLoop = LoopViewModel(loop)
                    }) {
                        Text("Item at \(loop.id!)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .sheet(item: $selectedLoop) { loop in
                EditLoopView(loop: loop)
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    HStack {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                        #if os(iOS)
                        EditButton()
                        #endif
                        
                    }
                }
            }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = CoreDataLoop(context: viewContext)
            newItem.id = UUID()
            
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
