---
title: "Coding Tricks - Python"
summary: "Some simple tricks and syntatic"
date: 2020-09-16T16:16:40+08:00
draft: false
katex: true
tags:
- Python
categories:
- 随便写写
---

### Merge Two `Dict`s with overwriting
**Problem**: 

I have 2 Python dictionaries, `x = {...}` and `y = {...}`, that may or may not have same keys. I want to merge them, and if there are identical keys, use values from `y` to overwrite ones in `x`. 

**Solution**:

In Python 3.9.0a4 or greater, according to [PEP-584](https://www.python.org/dev/peps/pep0584).

```python
z = x | y
```

In Python 3.5 or greater, this can be done by simply:

```python
z = {**x, **y}
```

In Python 2

```python
def merge_dicts(x, y):
    z = x.copy()
    z.update(y)
    return z
```


