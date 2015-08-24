//
//  ViewController.m
//  Tesseract iOS Testing
//
//  Created by Zarek Parker on 8/24/15.
//  Copyright (c) 2015 Zarek Parker. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pictureButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.pictureButton.layer.borderWidth = 1.0f;
    self.pictureButton.layer.cornerRadius = 4.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pictureButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {

    self.textView.text = [NSString stringWithFormat:@"progress: %lu", (unsigned long)tesseract.progress];
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    chosenImage.ima
//    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:^() { [self performOCROnImage:chosenImage]; }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    //picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)performOCROnImage:(UIImage *)image {
    // Do any additional setup after loading the view, typically from a nib.
    
    // Languages are used for recognition (e.g. eng, ita, etc.). Tesseract engine
    // will search for the .traineddata language file in the tessdata directory.
    // For example, specifying "eng+ita" will search for "eng.traineddata" and
    // "ita.traineddata". Cube engine will search for "eng.cube.*" files.
    // See https://code.google.com/p/tesseract-ocr/downloads/list.
    
    // Create your G8Tesseract object using the initWithLanguage method:
    G8Tesseract *ocrtesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    
    // Optionaly: You could specify engine to recognize with.
    // G8OCREngineModeTesseractOnly by default. It provides more features and faster
    // than Cube engine. See G8Constants.h for more information.
    ocrtesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    
    // Set up the delegate to receive Tesseract's callbacks.
    // self should respond to TesseractDelegate and implement a
    // "- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract"
    // method to receive a callback to decide whether or not to interrupt
    // Tesseract before it finishes a recognition.
    ocrtesseract.delegate = self;
    
    // Optional: Limit the character set Tesseract should try to recognize from
    //tesseract.charWhitelist = @"0123456789";
    
    // This is wrapper for common Tesseract variable kG8ParamTesseditCharWhitelist:
    // [tesseract setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharBlacklist];
    // See G8TesseractParameters.h for a complete list of Tesseract variablesw
    
    // Optional: Limit the character set Tesseract should not try to recognize from
    //tesseract.charBlacklist = @"OoZzBbSs";
    
    // Specify the image Tesseract should recognize on
    ocrtesseract.image = image;//[[UIImage imageNamed:@"IMG_6199.jpg"] g8_blackAndWhite];
    
    // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
    //ocrtesseract.rect = CGRectMake(20, 20, 100, 100);
    
    // Optional: Limit recognition time with a few seconds
    ocrtesseract.maximumRecognitionTime = 3.0;
    
    // Start the recognition
    [ocrtesseract recognize];
    
    NSString *ocrText = [ocrtesseract recognizedText];
    // Retrieve the recognized text
    NSLog(@"%@", ocrText);
    
    self.textView.text = ocrText;
    
    // You could retrieve more information about recognized text with that methods:
    NSArray *characterBoxes = [ocrtesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelSymbol];
    NSArray *paragraphs = [ocrtesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelParagraph];
    NSArray *characterChoices = ocrtesseract.characterChoices;
    UIImage *imageWithBlocks = [ocrtesseract imageWithBlocks:characterBoxes drawText:YES thresholded:NO];
    self.characterImage.image = imageWithBlocks;
}


@end
