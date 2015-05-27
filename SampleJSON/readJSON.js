//Node.js script to read and verify a json file, and print out a stringified version to console.

var fs = require('fs');

process.argv.slice(2).forEach(function (val, index) {
  try {
    var s = fs.readFileSync(val, { encoding: 'utf8' });
    var t = JSON.parse(s);
    console.log(index + ': ' + JSON.stringify(t));
  } catch (e) {
    console.log(val + ' was not valid JSON');
  }
});