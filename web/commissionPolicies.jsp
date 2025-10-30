<%-- 
    Document   : commissionPolicies
    Created on : Oct 25, 2025, 4:44:48 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    Map<Integer, List<CommissionPolicy>> productPolicies =
   (Map<Integer, List<CommissionPolicy>>) request.getAttribute("productPolicies");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Commission Policies</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
        <style>
            h2 {
                color: var(--primary);
                font-weight: 600;
            }
            ul {
                margin-top: 0.5rem;
            }
        </style>
    </head>

    <body>

        <%@ include file="manager_navbar.jsp" %>
        <%@ include file="manager_sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h2 class="mb-4">Commission Policies</h2>

                <% if (productList != null && !productList.isEmpty()) { 
                    for (Product product : productList) { 
                        List<CommissionPolicy> policies = (productPolicies != null)
                            ? productPolicies.get(product.getProductId())
                            : null;
                %>
                <div class="card mb-4 shadow-sm border-0 rounded-3">
                    <div class="card-body">
                        <h4 class="card-title text-primary"><%= product.getProductName() %></h4>

                        <% if (policies != null && !policies.isEmpty()) { %>
                        <ul class="mt-3">
                            <% for (CommissionPolicy policy : policies) { %>
                            <li>
                                <strong><%= policy.getPolicyName() %></strong>
                                (<%= policy.getRateType() %>, <%= policy.getRate() %>%)
                                <br>
                                Hiệu lực: <%= policy.getEffectiveFrom() %>
                                <% if (policy.getEffectiveTo() != null) { %>
                                → <%= policy.getEffectiveTo() %>
                                <% } %>
                            </li>
                            <% } %>
                        </ul>
                        <% } else { %>
                        <p class="text-muted">Không có chính sách hoa hồng áp dụng cho sản phẩm này.</p>
                        <% } %>
                    </div>
                </div>
                <% 
                    } // end for
                } else { 
                %>
                <p class="text-muted text-center mt-4">
                    ❌ Không có sản phẩm nào để hiển thị chính sách hoa hồng.
                </p>
                <% } %>
            </div>
        </div>

        <footer class="main-footer text-center py-3">
            <small>© 2025 Insurance Agent System</small>
        </footer>

    </body>
</html>



