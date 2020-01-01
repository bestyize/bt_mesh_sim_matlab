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
DEFAULT_RANGE=10;
DEFAULT_PACKET_SIZE=31;
DEFAULT_CACHE_SIZE=1000;
DEFAULT_RRD=20;
DEFAULT_RELAY_PROBABILITY=1;


%全局变量区%
global SYSTEM_CLOCK;
global eventList;
global LIST_OF_NODES;
global MAX_SIM_TIME;%最大仿真时间%

%全局变量初始化%
SYSTEM_CLOCK=0;
initEvent=Event(-1,"EVT_SYS_START","1");
eventList=EventList(initEvent);
nodeMap=TopoHelper.loadTopology();
initPosition=Position(nodeMap([1],[1]),nodeMap([2],[1]));
initNode=Node(1,initPosition);
LIST_OF_NODES=[initNode];
MAX_SIM_TIME=10000;

msg="系统仿真开始"
%系统启动%
systemStart();
msg="仿真完成！"

function systemStart()
    global SYSTEM_CLOCK;
    global eventList;
    global LIST_OF_NODES;
    global MAX_SIM_TIME;%最大仿真时间%
    
    srcId=24;
    dstId=152;
    packetNum=1;
    packetRate=10;
    drawSrcAndDst(srcId,dstId);
    
    
    %读取节点拓扑%
    buildNodeList();
    
    
    %从节点18，发送1个包给节点142，发包速率是10p/s%
    eventList=eventList.addEventFromList(packetSendEventHelper(srcId,dstId,packetNum,packetRate));
    %eventList.printEventList();
    [~,eventListSize]=size(eventList.theList);
    while SYSTEM_CLOCK<MAX_SIM_TIME&&(eventListSize)>1
        SYSTEM_CLOCK=eventList.getFirstEventStartTime();
        eventList=eventList.addEventFromList(eventList.processFirstEvent());
        [~,eventListSize]=size(eventList.theList);
    end
    
end

function buildNodeList()
    global LIST_OF_NODES;
    nodeMap=TopoHelper.loadTopology();
    [~,nodeCount]=size(nodeMap);
    for i=2:1:nodeCount %遍历二维数组每一列%
        position=Position(nodeMap([1],[i]),nodeMap([2],[i]));
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
    newEvents=[packetSendEventRegister(srcId,dstId,1,firstTimeToSend)];
    for i=2:1:num
        timeToAdv=SYSTEM_CLOCK+Helper.getRandomRelayDelay()+addedTime;
        newEvents(i)=packetSendEventRegister(srcId,dstId,i,timeToAdv);
        addedTime=timeToAdv+advInterval;%基础时间再加一下%
    end
end


%设置某个数据包事件的时间、地点、目的地、序列号，顺便把数据包放在源节点的待发送队列里面%
function [event]=packetSendEventRegister(srcId,dstId,seq,time)
    packet=Packet(srcId,dstId,seq);
    event=Event(time,"EVT_ADV_START",num2str(srcId));
    event.setAdvRecvPayload(packet);
     global LIST_OF_NODES;
     [~,queueSize]=size(LIST_OF_NODES(srcId).queue);
     LIST_OF_NODES(srcId).queue(queueSize+1)=packet;
%      LIST_OF_NODES(srcId).queue.add(packet);
end

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





