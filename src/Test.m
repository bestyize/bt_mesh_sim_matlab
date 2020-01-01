% matrix=TopoHelper.createTopologyMatrix(200,100,100);
% plot(matrix([1],:),matrix([2],:),"r.")
myMap=TopoHelper.loadTopology();
r=10;
[~,nodeCount]=size(myMap);
for i=1:nodeCount
    x=myMap([1],i)
    y=myMap([2],i)
    plot(x,y,"r.")
    text(x,y,num2str(i))
    if i==18||i==157
         rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','b')
     end
    hold on;
end






% num=200;
% r=15;
% for i=1:1:num
%     a=[rand()*(100-r),rand()*(100-r)];
%     plot(a(1),a(2),'r.')
%     text(a(1),a(2),num2str(i),'FontSize',6)
% %     plotRound(a(1),a(2),15);
%     if i==10||i==77
%         rectangle('Position',[a(1)-r,a(2)-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','b')
%     end
%     
%     hold on
% end
% xlabel("X");
% ylabel("Y");
% grid on
% 
% function plotRound(xx,yy,r)
%     theta=0:pi/100:2*pi;
%     x=r*cos(theta);
%     y=r*sin(thata);
%     plot(x,y,'r.')
% %     hold on
% end