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
    function getIpsecConfig() {
      var para = {
        <%IPsecValue();%>
      };

      /* General Settings */
      $('#enable').val(para.enable);

      $('#peerAddressType').val(para.peer_address_type);
      $('#peerAddress').val(para.peer_address);

      $('#remoteSubnetType').val(para.remote_subnet_type);
      $('#remoteSubnet').val(para.remote_subnet);
      $('#remoteMaskBits').val(para.remote_maskbits);

      $('#localSubnetType').val(para.local_subnet_type);
      $('#localSubnet').val(para.local_subnet);
      $('#localMaskBits').val(para.local_maskbits);

      //            $('#requestVirtualIP').val(para.request_virtual_ip);
      $('#connectionType').val(para.connection_type);
      ipsecEnableControl();
      peerAddressControl();
      remoteSubnetControl();
      localSubnetControl();

      /* Authentication Settings */
      $('#authType').val(para.auth_type);
      $('#presharedKey').val(para.preshared_key);
      $('#localIDType').val(para.local_id_type);
      $('#localID').val(para.local_id);
      $('#remoteIDType').val(para.remote_id_type);
      if (para.remote_id_type == 'any')
        $('#remoteID').hide();
      $('#remoteID').val(para.remote_id);

      /* IKE Settings */
      $('#p1Mode').val(para.p1_mode);
      $('#p1DHGroup').val(para.p1_dhgroup);
      $('#p1Encryption').val(para.p1_encryption);
      $('#p1Authentication').val(para.p1_authentication);
      $('#ikeLifeTime').val(para.ike_lifetime);
      $('#protocol').val(para.protocol);
      $('#p2DHGroup').val(para.p2_dhgroup);
      $('#p2Encryption').val(para.p2_encryption);
      $('#p2Authentication').val(para.p2_authentication);
      $('#saLifeTime').val(para.sa_lifetime);

      /* Dead Peer Detection Settings */
      $('#dpdAction').val(para.dpd_action);
      $('#dpdInterval').val(para.dpd_interval);
      $('#dpdTimeout').val(para.dpd_timeout);
      dpdActionControl();
    }

    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());
      $('#trLocalID').hide();
      $('#trRemoteID').hide();

      SetIpPattern($('#peerAddress'));
      PreventValidateHidden($('#peerAddress'));
      SetIpPattern($('#remoteSubnet'));
      PreventValidateHidden($('#remoteSubnet'));
      PreventValidateHidden($('#remoteMaskBits'));
      SetIpPattern($('#localSubnet'));
      PreventValidateHidden($('#localSubnet'));
      PreventValidateHidden($('#localMaskBits'));
      PreventValidateHidden($('#presharedKey'));
      PreventValidateHidden($('#ikeLifeTime'));
      PreventValidateHidden($('#saLifeTime'));
      PreventValidateHidden($('#dpdInterval'));
      PreventValidateHidden($('#dpdTimeout'));

      getIpsecConfig();
      getIpsecStatus();
    });

    function getIpsecStatus() {
      $.ajax({
        url: '/form/IPsecStatusValueCgi',
        method: 'post',
        dataType: 'json',
        success: function(resp) {
          console.log(resp);
          var connStatus = resp.connStatus;
          var tunnel = resp.tunnel;
          var peerAddress = resp.peerAddress;

          $('#btnDisconnect').hide();
          $('#btnConnect').hide();
          $('#connStatus').text(connStatus);
          $('#ipsecPeerAddress').text(peerAddress);
          $('#tunnel').text(tunnel);
          switch (connStatus) {
            case 'Connecting':
            case 'Connected':
              $('#btnDisconnect').show();
              break;
            case 'Disconnected':
            case 'Disconnecting':
              $('#btnConnect').show();
          }
        }
      });
    }

    function ipsecEnableControl() {
      if ($('#enable').val()) {
        $('#ipsecEnable').toggleClass('switch-enable', true);
        $('#trPeerAddress').show();
        $('#trRemoteSubnet').show();
        $('#trLocalSubnet').show();
        $('#trConncetionType').show();
        $('#authPanel').show();
        $('#ikePanel').show();
        $('#dpdPanel').show();
      } else {
        $('#ipsecEnable').toggleClass('switch-enable', false);
        $('#trPeerAddress').hide();
        $('#trRemoteSubnet').hide();
        $('#trLocalSubnet').hide();
        $('#trConncetionType').hide();
        $('#authPanel').hide();
        $('#ikePanel').hide();
        $('#dpdPanel').hide();
      }
    }

    function peerAddressControl() {
      if ($('#peerAddressType').val() == 'dynamic')
        $('#peerAddress').hide();
      else
        $('#peerAddress').show();
    }

    function remoteSubnetControl() {
      if ($('#remoteSubnetType').val() == 'none') {
        $('#remoteSubnet').hide();
        $('#tdRemoteMaskBits').hide();
      } else {
        $('#remoteSubnet').show();
        $('#tdRemoteMaskBits').show();
      }
    }

    function localSubnetControl() {
      if ($('#localSubnetType').val() == 'none') {
        $('#localSubnet').hide();
        $('#tdLocalMaskBits').hide();
      } else {
        $('#localSubnet').show();
        $('#tdLocalMaskBits').show();
      }
    }

    function remoteIDControl() {
      if ($('#remoteIDType').val() == 'any')
        $('#remoteID').hide();
      else
        $('#remoteID').show();
    }

    function dpdActionControl() {
      if ($('#dpdAction').val() == 'none') {
        $('#trDpdInterval').hide();
        $('#trDpdTimeout').hide();
      } else {
        $('#trDpdInterval').show();
        $('#trDpdTimeout').show();
      }
    }

    $(document).ready(function() {
      $('#statusTable').hide();

      $('.dropdown').on('click', function() {
        $('.dropdown-toggle').dropdown();
      });

      $('#ipsecEnable').on('click', function() {
        $(this).toggleClass('switch-enable');
        $('#enable').val() ? $('#enable').val('') : $('#enable').val('enabled');
        ipsecEnableControl();
      });

      $('#peerAddressType').on('change', peerAddressControl);

      $('#remoteSubnetType').on('change', remoteSubnetControl);

      $('#localSubnetType').on('change', localSubnetControl);

      $('#remoteIDType').on('change', remoteIDControl);

      $('#dpdAction').on('change', dpdActionControl);

      $('#dpdInterval, #dpdTimeout').on('keyup', function() {
        if ($('#dpdTimeout').val() <= $('#dpdInterval').val())
          $('#dpdTimeout')[0].setCustomValidity('DPD timeout has to be greater than DPD interval');
        else
          $('#dpdTimeout')[0].setCustomValidity('');
      });

      $('.userList').on('click', function() {
        var target = $(this).attr('data-target');
        $('.userList').toggleClass('active', false);
        $('.table-wrapper').hide();
        $(this).toggleClass('active');
        $(target).show();
        parent.$('#main-section').height($('body').height());
      });

      $('#settingForm').on('submit', function(e) {
        console.log(CustomSerialize($('#settingForm')));
        $.ajax({
          url: '/form/IPsecCgi',
          method: 'post',
          data: CustomSerialize($('#settingForm')),
          dataType: 'json',
          success: function(resp) {
            console.log(resp);
            if (resp.status == 'ok') {
              ShowToast('Update Success');
              getIpsecStatus();
            } else {
              ShowToast('Update Failed');
            }
          },
          error: function(jqXHR, status, error) {
            ShowToast('Update Failed');
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

      $('#btnConnect').on('click', function() {
        $.ajax({
          url: '/form/IPsecStatusCgi',
          method: 'post',
          data: {
            action: 'connect',
            json: 'on'
          },
          dataType: 'json',
          success: function(resp) {
            console.log(resp);
            if (resp.status == 'ok') {
              ShowToast('Connecting...');
              getIpsecStatus();
            } else {
              ShowToast('Connect Failed');
            }
          },
          error: function(jqXHR, status, error) {
            ShowToast('Connect Failed');
          },
          beforeSend: function() {
            parent.$('#waitDialog').modal('show');
          },
          complete: function() {
            parent.$('#waitDialog').modal('hide');
          }
        });
      });

      $('#btnDisconnect').on('click', function() {
        $.ajax({
          url: '/form/IPsecStatusCgi',
          method: 'post',
          data: {
            action: 'disconnect',
            json: 'on'
          },
          dataType: 'json',
          success: function(resp) {
            console.log(resp);
            if (resp.status == 'ok') {
              ShowToast('Disconnecting...');
              getIpsecStatus();
            } else {
              ShowToast('Disconnect Failed');
            }
          },
          error: function(jqXHR, status, error) {
            ShowToast('Disconnect Failed');
          },
          beforeSend: function() {
            parent.$('#waitDialog').modal('show');
          },
          complete: function() {
            parent.$('#waitDialog').modal('hide');
          }
        });
      });

      $('#btnRefresh').on('click', function() {
        getIpsecStatus();
      });
    });
  </script>
</head>

<body>

  <div class="container">
    <ul class="nav nav-tabs">
      <li class="userList active" role="presentation" data-target="#settingTable"><a href="javascript:void(0);">Settings</a></li>
      <li class="userList" role="presentation" data-target="#statusTable"><a href="javascript:void(0);">Status</a></li>
    </ul>
    <form action="" id="settingForm">
      <div id="settingTable" class="table-wrapper">
        <div id="settingPanel" class="panel panel-default">
          <div class="panel-heading">General Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>IPsec Enable</td>
                <td colspan="2">
                  <div class="switch-wrapper">
                    <div id="ipsecEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="enable" type="hidden" name="enable">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trPeerAddress">
                <td>Peer Address</td>
                <td colspan="2">
                  <select id="peerAddressType" name="peer_address_type">
                                        <option value="dynamic">Dynamic</option>
                                        <option value="static">Static</option>
                                    </select>
                  <input id="peerAddress" type="text" name="peer_address">
                </td>
              </tr>
              <tr id="trRemoteSubnet">
                <td>Remote Subnet</td>
                <td>
                  <select id="remoteSubnetType" name="remote_subnet_type">
                                        <option value="none">None (Host Only)</option>
                                        <option value="network">Network</option>
                                    </select>
                  <input id="remoteSubnet" type="text" name="remote_subnet">
                </td>
                <td id="tdRemoteMaskBits">
                  <span>Mask Bit</span>
                  <input id="remoteMaskBits" type="number" name="remote_maskbits" min="1" max="32" maxlength="2" required>
                </td>
              </tr>
              <tr id="trLocalSubnet">
                <td>Local Subnet</td>
                <td>
                  <select id="localSubnetType" name="local_subnet_type">
                                        <option value="none">None (Host Only)</option>
                                        <option value="network">Network</option>
                                    </select>
                  <input id="localSubnet" type="text" name="local_subnet">
                </td>
                <td id="tdLocalMaskBits">
                  <span>Mask Bit</span>
                  <input id="localMaskBits" type="number" name="local_maskbits" min="1" max="32" maxlength="2" required>
                </td>
              </tr>
              <tr id="trConncetionType">
                <td>Connection Type</td>
                <td colspan="2">
                  <select id="connectionType" name="connection_type">
                                        <option value="tunnel">Tunnel</option>
                                        <option value="transport">Transport</option>
                                    </select>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div id="authPanel" class="panel panel-default">
          <div class="panel-heading">Authentication Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr id="trAuthType">
                <td>Method</td>
                <td>
                  <select id="authType" name="auth_type">
                                        <option value="psk">Pre-Shared Key</option>
                                    </select>
                  <input id="presharedKey" type="text" name="preshared_key" required>
                </td>
              </tr>
              <tr id="trLocalID">
                <td>Local ID</td>
                <td>
                  <select id="localIDType" name="local_id_type">
                                        <option value="ip">IP</option>
                                        <option value="email">E-mail</option>
                                        <option value="fqdn">Domain Name</option>
                                    </select>
                  <input id="localID" type="text" name="local_id">
                </td>
              </tr>
              <tr id="trRemoteID">
                <td>Remote ID</td>
                <td>
                  <select id="remoteIDType" name="remote_id_type">
                                        <option value="any">Any</option>
                                        <option value="ip">IP</option>
                                        <option value="email">Email</option>
                                        <option value="fqdn">Domain Name</option>
                                    </select>
                  <input id="remoteID" type="text" name="remote_id">
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div id="ikePanel" class="panel panel-default">
          <div class="panel-heading">IKE Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td rowspan="5"><b>Phase 1 SA (ISAKMP)</b></td>
                <td>Mode</td>
                <td>
                  <select id="p1Mode" name="p1_mode">
                                        <option value="main">Main</option>
                                        <option value="aggressive">Aggressive</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>DH Group</td>
                <td>
                  <select id="p1DHGroup" name="p1_dhgroup">
                                        <option value="group2">Group 2 (1024-bit)</option>
                                        <option value="group5">Group 5 (1536-bit)</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>Encryption Algorithm</td>
                <td>
                  <select id="p1Encryption" name="p1_encryption">
                                        <option value="3des">3DES</option>
                                        <option value="aes128">AES-128</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>Authentication Algorithm</td>
                <td>
                  <select id="p1Authentication" name="p1_authentication">
                                        <option value="md5">MD5</option>
                                        <option value="sha1">SHA1</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>SA Life Time</td>
                <td>
                  <input type="number" id="ikeLifeTime" name="ike_lifetime" min="300" max="86400" maxlength="5" required>seconds
                </td>
              </tr>
              <tr>
                <td rowspan="5"><b>Phase 2 SA</b></td>
                <td>Protocol</td>
                <td>
                  <select id="protocol" name="protocol">
                                        <option value="esp">ESP</option>
                                        <option value="ah">AH</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>Perfect Forward Secrecy</td>
                <td>
                  <select id="p2DHGroup" name="p2_dhgroup">
                                        <option value="none">Disable</option>
                                        <option value="group2">Group 2 (1024-bit)</option>
                                        <option value="group5">Group 5 (1536-bit)</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>Encryption Algorithm</td>
                <td>
                  <select id="p2Encryption" name="p2_encryption">
                                        <option value="3des">3DES</option>
                                        <option value="aes128">AES-128</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>Authentication Algorithm</td>
                <td>
                  <select id="p2Authentication" name="p2_authentication">
                                        <option value="md5">MD5</option>
                                        <option value="sha1">SHA1</option>
                                    </select>
                </td>
              </tr>
              <tr>
                <td>SA Life Time</td>
                <td>
                  <input type="number" id="saLifeTime" name="sa_lifetime" min="180" max="86400" maxlength="5" required>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div id="dpdPanel" class="panel panel-default">
          <div class="panel-heading">Dead Peer Detection Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr id="trDpdAction">
                <td>DPD Action</td>
                <td>
                  <select id="dpdAction" name="dpd_action">
                                        <option value="none">None</option>
                                        <option value="hold">Hold</option>
                                        <option value="restart">Restart</option>
                                        <option value="clear">Clear</option>
                                    </select>
                </td>
              </tr>
              <tr id="trDpdInterval">
                <td>DPD Interval</td>
                <td>
                  <input id="dpdInterval" type="number" name="dpd_interval" min="1" max="86400" maxlength="5" required>
                </td>
              </tr>
              <tr id="trDpdTimeout">
                <td>DPD Timeout</td>
                <td>
                  <input id="dpdTimeout" type="number" name="dpd_timeout" min="1" max="86400" maxlength="5" required>
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

    <form action="" id="statusForm">
      <div id="statusTable" class="table-wrapper noShow">
        <div id="statusPanel" class="panel panel-default">
          <button id="btnRefresh" class="btn btn-default pull-right glyphicon glyphicon-refresh" type="button"></button>
          <div class="panel-heading">
            Current Status
          </div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>Peer Address</td>
                <td id="ipsecPeerAddress"></td>
              </tr>
              <tr>
                <td>VPN Tunnel</td>
                <td id="tunnel"></td>
              </tr>
              <tr>
                <td>Status</td>
                <td id="connStatus"></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group">
          <button id="btnConnect" class="btn btn-default" type="button">Connect</button>
          <button id="btnDisconnect" class="btn btn-default" type="button">Disconnect</button>
        </div>
      </div>
    </form>
  </div>
</body>

</html>
