//
//  FullSizePhotoViewController.m
//  ImageViewer
//
//  Created by dengjun on 5/19/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import "FullSizePhotoViewController.h"
#import "PhotoModel.h"
#import "PhotoViewController.h"

@interface FullSizePhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSArray* photoModelArray;

@property (nonatomic, strong) UIPageViewController* pageViewController;

@end

@implementation FullSizePhotoViewController

-(instancetype) initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex{
    self = [self init];
    if (!self) return nil;
    
    self.photoModelArray = photoModelArray;
    self.title = [self.photoModelArray[photoIndex] photoName];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:@{UIPageViewControllerOptionInterPageSpacingKey:@(30)}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:photoIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    self.title = [[self.pageViewController.viewControllers.firstObject photoModel] photoName];
    [self.delegate userDidScroll:self toPhotoAtIndex:[self.pageViewController.viewControllers.firstObject photoIndex]];
}

-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(PhotoViewController *)viewController{
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(PhotoViewController *)viewController{
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

-(PhotoViewController*)photoViewControllerForIndex:(NSInteger) index{
    if (index >= 0 && index < self.photoModelArray.count){
        PhotoModel* photoModel = self.photoModelArray[index];
        
        PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithPhotoModel:photoModel index:index];
        return photoViewController;
    }
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
