---
title: "Learning Multimodal Graph to Graph Translation for Molecular Optimization"
summary: "读后总结, 刊于ICLR 2019"
date: 2020-05-28T22:52:13+08:00
mathjax: true
tags:
- Graph Auto Encoder (GAE)
- Machine Learning
- 未完成
categories:
- 文献阅读
---

## 论文简述

药物发现的目标是设计具有特定期望的化学性质的分子.  这个任务很具有挑战性, 因为化学空间是巨大的且难于探索. 一个解决该问题的流行的方法使匹配分子对分析 (MMPA). 通过学习"分子释义", 来提升化合物特定的性质. 这与机器翻译的策略很相似: MMPA输入一个分子对 $\{(X, Y)\}$, 其中 $Y$ 看做是 $X$ 的释义/含义, 并具有更好的化学性质. 然而现有的MMPA方法将分子对提炼为图转化 (graph transformation) 问题, 而非更普适的图之间的翻译问题.

因此,本文提出将分子优化问题 (molecular optimization) 看做一个图对图的翻译 (graph-to-graph translation). 给定分子对的文集, 任务目标是学习如何将输入的分子图翻译为更好的图. 这个思路中涉及很多问题: 如何编码图, 如何生成图. 其中如何编码图已有若干工作, 但在不诉诸于专业领域知识的情况下生成图, 确是一个难题. 另外, 一个分子的"释义"可以是多个, 因为有不同的分子优化策略. 因此, 本文的问题最终转化为如何生成多模态的分子图.

本文使用了junction tree encoder-decoder来在注意力机制下解码生成分子图. 为了 (a) 捕捉不同的输出, 本文在解码过程中引入了隐码 (latent code), 使其能捕捉有意义的分子变种; 为了 (b) 避免无效的翻译结果, 本文以入了对抗训练, 使用随机选择的隐码对齐模型生成的图的分布和以观察到的有效输出 (真值) 的分布.

## 解决方案

### Junction Tree Encoder-Decoder

本文的翻译模型拓展了junction tree variational autoencoder. 我们将每个分子看做从子图 (原子团/官能团) 构建而来, 基于一个合法的分子子结构库. Junction tree中的原子团代表着分子的骨架 (scaffold), 如下图所示. 分子解码的过程包括: 生成junction tree; 合并树中节点得到分子. 这样从粗到细的过程将允许我们很轻松的控制生成的图在化学上是正确的的, 并且能将分子在不同层级取得较为丰富的表示.

![](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-06-01-145411.png "Encoder-decoder示意图. 分子表示为对应的图结构和记录分子骨架的junction tree. 其中树中的节点表示一个子结构. 解码过程中, 模型先解码出junction tree, 而后联合子结构最终预测出分子图.")



模型的编码器包含: 一个图消息传递网络, 编码树和图至嵌入向量. 模型的解码器包含: (1) 树结构解码器, 用以预测junction tree的结构, (2) 一个图解码器, 用以将树扩充为分子图.

### 树图二合一编码器

图定义为 $G=(\mathcal{V}, \mathcal{E})$. 图中节点 $v$ 具有特征 $\boldsymbol{f}_v$ . 对原子来说, 其中包含了原子类型, 化合价等原子性质. 对junction tree中的节点 (文中称cluster),  $\boldsymbol{f}_v$ 是one-hot向量, 表示其类别. 类似地, 边 $(u,v)\in\mathcal{E}$ 也有对应的特征 $\boldsymbol{f}_{uv}$ . $N(v)$ 表示节点 $v$ 邻居构成的集合. 每条边 $(u,v)$ 有两个隐向量 $\boldsymbol{\nu}_{uv}$, $\boldsymbol{\nu}_{vu}$, 分别表示两个方向传递的消息. 则消息传递网络通过神经网络 $g_1(\cdot)$ 更新图中边上的消息:
$$
\boldsymbol{\nu}_{uv}^{(t)}=g_1\left(\boldsymbol{f}_u, \boldsymbol{f}_{uv}, \sum_{w\in N(u)\backslash v} \boldsymbol{\nu}_{wu}^{(t-1)}\right)
$$
其中 $\boldsymbol{\nu}_{uv}^{(t)}$ 表示第 $t$ 次迭代时边 $(u,v)$ 上的消息, 其初始化为零向量. 图上节点更新顺序是异步的, 即没有预定义的顺序. 在 $T$ 次迭代之后, 我们将图中消息通过神经网络 $g_2(\cdot)$ 聚合, 得到每一个节点的嵌入向量, 其刻画了**图或树中的局部结构**.
$$
\boldsymbol{x}_u = g_2\left( \boldsymbol{f}_u, \sum_{v\in N(u)} \boldsymbol{\nu}_{vu}^{(T)} \right)
$$
对junction tree $\mathcal{T}$ 和分子图 $G$ 都使用消息传递网络编码,得到了 $\{\boldsymbol{x}_1^{\mathcal{T}},\cdots, \boldsymbol{x}_n^{\mathcal{T}}\}$ 与 $\{\boldsymbol{x}_1^{\mathcal{G}},\cdots, \boldsymbol{x}_n^{\mathcal{G}}\}$ .[^1]

