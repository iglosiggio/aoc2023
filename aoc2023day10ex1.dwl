var m = payload
var lines = m splitBy '\n'
type Pipe = '|' | '-' | 'L' | 'J' | '7' | 'F'
type Point = { x: Number, y: Number }
var width = sizeOf(lines[0])
var height = sizeOf(lines)
var start =
    lines
        map ($ indexOf 'S')
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
    var p_offset = p.y * (width + 1) + p.x
    var p2 = neighbours[c](p) filter ($ != path[-2]) then $[0]
    var p2_offset = p2.y * (width + 1) + p2.x
    var next = m[p2_offset]
    ---
    if (next == 'S')
        path
    else
        wanderFrom(m[p2_offset], path << p2)
}
---
sizeOf(wanderFrom('-', [start])) / 2
