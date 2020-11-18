## namespace 
namespace 定义在 php文件顶部紧挨着 `<?php` 的下一行，顶级namespace必须全局唯一。

```php
<?php
namespace Oreilly;
```

sub-namespaces

```php
<?php
namespace Oreilly\ModernPHP
```

属于同个namespace的类不一定非得定义在一个文件下。可在每个文件顶部使用同一个namespace以标记这些文件在同一个命名空间下。

在php 引入 namespace之前，php开发者们使用 Zend-style 的类命名方式（源自 Zend 框架）。

即使用下划线来表示目录分隔，autoloader时自动替换下划线为当前OS的目录分隔符

```php
# Zend_Cloud_DocumentService_Adapter_WindowsAzure_Query => Zend/Cloud/DocumentService/Adapter/WindowsAzure/Query.php
```

这种方式对懒人来说的缺点就是写很多类名时太TM长了。

namespace提供了 import和 alias来解决这个问题。

import，alias 在5.3版本下支持类，接口与命名空间导入。5.6开始支持函数与常量导入。

```php
# namespace without alias
<?php
$response = new \Symfony\Component\HttpFoundation\Response('Oops',400);
$response->send();
$response2 = new \Symfony\Component\HttpFoundation\Response('Success',200);
```

```php
# namespace with alias 
use Symfony\Component\HttpFoundation\Response;
$response ＝ new Response('Oops',400);
$response->send();
```

```php
# namespace with custom alias 
use Symfony\Component\HttpFoundation\Response as Res;
$response ＝ new Res('Oops',400);
$response->send();
```

import与 alias的use与namespace的规则一样要在 php文件顶部紧挨着 `<?php` 的下一行或namespace的定义之后。

你没有必要在导入的命名空间的开始处加上`\`，php默认导入的命名空间为完全限定名称。

use关键字必须存在于全局作用域，因为它是在编译时被处理。

5.6之后可以导入函数与常量示例：

```php
<?php
use func Namespace\functionName;
functionName();
```

```php
<?php
use constant Namespace\CONST_NAME;
echo CONST_NAME;
```
多个namespace在一个文件中（这种做法极度不推荐）

```php
<?php
namespace Foo{

}

namespace Bar{

}
```

若没有附带namespace的调用类，方法或常量。php会默认这些属于当前命名空间下。

如果想指定namespace，则要使用完全限定名称来调用，或使用use来导入。

```php
<?php
namespace My\App
＃ Unqualified class name inside another namespace
class Foo {
    public function doSomething() {
        $exception = new Exception(); // php will search \My\App\Exception
    }
}
```

```php
<?php
namespace My\App
＃ Qualified class name inside another namespace
class Foo {
    public function doSomething() {
        $exception = new \Exception(); // php will search \Exception
    }
}
```

[namespace 官方手册参考](http://php.net/manual/en/language.namespaces.php) 

PS：中文版手册该章节有错误，请以英文版为准。
## Interface
无规矩不成方圆。你如果有一组类有类似的“行为”，需要对他们进行约束的话，接口就必不可少了。

只要定好规范，任第三份随意实现其代码。但是调用逻辑是不变的。

所以即使以后更换组件，只要其正确实现了所需接口，逻辑层代码都不需要变化。

```php
### Example
class DocumentStore {
    protected $data = [];
    public function addDocument(Documentable $document) {
        $key = $document->getId();
        $value = $document->getContent();
        $this->data[$key] = $value;
    }
    public function getDocuments() {
        return $this->data; 
    }
}

interface Documentable {
    public function getId(); 
    public function getContent();
}

class HtmlDocument implements Documentable {
    protected $url;
    public function __construct($url) {
        $this->url = $url;
    }
    public function getId() {
        return $this->url; 
    }
    public function getContent() {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_MAXREDIRS, 3);
        $html = curl_exec($ch);
        curl_close($ch);
        return $html; 
    }
}

class StreamDocument implements Documentable {
    protected $resource; protected $buffer;
    public function __construct($resource, $buffer = 4096) {
        $this->resource = $resource;
        $this->buffer = $buffer;
    }
    public function getId() {
        return 'resource-' . (int)$this->resource; 
    }
    public function getContent() {
        $streamContent = ''; rewind($this->resource);
        while (feof($this->resource) === false) {
            $streamContent .= fread($this->resource, $this->buffer);
        }
        return $streamContent; 
    }
}

class CommandOutputDocument implements Documentable {
    protected $command;
    public function __construct($command) {
        $this->command = $command;
    }
    public function getId() {
        return $this->command; 
    }
    public function getContent() {
        return shell_exec($this->command); 
    }
}

$documentStore = new DocumentStore();
// Add HTML document
$htmlDoc = new HtmlDocument('https://php.net'); 
$documentStore->addDocument($htmlDoc);
// Add stream document
$streamDoc = new StreamDocument(fopen('stream.txt', 'rb')); 
$documentStore->addDocument($streamDoc);


