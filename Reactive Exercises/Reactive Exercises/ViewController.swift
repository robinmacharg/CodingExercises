//
//  ViewController.swift
//  Reactive Exercises
//
//  Created by Robin Macharg2 on 24/08/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // After clicking a button 3 times, with at least one second elapsed between each click, print
        //  “Challenge #1 solved” to the browser console once. Further clicks will not have any effects.

        button1.rx.tap
            .asObservable()
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .take(3)
            .subscribe(
                onNext: { _ in
                    print("button 1 tapped")
                },
                onDisposed: {
                    print("Challenge #1 solved")
                })
            .disposed(by: disposeBag)
    }

    @IBAction func button1Clicked(_ sender: Any) {
    }

    /**
     Make an ajax call to an API to fetch some data, retry the call up to 3 time in case of failure,
     but allowing 2 seconds to elapse between each ajax call. If the three calls fail, write “API call
     failed” to the browser console , if any of them succeed, show the retrieved data instead.
     */
    @IBAction func button2Clicked(_ sender: Any) {
        let failOn = Int.random(in: 1...3)
        print(failOn)
        let endPoint = "https://httpbin.org/status/200"

        guard let url = URL(string: endPoint) else {
            fatalError()
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared.rx.data(request: request)
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .retry(3)
            .debug()
            .subscribe()
            .disposed(by: disposeBag)


    }

    @IBAction func button3Clicked(_ sender: Any) {
    }

}

