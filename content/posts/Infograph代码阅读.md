---
title: "Infograph代码阅读"
summary: "Infograph代码阅读"
date: 2020-06-22T18:24:20+08:00
draft: true
katex: true
tags:
- 
categories:
- 
---

`model.py`: class `FF`

stateDiagram-v2
    Input --> Linear1
    Linear1 -->Linear2:ReLU
    Linear2 -->Linear3:ReLU
    Input --> Linear4
    Linear4 --> Output: ElemAdd
    Linear3 --> Output: ReLU\n\nElemAdd

`model.py`: class `PriorDiscriminator`
stateDiagram-v2
    Input --> Linear1
    Linear1 -->Linear2:ReLU
    Linear2 -->Linear3:ReLU
    Linear3 --> Output\n0/1: Sigmoid