//
//  APIAddress.swift
//  Clean
//
//  Created by Inho Lee on 6/9/25.
//

enum ApiAddress {
    static let domain: String = "metasky-plus.com"
#if DEBUG
    enum MODE: String {
        case stage = "stage"
        case dev = "dev"
        case prod = "prod" //DEBUG 환경에서 prod서버에 소셜 로그인 하려면 프로젝트 -> TARGETS -> Build Phase-> Run Script에서 구글 인증서 prod용으로 바꿔줘야함 by 이인호
    }
    static let mode: MODE   = .dev
    
    static let webAddress   = "https://\((mode == .prod) ? ("") : (mode.rawValue + "."))" + domain
    static let apiAddress   = "https://\(mode.rawValue)." + domain + "/api/"
#else
    static let webAddress   = "https://" + domain
    static let apiAddress   = "https://prod." + domain + "/api/"
#endif
    
    
    
//    enum Auth {
//        private static let baseUrl = apiAddress + "auth"
//        
//        static let signInCheck               = baseUrl + "/signInCheck"
//        static let signOut                   = baseUrl + "/signOut"
//        static let createMeetcodaInfo        = baseUrl + "/createMeetcodaInfo"
//        static let getUserForMeetcoda        = baseUrl + "/getUserForMeetcoda"
//    }
    
    enum Auth: String {
        case signInCheck
        case signOut
        case createMeetcodaInfo
        case getUserForMeetcoda
        
        var url: String { return apiAddress + "auth/" + self.rawValue }
    }
    
    enum OAuth {
        private static let baseUrl = apiAddress + "oauth"
        
        static let emailLogin                = baseUrl + "/emailLogin"
        static let firebaseLogin             = baseUrl + "/firebaseLogin"
        static let connectSocialAccount      = baseUrl + "/connectSocialAccount"
        static let connectOriginAccount      = baseUrl + "/connectOriginAccount"
        static let disconnectOriginAccount   = baseUrl + "/disconnectOriginAccount"
        static let checkSession              = baseUrl + "/checkSession"
    }
    
    enum User {
        private static let baseUrl = apiAddress + "user"
        
        static let createUser                = baseUrl + "/createUser"
        static let emailSendCode             = baseUrl + "/emailSendCode"
        static let emailVerify               = baseUrl + "/emailVerify"
        static let resetPassword             = baseUrl + "/resetPassword"
        static let updateNickname            = baseUrl + "/updateNickname"
        static let updateStatusMessage       = baseUrl + "/updateStatusMessage"
        static let updateProfileImage        = baseUrl + "/updateProfileImage"
        static let deleteUser                = baseUrl + "/deleteUser"
        static let updatePassword            = baseUrl + "/updatePassword"
        static let updatePushToken           = baseUrl + "/updatePushToken"
        static let getTerms                  = baseUrl + "/getTerms"
        static let getMyVilla                = baseUrl + "/getMyVilla"
        static let getUserTermsAgree         = baseUrl + "/getUserTermsAgree"
        static let updateUserTermsAgree      = baseUrl + "/updateUserTermsAgree"
    }
    
    enum Friends {
        private static let baseUrl = apiAddress + "friends"
        
        static let getFriend                 = baseUrl + "/getFriend"
        static let getFriendList             = baseUrl + "/getFriendList"
        static let getPendingFriends         = baseUrl + "/getPendingFriends"
        static let getHiddenFriends          = baseUrl + "/getHiddenFriends"
        static let getBlockedFriends         = baseUrl + "/getBlockedFriends"
        static let createFriends             = baseUrl + "/createFriends"
        static let acceptFriends             = baseUrl + "/acceptFriends"
        static let rejectFriends             = baseUrl + "/rejectFriends"
        static let updateFavorite            = baseUrl + "/updateFavorite"
        static let updateHidden              = baseUrl + "/updateHidden"
        static let updateBlocked             = baseUrl + "/updateBlocked"
    }
    
    enum Feed {
        private static let baseUrl = apiAddress + "feed"
        
        static let getFeedList               = baseUrl + "/getFeedList"
        static let getFeed                   = baseUrl + "/getFeed"
        static let createFeed                = baseUrl + "/createFeed"
        static let updateFeed                = baseUrl + "/updateFeed"
        static let deleteFeed                = baseUrl + "/deleteFeed"
        static let getFeedCommentList        = baseUrl + "/getFeedCommentList"
        static let createFeedComment         = baseUrl + "/createFeedComment"
        static let updateFeedComment         = baseUrl + "/updateFeedComment"
        static let deleteFeedComment         = baseUrl + "/deleteFeedComment"
        static let getFeedCommentReplyList   = baseUrl + "/getFeedCommentReplyList"
        static let createFeedCommentReply    = baseUrl + "/createFeedCommentReply"
        static let updateFeedCommentReply    = baseUrl + "/updateFeedCommentReply"
        static let deleteFeedCommentReply    = baseUrl + "/deleteFeedCommentReply"
        static let createFeedLike            = baseUrl + "/createFeedLike"
        static let createFeedCommentLike     = baseUrl + "/createFeedCommentLike"
        static let createFeedReport          = baseUrl + "/createFeedReport"
    }
    
    enum Chat {
        private static let baseUrl = apiAddress + "chat"
        
