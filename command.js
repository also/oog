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
  var fnName = parts.pop();
  var m = goog.require(parts.join('.'));
  m[fnName].apply(m, args);
}
var main = process.argv[3];
if (main) {
  goog.load(main);
}
