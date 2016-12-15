<?php
/*用php练习做一个框架的代码
 *框架的主入口,为了把URL定位成类和方法形式的
 */
ini_set("display_errors", "On");   
error_reporting(E_ALL | E_STRICT);

define('APPPATH', '');
require('core/Common.php');
//CI_URI 已经实例化了
$URI= & load_class('URI');
$RTR=& load_class('Router');

//这会把URI中的函数执行一遍,并设置默认路由
$RTR->set_routing();
$class=$RTR->fetch_class();
$method=$RTR->fetch_method();

//现在分析出了类名和方法名了,要加载对应的控制器了
require('core/Controller.php');

//这函数放在这干嘛???
function &get_instance(){
    return CI_Controller::get_instance();
}

require('controllers/'.$class.'.php');
$CI=new $class();
$model="models/Testmodel";
$name="test";
$CI->load->model($model,$name);

print_r("hello");
die();


//call_user_func_array(array(&$CI,$method),array_slice($URI->rsegments,2));

?>