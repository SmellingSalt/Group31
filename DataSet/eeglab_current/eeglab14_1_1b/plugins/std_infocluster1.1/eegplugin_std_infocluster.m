function vers = eegplugin_std_infocluster( fig, trystrs, catchstrs);

vers = 'Infocluster1.0Beta';

% add menu to clustedit
% ---------------------
menu = findobj(fig, 'Label', 'Edit/plot clusters');

g = [1 0.3 1];
if ~isempty(findstr(get(menu, 'Callback'), 'std_envtopo'))
    structure.uilist = { { } ...
        {'style' 'pushbutton' 'string' 'Plot Envtopo plugin (beta)'  'Callback' 'args = { STUDY ALLEEG}; STUDY = pop_std_envtopo(args{:}); clear args;' } { } { }...
        {'style' 'pushbutton' 'string' 'Cluster Info (beta)'          'Callback' 'args = { STUDY ALLEEG}; STUDY = pop_std_infocluster(args{:}); clear args;' } { } { }};
    structure.geometry = {[1] g g};
else
    structure.uilist = { { } ...
        {'style' 'pushbutton' 'string' 'Cluster Info(beta)'          'Callback' 'args = { STUDY ALLEEG}; STUDY = pop_std_infocluster(args{:}); clear args;' } { } { }};
    structure.geometry = {[1] g};
end
arg = vararg2str( { structure } );
cb_clustedit   = [ trystrs.no_check 'ALLEEGTMP = ALLEEG; [STUDYTMP LASTCOM] = pop_clustedit(STUDY, ALLEEG, [], ' arg ');' catchstrs.update_study];
set(menu, 'callback', cb_clustedit);