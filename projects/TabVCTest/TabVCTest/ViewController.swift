//
//  ViewController.swift
//  TabVCTest
//
//  Created by kunguma-14252 on 03/09/24.
//

import UIKit

class FruitsVC: UIPageViewController {
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AppleNc")
        self.setViewControllers([vc], direction: .forward, animated: true)
    }
}

extension FruitsVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AppleNc")
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BananaNc")
        return vc
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        3
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}
