<!--php ����-->
<?php
ini_set("display_errors", "On");  
error_reporting(E_ALL | E_STRICT);
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
//�����������ڴ�������δ���������Է���.������Կɼ���Ϊprivate or protected,Ҳ���ø÷���
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
//����ӡ������,���ඨ���˴˷���,�ʹ�ӡ�÷����ķ���ֵ,������ȱʡ���ش���
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
//�������������ú͹��췽��_construct�෴,�ڶ��������ռ����ռ�֮ǰ�Զ�����,����������;;�����ռ���֪��ʲôʱ������,����shi
//print ���� __destruct����������
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
//static �ؼ��ֺ�self��parent һ��,static��������Ϊ��̬�������õı�ʶ��,�����ǴӷǾ�̬�������е���


abstract class Basea{
    private $ownedGroup;
    public function __construct(){
    //�����static �����������һ��,��ʾ��ǰ���ø÷�����ʵ����//����static�����ĺ������ڲ�ͬ
        //����getGroup �þ�̬��������ͨ�෽�����ܵ���,�������ͨ�෽��,������$this
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
//��ʵ�ֽӿ�Ҫʹ��implements,ʵ�����еĳ��󷽷�.һ�������ʵ�ֶ���ӿ�,�ӿڵ��������ں���һ�ڼ���˵�Ķ�̬,�����Ƕ�̳�,��Ϊû�̳�ʵ��ѽ
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
echo "Max value".People::MAX; //��̬����
die();
?>

<?php
//�ӿ���һ������ĳ����࣬���ֳ�������ֻ�������󷽷��;�̬������
interface People
{
    const MAX=30;
    function setName($name);
    function getName();
}

die();
?>

<?php
//��abstract ���ε����ʾ���������һ�����󷽷�.
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
//�����಻��ʵ����
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

//��̬��ȶ�̬����ԭ��ǰ���ǵ��ö�Σ�,��̬������һ��,��̬��ÿ����һ�ξ�Ҫ������һ��

//������ܵ�static �ؼ�����Ҫ�����ӳپ�̬�󶨹���
abstract class Base{
    
    public static function getInstance(){
    //�����new static()ʵ�������ǵ��øþ�̬�����ĵ�ǰ��.
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
//�����ڵ��ø��ྲ̬��Ա�;�̬������ǰ׺����,���ڷǾ�̬��Ա�����ͺ�����ʹ��this
// this ʵ��ָ��  parent ����ָ�� self ��ǰ��ָ��    /?? ����ʵҲҪ ���ڴ����ɵ� ,ʵ������������  ;;��̬�����ܸ�ֵ new static()ʵ����̬����

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
//��ļ̳�(���ݺͷ���)

	
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
//���еĹ��캯�����÷�
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
