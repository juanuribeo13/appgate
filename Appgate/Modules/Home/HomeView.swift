//
//  HomeView.swift
//  Appgate
//
//  Created by Juan Uribe on 15/05/21.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: HomeViewModel
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $viewModel.username)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $viewModel.password)
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                Section {
                    Button("Create account") {
                        hideKeyboard()
                        viewModel.createAccount()
                    }
                    Button("Validate account") {
                        hideKeyboard()
                        viewModel.validateAccount()
                    }
                }
                .disabled(!viewModel.isValid)
            }
            .navigationBarTitle("Appgate")
            .alert(item: $viewModel.alert) { alert in
                Alert(title: Text(alert.title),
                      message: Text(alert.message),
                      dismissButton: .default(
                        Text(alert.dismissText),
                        action: {
                            alert.dismissAction?()
                        }))
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
