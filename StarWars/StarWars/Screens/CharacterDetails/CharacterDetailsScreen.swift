import SwiftUI

struct CharacterDetailsScreen: View {
    let info: CharacterInfo
    @StateObject private var viewModel = CharacterDetailsViewModel()
    var body: some View {
        Form {
            Section("Info") {
                ListTile("Gender", info.gender)
                ListTile("Birth Year", info.birthYear)
                ListTile("Skin Color", info.skinColor)
                ListTile("Hair Color", info.hairColor)
                ListTile("Eye Color", info.eyeColor)
                ListTile("Height", info.height?.intValue?.getHeightString())
            }
            Section(content: {
                ForEach(viewModel.films) { film in
                    ListTile(film.title, "Words in Opening Crawl: \(film.openCrawlCount)")
                }.transition(.move(edge: .leading))
            }, header: {
                HStack(spacing: 16) {
                    Text("Films")
                    if viewModel.isFetchingFilms {
                        ProgressView()
                    }
                }
            })
        }
        .navigationTitle(info.name)
        .task {
            viewModel.fetchFilms(from: info)
        }
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