// Add terminal command document
$cmdDoc = new CommandOutputDocument('cat /etc/hosts'); 
$documentStore->addDocument($cmdDoc);
print_r($documentStore->getDocuments());
```

5.4 新加入了 Traits特性，它既不是接口也不是类。主要是为了解决单继承语言的限制。与 Ruby 的 `composable modules` 或 `mixins` 类似。

它能被加入到一个或多个已经存在的类中。它声明了类能做什么（表明了其接口特性），同时也包含了具体实现（表明了其类特性）

Example:

```php
<?php
trait Geocodable {
    /** @var string */
    protected $address;
    /** @var \Geocoder\Geocoder */
    protected $geocoder;
    /** @var \Geocoder\Result\Geocoded */
    protected $geocoderResult;
    public function setGeocoder(\Geocoder\GeocoderInterface $geocoder) {
        $this->geocoder = $geocoder;
    }
    public function setAddress($address) {
        $this->address = $address;
    }
    public function getLatitude(){
        if (isset($this->geocoderResult) === false) {
            $this->geocodeAddress();
        }
        return $this->geocoderResult->getLatitude(); 
    }
    public function getLongitude() {
        if (isset($this->geocoderResult) === false) { 
            $this->geocodeAddress();
        }
        return $this->geocoderResult->getLongitude(); 
    }
    protected function geocodeAddress() {
        $this->geocoderResult = $this->geocoder->geocode($this->address); 
        return true;
    } 
}
```

```php
<?php
class RetailStore {
    use Geocodable;
    // Class implementation goes here
    // Now each RetailStore instance can use the properties and methods provided by the Geocodable trait
}
```

```php
$geocoderAdapter = new \Geocoder\HttpAdapter\CurlHttpAdapter(); 
$geocoderProvider = new \Geocoder\Provider\GoogleMapsProvider($geocoderAdapter); 
$geocoder = new \Geocoder\Geocoder($geocoderProvider);
$store = new RetailStore();
$store->setAddress('420 9th Avenue, New York, NY 10001 USA'); 
$store->setGeocoder($geocoder);
$latitude = $store->getLatitude(); 
$longitude = $store->getLongitude(); 
echo $latitude, ':', $longitude;
```

PHP解释器将在编译时期将 Traits 的代码拷贝到类中。

从基类继承的成员被 traits 插入的成员所覆盖。

优先顺序是来自当前类的成员方法覆盖了 trait 的方法，而 trait 的方法则覆盖了被继承的方法。

如果两个 trait 都插入了一个同名的方法，如果没有明确解决冲突将会产生一个致命错误。

为了解决多个 trait 在同一个类中的命名冲突，可以使用 insteadof 操作符来明确指定使用冲突方法中的哪一个。

或者使用 as 操作符可以将其中一个冲突的方法以另一个名称来引入。

```
<?php
trait A {
    public function smallTalk() {
        echo 'a';
    }
    public function bigTalk() {
        echo 'A';
    }
}

trait B {
    public function smallTalk() {
        echo 'b';
    }
    public function bigTalk() {
        echo 'B';
    }
}

class Talker {
    use A, B {
        B::smallTalk insteadof A;
        A::bigTalk insteadof B;
    }
}

class Aliased_Talker {
    use A, B {
        B::smallTalk insteadof A;
        A::bigTalk insteadof B;
        B::bigTalk as talk;
    }
}
?>
```

使用 as 语法还可以用来调整方法的访问控制权限。

```php
<?php
trait HelloWorld {
    public function sayHello() {
        echo 'Hello World!';
    }
}

// 修改 sayHello 的访问控制
class MyClass1 {
    use HelloWorld { sayHello as protected; }
}

// 给方法一个改变了访问控制的别名
// 原版 sayHello 的访问控制则没有发生变化
class MyClass2 {
    use HelloWorld { sayHello as private myPrivateHello; }
}
?>
```

## generators
php 5.5之后引入了 generators。

与 php传统的迭代器不同，generators不仅不需要你实现繁重的迭代器接口，而且还能按需求值，提高性能，特别是在数据量大的时候。

generators 也并非灵丹妙药。除非你调用，否则它并不知道下一次迭代的值。并且整体只能迭代一次（需要重新迭代则必须重建generators）。

Example:

```php
<?php
function myGenerator() {
    yield 'value1'; 
    yield 'value2'; 
    yield 'value3';
}
```

调用该迭代器函数，php将返回一个与之关联的对象（建立了generators）。

该对象可被foreach之类的函数迭代，每次迭代 generators 将提供一个具体的值（停留在下一个 yield 之前）。

```php
<?php
foreach (myGenerator() as $yieldedValue) {
    echo $yieldedValue, PHP_EOL; 
}

// This outputs:
//    value1
//    value2
//    value3
```

之前迭代器的解决方案：

```php
<?php
function makeRange($length) {
    $dataset = [];
    for ($i = 0; $i < $length; $i++) {
        $dataset[] = $i;
    }
    return $dataset; 
}
$customRange = makeRange(1000000); 
foreach ($customRange as $i) {
    echo $i, PHP_EOL; 
}
```

generators 的解决方案：

```php
<?php
function makeRange($length) {
    for ($i = 0; $i < $length; $i++) { 
        yield $i;
    } 
}
foreach (makeRange(1000000) as $i) { 
    echo $i, PHP_EOL;
}
```

## 闭包与匿名函数
闭包与匿名函数在 php 5.3 之后被引入。

闭包指的是一种函数保留外部变量（创建该函数时外部变量的值）的技术。一般作为回调函数使用。

Example:

```php
<?php
$message = 'hello';

