in splitBy '\n'
map do {
    var tab = {
        '0': '0', '1': '1', '2': '2', '3': '3', '4': '4',
        '5': '5', '6': '6', '7': '7', '8': '8', '9': '9',
        'one': '1', 'two': '2', 'three': '3', 'four': '4',
        'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9'
    }
    var first = $ replace /^.*?(\d|one|two|three|four|five|six|seven|eight|nine).*$/ with tab[$[1]]
    var last = $ replace /^.*(\d|one|two|three|four|five|six|seven|eight|nine).*?$/ with tab[$[1]]
    ---
    first ++ last
}
map $ as Number
then sum($)