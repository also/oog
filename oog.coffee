vm = require 'vm'
fs = require 'fs'
path = require 'path'

module.exports = (file_or_dir) ->
  context = vm.createContext()

  load = (filename) ->
    script = fs.readFileSync filename, 'utf8'
    # remove shebang
    script = script.replace /^\#\!.*/, ''
    vm.runInContext script, context, filename

  if fs.statSync(file_or_dir).isFile()
    load path.resolve file_or_dir
  else
    base_dir = path.resolve file_or_dir
    base_subdir = path.resolve base_dir, 'goog'
    if fs.existsSync base_subdir
      base_dir = base_subdir

    load path.resolve base_dir, 'base.js'
    load path.resolve base_dir, 'deps.js'
  {goog} = context

  if goog?
    if not context.COMPILED
      goog_require = goog.require
      goog.require = (name) ->
        return if goog.isProvided_ name
        filename = goog.dependencies_.nameToPath[name]
        load path.resolve base_dir, filename if filename?
        goog_require name
      require = (name) ->
        goog.require name
        goog.getObjectByName name
  else
    require = (name) ->
      cur = context
      for part in name.split '.'
        cur = cur[part]
        throw new Error "could not find: #{name}" unless cur?
      cur

  load: load
  goog: goog
  global: context
  require: require
