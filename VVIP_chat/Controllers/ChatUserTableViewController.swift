//
//  ChatUserTableViewController.swift
//  VVIP_chat
//
//  Created by mac on 03/08/21.
//

import UIKit

class ChatUserTableViewController: UITableViewController {
    var vc: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightMenuConfig()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func rightMenuConfig(){
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Search".localized, image: UIImage(systemName: "magnifyingglass"), handler: { (_) in
                }),
                UIAction(title: "New Group".localized, image: UIImage(systemName: "bubble.left.and.bubble.right"), handler: { (_) in
                }),
                UIAction(title: "New Broadcast".localized, image: UIImage(systemName: "ellipsis.bubble"), handler: { (_) in
                }),
                UIAction(title: "Setting".localized, image: UIImage(systemName: "gearshape"), handler: { (_) in
                }),
            ]
        }
        
        var demoMenu: UIMenu {
            return UIMenu(title: "My menu".localized, image: nil, identifier: nil, options: [], children: menuItems)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu".localized, image: UIImage(named:"more-20"), primaryAction: nil, menu: demoMenu)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath)
        
        // Configure the cell...
        //        let vc = (storyboard?.instantiateViewController(withIdentifier: "ChatViewController")) as! ChatViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected item \(indexPath.row)")
        
        vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //        switch indexPath.row {
        //        case 0:
        //            vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //        default:
        //            vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //        }
        self.navigationController?.pushViewController(vc!, animated: true)
        
        //        dismiss(animated: true, completion: nil)
        ////        let vc1 = storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! vc
        //        if(indexPath.row != 0){
        //            self.navigationController?.pushViewController(vc!, animated: false)
        //        } else {
        //            dismiss(animated: true)
        //        }
        
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
