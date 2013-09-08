//
//  AddNoteViewController.m
//  bluenote-ios
//
//  Created by Charlie White on 9/7/13.
//  Copyright (c) 2013 Charlie White. All rights reserved.
//

#import "AddNoteViewController.h"
#import "Note.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

@synthesize noteTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendNote:)];
    self.navigationItem.rightBarButtonItem = sendButton;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendNote:(id)sender {
    Note *note = [[Note alloc] init];
    note.message = noteTextField.text;
    note.fromUserId = @"1";
    [[RKObjectManager sharedManager] postObject:note path:@"notes" parameters:nil success:nil failure:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
