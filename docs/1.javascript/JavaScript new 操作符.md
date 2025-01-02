---
title: JavaScript new 操作符
createTime: 2025/01/02 15:41:44
permalink: /article/8fbcq28x/
---

::: tip 提示
需要先阅读 

[JavaScript 原型](./JavaScript%20原型.md)

[JavaScript 作用域](./JavaScript%20作用域.md)

[JavaScript 上下文](./JavaScript%20上下文.md) 
:::

## 什么是 new 操作符？

`new` 是 JavaScript 中的一个关键字，用于创建对象的实例。它的主要作用是调用构造函数，并返回一个由构造函数定义的对象实例。`new` 是面向对象编程中实现继承和实例化的重要工具。
<!-- more -->
## new 的作用

`new` 操作符在调用构造函数时会完成以下几步：

1. **创建一个空对象**：创建一个新的对象，并将其内部的 `[[Prototype]]` 指向构造函数的 `prototype` 属性。

2. **绑定** `this`：将构造函数内部的 `this` 绑定到新创建的对象上，使构造函数能够使用 `this` 来定义对象的属性和方法

3. **执行构造函数**：调用构造函数代码，并将结果赋值给新创建的对象。

4. **返回对象**：如果构造函数显式返回了一个对象，则返回该对象；否则返回步骤 1 中创建的新对象。

## new 的工作原理

```js
function customNew(Constructor, ...args) {
    // 1. 创建一个空对象，并将其原型链接到构造函数的 prototype
    const obj = Object.create(Constructor.prototype);

    // 2. 调用构造函数，将 obj 作为其上下文 (this)
    const result = Constructor.apply(obj, args);

    // 3. 如果构造函数返回一个对象，则返回该对象；否则返回新创建的 obj
    return typeof result === 'object' && result !== null ? result : obj;
}
```

## 构造函数与 new

构造函数是一个普通的函数，但与普通函数相比，它的作用是用于创建对象实例。

### 构造函数的特性

1. 构造函数名称的首字母通常大写（不是强制要求，但这是社区约定）。

2. 构造函数应与 `new` 一起调用。

3. 构造函数内部使用 `this` 引用新创建的对象。

### 简单构造函数

```js
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.greet = function () {
      console.log(`Hello, my name is ${this.name} and I am ${this.age} years old.`);
  };
}

const alice = new Person('Simin', 25);
alice.greet(); // 输出：Hello, my name is Simin and I am 25 years old.
```

在这个例子中：

1. `Person` 是构造函数。

2. `alice` 是通过 `new Person` 创建的实例。

3. 构造函数定义了 `name`、`age` 属性和 `greet` 方法。

### 与原型结合

通过构造函数的 `prototype` 属性，我们可以为所有实例共享方法，从而节省内存。

```js
function Car(make, model) {
  this.make = make;
  this.model = model;
}

Car.prototype.drive = function () {
  console.log(`${this.make} ${this.model} is driving.`);
};

const tesla = new Car('Tesla', 'Model S');
const bmw = new Car('BMW', 'X5');

tesla.drive(); // 输出：Tesla Model S is driving.
bmw.drive();   // 输出：BMW X5 is driving.
```

在这个例子中：

1. `Car.prototype.drive` 是所有 `Car` 实例共享的方法。

2. `tesla` 和 `bmw` 都继承了 `drive` 方法。

## new 的特殊情况

### 显式返回值

如果构造函数显式返回一个对象，`new` 会忽略步骤 1 创建的新对象，直接返回该对象。

```js
function CustomObject() {
    this.name = 'Default';
    return { name: 'Explicit' };
}

const obj = new CustomObject();
console.log(obj.name); // 输出：Explicit
```

### 返回非对象

如果构造函数返回一个非对象类型的值（例如字符串、数字、布尔值等），new 会忽略返回值，并返回新创建的对象。

```js
function CustomObject() {
    this.name = 'Default';
    return 'Ignored';
}

const obj = new CustomObject();
console.log(obj.name); // 输出：Default
```

## new 与普通函数的区别

```js
function Example() {
    this.value = 42;
}

const instanceWithNew = new Example();
console.log(instanceWithNew.value); // 输出：42

const instanceWithoutNew = Example();
console.log(instanceWithoutNew.value); // 报错：Cannot read property 'value' of undefined
```

区别在于：

- 使用 new 时，this 指向新创建的对象。

- 不使用 new 时，this 指向全局对象（非严格模式）或 undefined（严格模式）。

## 自定义实现 new

通过实现一个自定义的 new 函数，可以更好地理解其工作机制。

```js
function customNew(Constructor, ...args) {
    // 创建一个空对象
    const obj = Object.create(Constructor.prototype);

    // 调用构造函数并绑定 `this`
    const result = Constructor.apply(obj, args);

    // 返回对象
    return result instanceof Object ? result : obj;
}

function Example(name) {
    this.name = name;
}

const instance = customNew(Example, 'Simin');
console.log(instance.name); // 输出：Simin
```

## 为什么必须使用 new 调用构造函数？

`new` 确保 `this` 指向新创建的对象，并正确初始化原型链。如果直接调用构造函数，`this` 的绑定可能不符合预期