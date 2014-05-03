//
//  ViewController.h
//  AWSS3Teste
//
//  Created by Lucas Augusto on 2/25/2014.
//  Copyright (c) 2014 Lucas Augusto da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>

#define ACCESS_KEY_ID          @""
#define SECRET_KEY             @""
#define PICTURE_BUCKET         @"calendarimg"
#define PICTURE_NAME           @"teste2"



@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AmazonServiceRequestDelegate> {
}


@property (nonatomic, retain) AmazonS3Client *s3;

-(IBAction)uploadPhotoWithDelegate:(id)sender;

- (IBAction)sendImage;

@end
