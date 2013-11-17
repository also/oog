vm = require 'vm'
fs = require 'fs'
path = require 'path'

module.exports = (dir) ->
  base_dir = path.resolve dir
  context = vm.createContext()

  load = (filename) ->
    script = fs.readFileSync filename, 'utf8'
    vm.runInContext script, context, filename

  load path.resolve base_dir, 'base.js'
  load path.resolve base_dir, 'deps.js'
  {goog} = context

  goog_require = goog.require
  goog.require = (name) ->
    return if goog.isProvided_ name
    filename = goog.dependencies_.nameToPath[name]
    load path.resolve base_dir, filename if filename?
    goog_require name

  load: load
  goog: goog
  global: context
  require: (name) ->
    goog.require name
    goog.getObjectByName name
