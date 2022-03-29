//
//  ViewController.swift
//  College Organizer
//
//  Created by Wehby, Quinton on 1/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    var newButtonY = 0 //takes current college number and sets the height of the button for it
    var collegeInfoList : [Any] = ["", "", "", "", 0.0, 0.0, 1, 1, ""] //list of all data for a college
    var tempCollegeInfoList : [Any] = ["", "", "", "", 0.0, 0.0, 1, 1, ""]
    var tempCollegeNum = 1
    let defaults = UserDefaults.standard
    
    var buttonList : [UIButton] = [] //list of all generated buttons, used to remove them
    
    var clearDataBool = 0 //safety net for clearing data rn, have to click clear button 10 times
    
    let changeY = 15 //used to change the height of the buttons w/o messing up code
    
    @IBOutlet weak var upcomingDeadlineView: UITextView!
    var collegeDeadlineList : [String] = [] //list of deadlines
    var collegeDeadlineListName : [String] = [] //list of names
    var newNameArray : [String] = [] //list of names in order of deadlines
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //defaults.set(5, forKey: "numberOfColleges")
        newButtonY = defaults.integer(forKey: "numberOfColleges")
        print("newButtonY: \(newButtonY)")
        if newButtonY != 0 {
        generateExistingButtons()
        }
        
        
        newButtonY = defaults.integer(forKey: "numberOfColleges")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(runAddButton(_:)), name: Notification.Name(rawValue: "addButtonNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadButtons(_:)), name: Notification.Name(rawValue: "reloadButtons"), object: nil)

    }
    
    public func addButton(CollegeName: String, buttonHeight: Int) { //func that makes a new button for a college
        
        newButtonY = buttonHeight
        newButtonY *= 65
        newButtonY += (105-changeY)
        
        let cornerRadius = CGFloat(10)
        let borderWidth = CGFloat(1)
        
        
        let button = UIButton(frame: CGRect(x: Int(self.view.frame.size.width)/2 - 150, y: newButtonY, width: 300, height: 50))
        button.backgroundColor = UIColor(hue: collegeInfoList[9] as? CGFloat ?? 0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        button.setTitle(CollegeName, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = borderWidth
        
        buttonList.append(button)
        
          self.view.addSubview(button)
    }
    
    @objc func runAddButton(_ notification: Notification) { //gets notified by save function, runs the add button function with the correct info
        
        newButtonY = defaults.integer(forKey: "numberOfColleges")
        collegeInfoList = defaults.array(forKey: "collegeInfo" + String(newButtonY)) ?? ["Err: no college found"]
        let collegeNameString = collegeInfoList[0]
        addButton(CollegeName: collegeNameString as! String, buttonHeight: newButtonY)
    }
    
    func generateExistingButtons() { //This is called right when the view loads, it generates the existing buttons
        newButtonY = defaults.integer(forKey: "numberOfColleges")
        
        collegeDeadlineList = []
        collegeDeadlineListName = []
        newNameArray = []
        
        for i in 1...newButtonY {
            collegeInfoList = defaults.array(forKey: "collegeInfo" + String(i)) ?? ["Err: no college found"]
            let collegeNameString = collegeInfoList[0]
            
            generateDeadlineView(collegeDeadline: "\(collegeInfoList[1])")
            generateDeadlineViewName(collegeName: "\(collegeInfoList[0])")
            
            print("Attempt \(i) College: \(collegeNameString)")
            addButton(CollegeName: collegeNameString as! String, buttonHeight: i)
        }
        formatDates(testArray: collegeDeadlineList)
        
    }
    
    @objc func buttonAction(sender: UIButton!) { //this is the function that runs when one of the college buttons are pressed
        
        guard let vc = storyboard?.instantiateViewController(identifier: "DisplayCollege_vc") as? DisplayCollegeViewController else {
            return
        }
        
        
        
        var buttonTag = String(describing: sender)
        print("Button tapped from sender: \(buttonTag)")
        let char1 = buttonTag[buttonTag.index(buttonTag.startIndex, offsetBy: 45)]
        let char2 = buttonTag[buttonTag.index(buttonTag.startIndex, offsetBy: 46)]
        let char3 = buttonTag[buttonTag.index(buttonTag.startIndex, offsetBy: 47)]
        buttonTag = String(char1)+String(char2)+String(char3)
        
        
        var buttonNum = Int(buttonTag)
        buttonNum! += changeY
        switch buttonNum {
        case 170:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo1") ?? ["Err2: no college found"]
            tempCollegeNum = 1
        case 235:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo2") ?? ["Err2: no college found"]
            tempCollegeNum = 2
        case 300:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo3") ?? ["Err2: no college found"]
            tempCollegeNum = 3
        case 365:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo4") ?? ["Err2: no college found"]
            tempCollegeNum = 4
        case 430:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo5") ?? ["Err2: no college found"]
            tempCollegeNum = 5
        case 495:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo6") ?? ["Err2: no college found"]
            tempCollegeNum = 6
        case 560:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo7") ?? ["Err2: no college found"]
            tempCollegeNum = 7
        case 625:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo8") ?? ["Err2: no college found"]
            tempCollegeNum = 8
        case 690:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo9") ?? ["Err2: no college found"]
            tempCollegeNum = 9
        case 755:
            tempCollegeInfoList =  defaults.array(forKey: "collegeInfo10") ?? ["Err2: no college found"]
            tempCollegeNum = 10
        default:
            break
        }
        defaults.set(tempCollegeInfoList, forKey: "displayCollegeInfo")
        defaults.set(tempCollegeNum, forKey: "tempCollegeNum")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        print("Button tapped from sender: \(buttonTag)")
    }
    
    
    @IBAction func clearDataButton(_ sender: Any) { // func ran when clear button is pressed, deletes all saved data
        if clearDataBool == 9 {
        print("resetting data")
        //resetDefaults()
        //clearButtons()
        } else {
            clearDataBool += 1
        }
    }
    
    func resetDefaults() { //deletes all saved data
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    @IBAction func addCollegeButton(_ sender: Any) { // when the add college button is pressed it sets the "editBool" to zero meaning it will load up the add college view controller with no data filled in
        defaults.set(0, forKey: "editBool")
    }
    

    
    func clearButtons() { //instantly clears the existing college buttons from the view
        for item in buttonList{
            item.removeFromSuperview()
        }
    }
    
    @objc func reloadButtons(_ notification: Notification) { //clears and re-generates the college buttons, called when something is edited or deleted
        print("reloading buttons")
        clearButtons()
        generateExistingButtons()
    }
    
    func generateDeadlineView(collegeDeadline: String) { //When generating the buttons this function is called, it adds all the deadlines to a list
        collegeDeadlineList.append(collegeDeadline)
        
    }
    
    func generateDeadlineViewName(collegeName: String) { //When generating the buttons this function is called, it adds all the college names to a list
        collegeDeadlineListName.append(collegeName)
        
    }
    
    func formatDates(testArray: Array<String>) { //this puts the date in the correct format and in calender order for the upcoming deadlines
        
        print("running formatter")
        print("Test array: \(testArray)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let regularArray = testArray.compactMap(dateFormatter.date(from:))
        var convertedArray = testArray
            .compactMap(dateFormatter.date(from:))
            .sorted(by: >)
        
        
        formatNames(convertedArray: convertedArray, regularArray: regularArray, nameArray: collegeDeadlineListName)
        
        var convString = ""
        var x = 0
        convertedArray.reverse()
        newNameArray.reverse()
        for item in convertedArray {
            
            if item > Date() {
            
                let item2 = "\(item)"
                let item3 = item2.prefix(10)
                let year = item3.prefix(4)
                let month = item3.prefix(7).suffix(2)
                let day = item3.suffix(2)
                let item5 = month + "-" + day + "-" + year
                convString = convString + "\(newNameArray[x]): " + "\(item5) \n"
            }
            
            x += 1
        }
        upcomingDeadlineView.text = convString
    }
    
    func formatNames(convertedArray: [Date], regularArray: [Date], nameArray: [String]) { //This function matches the name of the college with the cooresponding deadline, not sure what happens if two colleges have the same one
        
        var x = 0
        for itemConverted in convertedArray {
            x = 0
            for itemRegular in regularArray {
                
                if itemRegular == itemConverted {
                    newNameArray.append(nameArray[x])
                }
                x += 1
            }
        }
        print(newNameArray)
    }
    
    
    
}

