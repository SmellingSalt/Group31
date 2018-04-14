function[]= plotOffline(nbrClasses,ClassMean,Ctest,type,name)
%This function plots the results of classification, using ClassMean and
%Ctest as the centers and the test subjects respectively. The type will
%allow the plot to display any pairings of 6 possible distances. The 'name'
%will be the title of the figure.
AccR=ClassAccuracy(ClassMean, Ctest,'riemann');
AccK=ClassAccuracy(ClassMean, Ctest,'kullback');
AccL=ClassAccuracy(ClassMean, Ctest,'logeuclid');
AccO=ClassAccuracy(ClassMean, Ctest,'opttransp');
AccLd=ClassAccuracy(ClassMean, Ctest,'ld');
Acc=ClassAccuracy(ClassMean, Ctest,'');

x=strtrim(cellstr(num2str(nbrClasses'))');                                              %Converts numbers to string
x=strcat(x,'Hz');
x=categorical(x);

i=length(type);
while i>0
    types=type(1,(length(type)-i+1));
    if ~exist('VarName')||~exist('VarName2')                                             %Execute this only once
        switch i
            case 1
                if type=="all"||type=="ALL"
                    type=["riemann","kullback", "logeuclid", "opttransp", "ld", ""];
                    plot_id1=3;
                    plot_id2=2;
                    i=6;
                    types=type(1,(length(type)-i+1));
                else
                    plot_id1=1;
                    plot_id2=1;
                end
            case 2
                plot_id1=1;
                plot_id2=2;
            case 3
                plot_id1=2;
                plot_id2=2;
            case 4
                plot_id1=2;
                plot_id2=2;
            case 5
                plot_id1=3;
                plot_id2=2;
            case 6
                plot_id1=3;
                plot_id2=2;
            otherwise
                warning('Enter a valid number of distances');
        end
        VarName=0;
    end

   h(length(type)-i+1)=subplot(plot_id1,plot_id2,length(type)-i+1);
   if length(type)~=1&&mod(length(type),2)==1&&i==1
       pos = get(h,'Position');
       new = mean(cellfun(@(v)v(1),pos(1:2)));
       set(h(length(type)-i+1),'Position',[new,pos{end}(2:end)])
   end
    switch types
        case 'riemann'
            bar(x,AccR,0.25,'c')
            ylim([0 100]);                                                              %Bar Graph Height
            ylabel('Accuracy %');
            text(1:length(AccR),AccR,num2str(AccR'),'vert','bottom','horiz','center');  %Sets numbers on top of graph
            title('Riemann Distance Test');
            grid minor;
            VarName2=0;
            
        case 'kullback'
            bar(x,AccK,0.25,'r')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccK),AccK,num2str(AccK'),'vert','bottom','horiz','center');
            title('Kullback Lieber Distance Test');
            grid minor;
            VarName2=0;
        case 'logeuclid'
            bar(x,AccL,0.25,'k')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccL),AccL,num2str(AccL'),'vert','bottom','horiz','center');
            title('Log-Euclidean Distance Test');
            grid minor;
            
        case 'opttransp'
            bar(x,Acc,0.25,'g')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccO),Acc,num2str(AccO'),'vert','bottom','horiz','center');
            title('OP-Trans Test');
            grid minor;
            VarName2=0;
            
        case 'ld'
            bar(x,Acc,0.25,'g')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccLd),Acc,num2str(AccLd'),'vert','bottom','horiz','center');
            title('Log-Euclidean Distance Test');
            grid minor;
            VarName2=0;
        case ''
            bar(x,Acc,0.25,'g')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(Acc),Acc,num2str(Acc'),'vert','bottom','horiz','center');
            title('Euclidean Distance Test');
            grid minor;
            VarName2=0;
            
        otherwise
            warning('Invalid input');
    end
    i=i-1;
end


suptitle(name)

end