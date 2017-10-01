//
//  ISRadioButton.swift
//  DaynamicForm
//
//  Created by Ishaq Shafiq on 09/12/2015.
//  Copyright © 2015 TheGoal. All rights reserved.
//

import UIKit

@IBDesignable
open class  ISRadioButton: UIButton {
    
    var indexPath:IndexPath!
    
    //      Container for holding other buttons in same group.
    
    @IBOutlet var otherButtons: Array<ISRadioButton>?
    
    //      Size of icon, default is 15.0.
    
    @IBInspectable open var iconSize:CGFloat = 15.0
    
    //    Size of selection indicator, default is iconSize * 0.5.
    
    @IBInspectable open var indicatorSize:CGFloat = 15.0 * 0.5
    
    //      Color of icon, default is black
    
    @IBInspectable open var iconColor:UIColor =  UIColor.black
    
    //      Stroke width of icon, default is iconSize / 9.
    
    @IBInspectable open var iconStrokeWidth:CGFloat = 1.6
    
    //      Color of selection indicator, default is black
    
    @IBInspectable open var indicatorColor:UIColor = UIColor.black
    
    //      Margin width between icon and title, default is 10. 0.
    
    @IBInspectable open var marginWidth:CGFloat = 10.0
    
    //      Whether icon on the right side, default is NO.
    
    @IBInspectable open var iconOnRight:Bool = false
    
    //      Whether use square icon, default is NO.
    
    @IBInspectable open var iconSquare:Bool = false
    
    //      Image for radio button icon (optional).
    
    @IBInspectable open var icon:UIImage!
    
    //      Image for radio button icon when selected (optional).
    
    @IBInspectable open var iconSelected:UIImage!
    
    //      Whether enable multiple selection, default is NO.
    
    @IBInspectable open var multipleSelectionEnabled:Bool = false
    
    var isChaining:Bool = false
    
    fileprivate var setOtherButtons:NSArray {
        
        get{
            return otherButtons! as NSArray
        }
        set (newValue) {
            if !isChaining {
                otherButtons = newValue as? Array<ISRadioButton>
                isChaining = true
                for radioButton in otherButtons!{
                    let others:NSMutableArray = NSMutableArray(array:otherButtons!)
                    others.add(self)
                    others.remove(radioButton)
                    radioButton.setOtherButtons = others
                }
                isChaining = false
            }
        }
    }
    
    @IBInspectable open var setIcon:UIImage {
        
        // Avoid to use getter it can be nill
        
        get{
            return icon
        }
        
        set (newValue){
            icon = newValue
            self.setImage(icon, for: UIControlState())
        }
    }
    
    @IBInspectable open var setIconSelected:UIImage {
        
        // Avoid to use getter it can be nill
        
        get{
            return iconSelected
        }
        
        set (newValue){
            iconSelected = newValue
            self.setImage(iconSelected, for: .selected)
            self.setImage(iconSelected, for: .highlighted)
        }
    }
    
    var setMultipleSelectionEnabled:Bool {
        
        get{
            return multipleSelectionEnabled
        }
        set (newValue) {
            if !isChaining {
                isChaining = true
                multipleSelectionEnabled = newValue
                
                if self.otherButtons != nil {
                    for radioButton in self.otherButtons!{
                        radioButton.multipleSelectionEnabled = newValue
                    }
                }
                isChaining = false
            }
        }
    }
    
    // MARK: -- Helpers
    
