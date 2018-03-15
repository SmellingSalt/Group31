function eegplugin_erppeakinterval(fig,try_strings,catch_strings)

version = 1.0;
% create menu
toolsmenu1 = findobj(fig, 'tag', 'tools');
toolsmenu2 = findobj(fig, 'tag', 'ERPLAB');

uimenu( toolsmenu2, 'label', 'Measure Peak Interval', 'separator','on','callback', '[ERP_MEASURES]=pop_erppeakinterval(ERP);');
