classdef Helper
    methods(Static)
        function [rrd] = getRandomRelayDelay()
            global DEFAULT_RRD;
            rrd=round(rand()*DEFAULT_RRD);
        end
        %����ǲ����ھӽڵ�%
        function result = checkIsNeighbor(pos1,pos2)
            global DEFAULT_RANGE;
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
%             x_change=(pos1.x-pos2.x)*(pos1.x-pos2.x);
%             y_change=(pos1.y-pos2.y)*(pos1.y-pos2.y);
            result=(sqrt(power(pos1.x-pos2.x,2)+power(pos1.y-pos2.y,2))<DEFAULT_RANGE);
        end
    end
end


