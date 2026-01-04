import UIKit

let url = URL(string: "https://bit.ly/2LMtByx")!

var request = URLRequest(url: url)

let task = URLSession.shared.dataTask(with: url) { data, response, error in
    if let data = data {
        let image = UIImage(data: data)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-API-Key": "123456789"
        ]
        request.setValue("application/png", forHTTPHeaderField: "Content-Type")

    } else if let error = error {
        print("HTTP Request Failed \(error)")
    }
}
task.resume()

