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
    var apConns;
    var meshConns;

    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());
      $('#tdModelName').text('<%Model();%>');
      $('#tdDeviceName').text('<%Device();%>');
      $('#tdKernel').text('<%KernelVersion();%>');
      $('#tdAp').text('<%APVersion();%>');
      $('#tdBootloader').text('<%BootVersion();%>');
      $('#tdCPLD').text('<%CPLDVersion();%>');
    });

    function apTableGenerater(addrs) {
      if (addrs.length > 1) {
        var $tbody = $('<tbody>');
        var $tr = $('<tr>');
        var $td = $('<td>');
        addrs.forEach(function(data) {
          if (!data)
            return;
          $tr.clone()
            .append($td.clone().text('AP Stations'))
            .append($td.clone().text(data))
            .appendTo($tbody);
        });
        $('#apTableData').append($tbody);
      }
    }

    function meshTableGenerater(addrs) {
      if (addrs.length > 1) {
        var $tbody = $('<tbody>');
        var $tr = $('<tr>');
        var $td = $('<td>');
        var $header = $('<tr>')
          .append($('<td>', {
            text: 'Destination Address'
          }))
          .append($('<td>', {
            text: 'Next Hop'
          }))
          .appendTo($tbody);

        addrs.forEach(function(data) {
          if (!data)
            return;
          $tr.clone()
            .append($td.clone().text(data.split(' ')[0]))
            .append($td.clone().text(data.split(' ')[1]))
            .appendTo($tbody);
        });
        $('#meshTableData').append($tbody);
      }
    }

    function getMeshStatus() {
      var response;
      return new Promise(function(resolve, reject) {
        $.ajax({
          url: '/form/AtopMeshGetMeshStatus',
          dataType: 'json',
          success: function(resp) {
            console.log(resp);
            response = resp;
          },
          complete: function() {
            resolve(response);
          }
        });
      });
    }

    function getApConns() {
      var response;
      return new Promise(function(resolve, reject) {
        $.ajax({
          url: '/form/AtopMeshGetAPConnections',
          dataType: 'json',
          success: function(resp) {
            console.log(resp);
            response = resp;
          },
          complete: function() {
            if (response['address'])
              resolve(response['address']);
          }
        });
      });
    }

    function getMeshConns() {
      var response;
      return new Promise(function(resolve, reject) {
        $.ajax({
          url: '/form/AtopMeshGetMeshConnections',
          dataType: 'json',
          success: function(resp) {
            console.log(resp);
            response = resp;
          },
          complete: function() {
            if (response['address'])
              resolve(response['address']);
          }
        });
      });
    }

    $(document).ready(function() {
      $('.table-wrapper').hide();
      $('.table-wrapper').eq(0).toggle();

      $.ajax({
        url: '/form/MeshSettingValueCgi',
        dataType: 'json',
        success: function(resp) {
          var modeName;
          if (resp.status == 'ok') {
            switch (resp.mode) {
              case '1':
                parent.$('#txtMeshMode').text('Primary AP mode');
                break;
              case '2':
                parent.$('#txtMeshMode').text('AP mode');
                break;
              case '3':
                parent.$('#txtMeshMode').text('Mesh only mode');
                break;
              case '4':
                parent.$('#txtMeshMode').text('STA mode');
                break;
            }
            $("#tdMeshSSID").text(resp.meshSSID);
            $("#tdApSSID").text(resp.apSSID);
            $("#tdIp").text(resp.ip);
            $("#tdMask").text(resp.mask);
            $("#tdDhcpServer").text(resp.dhcpServer);
            $("#tdDhcpStart").text(resp.dhcpStart);
            $("#tdDhcpEnd").text(resp.dhcpEnd);
          }
        },
        beforeSend: function() {
          parent.$('#waitDialog').modal('show');
        },
        complete: function() {
          parent.$('#waitDialog').modal('hide');
        }
      });

      getMeshStatus()
        .then(resp => getApConns())
        .then(addrs => apTableGenerater(addrs));

      getMeshStatus()
        .then(resp => getMeshConns())
        .then(addrs => meshTableGenerater(addrs));

      $('.userList').on('click', function() {
        var target = $(this).attr('data-target');
        $('.userList').toggleClass('active', false);
        $('.table-wrapper').hide();
        $(this).toggleClass('active');
        $(target).toggle();
        console.log('123');
        parent.$('#main-section').height($('body').height());
      });

      $('.connStatus').on('click', function(e) {
          var parentLi = $(this).parent().parent();
        var target = $(this).attr('data-target');
        $('.table-wrapper').hide();
        $(target).show();
        parentLi.toggleClass('open');
        parent.$('#main-section').height($('body').height());
        e.stopPropagation();
      });

    });
  </script>
