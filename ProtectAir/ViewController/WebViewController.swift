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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .clear
        dustButton.tintColor = .white
        weatherButton.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let normalSetting = URL(string: "https://m.airkorea.or.kr/info/behaviorInfo1")
        let normalURL = URLRequest(url: normalSetting!)
        webView.load(normalURL)
        setupWeb()
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
            .bind{[weak self] _ in
                self?.weatherWebView()
            }.disposed(by: bag)
        
        dustButton.rx.tap
            .bind{[weak self] _ in
                self?.dustWebView()
            }.disposed(by: bag)
    }
    
    private func weatherWebView() {
        let weatherUrl = URL(string: "https://www.weather.go.kr/w/image/radar.do")
        let weatherUrlRequest = URLRequest(url: weatherUrl!)
        webView.load(weatherUrlRequest)
    }
    
    private func dustWebView() {
        let dustUrl = URL(string: "https://m.airkorea.or.kr/info/envSatelliteImage")
        let dustUrlRequest = URLRequest(url: dustUrl!)
        webView.load(dustUrlRequest)
    }
}
