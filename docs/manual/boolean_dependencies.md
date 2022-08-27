---
layout: default
title: rpm.org - Boolean Dependencies
---
## Boolean Dependencies

从rpm-4.13开始，rpm能够处理所有依赖项中的布尔表达式（需要、推荐、建议、补充、增强、冲突）。布尔表达式总是用括号括起来。它们是基于“普通”依赖关系构建的：要么是名称，要么是名称、比较和版本描述。

## Boolean Operators

RPM 4.13中介绍了以下运算符：

 * `and` - requires all operands to be fulfilled for the term to be True.
  * `Conflicts: (pkgA and pkgB)`
 * `or` - requires one of the operands to be fulfilled
  * `Requires: (pkgA >= 3.2 or pkgB)`
 * `if` - requires the first operand to be fulfilled if the second is (reverse implication)
  * `Recommends: (myPkg-langCZ if langsupportCZ)`
 * `if else` - same as above but requires the third operand to be fulfilled if the second is not
  * `Requires: (myPkg-backend-mariaDB if mariaDB else sqlite)`

RPM 4.14中引入了以下附加运算符：

 * `with` - requires all operands to be fulfilled by the same package for the term to be True.
  * `Requires: (pkgA-foo with pkgA-bar)`
 * `without` - requires a single package that satisfies the first operand but not the second (set subtraction)
  * `Requires: (pkgA-foo without pkgA-bar)`
 * `unless` - requires the first operand to be fulfilled if the second is not (reverse negative implication)
  * `Conflicts: (myPkg-driverA unless driverB)`
 * `unless else` - same as above but requires the third operand to be fulfilled if the second is
  * `Conflicts: (myPkg-backend-SDL1 unless myPkg-backend-SDL2 else SDL2)`

`if` 运算符不能与 `or` 在同一上下文中使用， `unless` 运算符不能在与 `and` 相同的上下文中使用。

## Nesting 

操作数本身可以是布尔表达式。它们还需要用括号括起来。 `and` 和 `or` 运算符可以链接在一起，仅用一组环绕括号重复相同的运算符。

Examples:

`Requires: (pkgA or pkgB or pkgC)`

`Requires: (pkgA or (pkgB and pkgC))`

`Supplements: (foo and (lang-support-cz or lang-support-all))`

`Requires: ((pkgA with capB) or (pkgB without capA))`

`Supplements: ((driverA and driverA-tools) unless driverB)`

`Recommends: ((myPkg-langCZ and (font1-langCZ or font2-langCZ)) if langsupportCZ)`

## Semantics

依赖项的语义保持不变，而是检查一个匹配项。检查所有名称，然后通过布尔运算符聚合存在匹配项的布尔值。如果冲突不能阻止安装，则结果必须为False，否则必须为True。

请注意，`Provides`不是依赖项，并且不能包含布尔表达式“”。

### Incompatible nesting of operators

注意，`if`运算符也返回布尔值。在大多数情况下，这接近于直觉读数。例如：

`Requires: (pkgA if pkgB)` 

is True (and everything is OK) if pkgB is not installed. But if the same term is used where the "default" is False things become complicated:


`Conflicts: (pkgA if pkgB)` 

is a Conflict unless pkgB is installed and pkgA is not. So one might rather want to use

`Conflicts: (pkgA and pkgB)`

 in this case. The same is true if the `if` operator is nested in `or` terms.

`Requires: ((pkgA if pkgB) or pkgC or pkg)` 

As the `if` term is True if pkgB is not installed this also makes the whole term True. If pkgA only helps if pkgB is installed you should use `and` instead:

`Requires: ((pkgA and pkgB) or pkgC or pkg)` 

To avoid this confusion rpm refuses nesting `if` in such `or` like contexts (including `Conflicts:`) and `unless` in `and` like contexts.
