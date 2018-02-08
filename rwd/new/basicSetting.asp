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
    var dns = <%NetworkDNSJson();%>
    var nat = {
      <%NATInfo();%>
    };
    var network = [<%NetworkLanInfo();%>];
    var vipSetting = <%VirtualIpInfo();%>;
    var board = "<%NetworkLanType();%>";
    var bondingSupport = <%IsBondingSupport();%>;
    var ports = <%RstpBridgePort();%>;

    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());

      lanTableGenerator();

      if (vipSetting['vipEna'] == 'notSupport') {
        $('#trVip').remove();
        $('#trVipAddress').remove();
        $('#trVipInterface').remove();
      } else {
        vipControl();
      }

      if (network.filter(lan => lan['interface'] == '4G' || lan['interface'] == '3G').length) {
        nat['nat'] ? $('#chkNAT').val('on') : $('#chkNAT').val('');
        nat['dhcpServer'] ? $('#chkDHCPServer').val('on') : $('#chkDHCPServer').val('');
        $('#txtIPPoolStartAddress').val(nat['ippS']);
        $('#txtIPPoolEndAddress').val(nat['ippE']);
        natControl();
      } else {
        $('#trNat').remove();
        $('#trWanPort').remove();
        $('#trDhcpServer').remove();
        $('#trIpPoolStart').remove();
        $('#trIpPoolEnd').remove();
      }

      dhcpControl();
    });

    function lanTableGenerator() {
      if (network.length) {
        network.forEach(function(val, i) {
          $('#subUlLan').append($('<li>').append($('<a>', {
            class: 'lanSetting',
            href: 'javascript:void(0);',
            text: val['interface']
          })));
          $('#radDefaultGW').append($('<option>', {
            value: i++,
            text: val['interface']
          }));
        });
        network[0]['ipmod'] ? $('#dhcp').val('') : $('#dhcp').val('on');
        $('#ip').attr('name', 'ip1')
          .val(network[0]['ip']);
        $('#mask').attr('name', 'mask1')
          .val(network[0]['mask']);
        $('#gateway').attr('name', 'gw1')
          .val(network[0]['gw']);
        $('#networkTable').hide();
      } else {
        $('#lanTable').remove();
        $('#mainLiLan').remove();
        $('#liNetwork').addClass('active');
        $('#trDefaultGateway').remove();
      }
    }

    function dhcpControl() {
      if ($('#dhcp').val()) {
        $('#dhcpEnable').toggleClass('switch-enable', true);
        $('#trIp').hide();
        $('#trMask').hide();
        $('#trGateway').hide();
      } else {
        $('#dhcpEnable').toggleClass('switch-enable', false);
        $('#trIp').show();
        $('#trMask').show();
        $('#trGateway').show();
      }
    }

    function vipControl() {
      if ($('#chkVipEna').val()) {
        $('#vipEnable').toggleClass('switch-enable', true);
        $('#trVipAddress').show();
        $('#trVipInterface').show();
      } else {
        $('#vipEnable').toggleClass('switch-enable', false);
        $('#trVipAddress').hide();
        $('#trVipInterface').hide();
      }
    }

    function natControl() {
      if ($('#chkNAT').val()) {
        $('#natEnable').toggleClass('switch-enable', true);
        $('#trWanPort').show();
        $('#trDhcpServer').show();
        dhcpServerControl();
      } else {
        $('#natEnable').toggleClass('switch-enable', false);
        $('#trWanPort').hide();
        $('#trDhcpServer').hide();
        $('#trIpPoolStart').hide();
        $('#trIpPoolEnd').hide();
      }
    }

    function dhcpServerControl() {
      if ($('#chkDHCPServer').val()) {
        $('#dhcpServerEnable').toggleClass('switch-enable', true);
        $('#trIpPoolStart').show();
        $('#trIpPoolEnd').show();
      } else {
        $('#dhcpServerEnable').toggleClass('switch-enable', false);
        $('#trIpPoolStart').hide();
        $('#trIpPoolEnd').hide();
      }
    }

    //Setting Event
    $(document).ready(function() {

      $('.dropdown').on('click', function() {
        $('.dropdown-toggle').dropdown();
      });

      $('li').on('click', '.lanSetting', function() {
        var span = $('.caret');
        var text = $(this).text();
        const index = text.replace(/[^\d.]/g, '');
        $('.dropdown-toggle').html(text)
          .append(span);

        $('#lanPanel').text(text);
        $('#dhcp').attr('name', 'dhcp' + index);
        network[index - 1]['ipmod'] ? $('#dhcp').val('') : $('#dhcp').val('on');
        $('#ip').attr('name', 'ip' + index)
          .val(network[index - 1]['ip']);
        $('#mask').attr('name', 'mask' + index)
          .val(network[index - 1]['mask']);
        $('#gateway').attr('name', 'gw' + index)
          .val(network[index - 1]['gw']);
        dhcpControl();
      });

      $('#dhcpEnable').on('click', function() {
        $('#dhcp').val() ? $('#dhcp').val('') : $('#dhcp').val('on');
        dhcpControl();
      });

      $('#vipEnable').on('click', function() {
        $('#chkVipEna').val() ? $('#chkVipEna').val('') : $('#chkVipEna').val('on');
        vipControl();
      });

      $('#natEnable').on('click', function() {
        $('#chkNAT').val() ? $('#chkNAT').val('') : $('#chkNAT').val('on');
        natControl();
      });

      $('#dhcpServerEnable').on('click', function() {
        $('#chkDHCPServer').val() ? $('#chkDHCPServer').val('') : $('#chkDHCPServer').val('on');
        dhcpServerControl();
      });

      $('.userList').on('click', function() {
        var target = $(this).attr('data-target');
        $('.userList').toggleClass('active', false);
        $('.table-wrapper').hide();
        $(this).toggleClass('active');
        $(target).show();
        parent.$('#main-section').height($('body').height());
      });
    });
  </script>
