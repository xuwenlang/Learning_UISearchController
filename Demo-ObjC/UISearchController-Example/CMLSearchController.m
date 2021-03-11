//
//  CMLSearchController.m
//  UISearchController-Example
//
//  Created by chuimanlong on 2017/10/11.
//  Copyright © 2017 CHUI MANLONG. All rights reserved.
//

#import "CMLSearchController.h"

@interface CMLSearchController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
// 原始数据源
@property (nonatomic, strong) NSMutableArray *originalDatas;
// 搜索结果数据源
@property (nonatomic, strong) NSMutableArray *resultDatas;

@end

@implementation CMLSearchController

static NSString * const reuseCellIdentify = @"reuseCellIdentify";

- (UITableView *)tableView {
    if (_tableView == nil) {
//        CGFloat navigationBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44.0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellIdentify];
        _tableView.estimatedRowHeight = 70.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}

- (NSMutableArray *)originalDatas {
    if (_originalDatas == nil) {
        _originalDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _originalDatas;
}

- (NSMutableArray *)resultDatas {
    if (_resultDatas == nil) {
        _resultDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _resultDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.originalDatas = [NSMutableArray arrayWithArray:[self getDefaultDatas]];
    [self setupUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)setupUI {
    
    
    // 创建UISearchController, 这里使用当前控制器来展示结果
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    _searchController.dimsBackgroundDuringPresentation = NO;
    //
    _searchController.hidesNavigationBarDuringPresentation = YES;
    self.definesPresentationContext = YES;
    // 设置结果更新代理
    _searchController.searchResultsUpdater = self;
    
    
    UISearchBar *searchBar = _searchController.searchBar;
    // ”取消“按钮、光标颜色
    searchBar.tintColor = [UIColor orangeColor];
    // 背景色
    searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
//    [searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]]];
//    searchBar.backgroundColor = [UIColor redColor];
    searchBar.placeholder = @"请输入搜索内容...";
    searchBar.delegate = self;
    // 右侧语音
    searchBar.showsBookmarkButton = YES;
//    [searchBar setImage:[UIImage imageNamed:""] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    // 调整和移动 view 和 view 内部子视图的大小和位置
    [searchBar sizeToFit];
    
    // 去除 searchBar 上下两条黑线
    UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
    barImageView.layer.borderWidth = 1;
    
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = searchBar;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        return self.resultDatas.count ;
    }
    return self.originalDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCellIdentify];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        NSString *model = [self.resultDatas objectAtIndex:indexPath.row];
        cell.textLabel.text = model;
        cell.detailTextLabel.text = @"搜索结果cell";
    } else {
        NSString *model = [self.originalDatas objectAtIndex:indexPath.row];
        cell.textLabel.text = model;
        cell.detailTextLabel.text = @"原始数据cell";
    }
    
//    __weak typeof(cell) weakCell = cell;
//    cell.commodityUpDownStoreBlock = ^(YGCommodity *commodity) {
//        weakCell.model =
//    };
    
    return cell;
}

#pragma mark - 😤 UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.resultDatas objectAtIndex:indexPath.row]);
        NSLog(@"%s, %@", __func__, @"--------- 走到这里 ---------");
    } else {
        NSLog(@"选择了原始列表中的%@", [self.originalDatas objectAtIndex:indexPath.row]);
        NSLog(@"%s, %@", __func__, @"--------- 走到这里 ---------");
    }
    
}

//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
// 删除按钮
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath){

//        if (self.searchController.active ) {
//            // 先移除数组results中的cell数据
//            [self.resultDatas removeObjectAtIndex:indexPath.row];
//
//            [self.tableView beginUpdates];
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//            [self.tableView endUpdates];
//            // 刷新第0个section
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//        }
//        else {
//            // 先移除数组datas中的cell数据
//            [self.originalDatas removeObjectAtIndex:indexPath.row];
//
//            [self.tableView beginUpdates];
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView endUpdates];
//            // 刷新第0个section
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//        }

//    }];
//    return @[deleteRowAction];
//}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    /// 实时更新
    NSString *searchText = self.searchController.searchBar.text;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchText];
    self.resultDatas = [NSMutableArray arrayWithArray:[self.originalDatas filteredArrayUsingPredicate:searchPredicate]];
    [self.tableView reloadData];
    
//    /// 手动更新
//    if (self.resultDatas.count > 0) {
//        [self.resultDatas removeAllObjects];
//    }
//    [self.tableView reloadData];
    
}

