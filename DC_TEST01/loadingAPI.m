#include <QuartzCore/CALayer.h>
#import "NSString+Encode.h"
#import "SFHFKeychainUtils.h"

#import "loadingAPI.h"
@implementation loadingAPI

-(id)init
{
    //NSLog(@"test２");
    
    self = [super init];
    if (self != nil) 
    {       
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
        
        passCode=[defaults stringForKey:@"MDAC_PASSCODE"];         
        
        Category=[defaults stringForKey:@"MDAC_CATEGORY"];
        
        //Uid =1;// 329;
        //passCode =@"qhz421S2hE7yvHyO6y35";
        
        encPassCode=[passCode encodeString:NSUTF8StringEncoding];
        NSLog(@"loadingAPI起動 %d %@",Uid,encPassCode);
        
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}






///URLとURLエンコ用パラメータを合体させrequestUrlに送る
/*-(NSString *)setEncodeString:(NSString *)urlString:(NSString *)paramString
 {
 NSString *encodeString = [paramString encodeString:NSUTF8StringEncoding];
 NSString *urlString2 = [NSString stringWithFormat:@"%@%@",urlString, encodeString];
 NSString *url = [NSURL URLWithString:urlString2];
 
 return url;
 }*/




//投稿データエンコ＆URLに合体 サーバーアクセス
- (NSDictionary *) requestURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    //NSLog(@"url%@",url);
    //NSLog(@"request%@",jsonString);
    
    NSDictionary * restmp = [jsonString JSONValue]; // SBJsonを使った解析
    return restmp;
}


- (UIImage *) changeImageStyle:(UIImage *)baseImage
                              :(int)dw :(int)dh
                              :(int)cx :(int)cy
                              :(NSString *)fmt
                              :(int)fs
                              :(float)gm
                              :(int)st :(int)sp
                              :(int)dr
                              :(int)zr :(int)zp
{
    //?sr.dw=100&sr.dh=100サイズ変換
    NSString *type1=@"";
    if(dw!=0)
        type1=[NSString stringWithFormat:@"&sr.dw=%d&sr.dh=%d",dw,dh];
    
    //?sr.cx=2&sr.cy=2中央クロップ
    NSString *type2=@"";
    if(cx!=0)
        type2=[NSString stringWithFormat:@"&sr.cx=%d&sr.cy=%d",cx,cy];
    
    //?sr.fmt=JPEG JPG変換
    NSString *type3=@"";
    if(fmt!=@"")
        type3=[NSString stringWithFormat:@"&sr.fmt=%@",fmt];
    
    //?sr.fs=800ファイルサイズ上限（バイト）
    NSString *type4=@"";
    if(cx!=0)
        type4=[NSString stringWithFormat:@"&sr.fs=%d",fs];
    
    //?sr.gm=0.5ガンマ補正（float）    
    NSString *type5=@"";
    if(cx!=0)
        type5=[NSString stringWithFormat:@"&sr.gm=%f",gm];
    
    //?sr.st=1&sr.sp=3スタンプ合成
    NSString *type6=@"";
    if(st!=0)
        type6=[NSString stringWithFormat:@"&sr.st=%d&sr.sp=%d",st,sp];
    
    //?sr.dr=80サイズ比率変更（％）
    NSString *type7=@"";
    if(dr!=0)
        type7=[NSString stringWithFormat:@"&sr.dr=%d",dr];
    
    //?sr.zr=300&sr.zp=5拡大変換（100=1倍）
    NSString *type8=@"";
    if(zr!=0)
        type8=[NSString stringWithFormat:@"&sr.zr=%d&sr.zp=%d",zr,zp];
    
    
    NSString *urlString = [NSString stringWithFormat:CV_SERVER_URL "%@?%@%@%@%@%@%@%@%@",baseImage,type1,type2,type3,type4,type5,type6,type7,type8];
    NSURL *url = [NSURL URLWithString: urlString];
    NSData *data = [NSData dataWithContentsOfURL: url];
    
    
    // イメージの回転
    //CGAffineTransform rotate = CGAffineTransformMakeRotation(3.0f * (M_PI / 180.0f));
    //[img2 setTransform:rotate];
    
    return [UIImage imageWithData: data];
}






