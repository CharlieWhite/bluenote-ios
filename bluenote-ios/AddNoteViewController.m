//
//  AddNoteViewController.m
//  bluenote-ios
//
//  Created by Charlie White on 9/8/13.
//  Copyright (c) 2013 Charlie White. All rights reserved.
//

#import "AddNoteViewController.h"
#import "Note.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

@synthesize noteTextField, image1, image2, image3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    UIBarButtonItem *noteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendNote:)];
    self.navigationItem.rightBarButtonItem = noteButton;
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)sendNote:(id)sender {
    
    Note *note = [[Note alloc] init];
    note.message = noteTextField.text;
    [[RKObjectManager sharedManager] postObject:note path:@"notes" parameters:nil success:nil failure:nil];
    [self.navigationController popViewControllerAnimated:YES];
    

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches");
    UITouch *touch = [touches anyObject];
    if ([touch view] == image1) {
        // Do something here
        image1.highlighted = YES;
        image2.highlighted = NO;
        image3.highlighted = NO;
    }
    if ([touch view] == image2) {
        // Do something here
        image1.highlighted = NO;
        image2.highlighted = YES;
        image3.highlighted = NO;
    }
    if ([touch view] == image3) {
        // Do something here
        image1.highlighted = NO;
        image2.highlighted = NO;
        image3.highlighted = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
