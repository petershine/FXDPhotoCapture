//
//  PHMinterfaceCapture.m
//  FXDPhotoCapture
//
//  Created by Peter SHINe on 3/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDinterfaceCapture.h"


#pragma mark - Private interface
@interface FXDinterfaceCapture (Private)
@end


#pragma mark - Public implementation
@implementation FXDinterfaceCapture

#pragma mark Synthesizing
// Properties
@synthesize delegate = _delegate;

// IBOutlets
@synthesize imageviewFrozen;

@synthesize viewCaptureOverlay;
@synthesize buttonFlashMode;
@synthesize buttonCameraDirection;
@synthesize buttonShoot;


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
}

- (void)viewDidUnload {	// Release any retained subviews of the main view.
    [super viewDidUnload];
	
	// IBOutlets
    [self nilifyIBOutlets];
}

- (void)dealloc {		
	// Instance variables
	
	// Properties
	_delegate = nil;
		
	// IBOutlets
    [self nilifyIBOutlets];
	
    [super dealloc];
}

#pragma mark -
- (void)nilifyIBOutlets {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// IBOutlets
	self.imageviewFrozen = nil;
	
	self.viewCaptureOverlay = nil;
	self.buttonFlashMode = nil;
	self.buttonCameraDirection = nil;
	self.buttonShoot = nil;
}


#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        // Primitives
		
		// Instance variables
		
		// Properties
		_delegate = nil;
				
		// IBOutlets
    }
	
    return self;
}


#pragma mark - Accessor overriding


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {	FXDLog_SEPARATE;
    [super viewDidLoad];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	
	if (self.navigationController) {
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observedImageCapturedSuccessfully:) name:notificationImageCapturedSuccessfully object:nil];
	
	AVCaptureVideoPreviewLayer *capturePreviewLayer = [FXDcontrolCapture sharedInstance].capturePreviewLayer;
	capturePreviewLayer.frame = rectForPreviewLayer;
	[self.view.layer addSublayer:capturePreviewLayer];
	
	
	//View relatated initializations and configurations are all done here
	// If you would like use NIB just replace these implementations
	self.view.backgroundColor = [UIColor blackColor];
	
	self.imageviewFrozen = [[[UIImageView alloc] initWithFrame:rectForPreviewLayer] autorelease];	
	self.imageviewFrozen.backgroundColor = [UIColor clearColor];
	self.imageviewFrozen.userInteractionEnabled = NO;
	[self.view addSubview:self.imageviewFrozen];
	
	self.viewCaptureOverlay = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
	self.viewCaptureOverlay.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.viewCaptureOverlay];
	
	
	CGFloat insetTop = 10.0;
	CGFloat insetLeft = 10.0;
	CGFloat widthButton = 100.0;
	CGFloat heightButton = 37.0;
	
	CGRect frameFlashModeButton = CGRectZero;
	frameFlashModeButton.origin.x = insetLeft;
	frameFlashModeButton.origin.y = insetTop;
	frameFlashModeButton.size.width = widthButton;
	frameFlashModeButton.size.height = heightButton;
	
	self.buttonFlashMode = [[[UIButton alloc] initWithFrame:frameFlashModeButton] autorelease];
	self.buttonFlashMode.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
	[self.buttonFlashMode addTarget:self action:@selector(pressedSwitchFlashModeButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.viewCaptureOverlay addSubview:self.buttonFlashMode];

	
	CGRect frameCameraDirectionButton = CGRectZero;
	frameCameraDirectionButton.origin.x = self.view.frame.size.width -insetLeft -insetLeft -widthButton;
	frameCameraDirectionButton.origin.y = insetTop;
	frameCameraDirectionButton.size.width = widthButton;
	frameCameraDirectionButton.size.height = heightButton;
	
	self.buttonCameraDirection = [[[UIButton alloc] initWithFrame:frameCameraDirectionButton] autorelease];
	self.buttonCameraDirection.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
	[self.buttonCameraDirection addTarget:self action:@selector(pressedSwitchCameraDirectionButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.viewCaptureOverlay addSubview:self.buttonCameraDirection];
	
	
	CGRect frameShootButton = CGRectZero;
	frameShootButton.origin.x = (self.viewCaptureOverlay.frame.size.width -widthButton)/2.0;
	frameShootButton.origin.y = self.viewCaptureOverlay.frame.size.height -heightButton;
	frameShootButton.size.width = widthButton;
	frameShootButton.size.height = heightButton;
	
	self.buttonShoot = [[[UIButton alloc] initWithFrame:frameShootButton] autorelease];
	[self.buttonShoot setTitle:@"SHOOT" forState:UIControlStateNormal];
	[self.buttonShoot addTarget:self action:@selector(pressedShootButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.viewCaptureOverlay addSubview:self.buttonShoot];
}

- (void)viewWillAppear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewWillAppear:animated];
	
	[self setFlashModeButtonTitle];
	[self setCameraDirectionButtonTitle];
}

- (void)viewDidAppear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewDidAppear:animated];
	
	[[FXDcontrolCapture sharedInstance].captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewDidDisappear:animated];
	
	[[FXDcontrolCapture sharedInstance].captureSession stopRunning];
}


#pragma mark - Private
- (void)setFlashModeButtonTitle {
	switch ([FXDcontrolCapture sharedInstance].captureFlashMode) {
		case AVCaptureFlashModeOff:
			[self.buttonFlashMode setTitle:@"Off" forState:UIControlStateNormal];
			break;
			
		case AVCaptureFlashModeOn:
			[self.buttonFlashMode setTitle:@"On" forState:UIControlStateNormal];
			break;
			
		case AVCaptureFlashModeAuto:
			[self.buttonFlashMode setTitle:@"Auto" forState:UIControlStateNormal];
			break;
			
		default:
			break;
	}
}