### Junction Tree解码器

这一步的目标是根据编码器输出的树表示和图表示重建junction tree. 这里使用了树循环神经(tree RNN)网络+注意力机制. 构建树的过程是自顶向下的, 每次拓展树的一个节点. 形式化地说, 令 $\tilde{\mathcal{E}}=\{(i_1,j_1),\cdots,(i_m,j_m)\}$ 为树 $\mathcal{T}$ 的深度优先遍历, 其中 $m=2|\mathcal{E}|$ 因为每个边从两个方向看要算两次. 令 $\tilde{\mathcal{E}}_t$ 为 $\tilde{\mathcal{E}}$ 中前 $t$ 个边. 在第 $t$ 步的解码中, 模型访问节点 $i_t$ 并接受其邻居的消息 $\boldsymbol{h}_{ij}$ . 消息向量 $\boldsymbol{h}_{i_t,j_t}$ 通过 树GRU更新:
$$
\boldsymbol{h}_{i_t,j_t} = \text{GRU}(\boldsymbol{f}_{i_t}, \{\boldsymbol{h}_{k, i_t}\}_{(k, i_t)\in \tilde{\mathcal{E}}, k\ne j_t})
$$

**拓扑结构预测**. 当模型访问节点 $i_t$ 时, 首先通过一层神经网络编码节点特征 $\boldsymbol{f}_{i_t}$ 和输入消息 $\{\boldsymbol{h}_{k, i_t}\}$ 来计算计算隐状态 $\boldsymbol{h}_t$. 模型随后进行二分类, 预测是否拓展这个新节点, 或是回溯回 $i_t$ 的父亲节点. 概率是通过聚合编码器所编码的两组嵌入向量 $\{\boldsymbol{x}_*^{\mathcal{T}}\}, \{\boldsymbol{x}_*^{\mathcal{G}}\}$ 而来的.
$$
\begin{aligned}
\boldsymbol{h}_t &= \tau(\boldsymbol{W}_1^d\boldsymbol{f}_{i_t}+\boldsymbol{W}_2^d\sum_{(k,i_t)\in \tilde{\mathcal{E}}_t}\boldsymbol{h}_{k,i_t}) \\
\boldsymbol{c}_t^d &= \text{attention}(\boldsymbol{h}_t, \{\boldsymbol{x}_*^{\mathcal{T}}\}, \{\boldsymbol{x}_*^{\mathcal{G}}\}; \boldsymbol{U}_{att}^d) \\
\boldsymbol{p}_t &= \sigma(\boldsymbol{u}^d\cdot\tau(\boldsymbol{W}_3^d\boldsymbol{h}_t+\boldsymbol{W}_4^d\boldsymbol{c}_t^d))
\end{aligned}
$$
其中 $(\cdot;\boldsymbol{U}_{att}^d)$ 表示参数为 $\boldsymbol{U}_{att}^d$ 的注意力机制, 其在树和图上分别计算得到两组注意力分数 $\{\boldsymbol{\alpha}_*^{\mathcal{T}}\}, \{\boldsymbol{\alpha}_*^{\mathcal{G}}\}$ . 输出的 $\boldsymbol{c}_t^d$ 是树和图的注意力加权向量的级联.
$$
\boldsymbol{c}_t^d = \left[ \sum_i \boldsymbol{\alpha}_{i,t}^{\mathcal{T}}\boldsymbol{x}_{i}^{\mathcal{T}}, \sum_i \boldsymbol{\alpha}_{i,t}^{\mathcal{G}}\boldsymbol{x}_{i}^{\mathcal{G}} \right]
$$
**标签预测**. 如果节点 $j_t$ 是 $i_t$ 生成的新节点, 其标签(表明它是何种分子骨架的标签)可以通过下式预测.
$$
\begin{aligned}
\boldsymbol{c}_t^l&=\text{attention}(\boldsymbol{h}_{i_t,j_t}, \{\boldsymbol{x}_*^{\mathcal{T}}\}, \{\boldsymbol{x}_*^{\mathcal{G}}\}; \boldsymbol{U}_{att}^l) \\
\boldsymbol{q}_t &= \text{softmax}(\boldsymbol{U}^l\cdot\tau(\boldsymbol{W}_1^l\boldsymbol{h}_{i_t,j_t}+\boldsymbol{W}_2^l\boldsymbol{c}_t^l))
\end{aligned}
$$

其中 $\boldsymbol{q}_t$ 是在标签集上的概率分布, $\boldsymbol{U}_{att}^l$ 是另一组计算注意力时的参数.

