<!-- 本示例未包含完整css，获取外链css请参考上文，在hello uni-app项目中查看 -->
<template>
	<view>
		<view class="uni-padding-wrap uni-common-mt">
			<view>
				<scroll-view :scroll-top="scrollTop" scroll-y="true" class="scroll-Y" @scrolltoupper="upper"
					@scrolltolower="lower" @scroll="scroll">
					<button v-on:click="unisubmitPolicyGrantResult">submitPolicyGrantResult</button>
					<button v-on:click="configiOSApp">registerAndConfig(iOS)</button>
					<button v-on:click="unigetRegistrationID">getRegistrationID</button>
					<button v-on:click="uniaddPushReceiver">addPushReceiver</button>
					<button v-on:click="unistopPush">stopPush</button>
					<button v-on:click="unirestartPush">restartPush</button>
					<button v-on:click="uniisPushStopped">isPushStopped</button>
					<input placeholder="请输入别名:" v-model.trim="alias" />
					<button v-on:click="unisetAlias(alias)">setAlias</button>
					<button v-on:click="unideleteAlias">deleteAlias</button>
					<button v-on:click="unigetAlias">getAlias</button>
					<input placeholder='请输入标签,多个以";"分割:' v-model.trim="tagsStr" />
					<button v-on:click="uniaddTags(tagsStr)">addTags</button>
					<button v-on:click="unideleteTags(tagsStr)">deleteTags</button>
					<button v-on:click="unigetTags">getTags</button>
					<button v-on:click="unicleanAllTags">cleanAllTags</button>
					<button v-on:click="unisetShowBadge">setShowBadge(Android)</button>
					<button v-on:click="unigetShowBadge">getShowBadge</button>
					<button v-on:click="uniSetUserLan">setUserLan</button>
					<button v-on:click="unisetSilenceTime">setSilenceTime(Android)</button>
				</scroll-view>
			</view>
		</view>
	</view>
</template>


<script>
	import {
		mobSDKInit,
		mobSDKsubmitPolicyGrantResult
	} from "@/uni_modules/ohlcommon-uts";
	import {
		getRegistrationID,
		setAPNsForProduction,
		setUpNotificationConfig,
		addPushReceiver,
		stopPush,
		restartPush,
		isPushStopped,
		setAlias,
		getAlias,
		deleteAlias,
		addTags,
		getTags,
		cleanTags,
		deleteTags,
		setSilenceTime,
		setShowBadge,
		getShowBadge,
		setupDataNode,
		setupUserLanguage
	} from "@/uni_modules/ohlPush-uts"
	
	export default {
		created: function() {

		},
		data() {
			return {
				alias: "", //推送别名
				tagsStr: "",
				startHour: 0,
				startMinute: 0,
				endHour: 0,
				endMinute: 0

			}
		},

		methods: {
			unisubmitPolicyGrantResult() {
				// iOS配置
				setupDataNode(0)
				mobSDKsubmitPolicyGrantResult(true)
			},
			configiOSApp() {
				// iOS 需手动调用注册方法注册 或 配置Info.plist文件
				// registerApp('3276d3e413040', '4280a3a6df667cfce37528dec03fd9c3')
				mobSDKInit('11d90554ab605e', '0f9c4a78d4f1aad67180b3b421dc4622')
				// 设置APNs环境
				setAPNsForProduction(true)
				// 设置APNs权限 Badge 1 Sound 2 Alert 4 All 7
				setUpNotificationConfig(7)
			},
			//获取推送rid
			unigetRegistrationID() {
				getRegistrationID({
					onCallback(res) {
						uni.showToast({
							title: "rid:" + JSON.stringify(res),
							icon: 'none',
							duration: 5000
						})
					}
				})
			},
			//推送回调
			uniaddPushReceiver() {
				addPushReceiver({
					onCustomMessageReceive(message) {
						console.log("js onCustomMessageReceive" + message)
						uni.showToast({
							title: "onCustomMessageReceive:" + message,
							icon: 'none',
							duration: 2000
						})
					},
					onNotifyMessageReceive(message) {
						console.log("js onNotifyMessageReceive" + message)
						uni.showToast({
							title: "onNotifyMessageReceive:" + message,
							icon: 'none',
							duration: 2000
						})
					},
					onNotifyMessageOpenedReceive(message) {
						console.log("js onNotifyMessageOpenedReceive" + message)
						uni.showToast({
							title: "onNotifyMessageOpenedReceive:" + message,
							icon: 'none',
							duration: 2000
						})
					},
					onTagsCallback(tags, operation, errorCode) {
						uni.showToast({
							title: "onTagsCallback tags:" + tags + ",operation:" + operation +
								",errorCode:" + errorCode,
							icon: 'none',
							duration: 2000
						})
					},
					onAliasCallback(alias, operation, errorCode) {
						uni.showToast({
							title: "onAliasCallback alias:" + alias + ",operation:" + operation +
								",errorCode:" + errorCode,
							icon: 'none',
							duration: 2000
						})
					},
				})
			},
			//关闭推送功能
			unistopPush() {
				stopPush()
			},
			//重启推送功能
			unirestartPush() {
				restartPush()
			},
			//获取推送是否关闭
			uniisPushStopped() {
				isPushStopped({
					onCallback(res) {
						uni.showToast({
							title: "isPushStopped:" + JSON.stringify(res),
							icon: 'none',
							duration: 2000
						})
					}
				})
			},
			//设置别名
			unisetAlias(alias) {
				if (alias == '') {
					uni.showToast({
						title: "请输入别名！",
						icon: 'none',
						duration: 2000
					})
					return
				}
				setAlias(alias)
			},

			//获取别名
			unigetAlias() {
				getAlias()
			},
			//删除别名
			unideleteAlias() {
				deleteAlias()
			},
			//添加标签
			uniaddTags(tagsStr) {
				if (tagsStr == '') {
					uni.showToast({
						title: "请输入标签，以;隔开！",
						icon: 'none',
						duration: 2000
					})
					return
				}
				var tags = tagsStr.split(';')
				if (tags.length <= 0) {
					uni.showToast({
						title: "请输入标签，以;隔开！",
						icon: 'none',
						duration: 2000
					})
					return
				}
				addTags(tags)
			},
			//获取标签
			unigetTags() {
				getTags()
			},
			//删除标签
			unideleteTags(tagsStr) {
				if (tagsStr == '') {
					uni.showToast({
						title: "请输入标签，以;隔开！",
						icon: 'none',
						duration: 2000
					})
					return
				}
				var tags = tagsStr.split(';')
				if (tags.length <= 0) {
					uni.showToast({
						title: "请输入标签，以;隔开！",
						icon: 'none',
						duration: 2000
					})
					return
				}
				deleteTags(tags)
			},
			//清楚标签
			unicleanAllTags() {
				cleanTags()
			},
			unisetSilenceTime() {
				setSilenceTime(0, 0, 23, 59)
			},
			//设置角标状态
			unisetShowBadge() {
				setShowBadge(true)
			},
			//获取角标状态
			unigetShowBadge() {
				getShowBadge({
					onCallback(res) {
						uni.showToast({
							title: "getShowBadge:" + JSON.stringify(res),
							icon: 'none',
							duration: 2000
						})
					}
				})
			},
			uniSetUserLan() {
				setupUserLanguage("en")
			},
		}
	}
</script>


<style>
	.scroll-Y {}

	.scroll-view-item {
		height: 300rpx;
		line-height: 300rpx;
		text-align: center;
		font-size: 36rpx;
	}
</style>