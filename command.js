#!/usr/bin/env node
var oog = require('./oog');

function parseArgs() {
  var args = process.argv.slice(2);
  var base = args.shift();
  var load = [];
  var run = null;

  while (args.length > 0) {
    var arg = args.shift();
    if (arg === '-m') {
      run = {main: args.shift(), args: args};
      break;
    }
    else {
      load.push(arg);
    }
  }
  return {base: base, load: load, run: run};
}

function init(opts) {
  var goog = oog(opts.base);
  for (var i = 0; i < opts.load.length; i++) {
    goog.load(opts.load[i]);
  }
  return goog;
}

function run(opts, goog) {
  if (opts.run) {
    var parts = opts.run.main.split('.');
    parts.pop();
    goog.require(parts.join('.'));
    goog.require(opts.run.main).apply(null, opts.run.args);
  }
}

if (require.main === module) {
  var opts = parseArgs();
  var goog = init(opts);
  run(opts, goog);
}
else {
  exports.parseArgs = parseArgs;
  exports.init = init;
  exports.run = run;
}
