//
//  ViewController.swift
//  CoreMoboKeyExample
//
//  Created by Hadi on 27/03/2019.
//  Copyright © 2019 RoboArt. All rights reserved.
//

import UIKit
import CoreMoboKey

class ViewController: UIViewController, MKHandlerDelegate {

    var moboKey: MKHandler!
    @IBOutlet weak var bluetoothStatusLabel: UILabel!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var carTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var smartKeyOnButton: UIButton!
    @IBOutlet weak var smartKeyOffButton: UIButton!
    @IBOutlet weak var accOnButton: UIButton!
    @IBOutlet weak var accOffButton: UIButton!
    @IBOutlet weak var powerOnButton: UIButton!
    @IBOutlet weak var powerOffButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableButtons()
        moboKey = MKHandler(delegate: self)
        
    }
    
    
    func disableButtons(){
        
        lockButton.isEnabled = false
        unlockButton.isEnabled = false
        carTypeSegmentedControl.isEnabled = false
        smartKeyOnButton.isEnabled = false
        smartKeyOffButton.isEnabled = false
        startButton.isEnabled = false
        stopButton.isEnabled = false
        accOnButton.isEnabled = false
        accOffButton.isEnabled = false
        powerOnButton.isEnabled = false
        powerOffButton.isEnabled = false
    }
    
    func enableButtons(){
        
        lockButton.isEnabled = true
        unlockButton.isEnabled = true
        carTypeSegmentedControl.isEnabled = true
        startButton.isEnabled = true
        stopButton.isEnabled = true
    }

    
    @IBAction func didTapLockButton() {
        
        moboKey.lock()
        
    }
    
    func didFailToPerformAction() {
        // try again?
    }
    
    
    @IBAction func didTapUnlockButton() {
        
        moboKey.unlock()
        
    }
    
    @IBAction func didTapCarTypeSelectionControl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            
            print("Key Start was tapped")
            moboKey.changeCarType(type: .keyStart)
            
        }else{
            
            print("Push Start was tapped")
            moboKey.changeCarType(type: .pushStart)
            
        }
        
    }
    
    @IBAction func didTapSmartKeyOnButton() {
        
        moboKey.smartKeyOn()
        
    }
    
    @IBAction func didTapSmartKeyOffButton() {
        
        moboKey.smartKeyOff()
        
    }
    
    @IBAction func didTapAccOnButton() {
        moboKey.accOn()
    }
    
    @IBAction func didTapAccOffButton() {
        moboKey.accOff()
    }
    
    @IBAction func didTapPowerOnButton() {
        moboKey.powerOn()
    }
    
    @IBAction func didTapPowerOffButton() {
        moboKey.powerOff()
    }
    
    @IBAction func didTapStartButton() {
        
        moboKey.start()
        
    }
    
    
    @IBAction func didTapStopButton() {
        
        moboKey.stop()
        
    }
    
    // MARK: MKHandlerDelegate functions
    
    func masterKeyRequired() {
        
        //send the current master key, default is 1010
        moboKey.verifyMasterKey("1010")
        
    }
    
    func isReadyForScan() {
        
        //you can start a time before you start scan, and after let's say
        //10-20 seconds you could show timeout, no device found.
        moboKey.startScan(forTimeInSeconds: 7)
        //moboKey.startScan(for seconds: 300
        //moboKey.startScan(forSeconds: 10)
        
        
    }
    
    
    func bluetoothIsOff() {
        
        print("Bluetooth is off. Kindly turn it on.")
        bluetoothStatusLabel.text = "Bluetooth is off. Turn it on"
    }
    
    func didDisconnect() {
        
        print("MoboKey disconnected")
        //moboKey.startScan(forTimeInSeconds: 10)
        
    }
    
    func didUnlock() {
        print("Car was unlocked")
    }
    
    func didLock() {
        print("Car was locked")
    }
    
    func didFailToConnect() {
        
        //moboKey.stopScan()
        print("Connection Error: Failed to connect to MoboKey")
    }
    
    func didFailToCommunicate(error: Error) {
        print("Failed to communicate with MoboKey")
    }
    
    func didDiscoverNewDevice(_ device: MoboKey) {
        print("New device: \(device.mac)")
        //20:91:48:2D:63:F4
//        if device.mac == "20:91:48:2D:63:F4"{
//            moboKey.connectToMoboKey(device)
//        }
        moboKey.connectToMoboKey(device)
    }
    
    //Once you recieve this call, you can now call, lock/unlock.
    func masterKeyVerified() {
        
        //stop the scanning
        //moboKey.stopScan()
        bluetoothStatusLabel.text = "Connected"
        
        //Get current state for Car Type (Key Start or Push Start)
        moboKey.getCurrentCarType()
        
        enableButtons()
        print("Device is ready. Now you can call moboKey.lock() / moboKey.unlock()")
        if let id = moboKey.getIdentifier(){
            print("Device Id: \(id)")
        }
        if let mac = moboKey.getMACAddress(){
            print("Device MAC: \(mac)")
        }
        
        moboKey.getCurrentLockState { (isLocked, error)  in
            
            if error != nil{
                
                if error == .notConnected{
                    print("not connected to device")
                }
               return
            }
            
            print("isLocked: \(isLocked!)")
        }
        
        //Before calling these methods kindly make sure Car type is .keyStart.
        
        moboKey.getCurrentAccState { (isAccOn, error) in
            
            if error != nil{
                
                if error == .notConnected{
                    print("not connected to device")
                }
               return
            }
            
            print("isAccOn: \(isAccOn!)")
        }
        
        moboKey.getCurrentPowerState { (isPowerOn, error) in
            
            if error != nil{
                
                if error == .notConnected{
                    print("not connected to device")
                }
               return
            }
            
            print("isPowerOn: \(isPowerOn!)")
        }
        
        moboKey.getCurrentStartState { (isStart, error) in
            
            if error != nil{
                
                if error == .notConnected{
                    print("not connected to device")
                }
               return
            }
            
            print("isStart: \(isStart!)")
        }
        
        
        
    }
    
    @IBAction func changeRegularKey(){
        moboKey.changeRegularKey(currentMasterKey: "1010", newKey: "1111")
    }
    
    @IBAction func changeMasterKey(){
        moboKey.changeMasterKey(currentMasterKey: "1010", newKey: "1111")
    }
    
    func bluetoothUnauthorized() {
        print("User denied access to iOS's Bluetooth.")
    }
    
    func masterKeyWasInvalid() {
        
        bluetoothStatusLabel.text = "Invalid master key"
        print("You are trying with invalid master key")
    
    }
    
    func didStart(error: NSError?) {
        if let error = error{
            
            //let code = error.code
            
            let alert = UIAlertController(title: "Error", message: error.domain, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            print("Car has started (or stopped, in case of Push Start)")
            
        }
    }
    
    
    
    func accIsOn(error: NSError?) {
        if let error = error{
            print(error.description)
        }else{
            print("ACC is on")
        }
        
    }
    
    func accIsOff() {
        print("ACC is off")
    }
    
    func powerIsOn(error: NSError?) {
        if let error = error{
            print(error.description)
        }else{
            print("Power is on")
        }
    }
    
    func powerIsOff() {
        print("Power is off")
    }

    
    func didStop() {
        
        print("Car has stopped")
        
    }
    
    func smartKeyIsEnabled() {
        print("SmartKey is enabled")
    }
    
    func smartKeyIsDisabled() {
        print("SmartKey is disabled")
    }
    
    func didChangeCarType(type: CarType) {
        
        if type == .keyStart{
            
            print("Car type was changed to Key Start")
            carTypeSegmentedControl.selectedSegmentIndex = 0
            carTypeLabel.text = "Key Start"
            
            //disable smartkey buttons because these are only for Push Start cars.
            smartKeyOnButton.isEnabled = false
            smartKeyOffButton.isEnabled = false
            accOnButton.isEnabled = true
            accOffButton.isEnabled = true
            powerOnButton.isEnabled = true
            powerOffButton.isEnabled = true
            
        }else{
            print("Car type was changed to Push Start")
            carTypeSegmentedControl.selectedSegmentIndex = 1
            carTypeLabel.text = "Push Start"
            smartKeyOnButton.isEnabled = true
            smartKeyOffButton.isEnabled = true
            accOnButton.isEnabled = false
            accOffButton.isEnabled = false
            powerOnButton.isEnabled = false
            powerOffButton.isEnabled = false
        }
        
    }
    
    @IBAction func didTapLockStatus() {
        moboKey.getCurrentLockState { (isLocked, error) in
            
            if error != nil{
                
                if error == .notConnected{
                    print("Not connected to MoboKey device")
                }
                
                return
            }
            
            print("isLocked: \(isLocked!)")
            if isLocked! {
                self.statusLabel.text = "Car is locked"
            }else{
                self.statusLabel.text = "Car is unlocked"
            }
        }
        
    }
    
    
    @IBAction func didTapAccStatus() {
        //Before calling these methods kindly make sure Car type is .keyStart.
        
        moboKey.getCurrentAccState { (isAccOn, error) in
            
            if error != nil{
                
                if error == .notConnected{
                    print("Not connected to MoboKey device")
                }
                
                return
            }
            
            print("isAccOn: \(isAccOn!)")
            if isAccOn! {
                self.statusLabel.text = "Acc is on"
            }else{
                self.statusLabel.text = "Acc is off"
            }
        }
        
        
    }
    
    @IBAction func didTapPowerStatus() {
        moboKey.getCurrentPowerState { (isPowerOn, error) in
            
            if error != nil{
                
                if error == .notConnected{
                    print("Not connected to MoboKey device")
                }
                
                return
            }
            
            print("isPowerOn: \(isPowerOn!)")
            if isPowerOn! {
                self.statusLabel.text = "Power is on"
            }else{
                self.statusLabel.text = "Power is off"
            }
        }
        
    }
    
    @IBAction func didTapStartStatus() {
        moboKey.getCurrentStartState { (isStart, error) in
            
            if error != nil{
                
                if error == .notConnected{
                    print("Not connected to MoboKey device")
                }
                
                return
            }
            
            print("isStart: \(isStart!)")
            if isStart! {
                self.statusLabel.text = "Engine is on"
            }else{
                self.statusLabel.text = "Engine is off"
            }
        }
    }
    
    
    //KEYS MANAGEMENT
    
    func didChangeMasterKey(error: MKError?) {
        //
        if error == nil{
            print("master key changed")
        }else{
            print("error in changing master key")
        }
    }
    
    func didChangeRegularKey(error: MKError?) {
        if error == nil{
            print("regular key changed")
        }else{
            print("error in changing regular key")
        }
    }
    
    func didVerifyRegularKey(error: MKError?) {
        //
    }
    
    func regularKeyVerified() {
        //
    }
    
    func regularKeyWasInvalid() {
        //
    }
    
    func regularKeyRequired() {
        //
    }

}
