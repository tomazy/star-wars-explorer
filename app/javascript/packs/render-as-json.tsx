import * as React from 'react'

interface Link {
  _href: string
  _text: string
}

type SyntaxTuple = [string, string | JSX.Element]
export type LinkFactory = (href: string, text: string) => JSX.Element

export function renderAsJson(o: any, linkFactory: LinkFactory) {
  const syntax = []
  renderRecursive(o, syntax, 0, linkFactory)
  return syntax.map((tuple, i) => {
    const [className, element] = tuple
    return <span key={i} className={className || undefined}>{element}</span>
  })
}

const kwd = (s: string): SyntaxTuple => ['dark-blue', s]
const prop = (s: string): SyntaxTuple => ['dark-green', '"' + s + '"']
const pun = (s: string): SyntaxTuple => ['silver', s]
const str = (s: string): SyntaxTuple => ['orange', s]
const num = (n: number): SyntaxTuple => ['purple', String(n)]
const br = (): SyntaxTuple => ['', '\n']
const pad = (n: number): SyntaxTuple => ['', repeatString(' ', n)]

const TAB_SIZE = 4

const COMMA = pun(',')
const CURLY_OPEN = pun('{')
const CURLY_CLOSE = pun('}')
const SQUARE_OPEN = pun('[')
const SQUARE_CLOSE = pun(']')
const COLON = pun(':')
const BR = br()
const NULL = kwd('null')
const SPACE = pad(1)

function renderRecursive(o: any, syntax: SyntaxTuple[], indent: number, linkFactory: LinkFactory) {
  if (o === null) {
    syntax.push(NULL)
  } else if (isNumber(o)) {
    syntax.push(num(o))
  } else if (isString(o)) {
    renderString(o)
  } else if (isArray(o)) {
    renderArray(o)
  } else if (isLink(o)) {
    renderLink(o)
  } else if (isObject(o)) {
    renderObject(o)
  } else {
    console.warn('Unhandled case for', o)
  }

  function renderString(s: string) {
    const lines = s.split(/\n/)
    if (lines.length < 2) {
      syntax.push(str('"' + s + '"'))
    } else {
      lines.forEach((line, idx) => {
        const isFirstLine = idx === 0
        const isLastLine = idx === lines.length - 1

        syntax.push(BR, pad((indent + 1) * TAB_SIZE))

        syntax.push(
          str(
            (isFirstLine ? '"' : ' ') + line + (isLastLine ? '"' : '')
          )
        )
      })
    }
  }

  function renderArray(o: any[]) {
    syntax.push(SQUARE_OPEN)
    if (o.length) {
      syntax.push(BR)
      o.forEach((e, idx) => {
        syntax.push(pad((indent + 1) * TAB_SIZE))
        renderRecursive(e, syntax, indent + 1, linkFactory)
        if (idx < o.length - 1) {
          syntax.push(COMMA)
        }
        syntax.push(BR)
      })
      syntax.push(pad(indent * TAB_SIZE))
    }
    syntax.push(SQUARE_CLOSE)
  }

  function renderObject(o: any) {
    syntax.push(CURLY_OPEN)
    const keys = Object.keys(o)
    if (keys.length) {
      syntax.push(BR)
      keys.forEach((key, idx) => {
        syntax.push(pad((indent + 1) * TAB_SIZE), prop(key), COLON, SPACE)
        renderRecursive(o[key], syntax, indent + 1, linkFactory)
        if (idx < keys.length - 1) {
          syntax.push(COMMA)
        }
        syntax.push(BR)
      })
      syntax.push(pad(indent * TAB_SIZE))
    }
    syntax.push(CURLY_CLOSE)
  }

  function renderLink(l: Link) {
    syntax.push(['', linkFactory(l._href, `"${l._text}"`)])
  }
}

function isString(o: any): o is string {
  return typeof o === 'string'
}

function isLink(o: any): o is Link {
  return (o && isString(o._href) && isString(o._text))
}

function isObject(o: any): o is Object {
  return (o && typeof o === 'object')
}

function isArray(o: any): o is any[] {
  return Array.isArray(o)
}

function isNumber(o: any): o is number {
  return Number.isFinite(o)
}

function repeatString(s: string, times: number): string {
  const parts = []
  while (times--) {
    parts.push(s)
  }
  return parts.join('')
}