$example = function () {
    var_dump($message); // NULL
};
echo $example();

$example = function () use ($message) {
    var_dump($message); // hello
};
echo $example();

// Inherited variable's value is from when the function
// is defined, not when called
$message = 'world';
echo $example(); // also hello

// Reset message
$message = 'hello';

// Inherit by-reference
$example = function () use (&$message) {
    var_dump($message);
};
echo $example();

// The changed value in the parent scope
// is reflected inside the function call
$message = 'world';
echo $example(); // world

// Closures can also accept regular arguments
$example = function ($arg) use ($message) {
    var_dump($arg . ' ' . $message);
};
$example("hello"); // "hello world"
?>
```

闭包和匿名函数（其实就是没定义名字的函数）是不同的东西，但在PHP里他们是一样的。

匿名函数赋值给变量后，创建了closure对象(每个闭包都是一个 closure 对象实例)，

其实现了 invoke 魔术方法，所以可以通过直接调用变量名来调用该匿名函数。

[js与php闭包对比](http://stackoverflow.com/questions/7417430/javascript-closures-vs-php-closures-whats-the-difference)


## opcache 
opcache 是 php 5.5之后第一个内建的字节码内存缓存工具。类似之前的 APC，eAccelerator...

opcache 的加速原理是把编译后的 bytecode 存储在内存里面, 避免重复编译 PHP 所造成的资源浪费。

安装 & 配置部分省略。。。。。。

[一个关于Opcache的小分享](http://www.laruence.com/2013/11/11/2928.html)

## 内建的http服务器
php 5.4之后引入了内建的http服务器。

使用方式：

```php
# 在命令行界面切换到你的项目目录，在此启动该目录将作为服务器的根目录。
# php -S localhost:4000
# 在 localhost 上绑定 4000 端口
# 也可用 0.0.0.0 监听任意ip
# 带自定义配置项的启动 php -S localhsot:8000 -c app/config/php.ini
```

内建的服务器并不支持 `.htaccess`。php使用 router scripts 来解决这一问题。

```php
php -S localhost:8000 router.php
```

该脚本将在每一次请求前调用。如果脚本return false，与请求相匹配的静态文件将返回，否则将返回router.php返回的内容。

检测内建服务器的方式：

```php
<?php
if (php_sapi_name() === 'cli-server') {
    // PHP web server
}else{
    // Other web server
}
```

缺点：

1.只能同时处理一个请求。
2.mimetypes有限。
3.router script的rewrite规则是有限的。

总之就是不能用在生产环境啦

##  PHP-FIG
PSR 是 PHP互操作性框架制定小组（PHP-FIG :PHP Framework Interoperability Group）制定的PHP编码规范（PSR:Proposing a Standards Recommendation）。

具体内容就不列了，网上中英文都有

[PSR](http://www.php-fig.org/)

[中文版](https://github.com/PizzaLiu/PHP-FIG)


## Packagist，Composer
这部分主要介绍了 Packagist，Composer。

几乎每种语言都有包管理器。Java有Maven，Python有easy_install，Ruby有gem，Nodejs有npm。

PHP在 packagist 之前也有 PEAR，只是没那么好用。

Composer是PHP中的一个依赖管理工具，它可以让你声明自己项目所依赖的库，然后它将会在项目中为你安装这些库。

因为众所周知的原因，请使用 Packagist 的众多国内镜像来保证可用性与速度。

[packagist](https://packagist.org/)

[Composer](https://getcomposer.org/)

[中文文档](http://docs.phpcomposer.com/)

[使用GitHub、Composer、Packagist管理公开的PHP包](http://rivsen.github.io/post/how-to-publish-package-to-packagist-using-github-and-composer-step-by-step/)


## 实践
### 过滤，验证与转义

任何用户数据都是不可信的。获取用户信息主要是以下几个来源

* `$_GET`
* `$_POST`
* `$_REQUEST`
* `$_COOKIE`
* `$argv`
* `php://stdin`
* `php://input`
* `file_get_contents()`
* `Remote databases`
* `Remote APIs`
* `Data from your clients`

#### 过滤

#### HTML

`htmlentities` 函数默认不转义引号与检测字符集，正确的用法应该是

```php
<?php
$input = '<p><script>alert("You won the Nigerian lottery!");</script></p>'; 
echo htmlentities($input, ENT_QUOTES, 'UTF-8');
```

