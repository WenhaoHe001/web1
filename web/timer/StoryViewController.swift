//
//  StoryViewController.swift
//  timer
//
//  Created by kevinhe on 2019/11/13.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit
import MobileCoreServices
import os.log


class StoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    //MARK: -  properties
    var storyContent: String?
//    var datas = [Data]()
    var dataInfo = [Story.DataInfo]()
    
    var issegueFromClearVC: Bool = false
//    var story: Story = Story()
    
    private var isConfirmed: Bool = false
    private var hideDeleteBtn: Bool = false
    
    var deleteIndexPath: IndexPath?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: String? {
        didSet {
            dateLabel?.text = "Date: \((date!))"

        }
    }
//    let imageView = UIImageView()
    var imageViews = [UIImageView]()
    
    func setUpImageView(_ image: UIImage?, imagecenterx: Int?, imagecentery: Int?, imagewidth: Int?, imageheight: Int?){
        let oneImageView = UIImageView()
        oneImageView.frame.size = CGSize(width: imagewidth ?? 150,
                                         height: imageheight ?? 150)
        oneImageView.center = CGPoint(x: imagecenterx ?? 50 + 50*imageViews.count,
                                      y: imagecentery ?? 50 + 50*imageViews.count)
        oneImageView.image = image
        
//        oneImageView.sizeToFit()
        oneImageView.isUserInteractionEnabled = true
        
        addDeleteButton(oneImageView)
        
        storyContentView.addEmojiArtGestureRecognizers(to: oneImageView)
        imageViews.append(oneImageView)
        storyContentView.addSubview(oneImageView)

    }
    
    func addDeleteButton(_ imageview:UIImageView){
        print("addDeleteButton")
        let button = UIButton()
        button.isHidden = false
        button.frame.size = CGSize(width: 30, height: 30)
        button.tag = imageViews.count
        button.backgroundColor = .blue
        button.frame.origin =  CGPoint(x: imageview.bounds.maxX-15, y: imageview.bounds.minY-15)
        button.addTarget(self, action: #selector(deleteView), for: UIControl.Event.touchUpInside)
        imageview.addSubview(button)
    }
    
    @objc func deleteView(_ sender: UIButton){
        print("deleteView")
        if storyContentView.selectedSubview != nil {
        storyContentView.selectedSubview?.removeFromSuperview()
        let index = sender.tag
        imageViews.remove(at: index)
        }
    }
    
    var image: UIImage? {
        didSet {
            setUpImageView(image, imagecenterx: nil, imagecentery: nil, imagewidth: nil, imageheight: nil)
//            imageView.frame = CGRect(x: 50, y: 0, width: 150, height: 150)
//            imageView.image = image
//            imageView.backgroundColor = UIColor.red
//            imageView.isUserInteractionEnabled = true
//            storyContentView.addEmojiArtGestureRecognizers(to: imageView)
//            storyContentView.addSubview(imageView)

//            
//            imageView.addGestureRecognizer(pinGesture)
        }
        
    }
    
    
    
    

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var camera: UIBarButtonItem! {
        didSet {
            
                camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectImage =  (info[UIImagePickerController.InfoKey.editedImage] ?? info[UIImagePickerController.InfoKey.originalImage]) as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
//        if let jpegData = selectImage.jpegData(compressionQuality: 1.0){
//
//        }
        
        image = selectImage
        //        mealPhoto.image = selectImage
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: -UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return Story.Mood.All.count
        case 1: return Story.Weekday.All.count
        default:
            return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return Story.Mood.All[row].rawValue
        case 1: return Story.Weekday.All[row].rawValue
        default:
            return "ok"
        }
//        return String(row)+"-"+String(component)
    }
    

    //MARK: - properties
    
    @IBOutlet weak var weekdayPickView: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekdayPickView.dataSource = self
        weekdayPickView.delegate = self
        weekdayPickView.selectRow(0, inComponent: 0, animated: true)
        weekdayPickView.selectRow(0, inComponent: 1, animated: true)
        // Do any additional setup after loading the view.
        
//        if !datas.isEmpty {
//            for data in datas {
//                let image = UIImage(data: data)
//                setUpImageView(image)
//            }
//            imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
//            imageView.isUserInteractionEnabled = true
//            imageView.image = image
//            storyContentView.addEmojiArtGestureRecognizers(to: imageView)
//            storyContentView.addSubview(imageView)

//            storyContentView.addEmojiArtGestureRecognizers(to: imageView)
            
//        }
//        if !issegueFromClearVC {
        print("story viewDidLoad")
        imageViews = []
        
        if !dataInfo.isEmpty {
            for datainfo in dataInfo {
                if datainfo.data != nil, let image = UIImage(data: datainfo.data!) {
                    let x = datainfo.x
                    let y = datainfo.y
                    let width = datainfo.width
                    let height = datainfo.height
                setUpImageView(image, imagecenterx: x, imagecentery: y, imagewidth: width, imageheight: height)

                
                }
            }
            if !issegueFromClearVC {
              dataInfo = []
            }
        }
        

    }
    
    
    //MARK:- recover from deletVC
    @objc private func recoverFromDeletVC(){
        //do recover thing
        //1. update timeModel
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("timeRecord") {
            if let jsonData = try? Data(contentsOf: url) {
                if var timeModel = TimeModel(json: jsonData) {
                    timeModel.records.append(date ?? " ")
                    
                    timeModel.story.append(Story(story: storyContent!, weekday: nil, mood: nil, dataInfo: dataInfo))
                    
                    do {
                        try timeModel.json?.write(to: url)
                        os_log("timeModel is saved", log: OSLog.default, type: OSLogType.default)
                    } catch {
                        os_log("timeModel is not saved", log: OSLog.default, type: .error)
                    }
                }
            }
        }
        
        //2.update deleteModel
        
        if let url = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("clearedTimeModel") {
            if let jsondata = try? Data(contentsOf: url) {
                if var deletedTimeModels = TimeModels(json: jsondata) {
                    guard let indexpath = deleteIndexPath else {fatalError("no selectIndex")}
            deletedTimeModels.timeModels[indexpath.section].records.remove(at: indexpath.row)
                    deletedTimeModels.timeModels[indexpath.section].story.remove(at: indexpath.row)
                    if deletedTimeModels.timeModels[indexpath.section].records.isEmpty {
                        deletedTimeModels.timeModels.remove(at: indexpath.section)
                    }
                    try? deletedTimeModels.json?.write(to: url)
                    print("clearedTimeModel1111")
                }
            }
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if issegueFromClearVC {
            camera.isEnabled = false
            saveBtn.isEnabled = false
            storyContentView.isEditable = false
//            storyContentView.isUserInteractionEnabled = false
            for subview in storyContentView.subviews {
                subview.isUserInteractionEnabled = false
            }
            navigationBar.rightBarButtonItems = []
            let recoverBarBtn = UIBarButtonItem(title: "Recover", style: UIBarButtonItem.Style.done, target: self, action: #selector(recoverFromDeletVC))
//            navigationBar.rightBarButtonItems?.append(recoverBarBtn)

            navigationBar.rightBarButtonItem = recoverBarBtn


        }
        
        
        
        print("issegueFromClearVC = false")
        issegueFromClearVC = false
        
        if date != nil, storyContent != nil {
        dateLabel?.text = "Date: \((date!))"
        storyContentView.text = storyContent

        }
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    //MARK: - IB funcs
    
    //camera
    
    @IBAction func camera(_ sender: UIBarButtonItem) {
        storyContentView.resignFirstResponder()
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]  //import MobileCoreServices
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    //pickview alpha
    @IBAction func confirmBtn(_ sender: UIButton) {
        
        
        UIView.transition(with: weekdayPickView, duration: 1.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
            
            // Hide or Show delete btn
            for imageView in self!.imageViews {
                if let btn = imageView.subviews.first as? UIButton {
                    btn.isHidden = self?.hideDeleteBtn ?? false ? false : true
                }
            }
            self?.hideDeleteBtn = !self!.hideDeleteBtn

            
            
            self?.weekdayPickView.alpha = self?.isConfirmed ?? false ? 1 : 0
            self?.isConfirmed = !self!.isConfirmed
        },
        completion: {position in
                // do some clean
                //self.faceView.forEach{$0.isHidden = true, $0.alpha = 1, $0.transform = .identity}
        }
        )
        
        let index = weekdayPickView.selectedRow(inComponent: 0)
        print(Story.Mood.All[index])
        
    }
    
    
    // MARK: - Navigation
    @IBOutlet weak var storyContentView: UITextView! {
        didSet {
            
            storyContentView.delegate = self
            storyContentView.minimumZoomScale = 0.1
            storyContentView.maximumZoomScale = 3.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        storyContentView.insertSubview(storyContentView.selectedSubview!, at: 0)
        
        return storyContentView.selectedSubview
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        storyContentView.resignFirstResponder()
//    }
    
    
    //MARK:- texrView delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.selectedSubview = nil
        return true
    }
    
    
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        storyContentView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        if let text = storyContentView.text {
//            storyContent = text
//        }
//
//        storyContentView.resignFirstResponder()

        print("delegate.textViewDidChange")
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let text = storyContentView.text {
            storyContent = text
        }
        for imageV in imageViews {
        if let data = imageV.image?.jpegData(compressionQuality: 0.5) {
            let x = Int(imageV.center.x)
            let y = Int(imageV.center.y)
            let width = Int(imageV.frame.size.width )
            let height = Int(imageV.frame.size.height)
            let datainfo = Story.DataInfo(x: x, y: y, data: data, width: width, height: height)
            self.dataInfo.append(datainfo)
            }
        }
        presentingViewController?.dismiss(animated: false, completion: nil)
//        for imageV in imageViews {
//            self.dataInfo.append(Story.DataInfo(imageView: imageV) ?? Story.DataInfo(x: nil, y: nil, data: nil, width: nil, height: nil))
//        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}


extension Story.DataInfo {
    init?(imageView: UIImageView) {
        if let image = imageView.image {
         x =  Int(imageView.center.x)
         y = Int(imageView.center.y)
            data = image.jpegData(compressionQuality: 0.5)
         width = Int(imageView.frame.size.width)
         height = Int(imageView.frame.size.height)
        } else {
            return nil
        }
    }
    
    
}


/*
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     super.prepare(for: segue, sender: sender)
     
     
     
     guard let button = sender as? UIBarButtonItem, button === saveButton else {
         os_log("The save button was not pressed, cancelling", log: OSLog.default, type: OSLogType.default)
         return
     }
     
     let name = mealTextfield.text ?? ""
     let photo = mealPhoto.image
     let starNumber = starsControl.starNumber
     
     
     meal = Meals(name: name, image: photo, starNumber: starNumber) //set meal pass to MealTableVC
     
 }
 */
