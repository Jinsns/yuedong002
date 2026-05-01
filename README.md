# 乐动 (YueDong)

> **脖乐常有 · 健康常在**
> 
> 游戏化肩颈操，帮你养成好习惯！

一款创新的 iOS 音乐颈椎运动游戏，通过 AirPods 运动传感器检测头部动作，让用户在音乐节奏中锻炼颈椎。

---

## 背景故事

### 有时候坐得时间久了，就会...

现代生活方式让很多人面临颈椎问题：
- 长时间伏案工作
- 频繁使用手机电脑
- 缺乏有效的颈椎锻炼

### 养成动一动的习惯好难啊...

- 工作忙碌，忘记放松
- 传统锻炼枯燥乏味
- 缺乏持续的动力和反馈

### 乐动帮你解决

**游戏化肩颈操，帮你养成好习惯！**
- 让锻炼变得有趣
- 每天坚持看得见的成果
- 轻松养成健康生活方式

---

## 核心特色

### 科学性 — 麦肯基颈椎疗法

基于 **McKenzie Therapy（麦肯基颈椎疗法）** 科学编排：
- 游戏时长和玩法依据麦肯基肩颈疗法设计
- 工作日白天定时提醒（可自定义间隔）
- 肩颈操时长随用户坚持情况逐步增加
- 动作引导越标准，获得奖励越多

### 游戏化 × IP — 短颈鹿的进化史

**游戏背景故事，带你走进乐动世界**

| 游戏化机制 | 说明 |
|-----------|------|
| **玩法** | 点头吃叶子，简单有趣 |
| **反馈** | 实时动作检测，即时响应 |
| **奖励** | 叶子收集，脖子变长 |
| **进度** | 颈长记录，见证成长 |
| **挑战** | 解锁新世界，更高风景 |

**长颈鹿 IP 形象**：贴合肩颈操世界观，短颈鹿逆袭长颈鹿的故事让坚持充满成就感。

![游戏界面](docs/images/image1.png)

### 轻量级 — 3分钟放松首选

- **随时随地**：打开即刻就放松
- **点头就能玩**：零门槛，无需学习
- **零负担**：随时开始，随时结束
- **摒弃繁琐**：专注肩颈操核心体验

---

## 功能详解

### 核心玩法

| 功能 | 说明 |
|------|------|
| **AirPods 空间音频** | 多感官交互体验，沉浸式锻炼 |
| **拉伸脖子控制长颈鹿** | 动作越到位，叶子吃更多 |
| **定时提醒** | 手机消息贴心提醒，养成好习惯 |
| **自定义设置** | 可调整提醒时间和间隔 |

![AirPods 检测](docs/images/image9.png)

### 游戏世界

**短颈鹿逆袭长颈鹿 — 坚持超有成就感**

- 动作越到位，吃到的叶子越多，脖子长得越快
- 脖子变长，看到**更高**的风景
- 过去的风景也可以**回看**

#### 两个世界

| 世界 | 解锁条件 | 背景音乐 |
|------|---------|---------|
| **地面** | 默认场景 | 《虫儿飞》 |
| **魔幻森林** | 颈长达到 120cm | 《夜静悄悄》 |

![世界切换](docs/images/image10.png)

### 运动方向

游戏引导四个方向的颈部运动：
- **左右转动**：锻炼颈椎旋转灵活性
- **前后点头**：锻炼颈椎屈伸能力

![运动方向引导](docs/images/image7.png)

### 商店与分享

- **叶子收集**：收集到的叶子让脖子变长
- **购买饰品**：在商店购买太阳镜、钻石戒指、椰子树等装饰
- **截图分享**：晃动手机拍下美景，分享给朋友
- **大家一起收获健康"脖"乐**

![商店系统](docs/images/image12.png)

---

## 技术架构

### 整体架构设计

本项目采用 **SwiftUI + SceneKit** 混合架构，实现了 2D UI 与 3D 场景的无缝融合：

