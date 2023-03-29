import Combine
import Foundation

class CharacterListViewModel: ObservableObject {
    @Published var viewState: ViewState = .loading
    @Published var characterList: [CharacterInfo] = []
    private var characterCount: Int = 0
    var nextPageURL: URL?
    @Published var isNextPageLoading: Bool = false
    private var disposableBag = Set<AnyCancellable>()
    
    private var pageURL: URL? {
        if characterList.isEmpty {
            return URL(apiPath: "people/?page=1")
        } else {
            return nextPageURL
        }
    }
    
    func checkForNextPage(with item: CharacterInfo) {
        if characterList.last == item
            && nextPageURL != nil
            && isNextPageLoading == false {
            self.loadMoreData()
        }
    }
    
    func refresh() {
        nextPageURL = nil
        self.isNextPageLoading = false
        self.characterList = []
        self.loadMoreData()
    }
    
    func loadMoreData() {
        guard let pageURL else { return }
        if characterList.isEmpty {
            self.viewState = .loading
        } else {
            self.isNextPageLoading = true
        }
        guard Reachability.isConnectedToNetwork() else {
            self.viewState = .error(message: Strings.noInternet)
            return
        }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60.0 // 60 seconds
        let session = URLSession(configuration: configuration)
        session
            .dataTaskPublisher(for: pageURL)
            .receive(on: RunLoop.main)
            .map({$0.data})
            .decode(type: BasePaginationModel<CharacterInfo>.self, decoder: JSONDecoder())
            .sink { result in
                switch result {
                case .finished: break
                case .failure(let error):
                    print(error)
                    if let error = error as? URLError,
                        error.code == .timedOut {
                        self.viewState = .error(message: Strings.requestTimeout)
                    } else {
                        self.viewState = .error(message: Strings.somethingWentWrong)
                    }
                    
                }
            } receiveValue: { data in
                self.isNextPageLoading = false
                self.nextPageURL = data.next
                self.characterCount = data.count
                self.characterList = (self.characterList + data.results)
                    .sorted(by: { $0.name < $1.name })
                if self.characterList.isEmpty {
                    self.viewState = .error(message: Strings.noCharactersFound)
                } else {
                    self.viewState = .dataLoaded
                }
            }
            .store(in: &disposableBag)

    }
    
}
