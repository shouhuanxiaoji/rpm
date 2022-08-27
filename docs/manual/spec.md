---
layout: default
title: rpm.org - Spec文件格式
---
# Spec文件格式

## 通用语法

### 注释

spec文件中的注释为在一行的开头使用#。

```
    # this is a comment
```

即使在注释行中，宏也会被扩展。如果不希望这样，可以用一个额外的百分号（%）来转义宏。

```
    # make unversioned %%__python an error unless explicitly overridden
```

(rpm >= 4.15之后)另一个选择是使用内置的宏 %dnl，它将文本丢弃到下一行而不展开。

```
    %dnl make unversioned %__python an error unless explicitly overridden
```

### 条件判断

RPM的spec文件格式允许条件判断的代码块被使用，这取决于各种类型，如架构（%ifarch /%ifnarch），操作系统（%ifos / %ifnos），或条件表达式（%if）。

%ifarch通常用于为多个平台构建RPM包，如。

```
	%ifarch s390 s390x
	BuildRequires: s390utils-devel
	%endif
```

%ifos用于根据构建目标操作系统控制RPM的规格文件处理。

%if可以用于各种目的。测试可以基于以下几点进行评估 一个宏的存在，比如。

```
	%if %{defined with_foo} && %{undefined with_bar}
```

字符串比较：

```
	%if "%{optimize_flags}" != "none"
```
or a mathematical statement:
```
	%if 0%{?fedora} > 10 || 0%{?rhel} > 7
```

一般来说，逻辑运算语句允许使用逻辑运算符`&&`，`||`，`！`，关系运算符`！=`，`==`，`<`，`>`，`<=`，`>=`，算术运算符`+`，`-`，`/`，`*`，三元运算符`? :` 和括号。

条件块以%endif结束。在条件块内可以选择使用%elif、%elifarch、%elifos或%else。条件语句%endif和%else后面不应该有任何文字。条件语句可以嵌套在其他条件语句中。

%if-条件 不是宏，如果在其中使用，不太可能产生预期的结果。如果在其中使用，不太可能产生预期的结果。

## Preamble

### Preamble标签

#### Name

Name标签包含软件包的真正名称。Name不能包括空格，但可以包括一个连字符'-'（与version和release标签不同）。Name不应包括任何数字运算符（'<'、'>'、'='），因为未来版本的rpm可能需要保留'-'以外的字符。

默认情况下，子包的命名方式是在子包的名称前加上 `\<main package\>-' 。如果你想改变一个子包的名称（最常见的是将'-'改为'.'），那么你必须在%package定义中用-n参数指定全名:

```
	%package -n newname
```

#### Version

rpm软件包的版本，通常就是软件的版本。

版本字符串由字母、数字和字符组成，可以选择用分隔符`.`、```_``` 和 `+` 分段。

波浪号（`~`）可以用来强制排序低于基数（1.1~201601 < 1.1) 
上尖角（`^`）可用于强制排序高于基数（1.1^201601 > 1.1）。
这些对于处理发布前和发布后的版本很有用，例如1.0~rc1和2.0^a。

#### Release

Package release, used for distinguishing between different builds
of the same software version.

See Version for allowed characters and modifiers.

#### Epoch

可选的数值，可以用来覆盖正常的版本发布排序。如果可能的话，应该避免使用它。

在所有的版本比较中，没有epoch等于 `epoch: 0`。

#### License

Short (< 70 characters) summary of the package license. For example:
```
	License: GPLv3
```

#### SourceLicense

If license of the sources differ from the main package the license tag
of the source package can be set with this. If not given the license
tag of the source and the main package are the same.

#### Group

Optional, short (< 70 characters) group of the package.
```
	Group: Development/Libraries
```

#### Summary

Short (< 70 characters) summary of the package.  
```
	Summary: Utility for converting mumbles into giggles
```

#### Source

Used to declare source(s) used to build the package. All sources will
will be packaged into source rpms.
Arbitrary number of sources may be declared, for example:

```
	Source0: mysoft-1.0.tar.gz
	Source1: mysoft-data-1.0.zip
