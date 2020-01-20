<?php
function microtime_float()
{
    list($usec, $sec) = explode(" ", microtime());
    return ((float)$usec + (float)$sec);
}

$time_start = microtime_float();

// Sleep for a while
usleep(100);

$time_end = microtime_float();
$time = $time_end - $time_start;
function getRealIpAddr()
{
    if (!empty($_SERVER['HTTP_CLIENT_IP']))   //check ip from share internet
    {
      $ip=$_SERVER['HTTP_CLIENT_IP'];
    }
    elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))   //to check ip is pass from proxy
    {
      $ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
    }
    else
    {
      $ip=$_SERVER['REMOTE_ADDR'];
    }
    return $ip;
}
echo '<b style="color: red">
      SOURCE & DESTINATION ADDRESSES
      </b></br> ';
echo '<strong>'. "INTERVAL" .'</strong>: '. $time .'<br />';
$localIPAddress = getHostByName(getHostName());
$sourceIPAddress = getRealIpAddr();
echo '<strong>'. "SOURCE IP" .'</strong>: '. $sourceIPAddress .'<br />';
echo '<strong>'. "LOCAL  IP" .'</strong>: '. $localIPAddress .'<br />';

$vm_name = gethostname();
echo '<strong>'. "VM NAME" .'</strong>: '. $vm_name .'<br />';
echo ''. '<br />';
echo '<b style="color: blue">
      HEADER INFORMATION
      </b></br> ';
/* All $_SERVER variables prefixed with HTTP_ are the HTTP headers */
foreach ($_SERVER as $header => $value) {
  if (substr($header, 0, 5) == 'HTTP_') {
    /* Strip the HTTP_ prefix from the $_SERVER variable, what remains is the header */
    $clean_header = strtolower(substr($header, 5, strlen($header)));

    /* Replace underscores by the dashes, as the browser sends them */
    $clean_header = str_replace('_', '-', $clean_header);

    /* Cleanup: standard headers are first-letter uppercase */
    $clean_header = ucwords($clean_header, " \t\r\n\f\v-");

    /* And show'm */
    echo '<strong>'. $header .'</strong>: '. $value .'<br />';
  }
}
?>
