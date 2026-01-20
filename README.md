# SpeedType

<div align="center">

![SpeedType Logo](https://img.shields.io/badge/SpeedType-macOS-blue?style=for-the-badge&logo=apple)

**一款现代化的 macOS 打字速度测试应用**

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange?style=flat-square&logo=swift)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-blue?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![macOS](https://img.shields.io/badge/macOS-15.5+-green?style=flat-square&logo=apple)](https://developer.apple.com/macos/)
[![Xcode](https://img.shields.io/badge/Xcode-16.4+-red?style=flat-square&logo=xcode)](https://developer.apple.com/xcode/)

</div>

## 🚀 项目简介

SpeedType 是一款专为 macOS 设计的打字速度测试与练习应用。它提供简洁优雅的用户界面，精确的计时系统，以及丰富的统计分析功能，帮助用户提升打字技能。

### ✨ 主要特性

- 🎯 **多种打字挑战**：内置字母表、QWERTY 键盘布局等多种预设挑战
- ⚡ **高精度计时**：基于 `CACurrentMediaTime()` 的毫秒级精确计时
- 📊 **实时统计**：WPM（每分钟字数）、准确率、字符数等关键指标
- 🎨 **原生 macOS 设计**：遵循 Apple Human Interface Guidelines
- 🔄 **实时反馈**：输入时的即时视觉反馈和错误提示
- 📤 **结果分享**：生成精美的结果卡片图片，支持分享
- ⌨️ **键盘快捷键**：支持 Return 开始测试，Escape 结束测试

## 🎵 Vibe Coding

本项目在开发过程中主要使用了 VSCode 的 Copilot 和 Claude Code 来进行 Vibe Coding，项目的主要功能进行过测试验证，源码的结构主要由 Claude Sonnet 4 构建。

## 🛠️ 技术架构

### 核心技术栈
- **开发语言**：Swift 5.0+
- **UI 框架**：SwiftUI
- **目标平台**：macOS 15.5+
- **开发工具**：Xcode 16.4+

### 架构设计
SpeedType 采用现代化的 SwiftUI 架构，实现了清晰的关注点分离：

```
SpeedType/
├── SpeedTypeApp.swift          # 应用入口点
├── ContentView.swift           # 主界面视图
├── ResultView.swift            # 结果展示视图
├── MacStatisticItem.swift      # 统计显示组件
├── TypingTestState.swift       # 测试状态管理
├── Challenge.swift             # 挑战数据模型
├── TypingEngine.swift          # 核心打字逻辑引擎
├── ImageShareHelper.swift      # 图片分享工具
├── DesignSystem.swift          # 设计系统
└── ButtonStyles.swift          # 按钮样式
```

### 关键特性实现

#### 🕐 高精度计时系统
```swift
// 使用 CACurrentMediaTime() 确保亚毫秒级精度
var elapsedTime: TimeInterval {
  guard let startTime else { return 0 }
  if let endTime { return endTime - startTime }
  return isTyping ? CACurrentMediaTime() - startTime : 0
}
```

#### 📊 实时统计计算
- **WPM 计算**：基于标准的 5 字符 = 1 词的转换
- **准确率**：正确字符数 / 总输入字符数 × 100%
- **实时更新**：使用高频定时器确保流畅的统计显示

#### 🎨 原生 macOS 设计
- 完整的亮色/暗色模式支持
- 遵循 macOS 语义化颜色系统
- 原生的按钮样式和交互效果
- 标准的 macOS 间距和圆角规范

## 🏗️ 构建与运行

### 系统要求
- macOS 15.5 或更高版本
- Xcode 16.4 或更高版本
- Swift 5.0 或更高版本

### 构建步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/LZhenHong/SpeedType.git
   cd SpeedType
   ```

2. **打开项目**
   ```bash
   open SpeedType.xcodeproj
   ```

3. **构建项目**
   ```bash
   # 调试版本
   xcodebuild -project SpeedType.xcodeproj -scheme SpeedType -configuration Debug build
   
   # 发布版本
   xcodebuild -project SpeedType.xcodeproj -scheme SpeedType -configuration Release build
   ```

4. **运行应用**
   - 在 Xcode 中按 `⌘R` 运行
   - 或者使用命令行：`xcodebuild -project SpeedType.xcodeproj -scheme SpeedType run`

## 🎮 使用说明

### 基本操作
1. **选择挑战**：从下拉菜单中选择不同的打字挑战
2. **配置设置**：可开启大小写敏感模式和严格模式
3. **开始测试**：按 `Return` 键或点击"开始测试"按钮
4. **结束测试**：按 `Escape` 键或完成所有字符输入
5. **查看结果**：测试完成后可查看详细统计并分享结果

### 键盘快捷键
- `Return`：开始新测试
- `Escape`：结束当前测试

### 设置选项
- **大小写敏感**：区分大小写字符
- **严格模式**：输入错误时立即停止并回退

## 🔧 开发

### 项目结构说明

#### 核心组件

**TypingTestState**
- 集中管理所有测试相关状态
- 使用 `@Observable` 实现响应式状态更新
- 高精度计时和统计计算

**TypingEngine**
- 无状态的核心逻辑引擎
- 处理用户输入验证和字符匹配
- 生成带样式的文本显示

**Challenge Model**
- 定义打字挑战的数据结构
- 支持预设挑战和自定义文本
- 条件编译支持调试模式特殊挑战

#### 设计系统
项目包含完整的 macOS 原生设计系统：
- 语义化颜色（自动适配亮色/暗色模式）
- 标准化间距和圆角
- 原生材质效果和阴影
- 自定义按钮样式

### 添加新挑战
在 `Challenge.swift` 中的 `predefinedChallenges` 数组添加新挑战：

```swift
Challenge(
  id: "unique-identifier",
  title: "挑战显示名称",
  text: "要输入的文本内容"
)
```

### 自定义样式
修改 `DesignSystem.swift` 中的设计标记来自定义外观：
- 颜色：更新语义化颜色定义
- 间距：调整 `MacSpacing` 枚举值
- 圆角：修改 `MacCornerRadius` 值

## 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### 代码规范
- 遵循 Swift 官方代码风格
- 使用项目中的 `.swiftformat` 配置
- 确保所有新功能都有适当的注释
- 保持与现有架构的一致性

## 📄 许可证

本项目基于 MIT 许可证开源 - 查看 [LICENSE](LICENSE) 文件了解详情。
