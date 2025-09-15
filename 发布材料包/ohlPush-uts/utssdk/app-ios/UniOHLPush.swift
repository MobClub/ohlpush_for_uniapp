//
//  UniOHLPush.swift
//  DDDDDemo
//
//  Created by MobTech-iOS on 2025/4/9.
//

import Foundation
import MOBFoundation
import OHLPush

public protocol UniOHLPushEventReceiver {
    func onCustomMessageReceive(_ msg: String)
    func onNotifyMessageReceive(_ msg: String)
    func onNotifyMessageOpenedReceive(_ msg: String)
    func onTagsEventCallBack(_ tags: String, _ operation: Int, _ errorCode: Int)
    func onAliasEventCallBack(_ alias: String, _ operation: Int, _ errorCode: Int)
}

public class UniOHLPush {
    static let SharedInstance = UniOHLPush()

    private var receiver: UniOHLPushEventReceiver?

    static func setAPNsForProduction(_ isPro: Bool) {
        OHLPush.setAPNsForProduction(isPro)
    }

    static func setupNotificationWithType(_ type: Int = 7) {
        let config = OHLPushNotificationConfiguration()
        config.types = OHLPushAuthorizationOptions(rawValue: UInt(type))
        OHLPush.setupNotification(config)
    }

    static func getRegistrationID(_ callbck: @escaping (String, Int) -> Void) {
        OHLPush.getRegistrationID { rid, err in
            callbck(rid ?? "", (err as? NSError)?.code ?? 0)
        }
    }

    /// Push
    static func stopPush() {
        OHLPush.stop()
    }

    static func restartPush() {
        OHLPush.restart()
    }

    static func isPushStoped() -> Bool {
        return OHLPush.isPushStopped()
    }

    /// Badge
    static func setBadge(_ num: Int = 0) {
        OHLPush.setBadge(num)
    }

    static func getServiceBadge(_ callback: @escaping (Int, Int) -> Void) {
        OHLPush.getBadgeWithhandler { count, err in
            callback(count, (err as? NSError)?.code ?? 0)
        }
    }

    /// Tags
    static func addTagsToService(_ tags: [String] = []) {
        let intance = UniOHLPush.SharedInstance
        OHLPush.addTags(tags) { err in
            intance.receiver?.onTagsEventCallBack(
                tags.joined(separator: ";"), 1, (err as? NSError)?.code ?? 0)
        }
    }

    static func getTagsFromService() {
        let intance = UniOHLPush.SharedInstance
        OHLPush.getTagsWithResult { tags, err in
            var str = ""
            if let arr = tags as? [String] {
                str = arr.joined(separator: ";")
            }
            intance.receiver?.onTagsEventCallBack(str, 0, (err as? NSError)?.code ?? 0)
        }
    }

    static func deleteTagsFromService(_ tags: [String] = []) {
        let intance = UniOHLPush.SharedInstance
        OHLPush.deleteTags(tags) { err in
            intance.receiver?.onTagsEventCallBack(
                tags.joined(separator: ";"), 2, (err as? NSError)?.code ?? 0)
        }
    }

    static func cleanAllTags() {
        let intance = UniOHLPush.SharedInstance
        OHLPush.cleanAllTags { err in
            intance.receiver?.onTagsEventCallBack("", 3, (err as? NSError)?.code ?? 0)
        }
    }

    /// Alias
    static func addAliasToService(_ alias: String? = "") {
        let intance = UniOHLPush.SharedInstance
        OHLPush.setAlias(alias) { err in
            intance.receiver?.onAliasEventCallBack(alias ?? "", 1, (err as? NSError)?.code ?? 0)
        }
    }

    static func getAliasFromService() {
        let intance = UniOHLPush.SharedInstance
        OHLPush.getAliasWithResult { alias, err in
            intance.receiver?.onAliasEventCallBack(alias ?? "", 0, (err as? NSError)?.code ?? 0)
        }
    }

    static func deleteAliasFromService() {
        let intance = UniOHLPush.SharedInstance
        OHLPush.deleteAlias { err in
            intance.receiver?.onAliasEventCallBack("", 2, (err as? NSError)?.code ?? 0)
        }
    }

    static func addObserverToMsg(_ observer: UniOHLPushEventReceiver?) {
        let center = NotificationCenter.default
        let instance = UniOHLPush.SharedInstance
        let name = NSNotification.Name(rawValue: "OHLPushDidReceiveMessageNotification")

        instance.receiver = observer
        center.addObserver(
            instance, selector: #selector(_UniOHLPushMessage(_:)), name: name, object: nil)
    }

    static func setUserLanguage(_ lang: String?) {
        if let lan = lang {
            OHLPush.setUserLanguage(lan)
        }
    }

    static func setDataNode(_ dataNode: UInt = 0) {
        let node = OHLPushDataNode(rawValue: dataNode)
        OHLPush.setDataNode(node)
    }

    static func registerWithDevickToken(_ token: String?) {
        if let dk = token {
            let data = MOBFString.data(byHexString: dk)
            OHLPush.registerDeviceToken(data)
        }
    }

    @objc private func _UniOHLPushMessage(_ noti: NSNotification?) {
        if let message = noti?.object as? OHLPushMessage {
            let instance = UniOHLPush.SharedInstance
            let msgInfo = MOBFJson.jsonString(from: message.convertDictionary()) ?? ""
            switch message.messageType {
            case .custom:
                instance.receiver?.onCustomMessageReceive(msgInfo)
            case .apns:
                instance.receiver?.onNotifyMessageReceive(msgInfo)
            case .clicked:
                instance.receiver?.onNotifyMessageOpenedReceive(msgInfo)
            default:
                print("Don't support msg type: \(message.messageType).")
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(UniOHLPush.SharedInstance)
    }
}
