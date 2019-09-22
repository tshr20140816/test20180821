<?php

$options = [
            CURLOPT_URL => getenv('TEST_URL_01'),
            // CURLOPT_USERAGENT => getenv('USER_AGENT'),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_MAXREDIRS => 3,
            CURLOPT_PATH_AS_IS => true,
            CURLOPT_TCP_FASTOPEN => true,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_2TLS,
            CURLOPT_TIMEOUT => 25,
            CURLOPT_HEADER => true,
           ];

$ch = curl_init();
$rc = curl_setopt_array($ch, $options);

$res = curl_exec($ch);

curl_close($ch);

error_log($res);
