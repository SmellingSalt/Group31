function[]= plotConfuse(nbrClasses,ClassMean,Ctest,type,name)
%This function plots the results of classification, using ClassMean and
%Ctest as the centers and the test subjects respectively. The type will
%allow the plot to display any pairings of 6 possible distances. The 'name'
%will be the title of the figure.
%If type is "all" then type gets modified in the code so that all the plots
%are displayed.
[~, output1]=ClassAccuracy(ClassMean, Ctest,'riemann');
[~, output2]=ClassAccuracy(ClassMean, Ctest,'kullback');
[~, output3]=ClassAccuracy(ClassMean, Ctest,'logeuclid');
[~, output4]=ClassAccuracy(ClassMean, Ctest,'opttransp');
[~, output5]=ClassAccuracy(ClassMean, Ctest,'ld');
[~, output6]=ClassAccuracy(ClassMean, Ctest,'');

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
    switch types
        case 'riemann'
            figure;
            plotconfusion(target,output1,'Riemann Distance');
            xlabel('Prediction (Riemann)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            title(name)
            VarName2=0;
            
        case 'kullback'
            figure;
            plotconfusion(target,output2,'Kullback Lieber Distance ');
            xlabel('Prediction (Kullback)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            title(name)
            VarName2=0;
            
        case 'logeuclid'
            figure;
            plotconfusion(target,output3,'Log-Euclidean Distance ');
            xlabel('Prediction (Logeuclid)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            VarName2=0;
            
        case 'opttransp'
            figure;
            plotconfusion(target,output4,'OP-Trans Distance ');
            xlabel('Prediction (Opttransp)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            VarName2=0;
            
        case 'ld'
            
            figure;
            plotconfusion(target,output5,'Log-Euclidean Distance');
            xlabel('Prediction (Ld)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            title(name)
            VarName2=0;
        case ''
            
            figure;
            plotconfusion(target,output6,'Euclidean Distance');
            xlabel('Prediction (Euclidean)');
            set(gca,'xticklabel',xx');
            ylabel('Actual Class');
            set(gca,'yticklabel',xx');
            title(name)
            VarName2=0;
            
        otherwise
            warning('Invalid input');
    end
    i=i-1;
end






end