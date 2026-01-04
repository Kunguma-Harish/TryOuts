//
//  DallEModel.swift
//  Dall-e integration
//
//  Created by kunguma-14252 on 18/02/25.
//

import Foundation

class DallEModel: NSObject {
    static let shared = DallEModel()

//    func generateImage(using promt: String = "") async -> Result<Data, Error> {
    func generateImage(using promt: String = "") {
        self.getTask { data, resp, err in
            if let err {
                print("Kungu : \(err) ")
            }

            if let data {
                print("Kungu : \(data)")
            }
        }
    }

    private func getRequest() -> URLRequest {
        let url = URL(string: "https://api.openai.com/v1/images/generations")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        let reqBodyParam = [
            "prompt": "Computer",
            "model": "dall-e-3",
            "size": "1024x1024",
            "style": "natural"
        ]
        if let httpBody = try? JSONSerialization.data(withJSONObject: reqBodyParam, options: []) {
            request.httpBody = httpBody
        }

        return request
    }

    private func _getRequest() -> URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        let reqBodyParam = [
            "messages": "Computer",
            "model": "gpt-4o",
            "size": "1024x1024",
            "style": "natural"
        ]
        if let httpBody = try? JSONSerialization.data(withJSONObject: reqBodyParam, options: []) {
            request.httpBody = httpBody
        }

        return request
    }

    private func getTask(completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) {
        let task = URLSession.shared.dataTask(with: getRequest(), completionHandler: completionHandler)
        task.resume()
    }
}
