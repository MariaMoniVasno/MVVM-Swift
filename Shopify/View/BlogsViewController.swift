//
//  BlogsViewController.swift
//  Shopify
//
//  Created by Trident on 06/06/22.
//

import UIKit
import WebKit

class BlogsViewController: UIViewController,NetworkReachabilityProtocol {
    
    @IBOutlet var tblViewShopify : UITableView!
    let refreshControl = UIRefreshControl()
    var networkPathMonitor: NetworkPathMonitor?
    private let articleViewModel = ArticleViewModel()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Blogs
        // Network
        self.startNetworkMonitoring()
        // Indicator
        setUpActivityIndicator()
        startActivityIndicator(backgroundColor:UIColor.AppWhite.Base!)
        // TableView
        setUpShopifyTableView()
        setUpRefreshControl()
        // Data Fetch
        if self.isNetworkAvailable() {
            articleViewModel.getAPIService()  //        articleViewModel.readJsonFile()
        }else{
            setUpAlert()
        }
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        notificationCenter.addObserver(self, selector: #selector(self.reloadTblViewNC(notification:)), name: ReloadTableViewNC, object: nil)
    }
    
    @objc func reloadTblViewNC(notification: Notification) {
        reloadTblViw()
    }
    
    //MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool){
        notificationCenter.removeObserver(self, name: ReloadTableViewNC, object: nil)
    }
    
    //MARK: setUpTableView and refresh
    func setUpShopifyTableView() {
        tblViewShopify.backgroundColor = UIColor.AppBackGround.Base
        tblViewShopify.tableFooterView = UIView(frame: .zero)
        tblViewShopify.register(UINib(nibName: ShopifyTableViewCellStr, bundle: nil), forCellReuseIdentifier: ShopifyTableViewCellStr)
    }
    
    func setUpRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: PullToRefresh)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblViewShopify.addSubview(refreshControl)
    }
    
    // Pull to Refresh
    @objc func refresh(_ sender: AnyObject) {
        articleViewModel.getAPIService()
        self.refreshControl.endRefreshing()
    }
    
    func reloadTblViw(){
        DispatchQueue.main.async{
            self.stopActivityIndicator()
            self.tblViewShopify.reloadData()
        }
    }
    
    //MARK: Network
    func networkStatusChanged(isConnected: Bool) {
        print("\(NetworkAvailability)  \(isConnected)")
    }
    
    deinit {
        self.stopNetworkMonitoring()
    }
    
    //MARK: AlertView
    func setUpAlert(){
        let alert = UIAlertController(title: NetworkAvailability, message: PleaseCheckYourInternet, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Ok, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        reloadTblViw()
    }
}

//MARK:- UITableViewDelegate and UITableViewDatasource
extension BlogsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: tableView: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModel.detailList?.count ?? zeroInt
    }
    
    //MARK: TableView: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopifyTableViewCellStr, for: indexPath) as! ShopifyTableViewCell
        if let productImage = articleViewModel.detailList?[indexPath.row].image?.src {
            ImageCaches.getImages(imageURL: productImage) { (downloadedImage) in
                cell.imgProduct.image = downloadedImage
            } // ImageCaches
        } // if let
        lblProperties(label:cell.lblTitle,text: "\(articleViewModel.detailList?[indexPath.row].title ?? EmptyStr)".uppercased(),textColor: UIColor.AppBlack.Base!, font: UIFont.InterBold(ofSize: sixteen),numberLines:zeroInt)
        lblProperties(label:cell.lblDescription,text: "\(articleViewModel.detailList?[indexPath.row].summary_html ?? EmptyStr)",textColor: UIColor.AppTextGray.Base!, font: UIFont.InterRegular(ofSize: fourteen),numberLines:twoInt)
        if cell.lblDescription.text == EmptyStr{
            cell.descriptionHeightConstraint.constant = zero
        } // if
        
        // height set based on the API
        cell.productImgHeightConstraint.constant = CGFloat(articleViewModel.detailList?[indexPath.row].image?.height ?? zeroInt)
        
        return cell
    }
    
    // Common func for label properties
    func lblProperties(label:UILabel,text: String,textColor : UIColor,font : UIFont,numberLines:Int){
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberLines
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    //MARK: TableView: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: TableView: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Main, bundle: nil)
        let webKitViewController = storyboard.instantiateViewController(withIdentifier: WebKitViewControllerStr) as! WebKitViewController
        webKitViewController.webViewHtml = articleViewModel.detailList?[indexPath.row].body_html ?? EmptyStr
        navigationController?.pushViewController(webKitViewController, animated: true)
    }
    
    //MARK: TableView: willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let padding: CGFloat = ten
        let maskLayer = CALayer()
        maskLayer.cornerRadius = ten
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: padding, dy: padding)
        cell.layer.mask = maskLayer
    }
}

