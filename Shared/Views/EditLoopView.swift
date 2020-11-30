//
//  EditLoopView.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/29/20.
//

import SwiftUI

struct EditLoopView: View {
    
    @StateObject var loop: LoopViewModel
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        NavigationView {
            Form {
                TextField("Loop name", text: $loop.name)
                Toggle("Enable", isOn: $loop.isEnabled)
                Stepper(loop.intervalString, value: $loop.interval, in: 0.25...12, step: 0.25)
            }
            .navigationTitle(loop.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if loop.unsavedChanges {
                        Button("Discard") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if loop.unsavedChanges {
                        Button("Save") {
                            loop.save()
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct EditLoopView_Previews: PreviewProvider {
    static var previews: some View {
        EditLoopView(loop: LoopViewModel.previewLoop)
    }
}
