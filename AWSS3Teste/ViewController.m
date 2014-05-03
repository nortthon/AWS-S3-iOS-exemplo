//
//  ViewController.m
//  AWSS3Teste
//
//  Created by Lucas Augusto on 2/25/2014.
//  Copyright (c) 2014 Lucas Augusto da Silva. All rights reserved.
//

#import "ViewController.h"
#import <AWSRuntime/AWSRuntime.h>

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewShow;

@end

@implementation ViewController

@synthesize s3 = _s3;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.s3 == nil){
        // Initial the S3 Client.
        self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    }
}

- (IBAction)sendImage {
    // Convert the image to JPEG data.
    NSData *imageData = UIImageJPEGRepresentation(_imageView.image, 1.0);
    
    [self processDelegateUpload:imageData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - AmazonServiceRequestDelegate

-(IBAction)uploadPhotoWithDelegate:(id)sender
{
    [self showImagePicker];
}

- (void)processDelegateUpload:(NSData *)imageData
{
    // Upload image data.  Remember to set the content type.
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:PICTURE_NAME inBucket:PICTURE_BUCKET];
    por.contentType = @"image/jpeg";
    por.data = imageData;
    por.cannedACL = [S3CannedACL publicRead];
    por.delegate = self;
    
    // Put the image data into the specified s3 bucket and object.
    [self.s3 putObject:por];
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [self showAlertMessage:@"The image was successfully uploaded." withTitle:@"Upload Completed"];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat: @"https://s3-us-west-2.amazonaws.com/%@/%@", PICTURE_BUCKET, PICTURE_NAME]];
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:url];
    _imageViewShow.image = [[UIImage alloc] initWithData:imgData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    [self showAlertMessage:error.description withTitle:@"Upload Error"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods

- (void)showImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertView show];
}

@end
