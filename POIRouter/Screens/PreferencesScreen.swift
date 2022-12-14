//
//  PreferencesScreen.swift
//  MapsMacOS
//
//  Created by Joseph Jung on 8/6/22.
//

import SwiftUI

struct PreferencesScreen: View {
    @ObservedObject var userSettings: UserSettings
//    @AppStorage("useLightMap") var useLightMap: Bool = false
//    @AppStorage("distanceUnit") var distanceUnit = DistanceUnit.miles
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            
            Toggle(isOn: $userSettings.isDarkMode) {
                Text("Use Dark Map Appearance")
            }
            
            Divider()
            
            HStack{
                Text("Distance Units")
                Picker("", selection: $userSettings.distanceUnit){
                    ForEach(DistanceUnit.allCases, id: \.self) {distance in
                        Text(distance.title)
                        
                    }
                }.fixedSize()
                    .padding(.trailing, 20)
            }
            
        }.padding()
            .frame(minWidth:400, minHeight: 400)
    }
}

struct PreferencesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesScreen(userSettings: UserSettings())
    }
}
