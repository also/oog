vm = require 'vm'
fs = require 'fs'
path = require 'path'
Module = require 'module'

oog = (file_or_dir) ->
  goog = global: {}
  goog.global.goog = goog
  context = null

  load = (filename) ->
    script = fs.readFileSync filename, 'utf8'
    # remove shebang
    script = script.replace /^\#\!.*/, ''
    m = new Module filename, module

    if script.substr(0, 100).indexOf('var COMPILED = false') > -1
      script = "with (exports) {\n#{script}\n}"
      m.exports = goog.global

    script = "(function(goog, exports, require, module, __filename, __dirname) {#{script}})"
    wrapped = vm.runInThisContext script, filename
    wrapped.call m.exports, goog, m.exports, require, m, filename, path.dirname filename
    m

  if fs.statSync(file_or_dir).isFile()
    context = load(path.resolve(file_or_dir)).exports
  else
    base_dir = path.resolve file_or_dir
    base_subdir = path.resolve base_dir, 'goog'
    if fs.existsSync base_subdir
      base_dir = base_subdir

    load path.resolve(base_dir, 'base.js')
    load path.resolve base_dir, 'deps.js'

  if goog?.isProvided_?
    goog_require = goog.require
    goog.require = (name) ->
      return if goog.isProvided_ name
      filename = goog.dependencies_.nameToPath[name]
      load path.resolve base_dir, filename if filename?
      goog_require name
    local_require = (name) ->
      goog.require name
      goog.getObjectByName name
  else
    local_require = (name) ->
      cur = context
      for part in name.split '.'
        cur = cur[part]
        throw new Error "could not find: #{name}" unless cur?
      cur

  load: load
  goog: goog
  require: local_require

module.exports = oog
