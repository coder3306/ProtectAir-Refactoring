//
//  WebViewController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/12/31.
//

import Foundation
import UIKit
import RxWebKit
import RxCocoa
import RxSwift
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var dustButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupWeb(){
        let progressObservable = webView.rx.loading
            .share()
        
        progressObservable
            .map{ return $0 }
            .observe(on: MainScheduler.instance)
            .bind(to: progressBar.rx.isHidden)
            .disposed(by: bag)
        
        progressObservable
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: bag)
        
        webView.rx.title
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: bag)
        
        webView.rx.estimatedProgress
            .map{ return Float($0) }
            .observe(on: MainScheduler.instance)
            .bind(to: progressBar.rx.progress)
            .disposed(by: bag)
        
        weatherButton.rx.tap
            .bind{
                print("asdf")
            }.disposed(by: bag)
        
        dustButton.rx.tap
            .bind{
                print("asdf")
            }.disposed(by: bag)
        
    }
}
