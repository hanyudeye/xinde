<?php
/*��php��ϰ��һ����ܵĴ���
 *��ܵ������,Ϊ�˰�URL��λ����ͷ�����ʽ��
 */
ini_set("display_errors", "On");   
error_reporting(E_ALL | E_STRICT);

define('APPPATH', '');
require('core/Common.php');
//CI_URI �Ѿ�ʵ������
$URI= & load_class('URI');
$RTR=& load_class('Router');

//����URI�еĺ���ִ��һ��,������Ĭ��·��
$RTR->set_routing();
$class=$RTR->fetch_class();
$method=$RTR->fetch_method();

//���ڷ������������ͷ�������,Ҫ���ض�Ӧ�Ŀ�������
require('core/Controller.php');

//�⺯�����������???
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