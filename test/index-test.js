var vows = require('vows');
var assert = require('assert');
var fs = require('fs');
var mustard = require('../lib/mustard');

mustard.templates = __dirname + '/fixtures/actual/';

var testRunner = vows.describe('mustard').addBatch({
  'when using a template': {
    topic: function () {
      return mustard('sample', null, {
        red: {
          color: 'red'
        },
        col1: {
          width: 10
        },
        col2: {
          width: 8
        }
      });
    },

    'the proper text is returned': function (topic) {
      assert.equal(topic, fs.readFileSync(__dirname + '/fixtures/expected/sample.txt', 'utf-8'));
    }
  },

  'when styling a list': {
    topic: function () {
      return mustard('lists', { data: ['foo', 'bar', 'baz'] }, { data: { color: 'red' }});
    },

    'we get foo, bar, and baz but not in red': function (topic) {
      assert.equal(topic, fs.readFileSync(__dirname + '/fixtures/expected/lists.txt', 'utf-8'));
    }
  },

  'when using color': {
    topic: function () {
      return mustard('red', {}, { red: { color: 'red' }});
    },

    'we get result in red': function (topic) {
      assert.equal(topic, '\033[31mHello World\033[00m\n');
    }
  }
});

testRunner.export(module);
