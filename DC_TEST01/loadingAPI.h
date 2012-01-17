
#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class loadingAPI;
@interface loadingAPI : UIViewController 
{
    int Uid;
    NSString* Category;
    NSString* passCode;
    NSString* encPassCode;//エンコ済みパスコード
}
-(id)init;

//- (int)getNowOffsetLoadCount;
- (NSString *)setEncodeString:(NSString *)urlString:(NSString *)paramString;

- (NSDictionary *) requestURL:(NSString *)urlString;
- (UIImage *) changeImageStyle:(UIImage *)baseImage
                              :(int)dw :(int)dh
                              :(int)cx :(int)cy
                              :(NSString *)fmt
                              :(int)fs
                              :(float)gm
                              :(int)st :(int)sp
                              :(int)dr
                              :(int)zr :(int)zp;



- (NSDictionary *)getPickupPicture;
- (NSDictionary *)getPostimageByNewList : (int) offset:(int) limit;
- (NSDictionary *)getTopActivity:(int)flag;//Topのアクティビティ一覧


-(NSDictionary *)convert :(int)width :(int)height;//
-(NSDictionary *)loadTopData;//:(NSString *)lp:(NSString *)il;//TOPデータ取得

-(NSDictionary *)updateReadFlag:(NSString *)activity_id;

-(NSDictionary *)deleteUser;
-(NSString *)requestUserShift :(NSString *)passNo;
-(NSDictionary *)processUserShift :(NSString *)shiftNo :(NSString *)passNo;
-(NSDictionary *)getUserInfo :(int)uid;

-(NSDictionary *)changeProfile :(NSString *)newName:(NSString *)profComment:(NSString *)birthDay;
-(NSDictionary *) getUserIconPath :(int)uid;
-(NSDictionary *)getNewActivity; 

- (NSDictionary *)getTagLists:(NSString *)tag:(int)offset:(int)limit;
-(NSDictionary *)getPublicTagList;
-(NSDictionary *) getTagCloud;
- (NSDictionary *)getPostimageCountByNew;
- (NSDictionary *)getPostimageCountByEvaluation :(NSString *)tag;

-(NSDictionary *)getPostimageByEvaluationList:(NSString *)tag :(int)offset :(int)limit;

-(NSDictionary *) searchPostimageCount :(NSString *)keyword;
-(NSDictionary *)searchPostimage :(NSString *)keyword :(NSString *)sort:(int)offset :(int)limit;
-(NSDictionary *)savePostimage :(long)imageId :(int)categoryId :(NSString *)postImageName :(NSString *)comment;
-(NSDictionary *)updatePostimage :(long)postImageId :(int)categoryId :(NSString *)postImageName :(NSString *)comment;

-(NSDictionary *)getEncodeURL:(NSString *)post_image_id;

-(NSDictionary *)detailPostimage :(long)postImageId :(int)Uid;

-(NSDictionary *) deletePostimage:(long)postImageId;

-(NSDictionary *)isLocked;
-(NSDictionary *)saveTags:(NSString *)postImageId :(NSString *)taglist;
-(NSDictionary *)getTags:(long)postImageId;

-(NSDictionary *)saveEvaluation:(long)postImageId;
-(NSDictionary *) saveReport:(long)postImageId :(int)reason;

-(NSDictionary *) getComment:(long)postImageId :(int)offset :(int)limit;

-(NSDictionary *)saveComment:(long)postImageId:(NSString *)comment;
-(NSDictionary *) saveSnsHistory:(NSString *)postImageId;

-(NSDictionary *) saveCandy:(int)targetUid:(int)candy;


-(NSDictionary *) getDecorationList:(int)uid;

-(NSDictionary *) getFanTitleList:(int)uid;
-(NSDictionary *) getTitleList;
-(NSDictionary *) createAlbum:(NSString *)albumName;
-(NSDictionary *) getAlbumList:(int)uid;
-(NSDictionary *) saveAlbumName:(int)albumId :(NSString *)albumName;
-(NSDictionary *) saveAlbumIcon:(int)albumId:(long) postImageId;

-(NSDictionary *) deleteAlbum:(int)albumId;
-(NSDictionary *) getAlbumimageCount:(int) uid :(int) albumId;

-(NSDictionary *)getAlbumimageList:(int) albumId:(int) offset:(int) limit;

-(NSDictionary *)deleteAlbumimage:(int) albumId:(int) post_image_id;
-(NSDictionary *)saveAlbumimage:(int) albumId:(long) postImageId:(NSString *) isFromAlbum :(int) fromAlbumUid;

-(NSDictionary *)getFollowingCount:(int)uid;
-(NSDictionary *)getFollowerCount:(int)uid;

-(NSDictionary *)getFollowingList:(int)uid;
-(NSDictionary *)getFollowerList:(int)uid;
-(NSDictionary *)saveFollow:(int) followUid;
-(NSDictionary *)deleteFollow:(int) followUid;

-(NSDictionary *)getBlockList;

-(NSDictionary *)saveBlock:(int) block_uid;
-(NSDictionary *)deleteBlock:(int) block_uid;
-(NSDictionary *)isBlockUser:(int)targetUid;

-(NSDictionary *)saveImage:(NSData *)imageData;// :(int)imagesize:(NSString *)motoImageID
@end


