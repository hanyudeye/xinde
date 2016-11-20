<!--php 例子-->
<?php
ini_set("display_errors", "On");  
error_reporting(E_ALL | E_STRICT);
echo __FILE__;
echo "</br>";
echo __file__;
die();
?>


<?php
$segs;
$segs[]=3;
$segs[]=6;
$segs[]=7;
print_r($segs);
     die();
?>
<?php
class upDateNameClass
{
    function UpdateFunc()
    {
        echo "hello";
    }
}
$upobj=new upDatenameclass();
$upobj->updatefunc();

die();
 ?>


<?php
    $a=31;
$b=5;
function f(){
  $tmp1=  $GLOBALS['a'];
  $tmp2=  $GLOBALS['b'];
  $a=$tmp1+$tmp2;
    return $a;
}
$aa=f();
echo $aa;
    die();
?>

<?php
//这两方法用于处理类中未声明的属性访问.如果属性可见性为private or protected,也调用该方法
class TestclassB{
    private $privateField;
    public $publicField;
    
    public function __construct(){
        $this->publicField="this is a public field.\n";
        $this->privateField="this is a private field.\n";
    }
    public function __get($property)
    {
        print "__get()is called.\n";
        $method="get${property}";
        if(method_exists($this,$method)){
            return $this->$method();
        }
        return "this is underfined field.\n";
    }
    public function __set($method, $value)
    {
        print "__set is called\n";
        $m="set${method}";
        if(method_exists($this,$m))
        {
            $this->$m($value);
        }else
        {
            print "this is an underfined field.\n";
        }
    }
    public function getPrivateField(){
        return $this->privateField;
    }
    
    public function setPrivateField($value){
        $this->privateField=$value;
    }
}
$testb=new TestclassB();
print $testb->PrivateField;
print $testb->undefinedField;
print $testb->publicField;
echo "<br/>";

$testb->privateField="this is a private on set";
$testb->undefinedField="this is a undefinedField on set";
$testb->publicField="this is a publicField on set";
print $testb->PrivateField;
echo "<br/>";
print $testb->undefinedField;
echo "<br/>";
print $testb->publicField;
die();
?>
<?php
//当打印对象是,该类定义了此方法,就打印该方法的返回值,否则按照缺省返回错误
class TestClassa{
    public function __toString(){
        return "this is testclass::__toString.\n";
    }
}
$testa=new TestClassa();
print $testa;
die();
?>
<?php
//析构方法的作用和构造方法_construct相反,在对象被垃圾收集器收集之前自动调用,可以做清理;;垃圾收集不知道什么时候运行,测试shi
//print 先于 __destruct方法先运行
class TestClass{
function __destruct(){
    print "Testclass destructor is called.\n";
}
}
$testo=new TestClass();
unset($test);
print "Application will exit .\n";
die();
?>

<?php
//static 关键字和self和parent 一样,static还可以作为静态方法调用的标识符,甚至是从非静态上下文中调用


abstract class Basea{
    private $ownedGroup;
    public function __construct(){
    //这里的static 和上面的例子一样,表示当前调用该方法的实际类//这里static方法的含义与众不同
        //这里getGroup 用静态方法或普通类方法都能调用,如果是普通类方法,建议用$this
        $this->ownedGroup=static::getGroup();
    }
    public function printGroup()
    {
        print "My Group is ".$this->ownedGroup."\n";
    }
     public static function getInstance() {
        return new static();
    }
    public static function getGroup() {
        return "default";
    }
}

class A extends Basea {}
class B extends Basea{
    public static function getGroup()
    {
        return "SubB";
    }
}
A::getInstance()->printGroup();
B::getInstance()->printGroup();

die();
?>

<?php
//类实现接口要使用implements,实现其中的抽象方法.一个类可以实现多个接口,接口的意义在于后面一节继续说的多态,而不是多继承,因为没继承实现呀
interface People
{
    const MAX=30;
    function setName($name);
    function getName();
}