```

#### Patch

Used to declare patches applied on top of sources. All patches declared
will be packaged into source rpms.

#### Icon

Used to attach an icon to an rpm package file. Obsolete.

#### NoSource
#### NoPatch

Files ending in .nosrc.rpm are generally source RPM packages whose spec
files have one or more NoSource: or NoPatch: directives in them.  Both
directives use the named source or patch file to build the resulting
binary RPM package as usual, but they are not included in the source
RPM package.

The original intent of this ability of RPM was to allow proprietary or
non-distributable software to be built using RPM, but to keep the
proprietary or non-distributable parts out of the resulting source RPM
package, so that they would not get distributed.

They also have utility if you are building RPM packages for software
which is archived at a well-known location and does not require that
you distribute the source with the binary, for example, for an
organization's internal use, where storing large quantities of source
is not as meaningful.

The end result of all this, though, is that you can't rebuild
``no-source'' RPM packages using `rpm --rebuild' unless you also have
the sources or patches which are not included in the .nosrc.rpm.

#### URL

URL supplying further information about the package, typically upstream
website.

#### BugURL

Bug reporting URL for the package.

#### ModularityLabel
#### DistTag
#### VCS

#### Distribution
#### Vendor
#### Packager

Optional package distribution/vendor/maintainer name / contact information.
Rarely used in specs, typically filled in by buildsystem macros.

#### BuildRoot

Obsolete and unused in rpm >= 4.6.0, but permitted for compatibility
with old packages that might still depend on it.

Do not use in new packages.

#### AutoReqProv
#### AutoReq
#### AutoProv

Control per-package automatic dependency generation for provides and requires. 
Accepted values are 1/0 or yes/no, default is always "yes". Autoreqprov is
equal to specifying Autoreq and Autoprov separately.

### Dependencies

The following tags are used to supply package dependency information,
all follow the same basic form. Can appear multiple times in the spec,
multiple values accepted, a single value is of the form
`capability [operator version]`. Capability names must
start with alphanumerics or underscore. Optional version range can be
supplied after capability name, accepted operators are `=`, `<`, `>`,
`<=` and `>=`, version 

#### Requires

Capabilities this package requires to function at all. Besides ensuring
required packages get installed, this is also used to order installs
and erasures. 

Additional context can be supplied using `Requires(qualifier)` syntax,
accepted qualifiers are:

* `pre`

  Denotes the dependency must be present in before the package is
  is installed, and is used a strong ordering hint to break possible
  dependency loops. A pre-dependency is free to be removed
  once the install-transaction completes.

  Also relates to `%pre` scriptlet execution.

* `post`

  Denotes the dependency must be present right after the package is
  is installed, and is used a strong ordering hint to break possible
  dependency loops. A post-dependnecy is free to be removed
  once the install-transaction completes.

  Also relates to `%post` scriptlet execution.

* `preun`

  Denotes the dependency must be present in before the package is
  is removed, and is used a strong ordering hint to break possible
  dependency loops.

  Also relates to `%preun` scriptlet execution.

* `postun`

  Denotes the dependency must be present right after the package is
  is removed, and is used a strong ordering hint to break possible
  dependency loops.

  Also relates to `%postun` scriptlet execution.

* `pretrans`

  Denotes the dependency must be present before the transaction starts,
  and cannot be satisified by added packages in a transaction. As such,
  it does not affect transaction ordering. A pretrans-dependency is
  free to be removed after the install-transaction completes.

  Also relates to `%pretrans` scriptlet execution.

* `posttrans`

  Denotes the dependency must be present at the end of transaction, ie
  cannot be removed during the transaction. As such, it does not affect
  transaction ordering. A posttrans-dependency is free to be removed
  after the the install-transaction completes.

  Also relates to `%posttrans` scriptlet execution.

* `verify`

  Relates to `%verify` scriptlet execution. As `%verify` scriptlet is not
  executed during install/erase, this does not affect transaction ordering.

* `interp`

  Denotes a scriptlet interpreter dependency, usually added automatically
  by rpm. Used as a strong ordering hint for breaking dependency loops.

* `meta` (since rpm >= 4.16)

  Denotes a "meta" dependency, which must not affect transaction ordering.
  Typical use-cases would be meta-packages and sub-package cross-dependencies
  whose purpose is just to ensure the sub-packages stay on common version.

Multiple qualifiers can be supplied separated by comma, as long as
they're not semantically contradictory: `meta` qualifier contradicts any
ordered qualifier, eg `meta` and `verify` can be combined, and `pre` and
`verify` can be combined, but `pre` and `meta` can not.

As noted above, dependencies qualified as install-time only (`pretrans`,
`pre`, `post`, `posttrans` or combination of them) can be removed after the
installation transaction completes if there are no other dependencies
to prevent that. This is a common source of confusion.

