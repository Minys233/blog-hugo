---
title: "Javascript学习笔记 (1)"
summary: "Javascript学习笔记"
date: 2020-09-13T00:15:18+08:00
draft: false
katex: true
tags:
- Javascript
categories: 
- 学习笔记
---

## 写在前面

为什么要学习JS呢? 对我来说, 日常科研工作中有很多场景都需要和互联网, 尤其是前端打交道. 比如:文献制图, 数据可视化, 训练监控, 维护博客等等. 在这些过程中有很多端到端的工具可以使用, 但也仅仅是停留在"使用". 有时出现错误或新增内容时, 总要写点新东西或者整合一些JS库. 每到这时, 总是会触及到我的知识盲区, 即"明明知道用JS可以轻松解决但就是不会". 列举几个让我十分沮丧的时刻: 

- 本科时每学期评教, 要选中页面中所有特定的单选框
- 咪咕音乐PC端仅提供网页应用, 或许可以使用Electron打包成APP
- Clash科学上网, 可以用用HTML+JS可以包装官方简陋的RESTful API
- Gnome更新后, 某些插件不能用了但无法debug

因此, 我决定在闲暇之时, 抽出时间系统地学一下JS. 但是学归学, 为什么要开这个系列坑呢? 因为之前我已经学过好几次JS了! 每一次要么是疏于练习前学后忘, 要么是没有紧迫需求无法坚持. 我希望这个博问可以督促我每天学一点, 坚持下去. 

