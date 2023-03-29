import Foundation
import Combine

class CharacterDetailsViewModel: ObservableObject {
    
    @Published var films: [FilmInfo] = []
    @Published var isFetchingFilms = false
    private var disposableBag = Set<AnyCancellable>()
    private var filmLoadCount = 0
    
    func fetchFilms(from info: CharacterInfo) {
        guard info.films.isEmpty == false else {
            return
        }
        filmLoadCount = info.films.count
        info.films.forEach {
            self.fetchFilmDetails(from: $0)
        }
    }
    
    func fetchFilmDetails(from url: URL) {
        if isFetchingFilms == false {
            isFetchingFilms = true
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map({$0.data})
            .decode(type: FilmInfo.self, decoder: JSONDecoder())
            .sink { result in
                self.filmLoadCount -= 1
                if self.filmLoadCount <= 0 {
                    self.isFetchingFilms = false
                }
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { info in
                self.films.append(info)
            }.store(in: &disposableBag)

    }
}
