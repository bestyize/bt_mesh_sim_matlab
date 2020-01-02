clear
clc
%默认配置区%
global DEFAULT_TTL;
global DEFAULT_TTL_BACKOFF;
global DEFAULT_RANGE;
global DEFAULT_PACKET_SIZE;
global DEFAULT_CACHE_SIZE;
global DEFAULT_RRD;
global DEFAULT_RELAY_PROBABILITY;

DEFAULT_TTL=127;
DEFAULT_TTL_BACKOFF=0;
DEFAULT_RANGE=15;%默认传输距离，最好不要在这里直接定义，为了加快速度，在Helper里面直接给一个值%
DEFAULT_PACKET_SIZE=31;
DEFAULT_CACHE_SIZE=1000;
DEFAULT_RRD=20;
DEFAULT_RELAY_PROBABILITY=1.0;


%全局变量区%
global SYSTEM_CLOCK;
global eventList;
global LIST_OF_NODES;
global MAX_SIM_TIME;%最大仿真时间%

%全局变量初始化%
SYSTEM_CLOCK=0;
initEvent=Event(-1,"EVT_SYS_START",1);
eventList=EventList(initEvent);
nodeMap=TopoHelper.loadTopology();
initPosition=Position(nodeMap(1,1),nodeMap(2,1));
initNode=Node(1.0,initPosition);
LIST_OF_NODES=initNode;
MAX_SIM_TIME=60000;
tic
msg="系统仿真开始"
%系统启动%
systemStart();
printAvgNodeDegree()
msg="仿真完成！模拟时间："+SYSTEM_CLOCK/1000+"s 程序运行时间："+toc+"s"

function systemStart()
    global SYSTEM_CLOCK;
    global eventList;
    global MAX_SIM_TIME;%最大仿真时间%
    
    srcId=41;
    dstId=35;
    packetNum=200;
    packetRate=20;

    %读取节点拓扑%
    buildNodeList();
    buildNeighborForEachNode();
    
    %从节点srcId，发送packetNum个包给节点dstId，发包速率是每秒packetRate个包%
    eventList=eventList.addEventFromList(packetSendEventHelper(srcId,dstId,packetNum,packetRate));
    %eventList.printEventList();%打印当前事件列表%
    [~,eventListSize]=size(eventList.theList);
    while SYSTEM_CLOCK<MAX_SIM_TIME&&(eventListSize)>1
        SYSTEM_CLOCK=eventList.getFirstEventStartTime();
        %eventList=eventList.addEventFromList(eventList.processFirstEvent());
        eventList=eventList.addEventFromListOfSameTime(eventList.processFirstEvent());
        [~,eventListSize]=size(eventList.theList);
    end
    
    DrawHelper.drawSrcAndDst(srcId,dstId);
    
end

function buildNodeList()
    global LIST_OF_NODES;
    nodeMap=TopoHelper.loadTopology();
    [~,nodeCount]=size(nodeMap);
    for i=2:1:nodeCount %遍历二维数组每一列%   
        position=Position(nodeMap(1,i),nodeMap(2,i));
        LIST_OF_NODES(numel(LIST_OF_NODES)+1)=Node(i,position);
    end
end


%把所有要发送的数据包事件都注册在这里%
function [newEvents]=packetSendEventHelper(srcId,dstId,num,rate)
    if rate>50
        "速率超过允许范围"
    end
    global SYSTEM_CLOCK;
    firstTimeToSend=10+SYSTEM_CLOCK;%第10ms开始发送第一个数据包%
    advInterval=1000/rate;%计算广播间隔%
    addedTime=10;%累积的发送时间%
    %注册第一个数据包发送事件，为了让newEvens是一个事件链表而不是数值链表，只能先在这里注册了%
    newEvents=packetSendEventRegister(srcId,dstId,1,firstTimeToSend);
    for i=2:1:num
        timeToAdv=SYSTEM_CLOCK+Helper.getRandomRelayDelay()+addedTime;
        newEvents(i)=packetSendEventRegister(srcId,dstId,i,timeToAdv);
        addedTime=timeToAdv+advInterval;%基础时间再加一下%
    end
end


%设置某个数据包事件的时间、地点、目的地、序列号，顺便把数据包放在源节点的待发送队列里面%
function [event]=packetSendEventRegister(srcId,dstId,seq,time)
    packet=Packet(srcId,dstId,seq);
    event=Event(time,"EVT_ADV_START",srcId);
    event.setAdvRecvPayload(packet);
     global LIST_OF_NODES;
     [~,queueSize]=size(LIST_OF_NODES(srcId).queue);
     LIST_OF_NODES(srcId).queue(queueSize+1)=packet;
%      LIST_OF_NODES(srcId).queue.add(packet);
end

%为每个节点建立邻居列表%
function buildNeighborForEachNode()
    global LIST_OF_NODES;
    for i=1:numel(LIST_OF_NODES)
        LIST_OF_NODES(i).buildNeighborList();
    end
end


function printAvgNodeDegree()
    count=0;
    global LIST_OF_NODES;
    for i=1:numel(LIST_OF_NODES)
        for j=1:numel(LIST_OF_NODES)
            if((i~=j)&&(Helper.checkIsNeighbor(LIST_OF_NODES(i).position,LIST_OF_NODES(j).position)))
                count=count+1;
            end
        end
    end
    "平均节点度："+(count/numel(LIST_OF_NODES))
    
end






