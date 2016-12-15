<?php
class CI_Loader{
    //loader 类中的额内容,有model对象
    protected $_ci_model_paths=array();
    protected $_ci_models=array();

    function __construct(){
        //初始化一个根路径名为空的模块路径,
        $this->_ci_model_paths=array('');   
    }

    //var @model 路由模块名,var @name 模块名,由@model取得
    public function model($model,$name=""){
        if(is_array($model)){
            foreach($model as $baby){
                $this->model($baby);
            }
            return;
        }
        if($model==''){
            return;
        }
        $path='';

        //model是否在一个文件夹中,如果是的话,则分析路径和文件名
        if(($last_slash=strrpos($model,'/'))!==FALSE){
            $path=substr($model,0,$last_slash+1);
            $model=substr($model,$last_slash+1);
        }
        if($name==''){
            $name=$model;
        }

        if(in_array($name,$this->_ci_models,TRUE)){
            return;
        }
        $model=strtolower($model);

        $CI=&get_instance();
        foreach($this->_ci_model_paths as $mod_path){
            if(!file_exists($mod_path.$path.$model.'.php')){
                continue;
            }
            //加载models中的model 控制器
            if(!class_exists('CI_Model')){
                load_class('Model','core');
            }
            require_once($mod_path.$path.$model.'.php');
            $model=ucfirst($model);
            $CI->$name=new $model();
            $this->_ci_models[]=$name;
            return;
        }
        //找不到模型
        exit('Unable to locate the model you have specified:'.$model);
    }

function initialize(){
        return;
    }

}
?>