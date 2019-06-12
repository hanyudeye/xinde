---
title: 配置hexo 可以渲染latex数学公式
date: 2019-05-27 13:29:52
tags: latex
category: 软件使用
categories: 软件使用

mathjax: true
---
# [写数学公式](https://docs.mathjax.org/en/latest/index.html)
## 安装配置
安装渲染
```sh
npm un hexo-renderer-marked --save
npm i hexo-renderer-pandoc --save # 或者 hexo-renderer-kramed
```
主题配置中:
```yml
math:
  enable: true
  #是否每页需要验证( 下面的头部标记 )
  per_page: true
  engine: mathjax
```
<!-- more -->
头部验证，如果不需要渲染数学公式,在可以在文章头部加上下面那行,反之为true

```yml
mathjax: false
```
## 结构
单行结构:
``` latex
$$\begin{equation}
e=mc^2
\end{equation}\label{eq1}$$

```
单行简约结构:
``` latex
$1+1=3$
```
复杂单行: 
```
$ J_\alpha(x) = \sum_{m=0}^\infty \frac{(-1)^m}{m! \Gamma (m + \alpha + 1)} {\left({ \frac{x}{2} }\right)}^{2m + \alpha} \text {，行内公式示例} $
```

多行结构
```latex
$$\begin{equation}
\begin{aligned}
a &= b + c \\
  &= d + e + f + g \\
  &= h + i
\end{aligned}
\end{equation}\label{eq2}$$
```
公式对齐 
```
$$\begin{align}
a &= b + c \label{eq3} \\
x &= yz \label{eq4}\\
l &= m - n \label{eq5}
\end{align}$$
```
不想要编号
```latex
$$\begin{align}
-4 + 5x &= 2+y \nonumber  \\
 w+2 &= -1+w \\
 ab &= cb
\end{align}$$
```

公式引用:
```
著名的质能方程 $\eqref{eq1}$ 由爱因斯坦提出 ...
```

另一种标记
```latex
$$x+1\over\sqrt{1-x^2} \tag{i}\label{eq_tag}$$
```

# 示例展示
公式对齐:
$$\begin{align}
a &= b + c \label{eq1} \\
x &= yz \label{eq2}\\
l &= m - n \label{eq3}
\end{align}$$

公式引用:
引用上面的标记3 $\eqref{eq3}$ ...
