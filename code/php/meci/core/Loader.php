<?php
class CI_Loader{
    //loader ���еĶ�����,��model����
    protected $_ci_model_paths=array();
    protected $_ci_models=array();

    function __construct(){
        //��ʼ��һ����·����Ϊ�յ�ģ��·��,
        $this->_ci_model_paths=array('');   
    }

    //var @model ·��ģ����,var @name ģ����,��@modelȡ��
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

        //model�Ƿ���һ���ļ�����,����ǵĻ�,�����·�����ļ���
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
            //����models�е�model ������
            if(!class_exists('CI_Model')){
                load_class('Model','core');
            }
            require_once($mod_path.$path.$model.'.php');
            $model=ucfirst($model);
            $CI->$name=new $model();
            $this->_ci_models[]=$name;
            return;
        }
        //�Ҳ���ģ��
        exit('Unable to locate the model you have specified:'.$model);
    }

function initialize(){
        return;
    }

}
?>