//
//  LaunchViewController.swift
//  BuSG
//
//  Created by Ryan The on 8/12/20.
//

import UIKit

class SetupViewController: ListViewController {
    
    var favouritePlaces = [FavoritePlace]()
        
    func reloadData() {
        let favouritePlacesLocationPickerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        //favouritePlacesLocationPickerView.backgroundColor = .red
//        favouritePlacesLocationPickerView.addSubview(UISegmentedControl(items: ["Hello"]))
        
        func createFavouritePlacesViewController(for index: Int) -> UIViewController {
            ListViewController(data: ListData(sections: [
                ListSection(items: [
                    ListItem(textField: UITextField(frame: CGRect(), placeholder: "Name", text: self.favouritePlaces[index].name, primaryAction: UIAction(handler: { action in
                        let textField = action.sender as! UITextField
                        textField.resignFirstResponder()
                        if let text = textField.text {
                            self.favouritePlaces[index].name = text
                        }
                        self.reloadData()
                    }))),
                    ListItem(textField: UITextField(frame: CGRect(), placeholder: "Nearest Bus Stop Code", text: self.favouritePlaces[index].busStopCode, primaryAction: UIAction(handler: { action in
                        let textField = action.sender as! UITextField
                        textField.resignFirstResponder()
                        
                        if let text = textField.text {
                            self.favouritePlaces[index].busStopCode = text
                        }
                        self.reloadData()
                    })))
                ], footerText: "Enter a descriptive name and the nearest bus stop.")
            ]), footerView: favouritePlacesLocationPickerView)
        }
        
        let favouritePlacesTableItems = favouritePlaces.enumerated().map { (index, place) -> ListItem in
            ListItem(title: place.name, pushViewController: createFavouritePlacesViewController(for: index))
        }
        
        data = ListData(sections: [
//            ListSection(items: favouritePlacesTableItems, headerText: "Favourite Places", footerText: "These places would be used in suggesting buses to take.", headerTrailingButton: UIButton(type: .contactAdd, primaryAction: UIAction(handler: { _ in
//                self.favouritePlaces.append(FavoritePlace(name: ""))
//                self.reloadData()
//                self.navigationController?.pushViewController(createFavouritePlacesViewController(for: self.favouritePlaces.count - 1), animated: true)
//            }))),
            ListSection(items: [
                ListItem(title: "Show Suggestions", accessoryView: UISwitch(frame: CGRect(), isOn: UserDefaults.standard.bool(forKey: K.userDefaults.connectToCalendar), primaryAction: UIAction(handler: {
                    let calendarSwitch = $0.sender as! UISwitch
                    
                    EventProvider.shared.requestForCalendarAccess { (granted, error) in
                        DispatchQueue.main.async {
                            if error != nil || !granted {
                                calendarSwitch.setOn(false, animated: true)
                                let alert = UIAlertController(title: "Unable to access Calendar", message: error?.localizedDescription ?? "In order to access this feature, BuSG requires you to grant access to Calendar in Settings", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                                    URL.open(webURL: UIApplication.openSettingsURLString)
                                }))
                                self.present(alert, animated: true)
                            }
                            UserDefaults.standard.setValue(calendarSwitch.isOn, forKey: K.userDefaults.connectToCalendar)
                        }
                    }
                }))),
            ], headerText: "Events", footerText: "Enabling this allows BuSG to suggest buses based on your Calendar events.")
        ])
        tableView.reloadData()
    }
    
    init() {
        super.init(data: ListData(sections: []), footerView: UIView(frame: CGRect(height: 50+K.margin.two*2)))
        isModalInPresentation = true
        title = "Setup"
        
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIButton(frame: CGRect(), primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        doneButton.backgroundColor = .accent
        doneButton.setTitle("Done", for: .normal)
        doneButton.layer.cornerRadius = K.cornerRadius
        footerView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: K.margin.two),
            doneButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -K.margin.two),
            doneButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -K.margin.two),
            doneButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: K.margin.two),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
