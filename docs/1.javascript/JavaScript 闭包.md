---
title: JavaScript 闭包
createTime: 2025/01/02 17:01:51
permalink: /article/0895k759/
cover: {url: '/simin-xxm/images/闭包.png'}
---

## 什么是闭包？

闭包是指一个函数能够记住其定义时的词法作用域，并能在当前作用域之外调用。
<!-- more -->
- 闭包的本质是函数和其词法环境的组合。

- 内部函数能够“捕获”外部函数中的变量，即使外部函数已经执行完毕。


```js
function outer() {
    let count = 0;
    return function() {
        count++;
        return count;
    };
}
const counter = outer();
console.log(counter()); // 输出：1
console.log(counter()); // 输出：2

function greeting(name) {
    return function(message) {
        return `${message}, ${name}!`;
    };
}
const greetJohn = greeting("John");
console.log(greetJohn("Hello")); // 输出：Hello, John!
console.log(greetJohn("Goodbye")); // 输出：Goodbye, John!
```

## 闭包的形成条件

### 1. 函数嵌套

闭包需要内部函数能够访问外部函数的变量。这个嵌套关系是闭包形成的基础。

```js
function outer() {
    const outerVar = "外部变量";
    function inner() {
        console.log(outerVar); // 内部函数访问外部变量
    }
    inner();
}
outer(); // 输出：外部变量

function calculator(base) {
    return function(addend) {
        return base + addend;
    };
}
const addFive = calculator(5);
console.log(addFive(10)); // 输出：15
console.log(addFive(20)); // 输出：25
```

### 外层函数返回内部函数

闭包的特点是外层函数返回的内部函数仍然可以访问外层函数的变量。

```js
function sayHello(name) {
    return function() {
        console.log(`Hello, ${name}`);
    };
}

const greetMary = sayHello("Simin");
greetMary(); // 输出：Hello, Simin
```

## 闭包的特点

### 1. 记住定义时的作用域

```js
function multiplier(factor) {
    return function(number) {
        return number * factor; // 闭包记住了 factor
    };
}
const double = multiplier(2);
console.log(double(10)); // 输出：20
console.log(double(5)); // 输出：10
```

### 2. 延长变量的生命周期

闭包使外层函数中的变量不会在函数调用结束后销毁，而是继续存在于内存中。

```js
function storage() {
    let data = [];
    return {
        add(item) {
            data.push(item);
        },
        get() {
            return data;
        }
    };
}
const myStorage = storage();
myStorage.add("item1");
myStorage.add("item2");
console.log(myStorage.get()); // 输出：["item1", "item2"]
```

## 闭包的应用场景

### 1. 模拟私有变量

通过闭包，可以创建只允许通过特定函数访问的变量，从而实现类似于类中的“私有变量”。

```js
function createAccount() {
    let balance = 0;
    return {
        deposit(amount) {
            balance += amount;
        },
        withdraw(amount) {
            if (balance >= amount) {
                balance -= amount;
            } else {
                console.log("余额不足");
            }
        },
        getBalance() {
            return balance;
        }
    };
}
const account = createAccount();
account.deposit(100);
console.log(account.getBalance()); // 输出：100
account.withdraw(50);
console.log(account.getBalance()); // 输出：50


function secretHolder() {
    let secret = "未设置";
    return {
        setSecret(newSecret) {
            secret = newSecret;
        },
        revealSecret() {
            console.log(secret);
        }
    };
}
const mySecret = secretHolder();
mySecret.setSecret("Simin");
mySecret.revealSecret(); // 输出：Simin
```

### 2. 事件监听器

闭包在事件处理程序中非常常见，用来捕获上下文信息。

```js
function attachListeners(elements) {
    elements.forEach((element, index) => {
        element.addEventListener("click", function() {
            console.log(`点击了第 ${index + 1} 个元素`);
        });
    });
}
const elements = [document.createElement("div"), document.createElement("div")];
attachListeners(elements);
elements[0].click(); // 输出：点击了第 1 个元素
elements[1].click(); // 输出：点击了第 2 个元素


function createButton(label) {
    const button = document.createElement("button");
    button.textContent = label;
    button.addEventListener("click", () => {
        console.log(`${label} 按钮被点击`);
    });
    return button;
}
document.body.appendChild(createButton("提交"));
```

## 闭包的注意事项

### 1. 避免内存泄漏

闭包会持有对外部变量的引用，可能导致内存泄漏，特别是当闭包引用了大量的 DOM 元素时。

```js
function attachHandlers() {
    const elements = document.querySelectorAll("button");
    elements.forEach((element) => {
        element.addEventListener("click", () => {
            console.log(element.id);
        });
    });
}
attachHandlers(); // 如果 elements 被持久化引用，可能导致内存泄漏
```



## 参考资料

[MDN《闭包》](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Closures)

