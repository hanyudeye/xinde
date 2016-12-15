<?php

//������Ĺ���
function &load_class($class,$directory='core'){

    //����洢��Щ��Ҫ��ʵ��ȫ�ֱ����ľ�̬����
    static $_classes=array();
    //�����ص���ʵ��,�������,�Ͱ����ʵ�����ؾͿ�����
    if(isset($_classes[$class])){
        return $_classes[$class];
    }
    //�����ǵĿ����,ÿ����ʵ������ǰ׺CI_
    $name='CI_'.$class;

    if(file_exists($directory.'/'.$class.'.php')){
        require($class.'.php');
    }else{
        exit("Unable to locate the class");
    }

    //�������Ǽ��ع�����
    is_loaded($class);

    $_classes[$class]=new $name();
    return $_classes[$class];
}

//�Ѽ��ص�����������
function is_loaded($class=''){
    static $_is_loaded=array();

    if($class !=''){
        $_is_loaded[strtolower($class)]=$class;
    }
    return $_is_loaded;
}



?>