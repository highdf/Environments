### Configs
| 目录 | 介绍 |
| :-: | :--: |
| Dynamic | 存储工具的配置文件（可使用脚本自动更新） |
| Dynamic/hypr | 平铺窗口管理器 hyprland 配置 |
| Dynamic/waybar | 桌面状态栏 waybar 配置 | 
| Dynamic/dunst | 通知管理工具 dunst 配置 |
| Dynamic/fcitx5 | 输入法 fcitx5 的配置 |
| Dynamic/imv | 图片查看器 imv 的配置文件 |
| Dynamic/kitty | 终端模拟器 kitty 的配置和主题 |
| Dynamic/mpv | 媒体播放器 mpv 的配置文件 |
| Dynamic/tofi | 应用启动器 tofi 的配置和主题 |
| Dynamic/yazi | 文件管理器 yazi 的 TOML 格式配置文件 |
| Dynamic/zathura | PDF 阅读器 zathura 的键位和主题配置 |
| Static | 静态配置和系统资源文件 |
| Static/Browser-extensions | 浏览器扩展配置备份文件 |
| Static/clash | 网络代理工具 Clash 的配置和数据库文件 |
| Static/Extra_Config | 附加组件配置（swayimg/swaync） |
| Static/Init | 系统初始化文件和字体配置 |
| Static/PkgList | 软件包安装列表（pacman/yay 分类） |
| Static/source | 配置来源元数据（克隆/备份/主题记录） |
| Static/Template | 项目模板文件（含 Maven 模板） |

### Scripts
| 目录 | 介绍 |
| :-: | :--: |
| Scripts | 核心脚本存储目录（包含系统维护/环境初始化/元数据管理功能） |
| Daily_auto | 日常自动化脚本（配置备份/主题切换/仓库同步） |
| Daily_auto/config_backup.py | 配置文件自动备份工具（支持增量备份） |
| Daily_auto/theme_switch.py | 系统主题切换控制器（集成多主题支持） |
| Environments_init | 环境构建工具集（支持一键部署开发环境） |
| Environments_init/auto_install.sh | 软件包自动安装脚本（适配Arch系发行版） |
| Environments_init/repo_clone.py | 仓库克隆工具（支持JSON配置源同步） |
| Meta | 元数据管理系统（处理项目配置和缓存） |
| Meta/meta.py | 元数据处理器（管理.pyc缓存文件版本） |
