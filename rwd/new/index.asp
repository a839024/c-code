<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">

  <title>Test</title>
  <link rel="icon" href="img/favicon.ico" type="image/x-icon" />
  <!-- Bootstrap CSS CDN -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/layout.css">
  <!-- Font Style CSS -->
  <link rel="stylesheet" href="css/poppins-font.css">

  <!-- jQuery CDN -->
  <script src="js/ajax-jquery.min.js"></script>
  <!-- Bootstrap Js CDN -->
  <script src="js/bootstrap.min.js" defer></script>
  <!-- Local Function -->
  <script src="js/utils.js" defer></script>
  <script type="text/javascript" defer>
    $(document).ready(function() {
      $('#sidebarCollapse').on('click', function() {
        $('#sidebar').toggleClass('active');
        $(this).toggleClass('active');
      });

      $('#rebootLink').on('click', function() {
        var body = 'Click Reboot button to process system restart.';
        body += 'Please re-configure your local network setting accordingly if this device netowrk setting was changed.';
        ShowCheckDialog('Reboot', body, 'Reboot', function() {
          $.ajax({
            url: "/form/RebootCgi",
            beforeSend: function() {
              setTimeout(function() {
                location.reload();
              }, 30000);
            }
          });
        });
      });

      $('.frameLink').on('click', function() {
        $('#frame').attr('src', this.getAttribute('data-target'));
        $('#sidebar').toggleClass('active');
        $('#sidebarCollapse').toggleClass('active');
      });
    });
  </script>
</head>

<body>

  <div class="wrapper">
    <!-- Sidebar Holder -->
    <nav id="sidebar">
      <div class="sidebar-header">
        <img src="img/logo.png" style="width: 200px;">
      </div>

      <ul class="list-unstyled components">
        <li>
          <a class="frameLink" href="javascript:void(0);" data-target="overview.asp">Overview</a>
        </li>
        <li>
          <a class="frameLink" href="javascript:void(0);" data-target="wizard.html">Wizard</a>
        </li>
        <li>
          <a class="frameLink" href="javascript:void(0);" data-target="basicSetting2.asp">Basics</a>
        </li>
        <li>
          <a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false">Advances</a>
          <ul class="collapse list-unstyled" id="pageSubmenu">
            <li><a class="frameLink" href="javascript:void(0);" data-target="alert.asp">SNMP/ALERT</a></li>
            <li><a class="frameLink" href="javascript:void(0);" data-target="email.asp">Email</a></li>
            <li><a class="frameLink" href="javascript:void(0);" data-target="dhcp.asp">DHCP Server</a></li>
            <li><a class="frameLink" href="javascript:void(0);" data-target="ipsec.asp">IPsec</a></li>
            <li><a class="frameLink" href="javascript:void(0);" data-target="log.asp">Log</a></li>
            <li><a class="frameLink" href="javascript:void(0);" data-target="setup.asp">Setup</a></li>
          </ul>
        </li>
        <li>
          <a id="rebootLink" href="javascript:void(0);">Reboot</a>
        </li>
      </ul>

      <ul class="list-unstyled CTAs">
        <li><a href="http://www.atop.com.tw/atop/" class="article">Official website</a></li>
      </ul>
    </nav>

    <!-- Page Content Holder -->
    <div id="content">

      <nav class="navbar navbar-default">
        <div class="container-fluid">
          <div class="navbar-header">
            <button type="button" id="sidebarCollapse" class="navbar-btn">
                            <span></span>
                            <span></span>
                            <span></span>
                        </button>
          </div>
          <div class="navbar-collapse">
            <ul class="nav navbar-right">
              <li><a id="txtMeshMode" href="#"></a></li>
            </ul>
          </div>
        </div>
      </nav>

      <div id="main-section" class="embed-responsive embed-responsive-16by9">
        <iframe id="frame" class="embed-responsive-item" src="overview.asp" scrolling="no"></iframe>
      </div>

    </div>
  </div>
  <div class="modal fade" id="modalCheck" role="dialog" tabindex="-1" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 id="checkTitle" class="modal-title"></h4>
        </div>
        <div id="checkBody" class="modal-body">
        </div>
        <div class="modal-footer">
          <button id="btnSubmit" type="button" class="btn btn-primary" data-dismiss="modal"></button>
          <button id="btnCancel" type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="waitDialog" role="dialog" tabindex="-1" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">
                        <span class="glyphicon glyphicon-time"></span> Please Wait
                    </h4>
        </div>
        <div class="modal-body">
          <div class="progress">
            <div id="progressWait" class="progress-bar progress-bar-infoprogress-bar-striped active">
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id="toast"></div>
</body>

</html>