```
┌─────────────────────────────────────────────────────────────┐
│                      SwiftUI View Layer                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ HomePageView│  │  ShopView   │  │   SwiftUIView       │  │
│  │  (主界面)    │  │  (商店)     │  │   (游戏主逻辑)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                          ↓ ↓ ↓                               │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              DataModel (ObservableObject)                ││
│  │         全局状态管理：UI状态、游戏进度、提醒设置          ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
                          ↓ ↓ ↓
┌─────────────────────────────────────────────────────────────┐
│                    SceneKit 3D Engine Layer                  │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                    GiraffeScene                          ││
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐  ││
│  │  │ NeckNode │  │ LeafNode │  │CameraNode│  │LightNode│  ││
│  │  │ (长颈鹿)  │  │  (叶子)   │  │ (相机)   │  │ (灯光)  │  ││
│  │  └──────────┘  └──────────┘  └──────────┘  └─────────┘  ││
│  │                                                          ││
│  │  ┌─────────────────────────────────────────────────────┐││
│  │  │           SCNPhysicsWorld (物理碰撞检测)             │││
│  │  └─────────────────────────────────────────────────────┘││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
                          ↓ ↓ ↓
┌─────────────────────────────────────────────────────────────┐
│                    CoreMotion Layer                          │
│  ┌──────────────────────┐  ┌─────────────────────────────┐  │
│  │ CMHeadphoneMotionMgr │  │    CMMotionManager          │  │
│  │   (AirPods 检测)      │  │   (iPhone 运动，截图模式)    │  │
│  └──────────────────────┘  └─────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                          ↓ ↓ ↓
┌─────────────────────────────────────────────────────────────┐
│                    AVFoundation Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────┐  │
│  │  BgmSystem   │  │SoundEffectSys│  │  AVAudioPlayerPool│  │
│  │  (背景音乐)   │  │  (音效管理)   │  │    (音频池复用)    │  │
│  └──────────────┘  └──────────────┘  └───────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 核心技术实现

#### 1. AirPods 头部运动检测

项目使用 `CMHeadphoneMotionManager` 获取 AirPods 的实时运动数据，这是 Apple 在 iOS 14+ 提供的 API，支持 AirPods Pro 及更新型号：

```swift
class GiraffeScene: SCNScene {
    let motionManager = CMHeadphoneMotionManager()  // AirPods 专用
    
    func addNeckRotation() {
        motionManager.startDeviceMotionUpdates(to: .main) { deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else { return }
            
            // 获取头部姿态：pitch(前后)、roll(左右倾斜)、yaw(左右转动)
            let headphoneAnglex = attitude.roll   // 左右倾斜
            let headphoneAnglez = attitude.pitch  // 前后点头
            
            // 映射到长颈鹿脖子旋转，限制最大角度防止过度运动
            let maxAngle = Float.pi / 6
            self.neckNode?.eulerAngles = SCNVector3(
                x: clamp(attitude.roll, maxAngle) / 2.0,
                y: 0,
                z: clamp(attitude.pitch, maxAngle) / 2.0
            )
        }
    }
}
```

**设计要点**：
- 角度限制 (`maxAngle = π/6`)：防止用户过度运动造成颈椎损伤
- 校准机制 (`checkingPosition`)：游戏开始前要求用户将头部调整至中心位置
- AirPods 可用性检测 (`checkingAirpods`)：通过 `AVAudioSession` 检测耳机连接状态

#### 2. 3D 场景与物理碰撞

使用 SceneKit 构建完整的 3D 游戏场景，包含：

| 节点类型 | 功能 | 技术细节 |
|---------|------|---------|
| `neckNode` | 长颈鹿模型 | 从 `.dae` 文件加载，kinematic 物理体 |
| `leafNode` | 目标叶子 | 动态生成，kinematic 物理体，带空间音效 |
| `cameraNode` | 视角相机 | 根据颈长位置动态调整 |
| `backgroundNode` | 背景场景 | 大尺寸 SCNPlane，支持多世界切换 |
| `ornamentNode` | 装饰品 | 商店购买的装饰物挂载到长颈鹿 |

**物理碰撞检测**：
```swift
// 配置碰撞位掩码
neckNode.physicsBody?.categoryBitMask = 1      // 颈鹿类别
neckNode.physicsBody?.contactTestBitMask = 2   // 检测叶子

leafNode.physicsBody?.categoryBitMask = 2      // 叶子类别
leafNode.physicsBody?.contactTestBitMask = 1   // 检测颈鹿

// 碰撞回调
func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    if (contact.nodeA.name == "neck" && contact.nodeB.name == "leaf") {
        DispatchQueue.main.async { self.isContacting = true }
    }
}
```

#### 3. 音乐节奏同步系统

游戏玩法与背景音乐精确同步，采用时间轴驱动：

```swift
// 音符时间轴设计
let notes: [Note] = [
    Note(startTime: 0.0, endTime: 0.1, leafPosition: SCNVector3(3.0, -1.0, 0), level: 1),
    Note(startTime: 4.0, endTime: 8.0, leafPosition: SCNVector3(0, 1.4, 3.8), isTenuto: true),
    // ... 与音乐节拍对应的叶子出现时间
]