- (NSDictionary *)getPickupPicture//ピックアップ画像
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPickup/category:%@",Category];
    
    NSLog(@"pickup %@",urlString);
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
    
}





- (NSDictionary *)getPostimageByNewList : (int) offset:(int) limit//新着画像一覧
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageByNew/category:%@/offset:%d/limit:%d",Category,offset,limit];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
    
}









-(NSDictionary *)getTopActivity:(int)flag//Topのアクティビティ一覧
{
    NSString *urlString;
    if(flag==-1) urlString = DATA_SERVER_URL "gw/getTopActivity";    
    else        urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getTopActivity/uid:%d/pass_code:%@",Uid,encPassCode];
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}




//カテゴリ一覧を取得します。
-(NSDictionary *)getCategory
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getCategory"];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}



//アクティビティを既読
-(NSDictionary *)updateReadFlag:(NSString *)activity_id
{
    
    /*  NSString *paramString= [NSMutableString stringWithFormat:@"%@,%@",Uid,log_date];
     // 引数エンコード
     NSString *encodeString = [paramString encodeString:NSUTF8StringEncoding];
     */ 
    
    NSLog(@"act %d",activity_id);
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/updateReadFlag/uid:%d/pass_code:%@/activity_id:%@",Uid,encPassCode,activity_id];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 public static void updateReadFlag(List<ActivityMessageData> list)
 throws Exception {
 try {
 StringBuffer sb = new StringBuffer();
 if (list != null) {
 for (int i = 0; i < list.size(); i++) {
 if (i != 0) {
 sb.append(",");
 }
 sb.append(list.get(i).getActivityId());
 }
 }
 JSONObject o = ha.getJson(Const.DATA_SERVER_URL
 + "/gw/updateReadFlag/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/activity_id:" + URLEncoder.encode(sb.toString()));
 Log.d(GetViewDataLogic.class.getName(), "result:"
 + o.getJSONObject("result").get("action"));
 } catch (Exception ex) {
 Log.e(GetViewDataLogic.class.getName(), ex.getMessage(), ex);
 throw ex;
 }
 }
 */






//ロック確認
-(NSDictionary *) isLocked
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/isLocked/uid:%d",Uid];
    NSLog(@"url %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}

/*
 + "/gw/isLocked/uid:" + ApplicationSettings.getMdacUid());
 Log.d(GetViewDataLogic.class.getName(), "isLocked:"
 + o.getJSONObject("result").get("locked"));
 */


//アクティビティ一覧を取得します。
-(NSDictionary *)getActivity:(int)offset :(int)limit
{
    int nowUid=-1;
    if(Uid>=1)  nowUid=Uid;
    
    NSString *urlString;
    if(nowUid==-1)    urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getActivity/uid:%d/offset:%d/limit:%d",nowUid,offset,limit];
    else            urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getActivity/uid:%d/pass_code:%@/offset:%d/limit:%d",nowUid,encPassCode,offset,limit];
    
    NSLog(@"getactivity %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}






-(NSDictionary *)login//ログイン
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "/gw/login/uid:%d/pass_code:%@",Uid,encPassCode];
    
    NSDictionary * restmp =[self requestURL:urlString];    
    return restmp;
}









//投稿イメージMapからImageInfoのリストへ変換
-(NSDictionary *)convert :(int)width :(int)height
{
    return;
}

/*
 Map<String, String> m = list.get(i);
 ImageInfo ii = new ImageInfo();
 if (!StringUtil.isNullOrEmpty(m.get("real_path"))) {
 ii.setPostImageId(Long.parseLong((String) m
 .get("post_image_id")));
 ii.setImageId(Long.parseLong((String) m.get("image_id")));
 ii.setUrl(Const.IMAGE_SERVER_URL + m.get("real_path"));
 ii.setWidth(width);
 ii.setHeight(height);
 }
 iis.add(ii);
 }
 }
 return iis;
 } 
 
 
 */


//トップのデータを取得
//データ取得中はブロッキング。ブロッキング解除は、ImageListenerは、finished時にnotifyAll()を呼ぶ
/*-(NSDictionary *)loadTopData:(NSString *)lp:(NSString *)il
 {}
 
 ///////////////////////
 * @param lp
 * @param il
 public static void loadTopData(SplashActivity.SetLoadProgress lp,
 ImageListener il) throws Exception {
 List<ImageInfo> images = new ArrayList<ImageInfo>();
 getPickupList(images);
 lp.setLoadProgress(12);
 getTopNewList(images);
 lp.setLoadProgress(15);
 
 List<Map<String, String>> publictags = getPublicTagList();
 lp.setLoadProgress(18);
 List<String> tags = new ArrayList<String>();
 for (int i = 0; i < publictags.size(); i++) {
 tags.add(publictags.get(i).get("tag"));
 lp.setLoadProgress(18 + 2 * (i + 1));
 }
 ViewData.setPublicTags(tags);
 lp.setLoadProgress(30);
 getTagLists(lp, images);
 
 ImageManager.request(new RequestImage(images, il));
 
 try {
 synchronized (il) {
 il.wait();
 }
 } catch (InterruptedException ex) {
 }
 
 ViewData.setActivityList(getTopActivity());
 }
 */




//ユーザ情報の削除
-(NSDictionary *)deleteUser
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/deleteUser/uid:%d/pass_code:%@",Uid,encPassCode];
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/deleteUser/uid:" + ApplicationSettings.getMdacUid()
 + "/pass_code:" + ApplicationSettings.getMdacPasscode());
 Log.d(GetViewDataLogic.class.getName(), "result:"
 */



//ユーザ移行のリクエスト
-(NSDictionary *)requestUserShift :(NSString *)passNo
{
    NSString *encpassNo=[passNo encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/requestUserShift?uid=%d&pass_code=%@&pass_no=%@",Uid,encPassCode,encpassNo];
    //NSLog(@"url %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/requestUserShift?uid="
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "&pass_code=" + ApplicationSettings.getMdacPasscode()
 + "&pass_no=" + passNo);
 return o.getJSONObject("result").getString("shift_no");
 */




//ユーザ移行
-(NSDictionary *)processUserShift :(NSString *)shiftNo :(NSString *)passNo
{
    // NSString *encshiftNo=[shiftNo encodeString:NSUTF8StringEncoding];
    // NSString *encpassNo=[passNo encodeString:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/processUserShift?shift_no=%@&pass_no=%@",shiftNo,passNo];
    
    NSLog(@"url %@",urlString);
    
    NSDictionary * restmp =[self requestURL:urlString];
    
    return restmp;
}
/*
 + "/gw/processUserShift?shift_no=" + shiftNo + "&pass_no="
 + passNo);
 
 if (list.size() > 0) {
 UserData user = new UserData();
 user.setUid(Integer.parseInt(list.get(0).get("uid")));
 user.setPassCode(list.get(0).get("pass_code"));
 user.setName(list.get(0).get("name"));
 return user;
 */


//ユーザ情報を取得
-(NSDictionary *)getUserInfo :(int)uid
{
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getUserInfo/uid:%d",uid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getUserInfo/uid:" + String.valueOf(uid));
 */

//ユーザ情報の変更
-(NSDictionary *)changeProfile :(NSString *)newName:(NSString *)profComment:(NSString *)birthDay
{
    NSString *encnewName=[newName encodeString:NSUTF8StringEncoding];
    NSString *encprofComment=[profComment encodeString:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/changeProfile?uid=%d&pass_code=%@&new_name=%@&profile_comment=%@&birth_date=%@",Uid,encPassCode,encnewName,encprofComment,birthDay];
    
    NSLog(@"urlString %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];       
    return restmp;
}
/* String birthDay = "";
 if (data.getBirthDay() != null) {
 birthDay = "&birth_date="
 + Formatter.format(data.getBirthDay(), "yyyy-MM-dd");
 
 + "/gw/changeProfile?uid=" + String.valueOf(data.getUid())
 + "&pass_code=" + data.getPassCode() + "&new_name="
 + URLEncoder.encode(data.getName()) + "&profile_comment="
 + URLEncoder.encode(data.getProfileComment()) + birthDay);
 
 Log.d(GetViewDataLogic.class.getName(), "result:"
 + o.getJSONObject("result").get("action"));
 } catch (Exception ex) {
 Log.e(GetViewDataLogic.class.getName(), ex.getMessage(), ex);
 throw ex;
 }
 }
 */


//ユーザアイコンのパスを取得
-(NSDictionary *) getUserIconPath :(int)uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getUserIconPath/uid:%d",Uid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getUserIconPath/uid:" + String.valueOf(uid));
 */




//未読アクティビティ一覧を取得
-(NSDictionary *)getNewActivity 
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getNewActivity/uid:%d/pass_code:%@",Uid,encPassCode];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 
 + "/gw/getNewActivity/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode());
 ∂
 */


//タグリストを取得します。
- (NSDictionary *)getTagLists:(NSString *)tag:(int)offset:(int)limit
{
    NSString *enctag=[tag encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageByEvaluation?category=%@&tag=%@&offset=%d&limit=%d",Category,enctag,offset,limit];
    //NSLog(@"url %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];    
    return restmp;
}
/*
 + "/gw/getPostimageByEvaluation?category="
 + URLEncoder.encode(ApplicationSettings
 .getCategoryString()) + "&tag="
 + URLEncoder.encode(ViewData.getPublicTags().get(j))
 + "&offset=0&limit=10");
 
 List<Map<String, String>> list = ResultConverter.json2List(o);
 List<ImageInfo> iis = new ArrayList<ImageInfo>();
 if (list != null) {
 for (int i = 0; i < list.size(); i++) {
 Map<String, String> m = list.get(i);
 ImageInfo ii = new ImageInfo();
 ii.setPostImageId(Long.parseLong((String) m
 .get("post_image_id")));
 ii.setImageId(Long.parseLong((String) m.get("image_id")));
 ii.setUrl(Const.IMAGE_SERVER_URL + m.get("real_path"));
 ii.setWidth(126);
 ii.setHeight(126);
 images.add(ii);
 iis.add(ii);
 }
 }
 
 tagLists.add(list);
 iiss.add(iis);
 lp.setLoadProgress(30 + 10 * (j + 1)
 / ViewData.getPublicTags().size());
 }
 ViewData.setTagLists(tagLists);
 ViewData.setImageTagLists(iiss);
 } catch (Exception ex) {
 Log.e(GetViewDataLogic.class.getName(), ex.getMessage(), ex);
 throw ex;
 }
 }
 */



//公式タグ一覧を取得します。
-(NSDictionary *)getPublicTagList
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPublictag"];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}




//タグクラウドの一覧を取得します。
-(NSDictionary *) getTagCloud
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getTagCloud"];
    //∂NSLog(@"url %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 .getJson(Const.DATA_SERVER_URL + "/gw/getTagCloud");
 */    



//新着画像の件数を取得
- (NSDictionary *)getPostimageCountByNew//:(int)category
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageCountByNew/category:%@",Category];
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getPostimageCountByNew/category:"
 + URLEncoder.encode(ApplicationSettings
 .getCategoryString()));
 */

//評価順画像の件数を取得します。
- (NSDictionary *)getPostimageCountByEvaluation :(NSString *)tag// :(NSString *)category
{
    NSString *enctag=[tag encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageCountByEvaluation?tag=%@&category=%@",enctag,Category];
    NSDictionary * restmp =[self requestURL:urlString];    
    return restmp;   
}
/*
 + "/gw/getPostimageCountByEvaluation?tag="
 + URLEncoder.encode(tag)
 + "&category="
 + URLEncoder.encode(ApplicationSettings
 .getCategoryString()));
 */




//検索一覧の件数を取得
-(NSDictionary *) searchPostimageCount :(NSString *)keyword//:(int)category
{
    NSString *enckeyword=[keyword encodeString:NSUTF8StringEncoding];    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/searchPostimageCount?keyword=%@&category=%@",enckeyword,Category];
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/searchPostimageCount?keyword="
 + URLEncoder.encode(keyword)
 + "&category="
 + URLEncoder.encode(ApplicationSettings
 .getCategoryString()));
 */




//画像検索一覧
-(NSDictionary *)searchPostimage :(NSString *)keyword :(NSString *)sort :(int)offset :(int)limit
{
    NSString *enckeyword=[keyword encodeString:NSUTF8StringEncoding];
    NSString *encsort=[sort encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/searchPostimage?keyword=%@&sort=%@&category=%@&offset=%d&limit=%d",enckeyword,encsort,Category,offset,limit];
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*	
 + "/gw/searchPostimage?keyword="
 + URLEncoder.encode(keyword)
 + "&sort="
 + String.valueOf(sort)
 + "&category="
 + URLEncoder.encode(ApplicationSettings
 .getCategoryString()) + "&offset=" + offset
 + "&limit=" + limit);
 */





//画像の投稿処理
-(NSDictionary *)savePostimage :(long)imageId :(int)categoryId :(NSString *)postImageName :(NSString *)comment
{
    NSString *encpostImageName=[postImageName encodeString:NSUTF8StringEncoding];
    NSString *enccomment=[comment encodeString:NSUTF8StringEncoding];
    
    
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/savePostimage?uid=%d&pass_code=%@&image_id=%d&category_id=%d&post_image_name=%@&comment=%@",Uid,encPassCode,imageId,categoryId,encpostImageName,enccomment];
    
    NSLog(@"savepostimage %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/savePostimage?uid="
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "&pass_code=" + ApplicationSettings.getMdacPasscode()
 + "&image_id=" + String.valueOf(imageId) + "&category_id="
 + String.valueOf(categoryId) + "&post_image_name="
 + URLEncoder.encode(postImageName) + "&comment="
 + URLEncoder.encode(comment));
 */    


//画像情報の更新
-(NSDictionary *)updatePostimage :(long)postImageId :(int)categoryId :(NSString *)postImageName :(NSString *)comment
{
    NSString *encpostImageName=[postImageName encodeString:NSUTF8StringEncoding];
    NSString *enccomment=[comment encodeString:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/updatePostimage?uid:%d&pass_code=%@&post_image_id=%d&category_id=%d&post_image_name=%@&comment=%@",Uid,encPassCode,postImageId,categoryId,encpostImageName,enccomment];
    NSDictionary *restmp =[self requestURL:urlString];    
    return restmp;
}
/*
 + "/gw/updatePostimage?uid="
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "&pass_code=" + ApplicationSettings.getMdacPasscode()
 + "&post_image_id=" + String.valueOf(postImageId)
 + "&category_id=" + String.valueOf(categoryId)
 + "&post_image_name=" + URLEncoder.encode(postImageName)
 + "&comment=" + URLEncoder.encode(comment));
 */




//投稿イメージの詳細を取得
-(NSDictionary *)detailPostimage :(long)postImageId :(int)uid
{
    
    NSString *urlString;
    if(uid==-1) urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/detailPostimage/post_image_id:%d",postImageId];
    else        urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/detailPostimage/post_image_id:%d/uid:%d",postImageId,Uid];
    
    NSDictionary * restmp =[self requestURL:urlString];    
    return restmp;
}

/*	
 + "/gw/detailPostimage/post_image_id:" + postImageId);
 } else {
 sb.append(Const.DATA_SERVER_URL
 + "/gw/detailPostimage/post_image_id:" + postImageId
 + "/uid:" + String.valueOf(uid));
 
 */



//投稿イメージの削除
-(NSDictionary *) deletePostimage:(long)postImageId
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/deletePostimage/uid:%d/pass_code:%@/post_image_id:%d",Uid,encPassCode,postImageId];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}

/*
 + "/gw/deletePostimage/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/post_image_id:" + String.valueOf(postImageId));
 */


//タグの登録
-(NSDictionary *)saveTags:(NSString *)postImageId :(NSString *)taglist
{
    //NSString *enctag=[taglist encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveTags?uid=%d&pass_code=%@&post_image_id=%@&tags=%@",Uid,encPassCode,postImageId,taglist];
    
    NSLog(@"savetag %@",urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/saveTags?uid="
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "&pass_code=" + ApplicationSettings.getMdacPasscode()
 + "&post_image_id=" + String.valueOf(postImageId)
 + "&tags=" + URLEncoder.encode(sb.toString()));
 */


//タグ一覧を取得
-(NSDictionary *)getTags:(long)postImageId
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getTags/post_image_id:%d",postImageId];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getTags/post_image_id:"
 + String.valueOf(postImageId));
 */



//いいね評価
- (NSDictionary *)saveEvaluation:(long)postImageId
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveEvaluation/uid:%d/pass_code:%@/post_image_id:%d",Uid,encPassCode,postImageId];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/saveEvaluation/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/post_image_id:" + String.valueOf(postImageId));
 */



//通報
-(NSDictionary *) saveReport:(long)postImageId :(int)reasons
{
    //NSString *encreason=[reasons encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveReport/uid:%d/pass_code:%@/post_image_id:%d/reason:%d",Uid,encPassCode,postImageId,reasons];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/saveReport/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/post_image_id:" + String.valueOf(postImageId)
 + "/reason:" + String.valueOf(reason));
 */

//コメント一覧を取得
-(NSDictionary *) getComment:(long)postImageId: (int)offset :(int)limit
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getComment/post_image_id:%d/offset:%d/limit:%d",postImageId,offset,limit];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getComment/post_image_id:"
 + String.valueOf(postImageId) + "/offset:"
 + String.valueOf(offset) + "/limit:"
 + String.valueOf(limit));
 */


-(NSDictionary *)saveComment:(long)postImageId:(NSString *)comment
{
    NSString *enccomment=[comment encodeString:NSUTF8StringEncoding];    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveComment?uid=%d&pass_code=%@&post_image_id=%d&comment=%@",Uid,encPassCode,postImageId,enccomment];
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/saveComment?uid="
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "&pass_code=" + ApplicationSettings.getMdacPasscode()
 + "&post_image_id=" + String.valueOf(postImageId)
 + "&comment=" + URLEncoder.encode(comment));
 */



//SNS投稿記録を保存
-(NSDictionary *) saveSnsHistory:(NSString *)postImageId
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveSnsHistory/uid:%d/pass_code:%@/post_image_id:%@",Uid,encPassCode,postImageId];
    NSDictionary * restmp =[self requestURL:urlString];
    
    NSLog(@"url%@ restmp%@",urlString,restmp);
    return restmp;
}
/*
 + "/gw/saveSnsHistory/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/post_image_id:" + String.valueOf(postImageId));
 */


//キャンディの登録
-(NSDictionary *) saveCandy:(int)targetUid:(int)candy
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveCandy/uid:%d/pass_code:%@/target_uid:%d/candy:%d",Uid,encPassCode,targetUid,candy];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/saveCandy/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/target_uid:" + String.valueOf(targetUid) + "/candy:"
 + String.valueOf(candy));
 */



//バッジ一覧を取得
-(NSDictionary *) getDecorationList:(int)uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getDecorationList/uid:%d",uid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getDecorationList/uid:" + String.valueOf(uid));
 */


//キュレーター称号一覧を取得
-(NSDictionary *) getTitleList
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getTitleList/uid:%d",Uid];
    //NSLog(@"*urlString* = %@", urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
-(NSDictionary *) getFanTitleList:(int)uid
{    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getTitleList/uid:%d",uid];
    NSLog(@"*fanurlString* = %@", urlString);
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getTitleList/uid:" + String.valueOf(uid));
 */

//アルバムを作成
-(NSDictionary *) createAlbum:(NSString *)albumName
{
    NSString *encalbumName=[albumName encodeString:NSUTF8StringEncoding];   
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/createAlbum?uid=%d&pass_code=%@&album_name=%@",Uid,encPassCode,encalbumName];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/createAlbum?uid="
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "&pass_code=" + ApplicationSettings.getMdacPasscode()
 + "&album_name=" + URLEncoder.encode(albumName));
 */


//アルバム一覧を取得
-(NSDictionary *) getAlbumList:(int)uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getAlbumList/uid:%d",uid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getAlbumList/uid:" + String.valueOf(uid));
 */




//アルバム名の保存
-(NSDictionary *) saveAlbumName:(int)albumId :(NSString *)albumName
{
    NSString *encalbumName=[albumName encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveAlbumName?uid=%d&pass_code=%@&album_id=%d&album_name=%@",Uid,encPassCode,albumId,encalbumName];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/saveAlbumName?uid="
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "&pass_code=" + ApplicationSettings.getMdacPasscode()
 + "&album_id=" + String.valueOf(albumId) + "&album_name="
 + URLEncoder.encode(albumName));
 */



//アルバムアイコンの変更
-(NSDictionary *) saveAlbumIcon:(int)albumId:(long) postImageId
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveAlbumIcon/uid:%d/pass_code:%@/album_id:%d/post_image_id:%d",Uid,encPassCode,albumId,postImageId];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/saveAlbumIcon/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/album_id:" + String.valueOf(albumId)
 + "/post_image_id:" + String.valueOf(postImageId));
 */


//アルバムの削除を行います。
-(NSDictionary *) deleteAlbum:(int)albumId
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/deleteAlbum/uid:%d/pass_code:%@/album_id:%d",Uid,encPassCode,albumId];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
    
}
/*
 + "/gw/deleteAlbum/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/album_id:" + String.valueOf(albumId));
 */


//アルバムイメージ件数を取得
-(NSDictionary *) getAlbumimageCount:(int) uid :(int) albumId
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getAlbumimageCount/uid:%d/album_id:%d",uid,albumId];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getAlbumimageCount/uid:" + String.valueOf(uid)
 + "/album_id:" + String.valueOf(albumId));
 */



//アルバムイメージ一覧
-(NSDictionary *)getAlbumimageList:(int) albumId:(int) offset:(int) limit
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getAlbumimageList/uid:%d/album_id:%d/offset:%d/limit:%d",Uid,albumId,offset,limit];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;  
}
/*
 + "/gw/getAlbumimageList/uid:" + String.valueOf(uid)
 + "/album_id:" + String.valueOf(albumId) + "/offset:"
 + offset + "/limit:" + limit);
 */



