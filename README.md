# oog

Use [Google Closure Library](https://developers.google.com/closure/library/) in node.js.

Oog doesn't provide the libraries, but it makes it simple to use and distribute code that relies on them.

## Installation

```
npm install oog
```

For command-line usage:

```
npm install -g oog
```

## Usage

**example.js**:
```javascript
goog.addDependency('../../../helloworld.js', ['helloworld'], []);
```

**example/helloworld.js**:
```javascript
goog.provide('helloworld');
helloworld.sayHello = function(name) {
  console.log('Hello, ' + name);
}
goog.exportSymbol('helloworld.sayHello', helloworld.sayHello);
```

You can load Closure libraries:

```coffeescript
oog = require 'oog'
goog = oog 'closure-library/closure'
goog.load 'example.js'
helloworld = goog.require 'helloworld'
helloworld.sayHello 'World'
```

You can call functions in Closure Libraries from the command line:

```
oog closure-library/closure example.js -m helloworld.sayHello World
```

After compiling, you don't need to include the path to the Closure Library.

```
python closure-library/closure/bin/build/closurebuilder.py \
  --root closure-library \
  --root example \
  --namespace "helloworld" \
  --output_mode=compiled \
  --compiler_jar=compiler.jar > example-compiled.js
```

```
oog example-compiled.js -m helloworld.sayHello World
```

```coffeescript
require('oog')('example-compiled.js').require('helloworld').sayHello('World')
```