</head>

<body>

  <div class="container">
    <ul class="nav nav-tabs">
      <li class="userList active" role="presentation" data-target="#deviceTable"><a href="javascript: void(0);">Device Info</a></li>
      <li class="userList" role="presentation" data-target="#meshTable"><a href="javascript: void(0);">Mesh Info</a></li>
      <li class="userList dropdown" role="presentation" data-target="#meshConnTable">
        <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);" role="button" aria-haspopup="true" aria-expanded="false">
            Connetion Status<span class="caret"></span>
        </a>
        <ul class="dropdown-menu">
          <li class="connStatus" data-target="#meshConnTable"><a href="javascript: void(0);">Mesh</a></li>
          <li class="connStatus" data-target="#apConnTable"><a href="javascript: void(0);">AP</a></li>
        </ul>
      </li>
    </ul>
    <div id="deviceTable" class="table-wrapper">
      <div class="panel panel-default">
        <div class="panel-heading">Device Info</div>
        <table class="table table-striped">
          <tbody>
            <tr>
              <td>MODEL NAME</td>
              <td id="tdModelName"></td>
            </tr>
            <tr>
              <td>DEVICE NAME</td>
              <td id="tdDeviceName"></td>
            </tr>
            <tr>
              <td>KERNEL VERSION</td>
              <td id="tdKernel"></td>
            </tr>
            <tr>
              <td>AP VERISON</td>
              <td id="tdAp"></td>
            </tr>
            <tr>
              <td>BOOTLOADER VERSION</td>
              <td id="tdBootloader"></td>
            </tr>
            <tr>
              <td>CPLD VERSION</td>
              <td id="tdCPLD"></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div id="meshTable" class="table-wrapper">
      <div class="panel panel-default">
        <div class="panel-heading">Mesh</div>
        <table class="table table-striped">
          <tbody>
            <tr id="trMeshSSID">
              <td>Mesh SSID</td>
              <td id="tdMeshSSID"></td>
            </tr>
            <tr id="trApSSID">
              <td>AP SSID</td>
              <td id="tdApSSID"></td>
            </tr>
            <tr id="trIp">
              <td>IP</td>
              <td id="tdIp"></td>
            </tr>
            <tr id="trMask">
              <td>Mask</td>
              <td id="tdMask"></td>
            </tr>
            <tr id="trDhcpServer">
              <td>DHCP Server</td>
              <td id="tdDhcpServer"></td>
            </tr>
            <tr id="trDhcpStart">
              <td>DHCP Start</td>
              <td id="tdDhcpStart"></td>
            </tr>
            <tr id="trDhcpEnd">
              <td>DHCP End</td>
              <td id="tdDhcpEnd"></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div id="meshConnTable" class="table-wrapper">
      <div class="panel panel-default">
        <div class="panel-heading">Mesh Connection</div>
        <table id="meshTableData" class="table table-striped">
        </table>
      </div>
    </div>

    <div id="apConnTable" class="table-wrapper">
      <div class="panel panel-default">
        <div class="panel-heading">Ap Connection</div>
        <table id="apTableData" class="table table-striped">
        </table>
      </div>
    </div>

  </div>
</body>

</html>
