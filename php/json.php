<?php

include_once('classes/AuthorMatch.php');
include_once('classes/BookMatch.php');

$data = $_POST['data'];
$file = simplexml_load_file("../files/books.xml");

// Check for our flag characters; if present we know its an author search, otherwise book search.
if (substr($data, 0, 2) === '@@') {
	$AuthorMatch = new AuthorMatch();
	echo $AuthorMatch->getAuthors($data, $file);
} else {
	$BookMatch = new BookMatch();
	echo $BookMatch->getBooks($data, $file);
}

