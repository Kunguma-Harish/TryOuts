//
//  ViewController.swift
//  DallE_Integration
//
//  Created by kunguma-14252 on 18/02/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private let placeHolder = UIImage(systemName: "magnifyingglass") ?? UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    func configure() {
        self.imageView.image = self.placeHolder
        self.searchBar.text = ""
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        print("Kungu : \(text).")
        self.imageView.image = self.placeHolder
        DallEModel.shared.generateImage()
    }
}
