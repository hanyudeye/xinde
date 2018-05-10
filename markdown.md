*简单的标签实现格式化的文档, 兼容HTML*
# 区块元素
## 段落和换行
## 标题
1. 底线形式 (只有两阶)
如 这是标题
//============
或
这是标题
//--------

2. #形式 (可以有六阶**
### 如 这是标题

## 区块引用 >
> 这是区块引用
> 更多内容

> ## 引用中的文本格式化标题
> 内容
> 1. 列表1
> 2. 列表2

## 列表
* 无序
* 列表

+ 无序
+ 列表

1. 有序
2. 列表

列表下是段落，必须缩进1个制表符或4个空格
## 代码区块
    缩进1个制表符或4个空格
## 分隔线
***
---
# 区段元素
## 链接
行内式 [说明](http://www.baidu.com)
参考式 [说明][id] 然后定义id

[id]: http://www.baidu.com "可选标题"
## 强调
*强调* _强调_
**加强** __加强__

## 代码
`printf();`
## 图片
行内式![说明文字](/path/img.jpg)
行内式![说明文字](~/xinde/image/cname.png)
参考式![说明文字][img]
[img]:~/xinde/image/cname.png "可选说明"
## 表格
| 列1 | 列2 |
|   1 | ni  |
|   2 | hao |
# 其他
## 自动链接
<http://baidu.com>
## 转义 \
# markdown mode 
## 预览
> 快捷键 , c p 
> `(markdown :variables markdown-live-preview-engine 'vmd)`

## 生成 TOC(目录)
在文档头部
> `SPC SPC markdown-toc-generate-toc RET`


## 键盘绑定
### Element insertion

| Key Binding | Description                                                       |
| ~SPC m -~   | insert horizontal line                                            |
| ~SPC m h i~ | insert header dwim                                                |
| ~SPC m h I~ | insert header setext dwim                                         |
| ~SPC m h 1~ | insert header atx 1                                               |
| ~SPC m h 2~ | insert header atx 2                                               |
| ~SPC m h 3~ | insert header atx 3                                               |
| ~SPC m h 4~ | insert header atx 4                                               |
| ~SPC m h 5~ | insert header atx 5                                               |
| ~SPC m h 6~ | insert header atx 6                                               |
| ~SPC m h !~ | insert header setext 1                                            |
| ~SPC m h @~ | insert header setext 2                                            |
| ~SPC m i l~ | insert inline link dwim                                           |
| ~SPC m i L~ | insert reference link dwim                                        |
| ~SPC m i u~ | insert uri                                                        |
| ~SPC m i f~ | insert footnote                                                   |
| ~SPC m i w~ | insert wiki link                                                  |
| ~SPC m i i~ | insert image                                                      |
| ~SPC m i I~ | insert reference image                                            |
| ~SPC m i t~ | insert Table of Contents (toc)                                    |
| ~SPC m x b~ | make region bold or insert bold                                   |
| ~SPC m x i~ | make region italic or insert italic                               |
| ~SPC m x c~ | make region code or insert code                                   |
| ~SPC m x C~ | make region code or insert code (Github Flavored Markdown format) |
| ~SPC m x q~ | make region blockquote or insert blockquote                       |
| ~SPC m x Q~ | blockquote region                                                 |
| ~SPC m x p~ | make region or insert pre                                         |
| ~SPC m x P~ | pre region                                                        |


*### Element removal

| Key Binding | Description         |
| ~SPC m k~   | kill thing at point |

### Completion

| Key Binding | Description |
|-------------|-------------|
| ~SPC m ]~   | complete    |

### Following and Jumping

| Key Binding | Description           |
|-------------|-----------------------|
| ~SPC m o~   | follow thing at point |
| ~SPC m j~   | jump                  |

### Indentation

| Key Binding | Description   |
|-------------|---------------|
| ~SPC m \>~  | indent region |
| ~SPC m \<~  | exdent region |

### Header navigation

| Key Binding | Description                  |
|-------------|------------------------------|
| ~gj~        | outline forward same level   |
| ~gk~        | outline backward same level  |
| ~gh~        | outline up one level         |
| ~gl~        | outline next visible heading |

### Buffer-wide commands

| Key Binding | Description                                                                          |
|-------------|--------------------------------------------------------------------------------------|
| ~SPC m c ]~ | complete buffer                                                                      |
| ~SPC m c m~ | other window                                                                         |
| ~SPC m c p~ | preview                                                                              |
| ~SPC m c P~ | live preview using engine defined with layer variable =markdown-live-preview-engine= |
| ~SPC m c e~ | export                                                                               |
| ~SPC m c v~ | export and preview                                                                   |
| ~SPC m c o~ | open                                                                                 |
| ~SPC m c w~ | kill ring save                                                                       |
| ~SPC m c c~ | check refs                                                                           |
| ~SPC m c n~ | cleanup list numbers                                                                 |
| ~SPC m c r~ | render buffer                                                                        |

### List editing

| Key Binding | Description      |
|-------------|------------------|
| ~SPC m l i~ | insert list item |

### Movement

| Key Binding | Description        |
|-------------|--------------------|
| ~SPC m {~   | backward paragraph |
| ~SPC m }~   | forward paragraph  |
| ~SPC m N~   | next link          |
| ~SPC m P~   | previous link      |

### Promotion, Demotion

| Key Binding | Description        |
|-------------|--------------------|
| ~M-k~       | markdown-move-up   |
| ~M-j~       | markdown-move-down |
| ~M-h~       | markdown-promote   |
| ~M-l~       | markdown-demote    |

### Toggles

| Key Binding | Description          |
|-------------|----------------------|
| ~SPC m t i~ | toggle inline images |
| ~SPC m t l~ | toggle hidden urls   |
| ~SPC m t t~ | toggle checkbox      |
| ~SPC m t w~ | toggle wiki links    |
