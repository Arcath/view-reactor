React = require('react');

module.exports = React.createClass({
  render: ->
    React.createElement(
      "div",
      null,
      "Hello ",
      @props.name,
      ' ',
      React.createElement(
        "span",
        null,
        new Date().toString()
      )
    )
})
