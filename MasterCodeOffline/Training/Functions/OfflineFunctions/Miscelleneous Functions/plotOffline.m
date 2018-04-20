function[]= plotOffline(nbrClasses,ClassMean,Ctest,type,name)
%This function plots the results of classification, using ClassMean and
%Ctest as the centers and the test subjects respectively. The type will
%allow the plot to display any pairings of 6 possible distances. The 'name'
%will be the title of the figure.
%If type is "all" then type gets modified in the code so that all the plots
%are displayed.
[AccR, output1]=ClassAccuracy(ClassMean, Ctest,'riemann');
[AccK, output2]=ClassAccuracy(ClassMean, Ctest,'kullback');
[AccL, output3]=ClassAccuracy(ClassMean, Ctest,'logeuclid');
[AccO, output4]=ClassAccuracy(ClassMean, Ctest,'opttransp');
[AccLd, output5]=ClassAccuracy(ClassMean, Ctest,'ld');
[Acc, output6]=ClassAccuracy(ClassMean, Ctest,'');

x=strtrim(cellstr(num2str(nbrClasses'))');                                              %Converts numbers to string
x=strcat(x,'Hz');
xx=x;
x=categorical(x);

[len,bred,depth]=size(Ctest);
target=zeros(len,bred*depth);
p=1;
for i=1:len
    for j=1:bred*depth
    target(i,p)=1;
    p=p+1;
    end
end

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
            suptitle(name)
            
            figure;
            plotconfusion(target,output1,'Riemann Distace');
            
            xlabel('Prediction (Riemann)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            VarName2=0;
            
        case 'kullback'
            bar(x,AccK,0.25,'r')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccK),AccK,num2str(AccK'),'vert','bottom','horiz','center');
            title('Kullback Lieber Distance Test');
            grid minor;
            figure;
            suptitle(name)
            
            plotconfusion(target,output2,'Kullback Lieber Distance ');
            
            xlabel('Prediction (Kullback)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            VarName2=0;
       
        case 'logeuclid'
            bar(x,AccL,0.25,'k')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccL),AccL,num2str(AccL'),'vert','bottom','horiz','center');
            title('Log-Euclidean Distance Test');
            grid minor;
            suptitle(name)
            
            figure;
            plotconfusion(target,output3,'Log-Euclidean Distance ');
            
            xlabel('Prediction (Logeuclid)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            VarName2=0;
       
        case 'opttransp'
            bar(x,Acc,0.25,'g')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccO),Acc,num2str(AccO'),'vert','bottom','horiz','center');
            title('OP-Trans Test');
            grid minor;
            suptitle(name)
            
            figure;
            plotconfusion(target,output4,'OP-Trans Distance ');
            
            xlabel('Prediction (Opttransp)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            VarName2=0;
            
        case 'ld'
            bar(x,Acc,0.25,'g')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(AccLd),Acc,num2str(AccLd'),'vert','bottom','horiz','center');
            title('Log-Euclidean Distance Test');
            grid minor
            suptitle(name)
            
            figure;
            plotconfusion(target,output5,'Log-Euclidean Distance');
            
            xlabel('Prediction (Ld)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            grid minor;
            VarName2=0;
        case ''
            bar(x,Acc,0.25,'g')
            ylim([0 100]);
            ylabel('Accuracy %');
            text(1:length(Acc),Acc,num2str(Acc'),'vert','bottom','horiz','center');
            title('Euclidean Distance Test');
            grid minor;
            suptitle(name)
            
            figure;
            plotconfusion(target,output6,'Euclidean Distance');
            
            xlabel('Prediction (Euclidean)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            VarName2=0;
            
        otherwise
            warning('Invalid input');
    end
    i=i-1;
end




title(name)

end