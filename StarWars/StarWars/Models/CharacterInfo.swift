import Foundation

struct CharacterInfo: Codable, Identifiable, Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        self.name
    }
    
    let name: String
    let birthYear: String?
    let eyeColor: String?
    let films: [URL]
    let gender: String?
    let hairColor: String?
    let height: String?
    let homeWorld: URL?
    let mass: String?
    let skinColor: String?
    let species: [URL]
    let starships: [URL]
    let url: URL?
    let vehicles: [URL]


    enum CodingKeys: String, CodingKey {
        case birthYear = "birth_year"
        case eyeColor = "eye_color"
        case homeWorld = "homeworld"
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case height, mass, name, species
        case starships, url, vehicles, films, gender
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
    
        birthYear = try? values.decode(String.self, forKey: .birthYear)
        eyeColor = try? values.decode(String.self, forKey: .eyeColor)
        films = values.decodeArray(URL.self, forKey: .films)
        gender = try? values.decode(String.self, forKey: .gender)
        hairColor = try? values.decode(String.self, forKey: .hairColor)
        height = try? values.decode(String.self, forKey: .height)
        homeWorld = try? values.decode(URL.self, forKey: .homeWorld)
        mass = try? values.decode(String.self, forKey: .mass)
        name = try values.decode(String.self, forKey: .name)
        skinColor = try? values.decode(String.self, forKey: .skinColor)
        species = values.decodeArray(URL.self, forKey: .species)
        starships = values.decodeArray(URL.self, forKey: .starships)
        url = try? values.decode(URL.self, forKey: .url)
        vehicles = values.decodeArray(URL.self, forKey: .vehicles)
    }
}
