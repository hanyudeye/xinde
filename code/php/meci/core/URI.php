<?php
/**
 *URI Class
 *����URI,������·��
 */

class CI_URI{
	 // List of URI segments
    var $segments=array();

	/**
	 * Current URI string
	 * @var	string
	 */
    var $uri_string='';

    // List of routed URI segments
    var $rsegments;

    
    function fetch_uri_string(){
        if($uri=$this->detect_uri()){
            $this->set_uri_string($uri);
            return;
        }
    }

    function set_uri_string($str){
        $this->uri_string=($str=='/')?'':$str;
    }

    //��ȡURI,��ͨ��uri ������Ӧ�ķ���
    function detect_uri(){
        if(!isset($_SERVER['REQUEST_URI']) or !isset($_SERVER['SCRIPT_NAME'])){
            return '';
        }
        $uri=$_SERVER['REQUEST_URI'];
        if(strpos($uri,$_SERVER['SCRIPT_NAME'])===0){
            $uri=substr($uri,strlen($_SERVER['SCRIPT_NAME']));
        }

        if($uri == '/' || empty($uri)){
            return '/';
        }
        //�ö඼�������
        $uri = parse_url($uri,PHP_URL_PATH);

        //��·���е� '//'��'../'�Ƚ�������
        return str_replace(array('//','../'),'/',trim($uri,'/'));
    }

    function explode_uri(){
        foreach (explode('/',preg_replace("|/*(.+?)/*$|", "\\1", $this->uri_string)) as $val) {
            $var=trim($val);
            if($val!=''){
                $this->segments[]=$val;
            }
        }
    }
}

?>