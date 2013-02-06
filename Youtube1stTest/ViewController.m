//
//  ViewController.m
//  Youtube1stTest
//
//  Created by Carlos Andres Robinson Lara on 2/4/13.
//  Copyright (c) 2013 Carlos Andres Robinson Lara. All rights reserved.
//

#import "ViewController.h"
#import "ResultsViewController.h"
#import "AFJSONRequestOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [indicator setHidden:YES];
    [indicator stopAnimating];
    [myTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [myTableView setHidden:YES];
    [indicator setHidden:YES];
    [indicator stopAnimating];
    [aTextField resignFirstResponder];
    [self performSegueWithIdentifier:@"gotoresults" sender:self];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"gotoresults"])
	{
        ResultsViewController *controller = [segue destinationViewController];
        controller.titulo = myTextField.text;
        
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, -150,self.view.frame.size.width,self.view.frame.size.height)];
}

-(void)textFieldDidChange:(id)sender
{
    [myTableView setHidden:YES];
    [indicator setHidden:NO];
    [indicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&strict=true&max-results=50&v=2&alt=jsonc", myTextField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",myTextField.text);
    if([myTextField.text isEqualToString:@""]){
        [myTableView setHidden:YES];
        [indicator setHidden:YES];
        [indicator stopAnimating];
    }else{
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id getJSON) {
            
            resultados = [getJSON valueForKeyPath:@"data.items"];
            
            [myTableView reloadData];
            [myTableView setHidden:NO];
            [indicator setHidden:YES];
            [indicator stopAnimating];
            
            
        } failure:nil];
        [operation start];
    }

}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [resultados count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *datadiccionario = [resultados objectAtIndex:indexPath.row];
    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:@"celdaresult"];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
        
    nameLabel.text = [datadiccionario objectForKey:@"title"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [myTableView setHidden:YES];
    [indicator setHidden:YES];
    [indicator stopAnimating];
    
    NSDictionary *datadiccionario = [resultados objectAtIndex:indexPath.row];
    myTextField.text = [datadiccionario objectForKey:@"title"];
    [myTextField resignFirstResponder];
    [self performSegueWithIdentifier:@"gotoresults" sender:self];
}



@end
