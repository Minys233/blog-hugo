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

#### 字符串 (String)

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

字符串对象的操作类似列表. 通过 `.length` 获得长度, 通过方括号索引获取对应字符. 但是修改 `.length` 虽不会报错, 但是并不能更改字符串长度, 属性值也不会改变. **字符串是不可变的, 对索引赋值不会有任何效果.**

```javascript
var s = "Hellw!"; // mis-spelled
s[4] = 'o'; // no effect
```

个人认为, 字符串操作的丰富与否直接决定了一个语言是否对新手友好, 因为如果打log都很不是很容易, 那么学习曲线就会很陡峭. 因此, 易于学习的Javascript字符串对象有不少成员函数来操作字符串:

- `s.toUpperCase()` : 全部大写, 仅对有大小写关系的字符有效.
- `s.toLowerCase()` : 全部小写, 仅对有大小写关系的字符有效.
- `s.indexOf(str)` : 返回指定 `str` 字符串出现的位置, 没找到返回-1.
- `s.substring(start, end)` : 返回 `[start, end)` 区间的子字符串, 如 `end` 未指定, 默认到字符串结尾.

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

**这是Javascript的一个设计缺陷, 尽量避免使用 `==`**. 另外, `NaN` 和任何数包括他自己都不想等, 即 `NaN === NaN` 将得到 `false`, 符合数值运算时约定俗称的规矩. 实际上, `===` 当且仅当两边的对象指向相同的数据, 如 `new Number(0) === new Number(0);` 为 `false`.

#### `null` 与 `undefined`

`null` 表示空 (void) 之意, 类似C中的 `NULL`, Python中的 `None`. `undefined` 表示未定义. 大部分情况下,都应该用 `null`, 仅在判断函数传参的时候使用 `undefined`.

#### 数组 (Array)

数组是一个有序的元素序列, 可以包含任意类型元素, 一般使用以下两种方式定义. 使用整数索引可以访问元素的"引用". 不同于Python, Javascript并不支持能通过方括号索引进行负整数索引与数组切片操作.

```javascript
var arr = [1, 2, 3.14, 'hello', null, true];
var arr1 = new Array(1, 2, 3.14, 'hello', null, true);
arr[0]; // 1
arr[5]; // true
arr[6]; // undefined
arr[-1]; // undefined
arr[0] = 2 // change to [2, 2, 3.14, ...]
```

访问数组的 `.length` 属性可以得到列表长度. 注意: **更改 `.length` 属性会使得数组丢失元素或增加 `undefined` 元素**. 如果你在浏览器中试过, 你会发现似乎显示的是 `empty`. 但其实这是`undefined`. 另外, 除了上面一点外, 不同于字符串的还有, 当索引值越界后, 数组会自动变长,并在中间添加 `undefined`.

![empty和undefined](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-09-13-163424.png "看似 `empty` 实际 `undefined`")

和字符串类似, 字符串也支持一系列成员函数如下所示. 

- `.indexOf(Object)` : 搜索一个指定元素 `Object` 的下标, 没有找到时返回-1.
- `Array.slice(start, end)` : 子数组操作. 对应的是字符串的 `substring` 函数, 截取数组的一段元素. 如果不传递参数, 则会截取所有元素, 通常用于复制一个数组. 注意, 这里的复制规则比较复杂, 可以先这么记忆, 但实际上只会真正复制字符串和数字和布尔值, 详见下图, deep表示复制内容, shallow表示只复制一个引用.
- `push(*arg)` : 可传递任意多参数, 所传递的参数将按照顺序向末尾添加新元素. 该函数返回目标数组的新长度.
- `pop()` : 把最后一个元素删掉, 返回删除的元素.
- `unshift(*arg)` : 类似 `push`, 向头部添加元素.
- `shift()` : 类似 `pop`, 删掉第一个元素, 返回删除的元素.
- `sort()` : 按照递增字典序排序, 也可以传递一个比较函数, 暂且不提.
- `reverse()` : 翻转数组顺序.
- `splice(start, num, *arg)` : 删除+插入. 从 `start` 位置自己开始, 删除 `num` 个元素, 并在这里插入 `arg`. 该函数返回删除的元素.
- `concat(*arg)` : 当前的 `Array` 和另一个 `Array` 连接起来, 并返回一个新的 `Array`. **注意, 该函数并没有修改当前 `Array`, 而是返回了一个新的 `Array`. 该函数可以接受任意多参数, 如果参数包含数组, 也会将数组拆开加入**.
- `join(str)` : 将每个元素间用 `str` 连接起来, 然后返回连接后的字符串.

