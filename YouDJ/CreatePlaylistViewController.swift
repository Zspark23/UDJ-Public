//
//  CreatePlaylistViewController.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/13/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class CreatePlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        descriptionTextView.delegate = self
        descriptionTextView.text = "Enter description"
        descriptionTextView.textColor = UIColor.lightGrayColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("createPlaylistMemberCell") as? AddMemberTableViewCell
        let user = PlaylistController.sharedInstance.membersInPlaylist[indexPath.row]
        cell?.configureCellWithUser(user)
        return cell!
    }
    
    @IBAction func createPlaylistButtonTapped(sender: UIBarButtonItem)
    {
        PlaylistController.sharedInstance.createPlaylistWithTitle(self.nameTextField.text!, description: self.descriptionTextView.text)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaylistController.sharedInstance.membersInPlaylist.count
    }
    
    // MARK: - TableView Header
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! CreatePlaylistHeaderTableViewCell
        return headerCell.contentView
    }
    
    // Unwind Segue
    @IBAction func unwindForSegue(unwindSegue: UIStoryboardSegue, user: User) {
        let findFriendsVC = unwindSegue.sourceViewController as? FindFriendsViewController
        
    }
    
}

extension CreatePlaylistViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGrayColor() {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Enter description"
            descriptionTextView.textColor = UIColor.lightGrayColor()
        }
    }
}





