---
title: JavaScript 原型
createTime: 2025/01/02 10:40:02
permalink: /article/viqz9tdb/
cover: {url: '/simin-xxm/images/原型.png'}
tags:
  - JavaScript
---

## 什么是 Prototype（原型）？

在 JavaScript 中，每个对象都有一个内部链接到另一个对象的属性，这个属性被称为 原型（Prototype）。原型是实现继承的基础，允许对象通过原型链访问其他对象的属性和方法。原型链是 JavaScript 对象继承的核心机制。
<!-- more -->

## Prototype Chain（原型链）

### 什么是原型链？

**原型链** 是指通过对象的 `[[Prototype]]` 属性（在现代 JavaScript 中可以通过 `Object.getPrototypeOf` 或 `__proto__` 访问）将多个对象连接起来形成的链式结构。通过原型链，一个对象可以访问另一个对象的属性或方法，哪怕这些属性或方法并不存在于当前对象中。

### 工作原理

1. 当你访问一个对象的属性时，JavaScript 引擎会先在该对象自身查找属性。

2. 如果未找到，它会沿着对象的原型链向上查找，直到找到属性或到达原型链的顶端（`null`）。

3. 如果最终仍未找到属性，则返回 `undefined`。

```js whitespace
function Animal(type) {
    this.type = type;
}

Animal.prototype.eat = function () {
    console.log(`${this.type} is eating.`);
};

const dog = new Animal("Dog");

// 查找过程：
dog.eat(); // 输出：Dog is eating
console.log(dog.hasOwnProperty("type")); // true
console.log(dog.hasOwnProperty("eat")); // false
```

1. `dog.eat()` 在对象 `dog` 本身找不到 `eat` 方法。
2. 沿着原型链找到 `Animal.prototype.eat`，并调用它。

### 原型链的结构

```js whitespace
const grandParent = { grandParentProp: "grandParent" };
const parent = Object.create(grandParent);
parent.parentProp = "parent";
const child = Object.create(parent);
child.childProp = "child";

console.log(child.childProp); // 输出："child" （来自 child 对象）
console.log(child.parentProp); // 输出："parent" （来自 parent 对象）
console.log(child.grandParentProp); // 输出："grandParent" （来自 grandParent 对象）
console.log(child.nonExistentProp); // 输出：undefined
```

在这个例子中，`child` 的原型链是：`child -> parent -> grandParent -> null`。

### 原型链的核心点

1. **所有对象都最终指向 `null`**
   - 原型链的终点是 `null`，`null` 表示没有更高一级的原型。
2. **对象原型的定义**
   - 每个对象都有一个 `__proto__` 属性，指向其原型（除 `Object.prototype`）。
   - `Object.prototype.__proto__` 为 `null`。
3. **构造函数与原型**
   - 每个函数都有一个 `prototype` 属性，指向一个对象。
   - 使用该函数创建的实例对象会将其 `__proto__` 指向该对象。

```js whitespace
function Person(name) {
    this.name = name;
}

Person.prototype.sayHello = function () {
    console.log(`Hello, my name is ${this.name}`);
};

const alice = new Person("Simin");
alice.sayHello(); // 输出：Hello, my name is Simin

console.log(alice.__proto__ === Person.prototype); // 输出：true
console.log(Person.prototype.__proto__ === Object.prototype); // 输出：true
```

### 原型链的复杂实例

#### 1. 多级继承

```js whitespace
function Animal(type) {
    this.type = type;
}
Animal.prototype.eat = function () {
    console.log(`${this.type} is eating.`);
};

function Dog(name) {
    this.name = name;
}
Dog.prototype = Object.create(Animal.prototype);
Dog.prototype.constructor = Dog;
Dog.prototype.bark = function () {
    console.log(`${this.name} says woof!`);
};

const bulldog = new Dog("Bulldog");
bulldog.type = "Dog";
bulldog.eat(); // 输出：Dog is eating.
bulldog.bark(); // 输出：Bulldog says woof!
```

在这个例子中：

