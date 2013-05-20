<?php

class AuthorMatch {

	public function getAuthors($string, $books) {
		global $matches;
		$s = ltrim($string, '@');
		$pattern = '/'. $s . '/i';
		$matches = array();		
		$namePresent = false; // flag var

		foreach($books->book as $book) {
			foreach($book->authors->author as $author) {
				
        // If the author matches our regex.
				if (preg_match($pattern, $author)) {
					$i = 0;
					$a = (string)$author;
					$len = count($matches);
					
          // Loop through $matches and if the author is already added switch our flag var.
					for ($i; $i < $len; $i++) {
						if ($a === $matches[$i]) {
							$namePresent = true;
						}
					}
					
          // If the flag var is still false that means the author hasn't been added to array yet.
					if (!$namePresent) {
						// Add the author.
						array_push($matches, $a);
					}
					
          // Reset $namePresent for next author loop.
					$namePresent = false;
				}
			}
		}

		$matches = json_encode($matches);

		return $matches;
	}
}