//
//  AppVersionInformationView.swift
//  qandao
//
//  Created by bill donner on 9/18/24.
//

import SwiftUI

struct AppVersionInformationView: View {
   // # 1
  let name:String
    let versionString: String
    let appIcon: String

    var body: some View {
        //# 1
        HStack(alignment: .center, spacing: 12) {
          // # 2
           VStack(alignment: .leading) {
               Text("App")
                   .bold()
               Text("\(name)")
           }
           .font(.caption)
           .foregroundColor(.primary)
            //# 3
            // App icons can only be retrieved as named `UIImage`s
            // https://stackoverflow.com/a/62064533/17421764
            if let image = UIImage(named: appIcon) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
           // # 4
            VStack(alignment: .leading) {
                Text("Version")
                    .bold()
                Text("v\(versionString)")
            }
            .font(.caption)
            .foregroundColor(.primary)
        }
        //# 5
        .fixedSize()
        //# 6
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("App version \(versionString)")
    }
}


struct AppVersionInformationView_Previews: PreviewProvider {
  static var previews: some View {
    AppVersionInformationView(
        name:AppNameProvider.appName(),
        versionString: AppVersionProvider.appVersion(),
        appIcon: AppIconProvider.appIcon()
    )
  }
}
