//
//  ViewController.swift
//  web
//
//  Created by kevinhe on 2019/11/20.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit
import WebKit
import os.log
import SafariServices

class MainViewController: UIViewController,UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate
{

    //MARK:-outlet properties
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var reloadBtn: UIActivityIndicatorView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var goBackBtn: UIButton!
    @IBOutlet weak var goForwardBtn: UIButton!
    @IBOutlet weak var bookBtn: UIButton!
    
    @IBOutlet weak var addToBookBtn: UIButton!
    @IBOutlet weak var historyRecordBtn: UIButton!

    @IBOutlet weak var webView: WKWebView! {
        didSet {

            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.scrollView.delegate = self
            webView.allowsBackForwardNavigationGestures = false
            webView.allowsLinkPreview = true
        }
    }
    
    // Call this method when you want to show the browser // safari 无用待删
    func doSomething() { //无用待删 old reference
        

        print("doSomething")
//        let url = URL(string: "https://www.baidu.com")!
//        let safariViewController = SFSafariViewController(url: url)
//        present(safariViewController, animated: true, completion: nil)
    }
    
    private var bookMarks = BookMarks()
    
    private var searchedStrings = BookMarks()
    
    
    //MARK: -IBActions

    
    @IBAction func goBackAction(_ sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
            if let url = webView.url {
                searchBar.text = url.absoluteString
            }
            
        }
    }
    
    
    @IBAction func hideKeyBoard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            searchBar.resignFirstResponder()
//            searchBar.isHidden = true
            
        default:
            break
        }
    }
    
    
    @IBAction func reloadTapGuesture(_ sender: UITapGestureRecognizer) {
        if webView.url != nil {
            print(webView.url!.absoluteString)
        }
        switch sender.state {
        case .ended:
            webView.reload()
            updateBackAndForwardButtons()
        default:
            break
        }
        
    }
    
    
    @IBAction func goForwardAction(_ sender: UIButton) {
        if webView.canGoForward {
        webView.goForward()
            if let url = webView.url {
                searchBar.text = url.absoluteString
            }
        }
    }
    

    
    private var urlString: String? {
        get {
            return searchBar.text
        }
        set {
            let urlpre = "http"
            let urlpre2 = "https://"
            if var text = newValue, text.count > 8 {
                let startIndex = text.startIndex
                let endIndex = text.index(startIndex, offsetBy: 3)
                let newText = text[startIndex...endIndex]
                if newText != urlpre {
                    text = urlpre2 + text
                    loadurl(string: text)
                    return
                }
            }
            if let url = newValue {
                loadurl(string: url)
                
                print("already add  https")
                
            }
        }
    }
    
    //MARK:- segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showHistorys" {
        if let destinVC = segue.destination.contents as? PagesTableViewController {
//            destinVC.modalPresentationStyle = .overFullScreen
//            destinVC.modalTransitionStyle = .crossDissolve   //待删 无用
            destinVC.urlsModelTitle = searchedStrings.titles
            destinVC.urlsModelurl = searchedStrings.urls
            destinVC.title = (sender as? UIButton)?.currentTitle
        }
        } else if segue.identifier == "showBookMarks" {
            if let destinVC = segue.destination.contents as? PagesTableViewController {
                
//                destinVC.modalPresentationStyle = .fullScreen
//                destinVC.modalTransitionStyle = .crossDissolve //待删 无用
                destinVC.urlsModelTitle = bookMarks.titles
                destinVC.urlsModelurl = bookMarks.urls
                destinVC.title = (sender as? UIButton)?.currentTitle
            }
            
        }
    }
    
    @IBAction func unwindFromPagesVC(segue: UIStoryboardSegue) {
        if segue.identifier == "unwind" {
            if let scoureVC = segue.source as? PagesTableViewController {
                if let indexpath = scoureVC.tableView.indexPathForSelectedRow {
                    searchBar.text = scoureVC.urlsModelurl[indexpath.row]
                    
                    urlString = scoureVC.urlsModelurl[indexpath.row]
                }
            }
        }
    }
    
    
    //MARK:- scrollViewDeleagate
    
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        topStackView.isHidden = false
//
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let swipeThreshold: CGFloat = 10
         let y = scrollView.panGestureRecognizer.translation(in: scrollView).y
         if y != 0 && swipeThreshold > y {
//             navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                if !self.searchBar.isHidden {
                    self.searchBar.isHidden = true
                }
            })
         } else {
//             navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
                if self.searchBar.isHidden {
                    self.searchBar.isHidden = false
                }
            })
         }
        
//        topStackView.isHidden = true
//        webView.scrollView.scrollRectToVisible(CGRect(x: 0, y: 200, width: webView.bounds.width, height: webView.bounds.height), animated: true)
    }
    
    
  
    //MARK: UIWebViewDelegate
    
    
//    MARK: WKNavigationDelegate
    
    //MARK: UITextFieldDelegate
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
    

    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newValue = loadMarks() {
            bookMarks = newValue
        }

//        webView.load(<#T##data: Data##Data#>, mimeType: <#T##String#>, characterEncodingName: <#T##String#>, baseURL: <#T##URL#>)
        //estimatedProgress
//        //控制器推出的模式
//        let player = AVPlayer(url: NSURL(string: urlString)! as URL)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated:true, completion: nil)

        
//        urlString = "https://plmjxc.onesite.alibaba.com/?spm=a2700.onesite.0.0.138dapA2apA2GX"
    }
    
    

    
    private func updateBackAndForwardButtons(){
        goBackBtn.isEnabled = webView.canGoBack
        goForwardBtn.isEnabled = webView.canGoForward

    }
    
    var timer: Timer? //待删 无用
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBackAndForwardButtons()
        
        print("viewWillAppear")
        webView.addObserver(self, forKeyPath: "estimatedProgress",
        options: .new, context: nil)
