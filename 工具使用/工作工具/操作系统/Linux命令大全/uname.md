# Linux uname命令
[返回Linux 命令目录](11.Linux命令大全.md)

Linux uname命令用于显示系统信息。

uname可显示电脑以及操作系统的相关信息。

## 语法
```bash
uname [-amnrsv][--help][--version]
```

### 参数说明：

* -a或--all 　显示全部的信息。
* -m或--machine 　显示电脑类型。
* -n或-nodename 　显示在网络上的主机名称。
* -r或--release 　显示操作系统的发行编号。
* -s或--sysname 　显示操作系统名称。
* -v 　显示操作系统的版本。
* --help 　显示帮助。
* --version 　显示版本信息。

## 实例

* 显示系统信息
    ```bash
    # uname -a
    Linux snail-hnlinux 2.6.32-21-generic #32-Ubuntu SMP Fri Apr 16 08:10:02 UTC 2010 i686 GNU/Linux
    ```

* 显示计算机类型
    ```bash
    # uname -m
    i686
    ```

* 显示计算机名
    ```bash
    # uname -n
    snail-hnlinux
    ```

* 显示操作系统发行编号
    ```bash
    # uname -r
    2.6.32-21-generic
    ```

* 显示操作系统名称
    ```bash
    # uname -s
    Linux
    ```

* 显示系统时间
    ```bash
    # uname -v
    #32-Ubuntu SMP Fri Apr 16 08:10:02 UTC 2014
    ```