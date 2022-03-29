//
//  AddCollegeViewController.swift
//  College Organizer
//
//  Created by Wehby, Quinton on 1/4/22.
//

import UIKit



class AddCollegeViewController: UIViewController {

    //all the text fields for the screen
    @IBOutlet weak var applicationDeadline: UITextField!
    @IBOutlet weak var collegeName: UITextField!
    @IBOutlet weak var portalLink: UITextField!
    @IBOutlet weak var essayLink: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var scholarship: UITextField!
    //@IBOutlet weak var notes: UITextField!
    @IBOutlet weak var notes: UITextView!
    
    //college type button outlets
    @IBOutlet weak var safetyButton: UIButton!
    @IBOutlet weak var matchButton: UIButton!
    @IBOutlet weak var reachButton: UIButton!
    
    //status type button outlets
    @IBOutlet weak var incompleteButton: UIButton!
    @IBOutlet weak var appliedButton: UIButton!
    @IBOutlet weak var acceptedButton: UIButton!
    @IBOutlet weak var deniedButton: UIButton!
    
    //square and slider for color selector, outlets
    @IBOutlet weak var colorSquare: UILabel!
    @IBOutlet weak var colorSliderO: UISlider!
    
    //outlet for save button, honestly dont think i need this
    @IBOutlet weak var saveButtonO: UIButton!
    
    let defaults = UserDefaults.standard
    
    var collegeNameString = ""
    var applicationDeadlineString = ""
    var portalLinkString = ""
    var essayLinkString = ""
    var costString = ""
    var scholarshipString = ""
    var costInt = 0.0
    var scholarshipInt = 0.0
    var notesString = ""
    var matchTypeInt = 1
    var statusInt = 1
    
    var collegeInfoList : [Any] = ["", "", "", "", 0.0, 0.0, 1, 1, "", ""]
    var collegeKey = "collegeInfo"
    var collegeKeyNum = 0
    
    //used for saving color and setting color square color
    var colorValue = CGFloat(0)
    var color = UIColor(hue: 1, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    
    //scroll wheel for deadline
    let datePicker = UIDatePicker()
    var editBool = 0 //determines if it is used for editing or adding college
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createDatePicker()
        
        let defaults = UserDefaults.standard
        editBool = defaults.integer(forKey: "editBool")
        if editBool == 1 {
            createDeleteButton()
            createEditScreen()
        }
        
 
        
    }
    
