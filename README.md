# SlidingSegmentControl
only for OC

/Users/jija/Desktop/SlidingSegmentControl/Simulator Screen Shot 02.png
1.在自定义类中导入头文件

#import "SlidingSegmentControl.h"
#import "PunchScrollView.h"

2.申明属性、遵守协议
<SlidingSegmentControlDelegate,PunchScrollViewDelegate,PunchScrollViewDataSource,UIScrollViewDelegate>

@property(nonatomic, strong) PunchScrollView           *scrollView;
@property(nonatomic, strong) SlidingSegmentControl     *slidingSegControl;

@property(nonatomic, assign) NSInteger                 currentPage;

3.初始化控件
#pragma mark - Setter/Getter

-(SlidingSegmentControl *)slidingSegControl{

if (_slidingSegControl == nil) {

NSMutableArray *items = [NSMutableArray new];
NSArray *titlesArray = @[@"标题1",@"标题2就是这么长",@"标题3"];
for (NSString *title in titlesArray) {

SlidingSegmentControlItem *item = [[SlidingSegmentControlItem alloc] init];
item.title = title;
[items addObject:item];
}

_slidingSegControl = [SlidingSegmentControl slidingSegmentControlWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
_slidingSegControl.tintColor = [UIColor redColor];
_slidingSegControl.backgroundColor = [UIColor whiteColor];
_slidingSegControl.controlDelegate = self;
_slidingSegControl.items = items;
_slidingSegControl.itemNumberForOnePage = 3;
}
return _slidingSegControl;
}

- (PunchScrollView *)scrollView{

if (_scrollView == nil) {

_scrollView = [[PunchScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_slidingSegControl.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(_slidingSegControl.frame))];
_scrollView.pagePadding = 10.0;
_scrollView.scrollEnabled = YES;
_scrollView.delegate = self;
_scrollView.dataSource = self;
//        _scrollView.infiniteScrolling = NO;
}
return _scrollView;
}


-(UIView *)oneView{

if (_oneView == nil) {

_oneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), kScreenWidth,kScreenHeight -  CGRectGetMaxY(_slidingSegControl.frame) - 49)];
_oneView.backgroundColor = [UIColor orangeColor];
}
return _oneView;
}

-(UIView *)twoView{

if (_twoView == nil) {

_twoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), kScreenWidth,kScreenHeight -  CGRectGetMaxY(_slidingSegControl.frame) - 49)];
_twoView.backgroundColor = [UIColor purpleColor];
}
return _twoView;
}

-(UIView *)threeView{

if (_threeView == nil) {

_threeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), kScreenWidth,kScreenHeight -  CGRectGetMaxY(_slidingSegControl.frame) - 49)];
_threeView.backgroundColor = [UIColor grayColor];
}
return _threeView;
}

4.加载视图
- (void)viewDidLoad {
[super viewDidLoad];

[self showLeftButtonItemWithTitle:nil Sel:nil];
_currentPage = 0;
self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

[self.view addSubview:self.slidingSegControl];
[self.view addSubview:self.scrollView];
}


5.实现协议方法
#pragma mark - Delegate
//PunchScrollView
- (NSInteger)punchscrollView:(PunchScrollView *)scrollView numberOfPagesInSection:(NSInteger)section
{
return 3;
}

- (UIView *)punchScrollView:(PunchScrollView *)scrollView viewForPageAtIndexPath:(NSIndexPath *)indexPath
{
switch (indexPath.page)
{
case 0:
return self.oneView;
break;
case 1:
return self.twoView;
break;
case 2:
return self.threeView;
break;
default:
return nil;
break;
}
}

// GCSlidingSegmentedControl
- (void)slidingSegmentedControl:(SlidingSegmentControl *)control didSelectedItemAtIndex:(NSInteger)index
{
if (index != self.scrollView.currentIndexPath.page)
{
_currentPage = index;
[self.scrollView scrollToIndexPath:[NSIndexPath indexPathForPage:index inSection:0] animated:YES];
}
}

//UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//根据当前的坐标与页宽计算当前页码
int page = scrollView.contentOffset.x / scrollView.frame.size.width;
if (page != _currentPage && fabs(scrollView.contentOffset.x) >= fabs(scrollView.contentOffset.y)) {
_currentPage = page;
[self.slidingSegControl selectItemAtIndex:page scrollAnimated:YES];
}
}
