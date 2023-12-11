import * from dw::core::Arrays
var in = payload
var lines = in splitBy ('\n')
var width = sizeOf(lines[0])
var height = sizeOf(lines)
fun at(y: Number, x: Number): Boolean = in[y * (width + 1) + x] == '#'
fun iota(start: Number, end: Number): Array<Number> = 
    if (start < end)
        (start to end) as Array<Number>
    else
        []
var emptyRows =
    iota(0, height - 1)
        filter (y) ->
            iota(0, (width - 1))
                every (x) -> not at(y, x)
var emptyColumns =
    iota(0, width - 1)
        filter (x) ->
            iota(0, (height - 1))
                every (y) -> not at(y, x)
fun remap(size: Number, emptyList: Array<Number>) =
    iota(0, size - 1)
        map (i) -> do {
            var remap = (emptyList indexWhere i < $)
            ---
            if (remap == -1) i + sizeOf(emptyList) * 999999
            else i + remap * 999999
        }
var columnRemap = remap(width, emptyColumns)
var rowRemap = remap(height, emptyRows)
var galaxies =
    iota(0, height - 1)
        flatMap (y) ->
            iota(0, (width - 1))
                filter ((x) -> at(y, x))
                //map (x) -> { y: y, x: x }
                map (x) -> { y: rowRemap[y], x: columnRemap[x] }
---
galaxies[0 to -2]
    flatMap ((a, i) ->
        galaxies[i+1 to -1]
            map (b) -> abs(b.y-a.y) + abs(b.x-a.x))
    sumBy $