//        progressView.trackTintColor = UIColor.orange
//        progressView.progressTintColor = UIColor.blue

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        super.viewWillDisappear(animated)
        webView.stopLoading()
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
        timer?.invalidate() //待删 无用
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }

    //MARK: - methods
    
    
    private func saveBookMarks() {
        print("saveBookMarks")
        do {
            let url = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("bookMarks")
            try bookMarks.json?.write(to: url)
            os_log("bookMarks is saved", log: OSLog.default, type: OSLogType.default)
        } catch {
            os_log("bookMarks is not saved", log: OSLog.default, type: .error)
            
        }
        
    }
    
    
    private func loadMarks() -> BookMarks?{
        var temp: BookMarks?
        if let url = try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("bookMarks") {
            if let jsonData = try? Data(contentsOf: url) {
                temp = BookMarks(json: jsonData)
            }
        }
        return temp
    }
    
//    var datas = [Data]()
    
     private func loadurl(string: String) {
        
        guard let url = URL(string: string) else {fatalError("unuseful URL string")}
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data:Data?, response, error)  in
            if data != nil {
                print("文件大小是\(data!)")
                print(data!.count)

//                self.datas.append(data!)
                if let str = String(data: data!, encoding: String.Encoding.utf8) { print(str)}
                
             } else if error != nil {
                 print("there is error")
             }
        }
        task.resume()
        let urlrequest = URLRequest(url: url)
        webView.load(urlrequest)
        webView.allowsBackForwardNavigationGestures = true
        searchBar?.resignFirstResponder()
//        webView.observeValue(forKeyPath: "?", of: <#T##Any?#>, change: <#T##[NSKeyValueChangeKey : Any]?#>, context: <#T##UnsafeMutableRawPointer?#>)
        if webView.isLoading, webView.title != nil {
            print("isLoading: " + webView.title!)
        } else {
            print("isnotLoading")
        }
        
    }
    

    
    



    func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        print("contextMenuDidEndForElement")
    }
    
    func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        print("contextMenuWillPresentForElement")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        reloadBtn.startAnimating()
        updateBackAndForwardButtons()
         if webView.isLoading {
             if let url = webView.url?.absoluteString, let title = webView.title  {
                           
                           searchBar.text = url
                           
                           searchedStrings.titles.append(title)
                           searchedStrings.urls.append(url)
                           
                           print("didStartProvisionalNavigation have searched \(self.searchedStrings)")
                       }
                       //更新前进后退button
                       updateBackAndForwardButtons()
        }  else {
            print("didStartProvisionalNavigation isnotLoading  ")
        
        }
        
    }

    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateBackAndForwardButtons()
        
        print("didFail navigation")
    }

    

    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        if webView.isLoading {
            print("webViewWebContentProcessDidTerminate")
        }  else {
            print("webViewWebContentProcessDidTerminate isnotLoading")
        }
//        webView.stopLoading()
    }
    
    func webViewDidClose(_ webView: WKWebView) {
         if webView.isLoading {
            print("webViewDidClose")
        }  else {
            print("webViewDidClose isnotLoading")
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
         if webView.isLoading {
            print("didFailProvisionalNavigation")
        }  else {
            print("didFailProvisionalNavigation isnotLoading")
        }
//        webView.stopLoading()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
         if webView.isLoading {
            print("didCommit")
            
        }  else {
            print("didCommit isnotLoading")
            
        }
        
        for subView in webView.subviews {
            print("subView")
            if let textView = subView as? UITextView {
                print(textView.text ?? "no text")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("didFinish")
        //进度条

          progressView.setProgress(0.0, animated: false)
          reloadBtn.stopAnimating()
    }
    
    //MARK:- add进度条
     /// 进度条：只在活动页展示

    //设置监听

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progressView.isHidden = webView.estimatedProgress == 1
//        if webView.url != nil {
//            textfield.text = webView.url!.absoluteString
//        }
           progressView.setProgress(Float(webView.estimatedProgress), animated: true)
           print("webView.estimatedProgress = \(webView.estimatedProgress)")
    }
    
}

extension UIViewController {
    
    var contents: UIViewController {
        if let navi = self as? UINavigationController {
            return navi.visibleViewController ?? self
        } else {
            return self
        }
        
    }
}
    

extension Array where Element: Equatable {
    var uniquified: [Element] {
        var elements = [Element]()
        forEach { if !elements.contains($0) { elements.append($0) } }
        return elements
    }
}


extension MainViewController: UISearchBarDelegate {
    
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
//        doSomething()  // safari 模拟

        var alertText = "Already add to bookMakrs"
        
        if let url = webView.url?.absoluteString, let title = webView.title
        {
            if !bookMarks.titles.contains(title) || !bookMarks.urls.contains(url)
            {
                bookMarks.titles.append(title)
                bookMarks.urls.append(url)
                
                alertText = "Add to bookMakrs success"
            }
        }
        saveBookMarks()
        
        let alert = UIAlertController(title: alertText, message: nil, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch(searchBar)
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        startSearch(searchBar)
        searchBar.resignFirstResponder()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        webView.stopLoading()
    }
    
    private func startSearch(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            urlString = searchBar.text
        }
    }

}
