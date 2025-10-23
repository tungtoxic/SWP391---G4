<%@ page import="model.ReportSummary" %>
<%
ReportSummary s = (ReportSummary) request.getAttribute("summary");
%>
<h2>System Performance Overview</h2>
<table border="1" cellpadding="8">
<tr><th>Total Contracts</th><td><%= s.getTotalContracts() %></td></tr>
<tr><th>Total Revenue</th><td><%= s.getTotalRevenue() %></td></tr>
<tr><th>Active Contracts</th><td><%= s.getActiveContracts() %></td></tr>
<tr><th>Total Customers</th><td><%= s.getTotalCustomers() %></td></tr>
<tr><th>Paid Commissions</th><td><%= s.getPaidCommission() %></td></tr>
</table>
