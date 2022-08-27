---
layout: default
title: rpm.org - RPM 参考手册
---
# RPM 参考手册

## 软件包管理

### 查询和 RPM 元数据
* [RPM 标签](tags.md)
* [大文件支持](large_files.md)
* [Query formatting](queryformat.md)

## Macro 子系统
* [Macro 语法](macros.md)
* [内嵌的Lua](lua.md)

## 软件包构建
* [构建过程](buildprocess.md)
* [Spec语法](spec.md)
  * [Autosetup](autosetup.md)
  * 依赖处理
    * [依赖处理的基础说明](dependencies.md)
    * [依赖处理的更多说明](more_dependencies.md)
    * [Boolean相关的依赖说明](boolean_dependencies.md)
    * [架构相关的依赖说明](arch_dependencies.md)
    * [安装 Order](tsort.md)
    * [依赖自动生成的说明](dependency_generators.md)
  * 安装脚本
    * [Triggers](triggers.md)
    * [File Triggers](file_triggers.md)
    * [Scriptlet Expansion](scriptlet_expansion.md)
  * [构建中的条件判断](conditionalbuilds.md)
  * [Relocatable Packages](relocatable.md)
  * [Multiple build areas](multiplebuilds.md)


## 开发者相关的信息

### API
* [插件API](plugins.md)

### Package Format
* [RPM v3文件格式](format.md)
* [RPM v4 header regions](hregions.md)
* [RPM v4 signatures and digests](signatures_digests.md)

### Documentation
* [Write documentation](devel_documentation.md)
