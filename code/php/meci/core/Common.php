<?php

//加载类的功能
function &load_class($class,$directory='core'){

    //定义存储这些重要类实例全局变量的静态数组
    static $_classes=array();
    //当加载的类实例,如果有了,就把这个实例返回就可以了
    if(isset($_classes[$class])){
        return $_classes[$class];
    }
    //在我们的框架中,每个类实例都有前缀CI_
    $name='CI_'.$class;

    if(file_exists($directory.'/'.$class.'.php')){
        require($class.'.php');
    }else{
        exit("Unable to locate the class");
    }

    //跟踪我们加载过的类
    is_loaded($class);

    $_classes[$class]=new $name();
    return $_classes[$class];
}

//把加载的类名存起来
function is_loaded($class=''){
    static $_is_loaded=array();

    if($class !=''){
        $_is_loaded[strtolower($class)]=$class;
    }
    return $_is_loaded;
}



?>