<?php
/*
	COPYRIGHT:
		Made by Mestima © 2019
	
		If you're reading this at the GitHub, you need to know
		that this script is licensed under the GPLv3 License (https://www.gnu.org/licenses/gpl-3.0.html)
		Copyright removing is NOT allowed!
		
		http://steamcommunity.com/id/mestima
		http://github.com/Mestima
*/

	if (!isset($_POST["content"]) || !isset($_POST["webhook"])) exit();
	
	$options = array(
		'http' => array(
			'header'  => "Content-type: application/json\r\n",
			'method'  => 'POST',
			'content' => $_POST["content"]
		)
	);
	$context  = stream_context_create($options);
	$result = file_get_contents($_POST["webhook"], false, $context);
?>