---
layout: default
title: rpm.org - RPM Plugin Interface (DRAFT)
---
# RPM Plugin Interface (DRAFT)

当前的插件接口集中在 rpmtsRun() 内部发生的事情，而在它之外几乎没有发生什么。 没有理由不能将界面增强到其他方向，这只是插件背后的主要动机之一的结果：使 SELinux 和 MSSF 等其他项目能够处理他们最了解的领域，而无需支持十几个 rpm 本身内的不同安全“框架”。

插件 API 由一组大部分成对出现的钩子组成。 所有钩子都接收插件本身作为第一个参数，类似于 C++ 中的 this 或 Python 中的 self 。 从 RPM 4.12.0 开始，存在以下钩子：

```
struct rpmPluginHooks_s { 
    /* plugin constructor and destructor hooks */
    plugin_init_func                    init;
    plugin_cleanup_func                 cleanup;
    /* per transaction plugin hooks */
    plugin_tsm_pre_func                 tsm_pre;
    plugin_tsm_post_func                tsm_post;
    /* per transaction element hooks */
    plugin_psm_pre_func                 psm_pre;
    plugin_psm_post_func                psm_post;
    /* per scriptlet hooks */
    plugin_scriptlet_pre_func           scriptlet_pre;
    plugin_scriptlet_fork_post_func     scriptlet_fork_post;
    plugin_scriptlet_post_func          scriptlet_post;
    /* per file hooks */
    plugin_fsm_file_pre_func            fsm_file_pre;
    plugin_fsm_file_post_func           fsm_file_post;
    plugin_fsm_file_prepare_func        fsm_file_prepare;
};
```

## Initialization and cleanup

钩子`init`和`cleanup`应该是相当明显的。初始化发生在第一个事务元素添加的时候，无论是安装、擦除还是重新安装。

在调用rpmtsFree()时进行清理。

## Per transaction hooks

钩子`tsm_pre`和`tsm_post`发生在事务执行之前和之后。更确切地说，pre在任何脚本被执行或文件被放置之前运行，post在所有脚本被执行和文件被放置之后运行。

只要pre hook被执行，Post hook就会被保证执行。

## Per transaction element hooks

钩子 "psm_pre "和 "psm_post "在交易中处理单个交易元素之前和之后发生。这两个钩子可以为一个元素执行多次，因为除了主要的软件包安装或删除操作外，这些钩子还被%pretrans和%posttrans脚本小程序分别调用。

只要前钩子被执行，后钩子就会被保证执行。

## Per scriptlet hooks

钩子`scriptlet_pre`和`scriptlet_post`发生在任何rpm脚本执行之前和之后，所以这些钩子可以为一个元素被多次调用。

只要pre钩子被执行，post钩子就会被保证执行。

`scriptlet_fork_post`钩子很特别，因为它发生在分叉的子程序中，就在scriptlet解释器的exec()之前，而且它没有配对的pre-hook。`scriptlet_fork_post`钩子只在`scriptlet_pre`成功时执行。

## Per file hooks

钩子`fsm_file_pre`，`fsm_file_post`和`fsm_file_prepare`为所有事务元素的每个单独文件执行。前钩子在文件（或目录）被创建之前运行，后钩子在rpm完成对文件的所有处理后运行。在这之间，`fsm_file_prepare`可能被调用。准备钩子在文件被完全创建并设置了正常的元数据（如所有权、权限等）后运行，但在文件被移动到其最终位置之前。注意，prepare有时会被跳过，特别是对于硬链接的文件，每个硬链接集只调用一次prepare。

在大多数情况下，fi参数是rpm所拥有的关于文件的所有信息的句柄，但是在无主目录的情况下，它可以是NULL。path参数对于拥有的文件似乎是多余的，但是在`fsm_file_pre`和`fsm_file_prepare`中，它持有临时文件的名称，而这是无法通过fi访问的。

后钩子保证在前钩子被执行时执行。

警告。这些钩子的确切关系和语义可能会改变，因为有计划改善rpms在失败情况下撤销文件操作的能力。

## Examples

关于一些简单的例子，请看rpm本身提供的插件。[https://github.com/rpm-software-management/rpm/tree/master/plugins (https://github.com/rpm-software-management/rpm/tree/master/plugins)
