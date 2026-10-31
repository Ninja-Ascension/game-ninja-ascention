
RestrainMould = class("RestrainMould")

function RestrainMould:ctor()
    --类型
    self.camp =  0

    --相克类型
    self.restrainCamp =  0

    --相克属性
    self.restrainAddition =  ""

end


local obj = RestrainMould:new()