![JS函数处理数组的方式](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-09-15-164745.jpg "JS函数处理数组的方式")

```javascript
var arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'G'];
arr.indexOf('G'); // 6, the first appearance
arr.slice(1,3); // ["B", "C"]
arr.slice(3); // from arr[3] to end, ["D", "E", "F", "G", "G"]
arr.slice(); // make a copy, ["A", "B", "C", "D", "E", "F", "G", "G"]
arr.slice() === arr; // false, not the same object

var arr = ['Microsoft', 'Apple', 'Yahoo', 'AOL', 'Excite', 'Oracle'];
// 从索引2开始删除3个元素,然后再添加两个元素:
arr.splice(2, 3, 'Google', 'Facebook'); // 返回删除的元素 ['Yahoo', 'AOL', 'Excite']
arr; // ['Microsoft', 'Apple', 'Google', 'Facebook', 'Oracle']
// 只删除,不添加:
arr.splice(2, 2); // ['Google', 'Facebook']
arr; // ['Microsoft', 'Apple', 'Oracle']
// 只添加,不删除:
arr.splice(2, 0, 'Google', 'Facebook'); // 返回[],因为没有删除任何元素
arr; // ['Microsoft', 'Apple', 'Google', 'Facebook', 'Oracle']

var arr = ['A', 'B', 'C'];
var added = arr.concat([1, 2, 3]);
added; // ['A', 'B', 'C', 1, 2, 3]
arr; // ['A', 'B', 'C']
var arr = ['A', 'B', 'C'];
arr.concat(1, 2, [3, 4]); // ['A', 'B', 'C', 1, 2, 3, 4]

var arr = ['A', 'B', 'C', 1, 2, 3];
arr.join('-'); // 'A-B-C-1-2-3'
```

#### 对象

Javascript的对象像C++ STL中的 `unordered_map` 或 Python中的 `dict`, 是由一组key-value对组成的无序集合,通过索引键来访问值. 键值对末尾除了最后一个外必须加逗号, 如果最后一个也加了逗号, 低版本浏览器有可能会报错. 

```javascript
var person = {
    name: 'Bob',
    age: 20,
    "school-name": 'Tsinghua',
    tags: ['js', 'web', 'mobile'],
    city: 'Beijing',
    hasCar: true,
    zipcode: null
};
```

但不同的是, javascript中对象的键都是字符串类型, 值 (属性) 可以是任意类型. 如果属性名包含特殊字符, 则属性名要用单引号或双引号括起来. 要访问某个属性的值, 需通过 `.` 来完成, 如果属性名包括特殊字符则只能通过方括号来访问. 

```javascript
person.name; // 'Bob'
person.zipcode; // null
person['name']; // 'Bob'
person['school-name']; // 'Tsinghua'
```

因为Javascript是动态类型语言, 因此可以动态地添加或删除对象的属性. 但是注意, 如果访问到一个不存在的属性, 将会返回 `undefined`. 检测一个对象是否拥有某个属性可以使用 `in` 操作符, 但 `in` 操作符同样也会对继承而来的属性进行判断, 即有可能这个属性是继承而来的而非它自身的, 如要判断是否是其自身的属性, 需要用 `hasOwnProperty()`.

```javascript
var xiaoming = {
    name: '小明'
};
xiaoming.age; // undefined
xiaoming.age = 18; // 新增一个age属性
xiaoming.age; // 18
delete xiaoming.age; // 删除age属性
xiaoming.age; // undefined
delete xiaoming['name']; // 删除name属性
xiaoming.name; // undefined
delete xiaoming.school; // 删除一个不存在的school属性也不会报错
'name' in xiaoming; // true
'school' in xiaoming; // false
'toString' in xiaoming; // true
xiaoming.hasOwnProperty('toString'); // false
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

## 阶段总结

这一块讲了基本的javascript的内置类型和基本的语法, 记忆的东西偏多, 基本没有需要重点理解的地方. 可以看到内容也不是很多, 因此说学习javascript学习曲线很平缓. 但是, 易学并不代表易写, 也不表示轻松就能写好, 还需要多多努力.