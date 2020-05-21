---
title: "How Powerful Are Graph Neural Networks?"
date: 2020-05-20T20:59:03+08:00
summary: 读后总结, 刊于ICLR 2019
toc: true
katex: true
tags:
- Graph Neural Network (GNN)
- Machine Learning
categories:
- 文献阅读
---

## Preliminary

### The Weisfeiler-Lehman Isomorphism Test

For a easy-to understand explanation, please refer to [this link](https://davidbieber.com/post/2019-05-10-weisfeiler-lehman-isomorphism-test/). Here, I simply summarize it briefly.

![Two isomorphic graphs](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-05-21-112619.png)
*Graph 1 and Graph 2 are isomorphic. The correspondance between nodes is illustrated by the node colors and numbers.*



> In general, determining whether two graphs are isomorphic when the correspondance is not provided is a challenging problem; precisely how hard this problem is remains an open question in computer science. It isn't known whether there is a polynomial time algorithm for determining whether graphs are isomorphic, and it also isn't known whether the problem is NP-complete. The graph isomorphism problem may even be an example of an [NP-intermediate](https://en.wikipedia.org/wiki/NP-intermediate) problem, but this would only be possible if $P\ne NP$.
>
> *From link above*



The Weisfeiler-Lehman Isomorphism Test produces canonical forms of graphs. **If the canonical forms of two graphs are not same, then two graphs are not isomorphic**. It is possible for two graphs to have same canonical forms but are not isomorphic. The algorithm iterative encode nodes (usually by a hash function) in a graph based on its neighbors to generate some kind of "fingerprint" or "signature". With same initialization, we could find correspondance nodes in two graphs when they share the same fingerprint.

### Graph neural network

最为常见的GNN范式可以如此描述.对于图 $G=(V,E)$ , $X_v$ 表示其节点 $v\in V$ 的特征向量(feature vector)[^1]. 图网络的流程可以简单概括如下：
$$
\begin{aligned}
a_v^{(k)}&=\text{AGGREGATE}^{(k)}\left( \left\{\left. h_u^{(k-1)}\right|u\in \mathcal{N}(v) \right\} \right), \\\\
h_v^{(k)} &= \text{COMGINE}^{(k)}\left( h_v^{(k-1)}, a_v^{(k)} \right),\\\\
h_G &= \text{READOUT}\left( \left\{ \left. h_v^{(K)} \right| v\in G \right\} \right)
\end{aligned}
$$
其中, $h_v^{(k)}$ 表示节点 $v$ 在第 $k$ 层/循环时的特征向量; $h_v^{(k)}$ 的初始值为 $X_v$ ; $\mathcal{N}(v)$ 表示节点 $v$ 的邻居节点. 其中三个大写字母表示的函数是区别于不同GNN之间的重要因素. 大概汇总如下:

- GraphSAGE (Hamilton et al., 2017a)
  - $a_v^{(k)}=\text{MAX}\left( \left\{\left. \text{ReLU}\left(W\cdot h_u^{(k-1)}\right)  \right|u\in \mathcal{N}(v) \right\} \right)$
  - $h_v^{(k)} = W\cdot \left[ h_V^{(k-1)}, a_v^{(k)} \right]$
  - $\text{MAX}$ 表示MaxPooling
- GCN (Kipf & Welling, 2017)
  - $h_v^{(k)}=\text{ReLU}\left(W\cdot \text{MEAN}\left\{ h_u^{(k-1)}, \forall u\in \mathcal{N}(v)\cup \{v\}  \right\}\right)$
  - 两个函数合二为一

常见的图上任务有两类：① 节点分类, 每个节点 $v$ 都有一个对应标签 $y_v$, GNN学到了节点表示 $h_v$ 后, 通过映射函数进行预测, 使得 $y_v=f(h_v)$ ; ②图分类, 对于每一个图 $G$, 都有一个标签 $y_G$ , 通过GNN学到图的表示 $h_G$ 后, 通过映射函数进行预测, 使得 $y_G=f(h_G)$. 

## 工作简述

文章通过理论论证+实验验证的方法指出了做出了两个主要贡献: 

1. 论证并给出了各种GNN变体的表达能力的上限和达到的条件
2. 通过理论分析设计出了理论上更具优的网络结构GIN

## 理论证明

这里阐述一个大概的思路. 为了论证GNN的表示能力, 考察何种条件下GNN能将两个节点映射到嵌入空间中相同的位置. 理想情况下, 最具表达能力的GNN将两个节点映射到嵌入空间中相同的位置**当且仅当**两个节点具有相同的子树结构 (aggregate N 次形成的树). 这表示GNN的 $\text{AGGREGATE}$ 函数必须是单射的. 而GNN这种区分能力的上限则是WL test. 作者证明,只有当$\text{AGGREGATE}$ , $\text{COMBINE}$ 以及 $\text{READOUT}$ 都是单射的时候, GNN将在描述节点的特征上达到WL test的性能. 

注: 文中这里提出了很多引理, 针对如何设计一个单射的multiset function. 这些是GIN设计及有效的证据.

## Graph Isomorphism Network (GIN)

![一些引理最终得到的命题](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-05-21-155525.png)

这一命题构造了一系列符合要求的单设函数. 如果使用MLP学习其中的映射, 那么就得到了GIN的节点表示更新函数就可以写作为下式. 其中MLP可对前一次和下一次的 $\phi f$ 函数同时建模. 至此, 作者表明他们设计出了一个理论上达到表示能力上界的图神经网络.
$$
h_v^{(k)}=\text{MLP}^{(k)}\left(\left( 1+\epsilon^{(k)} \right)\cdot h_v^{(k-1)}+\sum_{u\in\mathcal{N}(v)}h_u^{(k-1)}\right)
$$
最后, 还差一个 $\text{READOUT}$ 函数. 作者提出, 在节点对应的遍历树逐渐趋近整个图的时候, 图中的特征将会有更好的判别性能. 但迭代轮数较小时候的特征却可以拥有更好的泛化性能[^2]. 因此作者表示为了能考虑到图中所有结构信息, 我们应当使用所有迭代过程中的特征. 作者通过一个与 Jumping Knowledge Network类似的架构实现了这样的操作:
$$
h_G=\text{CONCAT} \left( \text{READOUT}\left.\left.\left(\left\{h_v^{(k)}\right|v \in G\right\} \right) \right| k=0,1,\dots,K \right)
$$
根据上面的命题, 如果令 $\text{READOUT}$ 为求和函数, 那么它也将符合单射的条件. 作者在4个生信数据集+5个社交网络数据集上进行了测试, 结果自然是几乎全部怒砍第一.

![GIN不同数据集上的测评结果](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-05-21-163130.png)

## 关于其他的GNN

其他的GNN虽然没有GIN这么强大,但是同样会捕捉一些图上有趣的性质. 作者针对GCN和GraphSAGE中不满足单设条件的①1层感知器, ②均值或max-pooling而非求和的 $\text{AGGREGATE}$ 函数做了消融实验. 它们都在一些图结构上无法分辨.

![表达能力排序](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-05-21-164916.png)
*不同的 $\text{AGGREGATE}$ 函数的表示能力排序. Input表示将要输入的一堆目标节点的邻居; 右边排序说明了SUM捕捉到multiset中所有元素的特征; MEAN捕捉到了节点大致的分布; MAX忽视了multiset, 将其退化为简单地集合 (SET). 不同颜色的节点代表不同的特征值.*

### 1层感知器

文章证明了1层感知器 (线性组合+激活函数) 并不能对某些网络结构进行分辨. 即文中引理7:

> **Lemma 7.** *There exist finite multisets* $X_1 \ne X_2$ *so that for any linear mapping* $W$, $\sum_{􏰄x\in X_1} \text{ReLU}(Wx)=\sum_{􏰄x\in X_2} \text{ReLU}(Wx)$.

证明过程主要思路是, 1层感知器和线性映射区别很小, GNN会退化到每一层仅仅将邻居节点求和. 另外, 众所周知, 1层感知器并不能对任意的函数进行近似.

### Mean和Max-pooling

这两个函数虽然都是组合不变的, 但是他们并非单射的. 根据之前的证明, 他们并不能区分某些图结构. 对于Mean函数,很容易能看出来, 它刻画的是周围邻居的均值, 或者可以理解为分布情况. 而对Max-pooling, 它则将原本是Multiset的邻居特征集合退化为一个简单集合, 并使用唯一元素代表所有邻居. 这些结论都有形式化证明, 这里不再赘述.

![](https://minys-blog.oss-cn-beijing.aliyuncs.com/2020-05-21-165229.png)
*使得不同 $\text{AGGREGATE}$ 函数输出相同的图结构. 其中不同颜色代表不同的特征值. 简单计算就可以看出原因.*

## 结果与总结

这篇论文亮点就在通过WL test分析并设计的GNN确实在下游任务中比原来几种GNN好得多. 这篇文章代码也出奇简单. 有空一定要好好看看, 留个坑.



[^1]: 这里特征向量指的并非线性代数中的特征向量.
[^2]: 作者没有解释, 我也不是很理解这里