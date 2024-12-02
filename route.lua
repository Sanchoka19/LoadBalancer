local http = require "resty.http"

-- Use Docker container names
local prometheus_app1 = "http://192.168.100.10:8182/metrics" -- you have to insert host ip
local prometheus_app2 = "http://192.168.100.10:8283/metrics"
local prometheus_app3 = "http://192.168.100.10:8384/metrics"

-- Define static weights
local weight1 = 2  -- Weight for app1 (stronger server)
local weight2 = 2  -- Weight for app2 (weaker server)
local weight3 = 1  -- Weight for app3 (lowest weight)

local function fetch_metrics(url)
    local httpc = http.new()
    local res, err = httpc:request_uri(url, {
        method = "GET",
    })

    if not res then
        ngx.log(ngx.ERR, "Failed to request: ", err)
        return nil
    end

    return res.body
end

local function get_cpu_ram_usage(metrics)
    local cpu_usage, ram_usage = nil, nil

    for line in metrics:gmatch("[^\r\n]+") do
        if line:find("process_cpu_seconds_total") then
            cpu_usage = tonumber(line:match("(%d+%.%d+)"))
        elseif line:find("process_resident_memory_bytes") then
            ram_usage = tonumber(line:match("(%d+)"))
        end
    end

    return cpu_usage, ram_usage
end

local metrics_app1 = fetch_metrics(prometheus_app1)
local metrics_app2 = fetch_metrics(prometheus_app2)
local metrics_app3 = fetch_metrics(prometheus_app3)

if metrics_app1 and metrics_app2 and metrics_app3 then
    local cpu1, ram1 = get_cpu_ram_usage(metrics_app1)
    local cpu2, ram2 = get_cpu_ram_usage(metrics_app2)
    local cpu3, ram3 = get_cpu_ram_usage(metrics_app3)

    if ram1 and ram2 and ram3 and cpu1 and cpu2 and cpu3 then
        -- Select target based on static weights
        local total_weight = weight1 + weight2 + weight3
        local random_choice = math.random() * total_weight

        if random_choice < weight1 then
            ngx.var.target = "http://192.168.100.10:8181"  -- Target for app1
        elseif random_choice < weight1 + weight2 then
            ngx.var.target = "http://192.168.100.10:8282"  -- Target for app2
        else
            ngx.var.target = "http://192.168.100.10:8382"  -- Target for app3
        end
    else
        ngx.log(ngx.ERR, "Failed to parse metrics")
        ngx.exit(500)
    end
else
    ngx.log(ngx.ERR, "Failed to fetch metrics")
    ngx.exit(500)
end

ngx.exit(200)
