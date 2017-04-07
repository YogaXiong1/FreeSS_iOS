//
//  ViewController.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/3.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit

private let cellId = NSStringFromClass(LadderCell.self)

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var ladders = [Ladder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        Creater.shared.makeLadder { [weak self] (ladders, error) in
            if error != nil || ladders.isEmpty {
                DispatchQueue.main.async {
                    self?.noticeError("获取数据失败")
                }
            } else {
                DispatchQueue.main.async {
                    self?.ladders = ladders
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func configTableView() {
        tableView.register(UINib.init(nibName: "LadderCell", bundle: .main), forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    func saveQRCodeImage(url: String) {
        ImageUtil.shared.downloadImage(url: URL(string: url)!, progressBlock: nil) { [weak self] (data, image, error, finished) in
            guard let i = image else { return }
            ImageUtil.shared.save(image: i) { (success, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self?.noticeError("保存失败")
                    } else {
                        self?.noticeOnStatusBar("保存成功")
                    }
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ladders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? LadderCell
        let ladder = ladders[indexPath.row]
        cell?.config(with: ladder)
        cell?.menuItemHandler = saveQRCodeImage
        return cell!
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let i = UIMenuItem(title: "保存二维码图片", action: #selector(LadderCell.cilckMenuItem))
        UIMenuController.shared.menuItems = [i]
        UIMenuController.shared.update()
        return true
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(LadderCell.cilckMenuItem)
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
    }
    
}

