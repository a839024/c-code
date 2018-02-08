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
    $(window).ready(function() {
      parent.$('#main-section').height($('body').height());

      $('#sender').val('<%AlertSenderMail();%>');
      $('#receiver').val('<%AlertReceiverMail();%>');
      $('#smtp').val('<%AlertSenderServer();%>');
      '<%AlertAuth();%>' ? $('#auth').val('on'): $('#auth').val('');
      $('#userName').val('<%AlertAuthUser();%>');
      $('#password').val('<%AlertAuthPassword();%>');

      SetIpPattern($('#smtp'));
      PreventValidateHidden($('#userName'));

      authControl();
      mailBtnControl();
    });

    function authControl() {
      if ($('#auth').val()) {
        $('#authEnable').toggleClass('switch-enable', true);
        $('#trUserName').show();
        $('#trPasswd').show();
      } else {
        $('#authEnable').toggleClass('switch-enable', false);
        $('#trUserName').hide();
        $('#trPasswd').hide();
      }
    }

    function mailBtnControl() {
      if ($('#sender').val() && $('#receiver').val() && $('#smtp').val())
        $('#btnSendMail').show();
      else
        $('#btnSendMail').hide();
    }

    $(document).ready(function() {
      var ajaxData = '';

      $('#authEnable').on('click', function() {
        $('#auth').val() ? $('#auth').val('') : $('#auth').val('on');
        authControl();
      });

      $('#receiver').on('blur', function(e) {
        var mails = $(this).val().split(';');
        var failedMails = [];
        var fail = false;
        mails.forEach(function(mail) {
          if (!mail.match(/^[a-z0-9\._%\+-]+@[a-z0-9\.-]+\.[a-z]{2,4}$/i) && mail) {
            failedMails.push(mail);
            fail = true;
          }
        });
        if (fail)
          e.target.setCustomValidity('Invalid Mail "' + failedMails.join('", "') + '"');
        else
          e.target.setCustomValidity('');
      })

      $('#emailForm').on('submit', function(e) {
        console.log(ajaxData);
        $.ajax({
          url: '/form/SMTPCgi',
          method: 'post',
          data: ajaxData,
          dataType: 'json',
          success: function(resp) {
            if (resp.status == 'ok') {
              ShowToast('Update Success');
              mailBtnControl();
            } else if (resp.testMail != undefined) {
              ShowToast('Send Test Mail ' + resp.testMail);
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

      $('#btnSave, #btnSendMail').on('click', function() {
        ajaxData = CustomSerialize($('#emailForm :not(:hidden), #emailForm [type="hidden"]'));
        ajaxData += '&' + $(this).attr('name') + '=' + encodeURIComponent($(this).val());
      })
    });
  </script>
</head>

<body>

  <div class="container">

    <form action="" id="emailForm">
      <div id="emailTable" class="table-wrapper">
        <div class="panel panel-default">
          <div id="emailPanel" class="panel-heading">E-mail Settings</div>
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>Sender</td>
                <td><input id="sender" type="email" name="txtSenderMail"></td>
              </tr>
              <tr>
                <td>Receiver</td>
                <td>
                  <textArea id="receiver" name="txtReceiverMail" rows=5></textArea> Use a semicolon (;) to delimit the receiver's e-mail address.
                </td>
              </tr>
              <tr>
                <td>SMTP Server</td>
                <td><input id="smtp" type="text" name="txtSMTPServer"></td>
              </tr>
              <tr>
                <td>Authentication</td>
                <td>
                  <div class="switch-wrapper">
                    <div id="authEnable" class="switch-container">
                      <span class="switch-label switch-on">Yes</span>
                      <span class="switch-label"></span>
                      <span class="switch-label switch-off">no</span>
                      <input id="auth" type="hidden" name="chkAuthenticaton">
                    </div>
                  </div>
                </td>
              </tr>
              <tr id="trUserName">
                <td>User Name</td>
                <td><input id="userName" type="email" name="txtUserName" placeholder="user name"></td>
              </tr>
              <tr id="trPasswd">
                <td>Password</td>
                <td><input id="password" type="password" name="txtPassword" placeholder="password"></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="center" role="group">
          <button id="btnSave" class="btn btn-default" type="submit" name="submitValue" value="Save & Apply">Save & Apply</button>
          <button id="btnSendMail" class="btn btn-default" type="submit" name="submitValue" value="Send Test Mail">Send Test Mail</button>
          <button class="btn btn-default" type="reset">Reset</button>
        </div>
      </div>
    </form>

  </div>

</body>

</html>
