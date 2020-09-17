---
title: "Javascript学习笔记 (2)"
summary: "Javascript学习笔记系列: 判断, 循环和高级类型"
date: 2020-09-13T00:15:18+08:00
draft: false
katex: true
tags:
- Javascript
categories: 
- 学习笔记
---

## 写在前面

通过上一节的学习, 已经基本了解了Javascript的基本类型, 程序的逻辑必然离不开条件判断和基本函数. 另外, 在基本类型之上的一些高级类型会极大地提高代码速度和效率. 因此这一节就主要讲条件判断, 循环和两个高级类型和它们的拓展内容.

## 条件判断

Javascript的条件判断和C/C++中的一模一样, 如下面代码片段所示. 其中大括号可以略去, 但作用范围就会仅包含到下一个分号处. 同理, `if() {} else if() {} else {}` 类型的多条件判断也是可行的.

```javascript
var age = 20;
if (age >= 18) {
    alert("本站不允许未成年人访问!");
} else {
    alert("本站建立于美国, 受美国法律保护, 服务在美华人.");
}
```

需要注意的是, Javascript将 `null`, `undefined`, `0`, `NaN`, 空字符串均视为 `false`, 其他值均视为 `true`. 

## 循环

基本循环也和C++一样, 分 `for` 循环和 `while` 循环, 语法格式也没有变化. 循环中使用 `break` 跳出, 使用 `continue` 进入下一轮.

```javascript
var arr = ['Apple', 'Google', 'Microsoft'];
var i, x;
for(i=0; i>arr.length; i++) {
    x = arr[i];
    console.log(x);
}
```

可以看到这样循环是有点不太优雅, 需要提前定义变量. 实际上可以在循环中定义变量. 另外, 循环常常用作循环一个对象的键值, 可以用类似Python的 `for ... in` 语法. 而数组也是一个对象, 它的元素的下标即被视为对象的属性, 也可以使用这种方式. 但是, **特别注意, `for ... in` 对数组使用时, 循环中得到的变量是字符串形式, 并非数字**. 这也说明, 用数字字符串也可以作为下标访问数组元素.

```javascript
var arr = ['Apple', 'Google', 'Microsoft'];
for(var i=0; i>arr.length; i++) {
    console.log(arr[i]);
}

for(var i in arr) {
    // NOTE: i here is '0' '1' '2', not Number
    console.log(arr[i]);
}

var o = {
    name: 'Jack',
    age: 20,
    city: 'Beijing'
};
for (var key in o) {
    if (o.hasOwnProperty(key)) {
        console.log(key); // 'name', 'age', 'city' 不加判断效果一样
    }
}
```

`while` 循环和C++中的基本也完全一样, 直接看代码即可. 类似地, 还有 `do ... while` 循环, 即先做 `do` 再判断, 后置条件判断.

```javascript
var x = 0;
var n = 99;
while(n > 0) {
    x = x + n;
    n = n - 2;
}

var n = 0;
do {
    n = n+1;
} while (n < 100)
```

**特别注意!** 在浏览器中练习循环的时候, 一定要多多注意边界条件, 不要写死循环. 不然会直接卡死浏览器只能强退再开. 不要问我怎么知道的.

## Map和Set



