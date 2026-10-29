-- ----------------------------------------------------------------------------------------------------
-- 寻路
-- ----------------------------------------------------------------------------------------------------
Pathfindding = class("Pathfindding")

-- 单节点数据结构
-- local city_node = {
--     "id" = 10,
--     "near_node" = {
--         [20] = 10 ,            -- 临近节点id = 边的权重
--         [30] = 10 ,
--     },
--     "node_parent" = 0
--     "cost" = 0 or 10000                -- 点的权重
--     "camp" = 1
--     "flag" = false
-- }

-- 寻路所需数据
-- self.city_path_info = {
--     [id] = city_node
-- }

-- 返回结果数据结构
-- local result = {1，5, 20, 30, 50}  -- 返回一个节点数组 最后一个是end_node 没有start_node

function Pathfindding:ctor()
    self.city_path_info = {}
    self.camp = 0
end

-- 得到可以移动的点 
function Pathfindding:getNextPoints(curPoint)  
    return curPoint.near_node
end

-- 得到路径
function Pathfindding:makePath(camp, start_node, end_node, isPlayer)
    local _result = {}
    local _list_camp_city_id = {}

    self.camp = camp
    -- 过滤其它阵营城池id号
    local can_move = false
    if isPlayer then
        local city_num = dms.count(dms["warfare_map_mould"])

        -- 是否可以移动到目的地
        local border_city = dms.string(dms["warfare_map_mould"],end_node,warfare_map_mould.border_city)
        border_city = zstring.split(border_city,",")

        local my_camp = camp
        for i,v in pairs(border_city) do
            if my_camp == tonumber(_ED.warfareCityInfo[tonumber(v)].camp) then
                can_move = true
            end
        end

        -- 如果不能移动判断返回nil
        if not can_move then
            return _result
        end

        for i = 1, city_num do
            table.insert(_list_camp_city_id ,_ED.warfareCityInfo[i].city_id) -- 本国城池列表id
        end

        self:pathNodeDataCreate(_list_camp_city_id)

    -- 暂时不用
    else
        for i = 1, 76 do
            table.insert(_list_camp_city_id ,_ED.warfareCityInfo[i].city_id) -- 本国城池列表id
        end
        can_move = true
        self:pathNodeDataCreate(_list_camp_city_id)

        if not can_move then
            return _result
        end
    end

    -- 终点权值修改
    self.city_path_info[end_node].camp = self.camp

    -- parent索引路径 顺序 start_node第一个目的 到最后 end_node
    if self:excute(start_node, end_node) then
        table.insert(_result, 1, end_node)

        local node_parent = self.city_path_info[end_node].node_parent

        while node_parent ~= start_node do
            table.insert(_result, 1, node_parent)
            node_parent = self.city_path_info[node_parent].node_parent 
        end
    end

    -- for k,v in pairs(_result) do
    --     print("_result---------------",v)
    -- end

    return _result
end

-- 生成路径节点数据
function Pathfindding:pathNodeDataCreate(list_id)
    local edge_cost = 10
    local node_cost = 100000
    for i,v in pairs(list_id) do

        local city_node = {}
        -- 城池id
        city_node.id = v

        -- 临近城池节点
        city_node.near_node = {}

        -- 路径根节点
        city_node.node_parent = 0

        -- 节点权重
        city_node.cost = 100000

        -- 节点阵营
        city_node.camp = tonumber(dms.int(dms["warfare_map_mould"], i, warfare_map_mould.city_camp))

        -- 标志位(是否查询过)
        city_node.flag = false

        local table_near_city_id = zstring.split(dms.string(dms["warfare_map_mould"], v , warfare_map_mould.border_city), ",")

        for i=1, #table_near_city_id do
            city_node.near_node[tonumber(table_near_city_id[i])] = edge_cost
        end
        self.city_path_info[v] = city_node
    end
end  

-- 得到路径table
function Pathfindding:getAllCityPathInfo()
    return self.city_path_info
end

-- 路径查找执行函数
function Pathfindding:excute(start_node , end_node )
    -- 得到所有的点
    local all_nodes = self:getAllCityPathInfo()

    -- 保存路径队列
    local quene_path_nodes = {}

    -- start_node初始化
    all_nodes[start_node].cost = 0
    all_nodes[start_node].flag = true

    -- 顶点入列
    table.insert(quene_path_nodes , all_nodes[start_node])

    -- 循环寻找
    while #quene_path_nodes do
        local min_node = self:extractMin(quene_path_nodes)
        min_node.flag = false

        -- 如果找到终点
        if min_node.id == end_node then
            return true
        end

        -- 如果最小的点是地方阵营
        if min_node.cost > 1000 then
            return false
        end

        local next_node_list = self:getNextPoints(min_node)
        for i,v in pairs(next_node_list) do
            local bool_return = false
            if all_nodes[i] then 
                bool_return = self:relax (min_node, all_nodes[i] , v)
            end
            if bool_return and all_nodes[i].flag == false then
                table.insert(quene_path_nodes, all_nodes[i])
            end
        end
    end
end

-- 算出最小路径估计的顶点
function Pathfindding:extractMin(quene_path_nodes)
    local min_node = {}
    min_node = quene_path_nodes[1]
    local pos = 1
    for i = 1 , #quene_path_nodes do
        if min_node.cost > quene_path_nodes[i].cost then
            min_node = quene_path_nodes[i]
            pos = i
        end
    end
    -- print("******min_node*********",min_node.id, min_node.cost)
    table.remove(quene_path_nodes, pos)
    return min_node
end

-- 算法松弛函数
function Pathfindding:relax(node1, node2, edge_cost)
    -- print("node2()000000000000",node2.id, node2.cost)
    local n = 0
    if  self.camp ~= node2.camp then
        n = node1.cost + edge_cost * 100
    else
        n = node1.cost + edge_cost
    end

    if  n < node2.cost then
        -- 更新路径代价
        node2.cost = n ;
        -- 更新路径
        node2.node_parent = node1.id
        return true
    end
    return false
 end 

return Pathfindding