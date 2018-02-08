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
  <!-- Local Js-->
  <script src="js/utils.js" defer></script>
  <script type="text/javascript" defer>
    var emailEvent = [{
      title: 'Cold start',
      name: 'chkAlertColdStart',
      value: '<%AlertData(0);%>' ? 'on' : ''
    }, {
      title: 'Warm start',
      name: 'chkAlertWarnStart',
      value: '<%AlertData(1);%>' ? 'on' : ''
    }, {
      title: 'Authenticate failed',
      name: 'chkAlertAuthFail',
      value: '<%AlertData(2);%>' ? 'on' : ''
    }, {
      title: 'IP Address changed',
      name: 'chkAlertIPChange',
      value: '<%AlertData(3);%>' ? 'on' : ''
    }, {
      title: 'Password changed',
      name: 'chkAlertPasswordChange',
      value: '<%AlertData(4);%>' ? 'on' : ''
    }];
    var snmpEvent = [{
      title: 'Cold start',
      name: 'chkTrapColdStart',
      value: '<%SysSNMPTrapData(0);%>' ? 'on' : ''
    }, {
      title: 'Warm start',
      name: 'chkTrapWarnStart',
      value: '<%SysSNMPTrapData(1);%>' ? 'on' : ''
    }, {
      title: 'Authenticate failed',
      name: 'chkTrapAuthFail',
      value: '<%SysSNMPTrapData(2);%>' ? 'on' : ''
    }];
    var relayEvent = [{
      title: 'LAN Link Down',
      name: 'chkRelayLANLinkDown',
      value: '<%RelayData(7);%>' ? 'on' : ''
    }];

    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());
      var relay = parseInt('<%RelaySupport();%>');

      $('#txtSNMPContact').val('<%SystemContact();%>');
      $('#txtSNMPName').val('<%SystemName();%>');
      $('#txtSNMPLocation').val('<%SystemLocation();%>');
      $('#selSnmpVersion').val(parseInt('<%SysSNMPVer();%>'));
      $('#txtSNMPReadCommunity').val('<%SysReadCommunity();%>');
      $('#txtSNMPWriteCommunity').val('<%SysWriteCommunity();%>');
      $('#txtSNMPAuthUser').val('<%SysSNMPAuthName();%>');
      $('#txtSNMPAuthPass').val('<%SysSNMPAuthPassword();%>');
      $('#selEncrypt').val(parseInt('<%SysSNMPEncryptMode();%>'));
      $('#txtEncKey').val('<%SysSNMPEncryptKey();%>');
      $('#txtSNMPTrapServer').val('<%SysSNMPTrapServer();%>');

      if ('<%SysSNMPEnable();%>') {
        $('#snmpEnable').toggleClass('switch-enable', true);
        $('#chkSNMPEnable').val('on');
        snmpControll();
      } else {
        $('#snmpEnable').toggleClass('switch-enable', false);
        $('#chkSNMPEnable').val('');
        hideSnmp();
      }

      TableGenerator($('#alertEmail'));

      SetCharacterPattern($('#txtSNMPContact'));
      SetCharacterPattern($('#txtSNMPName'));
      SetCharacterPattern($('#txtSNMPLocation'));
      SetCharacterPattern($('#txtSNMPReadCommunity'));
      SetCharacterPattern($('#txtSNMPWriteCommunity'));
      SetIpPattern($('#txtSNMPTrapServer'));
      PreventValidateHidden($('#txtSNMPContact'));
      PreventValidateHidden($('#txtSNMPName'));
      PreventValidateHidden($('#txtSNMPLocation'));
      PreventValidateHidden($('#txtSNMPReadCommunity'));
      PreventValidateHidden($('#txtSNMPWriteCommunity'));
      PreventValidateHidden($('#txtSNMPTrapServer'));
    });

    function hideSnmp() {
      $('#trSnmpVersion').hide();
      $('#trReadComm').hide();
      $('#trWriteComm').hide();
      $('#trTrap').hide();
      $('#trUserName').hide();
      $('#trPasswd').hide();
      $('#trEncrypt').hide();
      $('#trKey').hide();
    }

    function keyControll() {
      switch ($('#selEncrypt').val()) {
        case '2':
        case '3':
          $('#trKey').show();
          break;
        default:
          $('#trKey').hide();
      }
    }

    function snmpControll() {
      hideSnmp();
      $('#trSnmpVersion').show();
      switch ($('#selSnmpVersion').val()) {
        case '2':
          $('#trUserName').show();
          $('#trPasswd').show();
          $('#trEncrypt').show();
          keyControll();
        case '1':
          $('#trReadComm').show();
          $('#trWriteComm').show();
          $('#trTrap').show();
          break;
        default:
          $('#trUserName').show();
          $('#trPasswd').show();
          $('#trEncrypt').show();
          keyControll();
      }
    }

    function TableGenerator($obj) {
      var arr = eval($obj.attr('data-array'));
      var tbody = $('#tbAlert');
      tbody.html($('#trAlertHeader'));
      $('#tdAlertHeader').text($obj.attr('data-title'));
      arr.forEach(function(ele) {
        var $tr = $('<tr>');
        var $container = $('<div>', {
          class: 'switch-container'
        });
        var $wrapper = $('<div>', {
          class: 'switch-wrapper'
        });
        $wrapper.append($container);
        $container.append($('<span>', {
          class: 'switch-label switch-on',
          text: 'Yes'
        }));
        $container.append($('<span>', {
          class: 'switch-label'
        }));
        $container.append($('<span>', {
          class: 'switch-label switch-off',
          text: 'no'
        }));
        $container.append($('<input>', {
          name: ele.name,
          type: 'hidden',
          value: ele.value
        }));
        if (ele.value)
          $container.addClass('switch-enable');
        $tr.append($('<td>', {
          'text': ele.title
        }));
        $tr.append($('<td>').append($wrapper));

        tbody.append($tr);
      });
    }

    //Setting Event
    $(document).ready(function() {
      $('#alertTable').hide();

      $('.alertSetting').on('click', function() {
        var span = $('.caret');
        var text = $(this).text();
        $('.dropdown-toggle').html(text).append(span);
        TableGenerator($(this));
      });

      $('.userList').on('click', function() {
        var target = $(this).attr('data-target');
        $('.userList').toggleClass('active', false);
        $('.table-wrapper').hide();
        $(this).toggleClass('active');
        $(target).show();
        parent.$('#main-section').height($('body').height());
      });

      $('body').on('click', '.switch-container', function() {
        var input = $(this).children('input');
        $(this).toggleClass('switch-enable');
        input.val() ? input.val('') : input.val('on');
      });

      $('#snmpEnable').on('click', function() {
        $('#chkSNMPEnable').val() ? hideSnmp() : snmpControll();
      });

      $('#selSnmpVersion').on('change', function() {
        snmpControll($(this));
      });

      $('#selEncrypt').on('change', function() {
        keyControll($(this));
      });

      $('#snmpForm').on('submit', function(e) {
        var i;
        console.log(CustomSerialize($('#snmpForm')));
        $.ajax({
          url: '/form/SNMPCgi',
          method: 'post',
          data: CustomSerialize($('#snmpForm')),
          dataType: 'json',
          success: function(resp) {
            if (resp.status == 'ok') {
              console.log(resp);
              for (i in emailEvent)
                ((1 << i) & parseInt(resp.mailAlert)) ? emailEvent[i]['value'] = 'on' : emailEvent[i]['value'] = '';

              for (i in snmpEvent)
                ((1 << i) & parseInt(resp.trapAlert)) ? snmpEvent[i]['value'] = 'on' : snmpEvent[i]['value'] = '';

              for (i in relayEvent)
                ((1 << i) & parseInt(resp.relayAlert)) ? relayEvent[i]['value'] = 'on' : relayEvent[i]['value'] = '';
              ShowToast('Update Success');
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
    });
  </script>
</head>

<body>

  <div class="container">
    <ul class="nav nav-tabs">
      <li class="userList active" role="presentation" data-target="#snmpTable"><a href="javascript:void(0);">SNMP Settings</a></li>
      <li class="dropdown userList" role="presentation" data-target="#alertTable">
        <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);" role="button" aria-haspopup="true" aria-expanded="false">Alert Event<span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a id="alertEmail" data-array="emailEvent" data-title="Email" data-name="Alert" class="alertSetting" href="javascript:void(0);">Alert: Email</a></li>
          <li><a id="alertSNMP" data-array="snmpEvent" data-title="SNMP Trap" data-name="Trap" class="alertSetting" href="javascript:void(0);">Alert: SNMP Trap</a></li>
          <li><a id="alertRelay" data-array="relayEvent" data-title="Relay" data-name="Relay" class="alertSetting" href="javascript:void(0);">Alert: Relay</a></li>
        </ul>
      </li>
    </ul>
    <form action="" id="snmpForm">
      <div id="snmpTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="snmpPanel" class="panel-heading">Basic Data Objects</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>System Contact</td>
                <td><input id="txtSNMPContact" type="text" name="txtSNMPContact" pattern="[\w\.]+" title="Invalid characters" placeholder="Contact"></td>
              </tr>
              <tr>
                <td>System Name</td>
                <td><input id="txtSNMPName" type="text" name="txtSNMPName" pattern="[\w\.]+" title="Invalid characters" placeholder="Name"></td>
              </tr>
              <tr>
                <td>System Location</td>
                <td><input id="txtSNMPLocation" type="text" name="txtSNMPLocation" pattern="[\w\.]+" title="Invalid characters" placeholder="Location"></td>
              </tr>
              <tr>
                <td>SNMP</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="snmpEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="chkSNMPEnable" type="hidden" name="chkSNMPEnable" value="">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trSnmpVersion">
                <td>SNMP Version</td>
                <td>
                  <select id="selSnmpVersion" name="selSnmpVersion">
                                        <option value="1">v1 / v2c</option>
                                        <option value="2">v1 / v2c / v3</option>
                                        <option value="3">Only v3</option>
                                    </select>
                </td>
              </tr>
              <tr id="trReadComm">
                <td>Read Community</td>
                <td><input id="txtSNMPReadCommunity" type="text" name="txtSNMPReadCommunity" pattern="[\w\.]+" title="Invalid characters" placeholder="Read Community"></td>
              </tr>
              <tr id="trWriteComm">
                <td>Write Community</td>
                <td><input id="txtSNMPWriteCommunity" type="text" name="txtSNMPWriteCommunity" pattern="[\w\.]+" title="Invalid characters" placeholder="Write Community"></td>
              </tr>
              <tr id="trUserName">
                <td>User Name</td>
                <td><input id="txtSNMPAuthUser" type="text" name="txtSNMPAuthUser" placeholder="User Name"></td>
              </tr>
              <tr id="trPasswd">
                <td>Password</td>
                <td><input id="txtSNMPAuthPass" type="text" name="txtSNMPAuthPass" placeholder="Password"></td>
              </tr>
              <tr id="trEncrypt">
                <td>Encrypt</td>
                <td>
                  <select id="selEncrypt" name="selEncrypt">
                                        <option value="1">None</option>
                                        <option value="2">DES</option>
                                        <option value="3">AES</option>
                                    </select>
                </td>
              </tr>
              <tr id="trKey">
                <td>Encrypt Key</td>
                <td><input id="txtEncKey" type="text" name="txtEncKey" placeholder="Encrypt Key"></td>
              </tr>
              <tr id="trTrap">
                <td>SNMP Trap Server</td>
                <td><input id="txtSNMPTrapServer" type="text" name="txtSNMPTrapServer" pattern="((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}" title="Invalid IP Address" placeholder="Trap Server"></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group">
          <button class="btn btn-default submitBtn" type="submit">Submit</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>

      <div id="alertTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="alertPanel" class="panel-heading">Event alert settings</div>
          <table class="table table-striped">
            <tbody id="tbAlert">
              <tr id="trAlertHeader">
                <td>Alert Type</td>
                <td id="tdAlertHeader">Email</td>
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