- (void)setCameraDirectionButtonTitle {	
	switch ([FXDcontrolCapture sharedInstance].cameraDirection) {
		case UIImagePickerControllerCameraDeviceRear:
			[self.buttonCameraDirection setTitle:@"Rear" forState:UIControlStateNormal];
			break;
			
		case UIImagePickerControllerCameraDeviceFront:
			[self.buttonCameraDirection setTitle:@"Front" forState:UIControlStateNormal];
			break;
			
		default:
			break;
	}
}

#pragma mark - Overriding
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	FXDLog_DEFAULT;	
	UITouch *focusTouch = [touches anyObject];
	
	CGPoint pointInView = [focusTouch locationInView:self.view];
	FXDLog(@"pointInView: %@", NSStringFromCGPoint(pointInView));
	
	[self focusAtPointInView:pointInView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}


#pragma mark - IBActions
- (IBAction)pressedSwitchFlashModeButton:(id)sender {	FXDLog_DEFAULT;
	[[FXDcontrolCapture sharedInstance] switchCaptureFlashMode];
	
	[self setFlashModeButtonTitle];
}

- (IBAction)pressedSwitchCameraDirectionButton:(id)sender {	FXDLog_DEFAULT;
	[[FXDcontrolCapture sharedInstance] switchCameraDirection];

	[self setCameraDirectionButtonTitle];
}

- (IBAction)pressedShootButton:(id)sender {	FXDLog_DEFAULT;	
	
	if (self.imageviewFrozen.image) {
		self.imageviewFrozen.image = nil;
		
		[self.buttonShoot setTitle:@"SHOOT" forState:UIControlStateNormal];
	}
	else {
		[[FXDcontrolCapture sharedInstance] captureImageToTakePhotoAndShowFrozenImageFor:self.imageviewFrozen];
	}
}


#pragma mark - Public


#pragma mark -
- (void)focusAtCenterOfPreview {	FXDLog_DEFAULT;
	CGPoint centerPoint = CGPointMake(rectForPreviewLayer.size.width/2.0, rectForPreviewLayer.size.height/2.0);
	
	[self focusAtPointInView:centerPoint];
}

- (void)focusAtPointInView:(CGPoint)pointInView {	FXDLog_DEFAULT;
	
	// Value should be vertically inverted for AVCapturePreviewLayer
	CGPoint modifiedPoint = pointInView;
	modifiedPoint.y = rectForPreviewLayer.size.height -pointInView.y;
	
	if (modifiedPoint.y >= 0.0 && modifiedPoint.y <= rectForPreviewLayer.size.height) {
		CGPoint focusPoint = CGPointMake(modifiedPoint.x/rectForPreviewLayer.size.width, modifiedPoint.y/rectForPreviewLayer.size.height);
		FXDLog(@"focusPoint: %@", NSStringFromCGPoint(focusPoint));
		
		BOOL didApplyFocusPoint = [[FXDcontrolCapture sharedInstance] didApplyFocusPoint:focusPoint];
		FXDLog(@"didApplyFocusPoint: %@", didApplyFocusPoint ? @"YES":@"NO");
		
		if (didApplyFocusPoint) {
			[self animateFocusAtTouchedPointInView:pointInView];
		}
	}
}
	 
- (void)animateFocusAtTouchedPointInView:(CGPoint)pointInView {	FXDLog_DEFAULT;
	// Animate focus rectagle
	CGFloat radius = 80.0;
	
	CGRect focusedFrame = CGRectMake(pointInView.x-radius, pointInView.y-radius, radius*2.0, radius*2.0);
	
	UIView *focusedView = [[[UIView alloc] initWithFrame:focusedFrame] autorelease];
	focusedView.backgroundColor = [UIColor clearColor];
	focusedView.layer.borderColor = [UIColor whiteColor].CGColor;
	focusedView.layer.borderWidth = 1.0;
	
	focusedView.alpha = 0.0;
	[self.view insertSubview:focusedView belowSubview:self.viewCaptureOverlay];
	
	
	// Smaller radius animated to
	radius = radius /3.0 *2.0;
	
	CGRect destinationFrame = CGRectMake(pointInView.x-radius, pointInView.y-radius, radius*2.0, radius*2.0);
	
	FXDLog(@"focusedView: %@", focusedView);
	[UIView animateWithDuration:0.3
					 animations:^{
						 [focusedView setFrame:destinationFrame];
						 focusedView.alpha = 1.0;
					 }
					 completion:^(BOOL finished) {
						 
						 FXDLog(@"focusedView: %@", focusedView);
						 [UIView animateWithDuration:0.3
										  animations:^{
											  focusedView.alpha = 0.0;
										  }
										  completion:^(BOOL finished) {
											  FXDLog(@"focusedView: %@", focusedView);
											  
											  [focusedView removeFromSuperview];
										  }];
					 }];
}

//MARK: - Observer implementation
- (void)observedImageCapturedSuccessfully:(id)notification {	FXDLog_DEFAULT;
	
	FXDcontrolCapture *captureControl = [FXDcontrolCapture sharedInstance];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(captureInterface:didFinishPickingMediaWithInfo:)]) {		
		NSDictionary *capturedImageInfo = [NSDictionary dictionaryWithObjectsAndKeys:
										   captureControl.capturedPhoto, UIImagePickerControllerOriginalImage,
										   kUTTypeImage, UIImagePickerControllerMediaType,
										   nil];
		
		[self.delegate captureInterface:self didFinishPickingMediaWithInfo:capturedImageInfo];
	}
	else {
		self.imageviewFrozen.image = captureControl.capturedPhoto;
		
		[self.buttonShoot setTitle:@"Reshoot" forState:UIControlStateNormal];
	}
}

//MARK: - Delegate implementation


@end