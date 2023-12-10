import * from dw::core::Arrays
var m = payload
var S_replacement = '-'
var lines = m dw::Core::splitBy '\n'
type Pipe = '|' | '-' | 'L' | 'J' | '7' | 'F'
type Point = { x: Number, y: Number }
var width = sizeOf(lines[0])
var height = sizeOf(lines)
var start =
    lines
        map ($ dw::Core::indexOf 'S')
        map { x: $, y: $$ }
        filter $.x != -1
        then $[0]
var neighbours: { (Pipe): (Point) -> Array<Point> } = {
    '|': (p) -> [{ x: p.x, y: p.y - 1 }, { x: p.x, y: p.y + 1 }],
    '-': (p) -> [{ x: p.x - 1, y: p.y }, { x: p.x + 1, y: p.y }],
    'L': (p) -> [{ x: p.x, y: p.y - 1 }, { x: p.x + 1, y: p.y }],
    'J': (p) -> [{ x: p.x, y: p.y - 1 }, { x: p.x - 1, y: p.y }],
    '7': (p) -> [{ x: p.x, y: p.y + 1 }, { x: p.x - 1, y: p.y }],
    'F': (p) -> [{ x: p.x, y: p.y + 1 }, { x: p.x + 1, y: p.y }],
    '.': (p) -> [],
}
@TailRec()
fun wanderFrom(c: Pipe, path: Array<Point>): Object = do {
    var p = path[-1]
    var p2 = neighbours[c](p) filter ($ != path[-2]) then $[0]
    var p2_offset = p2.y * (width + 1) + p2.x
    var next = m[p2_offset]
    ---
    if (next == 'S')
        path
    else
        wanderFrom(m[p2_offset], path << p2)
}
var m_no_S = m replace 'S' with S_replacement
---
wanderFrom(S_replacement, [start])
    orderBy $.x
    groupBy $.y
    mapObject {
        ($$): (do {
            var head = $[0]
            var tail = ($ as Array)[1 to -1]
            var c = m_no_S[head.y * (width + 1) + head.x]
            var init_state = {
                prev: c,
                inside: c == '|',
                x: head.x,
                acc: 0
            }
            ---
            tail reduce (v, acc=init_state) -> do {
                var c = m_no_S[v.y * (width + 1) + v.x]
                var change = c == '|'
                          or (c == '7' and acc.prev == 'L')
                          or (c == 'J' and acc.prev == 'F')
                var entering = c == 'F' or c == 'L' or c == '|'
                var assert =
                    if (c == '|' and (acc.prev == 'L' or acc.prev == 'F')) ???
                    else 0
                ---
                {
                    prev: if (c != '-') c else acc.prev,
                    inside: if (change) not acc.inside else acc.inside,
                    x: v.x,
                    acc: if (acc.inside and entering) (v.x-acc.x-1) + acc.acc else acc.acc
                }
            }
        }).acc as Number
    }
    then sum(valuesOf($))
