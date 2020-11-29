//
//  LoopListCellView.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/29/20.
//

import SwiftUI

struct LoopListCellView: View {
    
    var loop: LoopViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(loop.displayName)
            Text(loop.intervalString)
        }
    }
}

struct LoopListCellView_Previews: PreviewProvider {
    static var previews: some View {
        LoopListCellView(loop: LoopViewModel.previewLoop)
            .previewLayout(.sizeThatFits)
    }
}