    @IBAction func saveButton(_ sender: Any) { //ran when save button is pressed, saves data
        
        var addButtonBool = 0
        collegeKeyNum = defaults.integer(forKey: "numberOfColleges")
        
        if editBool == 0 {
        collegeKeyNum += 1
        defaults.set(collegeKeyNum, forKey: "numberOfColleges")
        addButtonBool = 1
        } else {
            
            collegeKeyNum = defaults.integer(forKey: "tempCollegeNum")
            defaults.set(0, forKey: "editBool")
        }
        
        collegeKey = "collegeInfo" + String(collegeKeyNum)
        
        collegeNameString = collegeName.text!
        applicationDeadlineString = applicationDeadline.text!
        portalLinkString = portalLink.text!
        essayLinkString = essayLink.text!
        notesString = notes.text!
        costString = cost.text!
        scholarshipString = scholarship.text!
        let removeCharacters: Set<Character> = [",", "$"]
        costString.removeAll(where: { removeCharacters.contains($0) } )
        scholarshipString.removeAll(where: { removeCharacters.contains($0) } )
        costInt = Double(costString) ?? 0.0
        scholarshipInt = Double(scholarshipString) ?? 0.0
        
        collegeInfoList[0] = collegeNameString
        collegeInfoList[1] = applicationDeadlineString
        collegeInfoList[2] = portalLinkString
        collegeInfoList[3] = essayLinkString
        collegeInfoList[4] = String(costInt)
        collegeInfoList[5] = String(scholarshipInt)
        collegeInfoList[6] = matchTypeInt
        collegeInfoList[7] = statusInt
        collegeInfoList[8] = notesString
        collegeInfoList[9] = colorValue
        
        defaults.set(collegeInfoList, forKey: collegeKey)
        defaults.set(collegeInfoList, forKey: "displayCollegeInfo")
        
        collegeInfoList = defaults.array(forKey: collegeKey) ?? []
        print(collegeInfoList)
        if addButtonBool == 1 {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addButtonNotification"), object: nil)
        }
        addButtonBool = 0
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notifyLoadFunction"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadButtons"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func createDeleteButton() { //function deletes save button, makes a new one and a delete button when the user selects edit on a college
        print("creating edit button")
        saveButtonO.removeFromSuperview()
        
        let button = UIButton(frame: CGRect(x: 225, y: 765, width: 150, height: 40))
        button.backgroundColor = .systemRed
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        
        let button2 = UIButton(frame: CGRect(x: 45, y: 765, width: 150, height: 40))
        button2.backgroundColor = .systemBlue
        button2.setTitle("Save", for: .normal)
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button2.addTarget(self, action: #selector(saveButton(_:)), for: .touchUpInside)
        
        self.view.addSubview(button)
        self.view.addSubview(button2)
    }
    
    @objc func deleteButtonAction(sender: UIButton!) { //ran when user clicks delete, gets rid of college, reformatts colleges to correct spot, refreshed buttons on VC1
        
        let numberOfColleges = defaults.integer(forKey: "numberOfColleges")
        collegeKeyNum = defaults.integer(forKey: "tempCollegeNum")
        collegeKey = "collegeInfo" + String(collegeKeyNum)
        
        if collegeKeyNum<numberOfColleges {
            for i in collegeKeyNum...(numberOfColleges-1) {
                defaults.set(defaults.array(forKey: "collegeInfo" + String(i+1)) ?? ["Err: no college found"], forKey: "collegeInfo" + String(i))
            }
        }
        
        defaults.set(numberOfColleges-1, forKey: "numberOfColleges")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notifyLoadFunction"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadButtons"), object: nil)
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func safetyButton(_ sender: Any) {
        safetyButton.backgroundColor = .systemGreen
        matchButton.backgroundColor = .darkGray
        reachButton.backgroundColor = .darkGray
        matchTypeInt = 1
    }
    @IBAction func matchButton(_ sender: Any) {
        safetyButton.backgroundColor = .darkGray
        matchButton.backgroundColor = .systemOrange
        reachButton.backgroundColor = .darkGray
        matchTypeInt = 2
    }
    @IBAction func reachButton(_ sender: Any) {
        safetyButton.backgroundColor = .darkGray
        matchButton.backgroundColor = .darkGray
        reachButton.backgroundColor = .systemRed
        matchTypeInt = 3
    }
    @IBAction func incompleteButton(_ sender: Any) {
        incompleteButton.backgroundColor = .systemRed
        appliedButton.backgroundColor = .darkGray
        acceptedButton.backgroundColor = .darkGray
        deniedButton.backgroundColor = .darkGray
        statusInt = 1
    }
    @IBAction func appliedButton(_ sender: Any) {
        incompleteButton.backgroundColor = .darkGray
        appliedButton.backgroundColor = .systemGreen
        acceptedButton.backgroundColor = .darkGray
        deniedButton.backgroundColor = .darkGray
        statusInt = 2
    }
    @IBAction func acceptedButton(_ sender: Any) {
        incompleteButton.backgroundColor = .darkGray
        appliedButton.backgroundColor = .darkGray
        acceptedButton.backgroundColor = .systemGreen
        deniedButton.backgroundColor = .darkGray
        statusInt = 3
    }
    @IBAction func deniedButton(_ sender: Any) {
        incompleteButton.backgroundColor = .darkGray
        appliedButton.backgroundColor = .darkGray
        acceptedButton.backgroundColor = .darkGray
        deniedButton.backgroundColor = .systemRed
        statusInt = 4
    }
    
    func resetDefaults() { //dont think this can even be called, not removing this for now tho
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    @IBAction func colorSlider(_ sender: UISlider) { //updates the color square when the slider is moved
        colorValue = CGFloat(sender.value)
        color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        colorSquare.backgroundColor = color
    }
    
    func createDatePicker() { //function creates the scroll wheel for the deadline selector
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        datePicker.preferredDatePickerStyle = .wheels
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        applicationDeadline.inputAccessoryView = toolbar
        
        applicationDeadline.inputView = datePicker
        datePicker.datePickerMode = .date
        
    }
    
    func createEditScreen() { //when this view controller is being used as an edit screen this function is called to put all of the existing data into the view controller
        
        
        var collegeInfoList1 : [Any] = ["", "", "", "", 0.0, 0.0, 1, 1, "", ""]
        collegeInfoList1 = defaults.array(forKey: "editCollege") ?? ["Err3: no college found"]
        
        applicationDeadline.text = "\(collegeInfoList1[1])"
        collegeName.text = "\(collegeInfoList1[0])"
        portalLink.text = "\(collegeInfoList1[2])"
        essayLink.text = "\(collegeInfoList1[3])"
        cost.text = "\(collegeInfoList1[4])"
        scholarship.text = "\(collegeInfoList1[5])"
        notes.text = "\(collegeInfoList1[8])"
        
        colorSliderO.value = collegeInfoList1[9] as? Float ?? 0.5
        colorValue = CGFloat(colorSliderO.value)
        color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        colorSquare.backgroundColor = color
        
        safetyButton.backgroundColor = .darkGray
        matchButton.backgroundColor = .darkGray
        reachButton.backgroundColor = .darkGray

        incompleteButton.backgroundColor = .darkGray
        appliedButton.backgroundColor = .darkGray
        acceptedButton.backgroundColor = .darkGray
        deniedButton.backgroundColor = .darkGray
        
        var collegeTypeNum = 1
        collegeTypeNum = collegeInfoList1[6] as? Int ?? 1
        switch collegeTypeNum {
        case 1:
            safetyButton.backgroundColor = .systemGreen
        case 2:
            matchButton.backgroundColor = .systemOrange
        case 3:
            reachButton.backgroundColor = .systemRed
        default:
            break
        }
        
        var collegeStatusNum = 1
        collegeStatusNum = collegeInfoList1[7] as? Int ?? 1

        switch collegeStatusNum {
        case 1:
            incompleteButton.backgroundColor = .systemRed
        case 2:
            appliedButton.backgroundColor = .systemGreen
        case 3:
            acceptedButton.backgroundColor = .systemGreen
        case 4:
            deniedButton.backgroundColor = .systemRed
        default:
            break
        }
        
        
    }
    
    @objc func donePressed() { //runs when done is pressed on the deadline scroll wheel, puts the date into the text field
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        applicationDeadline.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}
