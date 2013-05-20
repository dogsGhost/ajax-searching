<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Author Searching with AJAX</title>
  <link href="css/style.css" rel="stylesheet">
</head>
<body>
  <div class="wrapper">
  	<div class="header" role="banner">
  		<h1 class="heading">Author Searching with AJAX</h1>
  	</div>
  	<div class="section" role="main">
  		<h2>Instructions</h2>
  		<ol>
  			<li>Start typing an author's name to bring up a list of matches. The program will match partial names as well.</li>
  			<li>Press the down arrow to enter the list of matching authors. Use the up and down arrows to navigate through the list.</li>
  			<li>When the author you are looking for is highlighted, press the Enter key to show the books they have written.</li>
  		</ol>
  		<div class="container">
  			<label for="author">Enter Author:</label>
  			<input type="text" size="25" name="author" id="author">
  			<ul id="matches" class="matches"></ul>
  		</div>
  		<div id="results" class="results"></div>
  	</div>
    <div class="footer section" role="contentinfo">
      <small>2012 | <a href="http://davwilh.com/">David made this</a></small>
    </div>
  </div>

  <script type="davwilh_template" id="resultsTemplate">
  	<div class="book section">
  		<b>Title: </b> @=title=@ <br>
  		<b>Author(s): </b> @=authors=@ <br>
  		<b>Publisher: </b> @=publisher=@ <br>
  		<b>ISBN: </b> @=isbn=@
  	</div>
  </script>

  <script src="js/main.js"></script>
</body>
</html>