// BGM 时间追踪
Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
    self.currentTime = self.audioPlayer!.currentTime
    
    // 根据当前时间生成叶子
    if currentTime > note.startTime && !isLeafAdded {
        scene.addLeafNode(note.leafPosition)
        isLeafAdded = true
    }
    
    // 叶子消失判定
    if currentTime > note.endTime {
        leafNode.removeFromParentNode()
        noteIterator += 1
    }
}
```

#### 4. 空间音频系统

叶子出现和被吃掉时播放 3D 空间音效，增强沉浸感：

```swift
let leavesAppearAudioSource = SCNAudioSource(fileNamed: "monoLeavesAppearing.mp3")
leavesAppearAudioSource.isPositional = true   // 启用 3D 定位
leavesAppearAudioSource.shouldStream = false  // 短音效预加载
leavesAppearAudioSource.volume = 8.0

leafNode.addAudioPlayer(SCNAudioPlayer(source: leavesAppearAudioSource))
```

#### 5. 音频池优化

使用 `AVAudioPlayerPool` 复用音频播放器，避免频繁创建销毁：

```swift
class AVAudioPlayerPool {
    private var players: [AVAudioPlayer] = []
    
    func playerWithURL(url: URL) -> AVAudioPlayer? {
        // 查找空闲的播放器复用
        let available = players.filter { !$0.isPlaying && $0.url == url }
        if let player = available.first { return player }
        
        // 无可用则新建并加入池
        let newPlayer = try AVAudioPlayer(contentsOf: url)
        players.append(newPlayer)
        return newPlayer
    }
}
```

#### 6. 状态管理架构

采用 `ObservableObject` + `@Published` 的响应式状态管理：

```swift
class DataModel: ObservableObject {
    @Published var isShowAirpodsReminder = true       // AirPods佩戴提示
    @Published var isShowCorrectingPositionView = false // 校准位置视图
    @Published var isShowNodToEatView = false         // 点头开始提示
    @Published var score: Int = 0                     // 游戏分数
    @Published var isContacting = false               // 碰撞状态
    // ... 更多 UI 状态
}
```

SwiftUI 视图通过 `@EnvironmentObject` 自动订阅状态变化，实现 UI 与游戏逻辑的解耦。

#### 7. 数据持久化

使用 `@AppStorage` 实现轻量级数据持久化：

```swift
@AppStorage("neckLength") var neckLength: Int = 100      // 颈长记录
@AppStorage("totalLeaves") var totalLeaves: Int = 5000   // 累计叶子
@AppStorage("shopItems") var shopItemIDs = [1, 2, 3, 4]  // 商店物品
@AppStorage("myItems") var myItemIDs = [0]               // 已购物品

// 自定义数组存储（需实现 RawRepresentable）
extension Array: RawRepresentable where Element: Codable {
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}
```

#### 8. 世界切换动画

使用 `SCNTransaction` 实现平滑的场景切换动画：

```swift
func world1ViewMid2Up() {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = 1.2
    self.cameraNode?.position = SCNVector3(x: 10, y: 9.0, z: 0)
    SCNTransaction.commit()
}

