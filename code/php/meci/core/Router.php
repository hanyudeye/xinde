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
        //根据routes.php文件中定义的路由设置路由表,没有的话设置为空
        $this->routes=(!isset($route) OR ! is_array($route))?array():$route;
        //根据配置设定default_controller这条路由,如果没有设定false
        unset($route);
        $this->default_controller= (!isset($this->routes['default_controller']) OR $this->routes['default_controller']=='')?FALSE:$this->routes['default_controller'];
        //调用从构造器中实例化得URI对象中的函数
        $this->uri->fetch_uri_string();
        //上面的函数设定了uri_string,如果空,就跳到下面,但什么也不做
        if($this->uri->uri_string==''){
            return $this->set_default_controller();
        }
        //把uri对象中的函数执行一遍
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
    //根据地址分析出类,字符串输出
    function fetch_class()
    {
        return $this->class;
    }

    //根据地址分析出方法,字符串输出
    function fetch_method()
    {
        return $this->method;
    }

}

?>