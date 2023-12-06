import takeWhile from dw::core::Arrays
import isNumeric from dw::core::Strings
var schematic = payload
    splitBy '\n'
    map (line) -> 0 to sizeOf(line)-1 map line[$]
var symbols = schematic
    map ((line, y) -> line map { pos: { x: $$, y: y }, char: $ })
    flatMap ($ filter $.char == '*')
var possibleNumberPositions = symbols
    map [
        { x: $.pos.x + 0, y: $.pos.y + 1 },
        { x: $.pos.x + 0, y: $.pos.y - 1 },
        { x: $.pos.x + 1, y: $.pos.y + 0 },
        { x: $.pos.x + 1, y: $.pos.y + 1 },
        { x: $.pos.x + 1, y: $.pos.y - 1 },
        { x: $.pos.x - 1, y: $.pos.y + 0 },
        { x: $.pos.x - 1, y: $.pos.y + 1 },
        { x: $.pos.x - 1, y: $.pos.y - 1 },
    ]
var numberPositions = possibleNumberPositions
    map ($ filter isNumeric(schematic[$.y][$.x]))
var partNumbers = numberPositions
    map (
        $ map do {
            var lhs = (schematic[$.y][$.x to 0] takeWhile (isNumeric($)))[-1 to 0]
            var rhs = (schematic[$.y][($.x+1) to -1] takeWhile (isNumeric($)))
            ---
            {
                row: $.y,
                col: $.x - sizeOf(lhs) + 1,
                part: ((lhs ++ rhs) joinBy '') as Number
            }
        }
        distinctBy $
    )
---
partNumbers
filter (sizeOf($) == 2)
map $[0].part * $[1].part
then sum($)