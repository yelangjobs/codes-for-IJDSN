
%% 传感器节点随机分布在[-4000m, 4000m]×[-4000m, 4000m]的矩形区域内，节点的通信半径设置为$R=1600$;
function [E,posSensor,SenNode] = getConnectivitySparse(Nc)
    
    % 设置通信链接
    while 1

        % 每次需重新生成节点位置，若放在循环外面，不满足要求的网络由于节点位置没有发生改变，
        % 永远不满足要求，从而造成循环编程死循环，无法得到想要的结果；
        E = zeros(Nc);
        posSensor = -4000 + 8000 * rand(2,Nc);

        for i = 1:Nc-1
            for j = i+1:Nc
                d = norm(posSensor(:,j) - posSensor(:,i));
                if  d < 3400
                    E(i,j) = 1;
                end
            end
        end
        E = E + E';

        if any(sum(E) == 0) % 如果存在独立节点，即网络不连通，则重新生成网络；
            continue;
        else
            break;
        end
    end

    % 显示传感器节点及彼此之间的通信关系；
    SenNode = randperm(Nc,4); % 随机选择10个节点作为感知节点；
%     posSenNode = posSensor(:,SenNode); % 感知节点的位置；
%     
%     posComNode = posSensor;
%     posComNode(:,SenNode) = [];  % 去掉感知节点的位置,剩下通信节点的位置；
%     
%     
%     figure
%     hold on;    
%     for i = 1:Nc-1
%         for j = i+1:Nc
%             if E(i,j)
%                 plot(posSensor(1,[i,j]),posSensor(2,[i,j]),'b-');
%             end
%         end
%     end
%     
%     plot(posSenNode(1,:),posSenNode(2,:),'^','MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[0,0,0]);
%     plot(posComNode(1,:),posComNode(2,:),'sk');
end



