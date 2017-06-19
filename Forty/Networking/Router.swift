import Foundation

struct Router {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    static func hit(_ endpoint: Endpoint, handler: Handler? = nil) {
        let basePath = "https://forty-rails.herokuapp.com/api/v1"
        let url = URL(string: "\(basePath)\(endpoint.path)")!
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ClientToken, forHTTPHeaderField: "X-CLIENT-TOKEN")
        if let data = endpoint.data {
            request.httpBody = data
        }

        let task: URLSessionDataTask

        if let handler = handler {
            task = URLSession.shared.dataTask(with: request, completionHandler: handler)
        } else {
            task = URLSession.shared.dataTask(with: request)
        }

        task.resume()
    }
}
