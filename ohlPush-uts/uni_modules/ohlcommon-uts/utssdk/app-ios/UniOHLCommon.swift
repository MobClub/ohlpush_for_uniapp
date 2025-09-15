//
//  UniOHLCOmmon.swift
//  DDDDDemo
//
//  Created by MobTech-iOS on 2025/4/9.
//

import Foundation
import MOBFoundation

public class UniOHLCommon {
    static func registerAppKey(_ appKey: String?, _ appSecret: String?) {
        if let key = appKey, let secret = appSecret {
            MobSDK.initKey(key, secret: secret)
        }
    }

    static func uploadPrivacyPermissionStatus(_ isAgree: Bool = true) {
        MobSDK.uploadPrivacyPermissionStatus(isAgree)
    }
}
