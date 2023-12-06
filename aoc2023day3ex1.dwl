import takeWhile from dw::core::Arrays
import isNumeric from dw::core::Strings
var schematic = payload
    splitBy '\n'
    map (line) -> 0 to sizeOf(line)-1 map line[$]
var symbols = schematic
    map ((line, y) -> line map { pos: { x: $$, y: y }, char: $ })
    flatMap ($ filter (not isNumeric($.char)) and $.char != '.')
var possibleNumberPositions = symbols
    flatMap [
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
    filter isNumeric(schematic[$.y][$.x])
var partNumbers = numberPositions
    map do {
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
---
sum(partNumbers.part)