这个系列突出实用, 即默认读者应当已经掌握了一定的编程/互联网基础, 太过基础的和概念并不会占用太多篇幅. 本教程参考[廖雪峰的教程](https://www.liaoxuefeng.com/wiki/1022910821149312)编写, 并尽可能短小精悍. 

## Javascript历史简述

微软等几个大公司在1997年联合制定了**ECMAScript**标准, Javascript便不断跟进ES标准开发并实现. 如今现代浏览器所支持地最新Javascript标准是于2015年6月发布的ES6版本. 这个ES也正是前述ECMAScript的缩写. 其他的历史不了解也罢, 但是ES标准最好还是了解一下, 因为各种各样的浏览器在执行Javascript时所遵循的标准并不相同, 例如远古的IE6和最新版的Chrome便不同, 前者并不支持ES6标准的Javascript代码, 而且, 即使时最新版的不同浏览器, 如Safari与Firefox, 也会在执行Javascript脚本时有不一样的行为. 

## 基本语法和基本类型

### 语句和注释

一个编程语言开始上手首先就要关注它的语法, 基本类型, 这里也不例外. Javascript的语法类似C++或Java, 但却是一个动态类型语言. 其基本的运行单元是语句. 一个语句要以 `;` 结尾, 一个语句块要处在 `{...}` 中. 但由于某些原因, Javascript并不强制加 `;` , 浏览器中JS引擎会自动给没有分号的语句加上分号. 但是有时却会导致预期之外的效果. 因此, **每个语句结尾手动添加分号是良好的代码习惯**. 

语句样例:

```javascript
var a = 1;
var $b = 2;
'Hello Javascript!';
```

Javascript中的注释沿用了C风格注释, 即 `//` 表示单行注释, `\* ... *\`可注释多行. 

### 基本类型

#### 数字 (Number)

Javascript不区分数字类型, 整数, 浮点统一表示. 数字类型中有两个特殊值`NaN`和`Infinity`. 其意义见如下注释:

```javascript
123 // 整数
1.234 // 浮点数
1.234e5 // 123400的科学计数法
0xffff00 // 十六进制数, 同对应十进制数值
NaN
/* 
Not a Number, 计算失败时出现NaN. 
如Math.sqrt(-1), parseInt("f*ck"), 'a' + 1, 0/0. 
详细来说, 无穷大除以无穷大, 给任意负数做开方运算, 
或者算数运算符与不是数字或无法转换为数字的操作数一起使用时都将返回NaN. 
*/
Infinity
/*
无穷, 分为正无穷 (Infinity或+Infinity) 和负无穷 (-Infinity). 
它们都比任何数大/小. 对有限数除以0 (区分0/0) 或者超出Number.MAX_VALUE可以
得到Infinity, 另外, Infinity参与的四则运算都会得到±Infinity. 
但是, 注意: parseInt("Infinity", 10) => NaN,  Math库中某些函数
也会返回Infinity, 如:
const empty=[]; 
Math.max(...empty); ==> Infinity
Math.min(...empty); ==> -Infinity
*/
```

#### 字符串

字符串使用 `''` 或 `""` 包围的任意文本, 如 `abc` , `"xyz"` .  字符转义与其他语言完全一致, 如 `'I\'m Yaosen!\n'`. 另外,也可以使用十六进制数 `'\x##'` 表示字符串中的字符, 如 `'\x41bc' === 'Abc'`. 也可以用 `'\u####'` 表示字符串中的一个Unicode字符, 如 `'\u4e2d\u6587' === '中文'`. 

如果字符串很长, 写换行符会很烦, 可以使用ES6新标准中的多行字符串表示方法, 用`` `...` `` 括住即可. 同时, 反引号字符串也可以当作模板字符串将变量嵌入至字符串中, 而不用写很多+号.

```javascript
var name = 'Yaosen';
var age = 24;
var message1 = 'Hello, I\'m ' + name + ", I'm " + age + " years old."
// messagge1 === "Hello, I'm Yaosen, I'm 24 years old."
var message2 = `Hello, I'm ${name}, I'm ${age} years old.`
// messagge2 === "Hello, I'm Yaosen, I'm 24 years old."
var message3 = `Hello, I'm ${name},
I'm ${age} years old.`
// message3 === "Hello, I'm Yaosen,\nI'm 24 years old."
```



#### 布尔值

同C/C++, 有 `true` , `false` 两种值. 对应的布尔运算如下:

```javascript
true && true // 逻辑与
true || false // 逻辑或
!false // 逻辑非
```

#### 比较运算符

包含 `>`, `<`, `>=`, `<=`, `==`, `===`. 前面四种略去不说, 字如其意. 最后两种比较相等的运算符具有不同的行为, 要特别注意. 

- `==` : 比较时自动转换类型, 可得到 `false == 0` 为 `true` 这样的神奇情况
- `===` : 比较时不会转换类型,如果数据类型不一致直接 `false`, 类型相同再比较

**这是Javascript的一个设计缺陷, 尽量避免使用 `==`**. 另外, `NaN` 和任何数包括他自己都不想等, 即 `NaN === NaN` 将得到 `false`, 符合数值运算时约定俗称的规矩.

#### `null` 与 `undefined`

`null` 表示空 (void) 之意, 类似C中的 `NULL`, Python中的 `None`. `undefined` 表示未定义. 大部分情况下,都应该用 `null`, 仅在判断函数传参的时候使用 `undefined`.

#### 数组

数组是一个有序的元素序列, 可以包含任意类型元素. 使用整数索引可以访问元素的"引用". 不同于Python, Javascript并不支持能通过方括号索引进行负整数索引与数组切片操作.

```javascript
var arr = [1, 2, 3.14, 'hello', null, true];
arr[0]; // 1
arr[5]; // true
arr[6]; // undefined
arr[-1]; // undefined
arr[0] = 2 // change to [2, 2, 3.14, ...]
```

#### 对象

Javascript的对象像C++ STL中的 `unordered_map` 或 Python中的 `dict`, 是由一组key-value对组成的无序集合,通过索引键来访问值.

```javascript
var person = {
    name: 'Bob',
    age: 20,
    tags: ['js', 'web', 'mobile'],
    city: 'Beijing',
    hasCar: true,
    zipcode: null
};
```

但不同的是, javascript中对象的键都是字符串类型, 值 (属性) 可以是任意类型. 要访问某个属性的值, 需通过 `.` 来完成.

```javascript
person.name; // 'Bob'
person.zipcode; // null
```

#### 变量

其实以上的代码示例中已经用到了很多变量. Javascript中的变量名可以由**字母, 数字, `$`, `_`**组合而成, 但不能用数字开头. 当然, 变量名也不能是语言自身的关键字. 声明并定义一个变量的**推荐**方式为 `var name = ...;` 形式. 

其实, javascript并不要求变量使用 `var` 声明. 但是, 如果一个变量没有使用 `var`, 那么他将变成一个全局变量 (如 `b` ). 这样会使得同一个页面引入的不同JS文件中的变量相互冲突, 造成不可预知的后果. 因此, 牢记**声明变量的时候应当使用 `var`**. 

```javascript
var a = 1.23;
a = 'string';
b = 'I\'m conflict with other bs'
```

这个问题实际上是javascript的一个设计缺陷, ECMA在后续规范中推出了strict模式, 在该模式下运行的代码强制通过 `var` 声明变量, 不加 `var` 的变量声明将直接抛出错误. 启用strict模式的方法是在脚本中首行写入:

```javascript
'use strict';
```

支持strict模式的浏览器将开启strict模式, 而不支持该模式的浏览器将会把这一行当作一个没有什么意义的普通语句来执行. 为了避免因为粗心大意在声明变量时忽略 `var`, **任何脚本都应该开启strict模式**.