//アルバムに画像を登録
-(NSDictionary *)saveAlbumimage:(int) albumId:(long) postImageId:(NSString *) isFromAlbum:(int) fromAlbumUid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveAlbumimage/uid:%d/pass_code:%@/album_id:%d/post_image_id:%d/from_album:%@/from_album_uid:%d",Uid,encPassCode,albumId,postImageId,isFromAlbum,fromAlbumUid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;  
}
/*
 + "/gw/saveAlbumimage/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/album_id:" + String.valueOf(albumId)
 + "/post_image_id:" + String.valueOf(postImageId)
 + "/from_album:" + (isFromAlbum ? "true" : "false")
 + "/from_album_uid:" + String.valueOf(fromAlbumUid));
 */


//アルバムから画像を削除
-(NSDictionary *)deleteAlbumimage:(int) albumId:(int) post_image_id
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/deleteAlbumimage/uid:%d/pass_code:%@/album_id:%d/post_image_id:%d",Uid,encPassCode,albumId,post_image_id];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;  
}
/*
 + "/gw/deleteAlbumimage/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/album_id:" + String.valueOf(albumId)
 + "/post_image_id:" + String.valueOf(postImageId));
 */


//フォロー件数
-(NSDictionary *)getFollowingCount:(int)uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getFollowingCount/uid:%d",uid];
    NSDictionary * restmp =[self requestURL:urlString];    
    return restmp;
}

