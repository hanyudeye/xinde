[ 文档路径 ](/home/wuming/doc/EasyAdminDoc/SUMMARY.md)
# 简介
## 伪静态配置
  设置服务器的配置，不同服务器不一样，目的都是把 index.php 入口文件隐藏

## 架构总览

```dotenv
EasyAdmin项目目录
├── addons                     //插件存放目录
├── app                        //应用目录
│   ├── admin                 //后台管理应用模块
│   │   ├── config           //后台配置项目录
│   │   ├── controller       //后台控制器目录
│   │   ├── middleware       //后台中间件目录
│   │   ├── model            //后台模型目录
│   │   ├── service          //后台服务类目录
│   │   ├── traits           //后台trait目录
│   │   ├── view             //后台视图目录
│   ├── common                //通用应用模块
│   ├── BaseController.php    //控制器基础类
│   ├── common.php            //应用公共文件
│   ├── event.php             //事件定义文件
│   ├── ExceptionHandle.php   //应用异常处理类
│   ├── middleware.php        //全局中间件定义文件
│   ├── provider.php          //容器Provider定义文件
│   ├── Request.php           //应用请求对象类
├── config                     //配置项目录
├── public
│   ├── static
│   │   ├── admin            //后台静态资源
│   │   │    ├── css        //后台自义定CSS
│   │   │    ├── fonts      //后台自义定字体
│   │   │    ├── images     //后台相关图片资源
│   │   │    ├── js         //后台js, 与后台控制器是一一对应的
│   │   ├── common           //公共资源
│   │   ├── plugs            //插件资源
│   └── uploads               //上传文件目录
│   ├── index.php             //应用入口主文件
│   └── router.php
├── route                      //路由目录  
├── runtime                    //缓存目录    
├── vendor                     //Compposer资源包位置
│   ├── zhongshaofa
│   │   ├── easy-addons      //插件扩展
│   │   ├── easy-admin       //后台扩展
├── view
│   │   ├── index    //前台视图页面
├── LICENSE
├── README.md
├── easyadmin.sql              //数据库安装文件
├── build.php                    
├── composer.json              //Composer包配置
└── think
```


# 表名规范

> 好的表命名规范会让你开发起来更加心情开朗，下面是一些建议：

### 命名规则 `前缀 + 模块名 + 表标识`

 * 例如`系统`模块：
    * ea_system_admin
    * ea_system_config
 * 例如`博客`模块：
    * ea_blog_user
    * ea_blog_config
    
#字段规范

* 字段名使用`下划线风格`
* 字段一定要清晰, 尽量`避免使用缩写`命名
* `create_time`、`update_time`、`delete_time`三个字段以int类型保存时间信息


# CURD命令大全

`EasyAdmin`框架以内置快速生成CURD的命令, 包括控制器、视图、模型、JS文件。能够使开发者效率得到进一步提升。

> 备注：在进行CURD命令行之前, 请按照规范设计表结构, 请参数`表结构规范`模块说明。

## 常用命令

```shell
# 生成ea_test_goods表的CURD
php think curd -t test_goods

# 生成ea_test_goods表的CURD, 文件冲突时强制覆盖
php think curd -t test_goods -f 1

# 删除ea_test_goods表的CURD
php think curd -t test_goods -d 1

# 生成ea_test_goods表的CURD, 控制器在目录demo下的Goods.php文件
php think curd -t test_goods -c demo/Goods

# 生成ea_test_goods表的CURD, 模型在目录demo下的Goods.php文件
php think curd -t test_goods -m demo/Goods

# 生成ea_test_goods表的CURD, 并关联ea_test_cate表, 并设置外键为cate_id
php think curd -t test_goods -r test_cate --foreignKey=cate_id --primaryKey=id

# 生成ea_test_goods表的CURD, 并关联ea_test_cate表, 并设置只显示title,image两个字段
php think curd -t test_goods -r test_cate --foreignKey=cate_id --relationOnlyFileds=title,image

# 生成ea_test_goods表的CURD, 并关联ea_test_cate表, 并设置主表外键cate_id在表单的下拉选择显示的关联表的title字段
php think curd -t test_goods -r test_cate --foreignKey=cate_id --relationBindSelect=title

# 生成ea_test_goods表的CURD, 并设置logo字段后缀为单图片
php think curd -t test_goods --imageFieldSuffix=logo

# 生成ea_test_goods表的CURD, 并设置忽略remark, stock字段
php think curd -t test_goods --ignoreFields=remark --ignoreFields=stock
```

