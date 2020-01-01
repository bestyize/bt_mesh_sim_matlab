classdef Test2
    methods
        function obj=Test2()
            
        end
        function test(obj)
            global SYSTEM_CLOCK;
            SYSTEM_CLOCK=SYSTEM_CLOCK+1;
            SYSTEM_CLOCK
        end
    end
end
