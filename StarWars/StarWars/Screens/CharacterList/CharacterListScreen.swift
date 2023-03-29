import SwiftUI

struct CharacterListScreen: View {
    @StateObject private var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {
                case .loading:
                    ProgressView(Strings.fetchingRecords)
                case .error(let message):
                    ErrorView(message) {
                        viewModel.loadMoreData()
                    }
                case .dataLoaded:
                    mainContent
                }
            }
            .navigationTitle("Characters")
            .task {
                if viewModel.characterList.isEmpty {
                    viewModel.loadMoreData()
                }
            }
            .refreshable {
                viewModel.refresh()
            }
        }
    }
    
    var mainContent: some View {
        List {
            ForEach(viewModel.characterList) { info in
                NavigationLink(info.name) {
                    CharacterDetailsScreen(info: info)
                }.onAppear {
                    /// - Note: Load more not implemented, because we are sorting the list alphabetically
                    //viewModel.checkForNextPage(with: info)
                }
            }
            if viewModel.isNextPageLoading {
                ProgressView(Strings.fetchingMoreRecords)
            }
        }
    }
}

struct CharacterListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListScreen()
    }
}
