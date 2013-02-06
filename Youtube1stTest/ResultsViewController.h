//
//  ResultsViewController.h
//  Youtube1stTest
//
//  Created by Carlos Andres Robinson Lara on 2/4/13.
//  Copyright (c) 2013 Carlos Andres Robinson Lara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController<UIScrollViewDelegate>
{
    NSMutableData *responseData;
    IBOutlet UIScrollView *myScrollView;
    IBOutlet UIActivityIndicatorView *myActivityIndicator;
    IBOutlet UIView *vistaActivity;
    NSMutableArray *resultados;
    float page;
}

@property (nonatomic, strong) NSString *titulo;
@end