/*
 + "/gw/getFollowingCount/uid:" + String.valueOf(uid));
 */

//フォロワー件数
-(NSDictionary *)getFollowerCount:(int)uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getFollowerCount/uid:%d",uid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getFollowerCount/uid:" + String.valueOf(uid));
 */


//フォロー一覧
-(NSDictionary *)getFollowingList:(int)uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getFollowingList/uid:%d",uid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/getFollowingList/uid:" + String.valueOf(uid));
 */


//フォロワー一覧
-(NSDictionary *)getFollowerList:(int) uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getFollowerList/uid:%d/my_uid:%d",uid,Uid];
    NSDictionary *restmp =[self requestURL:urlString];
    return restmp;
}

/*
 + "/gw/getFollowerList/uid:" + String.valueOf(uid)
 + "/my_uid:" + ApplicationSettings.getMdacUid());
 */




//フォローする
-(NSDictionary *)saveFollow:(int) followUid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveFollow/uid:%d/pass_code:%@/follow_uid:%d",Uid,encPassCode,followUid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
    
}
/*
 + "/gw/saveFollow/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/follow_uid:" + String.valueOf(followUid));
 */



//フォロー解除
-(NSDictionary *)deleteFollow:(int) followUid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/deleteFollow/uid:%d/pass_code:%@/follow_uid:%d",Uid,encPassCode,followUid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}
/*
 + "/gw/deleteFollow/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/follow_uid:" + String.valueOf(followUid));
 */






