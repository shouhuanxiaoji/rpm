---
layout: default
title: rpm.org - 软件包构建过程
---
# 软件包构建过程

* 解压 srpm/tar (可选)
* [解析 spec](https://github.com/rpm-software-management/rpm/blob/master/build/parseSpec.c)  - 又见 [build/parse*.c](https://github.com/rpm-software-management/rpm/blob/master/build/)
  * 如果检测到`buildarch`，则多次解析spec--为每个设置了`_target_cpu'宏的arch解析一次
  * 编译阶段会迭代遍历所有的spec文件变量，然后编译出多个版本。
* 检查静态的requires
* 执行构建脚本 (see [doScript()](https://github.com/rpm-software-management/rpm/blob/master/build/build.c#L95)
  * %prep
  * %generate_buildrequires if present
    * re-check build requires - stop build on errors
  * %conf
  * %build
  * %install
  * %check - if present
 * 处理 files
   * 将%files行变成实际文件（evaluate globs）
     * 从-f参数读取
   * 运行 [file classifiers](https://github.com/rpm-software-management/rpm/blob/master/build/rpmfc.c) 
   * 生成自动的依赖列表
   * 根据安装根目录检查打包的文件
 * 创建软件包
 * %clean
 * 清理
