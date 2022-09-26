---
layout: default
title: rpm.org - 宏语法
---
# 宏语法

RPM有完全递归的spec文件宏。简单的宏直接进行文本替换。参数化的宏包括一个选项字段，并在空白分隔的标记上执行argc/argv处理，直到下一个换行。在宏的扩展过程中，标志和参数都可以作为宏来使用，在宏扩展结束时被删除。宏可以在spec文件的任何地方使用，特别是在 "included file lists" 中（即使用%files -f\<file\>读入的文件）。此外，宏可以被嵌套，在包含嵌套宏的宏扩展过程中隐藏之前的定义。

## 定义宏

要定义一个宏，请使用:

```
	%define <name>[(opts)] <body>
```

围绕着/<body\>的所有空白都被删除。 名称可以由字母数字字符和字符"_"组成，长度必须至少为3个字符。没有(opts)字段的宏是 "简单 "的，因为它只进行递归宏扩展。一个参数化的宏包含一个（opts）字段。作为opts的"-"可以禁用所有的选项处理，否则opts（即括号内的字符串）会在宏调用开始时完全传递给getopt(3)，用于处理argc/argv。"--"可以用来分隔选项和参数。当一个参数化的宏正在被展开时，以下类似shell的宏可以使用。

```
	%0	the name of the macro being invoked
	%*	all arguments (unlike shell, not including any processed flags)
	%#	the number of arguments
	%{-f}	if present at invocation, the flag f itself
	%{-f*}	if present at invocation, the argument to flag f
	%1, %2	the arguments themselves (after getopt(3) processing)
```

在一个参数化宏的调用结束时，上述宏会被丢弃。(目前是静止的)被丢弃。

## 编写宏

在宏的正文中，有几个结构允许测试是否存在可选参数。最简单的结构是"%{-f}"，如果调用宏时提到了-f，它就会扩展（字面意思）为"-f"。也有一些规定，如果有标志存在，可以使用"%{-f:X}"来包含文本。如果存在标志，该宏会扩展为（X的扩展）。也支持负数形式，"%{!-f:Y}"，如果*不存在-f，则扩展到（扩展）Y。

除了"%{...}"形式外，还可以使用"%(shell command) "进行shell扩展。使用"%(shell command)"。

## Builtin Macros

有几个内置的宏（有保留的名称），需要用来执行有用的操作。来执行有用的操作。目前的列表是：

```
	%trace		toggle print of debugging information before/after
			expansion
	%dump		print the active (i.e. non-covered) macro table
	%getncpus	return the number of CPUs
	%getconfdir	expand to rpm "home" directory (typically /usr/lib/rpm)
	%dnl		discard to next line (without expanding)
	%verbose	expand to 1 if rpm is in verbose mode, 0 if not
	%{verbose:...}	expand to ... if rpm is in verbose mode, the
			empty string if not

	%{echo:...}	print ... to stdout
	%{warn:...}	print warning: ... to stderr
	%{error:...}	print error: ... to stderr and return an error
 
	%define ...	define a macro
	%undefine ...	undefine a macro
	%global ...	define a macro whose body is available in global context

	%{macrobody:...}	literal body of a macro

	%{gsub:...}	replace occurences of pattern in a string
                        (see Lua `string.gsub()`)
	%{len:...}	string length
	%{lower:...}	lowercase a string
	%{rep:...}	repeat a string (see Lua `string.rep()`)
	%{reverse:...}	reverse a string
	%{sub:...}	expand to substring (see Lua `string.sub()`)
	%{upper:...}	uppercase a string

	%{basename:...}	basename(1) macro analogue
	%{dirname:...}	dirname(1) macro analogue
	%{exists:...}	test file existence, expands to 1/0
	%{suffix:...}	expand to suffix part of a file name
	%{url2path:...}	convert url to a local path
	%{getenv:...}	getenv(3) macro analogue
	%{uncompress:...} expand ... to <file> and test to see if <file> is
			compressed.  The expansion is
				cat <file>		# if not compressed
				gzip -dc <file>		# if gzip'ed
				bzip2 -dc <file>	# if bzip'ed

	%{load:...}	load a macro file
	%{lua:...}	expand using the [embedded Lua interpreter](lua.md)
	%{expand:...}	like eval, expand ... to <body> and (re-)expand <body>
	%{expr:...}	evaluate an expression
	%{shescape:...}	single quote with escapes for use in shell
	%{shrink:...}	trim leading and trailing whitespace, reduce
			intermediate whitespace to a single space
	%{quote:...}	quote a parametric macro argument, needed to pass
			empty strings or strings with whitespace

	%{S:...}	expand ... to <source> file name
	%{P:...}	expand ... to <patch> file name
```

