//
//  FXDAppDelegate.h
//  FXDPhotoCapture
//
//  Created by Peter SHINe on 3/7/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FXDinterfaceCapture.h"


@interface FXDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) IBOutlet FXDinterfaceCapture *captureInterface;


@end
