import Foundation

struct FilmInfo: Codable, Identifiable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    let id = UUID()
    let title: String
    let episodeID: Int
    let openingCrawl, director, producer, releaseDate: String?
    let characters, planets, starships, vehicles: [URL]
    let species: [URL]
    let created, edited: String?
    let url: URL
    
    var openCrawlCount: Int {
        (openingCrawl ?? "").split(separator: " ").count
    }

    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
        case openingCrawl = "opening_crawl"
        case director, producer
        case releaseDate = "release_date"
        case characters, planets, starships, vehicles, species, created, edited, url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.episodeID = try values.decode(Int.self, forKey: .episodeID)
        self.openingCrawl = try? values.decode(String.self, forKey: .openingCrawl)
        self.director = try? values.decode(String.self, forKey: .director)
        self.producer = try? values.decode(String.self, forKey: .producer)
        self.releaseDate = try? values.decode(String.self, forKey: .releaseDate)
        self.characters = values.decodeArray(URL.self, forKey: .characters)
        self.planets = values.decodeArray(URL.self, forKey: .planets)
        self.starships = values.decodeArray(URL.self, forKey: .starships)
        self.vehicles = values.decodeArray(URL.self, forKey: .vehicles)
        self.species = values.decodeArray(URL.self, forKey: .species)
        self.created = try? values.decode(String.self, forKey: .created)
        self.edited = try? values.decode(String.self, forKey: .edited)
        self.url = try values.decode(URL.self, forKey: .url)
    }
}