func upWorld() {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = 0.6
    self.neckNode?.position = SCNVector3(0.0, 1.5, 0.0)
    
    SCNTransaction.completionBlock = {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.backgroundNode?.position = SCNVector3(-35, 47, 0)
        self.neckNode?.position = SCNVector3(0.0, -2.8, 0.0)
        SCNTransaction.commit()
    }
    SCNTransaction.commit()
}
```

#### 9. 定时提醒系统

使用 `UserNotifications` 实现颈椎锻炼提醒：

```swift
func makeNotification() {
    // 每日固定时间提醒
    var dateComponents = DateComponents()
    dateComponents.hour = 10  // 10:00 提醒
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents, repeats: true
    )
    
    let content = UNMutableNotificationContent()
    content.title = "乐动时间"
    content.body = "老大，是时候动动脖子了!"
    content.sound = UNNotificationSound.default
    
    UNUserNotificationCenter.current().add(
        UNNotificationRequest(identifier: "yuedong", content: content, trigger: trigger)
    )
}
```

### 技术亮点总结

| 技术领域 | 实现方案 | 设计考量 |
|---------|---------|---------|
| 运动检测 | CMHeadphoneMotionManager | 角度限制防损伤，校准机制保准确性 |
| 3D渲染 | SceneKit + SCNPhysicsWorld | kinematic物理体，位掩码碰撞检测 |
| 音频同步 | Timer + AVAudioPlayer.currentTime | 0.01s精度，音符时间轴驱动 |
| 空间音频 | SCNAudioSource.isPositional | 叶子位置绑定音效，增强沉浸感 |
| 状态管理 | Combine + ObservableObject | UI与逻辑解耦，响应式更新 |
| 数据存储 | @AppStorage + Codable | 轻量持久化，无需数据库 |
| 动画系统 | SCNTransaction | 串行动画，completionBlock链式调用 |

---

## 项目结构

```
yuedong002/
├── yuedong002App.swift           # 应用入口，初始化场景
├── ContentView.swift             # 基础视图模板
│
├── MainContentView/              # 主视图模块
│   ├── SwiftUIView.swift         # ⭐ 游戏主控制器
│   │   ├── 音乐时间轴驱动逻辑
│   │   ├── 叶子生成与消失管理
│   │   ├── 碰撞检测响应
│   │   └── 世界切换触发
│   │
│   ├── HomePageView.swift        # 主界面
│   │   ├── NeckIcon/EarthIcon 状态显示
│   │   ├── 设置/相机/商店入口
│   │   ├── AirPods佩戴提示
│   │   └── 位置校准引导
│   │
│   ├── ShopView.swift            # 商店系统
│   │   ├── ShopItems/MyItems 切换
│   │   ├── 叶子货币管理
│   │   └── 装饰品佩戴逻辑
│   │
│   ├── SettingsView.swift        # 设置面板
│   │   ├── 提醒设置
│   │   └── 关卡重置
│   │
│   ├── CountScoreView.swift      # 结算页面
│   ├── PauseAlertView.swift      # 暂停弹窗
│   └── ...
│
├── Utils/                        # 核心工具类
│   ├── GiraffeScene.swift        # ⭐ 3D场景核心
│   │   ├── 长颈鹿模型加载与控制
│   │   ├── 叶子节点生成与碰撞
│   │   ├── AirPods运动数据映射
│   │   ├── 世界切换动画
│   │   └── 空间音效绑定
│   │
│   ├── SoundSystem.swift         # 音频系统
│   │   ├── BgmSystem: 背景音乐播放与时间追踪
│   │   ├── SoundEffectSystem: 音效预加载
│   │   ├── AVAudioPlayerPool: 播放器复用池
│   │   └── MidiPlaySystem: MIDI录制（创建模式）
│   │
│   ├── MotionManager.swift       # 运动数据管理器
│   │   └── CMHeadphoneMotionManager封装
│   │
│   ├── DataModel.swift           # 全局状态模型
│   │   └── 所有UI状态、游戏进度、提醒设置
│   │
│   ├── EulerAngle.swift          # 欧拉角计算
│   └── CalculateObjectState.swift # 物体状态计算
│
├── Data/                         # 资源文件
│   ├── fonts/                    # DFPYuan 字体家族
│   ├── Images/                   # 2D UI 图片
│   ├── SoundFiles/               # 背景音乐 (虫儿飞、夜静悄悄)
│   ├── SoundEffects/             # 音效文件
│   ├── scene/                    # 3D模型 (.dae格式)
│   │   ├── 长颈鹿模型
│   │   ├── 装饰品模型
│   │   └── 叶子模型
│   ├── Video/                    # 开场视频
│   └── MusicInfo/                # 音乐信息
│
├── Assets.xcassets/              # Xcode 资源目录
│   ├── AppIcon.appiconset/       # 应用图标
│   └── ...                       # 其他图片资源
│
└── docs/                         # 文档与截图
    └── images/                   # PPT 素材图片
```

---

## 安装运行

### 系统要求

- iOS 15.0+
- AirPods（支持头部追踪功能）
- iPhone 设备

### 开发环境

- Xcode 14+
- Swift 5+

### 运行步骤

1. 克隆项目到本地
2. 打开 `yuedong002.xcodeproj`
3. 选择目标设备或模拟器
4. 点击运行按钮

---

## 健康提示

> 每天 3 分钟，轻松放松颈椎

- 建议每次锻炼时长约 1 分钟
- 每日可设置多次提醒，循序渐进
- 运动时保持放松，避免过度用力
- 如有颈椎问题，请咨询医生后再使用

---

## 作者

Created by Jzh (2023)

---

*让颈椎运动变得有趣，用音乐陪伴每一天的健康生活。*