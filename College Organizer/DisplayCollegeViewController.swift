//
//  DisplayCollegeViewController.swift
//  College Organizer
//
//  Created by Wehby, Quinton on 1/6/22.
//

import UIKit

class DisplayCollegeViewController: UIViewController {

    @IBOutlet weak var collegeNameLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var scholarshipLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var notesLabel: UITextView!
    @IBOutlet weak var calenderDayLabel: UILabel!
    
    var portalURL = ""
    var essayURL = ""
    
    var deadline = ""
    
    @IBOutlet weak var accentBackground: UILabel! //color of background
    
    //outlets for portal and essay buttons, used for changing color of them
    @IBOutlet weak var portalButtonO: UIButton!
    @IBOutlet weak var essayButtonO: UIButton!
    
    let defaults = UserDefaults.standard
    var collegeInfoList : [Any] = ["", "", "", "", 0.0, 0.0, 1, 1, ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCollegeInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyLoadFunc(_:)), name: Notification.Name(rawValue: "notifyLoadFunction"), object: nil)
    }
    
    @objc func notifyLoadFunc(_ notification: Notification) { //used to update the data on the screen if it is edited, runs from a notification from the add college VC
        loadCollegeInfo()
    }
    
    func loadCollegeInfo() { //loads the current college info on the screen, gets info from "displayCollegeInfo" saved variable
        collegeInfoList = defaults.array(forKey: "displayCollegeInfo") ?? ["Err3: no college found"]
        print(collegeInfoList)
        
        roundCorners()
        setColors()
        
        fixLinks()
        displayCalender()
        displayCosts()
        decodeTypeStatus()
        
        collegeNameLabel.text = collegeInfoList[0] as? String
        notesLabel.text = collegeInfoList[8] as? String
        
    }
    
    func setColors() { //sets the colors of the background and button from the selected color for the college
        let color = UIColor(hue: collegeInfoList[9] as? CGFloat ?? 0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        accentBackground.backgroundColor = color
        portalButtonO.backgroundColor = color
        essayButtonO.backgroundColor = color
        typeLabel.backgroundColor = color
    }
    
    func displayCalender() { //creates the calander icon based on the deadline for the college
        deadline = collegeInfoList[1] as? String ?? "ERR"
        
        let char1 = deadline[deadline.index(deadline.startIndex, offsetBy: 0)]
        let char2 = deadline[deadline.index(deadline.startIndex, offsetBy: 1)]
        let char3 = deadline[deadline.index(deadline.startIndex, offsetBy: 2)]
        let month = String(char1) + String(char2) + String(char3)

        deadlineLabel.text = month.uppercased()
        
        var day = ""
        let char4 = deadline[deadline.index(deadline.startIndex, offsetBy: 4)]
        let char5 = deadline[deadline.index(deadline.startIndex, offsetBy: 5)]
        if char5 == "," {
            day = String(char4)
        } else {
            day = String(char4) + String(char5)
        }
        calenderDayLabel.text = day
    }
    
    func displayCosts() {//supposed to add commas and a $ to the money, not working 100% right now tho
        var cost = "\(collegeInfoList[4])"// as? String ?? "0"
        var scholarship = "\(collegeInfoList[5])"
        
        /*print("COST: \(cost)")
        let costInt: Int? = Int(cost)
        let scholarshipInt = Int(scholarship)
        print("COST INT: \(costInt)")
        cost = "\(costInt)"
        scholarship = "\(scholarshipInt)"
        print("COST: \(cost)")*/
        print("COST: \(cost)")
        print("cost count: \(cost.count)")
        if cost.count > 6 {
            cost = String(cost.prefix(5))
        } else if cost.count > 5 {
            cost = String(cost.prefix(4))
        }
        if scholarship.count > 6 {
            scholarship = String(scholarship.prefix(5))
        } else if scholarship.count > 5 {
            scholarship = String(scholarship.prefix(4))
        }
        if cost.count == 5 {
            cost.insert(",", at: cost.index(cost.startIndex, offsetBy: 2))
        } else if cost.count == 4 {
            
            cost.insert(",", at: cost.index(cost.startIndex, offsetBy: 1))
        }
        if scholarship.count == 5 {
            scholarship.insert(",", at: scholarship.index(scholarship.startIndex, offsetBy: 2))
        } else if scholarship.count == 4 {
            scholarship.insert(",", at: scholarship.index(scholarship.startIndex, offsetBy: 1))
        }
        costLabel.text = "$\(cost)"
        scholarshipLabel.text = "$\(scholarship)"
    }
    
    func roundCorners() { //function rounds the corners of the buttons on the screen
        let cornerRadius = CGFloat(10)
        let borderWidth = CGFloat(1)
        portalButtonO.layer.cornerRadius = cornerRadius
        portalButtonO.layer.borderWidth = borderWidth
        essayButtonO.layer.cornerRadius = cornerRadius
        essayButtonO.layer.borderWidth = borderWidth
        /*typeLabel.layer.cornerRadius = cornerRadius
        typeLabel.layer.masksToBounds = true*/
        typeLabel.layer.borderWidth = borderWidth
    }
    
    func fixLinks() { // adds "https://" in front of links if they don't have it
        portalURL = collegeInfoList[2] as? String ?? ""
        essayURL = collegeInfoList[3] as? String ?? ""
        
        if portalURL.contains("https://") != true {
            portalURL = "https://\(portalURL)"
        }
        if essayURL.contains("https://") != true {
            essayURL = "https://\(portalURL)"
        }
    }
    
    func decodeTypeStatus() { //this takes the number for the status and college type and sets the button text to the cooresponding type
        var collegeTypeNum = 1
        collegeTypeNum = collegeInfoList[6] as? Int ?? 1
        var collegeType = ""
        switch collegeTypeNum {
        case 1:
            collegeType = "Safety"
        case 2:
            collegeType = "Match"
        case 3:
            collegeType = "Reach"
        default:
            break
        }
        typeLabel.text = collegeType
        
        var collegeStatusNum = 1
        collegeStatusNum = collegeInfoList[7] as? Int ?? 1
        var collegeStatus = ""
        switch collegeStatusNum {
        case 1:
            collegeStatus = "Incomplete"
        case 2:
            collegeStatus = "Applied"
        case 3:
            collegeStatus = "Accepted"
        case 4:
            collegeStatus = "Denied"
        default:
            break
        }
        statusLabel.text = "Status: \(collegeStatus)"
        
    }

    @IBAction func portalButton(_ sender: Any) { // opens the link for the portal when this button is pressed
        UIApplication.shared.open(NSURL(string: portalURL)! as URL)
    }
    @IBAction func essayButton(_ sender: Any) { // opens the link for the essay when this button is pressed
        UIApplication.shared.open(NSURL(string: essayURL)! as URL)
    }
    
    @IBAction func backButton(_ sender: Any) { //dismisses view controller when the back button is pressed
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) { // sets editBool to 1 and opens the addCollege VC while loading the current college info to make it an edit screen
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "editBool")
        guard let vc = storyboard?.instantiateViewController(identifier: "AddCollege_vc") as? AddCollegeViewController else {
            return
        }
        defaults.set(collegeInfoList, forKey: "editCollege")
        present(vc, animated: true)
    }
    

}
