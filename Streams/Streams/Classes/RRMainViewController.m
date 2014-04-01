//
//  RRMainViewController.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRMainViewController.h"
#import "RRChannelsViewController.h"
#import "RRVideosViewController.h"

#import "RRUser.h"
#import "RRTwitchApiWorker.h"

static const NSInteger kSpinnerTag = 5298713;

@interface RRMainViewController () <UIAlertViewDelegate>

@property (nonatomic, weak) RRChannelsViewController *channelsVC;

@property (nonatomic, strong) RRUser *currentUser;
@property (nonatomic, strong) RRTwitchApiWorker *apiWorker;

@end

@implementation RRMainViewController

- (id)init
{
  if ( self = [super init] )
  {
    _currentUser = [RRUser currentUser];
    _apiWorker = [RRTwitchApiWorker new];
  }
  
  return self;
}

- (void)loadView
{
  self.view = [UIView new];
  
  RRChannelsViewController *channelsVC = [RRChannelsViewController new];
  [channelsVC setHeader:[self generateTableHeader]];
  [self addChildViewController:channelsVC];
  [self.view addSubview:channelsVC.view];
  [channelsVC didMoveToParentViewController:self];
  self.channelsVC = channelsVC;
  
  __weak __typeof(self)wkSelf = self;
  channelsVC.onSelectBlock = ^(RRChannelsViewController *sender, RRChannel *channel){
    __typeof(self)this = wkSelf;
    [this showSpinner];
    [self.apiWorker getRecentVideosForChannel:channel onCompletion:^(id result, NSError *error) {
      [this hideSpinner];
      
      // TODO: handle error
      if ( !error )
      {
        RRVideosViewController *videosTVC = [[RRVideosViewController alloc] initWithVideos:result];
        [this.navigationController pushViewController:videosTVC animated:YES];
      }
    }];
  };
}

- (NSString *)title
{
  return @"Channels";
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  UIViewController *channelsVC = self.channelsVC;
  channelsVC.view.frame = self.view.bounds;
}

#pragma mark - View generators

- (UIView *)generateTableHeader
{
  UILabel *tableHeader = [UILabel new];
  tableHeader.backgroundColor = [UIColor brownColor];
  tableHeader.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  tableHeader.text = @"Tap here to follow a channel!";
  tableHeader.textAlignment = NSTextAlignmentCenter;
  
  UITapGestureRecognizer *recg = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(addChannelTapped)];
  tableHeader.userInteractionEnabled = YES;
  [tableHeader addGestureRecognizer:recg];
  
  [tableHeader sizeToFit];
  CGRect frame = tableHeader.frame;
  frame.size.height += 20.0f;
  tableHeader.frame = frame;
  
  return tableHeader;
}

#pragma mark - Handlers

- (void)addChannelTapped
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow a Channel"
                                                  message:@"Enter the name of the channel you wish to follow"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Follow", nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alert show];
}

#pragma mark - UIAlertViewDelegate

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
  return [[alertView textFieldAtIndex:0].text length] > 0;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if ( ![alertView cancelButtonIndex] == buttonIndex )
  {
    [self showSpinner];
    
    NSString *channelName = [alertView textFieldAtIndex:0].text;
    [self.apiWorker getChannel:channelName onCompletion:^(RRChannel *channel, NSError *error) {
      [self hideSpinner];
      
      // TODO: handle error
      if ( !error )
      {
        [self.currentUser addChannelToFavorites:channel];
        RRChannelsViewController *channelsVC = self.channelsVC;
        [channelsVC addChannel:channel];
      }
    }];
  }
}

#pragma mark - Helpers

- (void)showSpinner
{
  dispatch_async(dispatch_get_main_queue(), ^{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    spinner.frame = self.view.bounds;
    spinner.tag = kSpinnerTag;
    [self.view addSubview:spinner];
    [spinner startAnimating];
  });
}

- (void)hideSpinner
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[self.view viewWithTag:kSpinnerTag] removeFromSuperview];
  });
}

@end
