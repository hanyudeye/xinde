<?php
// 控制器父类
class CI_Controller{
    private static $instance;

    //控制器 初始化时的行为
    public function __construct(){
        self::$instance=& $this;

     //is_loaded()显示已经实例化了多少类
        //这个控制器初始化时生成了 $var 路由对象 和 load对象
       foreach (is_loaded() as $var=> $class){
            $this->$var = & load_class($class);
        }
        /* $this->$var       //CI_Router Object ( [uri] => CI_URI Object ( [segments] => Array ( [0] => welcome [1] => hello ) [uri_string] => welcome/hello [rsegments] => Array ( [0] => welcome [1] => saysomething [2] => hello ) ) [routes] => Array ( [default_controller] => controllers [welcome/hello] => welcome/saysomething/hello ) [class] => welcome [method] => saysomething [default_controller] => controllers )*/
       $this->load=& load_class('Loader');
       $this->load->initialize();
 }

public static    function &get_instance(){
    return self::$instance;
    }
}
?>