//
//  ViewController.m
//  笑话大全
//
//  Created by 刘烊 on 16/7/12.
//  Copyright © 2016年 阳光. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import "xiaoTableViewCell.h"

#import <UIImageView+WebCache.h>

//#define Read_URL @"http://route.showapi.com/341-3"

@interface ViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *info;
    NSMutableArray *dataArray;
    UITableView *meitableView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor redColor];
    self.view.backgroundColor=[UIColor yellowColor];
    [self initlized];
    [self setUI];
}

-(void)initlized
{
    info = [NSDictionary dictionary];
    
    dataArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时操作
        [self getRequest];
    });
    
}

#pragma mark - 网络请求
-(void)getRequest
{
  
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *url=@"http://route.showapi.com/341-3";
    NSDictionary *parat=@{@"showapi_appid":@"21845",@"showapi_sign":@"F4D17FF71B38E333CDBACA4063EC8229",@"maxResult":@20,@"page":@1};
    [manager GET:url parameters:parat progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        info=[NSJSONSerialization JSONObjectWithData:responseObject options:optind error:nil];
        NSLog(@"%@",info);

        dataArray=info[@"showapi_res_body"][@"contentlist"];
        [meitableView reloadData];
        
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
    
}

-(void)setUI
{
    self.title = @"笑话";
    
    meitableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    meitableView.delegate=self;
    meitableView.dataSource=self;
    meitableView.tag = 1;
    meitableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:meitableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"cellname";
    xiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectedBackgroundView.backgroundColor = cell.backgroundColor;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    
    
    
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"xiaoTableViewCell" owner:nil options:nil]lastObject];
    }
    
  
        // 更新界面
        cell.title.text = dataArray[indexPath.row][@"title"];//笑话
        
        cell.time.text = dataArray[indexPath.row][@"ct"];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataArray[indexPath.row][@"img"]]];
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
        
        
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
    
}

@end
