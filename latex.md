## LaTeX [排版]
### 排版属性
#### 排版类型
article book  report
#### 页面大小
a4paper
#### 特殊字符  [转义 \]
$
%
&
#
#### 多语言 [包，选字体]
##### 包
\usepackage[T5]{fontenc}

中日韩
usepackage{CJKutf8}  
\begin{CJK}{UTF8}
\end{CJK} 

```tex
\documentclass[a4paper]{article}
\usepackage{CJKutf8}

\begin{document}

\begin{CJK}{UTF8}{min}
この記事を読んでいただきありがとうございます。
%Thank you for reading this article.
\end{CJK} 

\end{document}
```
##### 选字体
```tex
\documentclass[a4paper]{article}

\usepackage{fontspec}
\usepackage{polyglossia}
%\setmainfont[]{DejaVu Serif}

\begin{document}

Xin chào thế giới. This is Hello World in Vietnamese.

\end{document}
```


### 命令
#### 构建
## 结构
### 文档
```tex
\documentclass[a4paper]{article}

\begin{document}

Hello World !  % This is your content

\end{document}
```

### 列表
* 无序列表
```tex
\begin{itemize}
\item Item.
\item Another Item.
\end{itemize}

```  
* 有序列表

```tex
\begin{enumerate}
\item First Item.
\item Second Item.
\end{enumerate}
```
### 段落与部分
\section 部分
\paragraph段落
\subsection小节
\subparagraph 小段落

