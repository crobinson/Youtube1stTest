//
//  ViewController.h
//  Youtube1stTest
//
//  Created by Carlos Andres Robinson Lara on 2/4/13.
//  Copyright (c) 2013 Carlos Andres Robinson Lara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITextField *myTextField;
    NSMutableArray *resultados;
    IBOutlet UITableView *myTableView;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIView *loadingIndicator;
}
-(void)textFieldDidChange;
@end
