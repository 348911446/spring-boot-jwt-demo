
Simple demo with only 3 classes  

#### Please run example in *basic* folder;  
#### Then try to look at complete version in *complete* folder


方案 A（强烈推荐）：在联网机上临时使用“便携”JDK 解压并运行 Gradle，然后拷回缓存
总体思路：在有网的电脑上下载一个 Windows x64 的 JDK zip（无需安装，只解压），在该机器上运行仓库的 Gradle wrapper 去执行 init（和/或 buildGhidra），让 Gradle 自动把所有需要的 jar 下载到本地 Gradle 缓存；然后把下列目录拷回离线机：

仓库内的 dependencies 目录（repo-root/dependencies）
用户 Gradle 缓存目录 %USERPROFILE%\.gradle（包含 caches、wrapper\dists 等）
优点：最简单、最可靠，Gradle 会处理传递依赖与版本。拷回后，在离线机上再次运行 .[gradlew.bat](http://_vscodecontentref_/4) -I [fetchDependencies.gradle](http://_vscodecontentref_/5) init 就不会去联网拉包了。

步骤（在“可以上网但不能/不想安装 Java”的那台联网 Windows 机器上）：

下载一个 Windows x64 JDK zip（推荐 Adoptium / Temurin 或 Azul Zulu）。示例（请用浏览器打开并下载 Windows x64 zip 版本）：

Temurin (Adoptium) 页面（选择 Windows x64 JDK zip）： https://adoptium.net
Azul Zulu 也有 zip 包：https://www.azul.com/downloads/?package=jdk
说明：我不写出一个特定版本的固定链接以避免过期。你只需在页面上选择 JDK 21、Windows x64、ZIP (no installer) 并下载。文件通常名类似 OpenJDK21U-jdk_x64_windows_hotspot_21.0.x.zip。

在联网机上把 JDK zip 解压到一个临时目录（例如：C:\temp\jdk21）。用 PowerShell（在联网机上）：


# 假设你把 zip 放在 C:\Downloads\jdk21.zipExpand-Archive -Path "C:\Downloads\OpenJDK21U-jdk_x64_windows_hotspot_21*.zip" -DestinationPath "C:\temp\jdk21"
（或用资源管理器右键解压）

在联网机上把你的仓库代码拷贝 / 克隆一份（或直接在本地已有仓库目录中操作）。进入仓库根目录（与 gradlew.bat 同级）。

在同一个 PowerShell 会话中，临时设置 JAVA_HOME 与 PATH，运行 gradle wrapper。示例：


# 进入你的仓库目录Set-Location "E:\你的仓库路径\ghidra-master"   # 根据实际路径调整# 临时设置 JAVA_HOME 指向刚解压的 JDK（只在当前 PowerShell 会话中有效）$env:JAVA_HOME = "C:\Users\liuy\Downloads\OpenJDK21U-jdk_x64_windows_hotspot_21.0.9_10\jdk-21.0.9+10"  # 把路径改为实际解压路径$env:Path = "$env:JAVA_HOME\bin;$env:Path"# 现在用 gradle wrapper 执行 init（并让 fetchDependencies 脚本跑）.\gradlew.bat -I gradle/support/fetchDependencies.gradle init# 可选：为了预抓更多构件，执行一次完整构建（耗时更久）.\gradlew.bat -I gradle/support/fetchDependencies.gradle buildGhidra
注意：buildGhidra 会下载更多依赖并构建，耗时与所需磁盘空间更大，但能更全面预抓依赖。建议先运行 init，确认通过，再决定是否运行 buildGhidra。
等待命令完成（如果成功，Gradle 会把所有需要的 jar/pom 下载到该用户的 Gradle 缓存中，即 %USERPROFILE%\.gradle\）。常见目录包括：
%USERPROFILE%\.gradle\caches\modules-2\files-2.1\...
%USERPROFILE%\.gradle\wrapper\dists\...（这里存放 gradle 发行版）
可能还有 %USERPROFILE%\.m2\repository（如果某些工具使用 maven 本地仓库）
拷回这些目录到离线机
把仓库的 dependencies 目录（repo-root/dependencies）拷到离线机仓库相同位置（即把联网机上 repo 的 dependencies 覆盖到离线机 repo）。
把整个 %USERPROFILE%\.gradle 目录拷到离线机对应用户目录下（覆盖或合并）。建议拷整个 .gradle，这样最保险。可以用外接移动盘复制。


* Exception is:
org.gradle.internal.service.ServiceCreationException: Could not initialize native services.
        at org.gradle.internal.nativeintegration.services.NativeServices.initialize(NativeServices.java:290)
        at org.gradle.internal.nativeintegration.services.NativeServices.initializeOnDaemon(NativeServices.java:250)
        at org.gradle.launcher.daemon.bootstrap.DaemonMain.doAction(DaemonMain.java:114)
        at org.gradle.launcher.bootstrap.EntryPoint.run(EntryPoint.java:53)
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103)
        at java.base/java.lang.reflect.Method.invoke(Method.java:580)
        at org.gradle.launcher.bootstrap.ProcessBootstrap.runNoExit(ProcessBootstrap.java:72)
        at org.gradle.launcher.bootstrap.ProcessBootstrap.run(ProcessBootstrap.java:39)
        at org.gradle.launcher.daemon.bootstrap.GradleDaemon.main(GradleDaemon.java:22)
Caused by: net.rubygrapefruit.platform.NativeException: Failed to initialise native integration.
        at org.gradle.fileevents.FileEvents.init(FileEvents.java:71)
        at org.gradle.internal.nativeintegration.services.NativeServices$NativeFeatures$1.initialize(NativeServices.java:118)
        at org.gradle.internal.nativeintegration.services.NativeServices.<init>(NativeServices.java:343)
        at org.gradle.internal.nativeintegration.services.NativeServices.initialize(NativeServices.java:288)
        ... 8 more
Caused by: java.lang.UnsatisfiedLinkError: C:\Users\liuy\.gradle\native\0.2.8\x86_64-windows-gnu\gradle-fileevents.dll: 锟揭诧拷锟斤拷指锟斤拷锟侥筹拷锟斤拷
        at java.base/jdk.internal.loader.NativeLibraries.load(Native Method)
        at java.base/jdk.internal.loader.NativeLibraries$NativeLibraryImpl.open(NativeLibraries.java:331)
        at java.base/jdk.internal.loader.NativeLibraries.loadLibrary(NativeLibraries.java:197)
        at java.base/jdk.internal.loader.NativeLibraries.loadLibrary(NativeLibraries.java:139)
        at java.base/java.lang.ClassLoader.loadLibrary(ClassLoader.java:2418)
        at java.base/java.lang.Runtime.load0(Runtime.java:852)
        at java.base/java.lang.System.load(System.java:2025)
        at org.gradle.fileevents.FileEvents.init(FileEvents.java:55)
        ... 11 more