    func drawButton (){
        if (icon == nil ||  self.icon.accessibilityIdentifier == "Generated Icon"){
            self.setIcon = self.drawIconWithSelection(false)
        }else{
            self.setIcon = icon
        }
        if (iconSelected == nil ||  self.iconSelected.accessibilityIdentifier == "Generated Icon"){
            self.setIconSelected = self.drawIconWithSelection(true)
        }else{
            self.setIconSelected = iconSelected
        }
        
        if self.otherButtons != nil {
            self.setOtherButtons = self.otherButtons! as NSArray
        }
        
        if multipleSelectionEnabled {
            self.setMultipleSelectionEnabled = multipleSelectionEnabled
        }
        
        if self.iconOnRight {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width - self.icon.size.width + marginWidth, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, marginWidth + self.icon.size.width);
            self.contentHorizontalAlignment = .right
        } else {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, marginWidth, 0, 0);
            self.titleLabel?.textAlignment = .left
            self.contentHorizontalAlignment = .left
        }
        self.titleLabel?.adjustsFontSizeToFitWidth = false
    }
    
    func drawIconWithSelection (_ selected:Bool) -> UIImage{
        let rect:CGRect = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
        let context  = UIGraphicsGetCurrentContext()
        //        UIGraphicsPushContext(context!)
        // draw icon
        
        var iconPath:UIBezierPath!
        let iconRect:CGRect = CGRect(x: iconStrokeWidth / 2, y: iconStrokeWidth / 2, width: iconSize - iconStrokeWidth, height: iconSize - iconStrokeWidth);
        if self.iconSquare {
            iconPath = UIBezierPath(rect:iconRect )
        } else {
            iconPath = UIBezierPath(ovalIn:iconRect)
        }
        iconColor.setStroke()
        iconPath.lineWidth = iconStrokeWidth;
        iconPath.stroke()
        context!.addPath(iconPath.cgPath);
        
        // draw indicator
        if (selected) {
            var indicatorPath:UIBezierPath!
            let indicatorRect:CGRect = CGRect(x: (iconSize - indicatorSize) / 2, y: (iconSize - indicatorSize) / 2, width: indicatorSize, height: indicatorSize);
            if self.iconSquare {
                indicatorPath = UIBezierPath(rect:indicatorRect )
            } else {
                indicatorPath = UIBezierPath(ovalIn:indicatorRect)
            }
            indicatorColor.setStroke()
            indicatorPath.lineWidth = iconStrokeWidth;
            indicatorPath.stroke()
            
            indicatorColor.setFill()
            indicatorPath.fill()
            context!.addPath(indicatorPath.cgPath);
        }
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        //        UIGraphicsPopContext()
        UIGraphicsEndImageContext();
        
        image.accessibilityIdentifier = "Generated Icon";
        return image;
    }
    
    func touchDown () {
        self.isSelected = true
    }
    
    func initRadioButton () {
        super.addTarget(self, action:#selector(ISRadioButton.touchDown), for:.touchUpInside)
        self.isSelected = false
    }
    
    override open func prepareForInterfaceBuilder () {
        self.initRadioButton()
        self.drawButton()
    }
    
    // MARK: -- ISRadiobutton
    
    //    @return Selected button in same group.
    
    func selectedButton() -> ISRadioButton!{
        if !self.multipleSelectionEnabled {
            if self.isSelected {
                return self
            }
        }else{
            for isRadioButton in self.otherButtons!  {
                if isRadioButton.isSelected {
                    return isRadioButton
                }
            }
        }
        return nil
    }
    
    //    @return Selected buttons in same group, use it only if multiple selection is enabled.
    
    func selectedButtons() -> NSMutableArray{
        
        let selectedButtons:NSMutableArray = NSMutableArray ()
        if self.isSelected {
            selectedButtons.add(self)
        }
        for isRadioButton in self.otherButtons!  {
            if isRadioButton.isSelected {
                selectedButtons .add(self)
            }
        }
        return selectedButtons;
    }
    
    //    Clears selection for other buttons in in same group.
    
    func deselectOtherButtons() {
        if self.otherButtons != nil {
            for isRadioButton in self.otherButtons!  {
                isRadioButton.isSelected = false
            }
        }
    }
    
    //    @return unselected button in same group.
    
    func unSelectedButtons() -> NSArray{
        let unSelectedButtons:NSMutableArray = NSMutableArray ()
        if self.isSelected {
            unSelectedButtons .add(self)
        }
        for isRadioButton in self.otherButtons!  {
            if isRadioButton.isSelected {
                unSelectedButtons .add(self)
            }
        }
        return unSelectedButtons ;
    }
    
    // MARK: -- UIButton
    
    override open func titleColor(for state:UIControlState) -> UIColor{
        if (state == UIControlState.selected || state == UIControlState.highlighted){
            var selectedOrHighlightedColor:UIColor!
            if (state == UIControlState.selected) {
                selectedOrHighlightedColor = super.titleColor(for: .selected)
            }else{
                selectedOrHighlightedColor = super.titleColor(for: .highlighted)
            }
            self.setTitleColor(selectedOrHighlightedColor, for: .selected)
            self.setTitleColor(selectedOrHighlightedColor, for: .highlighted)
        }
        return super.titleColor(for: state)!
    }
    
    // MARK: -- UIControl
    
    override open var isSelected: Bool {
        didSet(oldValue) {
            if (multipleSelectionEnabled) {
                if oldValue == true && self.isSelected == true {
                    self.isSelected = false
                }
            }
            else {
                if isSelected {
                    self.deselectOtherButtons()
                }
            }
        }
    }
    
    // MARK: -- UIView
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initRadioButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initRadioButton()
    }
    
    override open func draw(_ rect:CGRect) {
        super.draw(rect)
        self.drawButton()
    }
}
