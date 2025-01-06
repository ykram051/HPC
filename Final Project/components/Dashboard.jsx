import React, { useState, useEffect } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, BarChart, Bar, PieChart, Pie, Cell } from 'recharts';
import { Clock, Cpu, Activity, Users, Server, Calendar } from 'lucide-react';

const Dashboard = ({ selectedUser, data }) => {
  const [metrics, setMetrics] = useState({
    totalCPUHours: 0,
    totalGPUHours: 0,
    jobCount: 0,
    avgWaitTime: 0,
    peakUsage: 0,
    efficiency: 0
  });

  // Colors for charts
  const COLORS = ['#004aad', '#0080ff', '#00bfff', '#00ffff'];

  useEffect(() => {
    if (data && selectedUser) {
      const userData = data.filter(d => d.User === selectedUser);
      
      // Calculate metrics
      const totalCPU = userData.reduce((acc, curr) => acc + curr['CPU_Time(Hours)'], 0);
      const totalGPU = userData.reduce((acc, curr) => acc + curr['GPU_Time(Hours)'], 0);
      const jobCount = userData.length;
      const avgWait = userData.reduce((acc, curr) => acc + curr.WaitTime, 0) / jobCount;
      const peak = Math.max(...userData.map(d => d['CPU_Time(Hours)']));
      const efficiency = (totalCPU / (totalCPU + avgWait)) * 100;

      setMetrics({
        totalCPUHours: totalCPU.toFixed(2),
        totalGPUHours: totalGPU.toFixed(2),
        jobCount,
        avgWaitTime: avgWait.toFixed(2),
        peakUsage: peak.toFixed(2),
        efficiency: efficiency.toFixed(2)
      });
    }
  }, [selectedUser, data]);

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 p-6">
      {/* Metric Cards */}
      <div className="bg-white rounded-xl p-6 shadow-lg">
        <div className="flex items-center space-x-4">
          <Cpu className="w-8 h-8 text-blue-600" />
          <div>
            <h3 className="text-gray-500 text-sm">Total CPU Hours</h3>
            <p className="text-2xl font-bold text-gray-900">{metrics.totalCPUHours}</p>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-xl p-6 shadow-lg">
        <div className="flex items-center space-x-4">
          <Server className="w-8 h-8 text-green-600" />
          <div>
            <h3 className="text-gray-500 text-sm">Total GPU Hours</h3>
            <p className="text-2xl font-bold text-gray-900">{metrics.totalGPUHours}</p>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-xl p-6 shadow-lg">
        <div className="flex items-center space-x-4">
          <Activity className="w-8 h-8 text-purple-600" />
          <div>
            <h3 className="text-gray-500 text-sm">Resource Efficiency</h3>
            <p className="text-2xl font-bold text-gray-900">{metrics.efficiency}%</p>
          </div>
        </div>
      </div>

      {/* Usage Distribution Chart */}
      <div className="bg-white rounded-xl p-6 shadow-lg col-span-1 md:col-span-2">
        <h3 className="text-lg font-semibold mb-4">Resource Usage Distribution</h3>
        <ResponsiveContainer width="100%" height={300}>
          <PieChart>
            <Pie
              data={[
                { name: 'CPU Time', value: parseFloat(metrics.totalCPUHours) },
                { name: 'GPU Time', value: parseFloat(metrics.totalGPUHours) }
              ]}
              cx="50%"
              cy="50%"
              innerRadius={60}
              outerRadius={100}
              paddingAngle={5}
              dataKey="value"
            >
              {COLORS.map((color, index) => (
                <Cell key={`cell-${index}`} fill={color} />
              ))}
            </Pie>
            <Tooltip />
            <Legend />
          </PieChart>
        </ResponsiveContainer>
      </div>

      {/* Usage Timeline */}
      <div className="bg-white rounded-xl p-6 shadow-lg col-span-1 md:col-span-3">
        <h3 className="text-lg font-semibold mb-4">Resource Usage Timeline</h3>
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={data.filter(d => d.User === selectedUser)}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="StartTime" />
            <YAxis />
            <Tooltip />
            <Legend />
            <Line type="monotone" dataKey="CPU_Time(Hours)" stroke="#004aad" name="CPU Usage" />
            <Line type="monotone" dataKey="GPU_Time(Hours)" stroke="#0080ff" name="GPU Usage" />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* Job Statistics */}
      <div className="bg-white rounded-xl p-6 shadow-lg col-span-1 md:col-span-3">
        <h3 className="text-lg font-semibold mb-4">Job Statistics</h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-gray-50 rounded-lg p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500">Total Jobs</p>
                <p className="text-2xl font-bold">{metrics.jobCount}</p>
              </div>
              <Users className="w-8 h-8 text-blue-600" />
            </div>
          </div>
          <div className="bg-gray-50 rounded-lg p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500">Avg Wait Time</p>
                <p className="text-2xl font-bold">{metrics.avgWaitTime}h</p>
              </div>
              <Clock className="w-8 h-8 text-yellow-600" />
            </div>
          </div>
          <div className="bg-gray-50 rounded-lg p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500">Peak Usage</p>
                <p className="text-2xl font-bold">{metrics.peakUsage}h</p>
              </div>
              <Activity className="w-8 h-8 text-green-600" />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;