</head>

<body>

  <div class="container">
    <ul class="nav nav-tabs">
      <li id="mainLiLan" role="presentation" class="dropdown active userList" data-target="#lanTable">
        <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);" role="button" aria-haspopup="true" aria-expanded="false">LAN<span class="caret"></span>
    </a>
        <ul id="subUlLan" class="dropdown-menu">
        </ul>
      </li>
      <li id="liNetwork" class="userList" role="presentation" data-target="#networkTable"><a href="javascript:void(0);">Network Settings</a></li>
    </ul>
    <form action="" id="networkForm">
      <div id="lanTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="lanPanel" class="panel-heading">Lan1</div>
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
                      <input id="dhcp" type="hidden">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trIp">
                <td>IP Address</td>
                <td><input id="ip" type="text"></td>
              </tr>
              <tr id="trMask">
                <td>Subnet Mask</td>
                <td><input id="mask" type="text"></td>
              </tr>
              <tr id="trGateway">
                <td>Gateway</td>
                <td><input id="gateway" type="text"></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group">
          <button class="btn btn-default submitBtn" type="submit">Submit</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>

      <div id="networkTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="networkPanel" class="panel-heading">Network Setting</div>
          <table class="table table-striped">
            <tbody id="tbNetwork">
              <tr id="trVip">
                <td>Virtual IP Enable</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="vipEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="chkVipEna" type="hidden" name="chkVipEna">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trVipAddress">
                <td>Virtual IP Address</td>
                <td><input id="textVipAddr" type="text" name="textVipAddr"></td>
              </tr>
              <tr id="trVipInterface">
                <td>Virtual IP Interface</td>
                <td></td>
              </tr>
              <tr id="trDefaultGateway">
                <td>Default Gateway</td>
                <td>
                  <select id="radDefaultGW" name="radDefaultGW">
                                    </select>
                </td>
              </tr>
              <tr id="trPreferDNS">
                <td>Preferred DNS</td>
                <td><input id="txtDNS0" type="text" name="txtDNS0"></td>
              </tr>
              <tr id="trAlternateDNS">
                <td>Alternate DNS</td>
                <td><input id="txtDNS1" type="text" name="txtDNS1"></td>
              </tr>
              <tr id="trNat">
                <td>NAT Enable</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="natEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="chkNAT" type="hidden" name="chkNAT">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trWanPort">
                <td>WAN Port</td>
                <td>
                  <select id="selWanPort" name="selWanPort">
                                    </select>
                </td>
              </tr>
              <tr id="trDhcpServer">
                <td>DHCP Server Enable</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="dhcpServerEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="chkDHCPServer" type="hidden" name="chkDHCPServer">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trIpPoolStart">
                <td>IP Pool Start Address</td>
                <td><input id="txtIPPoolStartAddress" type="text" name="txtIPPoolStartAddress"></td>
              </tr>
              <tr id="trIpPoolEnd">
                <td>IP Pool End Address</td>
                <td><input id="txtIPPoolEndAddress" type="text" name="txtIPPoolEndAddress"></td>
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
