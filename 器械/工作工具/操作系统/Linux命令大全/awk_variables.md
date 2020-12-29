# 8 个有力的 Awk 内建变量


Awk 有几个非常强力的内置变量.通常来说，分为两种类型的内置变量: - 第一种是定义的变量可以改变,　比如字段分隔(FS)与记录分隔(RS) - 第二种是可以用来数据处理或者数据总结，比如记录数(NR)与字段数目(NF) 文中 介绍了: FS,OFS, RS, ORS, NR, NR, FNR

## FS: 输入字段分隔符变量
FS(Field Separator) 读取并解析输入文件中的每一行时，默认按照空格分隔为字段变量,$1,$2...等。FS 变量被用来设置每一记录的字段分隔符号。FS 可以是任意的字符串或者正则表达式.你可以使用下面两种方式来声名FS:

* 使用 -F 命令选项或者作为设置为普通变量使用
    ```bash
    语法:

    $ awk -F 'FS' 'commands' inputfilename

    或者

    $ awk 'BEGIN{FS="FS";}'
    ```
    FS 可以是任意字符或者正则表达式

    FS 可以多次改变, 不过会保持不变直到被明确修改。不过如果想要改变字段分隔符,　最好是在读入文本之前就改变 FS, 这样改变才会在你读入的文本生效。

* 下面是一个使用 FS 读取 /etc/passwd 以 : 作为分隔符的例子
    ```bash
    $ cat etc_passwd.awk
    BEGIN{
    FS=":";
    print "Name\tUserID\tGroupID\tHomeDirectory";
    }
    {
        print $1"\t"$3"\t"$4"\t"$6;
    }
    END {
        print NR,"Records Processed";
    }
    ```
    使用结果:
    ```bash
    $ awk -f etc_passwd.awk /etc/passwd
    Name    UserID  GroupID        HomeDirectory
    gnats    41    41    /var/lib/gnats
    libuuid    100    101    /var/lib/libuuid
    syslog    101    102    /home/syslog
    hplip    103    7    /var/run/hplip
    avahi    105    111    /var/run/avahi-daemon
    saned    110    116    /home/saned
    pulse    111    117    /var/run/pulse
    gdm    112    119    /var/lib/gdm
    8 Records Processed
    ```

## OFS: 输出字段分隔符变量

OFS(Output Field Separator) 相当与输出上的 FS, 默认是以一个空格字符作为输出分隔符的，下面是一个 OFS 的例子:
```bash
$ awk -F':' '{print $3,$4;}' /etc/passwd
41 41
100 101
101 102
103 7
105 111
110 116
111 117
112 119
```
注意命令中的 print 语句的, 表示的使用一个空格连接两个参数，也就是默认的OFS的值。因此 OFS 可以像下面那样插入到输出的字段之间:
```bash
$ awk -F':' 'BEGIN{OFS="=";} {print $3,$4;}' /etc/passwd
41=41
100=101
101=102
103=7
105=111
110=116
111=117
112=11
```

## RS: 记录分隔符

RS(Record Separator)定义了一行记录。读取文件时，默认将一行作为一条记录。 下面的例子以 student.txt 作为输入文件，记录之间用两行空行分隔，并且每条记录的每个字段用一个换行符分隔:
```bash
$ cat student.txt
Jones
2143
78
84
77

Gondrol
2321
56
58
45

RinRao
2122
38
37
65

Edwin
2537
78
67
45

Dayan
2415
30
47
20
```
然后下面的脚本就会从student.txt输出两项内容:
```bash
$ cat student.awk
BEGIN {
    RS="\n\n";
    FS="\n";
}
{
    print $1,$2;
}
$ awk -f student.awk  student.txt
Jones 2143
Gondrol 2321
RinRao 2122
Edwin 2537
Dayan 2415
```
在 student.awk 中，把每个学生的详细信息作为一条记录，　这是因为RS(记录分隔符)是被设置为两个换行符。并且因为 FS (字段分隔符)是一个换行符，所以一行就是一个字段。

## ORS: 输出记录分隔符变量

ORS(Output Record Separator)顾名思义就相当与输出的 RS。 每条记录在输出时候会用分隔符隔开，看下面的 ORS 的例子:
```bash
$  awk 'BEGIN{ORS="=";} {print;}' student-marks
Jones 2143 78 84 77=Gondrol 2321 56 58 45=RinRao 2122 38 37 65=Edwin 2537 78 67 45=Dayan 2415 30 47 20=
```
上面的脚本，输入文件的每条记录被 = 分隔开。 附:student-marks 便是上面的输出.


## NR: 记录数变量

NR(Number of Record) 表示的是已经处理过的总记录数目，或者说行号(不一定是一个文件，可能是多个)。下面的例子，NR 表示行号，在 END 部分，NR 就是文件中的所有记录数目。
```bash
$ awk '{print "Processing Record - ",NR;}END {print NR, "Students Records are processed";}' student-marks
Processing Record -  1
Processing Record -  2
Processing Record -  3
Processing Record -  4
Processing Record -  5
5 Students Records are processed
```

## NF:一条记录的记录数目

NF(Number for Field)表示的是，一条记录的字段的数目.　它在判断某条记录是否所有字段都存在时非常有用。 让我们观察 student-mark 文件如下:
```bash
$ cat student-marks
Jones 2143 78 84 77
Gondrol 2321 56 58 45
RinRao 2122 38 37
Edwin 2537 78 67 45
Dayan 2415 30 47
```
接着下面的Awk程序，打印了记录数(NR),以及该记录的字段数目: 因此可以非常容易的发现那些数据丢失了。
```bash
$ awk '{print NR,"->",NF}' student-marks
1 -> 5
2 -> 5
3 -> 4
4 -> 5
5 -> 4
```


## FILENAME: 当前输入文件的名字
FILENAME 表示当前正在输入的文件的名字。 AWK 可以接受读取很多个文件去处理。看下面的例子:
```bash
$ awk '{print FILENAME}' student-marks
student-marks
student-marks
student-marks
student-marks
student-marks
```
在输入的文件的每一条记录都会输出该名字。

## FNR: 当前输入文件的记录数目

当awk读取多个文件时，NR 代表的是当前输入所有文件的全部记录数，而 FNR 则是当前文件的记录数。如下面的例子:
```bash
$ awk '{print FILENAME, "FNR= ", FNR,"  NR= ", NR}' student-marks bookdetails
student-marks FNR=  1   NR=  1
student-marks FNR=  2   NR=  2
student-marks FNR=  3   NR=  3
student-marks FNR=  4   NR=  4
student-marks FNR=  5   NR=  5
bookdetails FNR=  1   NR=  6
bookdetails FNR=  2   NR=  7
bookdetails FNR=  3   NR=  8
bookdetails FNR=  4   NR=  9
bookdetails FNR=  5   NR=  10
```
附: bookdetails 与 student-marks 内容一样，作例子. 可以看出来 NR 与 FNR 的区别。

经常使用 NR 与 FNR 结合来处理两个文件，比如有两个文件:
```bash
$ cat a.txt
李四|000002
张三|000001
王五|000003
赵六|000004

$ cat b.txt
000001|10
000001|20
000002|30
000002|15
000002|45
000003|40
000003|25
000004|60
```
如果想作对应的话,　比如张三|000001|10
```bash
$ awk -F '|' 'NR == FNR{a[$2]=$1;} NR>FNR {print a[$1],"|", $0}' a.txt b.txt
张三 | 000001|10
张三 | 000001|20
李四 | 000002|30
李四 | 000002|15
李四 | 000002|45
王五 | 000003|40
王五 | 000003|25
赵六 | 000004|60
```
