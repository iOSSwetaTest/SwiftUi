import SwiftUI

struct CharacterDetailsScreen: View {
    let info: CharacterInfo
    var body: some View {
        Form {
            Section("Info") {
                ListTile("Gender", "Gender")
            }
            Section("Films") {
                ListTile("Gender", "Gender")
            }
        }
        .navigationTitle(info.name)
    }
}

struct ListTile: View {
    let title, details: String
    
    init(_ title: String, _ details: String?) {
        self.title = title
        self.details = details ?? ""
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
            Spacer(minLength: 20)
            Text(details.capitalized)
                .foregroundColor(.gray)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.trailing)
        }
    }
}
