//
//  ValidationAttemptListView.swift
//  Appgate
//
//  Created by Juan Uribe on 16/05/21.
//

import SwiftUI

struct ValidationAttemptListView: View {
    
    // MARK: - Properties
    
    var viewModel: ValidationAttemptListViewModel
    
    // MARK: - View
    
    var body: some View {
        List(viewModel.items) { item in
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .fill(item.wasSuccessful ?
                                Color.green : Color.red)
                        .fixedSize()
                    Text("Successful: \(item.wasSuccessful.description)")
                }
                Text(item.time)
                Text(item.timeZone)
                Text(item.country)
            }
        }
        .navigationBarTitle("Validation Attempts")
    }
}

struct ValidationAttemptsView_Previews: PreviewProvider {
    static var previews: some View {
        ValidationAttemptListView(viewModel: .init(validationAttempts: []))
    }
}
