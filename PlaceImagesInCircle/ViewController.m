//
//  ViewController.m
//  PlaceImagesInCircle
//
//  Created by 111 on 17/12/2015.
//  Copyright © 2015 OS-X-iOS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UIScrollView *mainScrollView;
}

@end

@implementation ViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self Initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Initialize {
    [self createInterface];
    
}

#pragma mark - Interface
- (void)createInterface {
    //BarButton
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(barButtonPressed)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    //ScrollView
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect rect = self.view.frame;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = CGSizeMake(rect.size.width * 4 , rect.size.height * 4);
    float offsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2;
    float offestY = (scrollView.contentSize.height - scrollView.frame.size.height) / 2;
    scrollView.contentOffset = CGPointMake(offsetX, offestY);
    scrollView.scrollsToTop = NO;
    [self.view addSubview:scrollView];
    mainScrollView = scrollView;
    
    [self createCirclesInMap];

}

- (void)createCirclesInMap {
    
    //Middle Button
    CGPoint scrollViewContentCenter = CGPointMake(mainScrollView.contentSize.width/2, mainScrollView.contentSize.height/2);
    UIButton *button = [self newButtonwithCenter:scrollViewContentCenter buttonWidth:120 andImage:nil];
    [mainScrollView addSubview:button];
    button.backgroundColor = [UIColor greenColor];
    
    //Circle Buttons
    UIImage *image = [UIImage imageNamed:@"iPhone.png"];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    int imageCount = 50;
    for (int i =0; i < imageCount; i++) {
        [imageArray addObject:image];
    }
    [self createCircleMapWithData:imageArray andMapCenter:scrollViewContentCenter];
}




#pragma mark - Button Actions
- (void)barButtonPressed {

    float offsetX = (mainScrollView.contentSize.width - mainScrollView.frame.size.width) / 2;
    float offestY = (mainScrollView.contentSize.height - mainScrollView.frame.size.height) / 2;
    mainScrollView.contentOffset = CGPointMake(offsetX, offestY);
}



#pragma mark - Encapped Functions


- (void)createCircleMapWithData:(NSMutableArray *)dataArray  andMapCenter:(CGPoint)mapCenter{
    
    int imageCount = (int)dataArray.count;
    int buttonNumberEachCircle = 10;
    int totalRoundNumber = imageCount / buttonNumberEachCircle;
    int lastRoundButtonCount = imageCount -  buttonNumberEachCircle * totalRoundNumber;
    float startAngle = 0;
    
    NSLog(@"total round is %i and last is %i",totalRoundNumber, lastRoundButtonCount);
    for (int i=0; i <= totalRoundNumber; i++) {
        
        CGFloat buttonWidth = (i == 0) ? 65 : 60;
        int buttonCount = (i == totalRoundNumber) ? lastRoundButtonCount : buttonNumberEachCircle;
        float radius = 150 + 80 * i;
        [self createCircleButtonsWithButtonCount:buttonCount startAngle:startAngle buttonWidth:buttonWidth circleCenter:mapCenter circleRadius:radius andBackgroundImageArray:dataArray];
        
        float angleBetweenButtons = 2 * M_PI / buttonCount;
        startAngle = startAngle + angleBetweenButtons / 2;
    }
}

- (void)createCircleMapWithData02:(NSMutableArray *)dataArray  andMapCenter:(CGPoint)mapCenter {
    // [-b + sqrt(b^2 - 4ac)]/2
    int a = 1;
    int b = 9;
    
    int imageCount = (int)dataArray.count;
    int totalRoundNumber = (-b +sqrt(b * b + 4 * imageCount))/ (2 * a);
    int lastRoundButtonCount = imageCount - ((totalRoundNumber+ 9) * totalRoundNumber);
    int startAngle = arc4random() % 360;;
    
    NSLog(@"total round is %i and last is %i",totalRoundNumber, lastRoundButtonCount);
    for (int i=0; i <= totalRoundNumber; i++) {
        
        CGFloat buttonWidth = (i == 0) ? 70 : 60;
        int buttonCount = (i == totalRoundNumber) ? lastRoundButtonCount : (10 + 2 * i);
        float radius = 150 + 100 * i;
        
        [self createCircleButtonsWithButtonCount:buttonCount startAngle:startAngle buttonWidth:buttonWidth circleCenter:mapCenter circleRadius:radius andBackgroundImageArray:dataArray];
    }
}

- (UIButton*)createCircleButtonsWithButtonCount:(int)buttonCount startAngle:(float)startAngle buttonWidth:(CGFloat)buttonWidth circleCenter:(CGPoint)circleCenter circleRadius:(float)radius andBackgroundImageArray:(NSMutableArray *)dataArray{
    
    UIButton *button;
    for (int i = 0; i < buttonCount; i++) {
        float angleBetweenButtons = 2 * M_PI / buttonCount;
        float angleFromFirstButton = startAngle + angleBetweenButtons * i;
        float originX = circleCenter.x - radius * cosf(angleFromFirstButton);
        float originY = circleCenter.y - radius * sinf(angleFromFirstButton);
        CGPoint buttonCenter = CGPointMake(originX, originY);
        button = [self newButtonwithCenter:buttonCenter buttonWidth:buttonWidth andImage:dataArray[i]];
        [mainScrollView addSubview:button];
    }
    return button;
}

- (UIButton*)newButtonwithCenter:(CGPoint)center buttonWidth:(CGFloat)width andImage:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, width, width);
    button.center = center;
    button.backgroundColor = [UIColor brownColor];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.frame.size.width / 2;
    return button;
}


@end




