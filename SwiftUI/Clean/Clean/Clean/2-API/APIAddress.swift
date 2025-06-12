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
    
    
    
    enum Auth: String {
        case signInCheck
        case signOut
        case createMeetcodaInfo
        case getUserForMeetcoda
        
        var urlString: String { return apiAddress + "auth/" + self.rawValue }
    }
    
    enum OAuth: String {
        case emailLogin
        case firebaseLogin
        case connectSocialAccount
        case connectOriginAccount
        case disconnectOriginAccount
        case checkSession
        
        var urlString: String { return apiAddress + "oauth/" + self.rawValue }
    }
    
    enum User: String {
        case createUser
        case emailSendCode
        case emailVerify
        case resetPassword
        case updateNickname
        case updateStatusMessage
        case updateProfileImage
        case deleteUser
        case updatePassword
        case updatePushToken
        case getTerms
        case getMyVilla
        case getUserTermsAgree
        case updateUserTermsAgree
        
        var urlString: String { return apiAddress + "user/" + self.rawValue }
    }
    
    enum Friends: String {
        case getFriend
        case getFriendList
        case getPendingFriends
        case getHiddenFriends
        case getBlockedFriends
        case createFriends
        case acceptFriends
        case rejectFriends
        case updateFavorite
        case updateHidden
        case updateBlocked
        
        var urlString: String { return apiAddress + "friends/" + self.rawValue }
    }
    
    
    enum Feed: String {
        case getFeedList
        case getFeed
        case createFeed
        case updateFeed
        case deleteFeed
        case getFeedCommentList
        case createFeedComment
        case updateFeedComment
        case deleteFeedComment
        case getFeedCommentReplyList
        case createFeedCommentReply
        case updateFeedCommentReply
        case deleteFeedCommentReply
        case createFeedLike
        case createFeedCommentLike
        case createFeedReport
        
        var urlString: String { return apiAddress + "feed/" + self.rawValue }
    }
    
    enum Chat: String {
        case createChat
        case sendMessage
        case getChatRoom
        case getChatRoomList
        case updateChatFavorite
        case deleteChatRoom
        case createChatRoomReport
        case translate
        case updateChatMute
        
        var urlString: String { return apiAddress + "chat/" + self.rawValue }
    }
    
    enum Romanto: String {
        case updateProfile
        case report
        case block
        
        var urlString: String { return apiAddress + "romanto/" + self.rawValue }
    }
    
    enum V2Romanto: String {
        case getMyVillaList
        case getDonationVillaList
        case getVillaAlias
        case updateVillaAlias
        case getVillaInfo
        case getVillaList
        case joinVilla
        case donationVilla
        case getProfile
        case getVillaWithUserInfo
        case searchVilla
        case getVillaTopDonation
        case villaUserKick
        case getVillaDetail
        case getVillaDonationList
        case getProfileByWeecodaId
        case getLatestServiceInfoList
        case getUpdatedServiceInfoList
        case registerReferrer
        case getRomantoVillaList
        case joinVideoSlot
        case getVillaParticipantList
        case getAppliedVillaPackageId
        case startLive
        case getMyVillaNFTList
        case getVillaLiveStatus
        case setVillaLiveStatus
        case getVillaLiveSetting
        case setVillaLiveSetting
        case getServiceInfoDescription
        
        var urlString: String { return apiAddress + "v2/romanto/" + self.rawValue }
    }
    
    enum Version: String {
        case getIosVersionCheck
        
        var urlString: String { return apiAddress + "version/" + self.rawValue }
    }
    
    enum Notice: String {
        case getNoticeList
        case getNoticeDetail
        case getBannerList
        
        var urlString: String { return apiAddress + "notice/" + self.rawValue }
    }
    
    enum Notification: String {
        case getNotification
        case getNewNotification
        
        var urlString: String { return apiAddress + "notification/" + self.rawValue }
    }
    
    enum Wallet: String {
        case getBalance
        case sendCandy
        case getWalletHistory
        case sendKey
        
        var urlString: String { return apiAddress + "wallet/" + self.rawValue }
    }
    
    enum Payment: String {
        case getProduct
        case purchaseConfirmIos
        
        var urlString: String { return apiAddress + "payment/" + self.rawValue }
    }
    
    enum Admob: String {
        case getRewardCount
        
        var urlString: String { return apiAddress + "admob/" + self.rawValue }
    }
    
    enum Myroom: String {
        case addTicket
        case getEntryInfo
        
        var urlString: String { return apiAddress + "myroom/" + self.rawValue }
    }
    
    enum Develop: String {
        case devlogin
        
        var urlString: String { return apiAddress + "develop/" + self.rawValue }
    }
}
