# mustard

Mustard uses [hogan.js](http://twitter.github.com/hogan.js/) to give you [mustache](http://mustache.github.com/) templates for your CLI applications.

## Install

    $ npm install mustard

## Why?

Writing applications is great, but getting your dynamic output to format correctly isn't.

## How to

**hello.mu**

    {{#col1}}Hello{{/col1}} my name is {{#red}}{{name}}{{/red}}.

**hello.js**

    var mustard = require('mustard');
    var util = require('util');

    var output = mustard('hello.mu', { name: 'Josh' }, {
      col1: {
        width: 20
      },
      red: {
        color: 'red'
      }
    });

    util.puts(output);

**stdout**

    Hello                my name is [[31mJosh^[[39m.

# License

[MIT LICENSE](http://josh.mit-license.org)
