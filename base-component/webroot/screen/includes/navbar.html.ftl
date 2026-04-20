<#assign screenDocList = sri.getScreenUrlInfo().getTargetScreen().getScreenDocumentInfoList()>
<#assign currentScreenUrl = sri.getScreenUrlInstance().getUrlWithParams()>
<#assign currentScreenTitle = html_title!(ec.resource.expand(sri.screenUrlInfo.targetScreen.getDefaultMenuName()!"Page", ""))>

<nav class="moqui-topbar navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid moqui-topbar__inner">
    <div class="moqui-topbar__brand-zone">
      <button class="navbar-toggler moqui-topbar__toggler" type="button"
              data-bs-toggle="collapse" data-bs-target="#navbar-buttons"
              aria-controls="navbar-buttons" aria-expanded="false"
              aria-label="${ec.l10n.localize('Toggle navigation')}">
        <span class="navbar-toggler-icon"></span>
      </button>

      <#assign headerLogoList = sri.getThemeValues("STRT_HEADER_LOGO")>
      <#if headerLogoList?has_content>
        <a href="${sri.buildUrl('/apps').getUrl()}"
           class="navbar-brand moqui-topbar__brand"
           up-follow up-target="#content" up-history="true">
          <img src="${sri.buildUrl(headerLogoList?first).getUrl()}" alt="Home">
        </a>
      </#if>

      <div class="moqui-topbar__context">
        <#assign headerTitleList = sri.getThemeValues("STRT_HEADER_TITLE")>
        <#if headerTitleList?has_content>
          <a href="${sri.buildUrl('/apps').getUrl()}"
             class="moqui-topbar__app-title"
             up-follow up-target="#content" up-history="true">${ec.resource.expand(headerTitleList?first, "")}</a>
        </#if>
        <ul id="header-menus" class="navbar-nav moqui-topbar__menus">
          <#-- NOTE: menu drop-downs are appended here using JS as subscreens render so this is empty -->
        </ul>
        <div id="navbar-menu-crumbs" class="moqui-topbar__crumbs"></div>
        <a id="navbar-current-title"
           class="moqui-topbar__current"
           href="${currentScreenUrl}"
           up-follow up-target="#content" up-history="true">${currentScreenTitle}</a>
      </div>
    </div>

    <div id="navbar-buttons" class="collapse navbar-collapse moqui-topbar__collapse">
      <div class="moqui-topbar__actions">
        <#-- header navbar items from the theme -->
        <#assign navbarItemList = sri.getThemeValues("STRT_HEADER_NAVBAR_ITEM")>
        <#list navbarItemList! as navbarItem>
          <#assign navbarItemTemplate = navbarItem?interpret>
          <@navbarItemTemplate/>
        </#list>

        <#if screenDocList?has_content>
          <div id="document-menu" class="dropdown moqui-topbar__dropdown">
            <button id="document-menu-link"
                    class="btn btn-sm btn-outline-info moqui-topbar__icon-btn"
                    type="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                    title="Documentation">
              <i class="fa fa-question-circle"></i>
              <span class="visually-hidden">Documentation</span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
              <#list screenDocList as screenDoc>
                <li>
                  <button type="button" class="dropdown-item" onclick="return showScreenDocDialog('${screenDoc.index}')">${screenDoc.title}</button>
                </li>
              </#list>
            </ul>
          </div>
        </#if>

        <div id="history-menu" class="dropdown moqui-topbar__dropdown">
          <button id="history-menu-link"
                  class="btn btn-sm btn-outline-light moqui-topbar__icon-btn"
                  type="button"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                  title="${ec.l10n.localize('History')}">
            <i class="fa fa-list"></i>
            <span class="visually-hidden">${ec.l10n.localize('History')}</span>
          </button>
          <#assign screenHistoryList = ec.web.getScreenHistory()>
          <ul class="dropdown-menu dropdown-menu-end shadow-sm moqui-topbar__history-menu">
            <#list screenHistoryList as screenHistory><#if (screenHistory_index >= 25)><#break></#if>
              <li>
                <a class="dropdown-item"
                   href="${screenHistory.url}"
                   up-follow up-target="#content" up-history="true">
                  <#if screenHistory.image?has_content>
                    <#if screenHistory.imageType == "icon">
                      <i class="${screenHistory.image} me-2"></i>
                    <#elseif screenHistory.imageType == "url-plain">
                      <img src="${screenHistory.image}" alt="${screenHistory.name}" width="18" class="me-2"/>
                    <#else>
                      <img src="${sri.buildUrl(screenHistory.image).url}" alt="${screenHistory.name}" height="18" class="me-2"/>
                    </#if>
                  <#else>
                    <i class="fa fa-link me-2"></i>
                  </#if>
                  <span>${screenHistory.name}</span>
                </a>
              </li>
            </#list>
          </ul>
        </div>

        <button type="button"
                class="btn btn-sm btn-outline-light moqui-topbar__icon-btn"
                title="${ec.l10n.localize('Switch Dark/Light')}"
                onclick="switchDarkLight(); return false;">
          <i class="fa fa-adjust"></i>
          <span class="visually-hidden">${ec.l10n.localize('Switch Dark/Light')}</span>
        </button>

        <a href="${sri.buildUrl('/Login/logout').url}"
           class="btn btn-sm btn-outline-danger moqui-topbar__icon-btn"
           title="${ec.l10n.localize('Logout')} ${(ec.getUser().getUserAccount().userFullName)!}">
          <i class="fa fa-power-off"></i>
          <span class="visually-hidden">${ec.l10n.localize('Logout')}</span>
        </a>
      </div>
    </div>
  </div>