![](http://i.imgur.com/qKbZYnG.png)

### 目录
\tableofcontents
\newpage
![](http://i.imgur.com/TBUOTRj.png)

### 脚注
```tex
Hi let me introduce myself\footnote{\label{myfootnote}Hello footnote}.
... (later on)
I'm referring to myself \ref{myfootnote}.
```
![](http://i.imgur.com/BSYPX4C.png)

\newline换行

## 包
\usepackage
![](http://i.imgur.com/050nrfh.png)

甚至可以用来绘制电路图:

![](http://i.imgur.com/If4lbLA.png)

:construction: 你需要用谷歌搜索更多的包来满足你的需求。例如: amsmath 含有大量数学格式拓展并被广泛用于数学学科，circuitikz 用于电路设计等等。。。这篇通用的指南无法将这些知识全部覆盖。

## 表格

一个实际的例子:

```tex
\begin{table}[h!]
  \centering
  \caption{Caption for the table.}
  \label{tab:table1}
  \begin{tabular}{l|c||r}
    1 & 2 & 3\\
    \hline
    a & b & c\\
  \end{tabular}
\end{table}
```

:star2: 这是它显示的样式 :star2: :

![](http://i.imgur.com/XbZJJ2E.png)

现在让我们再回顾一下 :eyes: :

* 对于表格，首先我们需要一个以 `\begin{table}` 开头和  `\end{table}` 结尾的表格环境(a table environment)。
* 你将在图像章节学习有关 h! 内容。它可以让你通过 `\centering` 命令使表格保持在页面中央。
* Caption 是用来描述。 Label 用来标记。 你将在图像章节再来学习这些。
* Tabular 是最重要的部分。表格环境中往往需要包含一个 tabular 环境。
  - 我们用 `{l|c||r}` 来控制表格的内部样式。这里我们发现：
    * l , c , r 表示单元格内容是左对齐，居中，或右对齐的。
    * 竖线 | 和 || 实际上是控制表格列中垂直线的边框格式。
  - 1 & 2 & 3 => 1 2 3 是单元格的内容， & 用来分隔每行中的单元格内容。
  -  `\hline` 实际上是用来添加一个水平线在两行之间用来分隔。

:bangbang: **小技巧** 你可以使用一个名叫 booktabs 的包 :package: 来获得更好的视觉效果。

## 添加图像

若想在 LaTeX 文件中添加图像，你需要使用图形环境和 graphicx 包。使用  `\usepackage{graphicx}` 和

```tex
\begin{figure}
  \includegraphics[width=\linewidth]{filename.jpg}
  \caption{What is it about?}
  \label{fig:whateverlabel}
\end{figure}
```

:bangbang: **小技巧**: 放置 [width=\linewidth] 将图像缩放到文档的宽度。 如果你想浮动图像，那么你需要用一个特定的值给开头赋值。fig 用来在后面被引用，所以需要仔细命名。

```tex
\begin{figure}[h!]
```

:passport_control: 合法的值有:

* h (here) - 在当前位置(same location)
* t (top) - 页首(top of page)
* b (bottom) - 页尾(bottom of page)
* p (page) - 另起一页(on an extra page)
* ! (override) - 在指定位置(will force the specified location)

下图是图像呈现的样式:

![](http://i.imgur.com/ysY9MOb.png)

## 在 LaTeX 中插入代码
```tex
\documentclass[a4paper]{article}

\begin{document}

Hello world!

\begin{verbatim}
#include <iostream>

int main()
{
	std::cout << "hello world!\n";
	return 0;
}
\end{verbatim}

\end{document}
```
![](http://i.imgur.com/FJfj8Er.png)

如你所见，通过使用 **{verbatim}** 包裹，你可以轻松插入代码而不用担心语法的格式化问题。在下图中看这些是直接使用的，整洁且专业:

![](http://i.imgur.com/tpercup.png)


这种方法让你有更多的选择，比如:插入代码**内联**,使用**自定义样式**的代码，选择**
特定代码语言**,**从**同一目录(the same directory)中的其他文件**导入代码**...使用
这个方法时，你无需使用 **{verbatim}** ，而需要包含名叫 **listings** 的包
:package: 。

思考下面这个样例：
```tex
\documentclass[a4paper]{article}

\usepackage{listings}
\usepackage{color}

\lstdefinestyle{mystyle}{
keywordstyle=\color{magenta},
backgroundcolor=\color{yellow},
commentstyle=\color{green},
basicstyle=\footnotesize,
}
\lstset{style=mystyle}

\begin{document}
Hello world!
\begin{lstlisting}[language=Python]

print "Hello World!"

\end{lstlisting}

\lstinputlisting[language=C++]{hello.cpp}

Lorem ipsum dolor sit amet \lstinline{print "Hello World"} , consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.


\end{document}

```
从这个例子中，你会发现:

1. 插入的代码块，从 `\begin{lstlisting}` 开始，以 `\end{lstlisting}` 结束。
2. 你可以使用 `lstinputlisiting{name_of_file}` 来从同一目录(the same directory)下导入另一个文件的代码。
3. 用 `[language=C++]` 来指定使用的语言。
4. 想插入内联代码需要使用 `\lstinline`。
5. 想应用自定义样式，需要使用 `\usepackage{color}` 然后用你自己的主题定义列表(请看下面的代码)。你可以使用自己的风格修改许多内容，但你需要阅读文档以获取正确的属性名称。
6.  感兴趣？？查看[更多内容](https://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings)。

以下是 TexMaker 中的代码如何编译的:

![](http://i.imgur.com/XwwDJNo.png)

## LaTeX 中分割文件

当我们使用 LaTeX 时，我们可能因为一个文档太长而无法处理。因此，我们应该分割文件，使其内容可以轻松的处理。

让我们看这个例子:

```tex
% main.tex
\documentclass[a4paper]{article}

\begin{document}

Hello Latex, This is my first part.

Hello Latex, This is my second part.

\end{document}
```

这只是一个普通的 LaTeX 文件，让我们用 `\input` 关键字来将文件分成两个部分：

```tex
% main.tex
\documentclass[a4paper]{article}

\begin{document}

Hello Latex, This is my first part.

\input{second_file}

\end{document}
```


```tex
% second_file.tex
Hello Latex, This is my second part.
```

现在，主文件看起来有些不同，当文件被更好地组织了。在 TexMaker 中的结果如下：

[![multi_file.png](https://s14.postimg.org/deg0kqhu9/multi_file.png)](https://postimg.org/image/hnkqmwl3h/)

:bangbang: **小技巧** : 为了具有可读，清晰，便于维护的目的，强烈建议你将主文件系统性的，分级的，科学的分开。不要没有任何理由的分开，否则你会在以后感到困惑。


## 安装
1. sudo apt-get install texlive-latex-base

2.这样就安装好Latex了，可以直接使用。 但编译中文时，由于没有安装CJK中文环境，会提示找不到CJK包。
apt-cache search cjk, 有许多关于CJK 环境的包。
选择安装latex-cjk-all, 它的描述是：Installs all LaTex CJK packages.
sudo apt-get install latex-cjk-all
这样就可以使用中文环境了。

3.有些.sty文件可能没有安装，例如：lastpage.sty. 这个时候不要到网络上去询问是因为什么， Latex的输出错误信息已经很明显了。
使用下面的命令来查找相应的包：
apt-cache search lastpage (注意不要加.sty文件后缀)
可以看到需要下面的包，以及对这个包的描述：
texlive-latex-extra - TeX Live: LaTeX supplementary packages
选择安装即可：
sudo apt-get install texlive-latex-extra

完成上面的这三步，就可以完全满足我平时的应用需求了。 如果以后需要使用到新的包，可以使用上面第三步的方法来查找相应的安装包，并选择安装即可。

4.sudo apt-get install texmaker
安装texmaker程序，它是一个图形化界面的Tex书写，编译，生成，预览集合为一体的程序。 与Windows操作系统中的WinTex界面很相似。
 
//为了使用xelatex
5.sudo apt-get install texlive-xetex 
Texlive-publishers包也可以安装一下， support for publishers, theses, standards, conferences, etc.

6.下sudo apt-get install texlive-publishers
使用apt-cache show texlive-publishers命令可以看到它所支持的CTAN包的信息。
texmaker中编辑中文

第一步:
picture
第二步(很关键很关键)
要输出中文最重要的就是以下两句：

\usepackage{xeCJK} //这句话很关键很关键
\setCJKmainfont{自己电脑上有的字体(从word中选择一个吧)}(当然这句话可以省略)
举个例子:

\documentclass{article}
\usepackage{xeCJK}
\begin{document}
你好,成功了
\end{document}

## 数学
```
 \begin{equation}
 L' = {L}{\sqrt{1-\frac{v^2}{c^2}}}
 \sum\limits_{i=1}^n(\text{单项评分}_i * \text{权重})
 \end{equation}

```
