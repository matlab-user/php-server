<?php 
	$raw_post_data = file_get_contents( 'php://input' );
	echo $raw_post_data.'\n'; 
?> 