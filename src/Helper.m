classdef Helper
    methods(Static)
        function [rrd] = getRandomRelayDelay()
            global DEFAULT_RRD;
            rrd=round(rand()*DEFAULT_RRD);
        end
        %检查是不是邻居节点%
        function result = checkIsNeighbor(pos1,pos2)
            global DEFAULT_RANGE;
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
%             x_change=(pos1.x-pos2.x)*(pos1.x-pos2.x);
%             y_change=(pos1.y-pos2.y)*(pos1.y-pos2.y);
            result=(sqrt(power(pos1.x-pos2.x,2)+power(pos1.y-pos2.y,2))<DEFAULT_RANGE);
        end
    end
end


