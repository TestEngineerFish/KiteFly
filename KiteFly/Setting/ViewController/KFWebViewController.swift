//
//  BPWebViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import WebKit

open class KFWebViewController: KFViewController, WKNavigationDelegate, WKUIDelegate {
    
    /// 请求地址
    public var urlStr: String?
    var localHtml: String?
    /// 是否隐藏导航栏
    public var isHideNavigationBar: Bool = false
    
    private var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        // 视频播放是否允许调用本地播放器
        configuration.allowsInlineMediaPlayback                = true
        // 设置哪些设备(音频或视频)需要用户主动播放,不自动播放
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        // 是否允许画中画(缩放视频在浏览器内,不影响其他操作)效果,特定设备有效
        configuration.allowsPictureInPictureMediaPlayback      = true
        // 设置请求时的User—Agent信息中的应用名称, iOS9之后有用
        configuration.applicationNameForUserAgent              = "User_agent name"
        // ---- 设置偏好设置 ----
        let preferences = WKPreferences()
        // 设置最小字体,优先JS的控制,可关闭javaScriptEnabled.来测试
        preferences.minimumFontSize   = 8
        // 是否支持javaScriptEnable
        preferences.javaScriptEnabled = true
        // 是否可以不经过用户同意,直接由JS控制打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        
        // 这个类主要负责与JS交互管理
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        let _webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), configuration: configuration)
        _webView.scrollView.maximumZoomScale               = 1
        _webView.scrollView.minimumZoomScale               = 1
        _webView.scrollView.showsVerticalScrollIndicator   = true
        _webView.scrollView.showsHorizontalScrollIndicator = false
        return _webView
    }()
    public var progressView: UIProgressView = {
       let progressView = UIProgressView()
        progressView.tintColor = UIColor.blue0
        return progressView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        self.request()
    }
    
    open override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            if self.isHideNavigationBar {
                make.top.equalToSuperview()
            } else {
                make.top.equalToSuperview().offset(kNavHeight)
            }
        }
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(2))
            if self.isHideNavigationBar {
                make.top.equalToSuperview()
            } else {
                make.top.equalToSuperview().offset(kNavHeight)
            }
        }
    }
    
    open override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title    = title
        self.customNavigationBar?.isHidden = isHideNavigationBar
        self.webView.navigationDelegate    = self
        self.webView.uiDelegate            = self
    }
    
    open override func bindData() {
        super.bindData()
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        return
    }
    
    // MARK: ==== Event ====
    private func request() {
        if let _urlStr = self.urlStr, let url = URL(string: _urlStr) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            self.webView.load(request)
        } else if let _localHtml = self.localHtml {
            let url = URL(fileURLWithPath: _localHtml)
            let request = URLRequest(url: url)
            self.webView.load(request)
        } else {
            kWindow.toast("地址无效")
            self.navigationController?.pop()
            return
        }
        
    }
    
    // MARK: ==== KVO ====
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let key = NSKeyValueChangeKey(rawValue: "new")
            guard let progress = change?[key] as? Float else { return }
            if progress < 1 {
                self.progressView.progress = progress
            } else {
                self.progressView.isHidden = true
            }
        }
    }
    
    // MARK: ==== WKNavigationDelegate ====
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { [weak self] title, error in
            guard let self = self, let _title = title as? String else { return }
//            self.customNavigationBar?.title = _title
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        guard message.isNotEmpty else {
            completionHandler()
            return
        }
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { action in
            completionHandler()
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        guard message.isNotEmpty else {
            completionHandler(false)
            return
        }
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
            completionHandler(true)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = defaultText
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
            guard let textField = alert.textFields?.first else {
                completionHandler(nil)
                return
            }
            completionHandler(textField.text)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: ==== WKUIDelegate ====
}
