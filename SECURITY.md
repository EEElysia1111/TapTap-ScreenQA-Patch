# Security Policy

## 报告问题

请通过 GitHub 的 **Private vulnerability reporting** 或 Security Advisory 联系维护者：

<https://github.com/EEElysia1111/TapTap-ScreenQA-Patch/security/advisories/new>

不要在公开 Issue 中贴出可利用细节、密钥或个人信息。

## 范围

本仓库只包含补丁（3 个 `.patch`）和构建脚本，但分发的是完整的 TapTap APK，因此以下问题在范围内：

- **补丁引入的行为**
  - `com.dsh.screenqa.CAPTURE` 广播触发路径（本补丁把双击动作改成发广播）
  - 前台服务类型改为 `SPECIAL_USE` 带来的权限或稳定性问题
- **发布产物**
  - Release 中的 APK / 源码 zip 被篡改、替换或冒名
  - 签名证书与 README、Release 说明不一致
- **合规**
  - GPL-3.0 要求的完整对应源码缺失

## 不在范围内

- **上游 TapTap 自身的漏洞**：请报给 [KieronQuinn/TapTap](https://github.com/KieronQuinn/TapTap)
- **ScreenQA 应用本身的漏洞**：请报给 [EEElysia1111/ScreenQA](https://github.com/EEElysia1111/ScreenQA)
- 需要 root、解锁 Bootloader 或物理接触设备的攻击
- 用户自行用其他 keystore 构建/签名的版本
- TapTap、DeepSeek 服务端的可用性、计费或账号问题

> 注：`com.dsh.screenqa.CAPTURE` 是一个导出的广播，任何应用都可以直接发送。这是 ScreenQA 侧已知的设计取舍，安全说明见其 [SECURITY.md](https://github.com/EEElysia1111/ScreenQA/blob/main/SECURITY.md)。

## 发布校验

每个 Release 都提供 APK 的 SHA-256 和签名证书指纹。请只从本仓库 Releases 下载并核对。

```text
apksigner verify --print-certs TapTap-patched-v1.0.0.apk
```

## 签名

- 官方构建使用维护者持有的 release keystore。
- 仓库不包含任何 keystore、密码或 API Key。
- 如果签名发生变化，请视为不同应用，先卸载旧版再安装。

## 处理流程

- 收到报告后 7 天内确认收到。
- 给 90 天修复窗口（可协商），修复后发布新版本。
- 修复发布后，如你愿意，会在 Release 说明里致谢。

## 免责声明

本项目为非官方补丁，按“现状”提供，不提供任何担保。使用本软件造成的账号、数据或设备问题由使用者自行承担。