//ブロック一覧を取得
-(NSDictionary *)getBlockList
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getBlockList/uid:%d/pass_code:%@",Uid,encPassCode];
    NSDictionary * restmp =[self requestURL:urlString];
    
    return restmp;
}

/*
 + "/gw/getBlockList/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode());
 */

// ブロックします。
-(NSDictionary *)saveBlock:(int) block_uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/saveBlock/uid:%d/pass_code:%@/block_uid:%d",Uid,encPassCode,block_uid];
    NSDictionary * restmp =[self requestURL:urlString];
    
    return restmp;
}

/*	
 + "/gw/saveBlock/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/block_uid:" + String.valueOf(blockUid));
 */



//ブロック解除します。
-(NSDictionary *)deleteBlock:(int) block_uid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/deleteBlock/uid:%d/pass_code:%@/block_uid:%d",Uid,encPassCode,block_uid];
    NSDictionary * restmp =[self requestURL:urlString];
    
    return restmp;
    
}
/*
 + "/gw/deleteBlock/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/block_uid:" + String.valueOf(blockUid));
 */


//ブロックユーザか判定
-(NSDictionary *)isBlockUser:(int)targetUid
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/isBlockUser/uid:%d/pass_code:%@/target_uid:%d",Uid,encPassCode,targetUid];
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}

