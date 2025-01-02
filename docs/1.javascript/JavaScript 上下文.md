---
title: JavaScript 上下文
createTime: 2025/01/02 09:16:38
permalink: /article/ksjbv9cr/
cover: {url: '/simin-xxm/images/上下文.png',compact: true, layout: 'odd-left', ratio: '2:1'}
---

## 什么是上下文？

在 JavaScript 中，上下文（Context）是指代码在运行时的执行环境，它决定了 `this` 的值是什么。上下文是动态的，可以随着函数的调用方式改变。

很多开发者经常弄混作用域和上下文，似乎两者是一个概念。但并非如此。

作用域是[JavaScript 作用域详解](./JavaScript%20作用域详解.md)所解释的，而上下文通常涉及到你代码某些特殊部分中的this值。作用域指的是变量的可见性，而上下文指的是在相同的作用域中的this的值。我们当然也可以使用函数方法改变上下文，在全局作用域中，上下文总是 Window 对象。

1. 上下文（Context） 决定了函数调用时 `this` 的值。

2. 作用域（Scope） 决定了变量的可见性和访问权限。

## 上下文与 `this`

`this` 是上下文的核心部分，它指向当前代码正在执行的对象。上下文的主要作用是提供一个访问对象属性的途径。

### 1. 全局上下文

在全局作用域中，`this` 指向全局对象。

##### 浏览器环境：

```js whitespace
console.log(this); // 输出：Window
```

##### Node.js 环境：

```js whitespace
console.log(this); // 输出：{} （当前模块）
```

### 2. 函数上下文

在函数内部，`this` 的值取决于函数的调用方式：

- 如果函数被直接调用，`this` 指向全局对象（非严格模式）或 `undefined`（严格模式）。

```js whitespace
unction globalFunc() {
    console.log(this);
}

// 非严格模式
globalFunc(); // 输出：Window（浏览器）或 global（Node.js）

// 严格模式
'use strict';
globalFunc(); // 输出：undefined
```

- 如果函数是作为对象的方法调用，`this` 指向调用该函数的对象。

```js whitespace
const obj = {
    name: "Object",
    printThis: function () {
        console.log(this);
    }
};

obj.printThis(); // 输出：obj
```

- 如果函数被构造器调用（new 操作符），`this` 指向新创建的对象。

```js whitespace
function Constructor() {
    this.name = "New Object";
}

const instance = new Constructor();
console.log(instance.name); // 输出：New Object
```

### 3. 箭头函数上下文

箭头函数没有自己的 `this`，它会继承定义时的上下文中的 `this`。

```js whitespace
const obj = {
    name: "Object",
    printThis: function () {
        const arrowFunc = () => {
            console.log(this);
        };
        arrowFunc();
    }
};

obj.printThis(); // 输出：obj
```

## 上下文的切换

上下文切换主要指的是执行环境（Context）的切换，通过以下方式可以切换函数的上下文：

### 1. 使用 `call` 和 `apply`

- `call`：接受多个参数，第一个参数是上下文，后续是调用函数的参数。

- `apply`：接受两个参数，第一个是上下文，第二个是参数数组。

```js whitespace
function printName(greeting) {
    console.log(`${greeting}, I am ${this.name}`);
}

const user = { name: "Alice" };

printName.call(user, "Hello"); // 输出：Hello, I am Alice
printName.apply(user, ["Hi"]); // 输出：Hi, I am Alice
```

### 2. 使用 bind

`bind` 创建一个新的函数，并绑定指定的上下文。

```js whitespace
const boundFunc = printName.bind(user);
boundFunc("Hey"); // 输出：Hey, I am Alice
```

### 3. 显式绑定问题：丢失上下文
当函数传递作为回调时，上下文可能丢失。

```js whitespace
const obj = {
    name: "Object",
    printThis: function () {
        console.log(this.name);
    }
};

setTimeout(obj.printThis, 1000); // 输出：undefined（`this` 丢失）
```

解决方法：

- 使用箭头函数：

```js whitespace
setTimeout(() => obj.printThis(), 1000); // 输出：Object
```

- 使用 bind：

```js whitespace
setTimeout(obj.printThis.bind(obj), 1000); // 输出：Object
```

## 上下文与闭包的关系

闭包是指一个函数可以访问其定义时所在的作用域，即使它在另一个作用域中执行。而上下文的 `this` 与闭包无关。


```js whitespace
function outer() {
    const outerVar = "Outer";

    return function inner() {
        console.log(outerVar); // 闭包：访问外部变量
        console.log(this); // 上下文：取决于调用方式
    };
}

const innerFunc = outer();
innerFunc(); // 输出：Outer 和全局对象（非严格模式）
```

## 上下文的常见用途

1. 在事件处理器中使用：
   - DOM 事件处理器的 `this` 默认指向绑定事件的 DOM 元素。

```js whitespace
const button = document.querySelector("button");
button.addEventListener("click", function () {
    console.log(this); // 输出：button 元素
});
```

2. 在类和构造函数中：
   - 使用 `this` 访问实例属性。

```js whitespace
class User {
    constructor(name) {
        this.name = name;
    }

    sayHello() {
        console.log(`Hello, I am ${this.name}`);
    }
}

const user = new User("Alice");
user.sayHello(); // 输出：Hello, I am Alice
```

## 总结

1. **上下文与作用域不同**：作用域决定变量的可见性，而上下文决定 `this` 的值。
2. **上下文与调用方式相关**：函数调用方式直接影响 `this` 的指向。
3. **上下文切换工具**：`call`、`apply` 和 `bind`。
4. **避免丢失上下文**：使用箭头函数或显式绑定。