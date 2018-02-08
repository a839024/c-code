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


  <script src="js/utils.js"></script>
  <script type="text/javascript" defer>
    var moon = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var week = ['1st', '2nd', '3th', '4th', 'Last'];
    var day = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    var hour = Array.from(Array(24).keys());
    var minute = Array.from(Array(60).keys());
    var second = minute;
    var offset = Array.from(Array(13).keys());
    var manualYear = Array.from(new Array(31), (val, index) => index + 2000);
    var manualMoon = moon;
    var manualDay = Array.from(new Array(31), (val, index) => index + 1);

    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());

      dateGenerator($('#selDaylightSaveMonStart'), 1);
      dateGenerator($('#selDaylightSaveWeekStart'), 1);
      dateGenerator($('#selDaylightSaveDayStart'));
      dateGenerator($('#selDaylightSaveHourStart'));
      dateGenerator($('#selDaylightSaveMonEnd'), 1);
      dateGenerator($('#selDaylightSaveWeekEnd'), 1);
      dateGenerator($('#selDaylightSaveDayEnd'));
      dateGenerator($('#selDaylightSaveHourEnd'));
      dateGenerator($('#selDaylightSaveOffset'));
      dateGenerator($('#selManualYear'));
      dateGenerator($('#selManualMon'));
      dateGenerator($('#selManualDay'), 1);
      dateGenerator($('#selHour'));
      dateGenerator($('#selMin'));
      dateGenerator($('#selSec'));

      '<%SysNTP();%>' ? $('#ntp').val('on'): $('#ntp').val('');
      '<%SysTimeDLS();%>' ? $('#daylight').val('on'): $('#daylight').val('');
      $('#currentTime').text('<%SysTime();%>');
      $('#ntpServer').val('<%SysNTPServer();%>');
      $('#selDaylightSaveMonStart').val('<%SysDLSSMon();%>');
      $('#selDaylightSaveWeekStart').val('<%SysDLSSWeek();%>');
      $('#selDaylightSaveDayStart').val('<%SysDLSSDate();%>');
      $('#selDaylightSaveHourStart').val('<%SysDLSSHour();%>');
      $('#selDaylightSaveMonEnd').val('<%SysDLSEMon();%>');
      $('#selDaylightSaveWeekEnd').val('<%SysDLSEWeek();%>');
      $('#selDaylightSaveDayEnd').val('<%SysDLSEDate();%>');
      $('#selDaylightSaveHourEnd').val('<%SysDLSEHour();%>');

      $('#txtUserName').val('<%SysUserName();%>');
      '<%SysWebMode(0);%>' ? $('#radWebMode').val(0): $('#radWebMode').val(1);

      SetIpPattern($('#txtPingServer'));
      SetCharacterPattern($('#ntpServer'));
      PreventValidateHidden($('#ntpServer'));

      ntpControl();
      daylightControl();
    });

    function ntpControl() {
      if ($('#ntp').val()) {
        $('#ntpEnable').toggleClass('switch-enable', true);
        $('#trNtp').show();
        $('#trNtpServerEnable').show();
        $('#manualPanel').hide();
      } else {
        $('#ntpEnable').toggleClass('switch-enable', false);
        $('#trNtp').hide();
        $('#trNtpServerEnable').hide();
        $('#manualPanel').show();
      }
    }

    function ntpServerEnableControl() {
      if ($('#chkNTPServerEnable').val())
        $('#ntpServerEnable').toggleClass('switch-enable', true);
      else
        $('#ntpServerEnable').toggleClass('switch-enable', false);
    }

    function daylightControl() {
      if ($('#daylight').val()) {
        $('#daylightEnable').toggleClass('switch-enable', true);
        $('#trStartDate').show();
        $('#trEndDate').show();
        $('#trOffset').show();
      } else {
        $('#daylightEnable').toggleClass('switch-enable', false);
        $('#trStartDate').hide();
        $('#trEndDate').hide();
        $('#trOffset').hide();
      }
    }

    function dateGenerator($obj, start = 0) {
      var i = start;
      var arr = eval($obj.attr('data-date'));
      arr.forEach(function(element) {
        $obj.append($('<option>', {
          value: i++,
          text: element
        }));
      });
    }

    $(document).ready(function() {
      var date = new Date();
      $('#adminTable').hide();
      $('#firmwareTable').hide();
      $('#backupTable').hide();
      $('#pingTable').hide();

      $('.userList').on('click', function() {
        var target = $(this).attr('data-target');
        $('.userList').toggleClass('active', false);
        $('.table-wrapper').hide();
        $(this).toggleClass('active');
        $(target).show();
        parent.$('#main-section').height($('body').height());
      });

      $('#ntpEnable').on('click', function() {
        $('#ntp').val() ? $('#ntp').val('') : $('#ntp').val('on');
        ntpControl();
      });

      $('#ntpServerEnable').on('click', function() {
        $('#chkNTPServerEnable').val() ? $('#chkNTPServerEnable').val('') : $('#chkNTPServerEnable').val('on');
        ntpServerEnableControl();
      });

      $('#daylightEnable').on('click', function() {
        $('#daylight').val() ? $('#daylight').val('') : $('#daylight').val('on');
        daylightControl();
      });

      $('#selManualMon, #selManualYear').on('change', function() {
        $('#selManualDay option').show();
        switch ($('#selManualMon').val()) {
          case '4':
          case '6':
          case '9':
          case '11':
            $('#selManualDay option:gt(29)').hide();
            break;
          case '2':
            $('#selManualYear').val() % 4 == 3 ? $('#selManualDay option:gt(28)').hide() : $('#selManualDay option:gt(27)').hide();
        }
      });

      $('#selManualYear').one('click', function() {
        $(this).val(date.getFullYear() - 2000);
      })

      $('#selManualMon').one('click', function() {
        $(this).val(date.getMonth());
      })

      $('#selManualDay').one('click', function() {
        $(this).val(date.getDate());
      })

      $('#selHour').one('click', function() {
        $(this).val(date.getHours());
      })

      $('#selMin').one('click', function() {
        $(this).val(date.getMinutes());
      })

      $('#selSec').one('click', function() {
        $(this).val(date.getSeconds());
      })

      $('#dateForm').on('submit', function(e) {
        console.log(CustomSerialize($('#dateForm :not(:hidden), #dateForm [type="hidden"]')));
        $.ajax({
          url: "/form/TimeCgi",
          method: "POST",
          data: CustomSerialize($('#dateForm :not(:hidden), #dateForm [type="hidden"]')),
          dataType: "json",
          success: function(result) {
            if (result.status == 'ok') {
              console.log(result);
              ShowToast('Update Success');
              $('#currentTime').text(result.sysTime);
            } else {
              ShowToast('Update Failed');
            }
          },
          error: function(result) {
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

      $('#txtUserName').on('keyup', function() {
        this.setCustomValidity($('#txtUserName').val() != 'root' ? '' : 'Not allow root as user name.');
      });

      $('#txtOldPassword').on('keyup', function() {
        var newPasswd = $('#txtNewPassword').val();
        this.setCustomValidity((($(this).val() == newPasswd) && newPasswd) ? 'Old and new password are the same' : '');
      });

      $('#txtNewPassword').on('keyup', function() {
        var oldPasswd = $('#txtOldPassword').val();
        var newPasswd = $(this).val();
        var repPasswd = $('#txtRepNewPassword').val();
        if (newPasswd == oldPasswd)
          this.setCustomValidity('Old and new password are the same');
        else if (newPasswd.match(/[\s]/g))
          this.setCustomValidity('Invalid characters \"space\" in new password.');
        else if ((newPasswd != repPasswd) && repPasswd)
          this.setCustomValidity('Inconsistency new password');
        else
          this.setCustomValidity('');
      });

      $('#txtRepNewPassword').on('keyup', function() {
        this.setCustomValidity($(this).val() == $('#txtNewPassword').val() ? '' : 'Inconsistency new password');
      });

      $('#btnUploadFirmware').on('click', function() {
        var uploadBody = 'Finish uploading firmware. Press OK to continue to write it to the flash';
        var rebootBody = 'Finish writing the new firmware to flash, reboot the system right now?';
        var fd = new FormData();

        fd.append('file', $('#firmware')[0].files[0]);
        $.ajax({
          url: '/form/firmwareUploadCgi',
          data: fd,
          dataType: 'json',
          processData: false,
          contentType: false,
          method: 'POST',
          success: function(data) {
            ShowCheckDialog('Firmware Upload', uploadBody, 'OK',
              function() {
                $.ajax({
                  url: "/form/firmwareUpgradeCgi",
                  method: "POST",
                  data: {
                    act: "action"
                  },
                  dataType: "json",
                  success: function(resp) {
                    console.log(resp);
                    if (data.status == 'ok') {
                      ShowCheckDialog('reboot', rebootBody, 'OK',
                        function() {
                          $.ajax({
                            url: "/form/RebootCgi",
                            beforeSend: function() {
                              setTimeout(function() {
                                location.reload();
                              }, 30000);
                            }
                          });
                        },
                        function() {
                          console.log('remove backdrop');
                          RemoveBackdrop();
                        });
                    } else {
                      ShowToast('Upgarde firmware failed, please double check if the new firmware is correct for this device');
                    }
                  },
                  complete: function() {
                    console.log("action complete");
                  }
                });
              },
              function() {
                $.ajax({
                  url: "/form/firmwareUpgradeCgi",
                  method: "POST",
                  data: {
                    act: "release"
                  },
                  complete: function() {
                    console.log("release complete");
                  }
                });
              }
            );
          },
          error: function() {
            ShowToast('Upload firmware failed');
          },
          beforeSend: function() {
            ShowWaitDialog('show');
          },
          complete: function() {
            ShowWaitDialog('hide');
          }
        });

      });

      $('#adminForm').on('submit', function(e) {
        if ($('#adminForm')[0].checkValidity()) {
          $.ajax({
            url: '/form/SecurityCgi',
            method: 'POST',
            data: CustomSerialize($('#adminForm')),
            dataType: 'json',
            success: function(result) {
              if (result['error']) {
                ShowToast(result['error']);
              } else {
                console.log(result);
                $('#txtUserName').val(result['userName']);
                $('#txtOldPassword').val('');
                $('#txtNewPassword').val('');
                $('#txtRepNewPassword').val('');
                $('#radWebMode').val(result['mode']);
                ShowToast('Update Success');
              }
            },
            error: function(result) {
              ShowToast('Update Failed');
            },
            beforeSend: function() {
              parent.$('#waitDialog').modal('show');
            },
            complete: function() {
              parent.$('#waitDialog').modal('hide');
            }
          });
        } else {
          ShowToast('Wrong input data');
        }
        e.preventDefault();
      });

      $('#btnBackup').on('click', function() {
        $.ajax({
          url: '/form/exportCgi',
          dataType: 'json',
          success: function(data) {
            if (data.redirect != undefined) {
              console.log(data);
              var url = document.location.protocol + '//' + window.location.host + '/' + data.redirect;
              DownloadFile(url, data.redirect);
            } else {
              ShowToast('Export configuration failed');
            }
          },
          error: function() {
            ShowToast('Export configuration failed');
          },
          beforeSend: function() {
            ShowWaitDialog('show');
          },
          complete: function() {
            ShowWaitDialog('hide');
          }
        });
      });

      $('#btnUploadConf').on('click', function() {
        var importBody = 'Press OK to import configuration file "' + $('#config')[0].files[0].name + '"';
        var rebootBody = 'Import onfiguration completed, press OK to reboot now';
        var fd = new FormData();
        ShowCheckDialog('Import Configuration', importBody, 'OK', function() {
          fd.append('file', $('#config')[0].files[0]);
          $.ajax({
            url: '/form/importCgi',
            data: fd,
            dataType: 'json',
            processData: false,
            contentType: false,
            method: 'POST',
            success: function(data) {
              console.log(data);
              if (data.status == 'ok') {
                ShowCheckDialog('reboot', rebootBody, 'OK', function() {
                  $.ajax({
                    url: '/form/RebootCgi',
                    beforeSend: function() {
                      setTimeout(function() {
                        location.reload();
                      }, 30000);
                    }
                  });
                });
              } else {
                ShowToast('Restore to default failed');
              }
            },
            error: function() {
              ShowToast('Import configuration failed');
            },
            beforeSend: function() {
              ShowWaitDialog('show');
            },
            complete: function() {
              ShowWaitDialog('hide');
            }
          });
        });
      });

      $('#btnRestore').on('click', function() {
        var restoreBody = 'Press OK to process restoring factory default configuration';
        var rebootBody = 'Restore factory default configuration completed, press OK to reboot now';
        ShowCheckDialog('Restore', restoreBody, 'OK', function() {
          $.ajax({
            url: '/form/restoreCgi',
            dataType: 'json',
            success: function(resp) {
              if (resp.status == 'ok') {
                ShowCheckDialog('reboot', rebootBody, 'OK', function() {
                  $.ajax({
                    url: '/form/RebootCgi',
                    beforeSend: function() {
                      setTimeout(function() {
                        location.reload();
                      }, 30000);
                    }
                  });
                });
              } else {
                ShowToast('Restore to default failed');
              }
            },
            error: function() {
              ShowToast('Restore to default failed');
            },
            beforeSend: function() {
              ShowWaitDialog('show');
            },
            complete: function() {
              ShowWaitDialog('hide');
            }
          })
        });
      });

      $('#pingForm').on('submit', function(e) {
        if ($('#txtPingServer')[0].checkValidity()) {
          $.ajax({
            url: '/form/AjaxPingCgi',
            method: 'POST',
            data: $('#txtPingServer').serialize(),
            dataType: 'json',
            success: function(result) {
              for (var i = 0; i < result['arr'].length; i++) {
                $('#pingResult').append(result['arr'][i]['line' + i]);
                $('#pingResult').append($('<br>'));
              }
            },
            error: function() {
              ShowToast('Ping IP failed');
            },
            beforeSend: function() {
              parent.$('#waitDialog').modal('show');
              $('#pingResult').text('');
            },
            complete: function() {
              parent.$('#waitDialog').modal('hide');
            }
          });
        } else {
          ShowToast('Invalid IP address');
        }
        e.preventDefault();
      });
    });
  </script>
</head>

<body>

  <div class="container">
    <ul class="nav nav-tabs">
      <li class="userList active" role="presentation" data-target="#dateTable"><a href="javascript:void(0);">Date/Time</a></li>
      <li class="userList" role="presentation" data-target="#adminTable"><a href="javascript:void(0);">Admin</a></li>
      <li class="userList" role="presentation" data-target="#firmwareTable"><a href="javascript:void(0);">Firmware Upgrade</a></li>
      <li class="userList" role="presentation" data-target="#backupTable"><a href="javascript:void(0);">Backup/Restore</a></li>
      <li class="userList" role="presentation" data-target="#pingTable"><a href="javascript:void(0);">Ping</a></li>
    </ul>
    <form action="" id="dateForm">
      <div id="dateTable" class="table-wrapper">
        <div id="datePanel" class="panel panel-default">
          <div class="panel-heading">Date/Time Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr id="trCurrent">
                <td>Current time</td>
                <td id="currentTime">
                  <%SysTime();%>
                </td>
              </tr>
              <tr id="trTimeZone">
                <td>Time Zone</td>
                <td>
                  <select id="selTimeZone" name="selTimeZone">
                                        <%SysTimeZone();%>
                                    </select>
                </td>
              </tr>
              <tr id="trNtpEnable">
                <td>NTP Server</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="ntpEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="ntp" type="hidden" name="chkNTPEnable">
                    </div>
                  </div>
                  <div>(Obtain date/time automatically)</div>
                </td>
              </tr>
              <tr id="trNtp">
                <td>NTP Server</td>
                <td><input id="ntpServer" type="text" name="txtNTPServer" pattern="[\w\.]+" title="Invalid characters" required></td>
              </tr>
              <tr id="trNtpServerEnable">
                <td>Local NTP Server</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="ntpServerEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="chkNTPServerEnable" type="hidden" name="chkNTPServerEnable">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trDaylight">
                <td>Daylight Saving Time</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="daylightEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="daylight" type="hidden" name="chkDaylightSaveEnable">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trStartDate">
                <td>Start Date</td>
                <td>
                  <select id="selDaylightSaveMonStart" name="selDaylightSaveMonStart" data-date="moon"></select>/
                  <select id="selDaylightSaveWeekStart" name="selDaylightSaveWeekStart" data-date="week"></select>/
                  <select id="selDaylightSaveDayStart" name="selDaylightSaveDayStart" data-date="day"></select>/
                  <select id="selDaylightSaveHourStart" name="selDaylightSaveHourStart" data-date="hour"></select>
                  <div>(Month / Week / Date / Hour)</div>
                </td>
              </tr>
              <tr id="trEndDate">
                <td>End Date</td>
                <td>
                  <select id="selDaylightSaveMonEnd" name="selDaylightSaveMonEnd" data-date="moon"></select>/
                  <select id="selDaylightSaveWeekEnd" name="selDaylightSaveWeekEnd" data-date="week"></select>/
                  <select id="selDaylightSaveDayEnd" name="selDaylightSaveDayEnd" data-date="day"></select>/
                  <select id="selDaylightSaveHourEnd" name="selDaylightSaveHourEnd" data-date="hour"></select>
                  <div>(Month / Week / Date / Hour)</div>
                </td>
              </tr>
              <tr id="trOffset">
                <td>Offset</td>
                <td>
                  <select id="selDaylightSaveOffset" name="selDaylightSaveOffset" data-date="offset"></select> hour(s)
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div id="manualPanel" class="panel panel-default">
          <div class="panel-heading">Manual Time Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>Date</td>
                <td>
                  <select id="selManualYear" name="selManualYear" data-date="manualYear"></select> /
                  <select id="selManualMon" name="selManualMon" data-date="manualMoon"></select> /
                  <select id="selManualDay" name="selManualDay" data-date="manualDay"></select>
                </td>
              </tr>
              <tr>
                <td>Time</td>
                <td>
                  <select id="selHour" name="selHour" data-date="hour"></select> :
                  <select id="selMin" name="selMin" data-date="minute"></select> :
                  <select id="selSec" name="selSec" data-date="second"></select>
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

    <form action="" id="adminForm">
      <div id="adminTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="adminPanel" class="panel-heading">Admin Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>User Name</td>
                <td><input id="txtUserName" type="text" name="txtUserName" placeholder="User Name" required></td>
              </tr>
              <tr>
                <td>Old Password</td>
                <td><input id="txtOldPassword" type="text" name="txtOldPassword" placeholder="Old Password" required></td>
              </tr>
              <tr>
                <td>New Password</td>
                <td><input id="txtNewPassword" type="text" name="txtNewPassword" placeholder="New Password"></td>
              </tr>
              <tr>
                <td>Repeat new password</td>
                <td><input id="txtRepNewPassword" type="text" name="txtRepNewPassword" placeholder="Repeat New Password"></td>
              </tr>
              <tr>
                <td>Web Mode</td>
                <td>
                  <select id="radWebMode" name="radWebMode">
                                        <option value="0">Http</option>
                                        <option value="1">Https</option>
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

    <div id="firmwareTable" class="table-wrapper">
      <div class="panel panel-default">
        <div id="firmwarePanel" class="panel-heading"> Firmware Upgrade</div>
        <table class="table table-striped">
          <tbody>
            <tr>
              <td>Select new firmware</td>
              <td><input id="firmware" type="file" name="firmware" accept=".dld"></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="center" role="group">
        <button id="btnUploadFirmware" class="btn btn-default" type="submit">Upload</button>
      </div>
    </div>

    <div id="backupTable" class="table-wrapper">
      <div class="panel panel-default">
        <div id="backupPanel" class="panel-heading">Backup Configuration</div>
        <table class="table table-striped">
          <tbody>
            <tr>
              <td>Click <b>Backup</b> to save the current configuration to your computer.</td>
              <td><button id="btnBackup" class="btn btn-default pull-right" type="button">Backup</button></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="panel panel-default">
        <div id="backupPanel" class="panel-heading">Restore Configuration</div>
        <table class="table table-striped">
          <tbody>
            <tr>
              <td>Browse a backuped configuration and click <b>Upload</b> to restore the device"s configuration.</td>
              <td><input id="config" type="file" name="config" value="Browse..."></td>
              <td><button id="btnUploadConf" class="btn btn-default" type="button">Upload</button></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="panel panel-default">
        <div id="backupPanel" class="panel-heading">Restore Factory Default</div>
        <table class="table table-striped">
          <tbody>
            <tr>
              <td>Click <b>Restore</b> to restore factory default configuration.</td>
              <td><button id="btnRestore" class="btn btn-default pull-right" type="button">Restore</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <form action="" id="pingForm">
      <div id="pingTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="pingPanel" class="panel-heading">Ping</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <!--                                <td><input id="txtPingServer" name="txtPingServer" type="text" pattern="((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}" title="Invalid IP address" required></td>-->
                <td><input id="txtPingServer" name="txtPingServer" type="text"></td>
                <td><button id="btnPing" class="btn btn-default pull-right" type="submit">Ping</button></td>
              </tr>
              <tr>
                <td id="pingResult" colspan="2">
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </form>
  </div>
</body>

</html>
