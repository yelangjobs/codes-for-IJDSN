% clc,clear
Nc = 10; % 其中90个通信节点，随机选择10个感知节点；
[E,posSensor,SenNode] = getConnectivitySparse(Nc);
posSenNode = posSensor(:,SenNode); % 感知节点的位置；
posComNode = posSensor;
posComNode(:,SenNode) = [];  % 去掉感知节点的位置,剩下通信节点的位置；

figure
hold on;
for i = 1:Nc-1
    for j = i+1:Nc
        if E(i,j)
            plot(posSensor(1,[i,j]),posSensor(2,[i,j]),'b-');
        end
    end
end

plot(posSenNode(1,:),posSenNode(2,:),'^','MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[0,0,0]);
plot(posComNode(1,:),posComNode(2,:),'sk');
h1 = plot(-5000,-5000,'^','MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[0,0,0]);
h2 = plot(-5000,-5000,'sk');
h3 = plot([-5000,-6000],[-5000,-6000],'b-');
axis([-4000,4000,-4000,4000]);
legend([h1,h2,h3],'Sensor Nodes','Communication Nodes','Communication Link');