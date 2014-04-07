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

#define PRELOAD_LIST 1

static const CGFloat kRotaryVisibleWidth = 150;

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
  self.view.backgroundColor = [UIColor whiteColor];
  
  RRChannelsViewController *channelsVC = [RRChannelsViewController new];
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
  
#if PRELOAD_LIST
  [self addFavoriteChannel:@"blitzdota"];
  [self addFavoriteChannel:@"puppey"];
  [self addFavoriteChannel:@"dreamleague"];
  [self addFavoriteChannel:@"draskyl"];
  [self addFavoriteChannel:@"purgegamers"];
  [self addFavoriteChannel:@"sing_sing"];
  [self addFavoriteChannel:@"iceiceice"];
  [self addFavoriteChannel:@"dendi"];
#endif
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
  return self.channelsVC;
}

- (NSString *)title
{
  return @"Channels";
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  __typeof(self.channelsVC)channelsVC = self.channelsVC;
  CGFloat size = MAX(self.view.bounds.size.width,self.view.bounds.size.height);
  CGPoint leftCenter = CGPointMake(0, CGRectGetMidY(self.view.bounds));
  channelsVC.view.frame = CGRectMake(leftCenter.x - (size - kRotaryVisibleWidth), leftCenter.y - size/2.0f,
                                     size, size);
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
    NSString *channelName = [alertView textFieldAtIndex:0].text;
    [self addFavoriteChannel:channelName];
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

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
  dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  });
}

- (void)addFavoriteChannel:(NSString *)channelName
{
  [self showSpinner];
  [self.apiWorker getChannel:channelName onCompletion:^(RRChannel *channel, NSError *error) {
    [self hideSpinner];
    
    if ( error )
    {
      NSString *message;
      switch ([error code]) {
        case TwitchApiErrorChannelNotFound:
          message = [NSString stringWithFormat:@"No channel named: %@", channelName];
          break;
        default:
        case TwitchApiErrorUnknown:
          message = @"An unkown error occured.";
          break;
      }
      [self showAlertWithTitle:@"Error" message:message];
    }
    else
    {
      [self.currentUser addChannelToFavorites:channel];
      RRChannelsViewController *channelsVC = self.channelsVC;
      [channelsVC addChannel:channel];
    }
  }];
}

@end
