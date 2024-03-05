//
//  followersAndFollwingVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/22/24.
//

import UIKit

class followersAndFollwingVC: UIViewController {
    
    var refString:String!
    
    @IBOutlet var followersView: UIView!
    @IBOutlet var followingView: UIView!
    
    
    var selectionIndicator: UIView!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        
        updateUI()
        
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateUI()
        

    }
    
    
    
    func updateUI(){
        
        DispatchQueue.main.async {
   
            // Make the segmented control transparent
            self.segmentControl.backgroundColor = UIColor.clear

            // Set the background images for normal and selected states to be transparent
            self.segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
            self.segmentControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)

//            // Set the text attributes for normal and selected states
            self.segmentControl.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 10) ?? UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)

            self.segmentControl.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 10) ?? UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)
            
            // Remove the divider image
            self.segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            
//            // Create and configure the selection indicator view
//            self.selectionIndicator = UIView()
//            self.selectionIndicator.backgroundColor = UIColor.systemRed
//            self.view.addSubview(self.selectionIndicator)
            
            // Check if the selectionIndicator already exists in the view hierarchy
             if self.selectionIndicator == nil {
//                 // Create and configure the selection indicator view
                 self.selectionIndicator = UIView()
                 self.selectionIndicator.backgroundColor = UIColor.systemRed
                 self.view.addSubview(self.selectionIndicator)
                 //             Initially position the indicator under the first segment
                 if self.refString == "followers"{
//                     self.segmentControl.selectedSegmentIndex = 0
                     self.updateSelectionIndicatorPosition(forSegment: 0)
                     self.followersView.alpha = 1
                     self.followingView.alpha = 0
                     self.segmentControl.selectedSegmentIndex = 0
                 }else{
//                     segmentControl.selectedSegmentIndex = 1
                     self.updateSelectionIndicatorPosition(forSegment: 1)
                     self.followersView.alpha = 0
                     self.followingView.alpha = 1
                     self.segmentControl.selectedSegmentIndex = 1
                 }
//
             }

        }
    }

    func updateSelectionIndicatorPosition(forSegment segment: Int) {
        guard let selectionIndicator = self.selectionIndicator else { return }
        // Calculate the width of each segment
        let segmentWidth = segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)

        // Calculate the desired width of the indicator (3/4 of the segment width)
        let indicatorWidth = segmentWidth * 0.75

        // Calculate the padding needed to center the indicator within the segment
        let padding = (segmentWidth - indicatorWidth) / 2

        // Calculate the position of the selection indicator
        let xPosition = segmentControl.frame.origin.x + CGFloat(segment) * segmentWidth + padding

        // Set the frame of the selection indicator
        selectionIndicator.frame = CGRect(x: xPosition, y: segmentControl.frame.maxY - 2, width: indicatorWidth, height: 2)
    }
    
    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            updateSelectionIndicatorPosition(forSegment: sender.selectedSegmentIndex)
            followersView.alpha = 1
            followingView.alpha = 0
            
        } else if sender.selectedSegmentIndex == 1{
            updateSelectionIndicatorPosition(forSegment: sender.selectedSegmentIndex)
            followersView.alpha = 0
            followingView.alpha = 1
        }
    }
    
    



}
