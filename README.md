# TapTap ScreenQA Patch

非官方补丁：让 [TapTap](https://github.com/KieronQuinn/TapTap) 1.6.2 在 Android 14+ 上保持前台服务，并把双击动作指向 [ScreenQA](https://github.com/EEElysia1111/ScreenQA)。

> 本项目与 TapTap 作者、DeepSeek 均无隶属关系。仅用于个人学习和辅助复习。

## 预构建 APK

Release v1.0.0 提供：

- `TapTap-patched-v1.0.0.apk`：已签名，可直接安装
- `TapTap-ScreenQA-Patch-v1.0.0-source.zip`：对应完整源码（GPL-3.0）

下载页：https://github.com/EEElysia1111/TapTap-ScreenQA-Patch/releases/tag/v1.0.0

APK SHA-256：`44cd1f57d4af381d431b5c61d5684d011eaf11bb223924b617b37c045476f8a3`  
签名证书：`CN=TapTap ScreenQA Patch, O=EEElysia1111, C=CN`

安装前必须卸载官方 TapTap；本修改版与官方版签名不同，不能覆盖安装。

## 为什么需要补丁

官方 TapTap 1.6.2 在 Android 14+ 有两个问题：

1. `TapTapForegroundService` 调用 `startForeground` 时使用 `FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE`，但 Manifest 声明的是 `specialUse`。类型不匹配会抛异常并被 `startForegroundCompat` 吞掉，服务没有真正进入前台，离开 TapTap 后容易被 MIUI/HyperOS 冻结。
2. `LaunchAppAction.isAvailable()` 在目标应用已打开时返回 `false`，导致双击动作只生效一次，日志里出现 `No available actions`。

另外，官方动作是 `startActivity`，在 MIUI 上可能被后台 Activity 限制拦截；补丁改成向 ScreenQA 发广播。

## 补丁内容

| 文件 | 修改 |
| --- | --- |
| `patches/0001-foreground-service-type.patch` | `CONNECTED_DEVICE` → `SPECIAL_USE` |
| `patches/0002-launch-app-broadcast.patch` | 去掉 `isOpen` 限制；对 `com.dsh.screenqa` 发 `com.dsh.screenqa.CAPTURE` 广播，不启动 Activity |
| `patches/0003-default-screenqa-action.patch` | 默认双击动作设为 `LAUNCH_APP` + `com.dsh.screenqa` |

没有修改手势识别、传感器、模型或其他动作。

## 构建

环境：JDK 21、Android SDK 35、Gradle 8.9（上游自带 Wrapper）。

```bash
git clone --depth 1 --branch 1.6.2 https://github.com/KieronQuinn/TapTap.git
cd TapTap

# 方式一：Git
git apply ../TapTap-ScreenQA-Patch/patches/*.patch

# 方式二：patch
for p in ../TapTap-ScreenQA-Patch/patches/*.patch; do
  patch -p1 < "$p"
done

./gradlew :app:assembleRelease
```

产物：`app/build/outputs/apk/release/app-release-unsigned.apk`

用你自己的 keystore 签名：

```bash
apksigner sign --ks your.keystore --out TapTap-patched.apk app-release-unsigned.apk
```

也可以直接用 `scripts/apply.sh` 和 `scripts/build.sh`。

## 安装

1. **先卸载官方 TapTap**（包名相同、签名不同，不能覆盖安装）。
2. 安装按本补丁构建的 APK。
3. 打开 TapTap，授予无障碍、悬浮窗、电池无限制。
4. 设置 → 双击动作 → 启动应用 → **ScreenQA**。
5. 确认 TapTap 常驻通知存在。

## 更新与签名

- 修改版签名由构建者自己决定；不同签名的版本不能互相覆盖。
- 不要从应用商店更新 TapTap，会因签名冲突失败或覆盖修改。
- 升级补丁版必须使用同一个 keystore，否则要先卸载（会清数据）。

## GPL 合规

TapTap 使用 **GPL-3.0**。本仓库的补丁属于衍生作品，同样使用 GPL-3.0。

如果你分发打补丁后的 APK，必须提供**完整的对应源码**。推荐做法：

- 在 Release 中同时提供源码 zip；
- 或提供本补丁 + 明确的上游 tag/commit + 构建说明；
- 保留上游版权声明和 `LICENSE`；
- 不添加额外限制。

详见 [LICENSE](LICENSE) 和 [NOTICE](NOTICE)。

## 安全提示

TapTap 需要无障碍和前台服务权限。请只使用你信任的构建，并自行审查补丁。不要安装来源不明的“修改版 TapTap”。

## 相关仓库

- [ScreenQA](https://github.com/EEElysia1111/ScreenQA)：截屏识题应用。
