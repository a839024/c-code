"use strict";
function SetIpPattern($obj) {
    $obj.attr("pattern", "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}");
    $obj.attr("maxlength", 15);
    $obj.attr("placeholder", "IP Address");
    $obj.on('invalid', function (e) {
        if (!e.target.validity.valid)
            e.target.setCustomValidity('Invalid IP address');
        else
            e.target.setCustomValidity('');
    });
}