target=[1,1,1,0,0,0,0,0,0;0,0,0,1,1,1,0,0,0;0,0,0,0,0,0,1,1,1];
output=[0,1,1,0,0,0,0,0,0;1,0,0,1,1,1,0,0,0;0,0,0,0,0,0,1,1,1];
 plotconfusion(target,output);
[c,cm,ind,per]=confusion(target,output);