#### Provides

Capabilities provided by this package.

`name = [epoch:]version-release` is automatically added to all packages.

#### Conflicts

Capabilities this package conflicts with, typically packages with
conflicting paths or otherwise conflicting functionality.

#### Obsoletes

Packages obsoleted by this package. Used for replacing and renaming
packages.

#### Recommends (since rpm >= 4.13)
#### Suggests
#### Supplements
#### Enhances

#### OrderWithRequires (sicne rpm >= 4.9)

#### Prereq

Obsolete, do not use.

#### BuildPrereq

Obsolete, do not use.

#### BuildRequires

Capabilities required to build the package.

Build dependencies are identical to install dependencies except:

```
  1) they are prefixed with build (e.g. BuildRequires: rather than Requires:)
  2) they are resolved before building rather than before installing.
```

So, if you were to write a specfile for a package that requires gcc to build,
you would add
```
	BuildRequires: gcc
```
to your spec file.

If your package was like dump and could not be built w/o a specific version of
the libraries to access an ext2 file system, you could express this as
```
	BuildRequires: e2fsprofs-devel = 1.17-1
```

#### BuildConflicts

Capabilities which conflict, ie cannot be installed during the package
package build.

For example if somelib-devel presence causes the package to fail build,
you would add
```
	BuildConflicts: somelib-devel
```

#### ExcludeArch

Package is not buildable on architectures listed here.
Used when software is portable across most architectures except some,
for example due to endianess issues.

#### ExclusiveArch

Package is only buildable on architectures listed here.
For example, it's probably not possible to build an i386-specific BIOS
utility on ARM, and even if it was it probably would not make any sense.

#### ExcludeOS

Package is not buildable on specific OSes listed here.

#### ExclusiveOS

Package is only buildable on OSes listed here.

#### BuildArch (or BuildArchitectures)

Specifies the architecture which the resulting binary package
will run on.  Typically this is a CPU architecture like sparc,
i386. The string 'noarch' is reserved for specifying that the
resulting binary package is platform independent.  Typical platform
independent packages are html, perl, python, java, and ps packages.

As a special case, `BuildArch: noarch` can be used on sub-package
level to allow eg. documentation of otherwise arch-specific package
to be shared across multiple architectures.

#### Prefixes (or Prefix)

Specify prefixes this package may be installed into, used to make
packages relocatable. Very few packages are.

#### DocDir

Declare a non-default documentation directory for the package.
Usually not needed.

#### RemovePathPostfixes

Colon separated lists of path postfixes that are removed from the end
of file names when adding those files to the package. Used on sub-package
level.

Used for creating sub-packages with conflicting files, such as different
variants of the same content (eg minimal and full versions of the same
software). 

### Sub-sections

#### %description

%description is free form text, but there are two things to note.
The first regards reformatting.  Lines that begin with white space
are considered "pre-formatted" and will be left alone.  Adjacent
lines without leading whitespace are considered a single paragraph
and may be subject to formatting by glint or another RPM tool.

### Dependencies

## 构建脚本

包的构建分为多个独立的步骤，每个步骤都在独立的shell进程中执行。

### %prep

%prep为构建源代码做准备。在这里，源代码被解压，可能的补丁被应用，以及其他类似的活动可以被执行。

通常(%autosetup)[autosetup.md]被用来自动处理这一切，但对于更高级的情况，有更低级别的 `%setup` 和 `%patch` 内置宏在这个槽中可用。

In simple packages `%prep` is often just:
```
%prep
%autosetup
```
 
### %generate_buildrequires (since rpm >= 4.15)

This optional script can be used to determine `BuildRequires`
dynamically. If present it is executed after %prep and can though
access the unpacked and patched sources. The script must print the found build
dependencies to stdout in the same syntax as used after
`BuildRequires:` one dependency per line.

`rpmbuild` will then check if the dependencies are met before
continuing the build. If some dependencies are missing a package with
the `.buildreqs.nosrc.rpm` postfix is created, that - as the name
suggests - contains the found build requires but no sources. It can be
used to install the build requires and restart the build.

On success the found build dependencies are also added to the source
package. As always they depend on the exact circumstance of the build
and may be different when bulding based on other packages or even
another architecture.

### %conf (since rpm >= 4.18)

In %conf, the unpacked sources are configured for building.

Different build- and language ecosystems come with their
own helper macros, but rpm has helpers for autotools based builds such as
itself which typically look like this:

```
%conf
%configure
```

