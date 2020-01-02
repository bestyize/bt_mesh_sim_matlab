classdef DrawHelper
    methods(Static)
        %����Դ�ڵ��Ŀ��ڵ�ͼ%
        function drawSrcAndDst(srcId,dstId)
            myMap=TopoHelper.loadTopology();
            global DEFAULT_RANGE;
            r=DEFAULT_RANGE;
            [~,nodeCount]=size(myMap);
            for i=1:nodeCount
                x=myMap([1],i);
                y=myMap([2],i);
                plot(x,y,"r.")
                text(x,y,num2str(i))
                if i==srcId||i==dstId
                     rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','b')
                 end
                hold on;
            end
            title("Դ�ڵ��Ŀ�Ľڵ�ʾ��")
        end
    end
    
end

