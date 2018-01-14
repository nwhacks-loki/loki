window = global;
var rant = require("rantjs");

// Templates for news items of various emotions. Valid substitutions:
// https://github.com/svenanders/Rantjs/blob/master/ext/words.js
const feedTemplates = {
  "happy": [
    "<firstname> is happy!",
    "<firstname> is ecstatic!"
  ],

  "sad": [
    "<firstname> is sad."
  ],

  "angry": [
    "<firstname> is angry."
  ],

  "surprised": [
    "<firstname> is surprised!"
  ]
};

/**
* Returns a random feed item for the given emotion.
* @param {string} emotion The emotion (happy, sad, angry, surprised)
* @returns {string}
*/
module.exports = (emotion, context, callback) => {
  var feedItem;

  if (emotion in feedTemplates) {
    var choices = feedTemplates[emotion];
    var sentence = choices[Math.floor(Math.random() * choices.length)];
    callback(null, rant(sentence))
  } else {
    callback(null, "invalid emotion");
  }
};