过滤html输入，[HTML Purifier](http://htmlpurifier.org/) 是更好的选择。

一些php模版引擎也会自动完成过滤工作，如 [Twig](http://twig.sensiolabs.org/) , [Blade](http://daylerees.com/codebright/blade) 。

不要自己写正则来过滤，正则又复杂又慢，html输入不一定是规范的，这一方法有很大的安全隐患。

### SQL

举一个例子

```php
$sql = sprintf(
    'UPDATE users SET password = "%s" WHERE id = %s',
    $_POST['password'],
    $_GET['id']
);
```

直接使用字符串拼接作为sql语句简直就是灾难，直接一个伪造请求就能改掉用户密码。

```php
# POST /user?id=1 HTTP/1.1
#    Content-Length: 17
#    Content-Type: application/x-www-form-urlencoded
#    password=abc";--
```

PS：大部分数据库将 `--` 当作注释而忽略掉后面的内容。

更好的方式是使用 [PDO](http://php.net/manual/en/book.pdo.php)

### 杂项

过滤Email

```php
<?php
$email = 'john@example.com';
$emailSafe = filter_var($email, FILTER_SANITIZE_EMAIL);
```

移除 ASCII 32 之前的字符并转义 127 之后的

```php
<?php
$string = "\nIñtërnâtiônàlizætiøn\t"; $safeString = filter_var(
    $string,
    FILTER_SANITIZE_STRING,
    FILTER_FLAG_STRIP_LOW|FILTER_FLAG_ENCODE_HIGH
);
```

[查看更多filter_var用法](http://php.net/ manual/function.filter-var.php)

### 验证

与过滤不同，验证数据并不改变数据本身，只是检查数据是否符合你的期望。

可以使用 `filter_var` 配合 `FIL TER_VALIDATE_*` 标志位来验证数据。

```php
<?php
$input = 'john@example.com';
$isEmail = filter_var($input, FILTER_VALIDATE_EMAIL); 
if ($isEmail !== false) {
    echo "Success"; 
}else{
    echo "Fail"; 
}
```

以下是其他推荐的验证组件。

[aura/filter](https://packagist.org/packages/aura/filter)

[respect/validation](https://packagist.org/packages/respect/validation)

[symfony/validator](https://packagist.org/packages/symfony/validator)

### 密码安全

* 绝不明文存储
* 不通过邮件发送密码（一旦发送表示网站明文存储并且能读取用户密码），使用带有效时间并且需要验证的token附带在url中发送来代替发送密码。
* 使用 bcrypt 加密密码
* 尽可能使用 Password Hashing API(若无法使用 php 5.5 以上，可以使用 [password-compat](https://packagist.org/packages/ircmaxell/password-compat) )

### 用户注册流程

请求：

```php
# POST /register.php HTTP/1.1
# Content-Length: 43
# Content-Type: application/x-www-form-urlencoded
# email=john@example.com&password=sekritshhh!
```

```php
<?php
try{
    // Validate email
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
    if (!$email) {
        throw new Exception('Invalid email');
    } 

    // Validate password
    $password = filter_input(INPUT_POST, 'password');
    if (!$password || mb_strlen($password) < 8) {
        throw new Exception('Password must contain 8+ characters');
    }

    // Create password hash
    $passwordHash = password_hash(
       $password,
       PASSWORD_DEFAULT,
       ['cost' => 12]
    );

    if ($passwordHash === false) {
        throw new Exception('Password hash failed');
    }

    // Create user account (THIS IS PSUEDO-CODE)
    $user = new User();
    $user->email = $email;
    $user->password_hash = $passwordHash;
    $user->save();

    // Redirect to login page
    header('HTTP/1.1 302 Redirect');
    header('Location: /login.php');

} catch (Exception $e) {
    // Report error
    header('HTTP/1.1 400 Bad request');
    echo $e->getMessage();
}
```

密码字段推荐 `varchar(255)`

### 用户登陆流程

请求：

```php
# POST /login.php HTTP/1.1
# Content-Length: 43
# Content-Type: application/x-www-form-urlencoded
# email=john@example.com&password=sekritshhh!
```

```php
<?php
session_start(); 

try{
    // Get email address from request body
    $email = filter_input(INPUT_POST, 'email');

    // Get password from request body
    $password = filter_input(INPUT_POST, 'password');

    // Find account with email address (THIS IS PSUEDO-CODE)
    $user = User::findByEmail($email);

    // Verify password with account password hash
    if (password_verify($password, $user->password_hash) === false) {
        throw new Exception('Invalid password');
    }

    // Re-hash password if necessary(see not below)
    $currentHashAlgorithm = PASSWORD_DEFAULT;
    $currentHashOptions = array('cost' => 15);
    $passwordNeedsRehash = password_needs_rehash(
        $user->password_hash,
        $currentHashAlgorithm,
        $currentHashOptions
    );

    if ($passwordNeedsRehash === true) {
        // Save new password hash (THIS IS PSUEDO-CODE)

        $user->password_hash = password_hash(
            $password,
            $currentHashAlgorithm,
            $currentHashOptions
        );
        $user->save();
    }

    // Save login status to session
    $_SESSION['user_logged_in'] = 'yes';
    $_SESSION['user_email'] = $email;

    // Redirect to profile page
    header('HTTP/1.1 302 Redirect');
    header('Location: /user-profile.php');
} catch (Exception $e) {
    header('HTTP/1.1 401 Unauthorized');
    echo $e->getMessage();
}
```

### 时间处理

php 5.2 之后推荐使用 `DateTime`,`DateInterval`,`DateTimeZone`来处理时间相关的操作。

第一步，设置时区。两种方式

```php
# declare the default time zone in the php.ini file like this:date.timezone = 'America/New_York';
date_default_timezone_set('America/New_York');
```

第二步，实例化

```php
# $datetime = new DateTime(); 
# Without arguments, the DateTime class constructor creates an instance that repre‐ sents the current date and time.
$datetime = new DateTime('2014-04-27 5:03 AM');
```

时间的来源格式不尽相同，使用 `DateTime::createFromFormat()` 静态方法来格式化并创建实例

```php
$datetime = DateTime::createFromFormat('M j, Y H:i:s', 'Jan 2, 2014 23:04:12');
# strtotime ('Jan 2, 2014 23:04:12');
```

使用 `DateInterval` ，`DatePeriod` 来处理时间间隔。

* Y (years)
* M (months)
* D (days)
* W (weeks)
* H (hours)
* M (minutes) 
* S (seconds)

举例，P2D 表示两天。P2DT5H2M 两天五小时两分钟。

```php
<?php
// Create DateTime instance
$datetime = new DateTime('2014-01-01 14:00:00');
// Create two weeks interval
$interval = new DateInterval('P2W');
// Modify DateTime instance
$datetime->add($interval);
echo $datetime->format('Y-m-d H:i:s');
```

```php
$dateStart = new \DateTime();
$dateInterval = \DateInterval::createFromDateString('-1 day'); 
$datePeriod = new \DatePeriod($dateStart, $dateInterval, 3); 
foreach ($datePeriod as $date) {
    echo $date->format('Y-m-d'), PHP_EOL; 
}
# This outputs:
#     2014-12-08
#     2014-12-07
#     2014-12-06
#     2014-12-05
```

```php
<?php
$start = new DateTime();
$interval = new DateInterval('P2W');
$period = new DatePeriod($start, $interval, 3);
foreach ($period as $nextDateTime) {
    echo $nextDateTime->format('Y-m-d H:i:s'), PHP_EOL;
}
```

第三方组件 [Cabon](https://github.com/briannesbitt/Carbon)

切换不同时区的话，使用 `DateTimeZone`

```php
<?php
$timezone = new DateTimeZone('America/New_York'); 
$datetime = new DateTime('2014-08-20', $timezone);

$timezone = new DateTimeZone('America/New_York'); 
$datetime = new \DateTime('2014-08-20', $timezone); 
$datetime->setTimezone(new DateTimeZone('Asia/Hong_Kong'));
```

### 数据库

使用 PDO 来处理数据库操作

通过配置 DSN 使得 PDO 将 php 与数据库连接起来

DSN 配置由数据库驱动名开头 (e.g., mysql or sqlite),每种数据库格式不尽相同，但大体都包含以下信息:

* Hostname or IP address
* Port number
* Database name
* Character set

[DSN格式参考](http://php.net/manual/pdo.drivers.php)

```php
<?php 
try {
    $pdo = new PDO( 'mysql:host=127.0.0.1;dbname=books;port=3306;charset=utf8', 'USERNAME','PASSWORD');
} catch (PDOException $e) {
    // Database connection failed
    echo "Database connection failed";
    exit; 
}
```

连接信息的隐私性要注意保护，不要加到版本控制里，更别放到公共仓库里。

使用 prepare 语句来绑定查询变量，保证安全性

```php
<?php
$sql = 'SELECT id FROM users WHERE email = :email';
$statement = $pdo->prepare($sql);
$email = filter_input(INPUT_GET, 'email');
$statement->bindValue(':email', $email); // default string type

$sql = 'SELECT email FROM users WHERE id = :id';
$statement = $pdo->prepare($sql);
$userId = filter_input(INPUT_GET, 'id');
$statement->bindValue(':id', $userId, PDO::PARAM_INT);
```

* PDO::PARAM_BOOL
* PDO::PARAM_NULL
* PDO::PARAM_INT
* PDO::PARAM_STR (default)
    
[一些PDO预定义常量](http://php.net/manual/en/pdo.constants.php)

#### 获取查询结果

通过 execute 执行 SQL 之后，若是非 INSERT，UPDATE或DELETE操作，你还需获取数据库返回的纪录。

```php
<?php
$pdo = new PDO("mysql:host=localhost;dbname=world", 'my_user', 'my_pass');
$pdo->setAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY, false);
// 缓存结果集到php端将有更多的操作可用，但内存占用也会加大
// 不缓存到php端，则使用连接资源向数据库端每次获取数据，虽然php端内存压力小了，但是会明显加大数据库端的负载。
// 对于同一个连接来说，除非结果集被服务端获取完，否则将无法返回其他查询结果。

$uresult = $pdo->query("SELECT Name FROM City");
if ($uresult) {
   while ($row = $uresult->fetch(PDO::FETCH_ASSOC)) {
       echo $row['Name'] . PHP_EOL;
   }
}
?>
```

[Buffered and Unbuffered queries](http://php.net/manual/zh/mysqlinfo.concepts.buffering.php)

[其他的FETCH_STYLE](http://php.net/manual/zh/pdostatement.fetch.php)

```php
<?php
// Build and execute SQL query
$sql = 'SELECT id, email FROM users WHERE email = :email'; 
$statement = $pdo->prepare($sql);
$email = filter_input(INPUT_GET, 'email'); 
$statement->bindValue(':email', $email, PDO::PARAM_INT); $statement->execute();
// Iterate results
$results = $statement->fetchAll(PDO::FETCH_ASSOC); 
// results 已经包含全部结果集
foreach ($results as $result) {
    echo $result['email']; 
}
```

获取指定列结果集

```php
<?php
// Build and execute SQL query
$sql = 'SELECT id, email FROM users WHERE email = :email'; 
$statement = $pdo->prepare($sql);
$email = filter_input(INPUT_GET, 'email'); 
$statement->bindValue(':email', $email, PDO::PARAM_INT); 
$statement->execute();
// Iterate results
// The query result column order matches the column order specified in the SQL query.
while (($email = $statement->fetchColumn(1)) !== false) { 
    echo $email;
}
```

#### 事务

PDO 同样支持事务

```php
<?php
require 'settings.php';
// PDO connection
try {
    $pdo = new PDO(
            sprintf(
                'mysql:host=%s;dbname=%s;port=%s;charset=%s',
                $settings['host'],
                $settings['name'],
                $settings['port'],
                $settings['charset']
            ),
            $settings['username'],
            $settings['password']
    );
} catch (PDOException $e) {
    // Database connection failed
    echo "Database connection failed";
    exit; 
}
// Statements
$stmtSubtract = $pdo->prepare('
    UPDATE accounts
    SET amount = amount - :amount
    WHERE name = :name
');
    $stmtAdd = $pdo->prepare('
    UPDATE accounts
    SET amount = amount + :amount
    WHERE name = :name
');
// Start transaction
$pdo->beginTransaction();
// Withdraw funds from account 1
$fromAccount = 'Checking';
$withdrawal = 50;
$stmtSubtract->bindParam(':name', $fromAccount);
$stmtSubtract->bindParam(':amount', $withDrawal, PDO::PARAM_INT);
$stmtSubtract->execute();
// Deposit funds into account 2
$toAccount = 'Savings';     
$deposit = 50;
$stmtAdd->bindParam(':name', $toAccount);
$stmtAdd->bindParam(':amount', $deposit, PDO::PARAM_INT);
$stmtAdd->execute();
// Commit transaction
$pdo->commit();
```

### 多字节字符串处理

除英文外的大部分语言都无法仅用一个字节来表示。目前主流使用 UTF-8 编码。

使用 [mbstring](http://php.net/manual/book.mbstring.php) 来处理多字节字符串。

比如说用 mb_strlen 来代替 strlen 统计字符串长度。

使用 `mb_detect_encoding()` 与 `mb_convert_encoding()` 函数来检测和转换字符编码。

#### 输出 UTF-8 编码的数据

```php
# set default_charset = "UTF-8"; in php.ini
header('Content-Type: application/json;charset=utf-8');
# or in html page, <meta charset="UTF-8"/>
```

### 流（Streams）

即使 php 4.3 之后就引入了 streams，但可以说这一特性是使用人数最少的特性之一，但它却非常好用。

streams 是用来在源与目的之间传输数据的，仅此而已。源可以是文件，进程，网络连接，zip压缩包，标准输入输出等等资源，只要其被 stream wrappers 封装成统一的接口。

PS：作者将stream比喻为一端流向另一端的水流，我们可以对水流做任何操作，比如加水，拉闸限水等等。。。

归纳来说所有的 Stream Wrappers 都是实现了

* 打开连接
* 读写数据
* 关闭连接

几个动作。

每个 stream 包含了 scheme 和 target，`<scheme>://<target>`

```php
<?php
# Flickr API with HTTP stream wrapper
$json = file_get_contents(
    'http://api.flickr.com/services/feeds/photos_public.gne?format=json'
);
```

像 `file_get_contents()`, `fopen()`, `fwrite()`, `fclose()` 之类的函数底层都实现了对各种 Stream Wrappers 的支持

```php
<?php
$handle = fopen('/etc/hosts', 'rb'); 
while (feof($handle) !== true) {
    echo fgets($handle);
}
fclose($handle);
```

自定义 Stream Wrapper

[链接1](http://php.net/manual/en/stream.streamwrapper.example-1.php)
[链接2](http://php.net/manual/en/class.streamwrapper.php)

#### Stream 上下文

```php
<?php
$requestBody = '{"username":"josh"}'; 
$context = stream_context_create(array(
    'http' => array(
    'method' => 'POST',
    'header' => "Content-Type: application/json;charset=utf-8;\r\n" .
                "Content-Length: " . mb_strlen($requestBody),
                'content' => $requestBody
    )
));
$response = file_get_contents('https://my-api.com/users', false, $context);
```

#### Stream 过滤器

```php
<?php
$handle = fopen('data.txt', 'rb'); 
stream_filter_append($handle, 'string.toupper'); 
while(feof($handle) !== true) {
    echo fgets($handle); // <-- Outputs all uppercase characters 
}
fclose($handle);
```

自定义过滤器

```php
class DirtyWordsFilter extends php_user_filter {
    /**
     * @param resource $in       Incoming bucket brigade
     * @param resource $out      Outgoing bucket brigade
     * @param int      $consumed Number of bytes consumed
     * @param bool     $closing  Last bucket brigade in stream?
     */
    public function filter($in, $out, &$consumed, $closing) {
        $words = array('grime', 'dirt', 'grease'); $wordData = array();
        foreach ($words as $word) {
            $replacement = array_fill(0, mb_strlen($word), '*');
            $wordData[$word] = implode('', $replacement);
        }
        $bad = array_keys($wordData);
        $good = array_values($wordData);
        // Iterate each bucket from incoming bucket brigade
        while ($bucket = stream_bucket_make_writeable($in)) {
            // Censor dirty words in bucket data
            $bucket->data = str_replace($bad, $good, $bucket->data);
            // Increment total data consumed
            $consumed += $bucket->datalen;
            // Send bucket to downstream brigade
            stream_bucket_append($out, $bucket);
        }
        return PSFS_PASS_ON; 
    }
}

stream_filter_register('dirty_words_filter', 'DirtyWordsFilter');

$handle = fopen('data.txt', 'rb'); 
stream_filter_append($handle, 'dirty_words_filter'); 
while (feof($handle) !== true) {
    echo fgets($handle); // <-- Outputs censored text 
}
fclose($handle);
```

### 错误与异常

可以使用 `@` 操作符来抑制错误提示，但这个极度不推荐的。正确的做法是用 `TryCatch` 和 `Throw` 处理和抛出异常。

#### 异常

```php
<?php
$exception = new Exception('Danger, Will Robinson!', 100);
$code = $exception->getCode(); // 100
$message = $exception->getMessage(); // 'Danger...'

throw new Exception('Something went wrong. Time for lunch!'); // un catch

try {
    $pdo = new PDO('mysql://host=wrong_host;dbname=wrong_name'); 
} catch (PDOException $e) {
    // Inspect the exception for logging
    $code = $e->getCode();
    $message = $e->getMessage();
    // Display a nice message to the user
    echo 'Something went wrong. Check back soon, please.';
    exit; 
}

try {
    throw new Exception('Not a PDO exception');
    $pdo = new PDO('mysql://host=wrong_host;dbname=wrong_name'); 
} catch (PDOException $e) {
    // Handle PDO exception
    echo "Caught PDO exception"; 
} catch (Exception $e) {
    // Handle all other exceptions
    echo "Caught generic exception"; 
} finally {
    // Always do this,since php 5.5
    echo "Always do this"; 
}

```

php 内置的异常类

[Exception](http://php.net/manual/en/class.exception.php)

[ErrorException](http://php.net/manual/en/class.errorexception.php)

SPL(php标准库)提供了更多的[异常子类](http://php.net/manual/en/spl.exceptions.php)

或者设置全局的异常处理函数，如下。

```php
<?php
// Register your exception handler set_exception_handler(function (Exception $e) {
    // Handle and log exception
});
// Your code goes here...
// Restore previous exception handler
restore_exception_handler();
```

#### 错误

相关函数主要有 trigger_error 与 [error_reporting](http://php.net/manual/function.error-reporting.php)

四大原则：

* 永远打开错误收集机制
* 开发环境打开错误提示
* 生产环境绝不提示错误
* 开发和生产环境都用日志纪录错误

开发环境推荐配置：

```php
; Display errors
  display_startup_errors = On
  display_errors = On
; Report all errors
  error_reporting = -1
; Turn on error logging
  log_errors = On
```

生产环境推荐配置：

```php
; DO NOT display errors
  display_startup_errors = Off
  display_errors = Off
; Report all errors EXCEPT notices
  error_reporting = E_ALL & ~E_NOTICE ; Turn on error logging
  log_errors = On
```

与异常一样，也可以设置全局处理函数

```php
<?php
set_error_handler(function ($errno, $errstr, $errfile, $errline) {
    if (!(error_reporting() & $errno)) {
        // Error is not specified in the error_reporting // setting, so we ignore it.
        return;
    }
    throw new \ErrorException($errstr, $errno, 0, $errfile, $errline); 
});
```

PS:

set_error_handler 并不能处理所有错误。包括 `E_ERROR`, `E_PARSE`, `E_CORE_ERROR`, `E_CORE_WARNING`, `E_COMPILE_ERROR`, `E_COMPILE_WARNING`

这些情况下 `register_shutdown_function` 与 `error_get_last` 是更好的解决方案。

优秀的第三方组件：

[错误处理](https://github.com/filp/whoops)

[日志纪录](https://github.com/Seldaek/monolog)

## 其他 ##
### 调优 ###

#### php.ini ####

##### 内存 #####

主要是针对 `memory_limit` 的设置。

相关 Q&A

Q：总共能分配多少内存给PHP ? 

A：假设一台 2GB 内存的 Linode 主机，除 php 外的其他进程，比如 nginx 或 MySQL 都部署在同一台机子上。配置 512M 给 php 是一个不错的选择。

Q：平均来说，一个php进程占用多少内存？

A：命令行使用 `top` ，或者调用php函数 `memory_get_peak_usage()` 来查看内存使用情况。以我的观察，大概一个占 5-20MB左右内存。（个人情况，仅供参考）

而且如果正在进行文件上传等操作时，内存占用会持续上升。

Q：PHP-FPM 开多少进程合适?

A：以分配 512 MB 内存来说。大概分配 34 个 PHP-FPM 进程（同样个人情况，仅供参考）

可以使用 [Apache Bench](https://httpd.apache.org/docs/2.2/programs/ab.html) 或 [seige](http://www.joedog.org/siege-home/) 来进行压力测试

##### 文件上传 #####

需要文件上传吗？如果不需要，直接关掉它提高安全系数。

```php
file_uploads = 1 // Whether or not to allow HTTP file uploads
upload_max_filesize = 10M
max_file_uploads = 3
```

##### 脚本最大执行时间 #####

建议 `max_execution_time = 5` 或 `set_time_limit()` 函数, 长时间运行的任务请丢给[队列](https://github.com/chrisboulton/php-resque)慢慢消化。

```php
<?php
exec('echo "create-report.php" | at now');  // The standalone create-report.php script runs in a separate background process;
echo 'Report pending...';
```

##### 设置session解决方案 #####

```php
session.save_handler = 'memcached'
session.save_path = '127.0.0.2:11211'
```

##### 输出缓存 #####

php默认开启了输出缓存（非命令行下）

```php
output_buffering = 4096
implicit_flush = false
// This is equivalent to calling the PHP function flush() after each and every call to print or echo and each and every HTML block. false by default
```

如果更改了 output_buffering ，确保它是4的倍数 (32位系统) 或8的倍数 (64位系统).

##### Realpath Cache #####

php会对文件路径做缓存来避免每次在 include path 中搜索。默认大小为 16k。

```php
realpath_cache_size = 64k
```

### 部署 ###

[Capistrano](http://capistranorb.com/)

[Magallanes](http://magephp.com/)

[Rocketeer](http://rocketeer.autopergamene.eu/#/docs/rocketeer/README)

[PuPHPet](https://puphpet.com/#deploy-target)

### 测试 ###

#### 单元测试 ####

单元测试主要针对独立的类，方法和函数，最常用的单元测试套件为 [PHPUnit](https://phpunit.de/) 。

#### 测试驱动开发（Test-driven development）TDD ####

是极限编程中倡导的程序开发方法，以其倡导先写测试程序，然后编码实现其功能得名。

测试驱动开发是戴两顶帽子思考的开发方式：先戴上实现功能的帽子，在测试的辅助下，快速实现其功能；再戴上重构的帽子，在测试的保护下，通过去除冗余的代码，提高代码质量。测试驱动着整个开发过程：首先，驱动代码的设计和功能的实现；其后，驱动代码的再设计和重构。

正面评价:

可以有效的避免过度设计带来的浪费。但是也有人强调在开发前需要有完整的设计再实施可以有效的避免重构带来的浪费。
可以让开发者在开发中拥有更全面的视角。

负面评价:

开发者可能只完成满足了测试的代码，而忽略了对实际需求的实现。有实践者认为用结对编程的方式可以有效的避免这个问题。
会放慢开发实际代码的速度，特别对于要求开发速度的原型开发造成不利。这里需要考虑开发速度需要包含功能和品质两个方面，单纯的代码速度可能不能完全代表开发速度。

对于GUI,资料库和Web应用而言。构造单元测试比较困难，如果强行构造单元测试，反而给维护带来额外的工作量。有开发者认为这个是由于设计方法，而不是开发方法造成的困难。

使得开发更为关注用例和测试案例，而不是设计本身。目前，对于这个观点有较多的争议。

测试驱动开发会导致单元测试的覆盖度不够，比如可能缺乏边界测试。在实际的操作中，和非测试驱动开发一样，当代码完成以后还是需要补充单元测试，提高测试的覆盖度。

#### 行为驱动开发（Behavior-driven development）BDD ####

BDD的重点是通过与利益相关者的讨论取得对预期的软件行为的清醒认识。它通过用自然语言书写非程序员可读的测试用例扩展了测试驱动开发方法。行为驱动开发人员使用混合了领域中统一的语言的母语语言来描述他们的代码的目的。这让开发者得以把精力集中在代码应该怎么写，而不是技术细节上，而且也最大程度的减少了将代码编写者的技术语言与商业客户、用户、利益相关者、项目管理者等的领域语言之间来回翻译的代价。

[Behat](http://docs.behat.org/en/v2.5/)

[PHPspec](http://www.phpspec.net/en/latest/)

### 持续集成 ###

[TravisCI](https://travis-ci.org/)

### 性能分析 & 调试工具 ###

[XDebug](http://xdebug.org/)

[Xhprof](http://xhprof.io/)

[Z-Ray](http://www.zend.com/en/products/server/z-ray-use-cases)

[简化PHP开发—Z-Ray的应用](http://code.csdn.net/news/2821335)

[New Relic](https://newrelic.com/)

### HHVM and Hack ###

[HHVM 是如何提升 PHP 性能的？](http://wuduoyi.com/note/hhvm/)

[Hack Lang](http://blog.jobbole.com/63613/)
