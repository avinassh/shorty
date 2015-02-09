//
//  ViewController.swift
//  Shorty
//
//  Created by avi on 09/02/15.
//  Copyright (c) 2015 avi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate,
                                        NSURLConnectionDelegate,
                                        NSURLConnectionDataDelegate {

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var shortenButton: UIBarButtonItem!
    @IBOutlet weak var shortLabel: UIBarButtonItem!
    @IBOutlet weak var clipboardButton: UIBarButtonItem!
    
    let goDaddyAccountKey = "012345"
    var shortenURLConnection: NSURLConnection?
    var shortURLData: NSMutableData?
    
    @IBAction func loadLocation(AnyObject) {
        var urlText = urlField.text
        
        if !urlText.hasPrefix("http:") && !urlText.hasSuffix("https:") {
            if !urlText.hasPrefix("//") {
                urlText = "//" + urlText
            }
            urlText = "http:" + urlText
        }
        
        if let url = NSURL(string: urlText) {
            println(url)
            webView.loadRequest(NSURLRequest(URL: url))
        }

    }
    
    @IBAction func shortenURL(sender: AnyObject) {
        if let toShorten = webView.request?.URL.absoluteString {
            if let encodeURL = toShorten.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                let urlString = "http://api.x.co/Squeeze.svc/text/\(goDaddyAccountKey)?url=\(encodeURL)"
                shortURLData = NSMutableData()
                let request = NSURLRequest(URL: NSURL(string: urlString)!)
                shortenURLConnection = NSURLConnection(request: request, delegate: self)
                shortenButton.enabled = false
            }
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        shortenButton.enabled = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        shortenButton.enabled = true
        urlField.text = webView.request?.URL.absoluteString
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        var message = "That page could not be loaded. " + error.localizedDescription
        let alert = UIAlertController(title: "Could not load URL", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "That's Sad", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        shortLabel.title = "failed"
        clipboardButton.enabled = false
        shortenButton.enabled = true
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        shortURLData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if let data = shortURLData {
            if let shortURLString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                shortLabel.title = shortURLString
                clipboardButton.enabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

