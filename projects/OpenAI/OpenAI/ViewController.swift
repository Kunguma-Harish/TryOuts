//
//  ViewController.swift
//  OpenAI
//
//  Created by kunguma-14252 on 30/03/23.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
//    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
    let apiSecretKey = "Bearer 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"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selected))
        self.view.gestureRecognizers = [tap]
    }

    @objc func selected() {
        self.textField.resignFirstResponder()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
//        self.customAnswerAi()
        if textField.text != nil, textField.text != "" {
//            self.generateAiFile()
            
            self.openAIRequest()
//            self.generateImageAI()
        }else {
            self.label.text = "Ask anything ..."
        }
    }
    
    func customAnswerAi() {
        let urlString = "https://api.openai.com/v1/chat/completions"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("\(apiSecretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let message = [["role": "user", "content": "Hello world"]]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": message,
            "temperature": 0.1,
            "max_tokens": 1000,
            "top_p": 0.1,
            "n": 1,
            "stream": false,
            "frequency_penalty": 0,
            "presence_penalty": 0.6
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            print("Kungu Custom",String(data: data!, encoding: .utf8))
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                let first = json!["choices"] as? [Any]
                let second = first?.first as? [String: Any]
                let text = second?["message"]
                print("Kungu : \(text)")
                DispatchQueue.main.async {
                    self.label.text = text as! String
                }
            }catch {
                print("Error")
            }
        })
        task.resume()
    }
    
    func openAIRequest() {
        let prompt = textField.text!
//        var prompt = "Give me a color hex code for the topic \(textField.text!) in th format accent1, accent2, accent3 and so on in json format"
        
        //"Give me a powerpoint color scheme which would suit the title \(textField.text) as json where accent1, accent2 and so on till accent4 is the key and the color's hex code is the value."
        
        let temp = "Give me slide has a unique key (e.g. slide1, slide2) and a corresponding value that includes the slide's title, layout, and content. The content is structured differently depending on the powerpoint presentation layouts for the topic iOS vs Android in json format for 8 slides"
//        prompt = temp
        let urlString = "https://api.openai.com/v1/engines/text-davinci-003/completions"
//        "https://api.openai.com/v1/engines/text-curie-003/completions"
//        "https://api.openai.com/v1/engines/text-davinci-003/completions"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("\(apiSecretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "temperature": 0.1,
            "max_tokens": 1000,
            "top_p": 0.1,
            "n": 1,
            "stream": false,
            "frequency_penalty": 0,
            "presence_penalty": 0.6
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                let first = json!["choices"] as? [Any]
                let second = first?.first as? [String: Any]
                let text = second?["text"] as? String
//                print("Kungu ", text!)
//                let textData = text?.data(using: .utf8)
//                let jsonArray = try? JSONSerialization.jsonObject(with: textData!) as? [String: String]
//                let color1 = jsonArray?["accent1"]
//                let color2 = jsonArray?["accent2"]
//                let color3 = jsonArray?["accent3"]
//                let color4 = jsonArray?["accent4"]
//                print(jsonArray)
                DispatchQueue.main.async {
//                    self.view1.backgroundColor = UIColor(hex: color1!)
//                    self.view2.backgroundColor = UIColor(hex: color2!)
//                    self.view3.backgroundColor = UIColor(hex: color3!)
//                    self.view4.backgroundColor = UIColor(hex: color4!)
                    self.label.text = text
                }
            } catch {
                print("errorMsg")
                DispatchQueue.main.async {
                    self.label.text = "errorMsg"
                }
            }
            
        })
        task.resume()
    }
    
    func generateImageAI() {
        let urlString = "https://api.openai.com/v1/images/generations"
        
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.setValue("\(apiSecretKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let parameters: [String : Any] = [
            "prompt": self.textField.text!,
              "n": 2,
              "size": "256x256"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        urlRequest.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                let first = json!["data"] as? [Any]
                let second = first?.first as? [String: Any]
                let url = second?["url"] as? String
                self.downloadImage(from: URL(string: url!)!)
            } catch {
                print("errorMsg")
                DispatchQueue.main.async {
                    self.label.text = "image errorMsg"
                }
            }

        })
        task.resume()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func generateAiFile() {
        let urlString = "https://api.openai.com/v1/files"
        
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.setValue("\(apiSecretKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        let parameters: [String : Any] = [
            "prompt": self.textField.text!,
            "n": 1,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            } catch {
                print("errorMsg")
                DispatchQueue.main.async {
                    self.label.text = "image errorMsg"
                }
            }
        })
        task.resume()
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }

        return nil
    }
}
