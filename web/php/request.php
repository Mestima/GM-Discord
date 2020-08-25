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

	function file_get_contents_utf8($fn) {
		$content = file_get_contents($fn);
		$content = iconv('windows-1251', 'utf-8', $content);
		return $content;
	}

	$channel	= $_GET['channel'];
	$token		= $_GET['token'];
			
	$result = file_get_contents_utf8("https://discordapp.com/api/channels/" . $channel . "/messages?token=Bot%20" . $token);
	echo $result;
?>
