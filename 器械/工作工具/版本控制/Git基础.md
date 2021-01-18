# Git基础

## Git 安装

### Git下载地址

- https://git-scm.com/downloads

### Git安装（Window/Mac）

- 选择不同系统安装包安装

### 检验是否安装成功

- 出现Git Bash命令行工具或Git GUI工具
- git --version  查看git安装版本

## Git 结构

### 工作区（Working Directory）

### 版本库（repository）

- 暂存区（stage/index）
- master

	- head唯一指向

## Git 文件的4种状态

### Untracked（未被跟踪的）

- 此文件在文件夹中, 但并没有加入到git库, 不参与版本控制. 通过git add 状态变为Staged.

### Unmodify（文件已经入库）

- 文件已经入库, 未修改, 即版本库中的文件快照内容与文件夹中完全一致. 这种类型的文件有两种去处, 如果它被修改, 而变为Modified. 如果使用git rm移出版本库, 则成为Untracked文件

### Modified（文件已修改）

- 文件已修改, 仅仅是修改, 并没有进行其他的操作. 这个文件也有两个去处, 通过git add可进入暂存staged状态, 使用git checkout 则丢弃修改过, 返回到unmodify状态, 这个git checkout即从库中取出文件, 覆盖当前修改

### Staged（暂存状态）

- 执行git commit则将修改同步到库中, 这时库中的文件和本地文件又变为一致, 文件为Unmodify状态. 执行git reset HEAD filename取消暂存, 文件状态为Modified

## Git基本命令

### git init

- 初始化git仓库
- 出现.git文件夹

### git add

- git add 

	- 将文件添加到暂存区

- git add .

	- 将工作空间下所有文件添加到暂存区（new，modifyed）

- git add -A

	- 将工作空间下所有文件添加到暂存区（new，modifyed，delete）

- git add -u

	- 将工作空间下所有文件添加到暂存区（modifyed，delete）

### git commit

- git commit -m <commit message>

	- 将暂存区的文件提交到版本库

- git commit -am <commit message>

	- 跳过git add 命令，直接将工作区所有已跟踪的文件提交到版本库，未跟踪的（untracked）文件不能使用该命令

### git status

- git status -s

### git log

- git log --graph --oneline
- git log --oneline

### git config

- git全局配置命令

	- git config --global user.name zivszheng
	- git config --global user.email zivs.zheng@gmail.com

- 查看配置

	- git config --list

- 单个项目配置

	- 项目父路径/.git/config文件

### git stash

- git stash

	- 暂存本地修改内容（不想提交修改的内容，想切换分支）

- git stash list

	- 查看暂存的历史记录

- git stash apple --index

	- 恢复之前暂存的某个记录

- git stash drop --index

	- 删除某个暂存记录

### git rm

- 用于从工作区和索引中删除文件
- 常见使用：删除已经提价到远程仓库的 .idea, .seting 文件/文件夹（项目构建自动生成的）

	- git rm -r .idea
	- git commit -m 'remove .idea'
	- git push origin master

## Git commit 解析

### commit Object/master/HEAD

- tree

	- 项目目录结构

- parent

	- 指向上一个commit Object

- author/commiter
- commit message

### 查看对象

- git cat-file -p HEAD/唯一ID
- git cat-file -t HEAD/唯一ID

## Git diff

### git diff

- 比较本地工作空间和staged区的差异

### git diff -- staged

- 比较staged区和本地仓库中的差异

### git diff HEAD

- 比较本地工作空间和本地仓库中的差异

## Git 撤销操作

### git commit --amend

- 撤销上一次提交将暂存区的文件重新提交（改写提交）

### git checkout --filename

- 拉取暂存区的文件并将其替换工作区的文件
- 注意与git checkout branchname 区别

### git reset HEAD --filename

- 拉取最近一次提交到版本库中的文件到暂存区，该操作不影响工作区

### git reset --option 版本号

- --hard

	- 硬回滚（不可逆的），即暂存区，工作区全部用指定提交版本的目录树替换掉

- --mixed

	- mixed或不使用参数，覆盖暂存区，但不覆盖工作区

- --soft

	- 软回滚，不进行暂存区和工作区的覆盖

## Git 分支

### git 分支创建、修改、删除、切换

- git branch

	- 查看分支

- git branch 

	- 创建分支

- git branch -m  

	- 修改分支名称

- git checkout 

	- 切换分支

- git checkout -b 

	- 创建并切换分支

- git branch -d 

	- 删除分支

### 分支合并

- git merge 

	- 合并指定分支到当前分支(Fast forward)

- git merge -no-ff -m <commit message>

	- 合并指定分支到当前分支(-no-ff 参数表示禁用Fast forward)

### 查看分支来自哪一个分支

- git reflog --date=local | grep <branchname>

## Git远程仓库

### git clone

- git clone http://gitlab.xqchuxing.com/gittest/xqchuxing-test.git

### git remote

- git remote -v

	- 查看远程信息

### git push

- git push -u origin master

	- 将本地上分支上推到

### git pull

- git pull origin dev:master

	- 获取远程的dev分支和本地的master分支合并

- git pull origin dev

	- 获取远程的dev分支和当前分支合并，实际是先执行git fetch 后再执行git merge

### git fetch

- git fetch origin dev

	- 获取远程dev分支但不做合并

## 关联远程仓库

### git remote add origin&nbsp;http://gitlab.xqchuxing.com/gittest/xqchuxing-test.git

## Git tag

### git tag

- 查看当前所有tag

### git tag 

- 创建tag

### git tag  

- 创建一个指向某一次提交的tag

### git tag -a  -m <message>

### git show 

- 查看tag

## Git Help

### git help

### git help <command>

### 官网文档地址  https://git-scm.com/book/zh/v2
