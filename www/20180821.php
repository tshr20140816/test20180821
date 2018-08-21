<?php

$res = get_contents($_GET['u']);

error_log($res);
echo $res;

function get_contents($url_) {
  error_log($url_);
  $pid = getmypid();
  $ch = curl_init();
  curl_setopt_array($ch,
                    [CURLOPT_URL => $url_,
                     CURLOPT_RETURNTRANSFER => TRUE,
                     CURLOPT_ENCODING => '',
                     CURLOPT_CONNECTTIMEOUT => 20,
                     CURLOPT_FOLLOWLOCATION => TRUE,
                     CURLOPT_MAXREDIRS => 3,
                     CURLOPT_FILETIME => TRUE,
                     CURLOPT_PATH_AS_IS => TRUE,
                     CURLOPT_USERAGENT => 'Mozilla/5.0 (Windows NT 6.1; rv:56.0) Gecko/20100101 Firefox/61.0',
                    ]);
  @curl_setopt($ch, CURLOPT_TCP_FASTOPEN, TRUE);
  $contents = curl_exec($ch);
  $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  error_log($http_code);
  
  curl_close($ch);
  
  return $contents;
}

?>
