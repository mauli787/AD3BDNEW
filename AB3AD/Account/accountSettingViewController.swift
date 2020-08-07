//
//  accountSettingViewController.swift
//  AB3AD
//
//  Created by Apple on 07/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class accountSettingViewController: UIViewController {
  @IBOutlet weak var settingTableView: UITableView!
    
    let settingArray = ["Governorate","Language"]
    let connectUsArray = ["Whatsapp","Snap Chat","Call Us"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.settingTableView.separatorStyle = .singleLine
        self.settingTableView.register(UINib(nibName: "settingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingTableViewCell")
    }
}

extension accountSettingViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-30, height: headerView.frame.height-10)
        if section == 0 {
            label.text = "Setting"
        }else{
            label.text = "Connect with us"
        }
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 22,weight: UIFont.Weight.bold)
        label.textColor = UIColor.black

        headerView.addSubview(label)

        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0{ return 2}else{ return 3}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.settingTableView.dequeueReusableCell(withIdentifier: "settingTableViewCell") as? settingTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0{
            cell.valueLbl.isHidden = false
            cell.titleLbl.text = self.settingArray[indexPath.row]
            cell.valueLbl.text = "jan"
        }else{
            cell.titleLbl.text = self.connectUsArray[indexPath.row]
            cell.valueLbl.isHidden = true
        }
        return cell
    }
   
    
}