### %build

In %build, the unpacked (and configured) sources are compiled to binaries.

Different build- and language ecosystems come with their
own helper macros, but rpm has helpers for autotools based builds such as
itself which typically look like this:

```
%build
%make_build
```

### %install

In `%install`, the software installation layout is prepared by creating
the necessary directory structure into an initially empty "build root"
directory and copying the just-built software in there to appropriate
places. For many simple packages this is just:

```
%install
%make_install
```

`%install` required for creating packages that contain any files.

### %check

If the packaged software has accomppanying tests, this is where they
should be executed.

## Runtime scriptlets

Runtime scriptlets are executed at the time of install and erase of the
package. By default, scriptlets are executed with `/bin/sh` shell, but
this can be overridden with `-p <path>` as an argument to the scriptlet
for each scriptlet individually. Other supported operations include
[scriptlet expansion](scriptlet_expansion.md).

### Basic scriptlets

 * `%pre`
 * `%post`
 * `%preun`
 * `%postun`
 * `%pretrans`
 * `%posttrans`
 * `%verify`

### Triggers

 * `%triggerprein`
 * `%triggerin`
 * `%triggerun`
 * `%triggerpostun`

More information is available in [trigger chapter](triggers.md).

### File triggers (since rpm >= 4.13)

 * `%filetriggerin`
 * `%filetriggerun`
 * `%filetriggerpostun`
 * `%transfiletriggerin`
 * `%transfiletriggerun`
 * `%transfiletriggerpostun`

More information is available in [file trigger chapter](file_triggers.md).

## %files section

### Virtual File Attribute(s)

#### %artifact (since rpm >= 4.14.1)

The %artifact attribute can be used to denote files that are more like
side-effects of packaging than actual content the user would be interested
in. Such files can be easily filtered out on queries and also left out
of installations if space is tight.

#### %ghost

A %ghost tag on a file indicates that this file is not to be included
in the package.  It is typically used when the attributes of the file
are important while the contents is not (e.g. a log file).

#### %config

The %config(missingok) indicates that the file need not exist on the
installed machine. The %config(missingok) is frequently used for files
like /etc/rc.d/rc2.d/S55named where the (non-)existence of the symlink
is part of the configuration in %post, and the file may need to be
removed when this package is removed.  This file is not required to
exist at either install or uninstall time.

The %config(noreplace) indicates that the file in the package should
be installed with extension .rpmnew if there is already a modified file
with the same name on the installed machine.

#### %dir

Used to explicitly own the directory itself but not it's contents.

#### %doc

Used to mark and/or install files as documentation. Can be used as a
regular attribute on an absolute path, or in "special" form on a path
relative to the build directory which causes the files to be installed
and packaged as documentation. The special form strips all but the last
path component. Thus `%doc path/to/docfile` installs `docfile` in the
documentation path.

Can also be used to filter out documentation from installations where
space is tight.

#### %license (since rpm >= 4.11)

Used to mark and/or install files as licenses. Same as %doc, but 
cannot be filtered out as licenses must always be present in packages.

#### %readme

Obsolete.

#### %verify

The virtual file attribute token %verify tells `-V/--verify' to ignore
certain features on files which may be modified by (say) a postinstall
script so that false problems are not displayed during package verification.
```
	%verify(not size filedigest mtime) %{prefix}/bin/javaswarm
```

Supported modifiers are:
* filedigest (or md5)
* size
* link
* user (or owner)
* group
* mtime
* mode
* rdev
* caps

### Shell Globbing

The usual rules for shell globbing apply (see `glob(7)`), including brace
expansion.  Metacharacters can be escaped by prefixing them with a backslash
(`\`).  A backslash or percent sign can be escaped with an extra `\` or `%`,
respectively.  Spaces are used to separate file names and must be escaped by
enclosing the file name in quotes.

For example:

```
	/opt/are.you|bob\?
	/opt/bob's\*htdocs\*
	/opt/bob's%%htdocs%%
	"/opt/bob's htdocs"
```

When trying to escape a large number of file names, it is often best to create
a file with a complete list of escaped file names.  This is easiest to do with
a shell script like this:

```
	rm -f filelist.txt
	find %{buildroot} -type f -printf '/%%P\n' |	\
	perl -pe 's/(%)/%$1/g;'				\
	     -pe 's/([*?\[\]{}\\])/\\$1/g;'		\
	> filelist.txt

	%files -f filelist.txt
```

## %changelog section
