//
//  SettingsView.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 24.07.2025.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("Выход")
                        .padding()
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Spacer()
            }
        }
        .padding(.bottom, 150)
    }
}

#Preview {
    SettingsView()
}
