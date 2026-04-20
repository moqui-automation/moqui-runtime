<div id="browser-warning" class="d-none text-center" style="margin-bottom: 80px;">
    <h4 class="text-danger">Your browser is not supported, please use a recent version of one of the following:</h4>
    <div class="row" style="font-size: 4em;">
        <div class="col-sm-2"></div>
        <div class="col-sm-2"><a href="https://www.google.com/chrome/"><i class="fa fa-chrome"></i></a></div>
        <div class="col-sm-2"><a href="https://www.mozilla.org/firefox/"><i class="fa fa-firefox"></i></a></div>
        <div class="col-sm-2"><a href="https://www.apple.com/safari/"><i class="fa fa-safari"></i></a></div>
        <div class="col-sm-2"><a href="https://www.microsoft.com/windows/microsoft-edge"><i class="fa fa-edge"></i></a></div>
        <div class="col-sm-2"></div>
    </div>
</div>
<!-- currently general/common HTML5 and ES5 support is currently required, so check for IE and older browsers -->
<script>
    (function() {
        var ua = (window.navigator.userAgent || '').toLowerCase();
        var isIE = /msie|trident/.test(ua);
        if (isIE) {
            var warning = document.getElementById('browser-warning');
            if (warning) warning.classList.remove('d-none');
        }
    })();
</script>

<div class="text-center form-signin">
    <ul class="nav nav-tabs d-inline-flex flex-nowrap justify-content-center" id="login-tabs" role="tablist" style="white-space: nowrap;">
        <li class="nav-item" role="presentation"><button class="nav-link px-2" type="button" data-moqui-login-tab="login">${ec.l10n.localize("Login")}</button></li>
        <#if authFlowList?has_content && !authFlowList.isEmpty()><li class="nav-item" role="presentation"><button class="nav-link px-2" type="button" data-moqui-login-tab="sso">${ec.l10n.localize("SSO")}</button></li></#if>
        <li class="nav-item" role="presentation"><button class="nav-link px-2" type="button" data-moqui-login-tab="reset">${ec.l10n.localize("Reset Password")}</button></li>
        <li class="nav-item" role="presentation"><button class="nav-link px-2" type="button" data-moqui-login-tab="change">${ec.l10n.localize("Change Password")}</button></li>
    </ul>
</div>

<div class="tab-content" id="login-tab-content">
    <div id="login" class="tab-pane" role="tabpanel" data-moqui-tab-pane="login">
        <form method="post" action="${sri.buildUrl("login").url}" class="form-signin" id="login_form" up-submit up-target="#content">
            <input type="hidden" name="initialTab" value="login" class="initial-tab">
            <input id="login_form_username" name="username" type="text" value="${(username!"")?html}"
                    <#if username?has_content && secondFactorRequired>disabled="disabled"</#if>
                    required="required" class="form-control top"
                    placeholder="${ec.l10n.localize("Username")}" aria-label="${ec.l10n.localize("Username")}">
            <#-- secondFactorRequired will only be set if a user is pre-authenticated, and in that case password not required again -->
            <#if secondFactorRequired>
                <input id="login_form_code" name="code" type="text" inputmode="numeric" autocomplete="one-time-code"
                       required="required" class="form-control bottom"
                       placeholder="${ec.l10n.localize("Authentication Code")}" aria-label="${ec.l10n.localize("Authentication Code")}">
            <#else>
                <input type="password" name="password" required="required" class="form-control bottom"
                       placeholder="${ec.l10n.localize("Password")}" aria-label="${ec.l10n.localize("Password")}">
            </#if>
            <button class="btn btn-lg btn-primary w-100" type="submit">${ec.l10n.localize("Sign in")}</button>
            <#if expiredCredentials><p class="text-warning text-center">WARNING: Your password has expired</p></#if>
            <#if passwordChangeRequired><p class="text-warning text-center">WARNING: Password change required</p></#if>
        </form>
    </div>

    <#if authFlowList?has_content && !authFlowList.isEmpty()>
        <div id="sso" class="tab-pane" role="tabpanel" data-moqui-tab-pane="sso">
            <#list authFlowList as authFlow>
                <form method="post" action="/sso/login" class="form-signin">
                    <input type="hidden" name="authFlowId" value="${authFlow.authFlowId}">
                    <button class="btn btn-lg btn-primary w-100" type="submit">${authFlow.description}</button>
                </form>
            </#list>
        </div>
    </#if>

    <div id="reset" class="tab-pane" role="tabpanel" data-moqui-tab-pane="reset">
        <form method="post" action="${sri.buildUrl("resetPassword").url}" class="form-signin" id="reset_form" up-submit up-target="#content">
            <p class="text-muted text-center">${ec.l10n.localize("Enter your username to email a reset password")}</p>
            <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
            <input type="hidden" name="initialTab" value="reset" class="initial-tab">
            <input id="reset_form_username" name="username" type="text" value="${(username!"")?html}"
                    <#if username?has_content && secondFactorRequired>disabled="disabled"</#if>
                    required="required" class="form-control"
                    placeholder="${ec.l10n.localize("Username")}" aria-label="${ec.l10n.localize("Username")}">
            <button class="btn btn-lg btn-danger w-100" type="submit">${ec.l10n.localize("Email Reset Password")}</button>
        </form>
    </div>

    <div id="change" class="tab-pane" role="tabpanel" data-moqui-tab-pane="change">
        <form method="post" action="${sri.buildUrl("changePassword").url}" class="form-signin" id="change_form" up-submit up-target="#content">
            <p class="text-muted text-center">${ec.l10n.localize("Enter details to change your password")}</p>
            <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
            <input type="hidden" name="initialTab" value="change" class="initial-tab">
            <input id="change_form_username" name="username" type="text" value="${(username!"")?html}"
                    <#if username?has_content && secondFactorRequired>disabled="disabled"</#if>
                    required="required" class="form-control top"
                    placeholder="${ec.l10n.localize("Username")}" aria-label="${ec.l10n.localize("Username")}">
            <#-- secondFactorRequired will only be set if a user is pre-authenticated, and in that case password not required again -->
            <#if secondFactorRequired>
                <input type="hidden" name="oldPassword" value="ignored">
                <input id="change_form_code" name="code" type="text" inputmode="numeric" autocomplete="one-time-code"
                        required="required" class="form-control middle"
                        placeholder="${ec.l10n.localize("Authentication Code")}" aria-label="${ec.l10n.localize("Authentication Code")}">
            <#else>
                <input type="password" name="oldPassword" required="required" class="form-control middle"
                        placeholder="${ec.l10n.localize("Old Password")}" aria-label="${ec.l10n.localize("Old Password")}">
            </#if>
            <input type="password" name="newPassword" required="required" class="form-control middle"
                    placeholder="${ec.l10n.localize("New Password")}" aria-label="${ec.l10n.localize("New Password")}">
            <input type="password" name="newPasswordVerify" required="required" class="form-control bottom"
                    placeholder="${ec.l10n.localize("New Password Verify")}" aria-label="${ec.l10n.localize("New Password Verify")}">
            <button class="btn btn-lg btn-danger w-100" type="submit">${ec.l10n.localize("Change Password")}</button>

            <p class="text-muted text-center">Password must be at least ${minLength} characters
                with at least <strong>${minDigits} number<#if (minDigits > 1)>s</#if></strong>
                <#if (minOthers > 0)> and at least <strong>${minOthers} punctuation character<#if (minOthers > 1)>s</#if></strong></#if></p>
        </form>
    </div>