</nav>

<script>
(function() {
    function syncNavbarCurrentTitle() {
        var titleEl = document.getElementById('navbar-current-title');
        if (!titleEl) return;

        var metaEl = document.querySelector('#content .moqui-current-screen-meta');
        if (metaEl) {
            var screenTitle = metaEl.getAttribute('data-screen-title');
            var screenUrl = metaEl.getAttribute('data-screen-url');
            if (screenTitle) titleEl.textContent = screenTitle;
            if (screenUrl) titleEl.setAttribute('href', screenUrl);
        }

        var crumbsHost = document.getElementById('navbar-menu-crumbs');
        var hasAnyCrumb = crumbsHost && crumbsHost.children && crumbsHost.children.length > 0;
        titleEl.style.display = hasAnyCrumb ? 'none' : '';
    }

    window.switchDarkLight = function() {
        var body = document.body;
        body.classList.toggle('bg-dark');
        body.classList.toggle('bg-light');
        var currentStyle = body.classList.contains('bg-dark') ? 'bg-dark' : 'bg-light';
        fetch('${sri.buildUrl("/apps/setPreference").url}', {
            method: 'POST',
            credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: 'moquiSessionToken=' + encodeURIComponent('${ec.web.sessionToken}') +
                  '&preferenceKey=' + encodeURIComponent('OUTER_STYLE') +
                  '&preferenceValue=' + encodeURIComponent(currentStyle)
        }).catch(function() {});
    };

    window.showScreenDocDialog = function(docIndex) {
        var trigger = document.getElementById('document-menu-link');
        var dialogId = 'screen-document-dialog';
        if (typeof window.moquiOpenModal === 'function') {
            window.moquiOpenModal(dialogId, trigger, '#' + dialogId);
        } else {
            var dlg = document.getElementById(dialogId);
            if (dlg) {
                dlg.style.display = 'block';
                dlg.classList.add('show');
                dlg.classList.add('in');
                dlg.removeAttribute('inert');
                dlg.setAttribute('aria-hidden', 'false');
            }
        }
        if (window.up && up.render) {
            up.render({ url: '${sri.buildUrlFromTarget("screenDoc").url}?docIndex=' + encodeURIComponent(docIndex), target: '#screen-document-dialog-body', history: false });
        } else {
            fetch('${sri.buildUrlFromTarget("screenDoc").url}?docIndex=' + encodeURIComponent(docIndex), { credentials: 'same-origin' })
                .then(function(resp) { return resp.text(); })
                .then(function(html) {
                    var body = document.getElementById('screen-document-dialog-body');
                    if (body) body.innerHTML = html;
                });
        }
        return false;
    };

    function resetScreenDocBody() {
        var body = document.getElementById('screen-document-dialog-body');
        if (!body) return;
        body.innerHTML = '<img src="/images/wait_anim_16x16.gif" alt="Loading...">';
    }

    document.addEventListener('hidden.bs.modal', function(ev) {
        if (ev.target && ev.target.id === 'screen-document-dialog') resetScreenDocBody();
    });
    document.addEventListener('up:rendered', syncNavbarCurrentTitle);
    document.addEventListener('up:fragment:loaded', syncNavbarCurrentTitle);
    document.addEventListener('up:fragment:inserted', syncNavbarCurrentTitle);
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', syncNavbarCurrentTitle);
    } else {
        syncNavbarCurrentTitle();
    }
})();
</script>

<#if screenDocList?has_content>
    <#assign screenDocDialogText>
    <div id="screen-document-dialog" class="modal dynamic-dialog" aria-hidden="true" style="display: none;" tabindex="-1" inert>
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">${ec.l10n.localize("Documentation")}</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="${ec.l10n.localize('Close')}"></button>
                </div>
                <div class="modal-body" id="screen-document-dialog-body">
                    <img src="/images/wait_anim_16x16.gif" alt="Loading...">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">${ec.l10n.localize("Close")}</button>
                </div>
            </div>
        </div>
    </div>
    </#assign>
    <#t>${sri.appendToAfterScreenWriter(screenDocDialogText)}
</#if>
