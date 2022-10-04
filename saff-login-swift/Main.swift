//
//  Main.swift
//  saff-login-swift
//
//  Created by 7up ‘ on 07/03/1444 AH.
//

import SwiftUI

struct Main: View {
    
    @ObservedObject private var viewModel = ViewModel.shared
    
    var body: some View {
        if viewModel.loggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
