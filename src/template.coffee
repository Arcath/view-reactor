React = require 'react'

module.exports = React.createClass
  cleanProperty: (key, value) ->
    remove = ['title', 'viewMarkup', 'reactURL', 'viewURI', 'viewReactor', 'settings', 'cache', '_locals']
    if remove.indexOf(key) != -1
      return undefined
    else
      return value

  render: ->
    React.createElement 'html', null,
      React.createElement 'head', null,
        React.createElement 'title', null, @props.title
      React.createElement 'body', null,
        React.createElement 'div', {id: 'app', dangerouslySetInnerHTML: { __html: @props.viewMarkup }}
        React.createElement 'div', {id: 'data', style: {display: 'none'}}, JSON.stringify(@props, @cleanProperty)
        React.createElement 'script', {src: @props.reactURL, type: 'text/javascript'}
        React.createElement 'script', {src: @props.viewURI, type: 'text/javascript'}
        React.createElement 'script', {dangerouslySetInnerHTML: {__html: @props.viewReactor}}
