//
//  ViewController.m
//  TakingPictures
//
//  Created by John Malloy on 9/6/14.
//  Copyright (c) 2014 BigRedINC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePicture:(id)sender
{
    //Make sure the camera is available
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Camera Unavailable"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.imagePicker == nil)
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        //the following allows the user to edit the image
        self.imagePicker.allowsEditing = YES;
    }
    
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (IBAction)editVideo:(id)sender
{
    if (self.pathToRecordedVideo)
    {
        UIVideoEditorController * editor = [[UIVideoEditorController alloc] init];
        editor.videoPath = self.pathToRecordedVideo;
        editor.delegate = self;
        [self presentViewController:editor animated:YES completion:NULL];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"No Video Recorded Yet"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
{
    self.pathToRecordedVideo = editedVideoPath;
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath))
    {
        UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, nil, nil, nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare((__bridge CFStringRef)mediaType,kUTTypeMovie,0) == kCFCompareEqualTo)
    {
        //Movie Captured
        NSString * moviePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.pathToRecordedVideo = moviePath;
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath))
        {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
            
            //What you are doing in this part of the method is comparing the media type of the saved file.the main issuse comes into play when you attempt to compare mediaType, which is an NSString with kUTTypeMovie,which is of the type CFStringRef. you accomplist this by casting your NSString down to a CFStringRef. After iOS 5 the process was changed because of the introductin of ARC. ARC deals with Objective C types such as NSString but not with C types like CFStringRef. You create a bridged casting by placing __bridge before your CFStringRef as shown to instruct ARC not to deal with this object. 
        }
    }
    else
    {
        
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        self.imageView.image = image;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
