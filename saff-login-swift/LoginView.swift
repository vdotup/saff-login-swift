//
//  LoginView.swift
//  saff-login-swift
//
//  Created by 7up ‘ on 07/03/1444 AH.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    
    @ObservedObject private var viewModel = ViewModel.shared
    
    var body: some View {
        VStack(spacing: 24) {
            Image("Logo")
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Username")
                TextField("", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 30))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 30))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            Button(action: viewModel.login) {
                Text("Credentials Login")
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .padding()
                    .background(Color.saffGreen)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
            }
            
            Button(action: viewModel.biometricsLogin) {
                HStack {
                    Image(systemName: "faceid")
                        .foregroundColor(.white)
                        .font(.title)
                    Image(systemName: "touchid")
                        .foregroundColor(.white)
                        .font(.title)
                    Text("Biometrics")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 35)
                .padding()
                .background(viewModel.biometricsEnabled ? Color.saffGreen : .gray)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
            }
            .disabled(!viewModel.biometricsEnabled)
            
        }
        .padding()
        .alert(isPresented: $viewModel.showingWrongCredentialsAlert) {
            Alert(title: Text("Wrong Credentials"),
                  dismissButton: .cancel(Text("Try Again"))
            )
        }
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
