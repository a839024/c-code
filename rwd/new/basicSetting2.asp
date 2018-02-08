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
  <!-- Local Js -->
  <script src="js/utils.js" defer></script>
  <script type="text/javascript" defer>
    var meshValue;
    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());
      getMeshValue();
    });

    function getMeshValue() {
      $.ajax({
        url: '/form/MeshSettingValueCgi',
        dataType: 'json',
        success: function(resp) {
          console.log(resp);
          if (resp.status == 'ok')
            meshValue = resp;

          TableControl();
          setBlankValue();
        },
        error: function(resp) {
          console.log(resp);
        },
        beforeSend: function() {
          parent.$('#waitDialog').modal('show');
        },
        complete: function() {
          parent.$('#waitDialog').modal('hide');
        }
      });
    }

    function TableControl() {
      switch (meshValue.mode) {
        case '3':
          $('#liAp').hide();
        case '2':
          $('#liNetwork').hide();
          break;
      }
      $('#apTable').hide();
      $('#networkTable').hide();
    }

    function setBlankValue() {
      if (meshValue) {
        $('#txtMeshSSID').val(meshValue.meshSSID);
        $('#txtMeshPSK').val(meshValue.meshPSK);
        $('#selChannel').val(meshValue.channel);
        $('#txtApSSID').val(meshValue.apSSID);
        $('#txtApPSK').val(meshValue.apPSK);
        $('#txtIP').val(meshValue.ip);
        $('#txtMask').val(meshValue.mask);
        $('#dhcp').val(meshValue.dhcpServer);
        dhcpControl();
        $('#txtDhcpStart').val(meshValue.dhcpStart);
        $('#txtDhcpEnd').val(meshValue.dhcpEnd);
      }
    }

    function dhcpControl() {
      if (parseInt($('#dhcp').val())) {
        $('#dhcpEnable').toggleClass('switch-enable', true);
        $('#trIP').show();
        $('#trMask').show();
        $('#trDhcpStart').show();
        $('#trDhcpEnd').show();
      } else {
        $('#dhcpEnable').toggleClass('switch-enable', false);
        $('#trIP').hide();
        $('#trMask').hide();
        $('#trDhcpStart').hide();
        $('#trDhcpEnd').hide();
      }
    }

    $(document).ready(function() {
      $('.userList').on('click', function() {
        var target = $(this).attr('data-target');
        $('.userList').toggleClass('active', false);
        $('.table-wrapper').hide();
        $(this).toggleClass('active');
        $(target).show();
        parent.$('#main-section').height($('body').height());
      });

      $('#dhcpEnable').on('click', function() {
        parseInt($('#dhcp').val()) ? $('#dhcp').val('0') : $('#dhcp').val('1');
        dhcpControl();
      });

      $('form').on('submit', function(e) {
        console.log($(this).serialize());
        $.ajax({
          url: '/form/MeshSettingCgi',
          method: 'post',
          data: $(this).serialize(),
          dataType: 'json',
          success: function(resp) {
            console.log(resp);
            if (resp.status == 'ok') {
              ShowToast('Update Success');
            } else {
              ShowToast('Update Failed');
            }
          },
          error: function(resp) {
            console.log(resp);
          },
          beforeSend: function() {
            parent.$('#waitDialog').modal('show');
          },
          complete: function() {
            parent.$('#waitDialog').modal('hide');
          }
        });
        e.preventDefault();
      });
    });
  </script>
</head>

<body>

  <div class="container">
    <ul class="nav nav-tabs">
      <li id="liMesh" class="userList active" role="presentation" data-target="#meshTable">
        <a href="javascript:void(0);">
                    Mesh<span class="rwdText"> Settings</span>
                </a>
      </li>
      <li id="liAp" class="userList" role="presentation" data-target="#apTable">
        <a href="javascript:void(0);">
                    AP<span class="rwdText"> Settings</span>
                </a>
      </li>
      <li id="liNetwork" class="userList" role="presentation" data-target="#networkTable">
        <a href="javascript:void(0);">
                    Network<span class="rwdText"> Settings</span>
                </a>
      </li>
    </ul>
    <form action="" id="meshForm">
      <div id="meshTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="networkPanel" class="panel-heading">Mesh Setting</div>
          <table class="table table-striped">
            <tbody id="tbMesh">
              <tr id="trMeshSSID">
                <td>Mesh SSID</td>
                <td><input id="txtMeshSSID" type="text" name="txtMeshSSID"></td>
              </tr>
              <tr id="trMeshPwd">
                <td>Mesh Password</td>
                <td><input id="txtMeshPSK" type="text" name="txtMeshPSK"></td>
              </tr>
              <tr id="trChannel">
                <td>Channel</td>
                <td>
                  <select id="selChannel" name="selChannel">
                                            <option value="1" selected="">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                            <option value="7">7</option>
                                            <option value="8">8</option>
                                            <option value="9">9</option>
                                            <option value="10">10</option>
                                            <option value="11">11</option>
                                    </select>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group">
          <button class="btn btn-default submitBtn" type="submit">Submit</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>
    </form>

    <form action="" id="apForm">
      <div id="apTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="apPanel" class="panel-heading">Ap Setting</div>
          <table class="table table-striped">
            <tbody id="tbAp">
              <tr id="trApSSID">
                <td>AP SSID</td>
                <td><input id="txtApSSID" type="text" name="txtApSSID"></td>
              </tr>
              <tr id="trApPwd">
                <td>AP Password</td>
                <td><input id="txtApPSK" type="text" name="txtApPSK"></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group">
          <button class="btn btn-default submitBtn" type="submit">Submit</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>
    </form>

    <form action="" id="networkForm">
      <div id="networkTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="networkPanel" class="panel-heading">Network Setting</div>
          <table class="table table-striped">
            <tbody id="tbNetwork">
              <tr>
                <td>DHCP Server</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="dhcpEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="dhcp" type="hidden" name="dhcp" value="">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trIP">
                <td>IP Address</td>
                <td><input id="txtIP" type="text" name="txtIP" value="10.0.50.100"></td>
              </tr>
              <tr id="trMask">
                <td>Subnet Mask</td>
                <td><input id="txtMask" type="text" name="txtMask" value="255.255.255.0"></td>
              </tr>
              <tr id="trDhcpStart">
                <td>DHCP Start</td>
                <td><input id="txtDhcpStart" type="number" name="txtDhcpStart" value="10"></td>
              </tr>
              <tr id="trDhcpEnd">
                <td>DHCP End</td>
                <td><input id="txtDhcpEnd" type="number" name="txtDhcpEnd" value="20"></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group">
          <button class="btn btn-default submitBtn" type="submit">Submit</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>
    </form>
  </div>
</body>

</html>