class NormalPeople implements People
{
    private $name;
    function getName()
    {
        return $this->name;
    }
    function setName($name)
    {
        $this->name=$name;
    }
}
$nope=new NormalPeople();
$nope->setName("xiaoming");
echo "name is".$nope->getName();
echo "Max value".People::MAX; //静态常量
die();
?>

<?php
//接口是一种特殊的抽象类，这种抽象类中只包含抽象方法和静态常量。
interface People
{
    const MAX=30;
    function setName($name);
    function getName();
}

die();
?>

<?php
//用abstract 修饰的类表示这个方法是一个抽象方法.
abstract class User
{
    protected $sal =0;
    abstract function getSal();
    abstract function setSal($sal);
    
    public function __toString(){
        return get_class($this);
    }
}

class NormalUser extends User{
    function getSal(){
    }
    function setSal($sal){
    }
}
die();

?>


<?php
//抽象类不能实例化
abstract class abstractclass
{
    public function __toString()
    {
        return get_class($this);
    }
    
}

class realclass extends abstractclass{

}
$ac=new realclass();  
return $ac->__toString();
die();
?>



<?php

//静态类比动态类快的原因（前提是调用多次）,静态类生成一次,动态类每调用一次就要先生成一次

//这里介绍的static 关键字主要用于延迟静态绑定功能
abstract class Base{
    
    public static function getInstance(){
    //这里的new static()实例化的是调用该静态方法的当前类.
        return new static();
    }
    
    abstract public function printSelf();

}

class SubA extends Base{
    public function printSelf(){
        print "This is SubA:printSELF.\n";
    }
}

class SubB extends Base{
    public function printSelf(){
        print "This is SubB:printSELF.\n";
    }
}

SubA::getInstance()->printSelf();
SubB::getInstance()->printSelf();

die();
?>


<?php
//在类内调用该类静态成员和静态方法的前缀修饰,对于非静态成员变量和函数则使用this
// this 实例指针  parent 父类指针 self 当前类指针    /?? 类其实也要 在内存生成的 ,实例化的是数据  ;;静态变量能改值 new static()实例静态方法

class StaticTest{
	static public $arg1="Hello,this is static field!";
	
	static public function SayHello()
	{
		print self::$arg1;
	}
	
	
}

	print StaticTest::$arg1;
	StaticTest::SayHello();
	StaticTest::$arg1=3;
	print StaticTest::$arg1;
	
	die();
?>

<?php
//类的继承(数据和方法)

	
class baseclass
{
	protected $arg1;
	protected $arg2;
	
	function __construct($arg1,$arg2)
	{
		$this->arg1=$arg1;
		$this->arg2=$arg2;
		print "__construct is called..\n";
	}
	
	function getAttributes()
	{
		return "arg1 is".$this->arg1."\targ2 is ".$this->arg2;
	}
}
	
class  subclass extends baseclass
{
	protected $arg3;
	
	function __construct($baseArg1,$baseArg2,$subArg)
	{
		parent::__construct($baseArg1,$baseArg2);
		$this->arg3=$subArg;
	}
	
	function getAttributes()
	{
		return parent::getAttributes().'$arg3 is'.$this->arg3;
		
	}
}	

$test=new subclass("arg1v","arg2v","arg3v")	;
print $test->getAttributes();
	
	
die();
?>


<?php
//类中的构造函数的用法
 ini_set("display_errors", "On");   
	error_reporting(E_ALL);
	
class test{
	private $arg1;
	private $arg2;
	
	public function __construct($arg1,$arg2)
	{
		$this->arg1=$arg1;
		$this->arg2=$arg2;
		print "__construct is called..\n";
	}
	
	public function printAttributes()
	{
		print 'arg1 ='.$this->arg1.'arg2='.$this->arg2;
		
	}
}	

$testobj=new test("arg1v","arg2v");
$testobj->printAttributes();
die();
?>