#pragma mark - 😤 UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    
//    __weak typeof(self) weakSelf = self;
    NSLog(@"%s, %@", __func__, @"--------- 走到这里 ---------");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s, %@", __func__, @"--------- 走到这里 ---------");
}

/**
 *  设置数据
 */
- (NSArray *)getDefaultDatas {
    NSArray *datas = @[@"国服第一臭豆腐 No.1 Stinky Tofu CN.",
                       @"比尔吉沃特(Bill Ji walter)",
                       @"瓦洛兰 Valoran",
                       @"祖安 Zaun",
                       @"德玛西亚 Demacia",
                       @"诺克萨斯 Noxus",
                       @"艾欧尼亚 Ionia",
                       @"皮尔特沃夫 Piltover",
                       @"弗雷尔卓德 Freijord",
                       @"班德尔城 Bandle City",
                       @"无畏先锋",
                       @"战争学院 The Institute of War",
                       @"巨神峰",
                       @"雷瑟守备(JustThunder)",
                       @"裁决之地(JustRule)",
                       @"黑色玫瑰(Black Rose)",
                       @"暗影岛（Shadow island）",
                       @"钢铁烈阳（Steel fierce）",
                       @"恕瑞玛沙漠 Shurima Desert",
                       @"均衡教派（Balanced sect）",
                       @"水晶之痕（Crystal Scar）",
                       @"影流（Shadow Flow ）",
                       @"守望之海（The Watchtower of sea）",
                       @"皮尔特沃夫",
                       @"征服之海",
                       @"扭曲丛林 Twisted Treeline",
                       @"教育网专区",
                       @"试炼之地 Proving Grounds",
                       @"卡拉曼达 Kalamanda",
                       @"蓝焰岛 Blue Flame Island",
                       @"哀嚎沼泽 Howling Marsh",
                       @"艾卡西亚 Icathia",
                       @"铁脊山脉 Ironspike Mountains",
                       @"库莽古丛林 Kumungu",
                       @"洛克法 Lokfar",
                       @"摩根小道 Morgon Pass",
                       @"塔尔贡山脉 Mountain Targon",
                       @"瘟疫丛林 Plague Jungles",
                       @"盘蛇河 Serpentine River",
                       @"厄尔提斯坦 Urtistan",
                       @"巫毒之地 Voodoo Lands",
                       @"咆哮深渊 Howling Abyss",
                       @"熔岩洞窟 Magma Chambers",
                       @"召唤师峡谷 Summoner's Rift",
                       @"九尾妖狐： 阿狸（Ahri）",
                       @"暗影之拳：阿卡丽（Akali）",
                       @"牛头酋长：阿利斯塔（Alistar）",
                       @"殇之木乃伊：阿木木（Amumu）",
                       @"冰晶凤凰：艾尼维亚（Anivia）",
                       @"黑暗之女：安妮（Annie）",
                       @"寒冰射手：艾希（Ashe）",
                       @"蒸汽机器人：布里茨（Blitzcrank)",
                       @"复仇焰魂：布兰德（Brand）",
                       @"皮城女警：凯特琳（Caitlyn）",
                       @"魔蛇之拥：卡西奥佩娅（Cassiopeia）",
                       @"虚空恐惧：科’加斯（ChoGath）",
                       @"英勇投弹手：库奇（Corki）",
                       @"诺克萨斯之手：德莱厄斯（Darius）",
                       @"皎月女神：黛安娜：（Diana）",
                       @"祖安狂人：蒙多医生（DrMundo）",
                       @"荣耀行刑官：德莱文（Delevin）",
                       @"蜘蛛女皇：伊莉斯（Elise）",
                       @"寡妇制造者：伊芙琳（Evelynn）",
                       @"探险家：伊泽瑞尔（Ezreal）",
                       @"末日使者：费德提克（Fiddlesticks）",
                       @"无双剑姬：剑姬（Fiora）",
                       @"潮汐海灵：菲兹（Fizz）",
                       @"哨兵之殇：加里奥（Galio）",
                       @"海洋之灾：普朗克（Gangplank）",
                       @"德玛西亚之力：盖伦（Garen）",
                       @"酒桶：古拉加斯（Gragas）",
                       @"法外狂徒：格雷福斯（Graves）",
                       @"战争之影：赫卡里姆 （Hecarim）",
                       @"大发明家：黑默丁格（Heimerdinger）",
                       @"刀锋意志：伊瑞利亚（Irelia）",
                       @"风暴之怒：迦娜（Janna）",
                       @"德玛西亚皇子：嘉文四世（JarvanⅣ）",
                       @"武器大师：贾克斯（Jax）",
                       @"未来守护者：杰斯（Jayce）",
                       @"天启者：卡尔玛（Karma）",
                       @"死亡颂唱者：卡尔萨斯（Karthus）",
                       @"虚空行者：卡萨丁（Kassadin）",
                       @"不详之刃：卡特琳娜（Katarina）",
                       @"审判天使：凯尔（Kayle）",
                       @"狂暴之心：凯南（Kennen）",
                       @"虚空掠夺者：卡’兹克（Khazix）",
                       @"深渊巨口：克格’莫（Kog Maw）",
                       @"诡术妖姬：乐芙兰（LeBlanc）",
                       @"盲僧：李青（Lee sin）",
                       @"曙光女神：蕾欧娜（Leona）",
                       @"仙灵女巫：璐璐（lulu）",
                       @"光辉女郎：拉克丝（Lux）",
                       @"熔岩巨兽：墨菲特（Malphite）",
                       @"虚空先知：玛尔扎哈（Malzahar）",
                       @"扭曲树精：茂凯（Maokai）",
                       @"无极剑圣：易（Yi）",
                       @"赏金猎人：厄运小姐（MissFortune）",
                       @"齐天大圣：孙悟空（Monkey king）",
                       @"金属大师：莫德凯撒（Mordekaiser）",
                       @"堕天使：莫甘娜（Morgana）",
                       @"唤潮鲛姬：娜美（Nami）",
                       @"沙漠死神：内瑟斯（Nasus）",
                       @"深海泰坦：诺提勒斯（Nautilus）",
                       @"狂野女猎手：奈德丽（Nidalee）",
                       @"永恒梦魇：魔腾（Nocturne）",
                       @"雪人骑士：努努（Nunu）",
                       @"狂战士：奥拉夫（Olaf）",
                       @"发条魔灵：奥莉安娜（Orianna）",
                       @"战争之王：潘森（Pantheon）",
                       @"钢铁大使：波比（Poopy）",
                       @"披甲龙龟：拉莫斯（Rammus）",
                       @"荒漠屠夫：雷克顿（Renekton）",
                       @"傲之追猎者：雷恩加尔（Rengar）",
                       @"放逐之刃：瑞文（Rivan）",
                       @"机械公敌：兰博（Rumble）",
                       @"流浪法师：瑞兹（Ryze）",
                       @"凛冬之怒：瑟庄妮：（Sejuani）",
                       @"恶魔小丑：萨科（Shaco）",
                       @"暮光之眼：慎（Shen）",
                       @"龙血武姬：希瓦娜（Shyvana）",
                       @"炼金术士：辛吉德（Singed）",
                       @"亡灵勇士：赛恩（Sion）",
                       @"战争女神：希维尔（Sivir）",
                       @"水晶先锋：斯卡纳（Skarner）",
                       @"琴瑟仙女：娑娜（Sona）",
                       @"众星之子：索拉卡（Soraka）",
                       @"策士统领：斯维因（Swain）",
                       @"暗黑元首：辛德拉（Syndra）",
                       @"刀锋之影：泰隆（Talon）",
                       @"宝石骑士：塔里克（Taric）",
                       @"迅捷斥候：提莫（Teemo）",
                       @"魂锁典狱长：锤石（Thresh）",
                       @"麦林炮手：崔丝塔娜（Tristana）",
                       @"诅咒巨魔：特兰德尔（Trundle）",
                       @"蛮族之王：泰达米尔（Tryndamere）",
                       @"卡牌大师：崔斯特（Twisted Fate）",
                       @"瘟疫之源：图奇（Twitch）",
                       @"野兽之灵：乌迪尔（Udyr）",
                       @"首领之傲：厄加特（Urgot）",
                       @"惩戒之箭：韦鲁斯（Varus）",
                       @"暗夜猎手：薇恩（Vayne）",
                       @"邪恶小法师：维伽（Veigar）",
                       @"皮城执法官：蔚（Vi）",
                       @"机械先驱：维克托（Viktor）",
                       @"猩红收割者：弗拉基米尔（Vladimir）",
                       @"雷霆咆哮：沃利贝尔（Volibear）",
                       @"嗜血猎手：沃里克（Warwick）",
                       @"远古巫灵：泽拉斯（Xerath）",
                       @"德邦总管：赵信（XinZhao）",
                       @"掘墓者：约里克(Yorick)",
                       @"影流之主：劫（Zed）",
                       @"爆破鬼才：吉格斯（Ziggs）",
                       @"时光守护者：基兰（Zilean）"];
    return datas;
}

@end
