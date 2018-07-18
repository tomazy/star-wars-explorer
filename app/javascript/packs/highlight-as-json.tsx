interface Link {
  _href: string
  _text: string
}

export type LinkFactory = (href: string, text: string) => JSX.Element

export enum Syntax {
  whitespace,
  keyword,
  propertyName,
  punctuation,
  string,
  number,
  link,
}

type HighlightPair = [
  Syntax,
  string | JSX.Element
]

const TAB_SIZE = 4

export function highlightAsJson(o: any, linkFactory: LinkFactory) {
  return highlightAny(o, 0, linkFactory)
}

// HighlightPair generators
const kwd = (s: string): HighlightPair => [Syntax.keyword, s]
const prop = (s: string): HighlightPair => [Syntax.propertyName, dblQuote(s)]
const pun = (s: string): HighlightPair => [Syntax.punctuation, s]
const str = (s: string): HighlightPair => [Syntax.string, s]
const num = (n: number): HighlightPair => [Syntax.number, String(n)]
const br = (): HighlightPair => [Syntax.whitespace, '\n']
const pad = (n: number): HighlightPair => [Syntax.whitespace, repeatString(' ', n)]
const tabPad = (tabs: number): HighlightPair => pad(tabs * TAB_SIZE)

const COMMA = pun(',')
const CURLY_OPEN = pun('{')
const CURLY_CLOSE = pun('}')
const SQUARE_OPEN = pun('[')
const SQUARE_CLOSE = pun(']')
const COLON = pun(':')
const BR = br()
const NULL = kwd('null')
const SPACE = pad(1)

function highlightAny(o: any, indent: number, linkFactory: LinkFactory): HighlightPair[] {
  if (o === null) {
    return [NULL]
  } else if (isNumber(o)) {
    return [num(o)]
  } else if (isString(o)) {
    return highlightString(o, indent)
  } else if (isArray(o)) {
    return highlightArray(o, indent, linkFactory)
  } else if (isLink(o)) {
    return highlightLink(o, linkFactory)
  } else if (isObject(o)) {
    return highlightObject(o, indent, linkFactory)
  } else {
    console.warn('Unhandled case for', o)
    return []
  }
}

function highlightString(s: string, indent: number): HighlightPair[] {
  const result = []
  const lines = s.split(/\n/)
  if (lines.length < 2) {
    result.push(str(dblQuote(s)))
  } else {
    lines.forEach((line, idx) => {
      const isFirstLine = idx === 0
      const isLastLine = idx === lines.length - 1

      result.push(BR, tabPad(indent + 1))

      result.push(
        str(
          (isFirstLine ? '"' : ' ') + line + (isLastLine ? '"' : ''),
        ),
      )
    })
  }
  return result
}

function highlightArray(arr: any[], indent: number, linkFactory: LinkFactory): HighlightPair[] {
  const result = []
  result.push(SQUARE_OPEN)
  if (arr.length > 0) {
    result.push(BR)
    arr.forEach((item, idx) => {
      const isLast = idx === arr.length - 1

      result.push(tabPad(indent + 1))
      result.push(...highlightAny(item, indent + 1, linkFactory))

      if (!isLast) result.push(COMMA)

      result.push(BR)
    })
    result.push(tabPad(indent))
  }
  result.push(SQUARE_CLOSE)
  return result
}

function highlightObject(obj: object, indent: number, linkFactory: LinkFactory): HighlightPair[] {
  const result = []
  result.push(CURLY_OPEN)
  const keys = Object.keys(obj)
  if (keys.length) {
    result.push(BR)
    keys.forEach((key, idx) => {
      const isLast = idx === keys.length - 1

      result.push(tabPad(indent + 1), prop(key), COLON, SPACE)
      result.push(...highlightAny(obj[key], indent + 1, linkFactory))

      if (!isLast) result.push(COMMA)

      result.push(BR)
    })
    result.push(tabPad(indent))
  }
  result.push(CURLY_CLOSE)
  return result
}

function highlightLink(l: Link, linkFactory: LinkFactory): HighlightPair[] {
  return [
    [Syntax.link, linkFactory(l._href, dblQuote(l._text))],
  ]
}

function isString(o: any): o is string {
  return typeof o === 'string'
}

function isLink(o: any): o is Link {
  return (o && isString(o._href) && isString(o._text))
}

function isObject(o: any): o is object {
  return (o && typeof o === 'object')
}

function isArray(o: any): o is any[] {
  return Array.isArray(o)
}

function isNumber(o: any): o is number {
  return Number.isFinite(o)
}

function dblQuote(s: string) {
  return '"' + s + '"'
}

function repeatString(s: string, times: number): string {
  const parts = []
  while (times--) {
    parts.push(s)
  }
  return parts.join('')
}

