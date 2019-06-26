//
//  ViewController.swift
//  HackerRankProject
//
//  Created by Harish V V on 22/06/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit
import PullToRefreshKit

///This is the View class which handles just the View creation/rendering
class ViewController: UIViewController {
    
    var feature: Feature?
    var country: Canada?
    
    var navigationCntrl: UINavigationController?
    var tableView: UITableView!
    
    let imageCache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpView()
        
        self.feature = Feature()
        
        //actual trigger for the service call from View which just mentions the service name
        let _  = self.feature?.triggerServiceCall(serviceType: .aboutCanada, completion: { (result) in
            if !result.hasError {
                self.country = result.value as? Canada
                
                DispatchQueue.main.async {
                    //do all UI operations in main thread after successful response is read
                 
                    //set navigation bar title with the response recieved
                    self.navigationCntrl?.navigationBar.topItem?.title = self.country?.title
                    
                    //trigger table reload to render cells by calling the delegates
                    self.tableView.reloadData()
                }
            } else {
                print("Failed to receive response!")
            }
        })
    }
    
    //do all initial setup to draw the UI in this function
    public func setUpView() {
        //create navigation bar
        self.navigationCntrl = UINavigationController(rootViewController: self)
        if let window = UIApplication.shared.delegate?.window {
            window!.rootViewController = self.navigationCntrl
        }

        let barHeight = self.navigationCntrl?.navigationBar.frame.height ?? 0
        let viewableWidth: CGFloat = self.view.frame.width
        let viewableHeight: CGFloat = self.view.frame.height

        //create tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: viewableWidth, height: viewableHeight - barHeight))
        self.tableView.register(AttributesCell.self, forCellReuseIdentifier: IDENTIFIERS.ROWS_CELL_ID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //handle dynamic cell height calculation here
        self.tableView.estimatedRowHeight = CGFloat(CONSTANTS_STRUCT.CELL_HEIGHT)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        
        self.setLayoutConstraints()
        
        self.pullDownToRefresh()
    }
    
    
    func pullDownToRefresh() {
        //customize refresh text
        let header = DefaultRefreshHeader.header()
        header.setText("Pull to refresh", mode: .pullToRefresh)
        header.setText("Release to refresh", mode: .releaseToRefresh)
        header.setText("Success", mode: .refreshSuccess)
        header.setText("Refreshing...", mode: .refreshing)
        header.setText("Failed", mode: .refreshFailure)
        header.durationWhenHide = 0.4
        
        //add pull down to refresh
        self.tableView.configRefreshHeader(with: header,container:self) { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
        }
    }
}

//handle all view constraints and orientation changes here
extension ViewController {
    
    private func setLayoutConstraints() {
        self.tableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//            // Reload TableView to update cell's constraints if need be
//            DispatchQueue.main.async {
//                //self.setLayoutConstraints()
//               // self.tableView.reloadData()
//            }
//    }
    
}


//handle all tableview delegates in this extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.country?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.ROWS_CELL_ID, for: indexPath as IndexPath) as! AttributesCell
        
        //read title, description and imageUrl to display from Model based on row index
        //set title and description in custom cells Model object didset
        let currentRow = self.country?.rows[indexPath.row]
        cell.row = currentRow
        
        //add a placeholder image in case an image is not available for a row
        cell.rowImage.image = UIImage(named: "placeholder")
        
        if let imageString = self.country?.rows[indexPath.row].imageUrl {
            //check to see if the image is in cache
            if let cachedImage = self.imageCache.object(forKey: imageString as NSString) {
                //using cached image and hence no need to download it
                cell.rowImage.image = cachedImage
            } else {
                //trigger image download
                let session =  URLSession.shared
                guard let url = URL(string: imageString) else {
                    print("Failed to create URL")
                    return cell
                }
                
                let task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async {
                            //check to ensure the current cell is visible before we assign the downloaded image
                            if let updateCell = tableView.cellForRow(at: indexPath) as? AttributesCell {
                                if let downloadedImage = UIImage(data: data) {
                                    updateCell.rowImage.image = downloadedImage
                                    //save the downloaded image in cache for reuse during scroll
                                    self.imageCache.setObject(downloadedImage, forKey: imageString as NSString)
                                }
                            }
                        }
                    }
                })
                task.resume()
            }
        }
        return cell
    }
    
}
