<?php

class BookMatch {

	public function getBooks($string, $books) {
		global $matches;

		$pattern = '/'. $string . '/i';
		$matches = array();		

		foreach($books->book as $book) {
			foreach($book->authors->author as $author) {
				$authorList = '';
				
        // If the author matches our regex.
				if (preg_match($pattern, $author)) {
					// Get all the authors for that book.
					foreach ($book->authors->author as $name) {
						$authorList .= $name . ', ';
					}
					$authorList = substr($authorList, 0, -2);
					
          // Push book info to our array.
					array_push($matches, array(
						'title'=>(string)$book->title,
						'authors'=>$authorList,
						'publisher'=>(string)$book->publisher,
						'isbn'=>(string)$book->isbn
					));
				}
			}
		}
		return json_encode($matches);
	}
}