---
title: 功能测试
date: 2020-05-19 18:49:55
toc: true
Mathjax: true
tags:
  - 测试
categories:
  - 随便写写
---

这是一个一级标题
=============
这是一个二级标题
------------------------

# 数学公式
简单公式$A+B=C$这是行内公式
$$ a^2 + b^2 = c^2$$

$$x=\frac{-b\pm\sqrt{4ac}}{2a}$$
复杂公式
$$
\begin{aligned}
\mathcal{L} ( \mu ,\sigma^2 ) &= \prod_{i = 1}^n \left\lbrace  \frac{1}{\sqrt{2 \pi} \sigma } \text{exp} \left\lbrace - \frac{( x_i - \mu)^2}{2 \sigma^2}\right\rbrace \right\rbrace ,\\\\
&= (2 \pi \sigma^2)^{- \frac{n}{2}} \text{exp} \left\lbrace - \frac{1}{2 \sigma^2} \sum_{i = 1}^{n} (x_i - \mu)^2 \right\rbrace .
\end{aligned}
$$

# 公式作为TOC项目

$x=\frac{-b\pm\sqrt{4ac}}{2a}$
----------------------

### $x=\frac{-b\pm\sqrt{4ac}}{2a}$

#### $x=\frac{-b\pm\sqrt{4ac}}{2a}$

##### $x=\frac{-b\pm\sqrt{4ac}}{2a}$

一元二次方程解的公式$x= \frac{-b\pm\sqrt{4ac}}{2a}$

# 化学式$\ce{H3O+}$

$\ce{[AgCl2]-}$

 $\ce{NaOH(aq,$\infty$)}$

$\ce{Hg^2+ ->[I-]  $\underset{\mathrm{red}}{\ce{HgI2}}$  ->[I-]  $\underset{\mathrm{red}}{\ce{[Hg^{II}I4]^2-}}$}$

# Emoji

🌶💉🔟🐮🍺

# 代码块

```python
class Foo(object):
    def __init__(self, bar):
    self.foo = bar
    def print():
      print(f"this is {self.foo}")
```



## Mermaid

{{<mermaid align="center"  caption="This is a flowchart">}}
graph LR;
	A[Hard edge] -->|Link text| B(Round edge)
    B --> C{Decision}
    C -->|One| D[Result one]
    C -->|Two| E[Result two]
{{< /mermaid >}}

通过shortcode的设置, 当允许图表图例时, 可以通过接收caption参数为mermaid图表加上图例. 但注意要在前后加上空行, 不然这一段就和图表处在同一段了!

$*\mathbf{A} \in \mathbb{R}^{B\times N \times N}*$