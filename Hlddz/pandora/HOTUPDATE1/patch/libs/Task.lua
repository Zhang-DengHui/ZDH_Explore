Task = {}
TaskQueue = {}
local Task = Task
local TaskQueue = TaskQueue

function Task.new(...)
    local t = {}
    setmetatable(t, { __index = Task })
    t:ctor(...)
    return t
end

function Task:ctor(callback)
    self.callback = callback
end

function Task:complete()
    if self.callback then
        self.callback()
    end
end

function TaskQueue.new(...)
    local t = {}
    setmetatable(t, { __index = TaskQueue })
    t:ctor(...)
    return t
end

function TaskQueue:ctor()
    self.list = {}
    self.index = 1
end

function TaskQueue:create()
    local task = Task.new()
    table.insert(self.list, task)
    return task
end

function TaskQueue:run(callback)
    self.len = #self.list
    self.callback = callback
    self:exec()
end

function TaskQueue:exec()
    if self.index <= self.len then
        local task = self.list[self.index]
        self.index = self.index + 1
        task.callback = function() 
            self:exec() 
        end
        task:run()
    else
        if self.callback then
            self.callback()
        end
    end
end
