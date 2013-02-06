//
//  ResultsViewController.m
//  Youtube1stTest
//
//  Created by Carlos Andres Robinson Lara on 2/4/13.
//  Copyright (c) 2013 Carlos Andres Robinson Lara. All rights reserved.
//

#import "ResultsViewController.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize titulo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{

    responseData = [NSMutableData data];
   
    
    titulo = [titulo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"%@",titulo);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&strict=true&max-results=50&v=2&alt=jsonc", titulo]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id getJSON) {
        
        resultados = [getJSON valueForKeyPath:@"data.items"];
        myScrollView.contentSize = CGSizeMake(320*resultados.count, 410);
        [myActivityIndicator stopAnimating];
        [vistaActivity setHidden:YES];

        [self showResults];

    } failure:nil];
    [operation start];
    

}

-(void) showResults{
    NSMutableDictionary *videoitem = [resultados objectAtIndex:page];
    //UIView *alphaView = [UIView alloc] initWithFrame:CGRectMake(page*320,0,320,myScrollView.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(page*320,0,320,myScrollView.frame.size.height)];
    [myScrollView addSubview:imageView];
    NSMutableDictionary *arrayimage = [videoitem objectForKey:@"thumbnail"];
    
    
    if ([[videoitem objectForKey:@"thumbnail"] objectForKey:@"hqDefault"])
    {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:[arrayimage objectForKey:@"hqDefault"]]];
        __block UIActivityIndicatorView *activityIndicator;
        [imageView setImageWithURL:imageURL placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             if (!activityIndicator)
             {
                 [imageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                 activityIndicator.center = imageView.center;
                 [activityIndicator startAnimating];
             }
         }
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             [activityIndicator removeFromSuperview];
             activityIndicator = nil;
         }];
    }

    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(page*320 + 20,10,280,21)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [myScrollView addSubview:title];
    title.text = [videoitem objectForKey:@"title"];
    NSString* yourString = [videoitem objectForKey:@"title"];
    float actualSize = 14.0;
    [yourString sizeWithFont:title.font
                 minFontSize:14
              actualFontSize:&actualSize
                    forWidth:217
               lineBreakMode:title.lineBreakMode];
    
    CGSize size = [yourString sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:actualSize]];
    
    int lines = 0;
    if(size.width > title.frame.size.width){
        float myFloat = size.width / title.frame.size.width;
        NSLog(@"%f",myFloat);
        lines = (int)ceil(myFloat);
        NSLog(@"%i",lines);
        title.numberOfLines = lines;
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, title.frame.size.height * lines);
    }

    
    UILabel *duration = [[UILabel alloc] initWithFrame:CGRectMake(page*320 + 20,10 + title.frame.size.height,280,21)];
    duration.backgroundColor = [UIColor clearColor];
    duration.textColor = [UIColor whiteColor];
    [duration setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [myScrollView addSubview:duration];
    duration.text = [NSString stringWithFormat:@"Duration: %@ sec", [videoitem objectForKey:@"duration"]];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sender{
    //NSLog(@"%f", myScrollView.contentOffset.x);
    page = myScrollView.contentOffset.x/320;
    NSLog(@"%f",page);
    [self showResults];
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(@"Connection failed: %@", [error description]);
    
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atencion" message:@"Conection problem" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alerta show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSString * datos = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *urlconexion = [NSString stringWithFormat:@"%@",connection.currentRequest.URL];
    NSLog(@"%@",urlconexion);
    NSLog(@"%@",datos);
    NSLog(@"%@",error);
    NSLog(@"%@",json);
    
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!page)
        page = 0;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
