---
title: JavaScript 作用域详解
tags:
  - JavaScript
createTime: 2024/12/31 15:29:24
permalink: /article/9xi55js6/
cover: {url: '/simin-xxm/images/作用域.png'}
---

## 什么是作用域？

作用域是指程序中定义变量的区域，它决定了变量的可访问性。简单来说，作用域定义了代码中哪些部分可以访问特定变量。
<!-- more -->
在 JavaScript 中，作用域是通过函数和代码块来划分的。理解作用域有助于编写高效、可维护的代码。

## 作用域的类型

JavaScript 中主要有以下几种作用域

1. **全局作用域**

2. **函数作用域**

3. **块级作用域**

4. **动态作用域（不是 JavaScript 的特性，仅作对比说明）**

## 1. 全局作用域

**定义：** 全局作用域是最外层的作用域，任何在全局作用域中定义的变量都可以在代码的任何地方访问。

**特点**

- 全局变量的生命周期与页面的生命周期一致。

- 过多的全局变量会污染命名空间，可能导致命名冲突。

**示例：**

```js whitespace
var globalVar = "我是全局变量";

function printGlobal() {
    console.log(globalVar); // 可以访问全局变量
}

printGlobal(); // 输出：我是全局变量
```

**注意：**

如果在函数中未显式声明变量，它会被默认添加到全局作用域中（严格模式下会报错）。

```js whitespace
function createGlobalVar() {  
    implicitGlobal = "我也是全局变量"; // 没有用 var/let/const
}

createGlobalVar();
console.log(implicitGlobal); // 输出：我也是全局变量
```

## 2. 函数作用域

**定义：** 函数作用域指的是变量在函数内部定义后，只能在函数内部访问。

**特点**

- 函数作用域由 <Badge type="tip" text="function" /> 定义。
- 函数作用域是独立的，不同函数之间的变量互不影响。

**示例：**

```js whitespace
function localScope() {  
    var localVar = "我是全局变量";
    console.log(localVar); // 可以访问局部变量
}

localScope(); // 输出：我是全局变量

console.log(localVar); // 报错：localVar is not defined
```

**闭包中的函数作用域**

函数作用域是闭包的基础。闭包允许一个函数访问另一个函数的作用域，即使外部函数已经返回。

```js whitespace
function outer() {
    var outerVar = "我来自外面";  

    return function inner() {
        console.log(outerVar); // 可以访问外部函数的变量
    };
}

const innerFunc = outer();
innerFunc(); // 输出：我来自外面
```

## 3. 块级作用域

**定义：** 块级作用域是由 {} 定义的作用域，let 和 const 声明的变量具有块级作用域。

**特点**

- 只能在代码块内部访问。

- 由 let 和 const 声明的变量不会被提升。

- 块级作用域避免了变量污染。

**示例**

```js whitespace
{
    let blockVar = "我是块范围的";
    console.log(blockVar); // 输出：我是块范围的
}

console.log(blockVar); // 报错：blockVar is not defined  
```

**与 <Badge type="tip" text="var" /> 的区别**

用 <Badge type="tip" text="var" /> 声明的变量没有块级作用域

```js whitespace
{
    var noBlockScope = "输出：我是块范围的";
}

console.log(noBlockScope); // 输出：我是块范围的
```

## 4. 动态作用域（非 JavaScript 特性）

动态作用域不是 JavaScript 的特性，但与静态作用域对比有助于理解。

**静态作用域（JavaScript 使用）**： 在定义时决定变量的作用域。

**动态作用域：** 在运行时决定变量的作用域。

**对比示例：**

静态作用域：

```js whitespace
function foo() {
    console.log(a); // 输出：10
}

function bar() {
    var a = 20;
    foo();
}

var a = 10;
bar();
```

如果 JavaScript 使用动态作用域，foo 的输出会是 20，因为它会在运行时查找调用时的上下文。

## 作用域链

作用域链是指在查找变量时，由内向外逐层查找的过程。

**查找规则：**

1. 先从当前作用域查找变量。

2. 如果未找到，向父级作用域查找。

3. 直到全局作用域。

4. 如果仍未找到，报错。

```js whitespace

var globalVar = "全局";

function outerFunc() {
    var outerVar = "外部";

    function innerFunc() {
        var innerVar = "内部";
        console.log(innerVar); // 内部
        console.log(outerVar); // 外部
        console.log(globalVar); // 全局
    }

    innerFunc();
}

outerFunc();
```

## 变量提升

变量提升是指 JavaScript 在解析代码时，将变量和函数声明移动到作用域的顶部。

**规则：**

- 使用 <Badge type="tip" text="var" /> 声明的变量会被提升，但不会初始化。

- 使用 <Badge type="tip" text="let" /> 和 <Badge type="tip" text="const" /> 的变量不会被提升。

**示例：**

```js whitespace
console.log(a); // 输出：undefined
var a = 10;
```

等同于：

```js whitespace
var a;
console.log(a); // 输出：undefined
a = 10;
```

而 <Badge type="tip" text="let" /> 和 <Badge type="tip" text="const" /> 不会提升：

```js whitespace
console.log(b); // 报错：Cannot access 'b' before initialization
let b = 20;
```

## 严格模式下的作用域

在严格模式下，JavaScript 的作用域行为更加严格：

- 禁止隐式声明全局变量。

- 函数内的 this 不再指向全局对象，而是 undefined。

**启用严格模式：**

```js whitespace
'use strict';

function test() {
    implicitGlobal = 10; // 报错：implicitGlobal is not defined
}

test();
```

## 总结

1. JavaScript 有全局作用域、函数作用域和块级作用域。

2. 变量查找遵循作用域链，由内向外逐级查找。

3. 使用 let 和 const 避免全局变量污染和变量提升问题。

4. 理解闭包和作用域链是掌握高级 JavaScript 的基础。

深入理解作用域不仅能写出高效的代码，还能避免意外的变量覆盖和内存泄漏等问题。