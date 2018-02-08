<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Test</title>
  <!-- Bootstrap CSS CDN -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/table.css">
  <!-- Font Style CSS -->
  <link rel="stylesheet" href="css/poppins-font.css">
  <!-- jQuery CDN -->
  <script src="js/ajax-jquery.min.js"></script>
  <!-- Bootstrap Js CDN -->
  <script src="js/bootstrap.min.js" defer></script>

  <script type="text/javascript" defer>
    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());
    });

    $(document).ready(function() {
      $('#trFromIP').hide();
      $('#trToIP').hide();
      $('#trMask').hide();
      $('#trLeaseTime').hide();
      $('#staticIP').hide();

      $('#dhcpEnable').on('click', function() {
        $(this).toggleClass('switch-enable');
        var input = $(this).children('input');
        if (input.attr('value') == 'yes') {
          input.val('no');
          $('#trFromIP').hide();
          $('#trToIP').hide();
          $('#trMask').hide();
          $('#trLeaseTime').hide();
          $('#staticIP').hide();
        } else {
          input.val('yes');
          $('#trFromIP').show();
          $('#trToIP').show();
          $('#trMask').show();
          $('#trLeaseTime').show();
          $('#staticIP').show();
        }
      });

      $('.newBtn').on('click', function() {
        $('#addModal').modal();
      });

      $('#addBtn').on('click', function() {
        const hostValue = $('#newItemForm :input[name="host"]').val();
        const $tdHost = $('<td>').append($('<span>').text(hostValue))
          .append($('<input>').addClass('editInput').val(hostValue));

        const ipValue = $('#newItemForm :input[name="ip"]').val();
        const $tdIp = $('<td>').append($('<span>').text(ipValue))
          .append($('<input>').addClass('editInput').val(ipValue));

        const macValue = $('#newItemForm :input[name="mac"]').val();
        const $tdMac = $('<td>').append($('<span>').text(macValue))
          .append($('<input>').addClass('editInput').val(macValue));

        const $pencilBtn = $('<button>').addClass('btn')
          .addClass('btn-default')
          .addClass('glyphicon')
          .addClass('glyphicon-pencil')
          .addClass('red')
          .prop('type', 'button');

        const $okBtn = $('<button>').addClass('btn')
          .addClass('btn-default')
          .addClass('glyphicon')
          .addClass('glyphicon-ok')
          .addClass('red')
          .addClass('hidden')
          .prop('type', 'button');

        const $tdBtn = $('<td>').append($pencilBtn)
          .append($okBtn);

        $('<tr>').append(
          $tdHost,
          $tdIp,
          $tdMac,
          $tdBtn
        ).appendTo('#listItem');
        parent.$('#main-section').height($('body').height());
      });

      $('tbody').on('click', '.glyphicon-pencil', function() {
        const $tds = $(this).parent().parent().children();
        const $btns = $(this).parent().children();
        $tds.contents('span').each(function(index, value) {
          $(this).siblings().val($(this).text());
        });
        $tds.contents('input').show();
        $tds.contents('span').hide();
        $btns.toggleClass('hidden');
      });

      $('tbody').on('click', '.glyphicon-ok', function() {
        const $tds = $(this).parent().parent().children();
        const $btns = $(this).parent().children();
        $tds.contents('span').each(function(index, value) {
          $(this).text($(this).siblings().val());
        });
        $tds.contents('input').hide();
        $tds.contents('span').show();
        $btns.toggleClass('hidden');
      });
    });
  </script>
</head>

<body>

  <div class="container">

    <form action="" id='dhcpForm'>
      <div id="dhcpTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id='dhcpPanel' class="panel-heading">DHCP Server</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>DHCP</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="dhcpEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="dhcp" type="hidden" name="dhcp" value="no">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trFromIP">
                <td>From IP Address</td>
                <td><input id="fromIP" type="text" name="fromIP" value=""></td>
              </tr>
              <tr id="trToIP">
                <td>To IP Address</td>
                <td><input id="toIP" type="text" name="toIP" value=""></td>
              </tr>
              <tr id="trMask">
                <td>Netmask</td>
                <td><input id="mask" type="text" name="mask" value=""></td>
              </tr>
              <tr id="trLeaseTime">
                <td>Lease Time(seconds)</td>
                <td><input id="leaseTime" type="text" name="leaseTime" value="" placeholder="user name"></td>
              </tr>
            </tbody>
          </table>
        </div>

        <div id="staticIP" class="panel panel-default">
          <div class="panel-heading">Static Connection(s)<button class="btn btn-default newBtn" type="button">NEW<span class="glyphicon glyphicon-plus"></span></button></div>
          <table class="table table-striped">
            <tbody id="listItem">
              <tr class="trheader">
                <td>Host Name</td>
                <td>IP Address</td>
                <td>Mac</td>
                <td></td>
              </tr>
              <tr class="addItem">
                <td>
                  <span>10.0.0.100</span>
                  <input class="editInput" type="text" value="12345">
                </td>
                <td>
                  <span>255.255.255.0</span>
                  <input class="editInput" type="text" value="1234">
                </td>
                <td>
                  <span>00:00:00:00:00:00</span>
                  <input class="editInput" type="text">
                </td>
                <td>
                  <button class="btn btn-default glyphicon glyphicon-pencil red" type="button"></button>
                  <button class="btn btn-default glyphicon glyphicon-ok red hidden" type="button"></button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="center" role="group" aria-label="...">
          <button onclick="console.log($('#dhcpForm :not(:hidden)').serialize());" class="btn btn-default submitBtn" type="submit">Submit</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>
    </form>
  </div>

  <div class="modal fade" id="addModal" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <!--                    <button type="button" class="close" data-dismiss="modal">&times;</button>-->
          <h4 class="modal-title">Add A New Item</h4>
        </div>
        <div class="modal-body">
          <form id="newItemForm" action="/" role="form" class="form-horizontal">
            <div class="form-group">
              <label class="col-sm-3 control-label">Host Name</label>
              <div class="col-sm-9">
                <input class="form-control" name="host" placeholder="Host" />
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">IP Address</label>
              <div class="col-sm-9">
                <input class="form-control" name="ip" placeholder="IP" />
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">MAC</label>
              <div class="col-sm-9">
                <input type="email" class="form-control" name="mac" placeholder="MAC" />
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button id="addBtn" type="button" class="btn btn-primary" data-dismiss="modal">Add</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</body>

</html>