### 图解码器

解码的第二步是从上一步预测的junction tree $\mathcal{\hat{T}}$ 出发, 构建分子图 $G$. 这个过程是非确定性的, 因为如下图所示, 同样的junction tree可以组装成不同的分子. 这一过程的自由度取决于原子团(树的节点)之间是如何连接的. 令 $\mathcal{G}_i$ 为一个分子图集合, 表示节点 $i$ 能发生的可能的连接方式对应的分子. 每一个分子图 $G_i\in \mathcal{G}_i$ 都表示原子团 $C_i$ 和其邻居原子团 $\{C_j\, j\in N_{\mathcal{\hat{T}}}(i)\}$ 的某种特定的连接方式. 这个图解码器的目标就是正确预测树中原子团的连接方式.

<img src="https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-06-02-114547.png" title="相同的树可以组合为不同的分子." style="zoom:30%;" />

为此, 本文作者设计了一个打分函数 $f(\cdot)$ 来对每一个 $\mathcal{G}_i$ 中的候选分子图 (对应连接方式) 进行排序. 首先, 用图消息传递网络对图 $G_i$ 计算原子表示 $\{\boldsymbol{\mu}_v^{G_i}\}$ . 然后使用sum-pooling求得图的表示 $\boldsymbol{m_{G_i}}=\sum_v \boldsymbol{\mu}_v^{G_i}$ . 最后, 通过点积函数为这个图打分 $f(G_i) = \sum_{u\in G}\boldsymbol{m}_{G_i}\cdot \boldsymbol{x}_u^{\mathcal{G}}$.[^2]解码器训练过程的损失函数是真值的子图和树中节点(原子团)的对数似然函数:
$$
\mathcal{L}_g(G) = \sum_i\left[ f(G_i)-\log\sum_{G_i'\in\mathcal{G}_i}exp(f(G_i')) \right]
$$

### 多模态图-图翻译

#### 变分Junction tree编码-解码器(VJTNN)

将上述模块组织起来形成整个模型

#### 分子骨架的对抗正则化

这部分旨在让模型输出正确的分子结构, 通过一个GAN来规范化模型,使得其输出正确的分子结构.



(未完待续)

## 个人感受

这篇文章的模型实在是太过复杂, 已经读了两三天了, 但是依然感觉有一些雾里看花. 一个很模糊的点是模型提出的动机, 例如: 如何解决文章开头提到的多模态图生成问题. 为什么要用编码器解码器这样的结构? 为什么要使用junction tree这样的有序树结构来表示无序的图? 为什么要联合树和图一起编码? 

个人认为其中缺乏很多解释, 更多的是搭建一个如何能完成这个任务的模型, 试想我们把化学分子换成蛋白质结构的空间距离图, 是不是也能用? 如果这样的话那究竟它编码的过程都"学"到了什么呢? 我认为作者应该更多解释一下如何从数据上刻画分子表示, 根据什么想法设计模型, 而非大量篇幅描述复杂的模型, 但模型某模块为什么加入. 这样我认为即使有好的结果也很难去解释为什么好. 虽然我看在Table2里,本文提出的结果似乎并没有比前人工作好多少, 甚至似乎都没有超出随机波动 (QED success提升2.5%, diversity提高0.045, novelty并没有提高. 第二个任务每一项指标都提高小于1个百分点). 另, 相比于VSeq2Seq模型直接翻译分子间的SMILES, 复杂性提升很多的模型却没有带来显著的性能提升, 是否应该有一些思考.

另外, 我的前导师崔老师教导我, 写公式的时候不到万不得已千万不要用连续下表, 比如 $i_{j_k}$, 很容易让读者迷惑. 我真真切切感受到了. 这些复杂的表示其实换一种想法完全可以省略, 比如 $\boldsymbol{\nu}_{uv}^{(t)}$, 完全可以并入公式 (2) 中. 感觉文章写完, 希腊字母似乎都被用光了. 这也可能是化生学科和计算机学科之间在认知上的鸿沟吧!

综上, 这篇文章咬牙看完, 看到最后结果汇总并和基线模型差距不大甚至无法超越的时候, 突然就丧失了一半继续写下去的动力, 然后转身去看代码, 发现代码是Python 2.7 + pytorch 0.4 + rdkit 2017.09! 不说别的, 这个环境配起来确实不是很方便, 至此, 丧失了另一半写下去的动力. 

如果以后有机会/需求的时候, 再接着这里写完吧!




[^1]: 这里有问题. junction tree中的节点数目按理来说应该小于分子图, 因为树中一个节点代表一个子结构. 但这里公式却写着两个嵌入向量集合具有相同的向量个数, 可能有误!
[^2]: 这个打分函数我强烈怀疑有问题. 竟然解码的结果会和编码的结果比较, 这不就相当于解码器模型的输出好坏取决于输入吗? 个人感觉这里有问题. 