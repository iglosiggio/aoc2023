in splitBy '\n'
map do {
    var trimmed = $ replace /^[^\d]*/ with ""
                    replace /[^\d]*$/ with ""
    ---
    trimmed[0] ++ trimmed[-1]
}
map $ as Number
then sum($)