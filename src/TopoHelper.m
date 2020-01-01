classdef TopoHelper < handle
    methods(Static)
        function posMatrix=createTopologyMatrix(num,maxX,maxY)
            initpos=[round(rand()*maxX);round(rand()*maxY)];
            poisitionMatrix=[initpos];
            for i=2:1:num
                pos=[round(rand()*maxX);round(rand()*maxY)];
                poisitionMatrix=[poisitionMatrix,pos];
            end
            posMatrix=poisitionMatrix;
        end
        
        function [result]=loadTopology()
            load("topology_matrix.mat",'-mat');
            result=matrix;
        end
    end
end

