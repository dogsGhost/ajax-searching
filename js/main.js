// Generated by CoffeeScript 1.6.1
(function() {
  'use strict';
  var app;

  app = {
    init: function() {
      this.cacheVariables();
      return this.bindElements();
    },
    cacheVariables: function() {
      this.inputField = document.getElementById('author');
      this.matches = document.getElementById('matches');
      this.results = document.getElementById('results');
      this.noResults = false;
      this.prevMatch = '';
      this.resultsTemplate = document.getElementById('resultsTemplate').innerHTML;
    },
    bindElements: function() {
      this.inputField.addEventListener('keyup', this.requestAuthors);
      return this.inputField.addEventListener('keydown', this.downArrow);
    },
    requestAuthors: function() {
      var data, regex;
      data = app.inputField.value;
      regex = new RegExp(app.prevMatch, 'ig');
      if (!app.noResults || (app.noResults && !regex.test(data))) {
        if (!data) {
          app.matches.style.display = 'none';
        } else {
          data = "@@" + data;
          return app.sendRequest('php/json.php', app.handleAuthorRequest, data);
        }
      }
    },
    handleAuthorRequest: function(req) {
      var i, json, output;
      json = JSON.parse(req.responseText);
      i = json.length;
      output = '';
      if (!i) {
        output = '<li class="item error">No matches found.</li>';
        app.noResults = true;
        app.prevMatch = app.inputField.value;
      } else {
        app.noResults = false;
        while (i--) {
          output += "<li tabindex='0' class='item'>" + json[i] + "</li>";
        }
        app.matches.addEventListener('keydown', app.keyActions);
      }
      app.matches.innerHTML = output;
      app.matches.style.display = 'block';
    },
    downArrow: function(evt) {
      evt = evt || window.event;
      if (evt.keyCode === 40 && this.value) {
        return app.matches.getElementsByTagName('li')[0].focus();
      }
    },
    keyActions: function(evt) {
      var cur;
      evt = evt || window.event;
      cur = evt.target || evt.srcElement;
      if (cur.nodeName.toLowerCase() === 'li') {
        switch (evt.keyCode) {
          case 40:
            if (cur.nextSibling) {
              return cur.nextSibling.focus();
            }
            break;
          case 38:
            if (cur.previousSibling) {
              return cur.previousSibling.focus();
            }
            break;
          case 13:
            cur.parentNode.style.display = 'none';
            return app.requestBooks(cur.innerHTML);
          default:
            break;
        }
      }
    },
    requestBooks: function(string) {
      return app.sendRequest('php/json.php', app.handleBooksRequest, string);
    },
    handleBooksRequest: function(req) {
      var json;
      json = JSON.parse(req.responseText);
      app.results.innerHTML = app.assembleTemplate(app.resultsTemplate, json);
      app.inputField.value = '';
      return app.inputField.focus();
    },
    assembleTemplate: function(template, arr) {
      var obj, output, replaceBrackets, _i, _len;
      output = '';
      replaceBrackets = function(object) {
        var key, pattern, temp, value;
        temp = '';
        for (key in object) {
          value = object[key];
          if (object.hasOwnProperty(key)) {
            pattern = new RegExp("@=" + key + "=@", 'ig');
            temp = (temp || template).replace(pattern, value);
          }
        }
        return temp;
      };
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        obj = arr[_i];
        output += replaceBrackets(obj);
      }
      return output;
    },
    sendRequest: function(url, callback, postData) {
      var requestType, xhr;
      xhr = new XMLHttpRequest();
      if (!xhr) {
        return false;
      }
      requestType = postData ? 'POST' : 'GET';
      xhr.open(requestType, url, true);
      xhr.setRequestHeader('X-Requesteed-With', 'XMLHttpRequest');
      if (postData) {
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
      }
      xhr.onreadystatechange = function() {
        if (xhr.readyState !== 4) {
          return;
        }
        if (xhr.status !== 200 && xhr.status !== 304) {
          return;
        }
        return callback(xhr);
      };
      if (xhr.readyState === 4) {
        return;
      }
      if (postData) {
        return xhr.send("data=" + postData);
      } else {
        return xhr.send(null);
      }
    }
  };

  app.init();

}).call(this);