/*
 + "/gw/isBlockUser/uid:"
 + String.valueOf(ApplicationSettings.getMdacUid())
 + "/pass_code:" + ApplicationSettings.getMdacPasscode()
 + "/target_uid:" + String.valueOf(targetUid));
 */





//画像アップロード
- (NSDictionary *)saveImage :(UIImage *)imageData
{
    // エラー処理
    if (imageData == nil)    NSLog(@"画像ファイルが無い");
    
    // NSData *data = UIImagePNGRepresentation(image);
    CGFloat compressionQuality = 0.8;
    NSData *photo = UIImageJPEGRepresentation(imageData,compressionQuality);
    
    // バウンダリ設定
    NSString *boundary = [NSString stringWithString:@"--meets-dogs-and-cats--"];
    NSMutableData* result_ = [[NSMutableData alloc] init];
    
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"post_image\"; filename=\"%@.jpg\"\r\n\r\n", @"iphone"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSASCIIStringEncoding]];//m
    [result_ appendData:photo];
    [result_ appendData:[[NSString stringWithFormat:@"%@", @"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uid\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"%d\r\n", Uid]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pass_code\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"%@\r\n", passCode]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];  
    // バウンダリ
    
    NSLog(@"uid %d",Uid);
    NSLog(@"pass %@",passCode);
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"size\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"%d\r\n", [photo length] ]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    // リクエストの作成
    NSURL *url = [NSURL URLWithString:DATA_SERVER_URL"gw/uploadImage"];
    //url = [NSURL URLWithString:IMAGE_SERVER_URL];
    
    //NSLog(@"%@",url);
    
    NSMutableURLRequest *request_ = [NSMutableURLRequest requestWithURL:url];
    
    // ログの表示
    NSString *_str= [[NSString alloc] initWithData:result_ encoding:NSUTF8StringEncoding];
    //NSLog(@"log='\r\n%@", _str);
    
    // ヘッダ情報を設定
    [request_ addValue:[NSString stringWithFormat:
                        @"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField: @"Content-Type"];
    
    [request_ setHTTPMethod:@"POST"];
    [request_ setHTTPBody:result_];
    
    // 通信し、リザルトを受け取る
    NSURLResponse *response = nil;
    NSError       *error    = nil;
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request_ 
                                                   returningResponse:&response error:&error];
    //    NSLog(@"%@", url);
    //    NSLog(@"error='%@'", error);
    
    // エラー表示
    NSHTTPURLResponse *urlresponse = (NSHTTPURLResponse *)response;
    //     NSLog(@"レスポンスコード表示 %d",[urlresponse statusCode]);
    
    // リザルト表示
    NSString *http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding]
                             autorelease];
    NSLog(@"result='%@'", http_result);
    
    // リザルト解放
    [result_ release], result_ = nil;
    
    NSDictionary * restmp = [http_result JSONValue];
    return restmp;
}

//短縮URL取得
-(NSDictionary *)getEncodeURL:(NSString *)post_image_id
{
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/encode/post_image_id:%@",post_image_id];
    
    NSLog(@"url %@",urlString);
    
    NSDictionary * restmp =[self requestURL:urlString];
    return restmp;
}

@end
