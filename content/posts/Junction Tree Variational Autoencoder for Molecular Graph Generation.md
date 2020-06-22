---
title: "Junction Tree Variational Autoencoder for Molecular Graph Generation"
summary: "读后总结, 刊于ICML 2018"
date: 2020-06-03T12:36:03+08:00
draft: true
mathjax: true
tags:
- Graph Auto Encoder (GAE)
- Machine Learning
categories:
- 文献阅读
---

## 论文简述

本文解决的主要问题是分子优化, 即给定一个分子结构和某个确定的性质, 模型输出一个分子的类似物, 这个类似物在这一性质上更优. 在此之前, 分子优化的任务主要借由分子的SMIELS表达式来实现, 具体是通过Seq2Seq模型来翻译待优化和已优化的分子表示, 即序列生成问题. 作者提出, 这些方法有两个问题:

- 分子的SMILES并不是设计用来描述分子相似度的, 如下图.[^1]
- 分子的表示是否合法, 通过分子图验证要比通过SMILES验证简单.

![](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-06-03-051143.png "一对同分异构体, 然而他们的经典SMILES的编辑距离为22, 占50.5%序列总长度.")

此前也有一个工作时图生成模型, 但是它们是逐个节点生成, 在分子图中, 作者表示 **这样必将生成很多违反化学规则的中间态分子图, 从而将分子图正确性验证推后到整张图都生成出来**. 因此, 本文提出了一种新方法 *junction tree variational autoencoder*. 包括两步:

- 用树分解将分子分解成子结构组成的树
- 子图(子结构, 树中节点)拼装生成分子图

## 方法



## 后记

本文和另一篇 *Learning Multimodal Graph to Graph Translation for Molecular Optimization* 是同一第一作者, 来自MIT的Wengong Jin. 看来他已经在分子生成模型上钻研了至少3年.



[^1]: 这一点我在自己的研究中也有发现, 我认为这里的表述不好. 分子的SMILES表示和图表示用来衡量分子相似性都很困难. 参考GIN中的WL test, 是一个NP-intermediate的问题, 复杂性不低. 我个人称之为 "canonical SMILES discontinuity", 即分子经典SMILES表示的不连续性, 分子中微小的扰动就可能让分子的经典SMILES出现很大的变动, 从而干扰对应的语言模型, 如RNN. SMILES直接应用于深度学习还有别的问题, 这里不再赘述.