宏也可以从/usr/lib/rpm/macros自动包含。此外，rpm本身也定义了许多宏。要显示当前的集合，在任何规格文件的开头添加"%dump"，用rpm处理，并检查stderr的输出。

## 条件扩展宏

有时，测试一个宏是否被定义是很有用的。语法

```
%{?macro_name:value}
%{?!macro_name:value}
```

可用于此目的。如果定义了 "macro_name"，%{?macro_name:value}会被扩展为 "value"，否则会扩展为空字符串。%{?!macro_name:value}是否定的变体。如果 "macro_name "没有被定义，它将被扩展为 "value"。"macro_name "没有被定义。否则，它将被扩展为空字符串。

```
%{?!with_python3: %global with_python3 1}
```

A macro that is expanded to 1 if "with_python3" is defined and 0 otherwise:

```
%{?with_python3:1}%{!?with_python3:0}
```

or shortly

```
0%{!?with_python3:1}
```

%"{?macro_name}" is a shortcut for "%{?macro_name:%macro_name}".

对于更复杂的测试，使用[expressions](#expression-expansion)或[Lua](lua)。请注意，`%if`、`%ifarch`和类似的东西不是宏，它们是spec指令，只能在该环境下使用。

请注意，在 rpm >= 4.17 中，内置宏上的条件语句只是测试该内置的存在，就像其他宏一样。在旧版本中，内置条件的行为是未定义的。

## Example of a Macro

Here is an example %patch definition from /usr/lib/rpm/macros:

```
	%patch(b:p:P:REz:) \
	%define patch_file	%{P:%{-P:%{-P*}}%{!-P:%%PATCH0}} \
	%define patch_suffix	%{!-z:%{-b:--suffix %{-b*}}}%{!-b:%{-z:--suffix %{-z*}}}%{!-z:%{!-b: }}%{-z:%{-b:%{error:Can't specify both -z(%{-z*}) and -b(%{-b*})}}} \
		%{uncompress:%patch_file} | patch %{-p:-p%{-p*}} %patch_suffix %{-R} %{-E} \
	...
```


The first line defines %patch with its options. The body of %patch is

```
	%{uncompress:%patch_file} | patch %{-p:-p%{-p*}} %patch_suffix %{-R} %{-E}
```

The body contains 7 macros, which expand as follows

```
	%{uncompress:...}	copy uncompressed patch to stdout
	  %patch_file		... the name of the patch file
	%{-p:...}		if "-p N" was present, (re-)generate "-pN" flag
	  -p%{-p*}		... note patch-2.1 insists on contiguous "-pN"
	%patch_suffix		override (default) ".orig" suffix if desired
	%{-R}			supply -R (reversed) flag if desired
	%{-E}			supply -E (delete empty?) flag if desired
```

There are two "private" helper macros:

```
	%patch_file	the gory details of generating the patch file name
	%patch_suffix	the gory details of overriding the (default) ".orig"
```

## Using a Macro

To use a macro, write:

```
	%<name> ...
```

or

```
	%{<name>}
```

The %{...} form allows you to place the expansion adjacent to other text.
The %\<name\> form, if a parameterized macro, will do argc/argv processing
of the rest of the line as described above.  Normally you will likely want
to invoke a parameterized macro by using the %\<name\> form so that
parameters are expanded properly.

Example:
```
	%define mymacro() (echo -n "My arg is %1" ; sleep %1 ; echo done.)
```

Usage:

```
	%mymacro 5
```

This expands to:

```
	(echo -n "My arg is 5" ; sleep 5 ; echo done.)
```

This will cause all occurrences of %1 in the macro definition to be
replaced by the first argument to the macro, but only if the macro
is invoked as "%mymacro 5".  Invoking as "%{mymacro} 5" will not work
as desired in this case.

## Shell Expansion

Shell expansion can be performed using "%(shell command)". The expansion
of "%(...)" is the output of (the expansion of) ... fed to /bin/sh.
For example, "%(date +%%y%%m%%d)" expands to the string "YYMMDD" (final
newline is deleted). Note the 2nd % needed to escape the arguments to
/bin/date.

## Expression Expansion

Expression expansion can be performed using "%[expression]".  An
expression consists of terms that can be combined using
operators.  Rpm supports three kinds of terms, numbers made up
from digits, strings enclosed in double quotes (eg "somestring") and
versions enclosed in double quotes preceded by v (eg v"3:1.2-1").
Rpm will expand macros when evaluating terms.

You can use the standard operators to combine terms: logical
operators &&, ||, !, relational operators !=, ==, <, > , <=, >=,
arithmetic operators +, -, /, *, the ternary operator ? :, and
parentheses.  For example, "%[ 3 + 4 * (1 + %two) ]" will expand
to "15" if "%two" expands to "2". Version terms are compared using
rpm version ([epoch:]version[-release]) comparison algorithm,
rather than regular string comparison.

Note that the "%[expression]" expansion is different to the
"%{expr:expression}" macro.  With the latter, the macros in the
expression are expanded first and then the expression is
evaluated (without re-expanding the terms).  Thus

```
	rpm --define 'foo 1 + 2' --eval '%{expr:%foo}'
```

will print "3".  Using '%[%foo]' instead will result in the
error that "1 + 2" is not a number.

Doing the macro expansion when evaluating the terms has two
advantages.  First, it allows rpm to do correct short-circuit 
processing when evaluation logical operators.  Second, the
expansion result does not influence the expression parsing,
e.g. '%["%file"] will even work if the "%file" macro expands
to a string that contains a double quote.

## Command Line Options

When the command line option "--define 'macroname value'" allows the
user to specify the value that a macro should have during the build.
Note lack of leading % for the macro name.  We will try to support
users who accidentally type the leading % but this should not be
relied upon.

Evaluating a macro can be difficult outside of an rpm execution context. If
you wish to see the expanded value of a macro, you may use the option

```
	--eval '<macro expression>'
```

that will read rpm config files and print the macro expansion on stdout.

Note: This works only macros defined in rpm configuration files, not for
macros defined in specfiles. You can use %{echo: %{your_macro_here}} if
you wish to see the expansion of a macro defined in a spec file.
 
## Configuration using Macros

Most rpm configuration is done via macros. There are numerous places from
which macros are read, in recent rpm versions the macro path can be seen
with `rpm --showrc|grep "^Macro path"`. If there are multiple definitions
of the same macro, the last one wins. User-level configuration goes
to ~/.rpmmacros which is always the last one in the path.

The macro file syntax is simply:

```
%<name>		 <body>
```

...where <name> is a legal macro name and <body> is the body of the macro.
Multiline macros can be defined by shell-like line continuation, ie `\`
at end of line.

Note that the macro file syntax is strictly declarative, no conditionals
are supported (except of course in the macro body) and no macros are
expanded during macro file read.

## Macro Analogues of Autoconf Variables

Several macro definitions provided by the default rpm macro set have uses in
packaging similar to the autoconf variables that are used in building packages:

```
    %_prefix		/usr
    %_exec_prefix	%{_prefix}
    %_bindir		%{_exec_prefix}/bin
    %_sbindir		%{_exec_prefix}/sbin
    %_libexecdir	%{_exec_prefix}/libexec
    %_datadir		%{_prefix}/share
    %_sysconfdir	/etc
    %_sharedstatedir	%{_prefix}/com
    %_localstatedir	%{_prefix}/var
    %_libdir		%{_exec_prefix}/lib
    %_includedir	%{_prefix}/include
    %_oldincludedir	/usr/include
    %_infodir		%{_datadir}/info
    %_mandir		%{_datadir}/man
```
