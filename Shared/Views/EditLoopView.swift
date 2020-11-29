//
//  EditLoopView.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/29/20.
//

import SwiftUI

struct EditLoopView: View {
    
    @StateObject var loop: LoopViewModel
    
    var body: some View {
        Form {
            TextField("Title", text: $loop.name)
            Toggle("Is Enabled", isOn: $loop.isEnabled)
            Stepper(loop.intervalString, value: $loop.interval, in: 0.25...12, step: 0.25)
        }
    }
}

struct EditLoopView_Previews: PreviewProvider {
    static var previews: some View {
        EditLoopView(loop: LoopViewModel.previewLoop)
    }
}
