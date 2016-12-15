<?php
/**
 *URI Class
 *分析URI,并决定路由
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

    //获取URI,并通过uri 调用相应的方法
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
        //好多都是冗余的
        $uri = parse_url($uri,PHP_URL_PATH);

        //将路径中的 '//'或'../'等进行清理
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