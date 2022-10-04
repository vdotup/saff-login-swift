//
//  HomeView.swift
//  saff-login-swift
//
//  Created by 7up ‘ on 07/03/1444 AH.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel = ViewModel.shared
    
    var body: some View {
        VStack(spacing: 24) {
            Image("Logo")
            
            Button(action: viewModel.logout) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .padding()
                    .background(Color.red)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
            }
            
            Button(action: viewModel.enableBiometrics) {
                HStack {
                    Image(systemName: "faceid")
                        .foregroundColor(.white)
                        .font(.title)
                    Image(systemName: "touchid")
                        .foregroundColor(.white)
                        .font(.title)
                    Text(viewModel.biometricsEnabled ? "Biometrics Enabled" : "Enable Biometrics")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 35)
                .padding()
                .background(viewModel.biometricsEnabled ? .gray : Color.saffGreen)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
            }
            .disabled(viewModel.biometricsEnabled)
            Spacer()
            
            VStack {
                Text("SAFF Location: \(viewModel.saffLocation.string())")
                Text("User Location: \(viewModel.userLocation?.string() ?? "nil")")
                Text("Distance: \(viewModel.calcDistance() ?? -1)")
            }
            
            Spacer()
            
            VStack {
                Text("Punch In: \(viewModel.punchInTime?.formatted(date: .numeric, time: .complete) ?? "not yet")")
                Text("Punch Out: \(viewModel.punchOutTime?.formatted(date: .numeric, time: .complete) ?? "not yet")")
            }
            
            Button(action: viewModel.punchIn) {
                Text("Punch In")
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .padding()
                    .background(Color.saffGreen)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
            }
            
            Button(action: viewModel.punchOut) {
                Text("Punch Out")
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .padding()
                    .background(Color.saffGreen)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showingNotInLocationAlert) {
            Alert(title: Text("Not Allowed"),
                  message: Text("You can punch in / out in work location only."),
                  dismissButton: .cancel(Text("Continue"))
            )
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