- `Dog` 继承了 `Animal`。

- `bulldog` 的原型链是：`bulldog -> Dog.prototype -> Animal.prototype -> Object.prototype -> null`。

#### 2. 原型链的动态性

由于 JavaScript 中对象的动态性，可以在运行时扩展原型链。

```js whitespace
function Car() {}
Car.prototype.drive = function () {
    console.log("Driving...");
};

const tesla = new Car();
tesla.drive(); // 输出：Driving...

Car.prototype.fly = function () {
    console.log("Flying...");
};

tesla.fly(); // 输出：Flying...
```

在运行时，给 `Car.prototype` 添加了一个 `fly` 方法，`tesla` 实例立即可以访问该方法。

## Object.create 与原型

`Object.create` 是一种直接创建原型对象的方式。

```js whitespace
const animal = {
    eat: function () {
        console.log("Eating...");
    }
};

const dog = Object.create(animal);
dog.bark = function () {
    console.log("Barking...");
};

dog.eat(); // 输出：Eating...
dog.bark(); // 输出：Barking...
```

1. `dog` 的原型是 `animal`。
2. 通过 `dog` 可以访问 `animal` 上的属性和方法

## 修改原型的注意事项

修改原型会影响所有基于该原型创建的对象。

``` js
function Person(name) {
    this.name = name;
}

Person.prototype.greet = function () {
    console.log(`Hi, I am ${this.name}`);
};

const alice = new Person("Alice");
const bob = new Person("Bob");

Person.prototype.greet = function () {
    console.log(`Hello, ${this.name}`);
};

alice.greet(); // 输出：Hello, Alice
bob.greet();   // 输出：Hello, Bob
```

**注意点：**

1. 原型上的修改会影响所有基于该原型创建的实例。

2. 原型链上的属性是共享的，但对象自身的属性不是。

```js
function Dog() {}

Dog.prototype.legs = 4;

const dog1 = new Dog();
const dog2 = new Dog();

dog1.legs = 3;

console.log(dog1.legs); // 输出：3（自身属性覆盖原型属性）
console.log(dog2.legs); // 输出：4（原型属性）
```

## 原型与类的关系

在ES6（ECMAScript 2015）中，JavaScript引入了class关键字，提供了一种新的语法来定义对象和它们之间的关系，使得面向对象编程（OOP）更加直观和易于理解。虽然JavaScript的继承机制仍然是基于原型的，但class语法提供了一种更接近传统面向对象编程语言的写法。简单来说，JavaScript 的 `class` 是基于原型机制实现的语法糖。


```js
class Person {
    constructor(name) {
        this.name = name;
    }

    greet() {
        console.log(`Hello, I am ${this.name}`);
    }
}

const alice = new Person("Simin");
alice.greet(); // 输出：Hello, I am Simin
```

1. `class` 本质上是基于 `Function` 的构造函数。

2. 方法定义在 `Person.prototype` 上，可以通过实例访问。

等价于：

```js
function Person(name) {
    this.name = name;
}

Person.prototype.greet = function () {
    console.log(`Hello, I am ${this.name}`);
};
```

## 原型的常见问题

### 1. 误解 `prototype` 和 `__proto__` 的区别

- `prototype` 是构造函数的属性，指向原型对象。
- `__proto__` 是实例对象的属性，指向构造函数的原型。

```js
function Person(name) {
    this.name = name;
}

const alice = new Person("Alice");
console.log(alice.__proto__ === Person.prototype); // true
console.log(Person.prototype.constructor === Person); // true
```

### 2. 直接替换原型

- 替换原型对象会导致原型链断裂。

```js
function Person() {}
Person.prototype = {
    greet: function () {
        console.log("Hello!");
    }
};

const alice = new Person();
alice.greet(); // 输出：Hello!
console.log(alice.constructor === Person); // false
```


## 参考资料

[MDN《继承与原型链》](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Inheritance_and_the_prototype_chain)

[原型对象概述 阮一峰](https://wangdoc.com/javascript/oop/prototype)