## 参数介绍

| 短参 | 长参 | 说明 | 
| --- | --- |--- |
| -t | --table=VALUE | 主表名 |
| -c | --controllerFilename=VALUE | 控制器文件名 |
| -m | --modelFilename=VALUE | 主表模型文件名 |
| -f | --force=VALUE | 强制覆盖模式 |
| -d | --delete=VALUE | 删除模式 |
|  | --checkboxFieldSuffix=VALUE | 复选框字段后缀 |
|  | --radioFieldSuffix=VALUE | 单选框字段后缀 |
|  | --imageFieldSuffix=VALUE | 单图片字段后缀 |
|  | --imagesFieldSuffix=VALUE | 多图片字段后缀 |
|  | --fileFieldSuffix=VALUE | 单文件字段后缀 |
|  | --filesFieldSuffix=VALUE | 多文件字段后缀 |
|  | --dateFieldSuffix=VALUE | 时间字段后缀 |
|  | --switchFields=VALUE | 开关的字段 |
|  | --selectFileds=VALUE | 下拉的字段 |
|  | --editorFields=VALUE | 富文本的字段 |
|  | --sortFields=VALUE | 排序的字段 |
|  | --ignoreFields=VALUE | 忽略的字段 |
| -r | --relationTable=VALUE | 关联表名 |
|  | --foreignKey=VALUE | 关联外键 |
|  | --primaryKey=VALUE | 关联主键 |
|  | --relationOnlyFileds=VALUE | 关联模型中只显示的字段 |
|  | --relationBindSelect=VALUE | 关联模型中的字段用于主表外键的表单下拉选择 |
|  | --relationModelFilename=VALUE | 关联模型文件名 |


# 特殊字段

* 默认`开关`字段：
    * status
* 默认`忽略`字段：
    * update_time
    * delete_time

## 以特殊字符结尾的规则

* 默认`单图片`字段后缀：
    * image
    * logo
    * photo
    * icon
* 默认`多图片`字段后缀：
    * images
    * photos
    * icons
* 默认`单文件`字段后缀：
    * file
* 默认`多文件`字段后缀：
    * files
    
## 注释说明

类型和数据可以通过特殊字符进行定义, 例如：`性别 {radio} (1:男, 2:女, 0:未知)`, 代表的就是单选框, 数据集合为：`['1'=>'男','2'=>'女','0'=>'未知']`。 

### 字符说明

* 类型：
    * `{}`包起来, 例如：`{radio}`
* 数据集：
    * `()`包起来, 例如：`(1:男, 2:女, 0:未知)`
    

### 类型大全

| 类型 | 说明 | 备注 |
| --- | --- | ---|
| text | 普通文本框 | | 
| image | 单图片 | | 
| images | 多图片 | | 
| file | 单文件 | | 
| files | 多文件 | | 
| date | 时间组件 | 需配合`数据集`使用,时间控件类型选择 | 
| editor | 富文本 | | 
| textarea | 普通文本 | | 
| select | 下拉选择| 需配合`数据集`使用 | 
| switch | 开关组件 | 需配合`数据集`使用| 
| checkbox | 多选框 |需配合`数据集`使用 | 
| radio | 单选框|需配合`数据集`使用 | 



### 完整示例

```sql
CREATE TABLE `ea_test_goods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `sex` int(11) DEFAULT '1' COMMENT '性别 {radio} (1:男, 2:女, 0:未知)',
  `checkbox` int(11) DEFAULT '1' COMMENT '测试多选 {checkbox} (1:选择1, 2:选择2, 3:选择3)',
  `mode` int(11) DEFAULT '1' COMMENT '购买模式 {select} (1:正常购买, 2:秒杀活动)',
  `cate_id` int(11) DEFAULT NULL COMMENT '分类ID {select}',
  `title` varchar(20) NOT NULL COMMENT '商品名称',
  `logo` varchar(500) DEFAULT NULL COMMENT '商品logo {image}',
  `images` text COMMENT '商品图片 {images} (|)',
  `describe` text COMMENT '商品描述',
  `market_price` decimal(10,2) DEFAULT '0.00' COMMENT '市场价',
  `discount_price` decimal(10,2) DEFAULT '0.00' COMMENT '折扣价',
  `sales` int(11) DEFAULT '0' COMMENT '销量',
  `virtual_sales` int(11) DEFAULT '0' COMMENT '虚拟销量',
  `stock` int(11) DEFAULT '0' COMMENT '库存',
  `total_stock` int(11) DEFAULT '0' COMMENT '总库存',
  `test_datetime` datetime DEFAULT NULL COMMENT '测试完整时间{date}(datetime)',
  `up_date` datetime DEFAULT NULL COMMENT '上架时间{date}(date)',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) unsigned DEFAULT '1' COMMENT '状态 {radio} (0:禁用,1:启用)',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注说明',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `delete_time` int(11) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `cate_id` (`cate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='商品列表';
