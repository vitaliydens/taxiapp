//
//  MenuViewController.swift
//  TaxiApp
//
//  Created by Developer on 27.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
// MARK: - IBOutlet
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblUserPhone: UILabel!
    
// MARK: - Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            let mapVC = Storyboard.map.instanceOf(viewController: MapViewController.self, identifier: "MapViewController")!
            self.navigationController?.pushViewController(mapVC, animated: true)
        default:
            print(indexPath.row)
        }
    }
}
    

