//
//  PDFViewController.m
//  openPDF
//
//  Created by Scott Andrus on 6/26/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "PDFViewController.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface PDFViewController ()

@end

@implementation PDFViewController
@synthesize pdf;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pdf = @"http://cran.r-project.org/doc/manuals/R-intro.pdf";
}

- (IBAction)savePDFPressed:(id)sender {
    
    NSArray *parts = [self.pdf componentsSeparatedByString:@"/"];
    NSString *previewDocumentFileName = [parts lastObject];
    NSLog(@"The file name is %@", previewDocumentFileName);
    
//    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    [loading startAnimating];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loading];
    [SVProgressHUD show];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        // Get file online
        NSData *fileOnline = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.pdf]];
        // Write file to the Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (!documentsDirectory) {NSLog(@"Documents directory not found!");}
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:previewDocumentFileName];
        [fileOnline writeToFile:appFile atomically:YES];
        NSLog(@"Resource file '%@' has been written to the Documents directory from online", previewDocumentFileName);
        
        // Get file again from Documents directory
        NSURL *fileURL = [NSURL fileURLWithPath:appFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
            controller.delegate = self;
            controller.UTI = @"com.adobe.pdf";
            //CGRect rect = CGRectMake(0, 0, 300, 300);
            [controller presentPreviewAnimated:YES];
//            [loading stopAnimating];
//            [loading removeFromSuperview];
            [SVProgressHUD dismiss];
        });
    });


}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller willBeginSendingToApplication: (NSString *) application {
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application {
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    
}

-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
	
	return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
