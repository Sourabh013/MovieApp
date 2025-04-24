struct GetMovieListModel: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let MediaType: String
    let Poster: String
    
    enum CodingKeys: String, CodingKey {
        case Title
        case Year
        case imdbID
        case MediaType = "Type"
        case Poster
        
    }
}
struct GetMovieAPIResponse: Codable {
    let Search: [GetMovieListModel]
    let totalResults: String
    let Response: String
}
