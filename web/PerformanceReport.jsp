<%@ page import="entity.ReportSummary" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
ReportSummary s = (ReportSummary) request.getAttribute("summary");
DecimalFormat df = new DecimalFormat("#,###");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Performance Overview</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            margin-top: 50px;
            max-width: 800px;
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }
        thead {
            background-color: #212529;
            color: white;
        }
        th, td {
            text-align: center;
            padding: 15px;
            font-size: 16px;
        }
        th {
            font-weight: 600;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .badge {
            font-size: 14px;
            padding: 8px 12px;
            border-radius: 8px;
        }
        .revenue {
            color: #198754;
            font-weight: bold;
        }
        .card {
            border-radius: 12px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>System Performance Overview</h2>

    <table class="table table-bordered text-center align-middle">
        <thead>
            <tr>
                <th><b>Metric</b></th>
                <th><b>Value</b></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Total Contracts</td>
                <td><span class="badge bg-primary"><%= s.getTotalContracts() %></span></td>
            </tr>
            <tr>
                <td>Total Revenue</td>
                <td class="revenue"><%= df.format(s.getTotalRevenue()) %>₫</td>
            </tr>
            <tr>
                <td>Active Contracts</td>
                <td><span class="badge bg-success"><%= s.getActiveContracts() %></span></td>
            </tr>
            <tr>
                <td>Total Customers</td>
                <td><span class="badge bg-info text-dark"><%= s.getTotalCustomers() %></span></td>
            </tr>
            <tr>
                <td>Paid Commissions</td>
                <td><span class="badge bg-warning text-dark"><%= df.format(s.getPaidCommission()) %></span></td>
            </tr>
        </tbody>
    </table>

    <div class="text-center mt-4">
        <a href="AdminDashboard.jsp" class="btn btn-secondary">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
