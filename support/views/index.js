var React = require('react');

module.exports = React.createClass({
  render: function render() {
    return React.createElement(
      "div",
      null,
      "Hello ",
      this.props.name,
      ' ',
      React.createElement(
        "span",
        null,
        new Date().toString()
      )
    )
  }
})
