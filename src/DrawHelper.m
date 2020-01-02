classdef DrawHelper
    methods(Static)
        %绘制源节点和目标节点图%
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
            title("源节点和目的节点示意")
        end
    end
    
end

