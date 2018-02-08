<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Test</title>
  <!-- Bootstrap CSS CDN -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <!--    <link rel="stylesheet" href="../cssjquery.dataTables.min.css">-->
  <link rel="stylesheet" href="css/dataTable.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/table.css">
  <!-- Font Style CSS -->
  <link rel="stylesheet" href="css/poppins-font.css">
  <!-- jQuery CDN -->
  <script src="js/ajax-jquery.min.js"></script>
  <!--    <script src="../javascript/jquery.dataTables.min.js" defer></script>-->
  <script src="js/dataTable.js" defer>
    <!-- Bootstrap Js CDN -->
    <
    script src = "js/bootstrap.min.js"
    defer >
  </script>
  <!-- Local Js -->
  <script src="js/utils.js" defer></script>
  <script type="text/javascript" defer>
    var datalog;
    var moduleName = {
      <%SysLogModuleSettings();%>
    };
    var moduleNum = moduleName['arr'].length;

    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());
      $('#tdModule').attr('rowspan', moduleNum + 1);

      for (var i = 0; i < moduleNum; i++) {
        var $tr = $('<tr>');
        var $div = $('<div>', {
          class: 'checkbox'
        });
        var $input = $('<td>').append($('<input>', {
          type: 'checkbox',
          id: moduleName['arr'][i]['checkboxId'],
          checked: true
        }));
        var $label = $('<td>').append($('<label>', {
          text: moduleName['arr'][i]['key']
        }));
        $label.appendTo($tr);
        $input.appendTo($tr);
        $tr.appendTo($('#trModule').parent());
      }

      '<%SyslogMedia(0);%>' ? $('#chkSyslogToFlash').val('on'): $('#chkSyslogToFlash').val('');
      '<%SyslogMedia(1);%>' ? $('#chkSyslogServer').val('on'): $('#chkSyslogServer').val('');
      $('#txtSyslogServerIP').val('<%SyslogServer();%>');
      $('#txtSyslogServerPort').val('<%SyslogServerPort();%>');
      flashControl();
      syslogControl();
      SetIpPattern($('#txtSyslogServerIP'));
    });

    function flashControl() {
      if ($('#chkSyslogToFlash').val()) {
        $('#flashEnable').toggleClass('switch-enable', true);
      } else {
        $('#flashEnable').toggleClass('switch-enable', false);
      }
    }

    function syslogControl() {
      if ($('#chkSyslogServer').val()) {
        $('#syslogEnable').toggleClass('switch-enable', true);
        $('#trIP').show();
        $('#trPort').show();
      } else {
        $('#syslogEnable').toggleClass('switch-enable', false);
        $('#trIP').hide();
        $('#trPort').hide();
      }
    }

    function checkModuleSetting(line) {
      var checkAll = $('#' + moduleName['arr'][0]['checkboxId']).prop('checked');
      if (checkAll)
        return 1;

      for (var k = 0; k < moduleNum; k++) {
        var check = $('#' + moduleName['arr'][k]['checkboxId']).prop('checked');
        var moduleKey = '[' + moduleName['arr'][k]['key'] + ']';

        if (check && (line.indexOf(moduleKey) >= 0))
          return 1;
      }
      return 0;
    }

    function loadSysLog(func) {
      $.ajax({
        url: '/form/getSysData',
        success: function(result) {
          datalog = result;
          func();
        }
      });
    }

    function refreshSysLog() {
      var lines = datalog.split('\n');
      $('#sysLog').DataTable().clear();
      for (var i = 0; i < lines.length - 1; i++) {
        if (lines[i].length && checkModuleSetting(lines[i])) {
          var line = lines[i].replace(/ +(?= )/g, '');
          var ele = line.split(' ', 7);
          const offset = line.lastIndexOf(':') + 2;
          ele[4] = ele[4].indexOf('.') >= 0 ? ele[4].split('.')[1] : ele[4];
          $('#sysLog').DataTable().row.add([
            [ele[0], ele[1], ele[2]].join(' '),
            ele[4].toUpperCase(),
            lines[i].substring(offset)
          ]);
        }
      }
      $('#sysLog').DataTable().draw(false);
    }

    $(document).ready(function() {
      var table = $('#sysLog').DataTable({
        'lengthMenu': [10, 25]
      });
      loadSysLog(refreshSysLog);
      $('#eventTable').hide();

      $('.userList').on('click', function() {
        var target = $(this).attr('data-target');
        $('.userList').toggleClass('active', false);
        $('.table-wrapper').hide();
        $(this).toggleClass('active');
        $(target).show();
        parent.$('#main-section').height($('body').height());
      });

      $('#flashEnable').on('click', function() {
        $(this).toggleClass('switch-enable');
        $('#chkSyslogToFlash').val() ? $('#chkSyslogToFlash').val('') : $('#chkSyslogToFlash').val('on');
        flashControl();
      });

      $('#syslogEnable').on('click', function() {
        $(this).toggleClass('switch-enable');
        $('#chkSyslogServer').val() ? $('#chkSyslogServer').val('') : $('#chkSyslogServer').val('on');
        syslogControl();
      });

      $('#systemForm').on('submit', function(e) {
        console.log(CustomSerialize($('#systemForm :not(:hidden), #systemForm [type="hidden"]')));
        $.ajax({
          url: '/form/SyslogCgi',
          method: 'post',
          dataType: 'json',
          data: CustomSerialize($('#systemForm :not(:hidden), #systemForm [type="hidden"]')),
          success: function(resp) {
            console.log(resp);
          },
          error: function() {
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
      })

      $('#refresh').on('click', function() {
        loadSysLog(refreshSysLog);
      });

      $('#export').on('click', function() {
        $('<a>', {
          href: encodeURI('data:text;charset=utf-8,' + datalog),
          download: 'SysLog-<%Device();%>.txt'
        }).get(0).click();
      });

      $('#clear').on('click', function() {
        $.ajax({
          url: '/form/clearSysLog',
          success: function() {
            loadSysLog(refreshSysLog);
          }
        });
      });

      $('#severity').on('change', function() {
        table.column(1).search($('#severity').val(), false, true).draw();
      });

      PreventValidateHidden($('#txtSyslogServerIP, #txtSyslogServerPort'));
    });
  </script>
</head>

<body>

  <div class="container">
    <ul class="nav nav-tabs">
      <li class="userList active" role="presentation" data-target="#systemTable"><a href="javascript: void(0);">System Log</a></li>
      <li class="userList" role="presentation" data-target="#eventTable"><a href="javascript: void(0);">Event Log</a></li>
    </ul>

    <form action="" id='systemForm'>
      <div id="systemTable" class="table-wrapper">
        <div class="panel panel-default">
          <div class="panel-heading">System Log Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>Enable Log Event to Flash</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="flashEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="chkSyslogToFlash" type="hidden" name="chkSyslogToFlash">
                    </div>
                  </div>
                </td>
              </tr>
              <tr>
                <td>Enable Syslog Server</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="syslogEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="chkSyslogServer" type="hidden" name="chkSyslogServer">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trIP">
                <td>IP Address</td>
                <td><input id="txtSyslogServerIP" type="text" name="txtSyslogServerIP"></td>
              </tr>
              <tr id="trPort">
                <td>Syslog Server Service Port</td>
                <td><input id="txtSyslogServerPort" type="number" name="txtSyslogServerPort" max="65535" min="1" required>(1~65535, default=514)</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group" aria-label="...">
          <button class="btn btn-default submitBtn" type="submit">Submit</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>
    </form>

    <div id="eventTable" class="table-wrapper">
      <div class="panel panel-default">
        <div class="panel-heading">System Log</div>
        <table class="table table-striped">
          <tbody>
            <tr id="trSeverity">
              <td>Severity</td>
              <td colspan="2">
                <select id="severity" name="severity" class="">
                                        <option value="" selected>All</option>
                                        <option value="Error">Error</option>
                                        <option value="WARN">Warning</option>
                                        <option value="INFO">Info</option>
                                </select>
              </td>
            </tr>
            <tr id="trModule">
              <td id="tdModule">Modules</td>
            </tr>
          </tbody>
        </table>
        <button id="refresh" class="btn btn-default" type="button">Refresh</button>
        <button id="export" class="btn btn-default" type="button">Export</button>
        <button id="clear" class="btn btn-default" type="button">Clear</button>
        <table id="sysLog" class="table table-striped table-bordered">
          <thead>
            <tr>
              <th>Time</th>
              <th>Serverity</th>
              <th>Message</th>
            </tr>
          </thead>
        </table>
      </div>
    </div>
  </div>
</body>

</html>
