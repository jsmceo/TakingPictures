//
//  ViewController.h
//  TakingPictures
//
//  Created by John Malloy on 9/6/14.
//  Copyright (c) 2014 BigRedINC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIVideoEditorControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (strong, nonatomic) UIImagePickerController * imagePicker;

//The following will store the path to the video that the user records.
@property (strong, nonatomic) NSString * pathToRecordedVideo;

- (IBAction)takePicture:(id)sender;
- (IBAction)editVideo:(id)sender;


//To access the camera, you use the UIImagePickerController class,this will present an interface for choosing photos or taking them. It is essential you include a function to have your app check for harware availability. This is done through the isSourceTypeAvailable class method of UIImagePickerController. It takes one of the predefined constants as an argument = UIImagePickerControllerSourceTypeCamera, UiImagePickerControllerSourceTypePhotoLibrary, UiImagePickerControllerSourceTypeSavedPhotosAlbum. 

@end
