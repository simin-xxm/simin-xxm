---
title: JavaScript 柯里化
createTime: 2025/01/02 17:59:18
permalink: /article/6w0xp38x/
---

::: tip 提示
需要先阅读 

[JavaScript 闭包](./JavaScript%20闭包.md)
:::

## 什么是函数柯里化？

柯里化概念源自数学和计算机科学的 Lambda 演算，由 Haskell Curry 推广。它的核心思想是通过固定部分参数来简化函数调用。是一种将函数转换为更细粒度函数的过程。具体来说，柯里化将一个接受多个参数的函数转换为一系列接受单一参数的函数。

简单来说就是把接收多参的函数转化成可以逐个调用单个参数并返回接收剩下参数的函数

<!-- more -->


#### 例子

```js
function sum(a, b, c) {
    return a + b + c;
}

// 转换 => 
function curriedSum(a) {
    return function(b) {
        return function(c) {
            return a + b + c;
        };
    };
}

curriedSum(1)(2)(3); // 输出：6
```

## 柯里化的优点和适用场景

### 提升代码的可读性

柯里化在许多场景下能够提高代码的可读性，特别是在高阶函数和函数组合中。它允许我们按需提供参数，并且能够以逐步递进的方式来定义函数的行为，从而避免一次性传递过多参数时可能产生的混乱。

例如，在需要处理动态用户输入或生成大量变体的场景中，柯里化非常有用。通过柯里化，我们可以将一个复杂的函数拆解为几个简单的函数，并且方便我们逐步传递必要的参数。


```js
function createGreeting(greeting) {
    return function(name) {
        return `${greeting}, ${name}!`;
    };
}

const greetMorning = createGreeting("Good Morning");
console.log(greetMorning("Simin")); // 输出：Good Morning, Simin!
```


### 可以提高函数复用性

柯里化能够将某些固定的参数抽离出去，从而使得其余参数可以在其他地方复用。这种方式提高了代码的复用性并减少了代码重复度。

```js
function discount(price, discountRate) {
    return price - (price * discountRate);
}

const applyTenPercentDiscount = discount.bind(null, null, 0.1);
console.log(applyTenPercentDiscount(100)); // 输出：90
```

## 柯里化和部分应用（Partial Application）

**部分应用** `（Partial Application）` 与柯里化有些相似，但它们之间存在明显的区别：

- 柯里化是将一个多参数的函数转化成多个单参数的函数，每个函数接收一个参数，直到所有的参数都传递完。

- 部分应用则是将一个多参数的函数，部分参数提前固定（提供）。这样做的结果是，得到一个新的函数，该函数接受剩下的参数。

柯里化是递归地将一个函数转变为接受单一参数的形式，而部分应用则是提前给定部分参数。


#### 部分应用

```js
function multiply(a, b, c) {
    return a * b * c;
}

// 部分应用，只固定 a 参数
const multiplyByTwo = multiply.bind(null, 2);

console.log(multiplyByTwo(3, 4)); // 输出：24 (2 * 3 * 4)

```

#### 柯里化与部分应用对比

```js
// 柯里化
const curriedMultiply = curry(multiply);
console.log(curriedMultiply(2)(3)(4)); // 输出：24

// 部分应用
const multiplyByTwo = multiply.bind(null, 2);
console.log(multiplyByTwo(3, 4)); // 输出：24
```

## 高阶函数和柯里化

在 JavaScript 中，柯里化特别适用于高阶函数。高阶函数是指接收函数作为参数，或返回一个函数的函数。柯里化的一个重要优点是它可以使得这些函数更加通用和灵活。

```js
function filter(predicate) {
    return function(array) {
        return array.filter(predicate);
    };
}

// 使用柯里化传递过滤条件
const filterGreaterThan10 = filter(x => x > 10);

const numbers = [1, 5, 10, 15, 20];
console.log(filterGreaterThan10(numbers)); // 输出：[15, 20]
```

在上面的代码中，我们使用柯里化来创建一个通用的过滤器（filter），它接受一个判断条件作为参数，并返回一个新的函数来应用该条件。

## 复杂的柯里化应用场景

### 数据转换和过滤

```js
const filter = (predicate) => (array) => array.filter(predicate);
const isEven = (num) => num % 2 === 0;

const filterEvens = filter(isEven);
console.log(filterEvens([1, 2, 3, 4])); // 输出：[2, 4]
```

### 动态配置系统

柯里化可用于动态生成具有特定配置的函数，例如 API 调用或日志处理。

```js
const createLogger = (level) => (message) => {
    console.log(`[${level}] ${message}`);
};

const debugLogger = createLogger("DEBUG");
const errorLogger = createLogger("ERROR");

debugLogger("This is a debug message."); // 输出：[DEBUG] This is a debug message.
errorLogger("This is an error message."); // 输出：[ERROR] This is an error message.
```

## 柯里化的缺点与注意事项

### 1. 可读性问题

过度使用柯里化会导致代码变得难以理解，尤其是在嵌套函数调用过多时。

虽然简洁，但对于不了解柯里化的开发者可能会感到困惑。

```js
const curried = (a) => (b) => (c) => (d) => a + b + c + d;
console.log(curried(1)(2)(3)(4)); // 输出：10
```

### 2. 性能开销

柯里化会增加函数调用层级，导致性能略有下降。因此，在性能敏感的场景中，应谨慎使用。

### 3. 过度抽象

在简单场景中使用柯里化可能导致不必要的复杂性。例如：

```js
const sum = (a, b) => a + b;
const curriedSum = curry(sum);
console.log(curriedSum(1)(2)); // 输出：3
```

## 参考资料

[现代 JavaScript 教程 - 柯里化（Currying）](https://zh.javascript.info/currying-partials)


