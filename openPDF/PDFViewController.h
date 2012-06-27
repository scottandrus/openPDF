//
//  PDFViewController.h
//  openPDF
//
//  Created by Scott Andrus on 6/26/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) NSString *pdf;

@end
