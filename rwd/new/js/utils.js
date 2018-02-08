"use strict";

function ShowToast(msg) {
    parent.$('#toast').text(msg);
    parent.$('#toast').toggleClass('show');
    setTimeout(function () {
        parent.$('#toast').toggleClass('show');
    }, 2900);
}

function ShowWaitDialog(msg) {
    parent.$('#waitDialog').modal(msg);
}

function ShowCheckDialog(title, body, btnText, onSubmit, onCancel) {
    parent.$('#checkTitle').text(title);
    parent.$('#checkBody').text(body);
    parent.$('#btnSubmit').off('click');
    if (typeof onSubmit != 'undefined')
        parent.$('#btnSubmit').on('click', onSubmit);
    parent.$('#btnSubmit').text(btnText);
    parent.$('#btnCancel').off('click');
    if (typeof onCancel != 'undefined')
        parent.$('#btnCancel').on('click', onCancel);
    parent.$('#modalCheck').modal('show');
}

function DownloadFile(url, filename) {
    $('<a>', {
        href: url,
        download: filename
    }).get(0).click();
}

function RemoveBackdrop() {
    $('body').removeClass('modal-open');
    console.log($('.modal-backdrop'));
    parent.$('.modal-backdrop').remove();
}

function CustomSerialize($obj) {
    return $obj.serialize() + '&json=on';
}

function SetIpPattern($obj) {
//    var pattern = /((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}/g;
    var pattern = /^(2[0-1][0-9]|2[2][0-3]|2[4][0-9]|2[5][0-5]|1[0-2][0-6]|1[0-2][8-9]|1[3-9][0-9]|[1-9][0-9]|[1-9])\.(2[0-4][0-9]|2[5][0-5]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(2[0-4][0-9]|2[5][0-255]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(2[0-4][0-9]|2[5][0-4]|1[0-9][0-9]|[1-9][0-9]|[1-9])$/g;
    $obj.attr("maxlength", 15);
    $obj.attr("placeholder", "IP Address");
    $obj.on('blur', function (e) {
        if ($obj.val().match(pattern))
            e.target.setCustomValidity('');
        else
            e.target.setCustomValidity('Invalid IP address');
    });
}

function SetCharacterPattern($obj) {
    var pattern = /[^~`!#$%\^&\*\+=\[\]';,\/{}\|":<>\?@]/g
    $obj.on('blur', function (e) {
        if ($obj.val().match(pattern))
            e.target.setCustomValidity('');
        else
            e.target.setCustomValidity('Invalid Characters');
    });
}

function PreventValidateHidden($obj) {
    $obj.on('invalid', function (e) {
        if ($obj.is(":hidden")) {
            e.preventDefault();
        }
    });
}