</div>

<#if secondFactorRequired>
    <p class="text-center">${ec.l10n.localize("An authentication code is required for your account, you have these options:")}</p>
    <ul class="form-signin" style="padding-left:40px;">
        <#list factorTypeDescriptions as factorType>
            <li>${factorType}</li>
        </#list>
    </ul>
    <#list sendableFactors as userAuthcFactor>
        <div class="text-center">
            <form method="post" action="${sri.buildUrl("sendOtp").url}" class="form-signin" up-submit up-target="#content">
                <input type="hidden" name="factorId" value="${userAuthcFactor.factorId}">
                <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
                <input type="hidden" name="initialTab" class="initial-tab">
                <button class="btn btn-lg btn-primary" type="submit">${ec.l10n.localize("Send code to")} ${userAuthcFactor.factorOption!}</button>
            </form>
        </div>
    </#list>
</#if>

<#if (ec.web.sessionAttributes.get("moquiPreAuthcUsername"))?has_content>
    <form method="post" action="${sri.buildUrl("removePreAuth").url}" class="form-signin" id="remove_preauth_form" up-submit up-target="#content">
        <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
        <button class="btn btn-lg w-100" type="submit">${ec.l10n.localize("Change User")}</button>
    </form>
</#if>

<script>
(function() {
    var tabButtons = Array.prototype.slice.call(document.querySelectorAll('[data-moqui-login-tab]'));
    var tabPanes = Array.prototype.slice.call(document.querySelectorAll('[data-moqui-tab-pane]'));

    function setInitialTabValue(tabName) {
        document.querySelectorAll('.initial-tab').forEach(function(el) { el.value = tabName; });
    }

    function focusTabField(tabName) {
        <#if username?has_content && secondFactorRequired>
            if (tabName === 'login') {
                var c1 = document.getElementById('login_form_code'); if (c1) c1.focus();
            } else if (tabName === 'change') {
                var c2 = document.getElementById('change_form_code'); if (c2) c2.focus();
            } else if (tabName === 'reset') {
                var u1 = document.getElementById('reset_form_username'); if (u1) u1.focus();
            }
        <#else>
            if (tabName === 'login') {
                var l1 = document.getElementById('login_form_username'); if (l1) l1.focus();
            } else if (tabName === 'change') {
                var c1 = document.getElementById('change_form_username'); if (c1) c1.focus();
            } else if (tabName === 'reset') {
                var r1 = document.getElementById('reset_form_username'); if (r1) r1.focus();
            }
        </#if>
    }

    function activateTab(tabName, updateHash) {
        tabButtons.forEach(function(btn) {
            var isActive = btn.getAttribute('data-moqui-login-tab') === tabName;
            btn.classList.toggle('active', isActive);
            btn.setAttribute('aria-selected', isActive ? 'true' : 'false');
        });

        tabPanes.forEach(function(pane) {
            var isActive = pane.getAttribute('data-moqui-tab-pane') === tabName;
            pane.classList.toggle('active', isActive);
            pane.classList.toggle('show', isActive);
            pane.classList.toggle('fade', true);
        });

        setInitialTabValue(tabName);
        if (updateHash) window.location.hash = '#' + tabName;
        focusTabField(tabName);
    }

    tabButtons.forEach(function(btn) {
        btn.addEventListener('click', function() {
            activateTab(btn.getAttribute('data-moqui-login-tab'), true);
        });
    });

    var hashTab = (window.location.hash || '${initialTab!"#login"}').replace('#', '');
    var hasTab = tabButtons.some(function(btn) { return btn.getAttribute('data-moqui-login-tab') === hashTab; });
    activateTab(hasTab ? hashTab : 'login', false);
})();
</script>
