classdef TopoHelper < handle
    methods(Static)
        function posMatrix=createTopologyMatrix(num,maxX,maxY)
            global DEFAULT_RANGE;
            initpos=[round(rand()*maxX);round(rand()*maxY)];
            poisitionMatrix=[initpos];
            for i=2:1:num
                pos=[round((DEFAULT_RANGE+rand()*(maxX-2*DEFAULT_RANGE)));round((DEFAULT_RANGE+rand()*(maxY-2*DEFAULT_RANGE)))];
                poisitionMatrix=[poisitionMatrix,pos];
            end
            posMatrix=poisitionMatrix;
        end
        
        function [result]=loadTopology()
            load("matrix_100_nodes.mat",'-mat');
            result=matrix_100_nodes;
        end
    end
end

