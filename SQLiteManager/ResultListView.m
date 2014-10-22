//
//  ResultListView.m
//  SQLiteManager
//
//  Created by wuyj on 14-10-20.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "ResultListView.h"
#import "DBManger.h"


@interface ResultListView ()
@property(nonatomic,strong)NSScrollView *tableContainer;
@property(nonatomic,strong)NSTableView  *tableView;
@property(nonatomic,strong)NSTextField  *sqlTextField;
@property(nonatomic,strong)NSTextField  *dbFileTextField;
@property(nonatomic,strong)NSTextField  *keyTextField;
@property(nonatomic,strong)NSText       *dbFileText;
@property(nonatomic,strong)NSText       *keyFileText;
@property(nonatomic,strong)NSText       *sqlFileText;

@property(nonatomic,strong)DBManger * dbMgr;
@property(nonatomic,strong)NSArray *listResult;

@end


@implementation ResultListView




- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.dbFileText = [[NSText alloc] initWithFrame:CGRectMake(10, frame.size.height-60, 90, 20)];
        [_dbFileText setString:@"数据库文件："];
        [_dbFileText setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_dbFileText];
        
        self.dbFileTextField = [[NSTextField alloc] initWithFrame:CGRectMake(100, frame.size.height-60, 400, 20)];
        [_dbFileTextField setBackgroundColor:[NSColor whiteColor]];
        [self addSubview:_dbFileTextField];
        
        
        self.keyFileText = [[NSText alloc] initWithFrame:CGRectMake(500, frame.size.height-60, 80, 20)];
        [_keyFileText setString:@"数据库key："];
        [_keyFileText setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_keyFileText];
        
        self.keyTextField = [[NSTextField alloc] initWithFrame:CGRectMake(580, frame.size.height-60, 200, 20)];
        [_keyTextField setBackgroundColor:[NSColor whiteColor]];
        [self addSubview:_keyTextField];
        
        self.sqlFileText = [[NSText alloc] initWithFrame:CGRectMake(10, frame.size.height-100, 70, 20)];
        [_sqlFileText setString:@"输入SQL:"];
        [_sqlFileText setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_sqlFileText];
        
        self.sqlTextField = [[NSTextField alloc] initWithFrame:CGRectMake(70, frame.size.height-150, 600, 70)];
        [_sqlTextField setBackgroundColor:[NSColor whiteColor]];
        [self addSubview:_sqlTextField];

        
        NSButton *executeBtn =[[NSButton alloc] init];
        [executeBtn setFrame:NSMakeRect(690, frame.size.height-155, 60, 35)];
        [executeBtn setBezelStyle:NSTexturedRoundedBezelStyle];
        [executeBtn setTitle:@"执行"];
        [executeBtn setTarget:self];
        [executeBtn setAction:@selector(buttonAction:)];
        [self addSubview:executeBtn];
        
        
        self.tableView = [[NSTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-165)];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[NSColor whiteColor]];
        [_tableView setGridColor:[NSColor lightGrayColor]];
        [_tableView setTarget:self];
        [_tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
        [_tableView setGridStyleMask: NSTableViewSolidHorizontalGridLineMask|NSTableViewSolidVerticalGridLineMask];
        
        self.tableContainer = [[NSScrollView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height-165)];
        [_tableContainer setDocumentView:_tableView];
        [_tableContainer setBackgroundColor:[NSColor clearColor]];
        [_tableContainer setHasVerticalScroller:YES];
        [_tableContainer setHasHorizontalScroller:YES];
        [self addSubview:_tableContainer];
        
        self.dbMgr = [[DBManger alloc] init];
    }
    return self;
}

-(void)buttonAction:(NSButton*)sender{
    [_tableView beginUpdates];
    self.listResult = nil;
    for (NSInteger i = [_tableView tableColumns].count - 1; i >=0 ; i--) {
        NSTableColumn * column = [[_tableView tableColumns] objectAtIndex:i];
        [_tableView removeTableColumn:column];
    }
    
    [_tableView reloadData];
    [_tableView endUpdates];

    
    NSString* sqlString = self.sqlTextField.stringValue;
    NSString* dbFile = self.dbFileTextField.stringValue;
    NSString* key = self.keyTextField.stringValue;
    
    if ((sqlString != nil && [sqlString length] > 0) &&
        (dbFile != nil && [dbFile length] > 0)) {
        
        if (key != nil && [key length] > 0 ) {
            self.listResult = [_dbMgr executeSQL:dbFile KEY:key SQL:sqlString];
        }else{
            self.listResult = [_dbMgr executeSQL:dbFile KEY:nil SQL:sqlString];
        }
        
        if ([self.listResult count] > 0) {
            NSDictionary* dic = [self.listResult objectAtIndex:0];
            
            [self addColumn:indexIdentifier withTitle:@"序号"];
            
            NSArray*keys = [dic allKeys];
            for (int i = 0; i < [keys count]; i ++) {
                NSString *key = [keys objectAtIndex:i];
                if (![key isEqualToString:indexIdentifier]) {
                    [self addColumn:key withTitle:key];
                }
                
            }
        }
        
        [_tableView reloadData];
        
    }
}

- (void)addColumn:(NSString*)newid withTitle:(NSString*)title{
    NSTableColumn *column=[[NSTableColumn alloc] initWithIdentifier:newid];
    [[column headerCell] setStringValue:title];
    [[column headerCell] setAlignment:NSCenterTextAlignment];
    [column setWidth:100.0];
    [column setMinWidth:50];
    [column setEditable:NO];
    [column setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
    [_tableView addTableColumn:column];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}



#pragma mark - table view data source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.listResult count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (row < [self.listResult count]) {
        NSDictionary * dic = [self.listResult objectAtIndex:row];
        NSString* identifer = [tableColumn identifier];
        
        id valueObj = [dic objectForKey:identifer];
        if ([valueObj isKindOfClass:[NSString class]]) {
            return valueObj;
        }else if ([valueObj isKindOfClass:[NSNumber class]]){
            return [NSString stringWithFormat:@"%ld",(long)[(NSNumber*)valueObj integerValue]];
        }else{
            return @"";
        }
    }

    return @"";
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 30;
}

@end
