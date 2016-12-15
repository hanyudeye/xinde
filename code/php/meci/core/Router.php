<?php
class CI_Router{
    var $uri;
    var $routes; //list of routes,@var array
    var $class; 
    var $method;
    var $default_controller;

    function __construct(){
        $this->uri=&load_class('URI');
    }

    function set_routing(){
        if(is_file('core/routes.php')){
            include('core/routes.php');
        }
        //����routes.php�ļ��ж����·������·�ɱ�,û�еĻ�����Ϊ��
        $this->routes=(!isset($route) OR ! is_array($route))?array():$route;
        //���������趨default_controller����·��,���û���趨false
        unset($route);
        $this->default_controller= (!isset($this->routes['default_controller']) OR $this->routes['default_controller']=='')?FALSE:$this->routes['default_controller'];
        //���ôӹ�������ʵ������URI�����еĺ���
        $this->uri->fetch_uri_string();
        //����ĺ����趨��uri_string,�����,����������,��ʲôҲ����
        if($this->uri->uri_string==''){
            return $this->set_default_controller();
        }
        //��uri�����еĺ���ִ��һ��
        $this->uri->explode_uri();
        $this->parse_routes();
    }

    function set_default_controller(){
        $default_controller='controllers';
    }

    function parse_routes(){
        $uri=implode('/',$this->uri->segments);
        if(isset($this->routes[$uri])){
            $rsegments=explode('/',$this->routes[$uri]);
            return $this->set_request($rsegments);
        }
    }

    function set_request($segments= array()){
        if(count($segments)==0){
            return $this->set_default_controller();
        }

        $this->set_class($segments[0]);
        if(isset($segments[1])){
        $this->set_method($segments[1]);
        }else{
            $method='index';
        }
        $this->uri->rsegments=$segments;
    }

    function set_class($class){
        $this->class=str_replace(array('/','.'),'',$class);
    }

function set_method($method){
    $this->method=$method;
}
    //���ݵ�ַ��������,�ַ������
    function fetch_class()
    {
        return $this->class;
    }

    //���ݵ�ַ����������,�ַ������
    function fetch_method()
    {
        return $this->method;
    }

}

?>