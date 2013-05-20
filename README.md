Searching with AJAX
===================

Simple demo of using AJAX to dynamically return a list of matches as a user types in a search field, then load in content when an option is selected.

While our data source (in this case a XML file) is small enough that we could simply make 1 request at page load and filter the information on the client-side as needed, this method doesn't scale well with larger datasets.

Note: No fallbacks are in place for addEventListener or XMLHttpRequest so this code will fail in IE < 9.