        static let createChat                = baseUrl + "/createChat"
        static let sendMessage               = baseUrl + "/sendMessage"
        static let getChatRoom               = baseUrl + "/getChatRoom"
        static let getChatRoomList           = baseUrl + "/getChatRoomList"
        static let updateChatFavorite        = baseUrl + "/updateChatFavorite"
        static let deleteChatRoom            = baseUrl + "/deleteChatRoom"
        static let createChatRoomReport      = baseUrl + "/createChatRoomReport"
        static let translate                 = baseUrl + "/translate"
        static let updateChatMute            = baseUrl + "/updateChatMute"
    }
    
//    enum Romanto {
//        private static let baseUrl = apiAddress + "/api/romanto"
//        
//        static let getProfile                = baseUrl + "/getProfile"
//        static let updateProfile             = baseUrl + "/updateProfile"
//        static let report                    = baseUrl + "/report"
//        static let block                     = baseUrl + "/block"
//    }

    enum Romanto: String {
        case updateProfile
        case report
        case block
        
        var url: String {
            return apiAddress + "romanto/" + self.rawValue
        }
    }
    
    enum V2Romanto {
        private static let baseUrl = apiAddress + "v2/romanto"
        
        static let getMyVillaList            = baseUrl + "/getMyVillaList"
        static let getDonationVillaList      = baseUrl + "/getDonationVillaList"
        static let getVillaAlias             = baseUrl + "/getVillaAlias"
        static let updateVillaAlias          = baseUrl + "/updateVillaAlias"
        static let getVillaInfo              = baseUrl + "/getVillaInfo"
        static let getVillaList              = baseUrl + "/getVillaList"
        static let joinVilla                 = baseUrl + "/joinVilla"
        static let donationVilla             = baseUrl + "/donationVilla"
        static let getProfile                = baseUrl + "/getProfile"
        static let getVillaWithUserInfo      = baseUrl + "/getVillaWithUserInfo"
        static let searchVilla               = baseUrl + "/searchVilla"
        static let getVillaTopDonation       = baseUrl + "/getVillaTopDonation"
        static let villaUserKick             = baseUrl + "/villaUserKick"
        static let getVillaDetail            = baseUrl + "/getVillaDetail"
        static let getVillaDonationList      = baseUrl + "/getVillaDonationList"
        static let getProfileByWeecodaId     = baseUrl + "/getProfileByWeecodaId"
        static let getLatestServiceInfoList  = baseUrl + "/getLatestServiceInfoList"
        static let getUpdatedServiceInfoList = baseUrl + "/getUpdatedServiceInfoList"
        static let registerReferrer          = baseUrl + "/registerReferrer"
        static let getRomantoVillaList       = baseUrl + "/getRomantoVillaList"
        static let joinVideoSlot             = baseUrl + "/joinVideoSlot"
        static let getVillaParticipantList   = baseUrl + "/getVillaParticipantList"
        static let getAppliedVillaPackageId  = baseUrl + "/getAppliedVillaPackageId"
        static let startLive                 = baseUrl + "/startLive"
        static let getMyVillaNFTList         = baseUrl + "/getMyVillaNFTList"
        static let getVillaLiveStatus        = baseUrl + "/getVillaLiveStatus"
        static let setVillaLiveStatus        = baseUrl + "/setVillaLiveStatus"
        static let getVillaLiveSetting       = baseUrl + "/getVillaLiveSetting"
        static let setVillaLiveSetting       = baseUrl + "/setVillaLiveSetting"
        static let getServiceInfoDescription = baseUrl + "/getServiceInfoDescription"
    }
    
    enum Version: String {
        case getIosVersionCheck
        
        var url: String { return apiAddress + "version/" + self.rawValue }
    }
    
    enum Notice {
        private static let baseUrl = apiAddress + "notice"
        
        static let getNoticeList             = baseUrl + "/getNoticeList"
        static let getNoticeDetail           = baseUrl + "/getNoticeDetail"
        static let getBannerList             = baseUrl + "/getBannerList"
    }
    
    enum Notification {
        private static let baseUrl = apiAddress + "notification"
        
        static let getNotification           = baseUrl + "/getNotification"
        static let getNewNotification        = baseUrl + "/getNewNotification"
        
    }
    
    enum Wallet {
        private static let baseUrl = apiAddress + "wallet"
        
        static let getBalance                = baseUrl + "/getBalance"
        static let sendCandy                 = baseUrl + "/sendCandy"
        static let getWalletHistory          = baseUrl + "/getWalletHistory"
        static let sendKey                   = baseUrl + "/sendKey"
    }
    
    enum Payment {
        private static let baseUrl = apiAddress + "payment"
        
        static let getProduct                = baseUrl + "/getProduct"
        static let purchaseConfirmIos        = baseUrl + "/purchaseConfirmIos"
    }
    
    enum Admob {
        private static let baseUrl = apiAddress + "admob"
        
        static let getRewardCount            = baseUrl + "/getRewardCount"
    }
    
    enum Myroom {
        private static let baseUrl = apiAddress + "myroom"
        
        static let addTicket    = baseUrl + "/addTicket"
        static let getEntryInfo = baseUrl + "/getEntryInfo"
    }
    
    enum Develop: String {
        case devlogin
        
        var url: String { return apiAddress + "develop/" + self.rawValue }
    }
    ///api/develop/devlogin
}
