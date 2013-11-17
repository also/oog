#!/usr/bin/env node
var oog = require('./oog');
var args = process.argv.slice(2);
var goog = oog(args.shift());
var main = null;
while (args.length > 0) {
  var arg = args.shift();
  if (arg === '-m') {
    main = args.shift();
    break;
  }
  else {
    goog.load(arg);
  }
}

if (main) {
  var parts = main.split('.');
  parts.pop();
  goog.require(parts.join('.'));
  goog.require(main).apply(null, args);
}
