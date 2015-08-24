//
//  ViewController.h
//  Tesseract iOS Testing
//
//  Created by Zarek Parker on 8/24/15.
//  Copyright (c) 2015 Zarek Parker. All rights reserved.
//


#import <TesseractOCR/TesseractOCR.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *characterImage;

@end