```

```sql
CREATE TABLE `ea_test_cate` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(20) NOT NULL COMMENT '分类名',
  `image` varchar(500) DEFAULT NULL COMMENT '分类图片 {image}',
  `sort` int(11) DEFAULT '0' COMMENT '排序 {sort}',
  `status` tinyint(1) unsigned DEFAULT '1' COMMENT '状态 {switch} (0:禁用,1:启用)',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注说明',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `delete_time` int(11) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='商品分类';
```


# 图片上传
三个地方的cover 都要改

``` html
<div class="layui-form-item">
<label class="layui-form-label required">用户头像</label>
<div class="layui-input-block layuimini-upload">
<input name="cover" class="layui-input layui-col-xs6" lay-reqtext="请上传用户头像" placeholder="请上传用户头像" value="{$row.cover|default=''}">
<div class="layuimini-upload-btn">
<span><a class="layui-btn" data-upload="cover" data-upload-number="one" data-upload-exts="png|jpg|ico|jpeg"><i class="fa fa-upload"></i> 上传</a></span>
<span><a class="layui-btn layui-btn-normal" id="select_head_img" data-upload-select="cover" data-upload-number="one"><i class="fa fa-list"></i> 选择</a></span>
</div>
</div>
</div>
```


# 必看基础信息

系统做了一些封装，先查看此文档会有效解决你的疑问

#后台控制器与JS的绑定

* 控制器中JS的目录对应为：`public/static/admin/js`
* 文件命名为: `小写+下划杠`
* `控制器`的每一个`方法`对应JS的`Controller`对象的一个`属性`
* 每一个JS文件都需要引入`admin`模块，并执行监听` ea.listen();`;

> 例子

* 控制器对应的PHP文件`app/admin/controller/mall/Cate.php`
* 控制器对应的JS文件`public/static/admin/js/mall/cate.js`
* 每一个控制里面的`方法`对应js里面的`属性`就会自动进行加载

```js
define(["jquery", "easy-admin"], function ($, ea) {

    var init = {
        table_elem: '#currentTable',
        table_render_id: 'currentTableRenderId',
        index_url: 'mall.cate/index',
        add_url: 'mall.cate/add',
        edit_url: 'mall.cate/edit',
        del_url: 'mall.cate/del',
        export_url: 'mall.cate/export',
        modify_url: 'mall.cate/modify',
    };

    var Controller = {

        index: function () {
            ea.table.render({
                init: init,
                modifyReload: true,
                cols: [[
                    {type: "checkbox"},
                    {field: 'id', width: 80, title: 'ID'},
                    {field: 'sort', width: 80, title: '排序', edit: 'text'},
                    {field: 'title', minWidth: 80, title: '分类名称'},
                    {field: 'image', minWidth: 80, title: '分类图片', search: false, templet: ea.table.image},
                    {field: 'remark', minWidth: 80, title: '备注信息'},
                    {field: 'status', title: '状态', width: 85, search: 'select', selectList: {0: '禁用', 1: '启用'}, filter: 'status', templet: ea.table.switch},
                    {field: 'create_time', minWidth: 80, title: '创建时间', search: 'range'},
                    {
                        width: 250,
                        title: '操作',
                        templet: ea.table.tool,
                        operat: ['edit', 'delete']
                    }
                ]],
            });

            ea.listen();
        },
        add: function () {
            ea.listen();
        },
        edit: function () {
            ea.listen();
        },
    };
    return Controller;
});
```
